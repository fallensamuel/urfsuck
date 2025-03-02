-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\meta\\quest_type_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_quest_type = rp.seasonpass.Meta._meta_quest_type

function _meta_quest_type:AddDataValidation(callback)
	self.Validator = callback
	return self
end

function _meta_quest_type:AddAccessValidation(callback)
	self.AccessValidator = callback
	return self
end

function _meta_quest_type:AddHook(hookname, player_param_id, callback)
	self.Hooks = self.Hooks or {}

	timer.Simple(5, function()
		--if not rp.seasonpass.GetSeason() then return end

		self.Hooks[hookname] = {
			hookname = hookname,
			callback = callback,
			player_param = player_param_id,
		}
	end)

	return self
end

function _meta_quest_type:OnInit(callback)
	self.OnInitCallback = callback
	return self
end

function _meta_quest_type:OnBegin(callback)
	self.OnBeginCallback = callback
	return self
end

function _meta_quest_type:OnEnd(callback)
	self.OnEndCallback = callback
	return self
end

function _meta_quest_type:OnFakeProgress(callback)
	self.FakeProgress = callback
	return self
end

function _meta_quest_type:SetListenCLPlayerSpawn(status)
	self.ListenCLPlayerSpawn = status
	return self
end

function rp.seasonpass.AddQuestType(quest_type_uid, quest_data)
	if rp.seasonpass.QuestsTypesMap[quest_type_uid] then return setmetatable({}, _meta_quest_type) end

	local t = {
		UID = quest_type_uid,
		PlayerCounter = 0,
	}

	t.ID = table.insert(rp.seasonpass.QuestsTypes, t)
	rp.seasonpass.QuestsTypesMap[quest_type_uid] = t

	setmetatable(t, _meta_quest_type)
	return t
end


--[[ Стандартные типажи заданий ]]--
rp.seasonpass.AddQuestType("like")
	:AddHook('LikeReactSystem::Add', 1, function(quest, quest_data, reactor, target)
		return true
	end)

rp.seasonpass.AddQuestType("work_on_factory")
	:AddHook('Factory::CombinedItem', 1, function(quest, quest_data, ply, item_id)
		return true
	end)

rp.seasonpass.AddQuestType("hit_complete")
	:AddHook('playerCompletedHit', 1, function(quest, quest_data, ply, victim)
		return true
	end)

rp.seasonpass.AddQuestType("dance")
	:AddHook('EmoteActions::PlayerAnimRun', 1, function(quest, quest_data, ply, actID)
		if ply.NextDance and (ply.NextDance > CurTime()) then return false end
		ply.NextDance = CurTime() + 3

		return not quest_data or not quest_data.dance_uid or (quest_data.dance_uid == actID)
	end)

rp.seasonpass.AddQuestType("team_taken")
	:AddDataValidation(function(quest_data)
		return quest_data.team and true or false
	end)
	:AddHook('OnPlayerChangedTeam', 1, function(quest, quest_data, ply, prevTeam, team)
		return not quest_data or not quest_data.team or (quest_data.team == team)
	end)

rp.seasonpass.AddQuestType("team_taken_any")
	:AddHook('OnPlayerChangedTeam', 1, function(quest, quest_data, ply, prevTeam, team)
		return true
	end)

rp.seasonpass.AddQuestType("team_taken")
	:AddDataValidation(function(quest_data)
		return quest_data.team and true or false
	end)
	:AddHook('OnPlayerChangedTeam', 1, function(quest, quest_data, ply, prevTeam, team)
		return not quest_data or not quest_data.team or (quest_data.team == team)
	end)

rp.seasonpass.AddQuestType("team_played_10_sec")
	:AddDataValidation(function(quest_data)
		return quest_data.team and true or false
	end)
	:OnInit(function(quest_data)
		rp.seasonpass.CheckPlayerJob(quest_data.team, true)
	end)
	:OnBegin(function(ply, quest_data)
		rp.seasonpass.DoTeamFactionCheck(ply)
	end)
	:SetListenCLPlayerSpawn(true)
	:OnFakeProgress(function(quest_data, ply, current_progress, max_progress, last_update)
		if quest_data.team ~= ply:Team() or CurTime() - last_update > 10 then
			return current_progress
		end

		if last_update + (max_progress - current_progress) > CurTime() then
			return current_progress + math.floor(CurTime() - last_update)
		end

		return max_progress
	end)
	:AddHook('Seasonpass::JobPlayed10Seconds', 1, function(quest, quest_data, ply, team)
		return (quest_data.team == team) and 10
	end)

rp.seasonpass.AddQuestType("faction_taken")
	:AddDataValidation(function(quest_data)
		return quest_data.faction and true or false
	end)
	:AddHook('OnPlayerChangedTeam', 1, function(quest, quest_data, ply, faction)
		return not quest_data or not quest_data.faction or (quest_data.faction == ply:GetFaction())
	end)

rp.seasonpass.AddQuestType("factions_taken")
	:AddDataValidation(function(quest_data)
		for k, v in pairs(quest_data.factions) do
			if not k then
				return false
			end
		end

		return true
	end)
	:AddHook('OnPlayerChangedTeam', 1, function(quest, quest_data, ply, faction)
		return quest_data.factions[ply:GetFaction()] or false
	end)

rp.seasonpass.AddQuestType("faction_played_10_sec")
	:AddDataValidation(function(quest_data)
		return quest_data.faction and true or false
	end)
	:OnInit(function(quest_data)
		rp.seasonpass.CheckPlayerFaction(quest_data.faction, true)
	end)
	:OnBegin(function(ply, quest_data)
		rp.seasonpass.DoTeamFactionCheck(ply)
	end)
	:SetListenCLPlayerSpawn(true)
	:OnFakeProgress(function(quest_data, ply, current_progress, max_progress, last_update)
		if quest_data.faction ~= ply:GetFaction() or CurTime() - last_update > 10 then
			return current_progress
		end

		if last_update + (max_progress - current_progress) > CurTime() then
			return current_progress + math.floor(CurTime() - last_update)
		end

		return max_progress
	end)
	:AddHook('Seasonpass::FactionPlayed10Seconds', 1, function(quest, quest_data, ply, faction)
		return (quest_data.faction == ply:GetFaction()) and 10
	end)

rp.seasonpass.AddQuestType("trade_any")
	:AddHook('Vendor::BoughtItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and item_count
	end)
	:AddHook('Vendor::SoldItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and item_count
	end)

rp.seasonpass.AddQuestType("trade_sold")
	:AddHook('Vendor::SoldItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and item_count
	end)

rp.seasonpass.AddQuestType("trade_bought")
	:AddHook('Vendor::BoughtItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and item_count
	end)

rp.seasonpass.AddQuestType("trade_any_price")
	:AddHook('Vendor::BoughtItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and price
	end)
	:AddHook('Vendor::SoldItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and price
	end)

rp.seasonpass.AddQuestType("trade_sold_price")
	:AddHook('Vendor::SoldItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and price
	end)

rp.seasonpass.AddQuestType("trade_bought_price")
	:AddHook('Vendor::BoughtItem', 1, function(quest, quest_data, ply, item_uid, item_count, vendor, price)
		return not quest_data or ((not quest_data.item_uid or quest_data.item_uid == item_uid) and (not quest_data.vendor_name or vendor:GetVendorName() == quest_data.vendor_name)) and price
	end)

rp.seasonpass.AddQuestType("payday_received")
	:AddHook('RP::PayDay', 1, function(quest, quest_data, ply, amount)
		return amount
	end)

rp.seasonpass.AddQuestType("captured_point")
	:AddHook('Capture::PlayerOwnHook', 2, function(quest, quest_data, point, ply)
		return (not quest_data or not quest_data.point_name or (quest_data.point_name == point.printName)) and true or false
	end)

rp.seasonpass.AddQuestType("start_hesit")
	:AddHook('ArmoryHeist::Start', 2, function(quest, quest_data, heist_id, ply)
		return true
	end)
	:AddHook('Heist::Start', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("kill")
	:AddHook('PlayerDeath', 3, function(quest, quest_data, victim, inflictor, ply)
		return true
	end)

rp.seasonpass.AddQuestType("take_loot")
	:AddHook('Inventory.OnMoveItem', 1, function(quest, quest_data, ply, inv_from, inv_entity, item)
		return inv_from.vars and inv_from.vars.isBag and (not quest_data or not quest_data.item_uid or (quest_data.item_uid == item.uniqueID)) and (item.data and item.data.count or 1)
	end)
	:AddHook('Inventory.OnCombineItem', 1, function(quest, quest_data, ply, inv_from, inv_entity, item)
		return inv_from.vars and inv_from.vars.isBag and (not quest_data or not quest_data.item_uid or (quest_data.item_uid == item.uniqueID)) and (item.data and item.data.count or 1)
	end)
	:AddHook('LootableRoulette::Reward', 2, function(quest, quest_data, ent, ply, t, v)
		return t == "invitem" and (not quest_data or not quest_data.item_uid or (quest_data.item_uid == v))
	end)

rp.seasonpass.AddQuestType("prop_dynamic_break")
	:AddHook('DestroyableProps::Destroyed', 1, function(quest, quest_data, ply, ent)
		return not quest_data or not quest_data.model or (IsValid(ent) and quest_data.model == ent:GetModel())
	end)

rp.seasonpass.AddQuestType("craft_item")
	:AddHook('OnItemCrafted', 1, function(quest, quest_data, ply, state, uniqueID)
		return (state == 4) and (not quest_data or not quest_data.item_uid or (quest_data.item_uid == uniqueID))
	end)

rp.seasonpass.AddQuestType("crafttable_item")
	:AddHook('urf.im/crafttable/FinishCraft', 2, function(quest, quest_data, craft_table, ply, uid, item_uid)
		return not quest_data or not quest_data.item_uid or (quest_data.item_uid == item_uid)
	end)

rp.seasonpass.AddQuestType("weapon_confiscate")
	:AddHook('Confiscation::Done', 1, function(quest, quest_data, ply, bad_guy, weapon_class, confiscation_money)
		return (not quest_data or not quest_data.weapon_class or (quest_data.weapon_class == weapon_class)) and true or false
	end)

rp.seasonpass.AddQuestType("weapon_confiscate_price")
	:AddHook('Confiscation::Done', 1, function(quest, quest_data, ply, bad_guy, weapon_class, confiscation_money)
		return (not quest_data or not quest_data.weapon_class or (quest_data.weapon_class == weapon_class)) and (confiscation_money and confiscation_money > 0) and confiscation_money
	end)

rp.seasonpass.AddQuestType("f4menu_open")
	:AddHook('F4Menu::Open', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("f4menu_open_settings")
	:AddHook('F4Menu::OpenSettings', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("social_promo")
	:AddHook('Social::UsedPromo', 1, function(quest, quest_data, ply, social_id, promo)
		return not quest_data or not quest_data.social_id or (quest_data.social_id == social_id)
	end)

rp.seasonpass.AddQuestType("bonus_used")
	:AddHook('Abilities::PlayerUsed', 1, function(quest, quest_data, ply, bonus_data)
		return not quest_data or not quest_data.bonus_uid or (quest_data.bonus_uid == bonus_data.UID)
	end)

rp.seasonpass.AddQuestType("social_promo_or_bonus")
	:AddHook('Social::UsedPromo', 1, function(quest, quest_data, ply, social_id, promo)
		return true
	end)
	:AddHook('Abilities::PlayerUsed', 1, function(quest, quest_data, ply, bonus_data)
		return true
	end)
	:AddHook('Lootboxes::Given', 1, function(quest, quest_data, ply, case_id)
		return (case_id == "daily_case")
	end)

rp.seasonpass.AddQuestType("case_spawned")
	:AddDataValidation(function(quest_data)
		return not quest_data.lootbox_uid or (rp.lootbox.Get(quest_data.lootbox_uid) and true or false)
	end)
	:AddHook('Lootbox::PlayerSpawned', 1, function(quest, quest_data, ply, lootbox_uid, box_ent)
		return not quest_data or not quest_data.lootbox_uid or (quest_data.lootbox_uid == lootbox_uid)
	end)

rp.seasonpass.AddQuestType("job_unlock")
	:AddHook('Teams::JobUnlock', 1, function(quest, quest_data, ply, job_command)
		return not quest_data or not quest_data.job_command or (quest_data.job_command == job_command)
	end)

rp.seasonpass.AddQuestType("rules_opened")
	:AddHook('MOTD::OpenedURL', 1, function(quest, quest_data, ply, btn_id)
		return true
	end)

rp.seasonpass.AddQuestType("circle_show_idcard")
	:AddHook('CircleMenu::ShowIDCard', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("transfer_money")
	:AddHook('RP::TransferMoney', 1, function(quest, quest_data, ply, ply_to, amount)
		return not quest_data or not quest_data.min_amount or (quest_data.min_amount >= amount)
	end)

rp.seasonpass.AddQuestType("radial_transfer_money")
	:AddHook('GivePlayerMoney', 1, function(quest, quest_data, ply, ply_to, amount)
		return not quest_data or not quest_data.min_amount or (quest_data.min_amount >= amount)
	end)

rp.seasonpass.AddQuestType("set_mood")
	:AddHook('Mood::PlayerSet', 1, function(quest, quest_data, ply, mood_id)
		return not quest_data or not quest_data.mood_id or (quest_data.mood_id == mood_id)
	end)

rp.seasonpass.AddQuestType("use_from_inv")
	:AddHook('Inventory::ItemUse', 1, function(quest, quest_data, ply, item)
		return not quest_data or not quest_data.item_uid or (quest_data.item_uid == item.uniqueID)
	end)

rp.seasonpass.AddQuestType("q_buy_ammo")
	:AddHook('QMenu::BoughtAmmo', 1, function(quest, quest_data, ply, ammo_type, ammo_data)
		return not quest_data or not quest_data.ammo_type or (quest_data.ammo_type == ammo_type)
	end)

rp.seasonpass.AddQuestType("q_spawn_entity")
	:AddHook('QMenu::SpawnedEntity', 1, function(quest, quest_data, ply, ent_class)
		return not quest_data or not quest_data.ent_class or (quest_data.ent_class == ent_class)
	end)

rp.seasonpass.AddQuestType("q_spawn_prop")
	:AddHook('QMenu::SpawnedProp', 1, function(quest, quest_data, ply, prop_model)
		return not quest_data or not quest_data.prop_model or (quest_data.prop_model == prop_model)
	end)

rp.seasonpass.AddQuestType("capture_bonus_used")
	:AddHook('Capture::BonusesUsed', 1, function(quest, quest_data, ply, bonusbox_ent)
		return true
	end)

rp.seasonpass.AddQuestType("storage_benifit_bought")
	:AddHook('Factory::BenifitBought', 1, function(quest, quest_data, ply, storage_name, benefit_data)
		return not quest_data or ((not quest_data.storage_name or quest_data.storage_name == storage_name) and (not quest_data.benefit_name or quest_data.benefit_name == benefit_data.name))
	end)

rp.seasonpass.AddQuestType("take_loot_armory_heist")
	:AddHook('Inventory.OnMoveItem', 1, function(quest, quest_data, ply, inv_from, inv_entity, item)
		return (inv_entity:GetNWInt("HeistID") or 0) > 0
	end)
	:AddHook('Inventory.OnCombineItem', 1, function(quest, quest_data, ply, inv_from, inv_entity, item)
		return (inv_entity:GetNWInt("HeistID") or 0) > 0
	end)

rp.seasonpass.AddQuestType("chat_emoji")
	:AddHook('Chat::EmojiSent', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("sp_reward")
	:AddHook('Seasonpass::GetReward', 1, function(quest, quest_data, ply, level)
		return true
	end)

rp.seasonpass.AddQuestType("pizza_craft")
	:AddHook('Pizza::Done', 1, function(quest, quest_data, ply, item, pizza_ent, is_burned)
		return not is_burned
	end)

rp.seasonpass.AddQuestType("c_menu_open")
	:AddHook('CMenu::Open', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("radial_open")
	:AddHook('Radial::Open', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("menu_select_job")
	:AddDataValidation(function(quest_data)
		return quest_data.team and true or false
	end)
	:AddHook('JobsMenu::SelectJob', 1, function(quest, quest_data, ply, team)
		return not quest_data or not quest_data.team or (quest_data.team == team)
	end)

rp.seasonpass.AddQuestType("menu_select_job_any")
	:AddHook('JobsMenu::SelectJob', 1, function(quest, quest_data, ply, team)
		return true
	end)

rp.seasonpass.AddQuestType("q_menu_open")
	:AddHook('QMenu::Open', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("vendor_menu_open")
	:AddHook('Vendor::OpenMenu', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("open_loot")
	:AddHook('Inv::OpenBag', 1, function(quest, quest_data, ply)
		return true
	end)
	:AddHook('LootableRoulette::Use', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("transfer_money_amount")
	:AddHook( "RP::TransferMoney", 1, function( quest, quest_data, ply, ply_to, amount )
		return amount
	end )

rp.seasonpass.AddQuestType("revive")
	:AddHook('DeathMechanics.OnEndHeal', 1, function(quest, quest_data, ply, revived_ply)
		return true
	end)

rp.seasonpass.AddQuestType("revive_players")
	:AddHook('DeathMechanics.OnEndHeal', 1, function(quest, quest_data, ply, revived_ply)
		RevivedSession = RevivedSession or {}; RevivedSession[ply] = RevivedSession[ply] or {};
		local b = not RevivedSession[ply][revived_ply];
		RevivedSession[ply][revived_ply] = true;
		return b
	end)

rp.seasonpass.AddQuestType("kill_npc")
	:AddDataValidation(function(quest_data)
		return quest_data.npc_class and true or false
	end)
	:AddHook('OnNPCKilled', 2, function(quest, quest_data, npc, attacker, inflictor)
		return not quest_data or not quest_data.npc_class or (quest_data.npc_class == npc:GetClass())
	end)

rp.seasonpass.AddQuestType("dance_follow")
	:AddHook('EmoteActions::Follow', 1, function(quest, quest_data, ply)
		return true
	end)

rp.seasonpass.AddQuestType("heal_players")
	:AddHook('OnPlayerHealed', 1, function(quest, quest_data, ply, healed_ply)
		HealedSession = HealedSession or {}; HealedSession[ply] = HealedSession[ply] or {};
		local b = not HealedSession[ply][healed_ply];
		HealedSession[ply][healed_ply] = true;
		return b
	end)

rp.seasonpass.AddQuestType( "game_played_1_min" )
	:AddHook( "Seasonpass::GamePlayed1Min", 1, function( quest, quest_data, ply, time_diff )
		return math.floor( time_diff / 60 );
	end )

rp.seasonpass.AddQuestType( "loot_players" )
	:AddHook( "Bodylooting::PlayerLooted", 1, function( quest, quest_data, initiator, target )
		LootedSession = LootedSession or {}; LootedSession[initiator] = LootedSession[initiator] or {};
		local b = not LootedSession[initiator][target];
		LootedSession[initiator][target] = true;
		return b;
	end )

local function ProcessLockpickQuest( ply, ent )
	LockpickedSession = LockpickedSession or {}; LockpickedSession[ply] = LockpickedSession[ply] or {};
	local b = not LockpickedSession[ply][ent];
	LockpickedSession[ply][ent] = true;
	return b;
end

rp.seasonpass.AddQuestType( "lockpick" )
	:AddHook( "PlayerFinishLockpicking", 1, function( quest, quest_data, ply, ent )
		return ProcessLockpickQuest( ply, ent );
	end )
	:AddHook( "PlayerFinishKeypadCrack", 1, function( quest, quest_data, ply, ent )
		return ProcessLockpickQuest( ply, ent );
	end )
	:AddHook( "PlayerFinishForcefieldCrack", 1, function( quest, quest_data, ply, ent )
		return ProcessLockpickQuest( ply, ent );
	end )
	:AddHook( "onLockpickCompleted", 1, function( quest, quest_data, ply, status, ent )
		if not status then return false; end
		return ProcessLockpickQuest( ply, ent );
	end )

rp.seasonpass.AddQuestType( "social" )
	:AddDataValidation( function( quest_data )
		return quest_data.social_id and true or false;
	end )
	:AddAccessValidation( function( ply, quest_data )
		local socials = ply:GetNetVar( "PlayerSocials" ) or {};
		if socials[quest_data.social_id] then
			return false;
		end
	end )
	:OnBegin( function( ply, quest_data )
		timer.Simple( 5, function() -- retarded solution
			if not IsValid( ply ) then return end
			hook.Run( "Seasonpass::SocialLoaded", ply, ply:GetNetVar( "PlayerSocials" ) or {} );
		end );
	end )
	:AddHook( "Seasonpass::SocialLoaded", 1, function( quest, quest_data, ply, socials )
		if socials[quest_data.social_id] then return true; end
		return false;
	end )
	:AddHook( "Social::UsedPromo", 1, function( quest, quest_data, ply, social_id )
		if social_id == quest_data.social_id then return true; end
		return false;
	end )

rp.seasonpass.AddQuestType( "referral" )
	:AddHook( "Social.Referrals::OnCodeActivated", 1, function( quest, quest_data, ply, referee_steamid )
		return true;
	end )