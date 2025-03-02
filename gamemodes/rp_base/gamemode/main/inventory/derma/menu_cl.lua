-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\derma\\menu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if rp.cfg.DisableContextRedisign then return end

rp.menu = rp.menu or {}
rp.menu.list = rp.menu.list or {}

local CL_SCREEN_ScaleX, CL_SCREEN_ScaleY = 1, 1;
local CL_SCREEN_BORDERX1, CL_SCREEN_BORDERX2, CL_SCREEN_BORDERY1, CL_SCREEN_BORDERY2 = 50, 1200, 50, 800;
rp.menu.HasActiveMenu = false;

local OldW, OldH = ScrW(), ScrH();

local function BuildResolutionScale()
	CL_SCREEN_ScaleX, CL_SCREEN_ScaleY = ScrW() / 1600, ScrH() / 900;

	CL_SCREEN_BORDERX2 = 1200 * ScrW() / 1600;
	CL_SCREEN_BORDERY2 = 800 * ScrH() / 900;

	surface.CreateFont( "MontserratUIMenu", {
		font     = "Montserrat",
		extended = true,
		weight = 700,
		size     = 28 * CL_SCREEN_ScaleY,
	} );
	
	surface.CreateFont( "MontserratUIMenu2", {
		font     = "Montserrat",
		extended = true,
		weight = 500,
		size     = 18 * CL_SCREEN_ScaleY,
	} );

	OldW, OldH = ScrW(), ScrH();
end

BuildResolutionScale();
timer.Remove('inventory-menu-rscale');
timer.Create('inventory-menu-rscale', 5, 0, function()
	if (OldW != ScrW() or OldH != ScrH()) then
		BuildResolutionScale();
	end
end);

function rp.menu.add(options, position, onRemove)
	-- Set up the width of the menu.
	local width = 0
	local entity

	--print(position, type(position))
	--debug.Trace()
	
	-- The font for the buttons.
	surface.SetFont("Trebuchet24")

	-- Set the width to the longest button width.
	for k, v in pairs(options) do
		width = math.max(width, surface.GetTextSize(tostring(k)))
	end

	-- If you supply an entity, then the menu will follow the entity.
	if (type(position) == "Entity" or type(position) == "Weapon") then
		-- Store the entity in the menu.
		entity = position
		-- The position will be the trace hit pos relative to the entity.
		position = entity:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
	end

	-- Add the new menu to the list.
	return table.insert(rp.menu.list, {
		-- Use the specified position or whatever the player is looking at.
		position = position or LocalPlayer():GetEyeTrace().HitPos,
		-- Options are the list with button text as keys and their callbacks as values.
		options = options,
		-- Add 8 to the width to give it a border.
		width = width + 8,
		-- Find how tall the menu is.
		height = table.Count(options) * 28,
		-- Store the attached entity if there is one.
		entity = entity,
		-- Called after the menu has faded out.
		onRemove = onRemove
	})
end

-- Gradient for subtle effects.
local gradient = Material("vgui/gradient-u")

local item_material = Material("rpui/icons/cancapture")
local weap_material = Material("rpui/icons/haslicense");
local weap_usematerial = false;

local fmod = math.fmod;

local getKeys = table.GetKeys;
local rotAngl = 0;

local utf8_codepoint = utf8.codepoint;
local string_sub = string.sub;
local utf8_char = utf8.char;
local string_byte = string.byte;

local Case = {
	{
		Filter = function(Char) 
			return (Char > 0) and (Char <= 127)
		end
	},
	{
		Filter = function(Char)
			return (Char >= 194) and (Char <= 223)
		end
	},
	{
		Filter = function(Char) 
			return (Char >= 224) and (Char <= 239)
		end
	},
	{
		Filter = function(Char) 
			return (Char >= 240) and (Char <= 244)
		end
	}
};

local SBytes = function(String, Position)
    Position = Position or 1;
    if (type(Position) != 'number' or type(String) != 'string') then
        return 1
    end
    local Char = string_byte(String, Position);
    for I, Data in pairs(Case) do
        if (Data.Filter(Char)) then
            return I
        end
    end
end

local Upper = function (String)
    if (type(String) != 'string') then return String end

    local Data = {
        Position = 1,
        Bytes = #String,
        CharByte = 1,
        UpperString = ''
    };

    local Char, CodePoint;
    while (Data.Position <= Data.Bytes) do
        Data.CharByte = SBytes(String, Data.Position);
        Char = string_sub(String, Data.Position, Data.Position + Data.CharByte - 1);
        CodePoint = utf8_codepoint(Char, 1);
        if (CodePoint >= 1072 and CodePoint <= 1103) or (CodePoint >= 93 and CodePoint <= 122) then
            Char = utf8_char(CodePoint - 32);
        end
        Data.UpperString = Data.UpperString .. Char;
        Data.Position = Data.Position + Data.CharByte;
    end

    return Data.UpperString
end

local BufferedPositions = {};

local test_active_menu, test_active_menu2

-- A function to draw all of the active menus or hide them when needed.
local default_name_txt = translates.Get('Предмет')
local place_in_bag_txt = translates.Get('Положить в сумку')
function rp.menu.drawAll()
	local frameTime = FrameTime() * 30
	local mX, mY = ScrW() * 0.5, ScrH() * 0.5
	local position2 = LocalPlayer():GetPos()

	rp.menu.HasActiveMenu = false;
	
	-- Loop through the current menus.
	for k, v in ipairs(rp.menu.list) do
		-- Get their position on the screen.
		local position
		local entity = v.entity

		local EntityName = default_name_txt;

		if (v.options and #getKeys(v.options) > 0) then rp.menu.HasActiveMenu = true; end

		if (entity) then
			-- Follow the entity.
			if (IsValid(entity)) then
				local realPos = entity:LocalToWorld(v.position)

				v.entPos = LerpVector(frameTime * 0.25, v.entPos or realPos, realPos)
				position = (v.entPos or Vector(0, 0, 0)):ToScreen()

				if (entity:GetClass() == 'rp_item') then
					weap_usematerial = (entity.getItemTable and entity.getItemTable().isWeapon) or false;
					EntityName = (entity.getItemTable and entity.getItemTable() or {}).name or default_name_txt
				else
					EntityName = entity.PrintName or default_name_txt;
					weap_usematerial = entity:IsWeapon() or false;
				end
			-- The attached entity is gone, remove the menu.
			else
				table.remove(rp.menu.list, k)
				BufferedPositions = {};

				if (v.onRemove) then
					v:onRemove()
				end

				continue
			end
		else
			--print(v.position)
			position = (v.position or Vector(0, 0, 0)):ToScreen()
		end

		if (!BufferedPositions[entity]) then
			BufferedPositions[entity] = position;
		end

		local width, height = v.width, v.height
		local startX, startY = position.x - (width * 0.5), position.y - 22
		local alpha = v.alpha or 0
		-- Local player is within 96 units of the menu.
		local inRange = position2:DistToSqr(IsValid(v.entity) and v.entity:GetPos() or v.position) <= 9216
		-- Check that the center of the screen is within the bounds of the menu.
		local inside = inRange; //(mX >= startX and mX <= (startX + width) and mY >= startY and mY <= (startY + height)) and inRange

		if !(startX >= CL_SCREEN_BORDERX1 and startX <= CL_SCREEN_BORDERX2 and startY >= CL_SCREEN_BORDERY1 and startY <= CL_SCREEN_BORDERY2) then
			v.toClose = true;
		end

		-- Make the menu more visible if the center is inside the menu or it hasn't peaked in alpha yet.
		if ((!v.displayed or inside) and !v.toClose) then
			v.alpha = math.Approach(alpha or 0, 255, frameTime * 10)

			--print(v.alpha)
			
			-- If this is the first time we reach full alpha, store it.
			if (v.alpha == 255) then
				v.displayed = true
			else
				test_active_menu, test_active_menu2 = nil, nil
			end
		-- Otherwise the menu should fade away.
		else
			inRange = false;
			v.alpha = math.Approach(alpha or 0, 0, inRange and frameTime or (frameTime * 15))

			-- If it has completely faded away, remove it.
			if (v.alpha == 0) then
				-- Remove the menu from being drawn.
				table.remove(rp.menu.list, k)
				BufferedPositions = {};

				if (v.onRemove) then
					v:onRemove()
				end

				-- Skip to the next menu, the logic for this one is done.
				continue
			end
		end

		-- Store which button we're on.
		local i = 0
		-- Determine the border of the menu.
		--local x2, y2, w2, h2 = startX - 4, startY - 4, width + 8, height + 8

		alpha = v.alpha * 0.9

		surface.SetDrawColor(250, 250, 250, v.alpha);
		surface.SetMaterial((weap_usematerial and weap_material) or item_material);
		surface.DrawTexturedRect(startX, startY - 22 - 2, 24 * CL_SCREEN_ScaleX, 24 * CL_SCREEN_ScaleY);

		rp.util.drawText(EntityName, startX + 30 * CL_SCREEN_ScaleX, startY - (24 + 3) * CL_SCREEN_ScaleY, Color(255, 255, 255, v.alpha), nil, nil, 'MontserratUIMenu');

		/*

		-- Draw the dark grey background.
		surface.SetDrawColor(40, 40, 40, alpha)
		surface.DrawRect(x2, y2, w2, h2)

		-- Draw a subtle gradient over it.
		surface.SetDrawColor(250, 250, 250, alpha * 0.025)
		surface.SetMaterial(gradient)
		surface.DrawTexturedRect(x2, y2, w2, h2)

		-- Draw an outline around the menu.
		surface.SetDrawColor(0, 0, 0, alpha * 0.25)
		surface.DrawOutlinedRect(x2, y2, w2, h2)

		*/

		local length = 0;
		local col = Color(255, 255, 255);

		local line = 0;

		local function FUNC_DRAW_DO(k2, v2)
			/*
			if (i >= 2) then
				line = line + 1;
				length = 0;
				i = 0;
			end
			*/

			-- Determine where the button starts.
			local x = startX;//local y = startY + (i * 28)
			local y = startY + 14 + (line * 25) - 2 + i*42;

			width = (utf8.len(k2) * (12 * CL_SCREEN_ScaleY) + 25) * CL_SCREEN_ScaleX;
			length = length + width;

			local _height = 30 * CL_SCREEN_ScaleY;

			local C = rpui.UIColors.BackgroundGold;
			local C2 = C;
			//C.a = v.alpha;

			local _C, _CC = rpui.UIColors.BackgroundGold, rpui.UIColors.Gold;
			_C.a, _CC.a = v.alpha, v.alpha;

			surface.SetAlphaMultiplier(v.alpha);
				surface.SetDrawColor(_C);
				surface.DrawRect(x, y, width - 20, _height);
		
				surface.SetMaterial(rpui.GradientMat);
				surface.SetDrawColor(_CC);
				surface.DrawTexturedRect(x, y, width - 20, _height);
			surface.SetAlphaMultiplier(1);

			-- Check if the button is hovered.
			if (mY >= y and mY <= (y + _height) and mX >= x and mX <= (x + width)) then
				-- If so, draw a colored rectangle to indicate it.
				/*
				surface.SetDrawColor(Color(247, 251, 251, v.alpha + math.cos(RealTime() * 8) * 40))
				surface.DrawRect(x, y, width - 20, 18 * CL_SCREEN_ScaleY)
				*/

				col = Color(0, 0, 0)
				C2 = ColorAlpha(rpui.UIColors.Black, v.alpha)

				test_active_menu = k
				test_active_menu2 = v2
			else
				/*
				surface.SetDrawColor(Color(0, 0, 0, 165 * (v.alpha / 255)))
				surface.DrawRect(x, y, width - 20, _height);
				*/
				draw.RoundedBox(0, x + 3, y + 3, width - 26, _height - 6, Color(0, 0, 0, v.alpha));

				col = Color(255, 255, 255)
				C2 = Color(255, 156, 0, v.alpha);
			end

			-- Draw the button's text.
			draw.SimpleText(Upper(k2), "MontserratUIMenu2", (x + 3) + ((width - 23)/2) - 3 + 1, y + _height / 2, C2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
			//rp.util.drawText(k2, x + (width - 20), y + _height / 2 - 1, C2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, "MontserratUIMenu2")

			-- Make sure we draw the next button in line.
			i = i + 1
		end

		local def_table = table.Copy(v.options);

		local HasInBag = table.HasValue(table.GetKeys(v.options), place_in_bag_txt);
		if (HasInBag) then
			for k2, v2 in SortedPairs({[place_in_bag_txt] = def_table[place_in_bag_txt]}) do
				FUNC_DRAW_DO(k2, v2)
			end
			def_table[place_in_bag_txt] = nil;
		end

		-- Loop through all of the buttons.
		for k2, v2 in SortedPairs(def_table) do
			FUNC_DRAW_DO(k2, v2)
		end
	end
end

function rp.menu.getActiveMenu()
	timer.Simple(0, function()
		test_active_menu, test_active_menu2 = nil, nil
	end)
	return test_active_menu, test_active_menu2
end

-- Handles whenever a button has been pressed.
function rp.menu.onButtonPressed(menu, callback)
	table.remove(rp.menu.list, menu)
	//rp.menu.HasActiveMenu = false;
	BufferedPositions = {};

	if (callback) then
		callback()
		
		return true
	end

	return false
end

do return end -- Скип старого кода.

-- Determines which menu is being looked at

function rp.menu.getActiveMenu()
	local mX, mY = ScrW() * 0.5, ScrH() * 0.5
	local position2 = LocalPlayer():GetPos()

	-- Loop through the current menus.
	for k, v in ipairs(rp.menu.list) do
		-- Get their position on the screen.
		local position
		local entity = v.entity
		local width, height = v.width, v.height
		
		if (entity) then
			-- Follow the entity.
			if (IsValid(entity)) then
				position = (v.entPos or entity:LocalToWorld(v.position)):ToScreen()
			-- The attached entity is gone, remove the menu.
			else
				table.remove(rp.menu.list, k)
				BufferedPositions = {};

				continue
			end
		else
			position = v.position:ToScreen()
		end

		if (!BufferedPositions[entity]) then
			BufferedPositions[entity] = position;
		end

		-- Get where the menu starts and ends.
		local startX, startY = position.x - (width * 0.5), position.y - 22
		-- Local player is within 96 units of the menu.
		local inRange = position2:Distance(IsValid(v.entity) and v.entity:GetPos() or v.position) <= 96
		-- Check that the center of the screen is within the bounds of the menu.
		local inside = inRange; //(mX >= startX and mX <= (startX + width) and mY >= startY and mY <= (startY + height)) and inRange

		if (inRange and inside) then
			local choice
			local i = 0

			local length = 0;
			local line = 0;

			local function FUNC_TO_DO(k2, v2)
				/*
				if (i >= 2) then
					line = line + 1;
					length = 0;
					i = 0;
				end
				*/

				-- Determine where the button starts.
				//local y = startY + (i * 28)
				/*
				local x = startX + length;//local y = startY + (i * 28)
				local y = startY + 14 - 2;
				*/

				local x = startX;//local y = startY + (i * 28)
				local y = startY + 14 + (line * 25) - 2 + i*42;

				width = (utf8.len(k2) * (12 * CL_SCREEN_ScaleY) + 25) * CL_SCREEN_ScaleX;
				length = length + width;

				-- Check if the button is hovered.
				if (inside and mY >= y and mY <= (y + 30 * CL_SCREEN_ScaleY) and mX >= x and mX <= (x + width)) then
					choice = v2

					return -1
				end

				-- Make sure we draw the next button in line.
				i = i + 1

				return 1
			end

			local def_table = table.Copy(v.options);

			local HasInBag = table.HasValue(table.GetKeys(v.options), place_in_bag_txt);
			if (HasInBag) then
				for k2, v2 in SortedPairs({[place_in_bag_txt] = def_table[place_in_bag_txt]}) do
					FUNC_TO_DO(k2, v2)
				end
				def_table[place_in_bag_txt] = nil;
			end

			-- Loop through all of the buttons.
			for k2, v2 in SortedPairs(def_table) do
				if (FUNC_TO_DO(k2, v2) == -1) then
					break
				end
			end

			return k, choice
		end
	end
end