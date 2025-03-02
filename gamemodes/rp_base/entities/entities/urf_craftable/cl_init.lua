include("shared.lua")

local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local math_Approach = math.Approach
local draw_Blur = draw.Blur
local surface_GetTextSize = surface.GetTextSize
local draw_RoundedBox = draw.RoundedBox
local surface_DrawLine = surface.DrawLine
local color_green = Color(127, 255, 127, 255)
local str_sub = string.sub
local sellIco = Material("rpui/misc/3d.png", "smooth", "noclamp")
local math_max, string_len, utf8_len = math.max, string.len, utf8.len
local utf8_sub = utf8.sub
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local csMdlCol = Color(255, 255, 255, 150)

local MenuSize = {
    w = 580,
    h = 800
}

local lastWorkBench
net.Receive("urf_craftable", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end

    lastWorkBench = ent

    local recipe = ent.ActiveRecipe
    if recipe and recipe ~= "" and rp.CraftTableItemsIndexes[recipe] then
        rpui.BoolRequest("Вы уверены?", "Вы уверены что хотите сбросить активный рецепт?", "rpui/misc/rectangle_right.png", 1, function()
            net.Start("urf_craftable")
                net.WriteUInt(2, 2)
            net.SendToServer()
            ent:ClearRecipe()
        end)
        return
    end

    local W, H = ScrW(), ScrH()
    local scale = math.Clamp(H / 1080, 0.7, 1)
    local wi, he = 290, 400
    wi = math.max(wi, MenuSize.w * scale)
    he = math.max(he, MenuSize.h * scale)

    local main_pnl = vgui.Create("rpui.CraftTable")
    main_pnl.CraftTableEnt = ent
    main_pnl:SetSize(wi, he)
    main_pnl:SetPos(ScrW()*0.5 - main_pnl:GetWide()*0.5, ScrH()*0.5 - main_pnl:GetTall()*0.5)
    main_pnl:SetText(translates.Get("КРАФТИНГ"))
    main_pnl.titleico = sellIco

    for k, v in pairs(rp.CraftTableItems) do
        if v.customCheck and v.customCheck(LocalPlayer(), ent) == false then continue end
        main_pnl:InsertItem(v)
    end

    function main_pnl:OnItemClick(pnl)
        if not IsValid(ent) then
            self:Close()
            return
        end

        ent:OnItemSelected(pnl.ItemIndex)

        net.Start("urf_craftable")
            net.WriteUInt(1, 2)
            net.WriteUInt(pnl.ItemIndex, 8)
        net.SendToServer()

        self:Close()
    end

    if main_pnl.RecipeCount < 1 then
        main_pnl:Remove()
    end
end)

net.Receive("urf_craftable_finish2", function()
    net.ReadEntity():ClearRecipe()
end)

net.Receive("urf_craftable_finish", function()
    local net_ent = net.ReadEntity()
    local time = rp.CraftTableItems[net_ent.ActiveRecipeIndex].crafttime

    net_ent:PlayAnimation(time)

    timer.Simple(time, function()
        if not IsValid(net_ent) then return end

        net_ent.CsMDL:SetColor(csMdlCol)

        net_ent:ClearRecipe()
        local pos = net_ent.CsMDL:GetPos()
        local emitter = ParticleEmitter( pos )

        local gravity = Vector(0, 0, -250)
        for i = 0, 15 do
            local part = emitter:Add("effects/muzzleflash"..math.random(1, 4), pos)
            if part then
                part:SetDieTime(1)

                part:SetStartAlpha(255)
                part:SetEndAlpha(0)

                part:SetStartSize(i)
                part:SetEndSize(0)
                part:SetGravity(gravity)
                part:SetVelocity(VectorRand() * 50)
            end
        end

        emitter:Finish()
    end)
end)

function Trace()
    return LocalPlayer():GetEyeTrace()
end

net.Receive("urf_craftable_recipe", function()
    if not IsValid(lastWorkBench) then return end

    local net_index, found = net.ReadUInt(8)
    for k, v in pairs(lastWorkBench.ReceptRequire) do
        if v.index == net_index then
            found = k
            break
        end
    end

    if not found then return end

    if lastWorkBench.NextBody < 9 then
        lastWorkBench:SetBodygroup(lastWorkBench.NextBody-1, 0)
        lastWorkBench:SetBodygroup(lastWorkBench.NextBody, 1)
        lastWorkBench:SetCycle(lastWorkBench.AnimCycle)
    end
    lastWorkBench.NextBody = lastWorkBench.NextBody + 1

    if lastWorkBench.ReceptRequire[found].count > 1 then
        lastWorkBench.ReceptRequire[found].count = lastWorkBench.ReceptRequire[found].count - 1
        return
    end

    lastWorkBench.ReceptRequire[found] = nil
    lastWorkBench.ModelsFor2dRender[found]:Remove()
    lastWorkBench.ModelsFor2dRender[found] = nil
end)

if ENT then

function ENT:Initialize()
    self.ModelsFor2dRender = {}
    self.AnimCycle = 0
end

local zeroAng, zeroVec = Angle(0, 0, 0), Vector(0, 0, 0)

function ENT:OnItemSelected(ItemIndex)
    local itemTab = rp.CraftTableItems[ItemIndex]
    local resultTab = rp.item.list[itemTab.result]
    if not resultTab then return end

    self.CustomAng = itemTab.customAng or zeroAng
    self.PosMdlOffset = itemTab.PosOffset or zeroVec

    self.ActiveRecipe = itemTab.result
    self.ActiveRecipeIndex = ItemIndex
    self.CsMDL:SetModel(resultTab.model)
    self.CsMDL:SetColor(csMdlCol)

    self.ReceptRequire = {}

    self.NeededElems = 0

    for i, item in pairs(rp.CraftTableItems[ItemIndex].recipe) do
        self.ReceptRequire[item.uid] = {
            ["count"] = item.count,
            ["model"] = rp.item.list[item.uid].model,
            ["index"] = i
        }

        self.NeededElems = self.NeededElems + item.count
    end

    for k, v in pairs(self.ModelsFor2dRender) do
        if IsValid(v) then
            v:Remove()
        end
    end

    local BodygroupIds = {5, 6, 7, 8}
    
    for k, v in pairs(BodygroupIds) do
        self:SetBodygroup(v, 0)
    end

    self:SetCycle(self.AnimCycle)
    self.NextBody = 5
end

local textOffset, txtCol = Vector(0, 0, 8), Color(225, 225, 225)
local offset3d2d, offset_3d2d_2 = Vector(0, 0, 10), Vector(0, 0, 8)
local ItemCol, ItemMat, txtCol = Color(25, 25, 25, 175), Material("circle_button/circle.png", "smooth", "noclamp"), Color(255, 255, 255)
local SetDrawColor, DrawTexturedRect, SetMaterial, SimpleText = surface.SetDrawColor, surface.DrawTexturedRect, surface.SetMaterial, draw.SimpleText
local maxDrawdist = 512*512
local SetAlphaMultiplier = surface.SetAlphaMultiplier

local animSpeed = 1
function ENT:PlayAnimation(playTime)
    local hookName = self:EntIndex().."workbench_anim"
    hook.Remove("HUDPaint", hookName)

    playTime = playTime or 6

    self.AnimCycle = self.AnimCycle or 0

    self:ResetSequence(self:LookupSequence("work"))
    self:ResetSequenceInfo()
    self:SetCycle(self.AnimCycle)
    self:SetPlaybackRate(1)

    local starttime = SysTime()
    local endTime = starttime + playTime

    local alpha = 150
    local alpha_step = 255 - 150

    local Frac = 0

    local plus = 0.0025*animSpeed
    hook.Add("HUDPaint", hookName, function()
        local os_time = SysTime()

        if os_time >= endTime then
            hook.Remove("HUDPaint", hookName)
            hook.Remove("PostDrawOpaqueRenderables", hookName)
            return
        end

        self.AnimCycle = self.AnimCycle + plus
        if self.AnimCycle >= 1 then
            self.AnimCycle = 0
        end
        self:SetCycle(self.AnimCycle)

        Frac = math.TimeFraction(starttime, endTime, os_time)
        local new = alpha + alpha_step*Frac
        --print(new)
        self.CsMDL:SetColor(ColorAlpha(csMdlCol, new))
    end)

    local entpos, LocalPlayer = self.CsMDL:GetPos(), LocalPlayer()

    hook.Add("PostDrawOpaqueRenderables", hookName, function()
        local dist = LocalPlayer:GetPos():DistToSqr(entpos)
        if dist > maxDrawdist then return end

        SetAlphaMultiplier((1 - dist/maxDrawdist)*1.25)

        local ang = Angle(0, LocalPlayer:EyeAngles().y - 90, 90)
        local pos = entpos + offset3d2d + Vector(0, 0, self.CsMDL:OBBMaxs().z)
        cam.Start3D2D(pos, ang, 0.05)
            SetDrawColor(ItemCol)
            SetMaterial(ItemMat)
            DrawTexturedRect(0, 0, 128, 128)

            draw.SimpleText(math.floor(100*Frac).."%", "rpui.bubble_hint.title", 64, 64, txtCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end)
end

function ENT:Think()
    self:SetCycle(self.AnimCycle)
end

function ENT:DrawRecipe(recipe)
    local hookName = "CraftTableRecipe"..self:EntIndex()
    local csMdls
    hook.Add("PostDrawOpaqueRenderables", hookName, function()        
        if not IsValid(self) then
            hook.Remove("PostDrawOpaqueRenderables", hookName)

            for k, v in pairs(csMdls) do
                if IsValid(v) then
                    v:Remove()
                end
            end

            return
        end

        csMdls = self.ModelsFor2dRender

        if not self.ReceptRequire then return end

        local pos = self.CsMDL:GetPos()
        local dist = LocalPlayer():GetPos():DistToSqr(pos)
        if dist > maxDrawdist then return end

        SetAlphaMultiplier((1 - dist/maxDrawdist)*1.25)

        local ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
        local pos = pos + offset3d2d + Vector(0, 0, self.CsMDL:OBBMaxs().z)

        for k, v in pairs(self.ReceptRequire) do
            cam.Start3D2D(pos, ang, 0.05)
                if IsValid(self.ModelsFor2dRender[k]) then
                    SetDrawColor(ItemCol)
                    SetMaterial(ItemMat)
                    DrawTexturedRect(0, 0, 128, 128)

                    self.ModelsFor2dRender[k]:PaintManual()

                    SimpleText("x"..v.count, "rpui.Fonts.VendorNpc_Title", 128, 128, txtCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                else
                    if v.MaterialPath then
                        self.ModelsFor2dRender[k] = vgui.Create("DImage")
                        self.ModelsFor2dRender[k]:SetImage(v.MaterialPath)
                    elseif v.model then
                        self.ModelsFor2dRender[k] = vgui.Create("SpawnIcon")
                        self.ModelsFor2dRender[k]:SetModel(v.model)
                    end

                    self.ModelsFor2dRender[k]:SetPaintedManually(true)
                    self.ModelsFor2dRender[k]:SetSize(128, 128)
                end
            cam.End3D2D()

            pos = pos + offset_3d2d_2
        end

        SetAlphaMultiplier(1)
    end)
end

function ENT:ClearRecipe(ply)
    self.ActiveRecipe = nil
    self.ActiveRecipeIndex = nil

    for k, v in pairs(self.ModelsFor2dRender) do
        if IsValid(v) then
            v:Remove()
        end
    end

    self.ReceptRequire = nil

    for k, v in pairs(self.ModelsFor2dRender) do
        if IsValid(v) then
            v:Remove()
        end
    end

    self.ModelsFor2dRender = {}

    local BodygroupIds = {5, 6, 7, 8}
    
    for k, v in pairs(BodygroupIds) do
        self:SetBodygroup(v, 0)
    end

    self:SetCycle(self.AnimCycle)

    self.CustomAng = nil
    self.PosMdlOffset = nil
end

function ENT:Draw()
    self:DrawModel()

    if not IsValid(self.CsMDL) then
        self.CsMDL = ClientsideModel("models/props_junk/popcan01a.mdl")
        self.CsMDL:SetNoDraw(true)
        
        self.CsMDL:SetColor(csMdlCol) 
        self.CsMDL:SetRenderMode(RENDERMODE_TRANSCOLOR)

        local timerName = "CraftTable_Validation"..self:EntIndex()
        if timer.Exists(timerName) then
            timer.Remove(timerName)
        end

        local linkToMDL = self.CsMDL
        timer.Create(timerName, 1, 0, function()
            if not IsValid(self) then
                if IsValid(linkToMDL) then
                    linkToMDL:Remove()
                end

                timer.Remove(timerName)
            end
        end)
    end

    local recipe = self.ActiveRecipe
    local recipeTab = rp.CraftTableItemsIndexes[recipe]
    if recipe and recipe ~= "" and recipeTab then
        self.CsMDL:SetNoDraw()
        self.CsMDL:SetPos( self:LocalToWorld(self.ResultOffset + self.PosMdlOffset) )
        local ang = self.CustomAng and self:LocalToWorldAngles( isfunction(self.CustomAng) and self.CustomAng(self) or self.CustomAng ) or self:GetAngles()
        self.CsMDL:SetAngles(ang)

        self:DrawRecipe(rp.CraftTableItems[self.ActiveRecipeIndex])
    else
        self.CsMDL:SetNoDraw(true)
    end
end

end

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local PANEL = {}
PANEL.UIColors = {
    Blank = Color(0, 0, 0, 0),
    White = Color(255, 255, 255, 255),
    Black = Color(0, 0, 0, 255),
    Tooltip = Color(0, 0, 0, 228),
    Active = Color(255, 255, 255, 255),
    Background = Color(0, 0, 0, 127),
    Hovered = Color(0, 0, 0, 180),
    Shading = Color(0, 12, 24, 74)
}
PANEL.GetPaintStyle = function(element, style)
    style = style or STYLE_SOLID
    local baseColor, textColor = Color(0, 0, 0, 0), Color(0, 0, 0, 0)
    local animspeed = 768 * FrameTime()

    if style == STYLE_SOLID then
        element._grayscale = math_Approach(element._grayscale or 0, (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1), animspeed)
        local invGrayscale = 255 - element._grayscale
        baseColor = Color(element._grayscale, element._grayscale, element._grayscale)
        textColor = Color(invGrayscale, invGrayscale, invGrayscale)
    elseif style == STYLE_SOLID_LIGHT then
        element._grayscale = math_Approach(element._grayscale or 0, (element:IsHovered() and 0 or 255) * (element:GetDisabled() and 0 or 1), animspeed)
        local invGrayscale = 255 - element._grayscale
        baseColor = Color(element._grayscale, element._grayscale, element._grayscale)
        textColor = Color(invGrayscale, invGrayscale, invGrayscale)
    elseif style == STYLE_BLANKSOLID then
        element._grayscale = math_Approach(element._alpha or 0, (element:IsHovered() and 0 or 255), animspeed)
        element._alpha = math_Approach(element._alpha or 0, (element:IsHovered() and 255 or 0), animspeed)
        local invGrayscale = 255 - element._grayscale
        baseColor = Color(element._grayscale, element._grayscale, element._grayscale, element._alpha)
        textColor = Color(invGrayscale, invGrayscale, invGrayscale)
    elseif style == STYLE_TRANSPARENT_SELECTABLE then
        element._grayscale = math_Approach(element._grayscale or 0, (element.Selected and 255 or 0), animspeed)

        if element.Selected then
            element._alpha = math_Approach(element._alpha or 0, 255, animspeed)
        else
            element._alpha = math_Approach(element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed)
        end

        local invGrayscale = 255 - element._grayscale
        baseColor = Color(element._grayscale, element._grayscale, element._grayscale, element._alpha)
        textColor = Color(invGrayscale, invGrayscale, invGrayscale)
    elseif style == STYLE_ERROR then
        baseColor = Color(150 + math_sin(CurTime() * 1.5) * 70, 0, 0)
        textColor = main_pnl.UIColors.White
    end

    return baseColor, textColor
end

function PANEL:Init()
    self.RecipeCount = 0

    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.25)
    self.CloseButton = vgui.Create("DButton", self)
    self.CloseButton:SetFont("VendorNpc_Text")
    self.CloseButton:SetText(translates and translates.Get('ЗАКРЫТЬ') or 'ЗАКРЫТЬ')
    self.CloseButton:SizeToContentsY(self:GetTall() * 0.02)
    self.CloseButton:SizeToContentsX(self.CloseButton:GetTall() + self:GetTall() * 0.03)
    self.CloseButton:SetPos(self:GetWide() - self.CloseButton:GetWide() - 6, 16)

    self.CloseButton.Paint = function(this, w, h)
        local baseColor, textColor = self.GetPaintStyle(this)
        surface_SetDrawColor(baseColor)
        surface_DrawRect(0, 0, w, h)
        surface_SetDrawColor(self.UIColors.White)
        surface_DrawRect(0, 0, h, h)
        surface_SetDrawColor(Color(0, 0, 0, this._grayscale or 0))
        local p = h * 0.1
        surface_DrawLine(h, p, h, h - p)
        draw_SimpleText("✕", "rpui.Fonts.AmmoPrinter.Small", h*0.5, h*0.5, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw_SimpleText(this:GetText(), this:GetFont(), w*0.5 + h*0.5, h*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    self.CloseButton.DoClick = function(self)
        if IsValid(self:GetParent()) then
            self:GetParent():Close()
        end
    end

    self.tabsshop = vgui.Create("rpui_tabsshop", self)
    self.tabsshop:SetSize(self:GetWide() - 60, self:GetTall() - 124)
    self.tabsshop:SetPos(30, 90)
    self.tabsshop.is_vendor_inv = function() return true end
end

function PANEL:OnItemClick() end

function PANEL:InsertItem(data)
    local btn = vgui.Create("DButton")
    btn:SetText("")
    btn:Dock(TOP)
    btn:SetTall(64)
    btn:InvalidateParent(true)
    btn.DoClick = function(this)
        self:OnItemClick(this)
    end

    btn.ItemIndex = data["index"]

    btn.Paint = function(that, w, h)
        if not IsValid(self) then return end

        local baseColor = self.GetPaintStyle(that, STYLE_TRANSPARENT_SELECTABLE)

        surface_SetDrawColor(baseColor)
        surface_DrawRect(h, 0, w, h)

        surface_SetDrawColor(self.UIColors.Black)
        surface_DrawRect(0, 0, h, h)

        local txt = data["printname"]

        local a, b = string_len(txt), utf8_len(txt)
        local len, isutf8 = 0

        if b ~= a then
            len = b
            isutf8 = true
        else
            len = a
        end

        if len >= 40 then
            txt = (isutf8 and utf8_sub(txt, 1, 40) or str_sub(txt, 1, 40))..".."
        end

        draw_SimpleText(txt, "rpui.Fonts.VendorNpc_Title", h + 8, h * 0.3, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local sz = btn:GetTall() * 0.9
    local ps = (btn:GetTall() - sz) * 0.5

    btn.ico = vgui.Create("SpawnIcon", btn)
    btn.ico:SetSize(sz, sz)
    btn.ico:SetPos(ps, ps)
    btn.ico:SetMouseInputEnabled(false)
    btn.ico:SetModel(data["model"])

    btn.recipe = vgui.Create("DIconLayout", btn)
    btn.recipe:SetPos(btn:GetTall() + 8, btn:GetTall()*0.55)
    btn.recipe:SetSize(0, btn:GetTall()*0.35)
    btn.recipe:SetSpaceX(8)

    local h = btn.recipe:GetTall()
    for k, v in pairs(data["recipe"]) do
        for i = 1, v["count"] do
            local i = btn.recipe:Add("SpawnIcon")
            i:SetSize(h, h)
            btn.recipe:SetWide(btn.recipe:GetWide() + h + 8)
            i:SetModel(v["mdl"])
            i.DoClick = function()
                self:OnItemClick(btn)
            end
            i.Paint = function(me, w, h)
                if me:IsHovered() then
                    surface_SetDrawColor(self.UIColors.Hovered)
                    surface_DrawRect(0, 0, h, h)
                end
            end
            i.PaintOver = function() end
            i:SetTooltipPanelOverride("rpui.Tooltip")
            i:SetTooltip((rp.item.list[v.uid] or {}).name or "???")
        end
    end

    self.tabsshop:GetPlace4Items():AddItem(btn)
    self.RecipeCount = self.RecipeCount + 1
end

function PANEL:SetText(str)
    if not isstring(str) then return end
    self.Text = str
end

function PANEL:GetText()
    return self.Text or ""
end

function PANEL:PerformLayout()
    if IsValid(self.CloseButton) then
        self.CloseButton:SizeToContentsY(self:GetTall() * 0.02)
        self.CloseButton:SizeToContentsX(self.CloseButton:GetTall() + self:GetTall() * 0.03)
        self.CloseButton:SetPos(self:GetWide() - self.CloseButton:GetWide() - 8, 16)
    end

    if IsValid(self.tabsshop) then
        self.tabsshop:SetSize(self:GetWide() - 60, self:GetTall() - 124)
        self.tabsshop:SetPos(30, 90)
    end
end

function PANEL:Paint(w, h)
    draw_Blur(self)
    surface_SetDrawColor(self.UIColors.Shading)
    surface_DrawRect(0, 0, w, h)
    local wide, tall
    surface_SetDrawColor(color_white)

    if self.titleico then
        surface.SetMaterial(self.titleico)
    end

    if IsValid(self.CloseButton) then
        surface_SetDrawColor(Color(0, 0, 0, 175))
        surface_DrawRect(12, 16, w * 0.65, self.CloseButton:GetTall())
        wide, tall = draw_SimpleText(self:GetText(), "VendorNpc_Name", w * 0.325 + (self.TitleTall or 0), 16 + self.CloseButton:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

         surface_SetDrawColor(color_white)
        surface.DrawTexturedRect(w * 0.325 - wide / 2 - tall - 24 + (self.TitleTall or 0), 16 + self.CloseButton:GetTall() / 2 - tall / 2, tall, tall)
    elseif self.CloseBtnTall then
        surface_SetDrawColor(Color(0, 0, 0, 175))
        surface_DrawRect(12, 16, w - 24, self.CloseBtnTall)
        wide, tall = draw_SimpleText(self:GetText(), "VendorNpc_Name", w * 0.45 + (self.TitleTall or 0), 16 + self.CloseBtnTall / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

         surface_SetDrawColor(color_white)
        surface.DrawTexturedRect(w * 0.45 - wide / 2 - tall - 24 + (self.TitleTall or 0), 16 + self.CloseBtnTall / 2 - tall / 2, tall, tall)
    end

    self.TitleTall = tall
end

function PANEL:Think()
    if self.ent and not IsValid(self.ent) then
        self:Remove()

        return
    end

    if input.IsKeyDown(KEY_X) then
        self:Close()
    end

    if input.IsKeyDown(KEY_ESCAPE) then
        self:Remove()
    end
end

function PANEL:Close()
    if self.Closing then return end
    self.Closing = true

    self:AlphaTo(0, 0.25, 0, function()
        if IsValid(self) then
            self:Remove()
        end
    end)

    if IsValid(self.buyframe) then
        self.buyframe:AlphaTo(0, 0.25, 0, function()
            if IsValid(self.buyframe) then
                self.buyframe:Remove()
            end
        end)
    elseif IsValid(self.sellframe) then
        self.sellframe:AlphaTo(0, 0.25, 0, function()
            if IsValid(self.sellframe) then
                self.sellframe:Remove()
            end
        end)
    end

    if IsValid(self.slider_menu) then
        self.slider_menu:AlphaTo(0, 0.25, 0, function()
            if IsValid(self.slider_menu) then
                self.slider_menu:Remove()
            end
        end)
    end
end

function PANEL:OnRemove()
    if self.PreRemove then
        self:PreRemove()
    end

    if self.DontRemovePseudoParent then return end

    if IsValid(self.buyframe) then
        self.buyframe:Remove()
    elseif IsValid(self.sellframe) then
        self.sellframe:Remove()
    end
end

vgui.Register("rpui.CraftTable", PANEL, "EditablePanel")

-----------------

surface.CreateFont("rpui.DefaultTooltipFont", {
    font = "Montserrat",
    extended = true,
    size = 17
})

local PANEL = {}

local bgCol = Color(0, 0, 0, 175)
function PANEL:Init()
    self:SetFont("rpui.DefaultTooltipFont")
    self.BackgroundColor = bgCol
    self:SetAlpha(0)
end

function PANEL:PositionTooltip()
    if not IsValid(self.TargetPanel) then
        self:Close()
        return
    end

    self:PerformLayout()

    local x, y = input.GetCursorPos()
    local w, h = self:GetSize()

    local lx, ly = self.TargetPanel:LocalToScreen(0, 0)

    y = math.min(y, ly - h * 1.25)
    if y < 2 then y = 2 end

    -- Fixes being able to be drawn off screen
    x = math.Clamp(x - w * 0.5, 0, ScrW() - self:GetWide())
    y = math.Clamp(y, 0, ScrH() - self:GetTall())
    self:SetPos(x, y)
end

function PANEL:Paint(w, h)
    self:PositionTooltip()
    
    if not self.StartDraw then
        self.StartDraw = true
        self:AlphaTo(255, 0.25)
    end
end

function PANEL:SetBackgroundColor(col)
    self.BackgroundColor = col
end

function PANEL:GetBackgroundColor()
    return self.BackgroundColor
end

function PANEL:PaintOver(w, h)
    draw_Blur(self)
    surface_SetDrawColor(self:GetBackgroundColor())
    surface_DrawRect(0, 0, w, h)

    draw_SimpleText(self:GetText(), self:GetFont(), w*0.5, h*0.5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:Close()
    if self.Closing then return end
    self.Closing = true

    if not self.DeleteContentsOnClose and IsValid(self.Contents) then
        self.Contents:SetVisible(false)
        self.Contents:SetParent()
    end

    self:AlphaTo(0, 0.25, 0, function()
        self:Remove()
    end)
end

vgui.Register("rpui.Tooltip", PANEL, "DTooltip")