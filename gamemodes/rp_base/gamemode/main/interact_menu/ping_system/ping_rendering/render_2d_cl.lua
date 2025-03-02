local framework = Nexus:ClassManager("Framework")
local _draw = framework:Class("Draw")
local anim = framework:Class("Animations")
local panels = framework:Class("Panels")

surface.CreateFont("Nexus.PingSystem.3D.Type", {
	font = "Montserrat",
	size = 24,
	weight = 800
})

surface.CreateFont("Nexus.PingSystem.3D.Cancel", {
	font = "Montserrat",
	size = 24,
	weight = 500
})

surface.CreateFont("Nexus.PingSystem.3D.CancelButton", {
	font = "Montserrat",
	size = 20,
	weight = 1200
})


surface.CreateFont("Nexus.PingSystem.3D.Dist", {
	font = "Montserrat",
	size = 20,
	weight = 500
})

function PIS:Render2D()
	local ply = LocalPlayer()
	local plyPos = ply:GetPos()

	local lookingAt = self:IsLookingAtPing()
	if (lookingAt) then
		local settings = PIS:GetSettings(ply)
		local ping = self.Pings[lookingAt.key]
		if (!IsValid(ping.author)) then
			PIS:RemovePing(lookingAt.key)
		end
		local pingTbl = self.Config.Pings[ping.ping]
		local tr = ply:GetEyeTrace()
		local hitPos = tr.HitPos
		hitPos = LocalToWorld(Vector(0, -50, -15), Angle(0, 0, 0), hitPos, ply:GetAngles())
		local sPos = ping.pos:ToScreen()
		local x = ScrW() / 2 + 75--100
		local y = ScrH() / 2 - 75--100
		local sX = sPos.x
		local sY = sPos.y

		local dist = plyPos:Distance(ping.pos)
		local distY = math.Clamp(dist * 0.5 >= 525 and dist * 0.5 - 525 or 0, 0, dist * 0.3)
		local scale = math.max(dist / 250, 1)
		local matSize = 128 * scale
		local matX = (matSize * -1) / 2
		local matY = -10 + matSize * -1
		matY =	math.abs(matY - (distY * math.Clamp(scale * 0.4, 0, 1.5)))
		local distModifier = ((ply:GetFOV() * 2) / dist)
		local matYOffset = matSize * 0.1 * distModifier + matY * 0.1 * distModifier
		draw.NoTexture()
		surface.SetDrawColor(color_black)
		local tbl = {
			{ x = sX, y = sY - matYOffset },
			{ x = sX + 50, y = sY - matYOffset - 50 },
			{ x = sX + 50, y = sY - matYOffset }
		}
		--surface.DrawPoly(tbl)
		--surface.DrawRect(sX, sY, 20, 20)

		surface.SetFont("Nexus.PingSystem.3D.Type")
		local tw, th = surface.GetTextSize(ping.directedAt and pingTbl.command .. " " or pingTbl.text)
		local dist = math.Round(plyPos:Distance(ping.pos) * (0.0254 / (4/3))) .. "m"
		surface.SetFont("Nexus.PingSystem.3D.Type")
		local _tw = surface.GetTextSize(dist)
		local height = 2
		local width = 10 + tw + _tw
		surface.SetFont("Nexus.PingSystem.3D.Cancel")
		local isLocalPlayer = LocalPlayer() == ping.author
		local cancelStr = isLocalPlayer and translates.Get("ОТМЕНИТЬ") or ping.author:Nick()
		local tw, th = surface.GetTextSize(cancelStr)
		local topWidth = 10 + tw + 5
		if (isLocalPlayer) then
			local _tw, th = surface.GetTextSize(PIS:GetKeyName(settings.InteractionKey))
			topWidth = topWidth + _tw + 10
		end
		local status = ping.status
		local str = status == PING_STATUS_CONFIRMED and translates.Get("Подтвержено") or translates.Get("Подтвердить - %s", PIS:GetKeyName(settings.InteractionKey))

		surface.SetFont("Nexus.PingSystem.3D.Type")
		if (ping.directedAt == LocalPlayer()) then
			local str = status == PING_STATUS_CONFIRMED and translates.Get("Подтвержено") or translates.Get("Подтвердить - %s" .. PIS:GetKeyName(settings.InteractionKey))
			local _tw, th = surface.GetTextSize(str)

			topWidth = topWidth + _tw + (isLocalPlayer and -10 or 10)
		elseif (ping.directedAt) then
			local str = status == PING_STATUS_CONFIRMED and translates.Get("Подтвержено") or translates.Get("Отменено")
			local _tw, th = surface.GetTextSize(str)

			topWidth = topWidth + _tw + (isLocalPlayer and -10 or 10)
		end
		width = math.max(topWidth, width)
		local lineX = x

		surface.SetFont("Nexus.PingSystem.3D.Type")
		
		local commandStr = (ping.directedAt and pingTbl.command .. " " or pingTbl.text)
		local tw, th = surface.GetTextSize(commandStr)
		_draw:Call("ShadowText", commandStr, "Nexus.PingSystem.3D.Type", x, y + 4, pingTbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		if (ping.directedAt) then
			local _tw = surface.GetTextSize(ping.directedAt:Nick())
			local col = ping.status == PING_STATUS_DEFAULT and Color(215, 215, 215)
				or ping.status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green
				or ping.status == PING_STATUS_REJECTED and PIS.Config.Colors.Red
			_draw:Call("ShadowText", ping.directedAt:Nick(), "Nexus.PingSystem.3D.Type", x + tw, y + 4, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			tw = tw + _tw
		end
		_draw:Call("ShadowText", dist, "Nexus.PingSystem.3D.Dist", x + tw + 5, y + 4 + 2, pingTbl.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		surface.SetFont("Nexus.PingSystem.3D.Cancel")
		local _tw = surface.GetTextSize(cancelStr)
		_draw:Call("ShadowText", cancelStr, "Nexus.PingSystem.3D.Cancel", x, y - 4, Color(215, 215, 215), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		if (!isLocalPlayer) then
			x = x + _tw + 5
		end

		surface.SetFont("Nexus.PingSystem.3D.Type")
		local tw, th = surface.GetTextSize(cancelStr)
		local _tw, _th = surface.GetTextSize(PIS:GetKeyName(settings.InteractionKey))
		local __tw, __th = surface.GetTextSize(cancelStr)
	
		if (isLocalPlayer) then
			x = x + tw + 5
			draw.RoundedBox(6, x, math.ceil(y - 4 - th), _tw + 8, th, Color(215, 215, 215))
			draw.SimpleText(PIS:GetKeyName(settings.InteractionKey), "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - th / 2 - 4, Color(62, 62, 62), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			x = x + _tw + 8 + 5
		end

		if (ping.directedAt == LocalPlayer()) then
			local status = ping.status
			local str = status == PING_STATUS_CONFIRMED and translates.Get("Подтвержено") or translates.Get("Подтвердить - %s" .. PIS:GetKeyName(settings.InteractionKey))
			local col = status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green or Color(183, 183, 183)
			local textCol = color_black

			local _tw, th = surface.GetTextSize(str)

			draw.RoundedBox(6, x, math.ceil(y - 4 - __th), _tw + 8, __th, col)
			draw.SimpleText(str, "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - __th / 2 - 4, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			x = x + _tw + 5
		elseif (ping.directedAt) then
			local status = ping.status
			local str = status == PING_STATUS_CONFIRMED and translates.Get("Подтвержено") or translates.Get("Отменено")
			local col = status == PING_STATUS_CONFIRMED and PIS.Config.Colors.Green or PIS.Config.Colors.Red
			local textCol = status == PING_STATUS_CONFIRMED and Color(222, 222, 222) or color_black

			local _tw, th = surface.GetTextSize(str)

			draw.RoundedBox(6, x, math.ceil(y - 4 - __th), _tw + 8, __th, col)
			draw.SimpleText(str, "Nexus.PingSystem.3D.CancelButton", x + _tw / 2 + 4, y - __th / 2 - 4, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			x = x + _tw + 5
		end

		draw.RoundedBox(0, lineX - 5, y, width, height, pingTbl.color)
	end
end

hook.Add("HUDPaint", "PIS.RenderPings", function()
	--if not PIS or not PIS.Render2D then return end
	--PIS:Render2D()
end)

hook.Add("PostDrawHUD", "PIS.RenderOffscreenPings", function()
	local settings = PIS:GetSettings(LocalPlayer())
	if (settings.PingOffscreen == 3) then return end

	for i, v in pairs(PIS.Pings) do
		local ping = PIS.Config.Pings[v.ping]
		if (!ping) then continue end
		if (settings.PingOffscreen == 2 and v.directedAt != LocalPlayer()) then continue end
		local mat = PIS:GetPingIcon(v.ping)
		local col = ping.color
		local pos = v.pos
		local sPos = pos:ToScreen()
		local x = sPos.x
		local y = sPos.y

		local size = 64

		local drawPing

		if (x < -50) then
			drawPing = true
		elseif (y < -20) then
			drawPing = true
		elseif (y > ScrH() + 80) then
			drawPing = true
		elseif (x > ScrW() + 50) then
			drawPing = true
		end

		if (!drawPing) then continue end

		local x = math.Clamp(x - size / 2, 16, ScrW() - 16 - size)
		local y = math.Clamp(y, 16, ScrH() - size - 16)

		_draw:Call("BlurHUD", x - 2, y - 2, size + 2, size)

		surface.SetMaterial(mat)
		surface.SetDrawColor(0, 0, 0, 255)
		for i = 1, 3 do
			surface.DrawTexturedRect(x - 1, y - 1, size + 2, size + 2)
		end
		surface.SetDrawColor(col)
		surface.DrawTexturedRect(x, y, size, size)
	end
end)



material_cache = material_cache or {}
local function CahceMaterial(path)
    if material_cache[path] then return material_cache[path] end

    material_cache[path] = Material(path, "smooth", "noclamp")
    return material_cache[path]
end


InteractHints = InteractHints or {}

local cam_Start3D2D, cam_End3D2D, surface_SetDrawColor, surface_DrawRect, math_Approach, FrameTime_, draw_SimpleText, LocalPlayer_, ColorAlpha_, CurTime_, timer_Simple, IsValid_, surface_DrawTexturedRect, ColoR, color_white_, Vector_, Angle_, draw_NoTexture = cam.Start3D2D, cam.End3D2D, surface.SetDrawColor, surface.DrawRect, math.Approach, FrameTime, draw.SimpleText, LocalPlayer, ColorAlpha, CurTime, timer.Simple, IsValid, surface.DrawTexturedRect, Color, color_white, Vector, Angle, draw.NoTexture
local pairs_ = pairs
local TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP = TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP
local timer = timer

surface.CreateFont("InteractHint_Medium", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 32,
    weight = 500
})

surface.CreateFont("InteractHint_Small", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 28,
    weight = 540
})

local zeroAng, zeroVec = Angle(0, 0, 0), Vector(0, 0, 0)

local DrawInfoBubble
local UseIcon = Material("rpui/misc/keybutton.png", "smooth", "noclamp") --"ping_system/e_key.png"
local ECol = ColoR(0, 0, 0)

local DrawTheKeyWord = function(x, y, w, h, colr)
	draw_SimpleText("E", "InteractHint_Small", x + 8, y + 4, colr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

local function DrawInteractHint(is3dcontext)
	if rpSupervisor and rpSupervisor.ID > 0 then return end
	
    local tr_ent = LocalPlayer_():GetEyeTrace().Entity
	
    DrawInfoBubble = DrawInfoBubble or rp.DrawInfoBubbleLeft
    if not DrawInfoBubble then return end

    for key, tab in pairs_(InteractHints) do
        if not tab.toremove then
        	if not IsValid_(tr_ent) or not IsValid_(tab.ent) or tr_ent ~= tab.ent or (tab.ent:GetPos():DistToSqr(LocalPlayer_():GetPos()) > 15625) or tab.ent:GetNoDraw() then
	            tab.toremove = true
	            timer.Simple(1, function()
	                local tr_ent = LocalPlayer_():GetEyeTrace().Entity
	                if not IsValid_(tr_ent) or not IsValid_(tab.ent) or tr_ent ~= tab.ent or (tab.ent:GetPos():DistToSqr(LocalPlayer_():GetPos()) > 15625) or tab.ent:GetNoDraw() then
	                    tab.ToHide = true
	                else
	                    tab.ToHide = nil
	                    tab.toremove = nil
	                end
	            end)
	        end
        end

        tab.alpha = math_Approach(tab.alpha or 0, (tab.ToHide and -1 or 255), FrameTime_()*300)

        if tab.alpha < 0 then
            InteractHints[tab.uid] = nil
            return
        end

        if not IsValid(tab.ent) or not tab.pos or not tab.ang then continue end--or not tab.draw then continue end
        local TxtCol = ColorAlpha_(ECol, tab.alpha)

        local F = (tab.ent.DrawLeftBubble or tab.ent:IsInFovOf(LocalPlayer())) and rp.DrawInfoBubbleLeft or rp.DrawInfoBubbleRight
        if is3dcontext then
        	cam_Start3D2D(tab.pos(tab) or zeroVec, tab.ang(tab) or zeroAng, 0.01)
        	    F(tab.alpha, UseIcon, nil, function(x, y, w, h)
        	    	DrawTheKeyWord(x, y, w, h, TxtCol)
        	    end)
        	cam_End3D2D()
        else
        	local screenPos = (tab.pos(tab) or zeroVec):ToScreen()
        	F(tab.alpha, UseIcon, screenPos, function(x, y, w, h)
        		DrawTheKeyWord(x, y, w, h, TxtCol)
        	end)
        end
    end
end

hook.Add("PreDrawEffects", "RenderInteractHint.3DContext", function()
	if not rp.cfg.BubbleRended3D2D then return end
	DrawInteractHint(true)
end)

hook.Add("HUDPaint", "RenderInteractHint.2DContext", function()
	if rp.cfg.BubbleRended3D2D then return end
	DrawInteractHint()
end)

local function AddInteractHint(ent, pos, ang, time)--, draw, time)
    if not IsValid_(ent) or (ent:GetNoDraw() and not (ba and ba["ToggleShowInvisible"])) then return end

    local uid = ent:EntIndex()
    if InteractHints[uid] then return end

    ent.HoverStart = nil

    InteractHints[uid] = {
        ["ent"] = ent,
        ["pos"] = pos,
        ["ang"] = ang,
        ["uid"] = uid
        --["draw"] = draw
    }

    if not time then return end

    timer_Simple(time, function()
        InteractHints[uid] = nil
    end)
end

local hit_check_delay, hit_check = 0

local VecOffset = Vector(-6, 0, 4)

local ThinkPlayerHint = function(ply)
	--print(ply, ply:DrawLeftBubble())
	if not IsValid(ply) or not (ply:IsPlayer() or ply.DrawLeftBubble and ply:DrawLeftBubble()) then return end

    if ply:GetPos():DistToSqr(LocalPlayer_():GetPos()) > 15625 then return end

	if not ply.DrawLeftBubble then
		if not ply.HoverStart or ply.HoverStart + 3 < CurTime_() then
			ply.HoverStart = CurTime_()
		end

		if (ply.HoverStart + 1.5 > CurTime_()) then return end
	end
	
    AddInteractHint(ply, function(tab)
    	if not IsValid(tab.ent) then return Vector(0, 0, 0) end

    	local bone_id = tab.ent:LookupBone("ValveBiped.Bip01_Head1")

    	if bone_id then
    		local pos = tab.ent:GetBonePosition(bone_id)
    		return pos - tab.ent:EyeAngles():Right()*8
    	end

		if tab.ent.DrawLeftBubble then
			--print(tab.ent:DrawLeftBubble() or Vector(0, 0, 0))
			return tab.ent:DrawLeftBubble() or Vector(0, 0, 0)
		end
		
        return tab.ent:LocalToWorld( Vector(0, tab.ent:OBBMaxs().y*0.25, tab.ent:OBBMaxs().z*0.925) )--(bone_id and tab.ent:GetBonePosition(bone_id) or tab.ent:LocalToWorld( Vector(48, 0, tab.ent:OBBMaxs().z) ))-- + VecOffset
    end, function(tab)
        return IsValid(tab.ent) and tab.ent:GetAngles()--:LocalToWorldAngles(Angle(0, LocalPlayer_():EyeAngles().y - 90, 90))
    end)

    --[[, function(tab)

        local col = ColorAlpha_(color_white_, tab.alpha)

        local txt1_x, txt1_y = draw_SimpleText("Зажмите", "InteractHint_Medium", 64, -48, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        surface_SetDrawColor(col)
        --draw_NoTexture()
        surface.SetMaterial(CahceMaterial("ping_system/e_key.png"))
        surface_DrawTexturedRect(72 + txt1_x, -48, txt1_y, txt1_y)

        draw_SimpleText("E", "InteractHint_Small", 72 + txt1_x + txt1_y/3, -48 + txt1_y/3, ColorAlpha_(ColoR(0, 0, 0), tab.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw_SimpleText("Что-бы взаимодействовать", "InteractHint_Small", 64, -48 + txt1_y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
]]--
--[[
        surface_SetDrawColor(col)
        draw.NoTexture()
        surface_DrawTexturedRect(64, 0, 32, 32)
        draw_SimpleText("E", "InteractHint_Small", 64, 0, ColorAlpha_(ColoR(0, 0, 0), tab.alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    end
]]--
end

hook.Add("Think", "Show_PlayerIntecract_Hint", function()
	--PrintTable(GetThirdPersonTrace())
    local tr_ply = LocalPlayer_():GetEyeTrace().Entity
    ThinkPlayerHint(tr_ply)
end)