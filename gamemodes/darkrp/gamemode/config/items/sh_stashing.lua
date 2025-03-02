-- "gamemodes\\darkrp\\gamemode\\config\\items\\sh_stashing.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.type      = "item";
ITEM.ent       = "stashing";
ITEM.name      = "Секретная документация";
ITEM.model     = "models/stalker/item/handhelds/files1.mdl";
ITEM.width     = 1;
ITEM.height    = 1;
ITEM.desc      = "Секретная документация, которую нужно где то спрятать.";
ITEM.category  = "Storage";
ITEM.noDrop    = true;
ITEM.stackable = true;
ITEM.maxStack  = 1;
-- ITEM.allowed   = { TEAM_ECOLOG_SHIFR, TEAM_NEBOR };
ITEM.vendor = {
	 ["Профессор Сахаров"] = {buyPrice = 10},
	 ["Ученый ЧН"] = {buyPrice = 10},
	 ["Сидорович"] = {sellPrice = 1},
};

if ITEM.vendor then
	local tblEnt = {
		name = ITEM.name,
		ent = ITEM.ent,
		model = ITEM.model,
		desc = ITEM.desc,
		noDrop = ITEM.noDrop,
		stackable = ITEM.stackable,
		maxStack = ITEM.maxStack,
		vendor = ITEM.vendor,
		allowed = ITEM.allowed,
	};

	for vendor_name, price_tab in pairs( tblEnt.vendor ) do
		rp.AddVendorItem( vendor_name, tblEnt.category, tblEnt, price_tab );
	end
end

local function IsStashingItemChallenge( data )
	return data and data.t == "stashing";
end

function ITEM:onInstanced( invID )
	local inv = rp.item.getInv( invID );
	if not inv then return end

	local ply = inv.owner;
	if not IsValid( ply ) then return end

	local spot = rp.Stashing:GetSpot( ply, true );
	if spot then return end

	if rp.Stashing:TrySpot(ply, {t = "stashing"}) then
		rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Точка схрона была отмечена на экране") );
	end
end

ITEM.functions.useStashing = {
	name = translates.Get("Спрятать"),
	tip  = "useTip",
	icon = "icon16/package_go.png",
	onRun = function( item )
        local status, message = rp.Stashing:TryChallenge( item.player, true, {t = "stashing"} );

		if message and #message > 0 then
			rp.Notify( item.player, NOTIFY_GENERIC, rp.Stashing:GetMessage(message) );
		end

        return status;
	end,
};

if CLIENT then
	local phrase = translates.Get( "Нажми [%s] чтобы спрятать документы!", string.upper(input.LookupBinding("+use")) );

	local function FindStashingVendors()
		local vendors = {};

		local t = LocalPlayer():Team();

		for vendor_id, vendor in pairs( rp.VendorsNPCs ) do
			if vendor.allowed and not vendor.allowed[t] then
				continue
			end

			if vendor.items and vendor.items["stashing"] then
				vendors[vendor_id] = true;
			end
		end

		return vendors;
	end

	gameevent.Listen( "player_spawn" );

	hook.Add( "player_spawn", "item_stashing", function( data )
		if data.userid ~= LocalPlayer():UserID() then return end

		timer.Remove( "item_stashing::Highlighter" );

		local jt = LocalPlayer():GetJobTable() or {};
		if not jt.stashing then
			return
		end

		timer.Create( "item_stashing::Highlighter", 5, 0, function()
			for vendor_id in pairs( FindStashingVendors() ) do
				rp.HighlightNPCVendor.Add( vendor_id, 5 );
			end
		end );
	end );

	hook.Add( "HUDStashing", "item_stashing", function( origin, origin_screen, dist )
        local alpha = math.min( 1, dist / math.pow(rp.Stashing.Config.Spots.Radius, 2) );
		if alpha < 1 then
			local w, h = ScrW(), ScrH();
			draw.SimpleTextOutlined( phrase, "rpui.fonts.Stashing-HUD", w * 0.5, h * 0.55, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, rpui.UIColors.Shading );
		end
	end );
end

hook.Add( "PlayerCanReceiveStashingSpot", "item_stashing", function( ply, data )
	if not IsStashingItemChallenge( data ) then return end

	local jt = ply:GetJobTable() or {};
	if not jt.stashing then
		return false, translates.Get("У вас неподходящая профессия");
	end

	local inv = ply:getInv();
	if not inv then
		return false, translates.Get("Инвентарь не доступен");
	end

	local has = inv:hasItem( "stashing" );
	if not has then
		return false, translates.Get("Предмет не доступен");
	end

	return true;
end );

hook.Add( "OnStashingChallengeReward", "item_stashing", function( ply, challenge )
	if not IsStashingItemChallenge( challenge ) then return end

	local reward = 75;

	ply:AddMoney( reward );
	rp.Notify( ply, NOTIFY_GREEN, string.format("Ты спрятал секретные документы и получил за это %s", rp.FormatMoney(reward)) );
end );

hook.Add( "OnStashingChallengeLose", "item_stashing", function( ply, challenge, message )
	if not IsStashingItemChallenge( challenge ) then return end

	rp.Notify( ply, NOTIFY_ERROR, "Ты разорвал секретные документы и выбросил их" );
end );

hook.Add( "StashingChallengeStarted", "item_stashing", function( ply, challenge )
	if not IsStashingItemChallenge( challenge ) then return end

	ply:ForceStartEmoteAction( "stashing_loop" );
end );

hook.Add( "StashingChallengeEnded", "item_stashing", function( ply, challenge )
	if not IsStashingItemChallenge( challenge ) then return end

	if not ply:IsInDeathMechanics() then
		ply:DropEmoteAction();

		timer.Simple( 0, function()
			if not IsValid( ply ) then return end

			if rp.Stashing:TrySpot(ply, {t = "stashing"}) then
				rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Точка схрона была отмечена на экране") );
			end
		end );
	end
end );

if SERVER then
	local function SpawnCheck( ply )
		local jt = ply:GetJobTable();
		if not jt.stashing then
			local spot = rp.Stashing:GetSpot( ply, true );

			if spot then
				rp.Stashing:SendSpot( ply );
			end

			return
		end

		local inv = ply:getInv();
		if not (inv and inv.hasItem) then return end

		local has = inv:hasItem( "stashing" );
		if has and rp.Stashing:TrySpot(ply, {t = "stashing"}) then
			rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Точка схрона была отмечена на экране") );
		end
	end

	hook.Add( "PlayerSpawn", "item_stashing", SpawnCheck );
	hook.Add( "PlayerInventoryLoaded", "item_stashing", SpawnCheck );

	hook.Add( "KeyPress", "item_stashing", function( ply, key )
		if key ~= IN_USE then return end

		local spot = rp.Stashing:GetSpot( ply, true );
		if not spot then return end

		local inv = ply:getInv();
		if not inv then return end

		local status, message = rp.Stashing:TryChallenge( ply, true, {t = "stashing"} );

		if status then
			local item = inv:hasItem( "stashing" );
			if item and item.remove then item:remove(); end
		end
	end );
end

timer.Simple( 0, function()
	local action = rp.Experiences:GetExperienceAction( "stashing" );
	action:SetPrintName( "Захоронение" );
end );
