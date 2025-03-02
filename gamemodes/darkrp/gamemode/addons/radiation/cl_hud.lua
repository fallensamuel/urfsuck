-- "gamemodes\\darkrp\\gamemode\\addons\\radiation\\cl_hud.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————▬— U s e r —▬— I n t e r f a c e —▬——————————————————--

local W, H, LocalPly = ScrW, ScrH, LocalPlayer
local surface_SetMaterial, surface_SetDrawColor, surface_DrawTexturedRect, render_SetScissorRect = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect, render.SetScissorRect
local Colr, HSV2Col, CAlpha, CurrentTime = Color, HSVToColor, ColorAlpha, CurTime
local math_Clamp, math_floor, math_abs, math_sin = math.Clamp, math.floor, math.abs, math.sin

local icon = {
    fill = Material("radiation/fill.png", "smooth", "noclamp"),
    stroke = Material("radiation/stroke.png", "smooth", "noclamp")
}

local colors = {
    white = Color(255, 255, 255),
    black = Color(0, 0, 0),
    fill = function(rad)
        rad = math_Clamp(rad*1.2, 0, 120)
        return HSV2Col(120-rad, 1, 1)
    end
}

local scrScale = H()/1080

local where = {
    ["w"] = function()
        return 48*scrScale
    end,
    ["h"] = function()
        return 48*scrScale
    end
}
where["x"] = function()
    return W() - 32*scrScale - where["w"]()
end

local hud_offset = function()
    local ply = LocalPly()
    local maxsprint     = ply:GetMaxStamina()
    local sprint        = ply:GetStamina() or 0
    local restoring     = ply:IsStaminaRestoring()

    local o1 = (not restoring or sprint < maxsprint * 0.7) and 40 or 0
    local o2 = ply:Armor() > 0 and 40 or 0
    return o1 + o2
end
where["y"] = function()
    return H() - 180 - where["h"]() - hud_offset()
end

local DoStencil = function(x, y, w, h, callback)
    render_SetScissorRect(x, y, w, h, true)
        callback()
    render_SetScissorRect(0, 0, 0, 0, false)
end

local Pulsate = function(c) 
    return (math_abs(math_sin(CurrentTime()*c)))
end

/*
hook.Add("HUDPaint", "Radiation.Hud", function()
    local rad = LocalPly():GetRadiation()
    if rad <= 3 or not LocalPly():Alive() then return end

    scrScale = H()/1080

    local a, b, c, d = where["x"](), where["y"](), where["w"](), where["h"]()

    surface_SetMaterial(icon.stroke)
    surface_SetDrawColor(colors.black)
    surface_DrawTexturedRect(a, b, c, d)

    DoStencil(c, b + d - (d*0.01 * rad), W(), H(), function()
        surface_SetMaterial(icon.fill)
        surface_SetDrawColor( CAlpha(colors.fill(rad), 125 + 75*Pulsate(rad*0.035)) )
        surface_DrawTexturedRect(a, b, c, d)
    end)
end)
*/