-- "gamemodes\\darkrp\\entities\\entities\\base_simpleprinter\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Material = Material
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local draw_DrawText = draw.DrawText
local net_Receive = net.Receive
local net_ReadTable = net.ReadTable
local net_ReadEntity = net.ReadEntity
local net_ReadFloat = net.ReadFloat
local include = include
local surface_CreateFont = surface.CreateFont
local table_insert = table.insert
local LocalPlayer = LocalPlayer
local FrameTime = FrameTime
local string_match = string.match
local Angle = Angle
local IsValid = IsValid
local ParticleEmitter = ParticleEmitter
local math_random = math.random
local Vector = Vector
local math_Rand = math.Rand
local hook_Add = hook.Add
local table_remove = table.remove
local math_Approach = math.Approach
local RealFrameTime = RealFrameTime
local math_Round = math.Round
local math_Clamp = math.Clamp
local CurTime = CurTime
local cam_Start3D2D = cam.Start3D2D
local Color = Color
local surface_DrawRect = surface.DrawRect
local string_Comma = string.Comma
local cam_End3D2D = cam.End3D2D
local GetRenderTarget = GetRenderTarget
local CreateMaterial = CreateMaterial
local render_PushRenderTarget = render.PushRenderTarget
local cam_Start2D = cam.Start2D
local render_Clear = render.Clear
local render_SetScissorRect = render.SetScissorRect
local render_OverrideAlphaWriteEnable = render.OverrideAlphaWriteEnable
local render_ClearDepth = render.ClearDepth
local cam_End2D = cam.End2D
local render_PopRenderTarget = render.PopRenderTarget


include("shared.lua")

surface_CreateFont( "SimplePrinter_SmallFont", {
    font = "EuropaNuovaExtraBold",
    size = 25,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

surface_CreateFont("SimplePrinter_MedFont", {
    font = "EuropaNuovaExtraBold",
    size = 44,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
})

rp.client = rp.client or {}
rp.client.printers = rp.client.printers or {}
local boost_icon = Material("ping_system/boost.png", "smooth noclamp")
local particle_material = {
    "particles/smokey",
    "sprites/orangelight1",
    "particles/fire1",
}

function ENT:Initialize()
    self.fanAng = 0

    self.InterfaceOffset = self.InterfaceOffset or 0

    self.smCurAmount = 0
    self.smAlpha = 0

    table_insert(rp.client.printers, self)
    self.m_bInitialized = true
    self.m_Maxs = self:OBBMaxs()
    self.m_Maxz = self.m_Maxs[3]
    self.m_Center = self:OBBCenter()
    self.m_Color = {245, 245, 245}
    self.m_PrinterSpeed = self.PrinterSpeed
end

net_Receive("cl_printer_boost", function()
    local ent = net_ReadEntity()
    ent.m_Color = net_ReadTable()
    ent.m_PrinterSpeed = net_ReadFloat()
end)

function ENT:Think()
    if not self.m_bInitialized then
        self:Initialize()
    end

    if LocalPlayer():GetPos():Distance(self:GetPos()) < 500 and self:GetIsWorking() then
        self.fanAng = self.fanAng + (FrameTime() * 400)

        for i = 0 , self:GetBoneCount() - 1 do
            if string_match( self:GetBoneName(i), "fan" ) ~= nil then
                self:ManipulateBoneAngles(i,Angle(self.fanAng,0,0))
            end
        end
    end
end

local pr, tr, ent

function ENT:Draw()
    if not IsValid(self.FireEmitter) then
        self.FireEmitter = ParticleEmitter(vector_origin, false)
    end

    self:DrawModel()

    if self:GetIsFiring() then
        local random_x = math_random(self.m_Maxs[1], -self.m_Maxs[1]) + math_random(-10, 10)
        local random_y = math_random(self.m_Maxs[2], -self.m_Maxs[2]) + math_random(-10, 10)
        local pos = self:LocalToWorld(self:OBBCenter() + Vector(random_x, random_y, self.m_Maxs.z * 0.5))
        self.FireEmitter:SetPos(pos)

        local fire_percent = self:GetFirePercent()
        if fire_percent < 40 then
            local particle = self.FireEmitter:Add(particle_material[1], pos)

            if particle then
                particle:SetVelocity(Vector(0, 0, 30))
                particle:SetDieTime(math_Rand(0.3, 0.7))
                particle:SetStartAlpha(math_Rand(10, 60))
                particle:SetEndAlpha(0)
                particle:SetStartSize(math_random(4, 7))
                particle:SetEndSize(math_Rand(9, 15))
                particle:SetRoll(math_Rand(180, 480))
                particle:SetRollDelta(math_Rand(-1, 1))
                particle:SetColor(30, 30, 30)
                particle:SetAirResistance(1)
            end
        elseif fire_percent >= 40 and fire_percent < 80 then
            local particle = self.FireEmitter:Add(particle_material[2], pos)

            if particle then
                particle:SetVelocity(Vector(0, 0, 30))
                particle:SetDieTime(math_Rand(0.3, 0.7))
                particle:SetStartAlpha(math_Rand(60, 120))
                particle:SetEndAlpha(0)
                particle:SetStartSize(math_random(4, 7))
                particle:SetEndSize(math_Rand(9, 15))
                particle:SetRoll(math_Rand(180, 480))
                particle:SetRollDelta(math_Rand(-1, 1))
                particle:SetColor(90, 90, 150)
                particle:SetAirResistance(1)
            end
        elseif fire_percent >= 80 then
            local particle = self.FireEmitter:Add(particle_material[3], pos)

            if particle then
                particle:SetVelocity(Vector(0, 0, 30))
                particle:SetDieTime(math_Rand(0.3, 0.7))
                particle:SetStartAlpha(math_Rand(10, 60))
                particle:SetEndAlpha(0)
                particle:SetStartSize(math_random(4, 7))
                particle:SetEndSize(math_Rand(9, 15))
                particle:SetRoll(math_Rand(180, 480))
                particle:SetRollDelta(math_Rand(-1, 1))
                particle:SetColor(30, 30, 30)
                particle:SetAirResistance(1)
            end
        end

        self.FireEmitter:Finish()
    end
end

hook_Add("PreDrawEffects", "SimplePrinters.Draw3D2D", function()
    tr = LocalPlayer():GetEyeTraceNoCursor()

    for i = 1, #(rp.client.printers or {}) do
        ent = rp.client.printers[i]

        if not IsValid(ent) then table_remove(rp.client.printers, i) break end
        if ent:GetIsFiring() then continue end
        if not ent.smAlpha then continue end
        ent.smAlpha = math_Approach(ent.smAlpha, IsValid(tr.Entity) and tr.Entity == ent and 1 or 0, RealFrameTime() * 4.5)
        if ent.smAlpha < 0 then return end

        local pos = ent:LocalToWorld(ent.m_Center) + vector_up * 35 + Vector(0, 0, ent.m_Maxz * 0.3)

        ent.smCurAmount = math_Round(math_Approach(ent.smCurAmount, ent:GetCurAmount() or 0, 0.1 / RealFrameTime()))
        pr = ent:GetIsWorking() and 1 - math_Clamp((ent:GetNextPrint() - CurTime()) / ent.m_PrinterSpeed, 0, 1) or 1

        cam_Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.11)
            draw_DrawText(IsValid(ent:Getowning_ent()) and ent:Getowning_ent():Name() or "Unknown", "SimplePrinter_MedFont", 0, 0, Color(245, 245, 245, 255 * ent.smAlpha), TEXT_ALIGN_CENTER)

            surface_SetDrawColor(0, 0, 0, 100 * ent.smAlpha)
            surface_DrawRect(-170, 50, 340, 40)

            surface_SetDrawColor(ent.m_Color[1], ent.m_Color[2], ent.m_Color[3], 255 * ent.smAlpha)
            surface_DrawRect(-169, 51, pr * 338, 38)

            if ent:GetIsBoosted() then
                surface_SetDrawColor(ent.m_Color[1], ent.m_Color[2], ent.m_Color[3], 255 * ent.smAlpha)
                surface_SetMaterial(boost_icon)
                surface_DrawTexturedRect(-170, 100, 50, 50)

                draw_DrawText(ent:GetBoostDuration() .. " СЕК", "SimplePrinter_SmallFont", -120, 110, Color(255, 255, 255,  255 * ent.smAlpha), TEXT_ALIGN_LEFT)
            end

            draw_DrawText(ent.ResourceName == false and rp.FormatMoney(ent.smCurAmount) or (string_Comma(ent.smCurAmount) .. " " .. (ent.ResourceName or "???")), "SimplePrinter_SmallFont", 0, 56,  Color(0, 0, 0, 255 * ent.smAlpha), TEXT_ALIGN_CENTER)
        cam_End3D2D()
    end
end)

local icon_mat = Material("ping_system/fire.png", "smooth noclamp")
local rt_printer = GetRenderTarget("rt_printer", 256, 256)
local printer_mat = CreateMaterial("printer_icon_mat", "UnlitGeneric", {
    ["$basetexture"] = rt_printer:GetName(),
    ["$basetexturetransform"] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
    ["$ignorez"] = 1,
    ["$translucent"] = 1,
})

local function updateIcon(printer)
    local fire_percent = 1 - (printer:GetFirePercent() * 0.01)

    render_PushRenderTarget(rt_printer)
        cam_Start2D()
            render_OverrideAlphaWriteEnable(true, true)
            render_ClearDepth()
            render_Clear(0, 0, 0, 0)

            surface_SetMaterial(icon_mat)
            surface_SetDrawColor(255, 255, 255)
            surface_DrawTexturedRect(0, 0, 256, 256)

            render_SetScissorRect(0, fire_percent * 256, 256, 256, true)
                surface_SetDrawColor(255, 123, 0)
                surface_DrawTexturedRect(0, 0, 256, 256)
            render_SetScissorRect(0, 0, 0, 0, false)

            render_OverrideAlphaWriteEnable(false)
        cam_End2D()
    render_PopRenderTarget()
end

ENT.IconMaterial = function(printer)
    updateIcon(printer)
    return printer_mat
end
