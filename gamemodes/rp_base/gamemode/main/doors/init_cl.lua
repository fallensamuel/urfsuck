-- "gamemodes\\rp_base\\gamemode\\main\\doors\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local IsValid                 = IsValid;
local ipairs                  = ipairs;
local pairs                   = pairs;
local LocalPlayer             = LocalPlayer;
local EyePos 			      = EyePos;
local EyeVector               = EyeVector;
local Vector                  = Vector;
local Angle                   = Angle;
local table_insert            = table.insert;
local table_sort              = table.sort;
local ents_FindInSphere       = ents.FindInSphere;
local util_QuickTrace         = util.QuickTrace;
local draw_SimpleTextOutlined = draw.SimpleTextOutlined;
local draw_SimpleText         = draw.SimpleText;
local cam_Start3D2D           = cam.Start3D2D;
local cam_End3D2D             = cam.End3D2D;
local off_vec                 = Vector( 0, 0, 17.5 );
local off_ang                 = Angle( 0, 90, 90 );


local color_white, color_black, color_green = rp.cfg.DoorColorWhite, rp.cfg.DoorColorBlack, rp.cfg.DoorColorGreen;

hook( "ConfigLoaded", function()
    color_white, color_black, color_green = rp.cfg.DoorColorWhite, rp.cfg.DoorColorBlack, rp.cfg.DoorColorGreen;
end );


local DoorCache = {};
local DoorLimit = 3;


local function UpdateDoorDisplay( ent )
	ent.DoorDisplayText = {};

	ent.DoorDisplayTextured = false
	ent.DoorDisplayName = ''
	
	if ent:DoorIsOwnable() then
		table_insert( ent.DoorDisplayText, {color_white, translates.Get("Зажмите [E]")} );
		table_insert( ent.DoorDisplayText, {color_white, translates.Get("чтобы арендовать")} );
		table_insert( ent.DoorDisplayText, {color_green, rp.FormatMoney(LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax))} );
		
		ent.DoorDisplayTextured = true
		ent.DoorDisplayName = ent.DoorDisplayName .. LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax)
	else
		local owner                        = ent:DoorGetOwner();
		local title, group, team, coowners = ent:DoorGetTitle(), ent:DoorGetGroup(), ent:DoorGetTeam(), ent:DoorGetCoOwners();

		if title then table_insert( ent.DoorDisplayText, {color_white, title} ); end
		
		if group then 
			table_insert( ent.DoorDisplayText, {color_white, group} ); 
			
			ent.DoorDisplayTextured = true
			ent.DoorDisplayName = ent.DoorDisplayName .. group
		end
		
		if team then 
			table_insert( ent.DoorDisplayText, {color_white, isnumber(team) and rp.teams[team] and rp.teams[team].name or team} ); 
			
			ent.DoorDisplayTextured = true 
			ent.DoorDisplayName = ent.DoorDisplayName .. team
		end

		if ent:DoorOrgOwned() and IsValid(owner) then
			table_insert( ent.DoorDisplayText, {owner:GetOrgColor(), (translates.Get("Организация") or "Организация") .. " `" .. (owner:GetOrg() or translates.Get("Неизвестно")) .. "`"} );
			
			ent.DoorDisplayTextured = true
			ent.DoorDisplayName = ent.DoorDisplayName .. 'org' .. (owner:GetOrg() or translates.Get("Неизвестно"))
			
		elseif ent:DoorOrg() then
			table_insert( ent.DoorDisplayText, {color_white, (translates.Get("Организация") or "Организация") .. " `" .. (ent:DoorOrg() or translates.Get("Неизвестно")) .. "`"} );
			
			ent.DoorDisplayTextured = true
			ent.DoorDisplayName = ent.DoorDisplayName .. 'org' .. ent:DoorOrg() or translates.Get("Неизвестно")
		end

		if IsValid(owner) then
			table_insert( ent.DoorDisplayText, {owner:GetJobColor(), owner:Name()} );
		end

		if coowners then
			for k, co in pairs( coowners ) do  
				if k > 3 then
					table_insert( ent.DoorDisplayText, {color_white, "..."} );
					break
				end

				if IsValid(co) then
					table_insert( ent.DoorDisplayText, {co:GetJobColor(), co:Name()} );
				end
			end
		end
	end
end


local function CheckDoorRelevance( ent )
	local newOwner, newTitle, newGroup, newTeam, newCoOwners, newOwnable = ent:DoorGetOwner(), ent:DoorGetTitle(), ent:DoorGetGroup(), ent:DoorGetTeam(), ent:DoorGetCoOwners(), ent:DoorIsOwnable();
	
	if
		newOwner    ~= ent.DoorOldOwner    	or
		newTitle    ~= ent.DoorOldTitle    	or
		newGroup    ~= ent.DoorOldGroup    	or
		newTeam     ~= ent.DoorOldTeam     	or
		newOwnable  ~= ent.DoorOldOwnable	or
		newCoOwners ~= ent.DoorOldCoOwners
	then
		UpdateDoorDisplay( ent );
	end

	ent.DoorOldOwner, ent.DoorOldTitle, ent.DoorOldGroup, ent.DoorOldTeam, ent.DoorOldCoOwners, ent.DoorOldOwnable = newOwner, newTitle, newGroup, newTeam, newCoOwners, newOwnable;
end


local pos

timer.Create( "RefreshDoorCache", 0.5, 0, function()
    if IsValid( LocalPlayer() ) then
        DoorCache = {};
		
		pos = LocalPlayer():EyePos();

        for _, ent in pairs( ents.FindInSphere(pos, 350) ) do
            if IsValid( ent ) and not ent:IsVehicle() and ent:IsDoor() then
				table_insert( DoorCache, ent );
				if not ent.DoorDisplayText then UpdateDoorDisplay( ent ); end
            end
		end
    end
end );


local bubble_cache = {}
local name, tW, tH, h, alpha, ds, lw, tr, aim, dir, max_h, ep;
local col_white = Color(255, 255, 255)

local function renderDoorText(txt_table)
	max_h = 0;
	
	for _, TextData in pairs( txt_table ) do
		--print(TextData[1], TextData[2])
		tW, tH = draw_SimpleTextOutlined( TextData[2], "DoorFont", 256, max_h, TextData[1], TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black );
		max_h = max_h + tH;
	end
	
	--print("Text size", max_h)
	
	return 512, max_h
end

hook( "PostDrawOpaqueRenderables", function()
	ep = EyePos();

    for _, ent in ipairs( DoorCache ) do
		if not IsValid( ent ) then continue end
		CheckDoorRelevance( ent );
		
		lw = ent:LocalToWorld( ent:OBBCenter() + off_vec );
		aim = (ep - lw):Angle();
	
		tr = util_QuickTrace( ep, -aim:Forward() * 350, LocalPlayer() );

		--tr = util.TraceHull( {
		--	start = ep,
		--	endpos = lw,
		--	filter = LocalPlayer(),
		--	mins = Vector( -5, -5, -5 ),
		--	maxs = Vector( 5, 5, 5 ),
		--} );

		if (tr.Entity ~= ent) or (lw:DistToSqr(tr.HitPos) > 65) then continue end

		dir = ent:GetAngles():Forward();
		if aim:Forward():Dot( dir ) < 0 then dir = -dir; end
		
		local angles = tr.HitNormal:Angle();
		angles:RotateAroundAxis( angles:Up(), 90 );
		angles:RotateAroundAxis( angles:Forward(), 90 );

		local origin = tr.HitPos + tr.HitNormal * 2;
		
		cam_Start3D2D( origin, angles, 0.1 );
			ds = lw:DistToSqr( ep );
			alpha = (122500 - ds) / 350;
			
			if ent.DoorDisplayTextured then
				draw.CustomTexture(ent.DoorDisplayName, 0, 0, ColorAlpha(col_white, alpha), function()
					return renderDoorText(ent.DoorDisplayText)
				end, false, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				h = 0;
				
				for _, TextData in pairs( ent.DoorDisplayText ) do
					TextData[1].a = alpha;
					color_black.a = alpha;

					tW, tH = draw_SimpleTextOutlined( TextData[2], "DoorFont", 0, h, TextData[1], 1, 1, 3, color_black );
					h = h + tH;
				end
			end
		cam_End3D2D();
	end
end );