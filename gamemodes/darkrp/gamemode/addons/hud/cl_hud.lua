-- "gamemodes\\darkrp\\gamemode\\addons\\hud\\cl_hud.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local cvar_name = 'hidehud_' .. game.GetMap()
cvar.Register(cvar_name):SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Отключить интерфейс')

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	DarkRP_HUD = false,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	DarkRP_EntityDisplay = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	DarkRP_ZombieInfo = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet
	DarkRP_LocalPlayerHUD	= true,

	-- Drawing the DarkRP agenda
	DarkRP_Agenda   = false,

	CHudHealth 		= true,
	CHudSecondaryAmmo = true,
	CHudBattery 	= true,
	CHudSuitPower	= true,
	CHudAmmo		= true,

}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
		ErrorNoHalt("surface.DrawPartialTexturedRect: Missing argument!")

		return
	end

	-- Get the positions and sizes as percentages / 100
	local percX, percY = partx / texw, party / texh
	local percW, percH = partw / texw, parth / texh

	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
			}
	}

	surface.DrawPoly( vertexData )
end

function surface.DrawPartialTexturedRectRotated( x, y, w, h, partx, party, partw, parth, texw, texh, rot )
	local matrix = Matrix()
	matrix:Rotate( Angle( 0,-rot,0 ) )
	cam.PushModelMatrix( matrix )
	surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	cam.PopModelMatrix()
end

local k = 1

surface.CreateFont("1StalkerJobFont", {
	font = "RUSBoycott",
	extended = true,
	size = 24 * k,
	weight = 550,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	--outline = true,
})

surface.CreateFont("1StalkerWalletFont", {
	font = "RUSBoycott",
	extended = true,
	size = 27 * k,
	weight = 200,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont("1StalkerSubBarFont", {
	font = "RUSBoycott",
	extended = true,
	size = 18 * k,
	weight = 100,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local p = "alphatest"

local hud = Material( "stalker_icons/stalker_flag.png" )
local hunger = Material( "stalker_icons/food_icon.png", p )
local radiation = Material( "stalker_icons/rad_icon.png", p )
local red_bar = Material( "stalker_icons/hp_bar.png", p )

local armor_bar = Material( "stalker/armor_bar.png", p)
local job_bar = Material( "stalker/job_bar.png", p)
local stamina_core_bar = Material( "stalker/stamina_core_bar.png", p)
local stamina_bar = Material( "stalker/stamina_bar.png", p)
local minimap = Material( "stalker/minimap.png", p)
local compas = Material( "stalker/compas.png", p)

local map = Material( rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].map or "stalker/minimap.png", p)

local unit_green = Material( "stalker/icons/ally_logo.png", p)
local unit_red = Material( "stalker/icons/enemy_logo.png", p)

local hud_size_w, hud_size_h = 232 * k, 183 * k
local job_bar_offset = 0
local job_bar_w, job_bar_h = 242 * k, 59 * k
local job_label_offset_x = 44 * k
local job_label_offset_y = 15 * k

local wallet_offset_x = 162 * k
local wallet_offset_y = 54 * k

local salary_offset_x = 110 * k
local salary_offset_y = 24 * k

local ammo_offset_x = 57 * k
local ammo_offset_y = 45 * k

local bar_w = 138 * k
local bar_sub_offset = 28 * k
local bar_offset = 57 * k
local bar_offset_right = 37 * k

local sub_bar_h_offset = 38 * k

local font_color = Color(225, 225, 225, 255)
local font_color2 = Color(255, 240, 90, 255)
local font_red_color = Color(240, 70, 70)
local font_blue_color = Color(150, 100, 250)



local minimap_max_dist 	= 3000 -- Gmod units
local find_time 		= 4 -- Icons time on minimap

local minimap_power 	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].power or 1
local minimap_offset_x 	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].off_x or 0
local minimap_offset_y	= rp.cfg.MinimapSettings[game.GetMap()] and rp.cfg.MinimapSettings[game.GetMap()].off_y or 0


local minimap_radius = 86 * k
local minimap_width = 197 * k
local minimap_height = 215 * k
local minimap_off_x = 10
local minimap_off_y = 10


local compas_width = 53 * k
local compas_height = 53 * k
local compas_off_x = minimap_off_x + compas_width / 2
local compas_off_y = minimap_off_y + compas_height / 2

local minimap_texture_x = map:Width()
local minimap_texture_y = map:Height()

local unit_size = 17 * k

local minimap_ply_maxdistance = minimap_radius / k - unit_size / 2
local minimap_dist_multiplier = minimap_max_dist / minimap_ply_maxdistance / k

local minimap_ctr_x = minimap_off_x + minimap_width / 2 + 8 * k
local minimap_ctr_y = minimap_off_y + minimap_height / 2 + 5 * k

local minimap_texture_radius = minimap_max_dist / minimap_power -- image map pixel radius on minimap
local minimap_texture_multiplier_x = minimap_texture_radius / minimap_texture_x
local minimap_texture_multiplier_y = minimap_texture_radius / minimap_texture_y

local minimap_realmap_offset = Vector(minimap_offset_x / minimap_texture_x, minimap_offset_y / minimap_texture_y, 0)


local sf_SetDrawColor = surface.SetDrawColor
local sf_DrawTexturedRect = surface.DrawTexturedRect
local sf_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local sf_SetMat = surface.SetMaterial
local sf_DrawPoly = surface.DrawPoly
local sf_DrawLine = surface.DrawLine
local cvar_Get = cvar.GetValue


local scrW, scrH
local ply

local hunder, armor, health, sprint, maxsprint, restoring, time_left, max_health
local x   	= 0
local maxx	= 0
local off_x, off_y

local m_sin = math.sin
local m_cos = math.cos
local m_rad = math.rad
local m_min = math.min
local m_max = math.max
local m_sqrt = math.sqrt
local t_ins = table.insert

local function sf_DrawMap(x, y, radius, seg)
	cir = {}

	dop = m_rad(EyeVector():Angle().yaw - 90)
	myp = minimap_realmap_offset + Vector(myPos.x / minimap_texture_x, -myPos.y / minimap_texture_y, 0) / minimap_power

	t_ins(cir, { x = x, y = y, u = 0.5 + myp.x, v = 0.5 + myp.y })

	for i = 0, seg do
		a = m_rad((i / seg) * -360)
		t_ins(cir, {
			x = x + m_sin(a) * radius,
			y = y + m_cos(a) * radius,
			u = m_sin(a + dop) * minimap_texture_multiplier_x + myp.x + 0.5,
			v = m_cos(a + dop) * minimap_texture_multiplier_y + myp.y + 0.5
		})
	end

	a = m_rad(0)
	t_ins(cir, {
		x = x + m_sin(a) * radius,
		y = y + m_cos(a) * radius,
		u = m_sin(a + dop) * minimap_texture_multiplier_x + myp.x + 0.5,
		v = m_cos(a + dop) * minimap_texture_multiplier_y + myp.y + 0.5
	})

	sf_DrawPoly(cir)
end



local m_ceil = math.ceil
local m_abs = math.abs
local m_clamp = math.Clamp
local s_find = string.find
local f_time = string.FormattedTime
local rp_FormatMoney = rp.FormatMoney
local minimap_max_dist 	= 1000 -- Gmod units
local find_time 		= 4 -- Icons time on minimap

-- local minimap_power 	= rp.cfg.MinimapSettings[game.GetMap()].power
-- local minimap_offset_x 	= rp.cfg.MinimapSettings[game.GetMap()].off_x
-- local minimap_offset_y	= rp.cfg.MinimapSettings[game.GetMap()].off_y


local minimap_radius = 113
local minimap_width = 207
local minimap_height = 192
local minimap_off_x = 10
local minimap_off_y = 10


local compas_width = 53
local compas_height = 53
local compas_off_x = minimap_off_x + compas_width / 2
local compas_off_y = minimap_off_y + compas_height / 2

local minimap_texture_x = map:Width()
local minimap_texture_y = map:Height()

local unit_size = 17

local minimap_ply_maxdistance = minimap_radius - unit_size / 2
local minimap_dist_multiplier = minimap_max_dist / minimap_ply_maxdistance

local minimap_ctr_x = 136
local minimap_ctr_y = ScrH() - 141

local capture, attacker, defender, myPos, myNorm, pos, dist, ok, norm
local unit_x = minimap_ctr_x - unit_size / 2
local unit_y = minimap_ctr_y - unit_size / 2
local cir, dop, a

local minimap_texture_radius = minimap_max_dist / minimap_power -- image map pixel radius on minimap
local minimap_texture_multiplier_x = minimap_texture_radius / minimap_texture_x
local minimap_texture_multiplier_y = minimap_texture_radius / minimap_texture_y

local minimap_realmap_offset = Vector(minimap_offset_x / minimap_texture_x, minimap_offset_y / minimap_texture_y, 0)

local function worldToMinimapUnclamped(pos)
	pos:Set(Vector(pos.x, pos.y, 0))

	pos  = (pos - myPos) / minimap_power
	pos:Set(Vector(pos.x, -pos.y, 0))
	pos:Rotate(-myNorm)

	return Vector(pos.x, pos.y, 0)
end

local function worldToMinimap(pos)
	pos = worldToMinimapUnclamped(pos)
	return Vector(unit_x + m_clamp(pos.x, -minimap_width / 2 + 10, minimap_width / 2 - 10), unit_y + m_clamp(pos.y, -minimap_height / 2 + 10, minimap_height / 2 - 10), 0)
end

local a, b, c, x0, y0, d, mult, ax, ay, bx, by
local pMin, pMax, rMin, rMax, R1, R2

local function clampLine(V1, V2, BY1, BY2)
	if BY1.x == BY2.x then
		rMin = V1.y < V2.y and V1 or V2
		rMax = rMin == V1 and V2 or V1

		pMin = BY1.y < BY2.y and BY1 or BY2
		pMax = pMin == BY1 and BY2 or BY1

		R1 = rMin.y < pMin.y and pMin or rMin
		R2 = rMax.y > pMax.y and pMax or rMax
	else
		rMin = V1.x < V2.x and V1 or V2
		rMax = rMin == V1 and V2 or V1

		pMin = BY1.x < BY2.x and BY1 or BY2
		pMax = pMin == BY1 and BY2 or BY1

		R1 = rMin.x < pMin.x and pMin or rMin
		R2 = rMax.x > pMax.x and pMax or rMax
	end

	ok = minimap_radius * minimap_radius + 1
	return R1.x, R1.y, R2.x, R2.y, R1:Length2DSqr() <= ok and R2:Length2DSqr() <= ok
end

local function drawMinimapLine(pos1, pos2)
	a = (pos1.y - pos2.y) / (pos1.x - pos2.x)
	b = -1
	c = pos2.y - a * pos2.x

	x0 = -a * c / (a * a + b * b)
	y0 = -b * c / (a * a + b * b)

	d = minimap_radius * minimap_radius - c * c / (a * a + b * b)
	mult = m_sqrt(d / (a * a + b * b))

	ax, ay, bx, by, ok = clampLine(pos1, pos2, Vector(x0 + b * mult, y0 - a * mult), Vector(x0 - b * mult, y0 + a * mult))

	if ok then
		sf_DrawLine(minimap_ctr_x + ax, minimap_ctr_y + ay,
					minimap_ctr_x + bx, minimap_ctr_y + by)
	end
end

local point_poses, pos1, pos2, pos3, pos4

local function drawCaptureZone()
	point_poses = capture:GetPoint().box

	pos1 = worldToMinimapUnclamped(point_poses[1])
	pos2 = worldToMinimapUnclamped(Vector(point_poses[1].x, point_poses[2].y, 0))
	pos3 = worldToMinimapUnclamped(point_poses[2])
	pos4 = worldToMinimapUnclamped(Vector(point_poses[2].x, point_poses[1].y, 0))

	sf_SetDrawColor(Color(0, 255, 0))

	drawMinimapLine(pos1, pos2)
	drawMinimapLine(pos2, pos3)
	drawMinimapLine(pos3, pos4)
	drawMinimapLine(pos4, pos1)

	drawMinimapLine(pos1, pos3)
	drawMinimapLine(pos2, pos4)
end









local participating_enemies = {}
local participating_allies = {}
timer.Create('HUD.Capture.CheckParticipatingPlayers', 3, 0, function()
	participating_enemies = {}
	participating_allies = {}

	capture = rp.Capture.GetCurrentCapture()
	if not capture then return end

	for _, v in ipairs(player.GetAll()) do
		if v ~= LocalPlayer() and capture:IsPlayerParticipating(v) then
			if attacker and capture:IsPointDefender(v) or defender and capture:IsPointAttacker(v) then
				table.insert(participating_enemies, v)
			else
				table.insert(participating_allies, v)
			end
		end
	end
end)

local next_find = 0
local found_pls = {}

local AirdropIcon = Material('stalker/icons/info_logo.png')
local AirdropColor = Color(150, 250, 150, 255)

local AirdropFactions = {
	[FACTION_MILITARY] = true,
	[FACTION_MILITARYS] = true,
}

local function drawWarMinimap()
	myPos = Vector(ply:GetPos().x, ply:GetPos().y, 0)

	myNorm = Vector(EyeVector().y, EyeVector().x, 0)
	myNorm = myNorm:Angle()

	sf_SetDrawColor(font_color)

	--sf_SetMat(minimap_bar)
	--sf_DrawTexturedRect(25, 0, 222, 163)

	myp = Vector(myPos.x / minimap_power, myPos.y / minimap_power)
	myp:Rotate(myNorm)

	render.SetScissorRect(minimap_ctr_x - minimap_width / 2, minimap_ctr_y - minimap_height / 2, minimap_ctr_x + minimap_width / 2, minimap_ctr_y + minimap_height / 2, true)
		sf_SetMat(map)
		sf_DrawTexturedRectRotated(minimap_ctr_x + minimap_offset_x - myp.x, minimap_ctr_y + minimap_offset_y + myp.y, minimap_texture_x, minimap_texture_y, -(EyeVector():Angle().yaw - 90))
	render.SetScissorRect(0, 0, 0, 0, false)

		-- Entities & Factions
		for _, v in ipairs(rp.Map.EntIcons) do
			if not v.dist or LocalPlayer():GetPos():DistToSqr(v.pos) <= v.dist then
				sf_SetMat(v.icon)

				pos = worldToMinimap(v.pos)
				sf_DrawTexturedRect(pos.x, pos.y, unit_size, unit_size)
			end
		end

		-- NPCs
		for _, v in ipairs(rp.Map.NPCIcons) do
			if not v.dist or LocalPlayer():GetPos():DistToSqr(v.pos) <= v.dist then
				sf_SetMat(v.icon)

				pos = worldToMinimap(v.pos)
				sf_DrawTexturedRect(pos.x, pos.y, unit_size, unit_size)
			end
		end

		if AirdropFactions[LocalPlayer():GetFaction()] then
			-- Airdrops
			for _, v in ipairs(rp.AirDropEnts) do
				if not IsValid(Entity(v.entIndex)) then continue end

				sf_SetMat(AirdropIcon)
				sf_SetDrawColor(AirdropColor)
				pos = worldToMinimap(v.pos)
				sf_DrawTexturedRect(pos.x, pos.y, unit_size, unit_size)
			end
		end

		-- Custom points
		for _, v in pairs(rp.Map.CustomPoints) do
			sf_SetMat(v.icon)
			sf_SetDrawColor(v.color)

			pos = worldToMinimap(v.pos)
			sf_DrawTexturedRect(pos.x, pos.y, unit_size, unit_size)
		end

	--drawAugIcons()

	-- Center
	sf_SetMat(unit_green)
	sf_SetDrawColor(font_color)
	sf_DrawTexturedRect(minimap_ctr_x - 4, minimap_ctr_y - 4, 8, 8)
end

local function drawBox(x, y, width, height, no_filled)
	surface.SetDrawColor(22, 22, 22, 255)

	surface.DrawRect(x, y, 2, height)
	surface.DrawRect(x + width - 2, y, 2, height)
	surface.DrawRect(x, y, width, 2)
	surface.DrawRect(x, y + height - 2, width, 2)

	if not no_filled then
		surface.SetDrawColor(39, 41, 38, 218)
		surface.DrawRect(x + 2, y + 2, width - 4, height - 4)
	end
end

local last_point
local last_alpha = 0
local last_point_time = 0

local ammo_icons = {
	['Pistol'] 		= { mat = Material("stalker_icons/pistol.png") },
	['Buckshot'] 	= { mat = Material("stalker_icons/buckshot.png") },
	['SMG1'] 		= { mat = Material("stalker_icons/smg1.png") },
	['smg1'] 		= { mat = Material("stalker_icons/smg1.png") },
	['AR2'] 		= { mat = Material("stalker_icons/ar2.png") },
	['ar2'] 		= { mat = Material("stalker_icons/ar2.png") },
	['357'] 		= { mat = Material("stalker_icons/357.png") },
	--['SniperPenetratedRound'] 	= { mat = Material("stalkerammo/pistol.png")},
	['Default'] 	= { mat = Material("stalker_icons/smg1.png")},
}


local weapon, weapon_ammo_data

hook.Add("HUDPaint", "NewStalkerHud", function()
	ply = LocalPlayer()
	if !(IsValid(ply) && ply:Alive()) then return end
	if cvar_Get(cvar_name) then return end

	scrW, scrH 	= ScrW(), ScrH()
	x 			= Lerp(0.1, x, maxX or 0)
	off_x 		= 0
	off_y 		= 0

	armor 		= m_min(ply:Armor(), rp.cfg.MaxArmor) / rp.cfg.MaxArmor
	maxsprint 	= ply:GetMaxStamina()
	sprint 		= ply:GetStamina() or 0
	restoring 	= ply:IsStaminaRestoring()
	time_left   = (ply:GetNetVar('LastDamageTime') or 0) + rp.cfg.StaminaRestoreTime - CurTime()
	mask 		= ply:GetDisguiseTime()

	weapon 				= ply:GetActiveWeapon()
	weapon_ammo_data	= IsValid(weapon) and weapon:GetPrimaryAmmoType() ~= -1 and (ammo_icons[game.GetAmmoName(weapon:GetPrimaryAmmoType())] or ammo_icons["Default"])
	ammo 		= nil

	sf_SetDrawColor( 255, 255, 255, 255 )


	-- Stamina
	/*
	if !restoring || sprint < maxsprint * 0.7 then
		sf_SetMat(stamina_core_bar)
		sf_DrawTexturedRect(scrW - hud_size_w, scrH - hud_size_h - x + off_y, hud_size_w, hud_size_h)

		render.SetScissorRect(0, 0, scrW - bar_offset_right - (bar_w - (bar_w - bar_sub_offset) * sprint / maxsprint), scrH, true)

		sf_SetMat(stamina_bar)
		sf_DrawTexturedRect(scrW - hud_size_w, scrH - hud_size_h - x + off_y, hud_size_w, hud_size_h)

		render.SetScissorRect(0, 0, 0, 0, false)
		draw.SimpleText(math.Round(time_left > 0 and time_left or 0), '1StalkerSubBarFont', scrW - bar_offset_right - 12 * k, scrH - hud_size_h - x + off_y + 27 * k, font_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		off_y = off_y + sub_bar_h_offset
	end

	maxX = off_y - 40
	*/


	-- right part
	drawBox(scrW - 234, scrH - 86, 204, 44)
	drawBox(scrW - 337, scrH - 86, 102, 44)

	drawBox(scrW - 337, scrH - 104, 307, 17, true)
	drawBox(scrW - 337, scrH - 112, 307, 9, true)
	drawBox(scrW - 337, scrH - 112, 307, 9, true)

	-- Stamina
	if !restoring || sprint < maxsprint * 0.7 then
		drawBox(scrW - 337, scrH - 120, 307, 9, true)

		surface.SetDrawColor(200, 140, 25, 255)
		surface.DrawRect(scrW - 335 + 303 - math.floor(303 * sprint / maxsprint), scrH - 118, 303 * sprint / maxsprint, 5)
	end

	-- Armor
	if armor > 0 then
		surface.SetDrawColor(60, 86, 117, 255)
		surface.DrawRect(scrW - 335 + 303 - math.floor(303 * armor), scrH - 110, 303 * armor, 5)
	end

	max_health = m_max(ply:Health(), m_min(200, ply:GetMaxHealth()))
	health = 1 - ply:Health() / max_health

	sf_SetMat(red_bar)
	surface.SetDrawColor(70, 70, 70, 255)
	sf_DrawTexturedRect(scrW - 335, scrH - 102, 303, 13)

	render.SetScissorRect(scrW - 335 + 303 * health, scrH - 102, scrW - 335 + 303, scrH - 102 + 13, true)

	surface.SetDrawColor(255, 255, 255, 255)
	sf_DrawTexturedRect(scrW - 335, scrH - 102, 303, 13)

	render.SetScissorRect(0, 0, 0, 0, false)

	draw.SimpleText(rp.FormatMoney(ply:GetMoney()), '1StalkerWalletFont', scrW - 44, scrH - 66, font_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


	drawBox(30, scrH - 240 - 34 + (rp.cfg.DisableMinimap and 198 or 0), 212, 36)
	draw.SimpleText(ply:GetJobName(), '1StalkerJobFont', 237, scrH - 240 - 34 + 16 + (rp.cfg.DisableMinimap and 198 or 0), font_color2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	if not rp.cfg.DisableMinimap then
		drawBox(30, scrH - 240, 212, 198)
		drawWarMinimap()
	end


	hunder = ply:GetHunger()

	if hunder < 50 then
		drawBox(scrW - 69, scrH - 152, 34, 34)

		surface.SetDrawColor(hunder == 0 and Color(190, 65, 65, 255) or Color(215, 170, 5, 255))
		surface.SetMaterial(hunger)
		surface.DrawTexturedRect(scrW - 63, scrH - 146, 22, 22)

		off_x = off_x + 39
	end

    local rad = ply:GetRadiation() or 0

	if rad > 20 then
		drawBox(scrW - 69 - off_x, scrH - 152, 34, 34)

		surface.SetDrawColor(rad >= 80 and Color(190, 65, 65, 255) or Color(215, 170, 5, 255))
		surface.SetMaterial(radiation)
		surface.DrawTexturedRect(scrW - 63 - off_x, scrH - 146, 22, 22)

		off_x = off_x + 39
	end

	/*
	hunder = ply:GetHunger() / 100 -- cur hunger / max hunger

	draw.SimpleText(ply:Health(), '1StalkerSubBarFont', scrW - bar_offset_right - 12 * k, scrH - hud_size_h + 69 * k, font_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	render.SetScissorRect(0, 0, scrW - bar_offset_right - (bar_w - bar_w * hunder), scrH, true)

	sf_SetMat(green_bar)
	sf_DrawTexturedRect(scrW - hud_size_w, scrH - hud_size_h, hud_size_w, hud_size_h)

	max_health = m_max(ply:Health(), m_min(200, ply:GetMaxHealth()))
	health = ply:Health() / max_health -- cur hunger / max hunger

	render.SetScissorRect(0, 0, scrW - bar_offset_right - (bar_w - (bar_w - bar_sub_offset) * health), scrH, true)

	sf_SetMat(red_bar)
	sf_DrawTexturedRect(scrW - hud_size_w, scrH - hud_size_h, hud_size_w, hud_size_h)

	render.SetScissorRect(0, 0, 0, 0, false)
	*/


	-- center
	if ply:GetNLRTime() and ply:GetNLRTime() > 0 and ply:InNLRZone() then
		draw.SimpleText('Покиньте NLR зону (' .. ply:GetNLRTime() .. ')', '1StalkerJobFont', 260, scrH - 60, font_red_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		off_y = off_y - 28
	end


	-- left part
	if LocalPlayerInsideGreenZone() then
		draw.SimpleText('МИРНЫЙ СЕКТОР', '1StalkerJobFont', 260, scrH - 60 + off_y, font_color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		off_y = off_y - 28
	end

	if LocalPlayer():GetCurrentPoint() then
		if last_point ~= LocalPlayer():GetCurrentPoint() then
			last_point = LocalPlayer():GetCurrentPoint()
			last_point_time = CurTime() + 4
		end


		draw.SimpleText(LocalPlayer():GetCurrentPoint().printName.." ("..rp.Capture.GetOwnerName(LocalPlayer():GetCurrentPoint().id)..")", '1StalkerJobFont', 260, scrH - 60 + off_y, font_color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		off_y = off_y - 28

	elseif last_alpha <= 0 then
		last_point = nil
	end

	last_alpha = math.Approach(last_alpha, last_point_time > CurTime() and 255 or 0, 2)

	if last_point then
		surface.SetDrawColor(ColorAlpha(font_color2, last_alpha))
		surface.SetMaterial(hud)
		surface.DrawTexturedRect(scrW / 2 - 21, scrH * 0.3 - 75, 50, 50)

		draw.SimpleText(last_point.printName, '1StalkerWalletFont', scrW / 2, scrH * 0.3, ColorAlpha(font_color, last_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(rp.Capture.GetOwnerName(last_point.id), '1StalkerWalletFont', scrW / 2, scrH * 0.3 + 30, ColorAlpha(font_color2, last_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if mask > 0 then
		draw.SimpleText('Маскировка (' .. mask .. ')', '1StalkerJobFont', 260, scrH - 60 + off_y, font_color2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	if IsValid(ply:GetActiveWeapon()) then
		weapon = ply:GetActiveWeapon()
		if weapon:Clip1() > 0 then
			ammo = weapon:Clip1() .. "/" .. ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
		end

		if weapon:GetSecondaryAmmoType() != -1 then
			if ammo then
				ammo = ammo .. "/" .. ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			else
				ammo = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())
			end
		end

		if !ammo && weapon:GetPrimaryAmmoType() != -1 then
			ammo = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
		end

		draw.SimpleText(ammo or '-', '1StalkerWalletFont', scrW - 286, scrH - 66, font_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if ammo and weapon_ammo_data then
			drawBox(scrW - 413, scrH - 112, 75, 70)

			sf_SetDrawColor(255, 255, 255, 255)
			sf_SetMat(weapon_ammo_data.mat)
			sf_DrawTexturedRect(scrW - 373 - 26, scrH - 75 - 26, 52, 52)
		end
	end
end)
