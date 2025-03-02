
local smallLabelColor = Color(255, 255, 255)
local bigLabelColor = Color(255, 255, 255)
local bigLabelColorRed = Color(170, 0, 0)
local ColorSup = ui.col.SUP
ColorSup.a = 150

local rd_SetMaterial 		= render.SetMaterial
local rd_DrawQuad 			= render.DrawQuad
local dr_Text 				= draw.SimpleText
local sf_SetDrawColor 		= surface.SetDrawColor
local sf_SetMaterial 		= surface.SetMaterial
local rd_SetScissorRect 	= render.SetScissorRect
local sf_DrawTexturedRect 	= surface.DrawTexturedRect
local sf_DrawRect 			= surface.DrawRect
local sf_DrawPoly 			= surface.DrawPoly
local dr_NoTexture 			= draw.NoTexture

local capture, attacker, defender, point, pos1, pos2, pos3, pos4, dist
local cur_x, cur_y

local LocalPlayer 	= LocalPlayer
local DistToSqr 	= DistToSqr
local Vector	 	= Vector
local Lerp	 		= Lerp


local Dist	 	= math.Distance
local m_Clamp 	= math.Clamp
local m_floor 	= math.floor
local m_max 	= math.max

local tb_insert = table.insert

local color1 		= Color(30, 30, 255, 255)
local color2 		= Color(255, 30, 30, 255)
local color_neutral = Color(255, 255, 255, 255)

local duga_bg = Material('capture/duga_bg.png')
local duga = Material('capture/duga_1.png')

local saved_time, saved_text, saved_prog, saved_table, saved_pos

local draw_data, color, ct1, ct2, nm1, nm2
local zoneGradientMat = CreateMaterial("capturegradient", "UnlitGeneric", 
{
    ["$basetexture"] = "gui/gradient",
    ["$translucent"] = 1,
    ["$vertexalpha"] = 1,
    ["$vertexcolor"] = 1,
})

local rect_poly 	= {}
local rect_quality 	= 20

local function build_rect_poly()
	table.insert(rect_poly, Vector(0, 0))
	
	for i = 0, rect_quality / 2 do
		table.insert(rect_poly, Vector(i * (80 / rect_quality), -40))
	end
	
	for i = 1, rect_quality do
		table.insert(rect_poly, Vector(40, i * (80 / rect_quality) - 40))
	end
	
	for i = 1, rect_quality do
		table.insert(rect_poly, Vector(40 - i * (80 / rect_quality), 40))
	end
	
	for i = 1, rect_quality do
		table.insert(rect_poly, Vector(-40, 40 - i * (80 / rect_quality)))
	end
	
	for i = 1, rect_quality / 2 do
		table.insert(rect_poly, Vector(i * (80 / rect_quality) - 40, -40))
	end
end
build_rect_poly()

local function drawCaptureState(capture)
	point 	= capture:GetPoint()
	dist 	= LocalPlayer():GetPos():DistToSqr(point.flag_pos)
	
	rp.Capture.CheckFlagEntity(point) 
	
	if dist > 3000000 then
		local pos = (point.flag_pos + Vector(0, 0, 300)):ToScreen()
		need_x, need_y = pos.x, pos.y
		
		need_x = m_Clamp(need_x, 150, ScrW() - 150)
		need_y = m_Clamp(need_y, 150, ScrH() - 150)
	else
		need_x, need_y = ScrW() / 2, 150
	end
	
	cur_x = Lerp(0.4, cur_x or ScrW() / 2, need_x)
	cur_y = Lerp(0.4, cur_y or 300, need_y)
	
	sf_SetDrawColor(0, 0, 0, 100)
	sf_DrawRect(cur_x - 45, cur_y - 45, 90, 90)
	
	
	sf_SetDrawColor(255, 255, 255, 255)
	
	
	ct1 = color1
	ct2 = color2
	
	nm1 = capture:GetDefender()
	nm2 = capture:GetAttacker()
	
	if capture:IsOrg() then
		ct1 = rp.orgs.Colors[capture:GetDefender()] or ct1
		ct2 = rp.orgs.Colors[capture:GetAttacker()] or ct2
		
	else
		if LocalPlayer():GetAlliance() == nm1 then
			ct1 = color1
			ct2 = color2
			
		else
			ct1 = color2
			ct2 = color1
		end
		
		nm1 = rp.Capture.Alliances[nm1].printName
		nm2 = rp.Capture.Alliances[nm2].printName
	end
	
	
	sf_SetMaterial(duga_bg)
	sf_DrawTexturedRect(cur_x - 45, cur_y - 86, 90, 20)
	
	color = IsValid(point.flag_ent) and (point.flag_ent.State == 0 and ct1 or ct2) or color_neutral
	
	sf_SetMaterial(duga)
	
	rd_SetScissorRect(cur_x - 45 + 90 * capture:GetScore(), cur_y - 86, cur_x + 45, cur_y - 66, true)
		sf_SetDrawColor(ct1)
		sf_DrawTexturedRect(cur_x - 45, cur_y - 86, 90, 20)
	rd_SetScissorRect(cur_x - 45, cur_y - 86, cur_x - 45 + 90 * capture:GetScore(), cur_y - 66, true)
		sf_SetDrawColor(ct2)
		sf_DrawTexturedRect(cur_x - 45, cur_y - 86, 90, 20)
	rd_SetScissorRect(0, 0, 0, 0, false)
	
	dr_NoTexture()
	
	if IsValid(point.flag_ent) then
		local progress = 1
		
		if point.flag_ent.Progress then
			if point.flag_ent.TimeRemain > 0 then 
				if point.flag_ent.CurState then
					progress = point.flag_ent.Progress * m_max(0, (point.flag_ent.TimeRemain - CurTime()) / point.flag_ent.TimeDone)
				else 
					progress = 1 - point.flag_ent.Progress * m_max(0, (point.flag_ent.TimeRemain - CurTime()) / point.flag_ent.TimeDone)
				end
			else
				if point.flag_ent.CurState then
					progress = point.flag_ent.Progress
				else 
					progress = 1 - point.flag_ent.Progress
				end
			end
		end
		
		if saved_prog ~= m_floor((1 + 4 * rect_quality) * progress) or saved_pos ~= Vector(cur_x, cur_y) then
			local temp 	= {}
			saved_prog 	= m_floor((1 + 4 * rect_quality) * progress)
			saved_pos 	= Vector(cur_x, cur_y)
			
			for i = 1, 1 + saved_prog do
				tb_insert(temp, { x = cur_x + rect_poly[i].x, y = cur_y + rect_poly[i].y })
			end
			
			saved_table = temp
		end
		
		sf_SetDrawColor(color)
		sf_DrawPoly(saved_table)
	end
	
	sf_SetDrawColor(10, 10, 10, 255)
	sf_DrawRect(cur_x - 35, cur_y - 35, 70, 70)
	
	if saved_time ~= rp.Capture.GetRemainingTime() then
		saved_time = rp.Capture.GetRemainingTime()
		saved_text = string.FormattedTime(saved_time, "%02i:%02i")
	end
	
	dr_Text(point.printName, "CaptureSmall", cur_x, cur_y + 60, smallLabelColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	dr_Text(nm1, "CaptureBig", cur_x - 9, cur_y - 58, ct1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	dr_Text('x', "CaptureBig", cur_x, cur_y - 58, smallLabelColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	dr_Text(nm2, "CaptureBig", cur_x + 9, cur_y - 58, ct2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	dr_Text(saved_text, "CaptureSmall", cur_x, cur_y, smallLabelColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint", "rp.Capture.DrawHud", function() 
	capture 	= rp.Capture.GetCurrentCapture() 
	draw_data 	= nil
	
	if not capture or not capture:IsPlayerParticipating(LocalPlayer()) then return end 
	
	attacker = capture:IsPointAttacker(LocalPlayer()) 
	defender = capture:IsPointDefender(LocalPlayer()) 
	
	point = capture:GetPoint()
	
	if attacker or defender then 
		dist = LocalPlayer():GetPos():DistToSqr(point.flag_pos)
		
		drawCaptureState(capture)
		if dist > 12250000 then return end
		
		draw_data = 
		{
			pos1 = point.box[1], 
			pos2 = Vector(point.box[2].x, point.box[1].y, point.box[1].z), 
			pos3 = Vector(point.box[2].x, point.box[2].y, point.box[1].z), 
			pos4 = Vector(point.box[1].x, point.box[2].y, point.box[1].z)
		}
	end
end)

hook.Add("PostDrawTranslucentRenderables", "rp.Capture.DrawZone", function()
	if draw_data then
		pos1 = draw_data.pos1
		pos2 = draw_data.pos2
		pos3 = draw_data.pos3
		pos4 = draw_data.pos4
		
		rd_SetMaterial(zoneGradientMat)
		
		rd_DrawQuad(pos1, pos1 + Vector(0, 0, 15), pos2 + Vector(0, 0, 15), pos2, ColorSup)
		rd_DrawQuad(pos2, pos2 + Vector(0, 0, 15), pos1 + Vector(0, 0, 15), pos1, ColorSup)
		
		rd_DrawQuad(pos2, pos2 + Vector(0, 0, 15), pos3 + Vector(0, 0, 15), pos3, ColorSup)
		rd_DrawQuad(pos3, pos3 + Vector(0, 0, 15), pos2 + Vector(0, 0, 15), pos2, ColorSup)
		
		rd_DrawQuad(pos3, pos3 + Vector(0, 0, 15), pos4 + Vector(0, 0, 15), pos4, ColorSup)
		rd_DrawQuad(pos4, pos4 + Vector(0, 0, 15), pos3 + Vector(0, 0, 15), pos3, ColorSup)
		
		rd_DrawQuad(pos4, pos4 + Vector(0, 0, 15), pos1 + Vector(0, 0, 15), pos1, ColorSup)
		rd_DrawQuad(pos1, pos1 + Vector(0, 0, 15), pos4 + Vector(0, 0, 15), pos4, ColorSup)
	end
end)


/*
hook.Add('rp.Capture.Started', 'rp.Capture.HudHandler', function(capt)
	if not capt or not capt:IsPlayerParticipating(LocalPlayer()) then return end 
	
	-- Create clientside models ?
	
	hook.Add("PostPlayerDraw", "rp.Capture.PlayerDraw", function(ply)
		if not capture or not capture:IsPlayerParticipating(LocalPlayer()) or not capture:IsPlayerParticipating(ply) then return end 
		
		
	end)
	
end)
*/


