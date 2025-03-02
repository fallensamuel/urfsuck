--[[
local IsValid = IsValid
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local Angle = Angle
local Vector = Vector
local ents_FindInSphere = ents.FindInSphere
local util_TraceLine = util.TraceLine
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local team_GetColor = team.GetColor
local team_GetName = team.GetName
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local color_white = rp.cfg.DoorColorWhite
local color_black = rp.cfg.DoorColorBlack
local color_green = rp.cfg.DoorColorGreen
local off_vec = Vector(0, 0, 17.5)
local off_ang = Angle(0, 90, 90)
local count
local DoorText = {}
local DoorCache = {}

hook('ConfigLoaded', function()
	color_white = rp.cfg.DoorColorWhite
	color_black = rp.cfg.DoorColorBlack
	color_green = rp.cfg.DoorColorGreen
end)

local function AddText(tbl)
	DoorText[count + 1] = tbl
	count = count + 1
end

timer.Create('RefreshDoorCache', 0.4, 0, function()
	if IsValid(LocalPlayer()) then
		local count = 0
		DoorCache = {}

		for k, ent in ipairs(ents_FindInSphere(LocalPlayer():GetPos(), 350)) do
			if IsValid(ent) and !ent:IsVehicle() && ent:IsDoor() then
				count = count + 1
				DoorCache[count] = ent
			end
		end
	end
end)

hook('PostDrawOpaqueRenderables', function()
	for _, ent in ipairs(DoorCache) do
		if IsValid(ent) then
			count = 0
			DoorText = {}
			local dist = ent:GetPos():DistToSqr(LocalPlayer():GetPos())

			if ent:DoorIsOwnable() then
				AddText({color_white, 'F2 -арендовать'})
				AddText({color_green, rp.FormatMoney(LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax))})
			elseif not ent:DoorIsOwnable() then
				-- Title
				if (ent:DoorGetTitle() ~= nil) then
					AddText({color_white, ent:DoorGetTitle()})
				end

				-- Group Own
				if (ent:DoorGetGroup() ~= nil) then
					AddText({color_white, ent:DoorGetGroup()})
				end

				-- Team Own
				if (ent:DoorGetTeam() ~= nil) then
					AddText({team_GetColor(ent:DoorGetTeam()), team_GetName(ent:DoorGetTeam())})
				end

				-- Org own
				local owner	= ent:DoorGetOwner()
				local org 	= ent:DoorOrg()
				
				if ent:DoorOrgOwned() and IsValid(owner) then
					AddText({owner:GetOrgColor(), 'Организация `' .. (owner:GetOrg() or 'Неизвестно') .. '`'})
				elseif org then
					AddText({Color(255, 255, 255), 'Организация `' .. org .. '`'})
				end


				-- Owner
				if IsValid(owner) then
					AddText({owner:GetJobColor(), owner:Name()})
				end

				-- Co-Owners
				if (ent:DoorGetCoOwners() ~= nil) then
					for k, co in ipairs(ent:DoorGetCoOwners()) do
						if IsValid(co) then
							AddText({co:GetJobColor(), co:Name()}) -- TODO: FIX
						end

						if (k >= 4) then
							AddText({color_white, 'and ' .. (#ent:DoorGetCoOwners() - 4) .. ' co-owners.'}) -- TODO: FIX
							break
						end
					end
				end
			end

			-- Draw it
			local lw = ent:LocalToWorld(ent:OBBCenter()) + off_vec

			local tr = util_TraceLine({
				start = LocalPlayer():GetPos() + LocalPlayer():OBBCenter(),
				endpos = lw,
				filter = LocalPlayer()
			})

			if (tr.Entity == ent) and (lw:DistToSqr(tr.HitPos) < 65) then
				cam_Start3D2D(tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + off_ang, .050)
				local h = 0

				for k, v in ipairs(DoorText) do
					local a = (122500 - dist) / 350
					--v[1].a = a
					--color_black.a = a
					local _, th = draw_SimpleTextOutlined(v[2], 'DoorFont', 0, h, v[1], 1, 1, 3, color_black)
					h = h + th
				end

				cam_End3D2D()
			end
		end
	end
end)
]]--

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
local util_TraceLine          = util.TraceLine;
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

	if ent:DoorIsOwnable() then
		table_insert( ent.DoorDisplayText, {color_white, translates.Get("F2 - арендовать")} );
		table_insert( ent.DoorDisplayText, {color_green, rp.FormatMoney(LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax))} );
	else
		local owner                        = ent:DoorGetOwner();
		local title, group, team, coowners = ent:DoorGetTitle(), ent:DoorGetGroup(), ent:DoorGetTeam(), ent:DoorGetCoOwners();

		if title then table_insert( ent.DoorDisplayText, {color_white, title} ); end
		if group then table_insert( ent.DoorDisplayText, {color_white, group} ); end
		if team  then table_insert( ent.DoorDisplayText, {color_white, isnumber(team) and rp.teams[team] and rp.teams[team].name or team} );  end

		if ent:DoorOrgOwned() and IsValid(owner) then
			table_insert( ent.DoorDisplayText, {owner:GetOrgColor(), (translates.Get("Организация") or "Организация") .. " `" .. (owner:GetOrg() or translates.Get("Неизвестно")) .. "`"} );
		elseif ent:DoorOrg() then
			table_insert( ent.DoorDisplayText, {color_white, (translates.Get("Организация") or "Организация") .. " `" .. (ent:DoorOrg() or translates.Get("Неизвестно")) .. "`"} );
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


local function IsDoorBehind( ent )
	return (ent:GetPos() - LocalPlayer():GetPos()):GetNormalized():Dot(EyeVector()) < 0;
end


timer.Create( "RefreshDoorCache", 0.5, 0, function()
    if IsValid( LocalPlayer() ) then
        DoorCache = {};
		
		local pos = EyePos();

        for _, ent in pairs( ents.FindInSphere(pos, 350) ) do
            if IsValid( ent ) then
                if !ent:IsVehicle() and ent:IsDoor() then
					table_insert( DoorCache, ent );
					if not ent.DoorDisplayText then UpdateDoorDisplay( ent ); end
                end
            end
		end
		
		--table_sort( DoorCache, function( a, b )	return a:GetPos():DistToSqr(pos) < b:GetPos():DistToSqr(pos) end );
		--
		--if #DoorCache > DoorLimit then
		--	for k = (DoorLimit + 1), #DoorCache do DoorCache[k] = nil; end
		--end
    end
end );


hook( "PostDrawOpaqueRenderables", function()
    for _, ent in ipairs( DoorCache ) do
		if IsValid(ent) then
			if IsDoorBehind(ent) then continue end
			CheckDoorRelevance( ent );
			
			local ds = ent:GetPos():DistToSqr( EyePos() );
			local lw = ent:LocalToWorld( ent:OBBCenter() ) + off_vec;
			local tr = util_TraceLine( {
				start  = EyePos(),
				endpos = lw,
				filter = LocalPlayer()
			} );

			if (tr.Entity == ent) and (lw:DistToSqr(tr.HitPos) < 65) then
				cam_Start3D2D( tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + off_ang, 0.050 );
					local alpha = (122500 - ds) / 350;
					local h = 0;
					
					for _, TextData in pairs( ent.DoorDisplayText ) do
						TextData[1].a = alpha;
						color_black.a = alpha;

						local _, tH = draw_SimpleTextOutlined( TextData[2], "DoorFont", 0, h, TextData[1], 1, 1, 3, color_black );
						h = h + tH;
					end
				cam_End3D2D();
			end
        end
	end
end );