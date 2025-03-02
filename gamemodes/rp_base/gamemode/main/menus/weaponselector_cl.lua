-- "gamemodes\\rp_base\\gamemode\\main\\menus\\weaponselector_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if not rp.cfg.RPUIWeaponSelector then return end

local cvar_name = 'default_weaponselector'
local cvar_Get = cvar.GetValue

cvar.Register(cvar_name)
	:SetDefault(false)
	:AddMetadata('State', 'RPMenu')
	:AddMetadata('Menu', 'Стандартное меню выбора оружия')

local switch = nil
hook.Add( "CreateMove", "WeaponSwitch", function( cmd )
	if ( !IsValid( switch ) ) then return end

	cmd:SelectWeapon( switch )

	if ( LocalPlayer():GetActiveWeapon() == switch ) then
		switch = nil
	end
end )

local font_color_white = Color(255, 255, 255)
local font_color_orange = Color(255, 156, 0)
local color_black = Color(6, 6, 6)
local color_selected = Color(255, 255, 255)

local color_temp_gold_1 = Color(254, 121, 4)
local color_temp_gold_2 = Color(240, 181, 25)

local exc 
local function rebuild_fonts()
	exc = ScrH() / 720
	
	surface.CreateFont( "WeaponSelectorFont", {
		font = "Montserrat",
		size = 20 * exc,
		extended = true,
		antialias = true,
		weight = 500
	})
	
	surface.CreateFont( "WeaponSelectorFontSmall", {
		font = "Montserrat",
		size = 17 * exc,
		extended = true,
		antialias = true,
		weight = 500
	})

	surface.CreateFont( "WeaponSelectorSubFont", {
		font = "Montserrat",
		size = 10 * exc,
		extended = true,
		antialias = true,
		weight = 700,
	})
end

local color = Color(255, 255, 255)
local activeColor = Color(94, 209, 241)
local focusColor = Color(241, 209, 94)

local cats = {
	[translates.Get("СТРОИТЕЛЬСТВО")] = 1,
	[translates.Get("РОЛЕПЛЕЙ")] = 2,
	[translates.Get("ОРУЖИЕ")] = 3,
	[translates.Get("ДРУГОЕ")] = 4,
}

local cat_ids = {
	[1] = translates.Get("СТРОИТЕЛЬСТВО"),
	[2] = translates.Get("РОЛЕПЛЕЙ"),
	[3] = translates.Get("ОРУЖИЕ"),
	[4] = translates.Get("ДРУГОЕ"),
}

local cats_map = {
	['Инструменты'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['Разное'] = translates.Get("ДРУГОЕ"),
	['Other'] = translates.Get("ДРУГОЕ"),
	['RP'] = translates.Get("РОЛЕПЛЕЙ"),
	['HL2 RP'] = translates.Get("РОЛЕПЛЕЙ"),
}

local cats_forced = {
	['weapon_physgun'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['weapon_physcannon'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_prem_1'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_prem_2'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_prem_3'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_prem_4'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_prem_5'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['gmod_tool_revolver'] = translates.Get("СТРОИТЕЛЬСТВО"),
	['weapon_medkit'] = translates.Get("РОЛЕПЛЕЙ"),
}

local slots = {
	Material("rpui/wep_selector/1", "smooth noclamp"),
	Material("rpui/wep_selector/2", "smooth noclamp"),
	Material("rpui/wep_selector/3", "smooth noclamp"),
	Material("rpui/wep_selector/4", "smooth noclamp"),
	Material("rpui/wep_selector/5", "smooth noclamp"),
	Material("rpui/wep_selector/6", "smooth noclamp"),
	Material("rpui/wep_selector/7", "smooth noclamp"),
	Material("rpui/wep_selector/8", "smooth noclamp"),
	Material("rpui/wep_selector/9", "smooth noclamp"),
	Material("rpui/wep_selector/10", "smooth noclamp"),
	Material("rpui/wep_selector/11", "smooth noclamp"),
	Material("rpui/wep_selector/12", "smooth noclamp"),
}

local holdtypes = {
	['pistol'] = 2,
	['revolver'] = 2,
	['duel'] = 2,
	
	['melee'] = 1,
	['melee2'] = 1,
	['knife'] = 1,
	
	['smg'] = 3,
	['ar2'] = 3,
	
	['shotgun'] = 4,
	['crossbow'] = 4,
	
	['rpg'] = 7,
	['grenade'] = 7,
	['slam'] = 7,
	
	['physgun'] = 8,
	
	['camera'] = 9,
	
	['normal'] = 12,
	['passive'] = 12,
	['magic'] = 12,
	['fist'] = 12,
}

local cat_slots = {
	slots[10],
	slots[12],
	slots[4],
	slots[12],
}

local slots_forced = {
	['weapon_physgun'] = 8,
	['weapon_physcannon'] = 8,
	['gmod_tool'] = 9,
	['gmod_tool_prem_1'] = 9,
	['gmod_tool_prem_2'] = 9,
	['gmod_tool_prem_3'] = 9,
	['gmod_tool_prem_4'] = 9,
	['gmod_tool_prem_5'] = 9,
	['gmod_tool_revolver'] = 9,
	['weapon_medkit'] = 12,
	
	['keys'] = 11,
	['weapon_cuff_elastic'] = 10,
	['weapon_cuff_rope'] = 10,
	['weapon_cuff_shackles'] = 10,
	['weapon_hands'] = 12,
}

local function sequent(t)
	local o = {}
	
	for k, _ in pairs(cats) do
		o[k] = {}
	end
	
	for _, v in pairs(t) do 
		if v.SelectorCategory and o[v.SelectorCategory] then
			table.insert(o[v.SelectorCategory], v) 
			
		elseif cats_forced[v:GetClass()] then
			table.insert(o[ cats_forced[v:GetClass()] ], v) 
			
		elseif v.Category and cats_map[v.Category] then
			table.insert(o[ cats_map[v.Category] ], v) 
			
		else
			table.insert(o[translates.Get("ОРУЖИЕ")], v) 
		end
	end
	
	return o
end

local cur_off
local max_weps = 10
local hud_fastswitch   = GetConVar( "hud_fastswitch" )
local cat_focus, cat_active = translates.Get("СТРОИТЕЛЬСТВО"), translates.Get("СТРОИТЕЛЬСТВО")
local focus, active    = 1, 1
local visible, opacity = 0, 0
local temp_weapons, rotAngle
local block_width, block_height
local baked_names = {}
local active_weapon
local offset_y = 0

local function updateweapons()
	local weps = sequent(LocalPlayer():GetWeapons())
	temp_weapons = weps
end

local obj_icons_got = {}
local obj_icons = {}
local function get_obj_icon(v)
	if obj_icons[v:GetClass()] then
		return obj_icons[v:GetClass()]
	end
	
	if not obj_icons_got[v:GetClass()] and (v.ClassName or v:GetClass()) then
		obj_icons_got[v:GetClass()] = true
		
		local name = "entities/" .. (v.ClassName or v:GetClass()) .. ".png"
		local mat = Material(name)
		
		if not mat or mat:IsError() then
			name = name:Replace("entities/", "VGUI/entities/")
			name = name:Replace(".png", "")
			mat = Material(name)
		end

		local slot = v.WeaponSelectorIcon
		
		if (not mat or mat:IsError() and slot) or slots_forced[v:GetClass()] then
			mat = slots_forced[v:GetClass()] and slots[ slots_forced[v:GetClass()] ] or slots[slot]
		end
		
		if (not mat or mat:IsError()) and v:GetHoldType() and slots[ holdtypes[v:GetHoldType()] or -1 ] then
			mat = slots[ holdtypes[v:GetHoldType()] or -1 ]
		end
		
		slot = v.Slot
		
		if (not mat or mat:IsError() and slot) or slots_forced[v:GetClass()] then
			mat = slots_forced[v:GetClass()] and slots[ slots_forced[v:GetClass()] ] or slots[slot]
		end
		
		if (not mat or mat:IsError()) and cat_slots[ cats[cat_focus or ''] or -1 ] then
			mat = cat_slots[ cats[cat_focus or ''] or -1 ]
		end
		
		if not mat or mat:IsError() then return end
		
		obj_icons[v:GetClass()] = mat
		return mat
	end
end

local wep_icon, time_change_weapon

local function draw_category(cat_id, cat_name)
	local x = ScrW() * 0.5 + (cat_id - 3) * 1.02 * block_width
	local y = 10 + 0.02 * ScrH()
	local spacer = 0.02 * block_width
	
	surface.SetDrawColor(ColorAlpha(color_black, ((cat_name == cat_focus) and 1 or 0.8) * opacity))
	surface.DrawRect(x, y, block_width, block_height)
	
	draw.SimpleText(cat_id, 'WeaponSelectorSubFont', x + block_width * 0.05, y + block_width * 0.05, ColorAlpha(font_color_orange, opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(cat_name, 'WeaponSelectorFont', x + block_width * 0.5, y + block_height * 0.5, ColorAlpha(font_color_white, opacity), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	if cat_name == cat_focus then
		local ct_weps = #temp_weapons[cat_name]
		
		if ct_weps > max_weps then
			local df_weps = (focus - 1) / ct_weps
			
			cur_off = -df_weps * (ct_weps - max_weps) * (block_height + spacer)
			
			offset_y = (offset_y or 0) + 0.2 * (cur_off - (offset_y or 0))
			
		else
			offset_y = 0
		end
		
		render.SetScissorRect(x - block_height, y + (block_height + spacer), x + block_width, ScrH(), true)
		for k, v in pairs(temp_weapons[cat_name]) do
			wep_icon = get_obj_icon(v)
			
			if wep_icon then
				surface.SetDrawColor(ColorAlpha(color_black, opacity))
				surface.DrawRect(x - block_height, y + k * (block_height + spacer) + offset_y, block_height, block_height)
				
				surface.SetDrawColor(ColorAlpha(font_color_white, opacity))
				surface.SetMaterial(wep_icon)
				surface.DrawTexturedRect(x - block_height, y + k * (block_height + spacer) + offset_y, block_height, block_height)
			end
			
			if time_change_weapon and time_change_weapon < CurTime() and cat_active == cat_focus then
				if v == active_weapon and active ~= k then
					active = k
					cat_active = cat_focus
				
				elseif k == active and v ~= active_weapon then
					active = -1
					cat_active = -1
				end
			end
			
			if not baked_names[v:GetClass()] then
				local swepname = v:GetPrintName() or "SWEP"
				baked_names[v:GetClass()] = string.Wrap('WeaponSelectorFontSmall', swepname, block_width * 0.8)
				
				for ka, vt in pairs(baked_names[v:GetClass()]) do
					baked_names[v:GetClass()][ka] = language.GetPhrase(string.Trim(vt)) or vt
				end
			end
			
			if cat_name == cat_active and k == active then
				surface.SetDrawColor(ColorAlpha(color_temp_gold_1, opacity))
				surface.DrawRect(x, y + k * (block_height + spacer) + offset_y, block_width, block_height)
				
				local distsize = math.sqrt( block_width * block_width + block_height * block_height )
				rotAngle = (rotAngle or 0) + 100 * FrameTime()
				
				render.SetScissorRect(x, y + k * (block_height + spacer) + offset_y, x + block_width, y + k * (block_height + spacer) + block_height + offset_y, true)
					surface.SetMaterial(rpui.GradientMat)
                    surface.SetDrawColor(ColorAlpha(color_temp_gold_2, opacity))
                    surface.DrawTexturedRectRotated(x + block_width * 0.5, y + k * (block_height + spacer) + block_height * 0.5 + offset_y, distsize, distsize, (rotAngle or 0))
					
					for kt, text in ipairs( baked_names[v:GetClass()] ) do
						draw.SimpleText(text, 'WeaponSelectorFontSmall', x + block_width * 0.1, y + block_height * 0.5 + k * (block_height + spacer) + (kt - 1 - ((#baked_names[v:GetClass()] - 1) * 0.5)) * block_height * 0.4 + offset_y, ColorAlpha((k == active and cat_name == cat_active or k ~= focus) and font_color_white or color_black, opacity), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				render.SetScissorRect(x - block_height, y + k * (block_height + spacer) + block_height + offset_y, x + block_width, ScrH(), true)
				
			else
				surface.SetDrawColor(ColorAlpha((k == focus) and color_selected or color_black, ((k == focus) and 1 or 0.5) * opacity))
				surface.DrawRect(x, y + k * (block_height + spacer) + offset_y, block_width, block_height)
				
				for kt, text in ipairs( baked_names[v:GetClass()] ) do
					draw.SimpleText(text, 'WeaponSelectorFontSmall', x + block_width * 0.1, y + block_height * 0.5 + k * (block_height + spacer) + (kt - 1 - ((#baked_names[v:GetClass()] - 1) * 0.5)) * block_height * 0.4 + offset_y, ColorAlpha((k == active and cat_name == cat_active or k ~= focus) and font_color_white or color_black, opacity), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end
		end
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

hook('HUDPaint', 'rp.WeaponSelector', function()
	if cvar_Get(cvar_name) then return end
	if temp_weapons == nil then updateweapons(); end
	if not exc then rebuild_fonts() end
	
	if LocalPlayer():InVehicle() then return end
	if not LocalPlayer():Alive() or LocalPlayer():IsInDeathMechanics() then return end

	if visible > CurTime() then 
		opacity = Lerp(0.15, opacity, 255)
	else 
		opacity = Lerp(0.15, opacity, 0) 
	end

	if opacity < 1 then return end

	local activeWeapon = IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon()
	updateweapons();

	if opacity < 10 then return end

	if (!cat_focus || !focus || !temp_weapons[cat_focus] || !temp_weapons[cat_focus][focus]) then
		cat_focus = cat_active
		focus = active
	end
	
	active_weapon = LocalPlayer():GetActiveWeapon()
	
	if !block_width then
		surface.SetFont('WeaponSelectorFont')
		local height
		
		block_width, height = surface.GetTextSize(translates.Get("СТРОИТЕЛЬСТВО"))
		block_width = 1.3 * block_width
		
		block_height = 1.9 * height
	end
	
	draw_category(1, translates.Get("СТРОИТЕЛЬСТВО"))
	draw_category(2, translates.Get("РОЛЕПЛЕЙ"))
	draw_category(3, translates.Get("ОРУЖИЕ"))
	draw_category(4, translates.Get("ДРУГОЕ"))
end)

local function fadeIn()
	visible = CurTime() + 1
end

local function fadeOut()
	visible = 0
end

local hoverSound = Sound("garrysmod/ui_hover.wav")
local tick = Sound('common/talk.wav')
local playSound = surface.PlaySound

local last = 0
local oldlast = 0
local cat_last = 0
local cat_oldlast = 0

local function physgun()
	return (IsValid(LocalPlayer():GetActiveWeapon()) && LocalPlayer():GetActiveWeapon():GetClass() == "weapon_physgun" && input.IsMouseDown(MOUSE_LEFT))
end

local function selectWeapon(cat_index, index)
	if !temp_weapons or !temp_weapons[cat_index] or !IsValid(temp_weapons[cat_index][index]) then return false end
	switch = temp_weapons[cat_index][index]
	--input.SelectWeapon( temp_weapons[cat_index][index] )

	playSound(tick)
	
	cat_active = cat_index
	active = index
	
	time_change_weapon = 0.5 + CurTime()
end

local bind_table = {
	invprev = function()
		if physgun() then
			return false 
		end
		playSound(hoverSound)
		
		if focus == 1 and temp_weapons and temp_weapons[cat_focus] then
			local i = 0
			focus = 0
			
			while i < 4 and focus < 1 do
				if cats[cat_focus] == 1 then
					cat_focus = cat_ids[4]
					
				else
					cat_focus = cat_ids[cats[cat_focus] - 1]
				end
				
				focus = #temp_weapons[cat_focus]
				i = i + 1
			end
			
			offset_y = 0
			
			local ct_weps = #temp_weapons[cat_focus]
			
			if ct_weps > max_weps then
				if !block_width then
					surface.SetFont('WeaponSelectorFont')
					local height
					
					block_width, height = surface.GetTextSize(translates.Get("СТРОИТЕЛЬСТВО"))
					block_width = 1.3 * block_width
					
					block_height = 1.9 * height
				end
				
				offset_y = -(ct_weps - max_weps) * (block_height + block_width * 0.02)
			end
		else
			focus = focus - 1
		end
		
		if hud_fastswitch:GetInt() > 0 then selectWeapon(focus) end 
		fadeIn()
		return true
	end,
	invnext = function()
		if physgun() then 
			return false 
		end
		playSound(hoverSound)
		
		if cat_focus and temp_weapons and temp_weapons[cat_focus] and focus == #temp_weapons[cat_focus] then
			local i = 0
			focus = 1
			
			while i < 4 and (i == 0 or #temp_weapons[cat_focus] < 1) do
				if cats[cat_focus] == 4 then
					cat_focus = cat_ids[1]
					
				else
					cat_focus = cat_ids[cats[cat_focus] + 1]
				end
				
				i = i + 1
			end
			
			offset_y = 0
		else
			focus = focus + 1
		end
		
		if hud_fastswitch:GetInt() > 0 then selectWeapon(focus) end 
		fadeIn()
		return true
	end,
}

bind_table['+attack'] = function()
	if visible > CurTime() then
		last = active
		cat_last = cat_active
		selectWeapon(cat_focus, focus)
		fadeOut()
		return true
	end
end

bind_table['lastinv'] = function()
	oldlast = last
	cat_oldlast = cat_last
	last = active
	cat_last = cat_active
	selectWeapon(cat_oldlast, oldlast)
	focus = active
	cat_focus = cat_active
	return true
end

for i = 1, 4 do
	bind_table['slot'..i] = function()
		if not (CW_CUSTOMIZE and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon().dt and LocalPlayer():GetActiveWeapon().dt.State == CW_CUSTOMIZE) then
			timer.Simple(0, function() 
				if temp_weapons and temp_weapons[ cat_ids[i] ][1] then
					if cat_focus ~= cat_ids[i] then
						cat_focus = cat_ids[i]
						focus = 1
						offset_y = 0
						
					else
						focus = 1 + (focus % (#temp_weapons[cat_focus]))
					end
					
					selectWeapon(cat_focus, focus)
				end
			end)
			
			fadeIn()
		end
	end
end

hook("PlayerBindPress", 'rp.WeaponSelector', function(ply, bind, pressed)
	if not cvar_Get(cvar_name) and ply:Alive() and not ply:IsInDeathMechanics() then
		if bind_table[bind] && pressed then
			local result = bind_table[bind]()
			
			if result ~= nil then
				return result
			end
		end
	end
end)

hook("HUDShouldDraw", function(name)
	if name == 'CHudWeaponSelection' then return cvar_Get(cvar_name) or false end
end)