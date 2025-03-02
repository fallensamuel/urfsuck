-- "gamemodes\\rp_base\\gamemode\\addons\\awards\\awards.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

--[[ Weighted Random Selector Function ]]--
local weighted_random = function(tbl)
	local summ = 0
	local result
	local default_summ = 0
	local default
	
	for k, v in pairs(tbl) do
		if not default or default_summ < v then
			default = k
			default_summ = v
		end
		
		summ = summ + v
	end
	
	local chance = math.random(0, summ)
	
	for k, v in pairs(tbl) do
		chance = chance - v
		
		if chance <= 0 then
			result = k
			break
		end
	end
	
	return result or default
end

local give_shop_item = function(ply, shop_uid, callback)
	rp._Stats:Query("INSERT INTO `kshop_purchases` VALUES(?, ?, ?, 0);", os.time(), ply:SteamID(), shop_uid, function(dat)
		local upgrades = ply:GetVar('Upgrades')
		upgrades[shop_uid] = upgrades[shop_uid] and (upgrades[shop_uid] + 1) or 1
		ply:SetVar('Upgrades', upgrades)
		
		local shop_obj = rp.shop.GetByUID(shop_uid)
		
		if shop_obj then
			shop_obj:OnBuy(ply)
			
			hook.Run("Awards::GivenToShop", ply, shop_obj)
			
			if callback then
				callback(shop_obj)
			end
		end
	end)
end


--[[ Award Type Descriptions ]]--
rp.awards.AddType('AWARD_WEAPON', function(ply, weapons, durations)
	local weps_copy = table.Copy(istable(weapons) and weapons or { [weapons] = 1 })
	local wep = weighted_random(weps_copy)
	
	if not durations or durations == 0 then
		net.Start('Lootbox::GaveWep')
			net.WriteString(wep)
			net.WriteBool(false)
		net.Send(ply)
		
		RunConsoleCommand("urf", "givetempweapon", ply:SteamID(), wep, '-1h') 
		
		return
	end
	
	while table.Count(weps_copy) > 0 and IsValid(ply:GetWeapon(wep)) do
		weps_copy[wep] = nil
		wep = weighted_random(weps_copy)
	end
	
	if not wep or IsValid(ply:GetWeapon(wep)) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidWep'))
		return
	end
	
	durations = istable(durations) and weighted_random(durations) or durations
	
	net.Start('Lootbox::GaveWep')
		net.WriteString(wep)
		net.WriteBool(true)
		net.WriteString(durations)
	net.Send(ply)
	
	RunConsoleCommand("urf", "givetempweapon", ply:SteamID(), wep, durations) 
	
end, function(steamid, award_info)
	local ply = player.GetBySteamID64(steamid)
	if not IsValid(ply) then return end
	
	ply.PresentWeapons = ply.PresentWeapons or {}
	ply.PresentWeapons[award_info] = true
	
	if rp.teams[ply:Team()] and not rp.teams[ply:Team()].DontHaveDonateSWEPS and not rp.teams[ply:Team()].disallowDonateWeapons then
		ply:Give(award_info)
	end
	
end, function(steamid, award_info)
	local ply = player.GetBySteamID64(steamid)
	
	if IsValid(ply) then
		ply.PresentWeapons = ply.PresentWeapons or {}
		ply.PresentWeapons[award_info] = nil
	end
end)

rp.awards.AddType('AWARD_JOB', function(ply, jobs, durations)
	local jobs_copy = table.Copy(istable(jobs) and jobs or { [jobs] = 1 })
	local job = weighted_random(jobs_copy)
	
	if not durations or durations == 0 then
		rp.JobsWhitelist.GiveAccess(ply:SteamID64(), job)
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("профессию %s!", rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job))
		
		timer.Remove('Award::' .. ply:SteamID64() .. '::' .. rp.awards.Types.AWARD_JOB .. '::' .. job)
		rp._Stats:Query("DELETE FROM `halloween_temp_presents`WHERE `steamid` = ? AND `present_type` = ? AND `present_id` = ?;", ply:SteamID64(), rp.awards.Types.AWARD_JOB, job)
		
		return
	end
	
	while table.Count(jobs_copy) > 0 and rp.PlayerHasAccessToJob(job, ply) do
		jobs_copy[job] = nil
		job = weighted_random(jobs_copy)
	end
	
	if not job or rp.PlayerHasAccessToJob(job, ply) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidJob'))
		
	else
		durations = istable(durations) and weighted_random(durations) or durations
		RunConsoleCommand("urf", "givetempjob", ply:SteamID(), job, durations)
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("профессию %s на %s!", rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job, durations))
	end
	
end, nil, function(steamid, award_info)
	rp.JobsWhitelist.RemoveAccess(steamid, award_info)
end)

rp.awards.AddType('AWARD_RANK', function(ply, ranks, durations)
	if not (ply:IsVIP() or ply:IsAdmin()) then
		ranks = istable(ranks) and weighted_random(ranks) or ranks
		durations = istable(durations) and weighted_random(durations) or durations
		
		RunConsoleCommand("urf", "setgroup", ply:SteamID(), ranks, durations, ply:GetUserGroup()) 
			
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("ранг %s на %s!", ba.ranks.Get(ranks).NiceName, durations))
		
	else
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidRank'))
	end
end)

rp.awards.AddType('AWARD_TIME', function(ply, hours)
	ply:SetNetVar('PlayTime', ply:GetNetVar('PlayTime') + hours * 3600)
	ba.data.UpdatePlayTime(ply)
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get('%s часов отыгранного времени!', hours))
end)

rp.awards.AddType('AWARD_MONEY', function(ply, min_amount, max_amount)
	local amount = max_amount and math.ceil(math.random(min_amount, max_amount)) or min_amount
	
	ply:AddMoney(amount)
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), rp.FormatMoney(amount))
end)

rp.awards.AddType('AWARD_CREDITS', function(ply, min_amount, max_amount, desc)
	local amount = max_amount and math.ceil(math.random(min_amount, max_amount)) or min_amount
	
	ply:AddCredits(amount, desc or 'award')
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get('%s кредитов', amount))
end)

rp.awards.AddType('AWARD_TIMEMULTIPLIER', function(ply, multipliers, durations)
	if ply:HasTimeMultiplayer('award_time') then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidTime'))
		return false
	end
	
	multipliers = istable(multipliers) and weighted_random(multipliers) or multipliers
	durations = istable(durations) and weighted_random(durations) or durations
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get('множитель времени x%s на %s!', multipliers, durations))
	
	ply:AddTimeMultiplayerSaved('award_time', multipliers, 3600 * tonumber(string.sub(durations, 1, -2)))
end)

rp.awards.AddType('AWARD_MODEL', function(ply, shop_uid)
	if ply:HasUpgrade(shop_uid) then
		return rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidModel'))
	end
	
	give_shop_item(ply, shop_uid, function(shop_obj)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("модель %s!", shop_obj:GetName()))
	end)
end)

rp.awards.AddType('AWARD_ITEM', function(ply, uid)
	local inv = ply:getInv()
	
	if not inv then
		rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
		return
	end
	
	local status, result = inv:add(uid)

	if status == false then
		rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
		return
	end
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("предмет %s!", rp.item.list[uid] and rp.item.list[uid].name or ''))

	timer.Simple(0.1, function()
		inv:sync(ply, true)
	end)
end)

rp.awards.AddType('AWARD_CASE', function(ply, case_id)
	rp.lootbox.Give(ply, case_id, function()
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), rp.lootbox.Get(case_id).name .. '!')
	end)
end)

rp.awards.AddType('AWARD_EMOTION', function(ply, shop_uid)
	if ply:HasUpgrade(shop_uid) then
		return rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidEmotion'))
	end
	
	give_shop_item(ply, shop_uid, function(shop_obj)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("танец %s!", shop_obj:GetName()))
	end)
end)

rp.awards.AddType('AWARD_EMOJI', function(ply, shop_uid)
	if ply:HasUpgrade(shop_uid) then
		return rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidEmoji'))
	end
	
	give_shop_item(ply, shop_uid, function(shop_obj)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("emoji %s!", shop_obj:GetName()))
	end)
end)

rp.awards.AddType('AWARD_SALARY', function(ply, multiplier, durations)
	if ply.SalaryMultiplier then
		return rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::InvalidSalary'))
	end
	
	multiplier = isnumber(multiplier) and multiplier or weighted_random(multiplier)
	durations = istable(durations) and weighted_random(durations) or durations
	
	RunConsoleCommand("urf", "givetempsalary", ply:SteamID(), multiplier, durations) 
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Awards::Reward'), translates.Get("множитель зарплаты x%s на %s!", multiplier, durations))
	
end, function(steamid, award_info)
	local ply = player.GetBySteamID64(steamid)
	if not IsValid(ply) then return end
	
	ply.SalaryMultiplier = tonumber(award_info)
	
end, function(steamid, award_info)
	local ply = player.GetBySteamID64(steamid)
	if not IsValid(ply) then return end
	
	ply.SalaryMultiplier = nil
end)

rp.awards.AddType( "AWARD_HAT", function( ply, hat_name, time )
	local hat;

	for _, data in pairs( rp.hats.list ) do
		if data.name == hat_name then
			hat = data;
		end	
	end

	if not hat then
		return
	end

	if not time then
		rp.hats.Give( ply, hat.model );
		rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("шапку %s!", hat.name) );
		return
	end

	RunConsoleCommand( "urf", "givetemphat", ply:SteamID(), hat.model, time );
	rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("шапку %s на %s!", hat.name, time) );
end, nil, function( steamid, hat_model )
	rp.hats.Take( steamid, hat_model );
end );

rp.awards.AddType( "AWARD_PET", function( ply, pet_uid, time )
	local pet = rp.pets.Map[pet_uid];
	
	if not pet then
		return
	end

	if not time then
		rp.pets.Give( ply, pet_uid );
		rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("питомца %s!", pet.name) );
		return
	end

	RunConsoleCommand( "urf", "givetemppet", ply:SteamID(), pet_uid, time );
	rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("питомца %s на %s!", pet.name, time) );
end, nil, function( steamid, pet_uid )
	rp.pets.Take( steamid, pet_uid );
end );

rp.awards.AddType( "AWARD_ACCESSORY", function( ply, accessory_uid, time )
	local accessory = rp.Accessories.List[accessory_uid];
	if not accessory then return end

	if not time then
		rp.Accessories.Set( ply, accessory_uid );
		rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("аксессуар %s!", accessory.name) );
		return
	end

	RunConsoleCommand( "urf", "givetempaccessory", ply:SteamID(), accessory_uid, time );
	rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("аксессуар %s на %s!", accessory.name, time) );
end, nil, function( steamid, accessory_uid )
	rp.Accessories.Remove( steamid, accessory_uid );
end );

rp.awards.AddType( "AWARD_WEAPON_ONETIME", function( ply, wep )
	wep = weapons.GetStored( wep );
	if not wep then return end

	ply:Give( wep.ClassName );
	rp.Notify( ply, NOTIFY_GREEN, rp.Term("Awards::Reward"), translates.Get("оружие %s на одну жизнь!", wep.PrintName or wep.ClassName) );
end );