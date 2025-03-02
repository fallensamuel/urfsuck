-- "gamemodes\\rp_base\\entities\\entities\\vendor_npc\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")

hook.Add( "InitPostEntity", "rp.VendorsNPCs::StockSync", function()
    hook.Remove( "InitPostEntity", "rp.VendorsNPCs::StockSync" );
    net.Start( "VendorNpc_StockSync" ); net.SendToServer();
end );

surface.CreateFont("VendorNpc_Name", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 36,
    weight = 530
})

surface.CreateFont("VendorNpc_Text", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 24,
    weight = 500
})

surface.CreateFont("rpui.Fonts.VendorNpc_Title", {
    font = "Montserrat",
    extended = true,
    weight = 535,
    size = 28
})

surface.CreateFont("rpui.Fonts.VendorNpc_Price", {
    font = "Montserrat",
    extended = true,
    weight = 500,
    size = 22
})

surface.CreateFont("rpui.Fonts.VendorNpc_Count", {
    font = "Montserrat",
    extended = true,
    weight = 565,
    size = 20
})

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
local white_color = Color(255, 255, 255)


-- Я не уверен на счёт уникальности имён созданных мною функций для сортировки, по сему пущай будет так - пока они локальны. Если вы собираетесь использовать их из-вне, измените имена функций и сделайте их глобальными.
local function GetShopByCategories_()
    --if rp.ShopByCategories then return rp.ShopByCategories end
    rp.ShopByCategories = {}
    local i = 0

    for tab_key, tab in pairs(rp.item.shop) do
        --print(tab_key)
        i = i + 1

        rp.ShopByCategories[i] = {
            ["category"] = tab_key,
            ["items"] = {}
        }

        for tab_key2, item in pairs(tab) do
            rp.ShopByCategories[i].items[item.uniqueID] = table.Copy(item)
            rp.ShopByCategories[i].items[item.uniqueID].key = tab_key2
        end
    end

    return rp.ShopByCategories
end

local function GetItemCategory_(item_uid)
    for key, tab in pairs(GetShopByCategories_()) do
        if tab.items[item_uid] then return tab.category, key end -- название и индекс категории
    end
end

local function SortItemsByCategory_(items4sort)
    local sorted = {}

    for uid, item_tab in pairs(items4sort) do
        local cat, key = GetItemCategory_(uid)

        if not cat then
            for name, vendor in pairs(rp.VendorsNPCs) do
                if cat then break end
                cat = vendor.items[uid] and vendor.items[uid].category
            end
        end

        if not cat then
            --print("[VendorNPC] Шо-то я не бачу категории для uid: " .. uid)
            cat = "entities"
            --continue
        end

        if not key then
            local i = 0
            for _cat, tab in pairs(rp.item.shop) do
                i = i + 1

                if _cat == cat then
                    key = i
                    break
                end
            end
        end

        sorted[key] = sorted[key] or {
            ["category"] = cat,
            ["items"] = {}
        }

        local insert_key = table.insert(sorted[key].items, item_tab)
        sorted[key].items[insert_key].uid = uid
    end

    return sorted
end

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local STYLE_SOLID, STYLE_BLANKSOLID, STYLE_TRANSPARENT_SELECTABLE, STYLE_ERROR, STYLE_SOLID_LIGHT = 0, 1, 2, 3, 4

local local_ui_colrs = {
    Blank = Color(0, 0, 0, 0),
    White = Color(255, 255, 255, 255),
    Black = Color(0, 0, 0, 255),
    Tooltip = Color(0, 0, 0, 228),
    Active = Color(255, 255, 255, 255),
    Background = Color(0, 0, 0, 127),
    Hovered = Color(0, 0, 0, 180),
    Shading = Color(0, 12, 24, 74)
}

local local_paint_style = function(element, style)
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

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

local PANEL = {}

function PANEL:Init()

end


local white_col = Color(255, 255, 255)
local burned_col = Color(116, 81, 61, 255)

function PANEL:ExtraPaint(w, h)
    if self.MatIcon then
        if IsValid(self.Icon) then
            self.Icon:Remove()
        end
        surface.SetMaterial(self.MatIcon)
        surface.SetDrawColor(self.pizza_burned and burned_col or white_col)
        surface.DrawTexturedRect(0, 0, w, h)
    end
end

function PANEL:Paint(w, h)
    --local parent = self:GetParent()
    --surface.SetDrawColor( rpui.UIColors.Background );
    --surface.DrawRect( 0, 0, w, h );

    self:ExtraPaint(w, h)
end

function PANEL:PaintOver(w, h)

end

function PANEL:SetModel(mdl, iSkin, BodyGroups)
    if not IsValid(self.Icon) then return end
    if ( !mdl ) then debug.Trace() return end

    self:SetModelName( mdl )

    self:SetSkinID( iSkin or 0 )

    if ( tostring( BodyGroups ):len() != 9 ) then
        BodyGroups = "000000000"
    end

    self.m_strBodyGroups = BodyGroups

    self.Icon:SetModel(mdl, iSkin, BodyGroups)
--[[
    if ( iSkin && iSkin > 0 ) then
        self:SetTooltip( Format( "%s (Skin %i)", mdl, iSkin + 1 ) )
    else
        self:SetTooltip( Format( "%s", mdl ) )
    end
]]--
end

function PANEL:PerformLayout()
    if not IsValid(self.Icon) then return end

    if self:IsDown() and not self.Dragging then
        self.Icon:StretchToParent( 6, 6, 6, 6 )
    else
        self.Icon:StretchToParent( 0, 0, 0, 0 )
    end
end

function PANEL:OnSizeChanged(newW, newH)
    if not IsValid(self.Icon) then return end
    self.Icon:SetSize( newW, newH )
end

function PANEL:SetSpawnIcon(name)
    self.m_strIconName = name
    if not IsValid(self.Icon) then return end
    self.Icon:SetSpawnIcon(name)
end

function PANEL:RebuildSpawnIcon()
    if not IsValid(self.Icon) then return end
    self.Icon:RebuildSpawnIcon()
end

function PANEL:RebuildSpawnIconEx(t)
    if not IsValid(self.Icon) then return end
    self.Icon:RebuildSpawnIconEx(t)
end

vgui.Register("rpui.VendorItemIcon", PANEL, "SpawnIcon")

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
    local parent = self:GetParent()

    if not IsValid(parent) then
        self:Remove()
    end

    self:SetText(translates and translates.Get( "ЗАКРЫТЬ" ) or "ЗАКРЫТЬ")
    self:SetScale(1)

    self.Paint = function(self, w, h)
        local baseColor, textColor = self.GetPaintStyle(self)
        surface_SetDrawColor(baseColor)
        surface_DrawRect(0, 0, w, h)
        surface_SetDrawColor(self.UIColors.White)
        surface_DrawRect(0, 0, h, h)
        surface_SetDrawColor(Color(0, 0, 0, self._grayscale or 0))
        local p = h * 0.1
        surface_DrawLine(h, p, h, h - p)
        draw_SimpleText("✕", self:GetFont(), h / 2, h / 2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw_SimpleText(self:GetText(), self:GetFont(), h / 2 + w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    self.DoClick = function(self)
        local parent = self:GetParent()

        if IsValid(parent) then
            local todo = parent.Close or parent.Remove
            todo(parent)
        end
    end
end

function PANEL:SetScale(scale)
    self.CurScale = scale

    surface.CreateFont("rpui.Fonts.CloseButton", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = 14 * scale
    })

    local parent = self:GetParent()
    self:SetFont("rpui.Fonts.CloseButton")
    self:SizeToContentsY(parent:GetTall() * 0.035)
    self:SizeToContentsX(self:GetTall() + parent:GetTall() * 0.045)
    self:SetPos(parent:GetWide() - self:GetWide() - 14, 14)
end

vgui.Register("rpui_closebutton", PANEL, "DButton")
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local PANEL = {}

function PANEL:Init()
    --Defaults
    self.CurMax = 1
    self:SetDecimals(0)
    self:SetSliderColor(rpui.UIColors.Pink)
    self.Title = ""
    self.CurVal = 0
    surface.SetFont("rpui.Fonts.VendorNpc_Title")
    local _tw, _th = surface_GetTextSize(" ")
    self.CVariableContainer = vgui.Create("Panel", self)
    self.CVariableContainer:Dock(FILL)
    self.CVariableContainer:SetTall(_th * 2)
    self.CVariableContainer:InvalidateParent(true)
    self.CVariableContainer.Title = vgui.Create("DLabel", self.CVariableContainer)
    self.CVariableContainer.Title.Dock(self.CVariableContainer.Title, TOP)
    self.CVariableContainer.Title.DockMargin(self.CVariableContainer.Title, 0, 0, 0, 0 * 0.3)
    self.CVariableContainer.Title.SetFont(self.CVariableContainer.Title, "rpui.Fonts.VendorNpc_Title")
    self.CVariableContainer.Title.SetTextColor(self.CVariableContainer.Title, rpui.UIColors.White)
    --self.CVariableContainer.Title.SetText(self.CVariableContainer.Title, string.utf8upper(self.Title))
    self.CVariableContainer.Title.SetContentAlignment(self.CVariableContainer.Title, 4)
    self.CVariableContainer.Title.SetWrap(self.CVariableContainer.Title, true)

    self.CVariableContainer.Title.Think = function(this)
        this:SetText(self.Title)
    end

    self.CVariableContainer.Slider = vgui.Create("DSlider", self.CVariableContainer)
    self.CVariableContainer.Slider.Dock(self.CVariableContainer.Slider, TOP)
    self.CVariableContainer.Slider.SetTall(self.CVariableContainer.Slider, _th * 0.5)
    self.CVariableContainer.Slider.InvalidateParent(self.CVariableContainer.Slider, true)
    self.CVariableContainer.Slider.SetTrapInside(self.CVariableContainer.Slider, true)

    self.CVariableContainer.Slider.Think = function(this)
        if this:IsEditing() and this.OnSliderMove then
            this.OnSliderMove(this)
        end
    end

    self.CVariableContainer.Slider.Paint = function(this, w, h)
        local rh = h
        h = rpui.PowOfTwo(h * 0.25)
        local ho = (rh - h) * 0.5
        draw_RoundedBox(3, 0, ho, w, h, Color(210, 210, 225))
        draw_RoundedBox(3, 0, ho, this.Knob.x + this.Knob.GetWide(this.Knob) * 0.5, h, self:GetSliderColor())
    end

    self.CVariableContainer.Slider.Think = function(this)
        if this:IsEditing() then
            local cur = this:GetSlideX()
            if not cur then return end
            self.CurVal = math.max(1, math.Round(cur * self:GetMax(), self:GetDecimals()))

            if this.OnSliderMove then
                this.OnSliderMove(this)
            end
        end
    end

    self.CVariableContainer.Slider.Knob.SetSize(self.CVariableContainer.Slider.Knob, _th * 0.5, _th * 0.5)
    self.CVariableContainer.Slider.Knob.NoClipping(self.CVariableContainer.Slider.Knob, false)

    self.CVariableContainer.Slider.Knob.Paint = function(this, w, h)
        surface_SetDrawColor(rpui.UIColors.White)
        surface_DrawRect(0, 0, w, h)
    end

    surface.SetFont("rpui.Fonts.VendorNpc_Count")
    local _tw2, _th2 = surface_GetTextSize(" ")
    self.CVariableContainer.Slider.Info = vgui.Create("Panel", self.CVariableContainer)
    self.CVariableContainer.Slider.Info:SetSize(self.CVariableContainer:GetWide(), _th2)

    self.CVariableContainer.Slider.Info.Paint = function(this, w, h)
        draw_RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        this.txt_wide = draw_SimpleText(self.CurVal, "rpui.Fonts.VendorNpc_Count", w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        this:SetWide(this.txt_wide + 8)
    end

    local knob_wide = self.CVariableContainer.Slider.Knob:GetWide()

    self.CVariableContainer.Slider.Info.Think = function(this)
        local x = self.CVariableContainer.Slider.Knob:GetPos()
        this:SetPos(math.Clamp(x - (this.txt_wide or 0) / 2 + knob_wide / 4, 0, self:GetWide() - (this.txt_wide or 0) - 8), -2)
    end

    self.CVariableContainer:InvalidateLayout(true)
    self.CVariableContainer:SizeToChildren(false, true)
end

function PANEL:SizeRebuild()
    surface.SetFont("rpui.Fonts.VendorNpc_Title")
    local _tw, _th = surface_GetTextSize(" ")
    self.CVariableContainer:SetTall(_th * 2)
    self.CVariableContainer:InvalidateParent(true)
    self.CVariableContainer.Slider.SetTall(self.CVariableContainer.Slider, _th * 0.5)
    self.CVariableContainer.Slider.InvalidateParent(self.CVariableContainer.Slider, true)
    surface.SetFont("rpui.Fonts.VendorNpc_Count")
    local _tw2, _th2 = surface_GetTextSize(" ")
    self.CVariableContainer.Slider.Knob.SetSize(self.CVariableContainer.Slider.Knob, _th * 0.5, _th * 0.5)
    self.CVariableContainer.Slider.Info:SetSize(self.CVariableContainer:GetWide(), _th2)
    surface.SetFont("rpui.Fonts.VendorNpc_Count")
    local _, _th3 = surface_GetTextSize(" ")
    _th3 = _th3 + 16
    self:SetTall(self:GetTall() + _th3)
    self.SizeInfo:SetSize(self:GetWide(), _th3)
    local _, slider_y = self.CVariableContainer.Slider:GetPos()
    slider_y = slider_y + self.CVariableContainer.Slider:GetTall()
    self.SizeInfo:SetPos(0, slider_y) --self:GetTall() - self.SizeInfo:GetTall())
end

function PANEL:Paint(w, h)
    --draw_RoundedBox(0, 0, 0, w, h, Color(175, 25, 25))
end

function PANEL:SetCvar(new_cvar)
    self.Convar = new_cvar
    self.ConvarTable = cvar.GetTable()[new_cvar]
    self.CVariableContainer.Slider.SetSlideX(self.CVariableContainer.Slider, self.ConvarTable:GetValue())

    self.CVariableContainer.Slider.Think = function(this)
        if this:IsEditing() then
            local cur = this:GetSlideX()
            if not cur then return end
            self.CurVal = math.max(1, math.Round(cur * self:GetMax(), self:GetDecimals()))
            self.ConvarTable:SetValue(self.CurVal)

            if this.OnSliderMove then
                this.OnSliderMove(this)
            end
        end
    end

    self.CurVal = self.ConvarTable.Value
end

function PANEL:GetValue()
    return self.CurVal
end

function PANEL:SetValue(num)
    self.CurVal = num
end

function PANEL:CreateSizeInfo()
    surface.SetFont("rpui.Fonts.VendorNpc_Count")
    local _, _th = surface_GetTextSize(" ")
    _th = _th + 16
    self.SizeInfo = vgui.Create("Panel", self)
    self.SizeInfo:SetMouseInputEnabled(false)
    self:SetTall(self:GetTall() + _th)
    self.SizeInfo:SetSize(self:GetWide(), _th)
    self.SizeInfo:SetPos(0, self:GetTall() - self.SizeInfo:GetTall())

    self.SizeInfo.Paint = function(this, w, h)
        local col = Color(200, 200, 200)
        --for i = 1, 5 do
        --  draw_RoundedBox(0, 4 + i*(w/5), 10, 2, 2 + math.fmod(i, 2), col)
        --end
        local _w = draw_SimpleText("1", "rpui.Fonts.VendorNpc_Count", 0, 16, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw_RoundedBox(0, _w/2, 10, 2, 6, col)

        local _w, tall = draw_SimpleText(self:GetMax(), "rpui.Fonts.VendorNpc_Count", w, 16, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw_RoundedBox(0, w - _w/2, 10, 2, 6, col)
    end
    --self.FullTall = 6 + 16 + tall
end

function PANEL:SetMax(num)
    self.CurMax = num
    self.CVariableContainer.Slider:SetSlideX(math.Clamp(math.Round(self.CVariableContainer.Slider:GetSlideX() / self:GetMax(), self:GetDecimals()), 0, 1))
end

function PANEL:GetMax()
    return self.CurMax
end

function PANEL:SetDecimals(dec)
    self.CurDecimals = dec
end

function PANEL:GetDecimals()
    return self.CurDecimals
end

function PANEL:SetTitle(str)
    self.Title = str
end

function PANEL:GetTitle()
    return self.Title
end

function PANEL:SetSliderColor(col)
    self.SliderCol = col
end

function PANEL:GetSliderColor()
    return self.SliderCol
end

vgui.Register("rpui_numslider", PANEL, "EditablePanel")
--for key, val in pairs(cvar.GetTable()) do
--  print(key)
--end
local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
    -- nothing ;)
end

function PANEL:Create(txt, font)
    self:SetText(txt)
    self:SetFont(font)
    self:SetTextColor(white_color)
    self:SizeToContents()
    self:SetSize(self:GetWide() * 1.1, self:GetTall() * 1.05)
end

function PANEL:SetStyle(styl)
    self.style = styl
end

function PANEL:GetStyle()
    self.style = styl
end

function PANEL:Paint(w, h)
    local baseColor, txt_col = rpui.GetPaintStyle(self, self.style or STYLE_SOLID)
    surface_SetDrawColor(baseColor)
    surface_DrawRect(0, 0, w, h)
    self:SetTextColor(txt_col)
end

vgui.Register("rpui_button", PANEL, "DButton")
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
    surface.CreateFont("rpui.Fonts.NumSliderMenu.Title", { -- pre create font
        font = "Montserrat",
        extended = true,
        weight = 550,
        size = 1
    })

    self:SetAlpha(0)
    self:AlphaTo(255, 0.25)
    self.Title = ""
    self.ButtonClick = {}
    self.CloseButton = vgui.Create("rpui_closebutton", self)
    self.Slider = vgui.Create("rpui_numslider", self)
    self.Slider:SetSize(self:GetWide() * 0.95, 32)
    self.Slider:SetPos(self:GetWide() * 0.025, self:GetTall() / 2 - self.Slider:GetTall())
    --self.Slider:SetCvar("sound_level")
    --self.Slider:SetTitle("Громкость")
    self.Slider:SetSliderColor(Color(106, 194, 116))
    self.Slider:CreateSizeInfo()
    self.Slider:SetMax(1)
    self.Slider:SizeRebuild()
    self.Button_1 = vgui.Create("rpui_button", self)
    self.Button_1:SetStyle(STYLE_SOLID_LIGHT)
    self.Button_1:Create(self:GetBtnText(), "rpui.Fonts.NumSliderMenu.Title")

    self.Button_1.DoClick = function(this)
        --surface.PlaySound("ui/buttonclickrelease.wav")
        if self.ButtonClick[1] then
            self.ButtonClick[1](this, self.Slider:GetValue(), self.Slider:GetMax())
        end
    end

    self.Button_2 = vgui.Create("rpui_button", self)
    self.Button_2:SetStyle(STYLE_SOLID_LIGHT)
    self.Button_2:Create(self:GetBtnText() .. " " .. (translates and translates.Get('всё') or 'всё'), "rpui.Fonts.NumSliderMenu.Title")

    self.Button_2.DoClick = function(this)
        --surface.PlaySound("ui/buttonclickrelease.wav")
        if self.ButtonClick[2] then
            self.ButtonClick[2](this, self.Slider:GetValue(), self.Slider:GetMax())
        end
    end

    local btns_wide = self.Button_1:GetWide() + self.Button_2:GetWide()
    self.Button_1:SetPos(self:GetWide() / 2 - btns_wide / 2 - 10, self:GetTall() - self.Button_1:GetTall() - self:GetTall() / 9)
    self.Button_2:SetPos(self:GetWide() / 2 - btns_wide / 2 + self.Button_1:GetWide() + 10, self:GetTall() - self.Button_2:GetTall() - self:GetTall() / 9)
end

function PANEL:SetDecimals(dec)
    self.Slider:SetDecimals(dec)
end

function PANEL:SetBtnText(str)
    self.BtnText = str
end

function PANEL:GetBtnText()
    return self.BtnText or ""
end

function PANEL:SetButtonClick(num, func)
    self.ButtonClick[num] = func
end

function PANEL:SetMax(num)
    self.Slider:SetMax(num)
end

function PANEL:GetMax()
    return self.Slider:GetMax()
end

function PANEL:Close()
    if self.Closing then return end
    self.Closing = true

    self:AlphaTo(0, 0.25, 0, function()
        self:Remove()
    end)
end

function PANEL:Paint(w, h)
    surface_SetDrawColor(Color(0, 0, 0, 165))
    surface_DrawRect(0, 0, w, h)
    local _, title_y = self.CloseButton:GetPos()
    title_y = title_y + self.CloseButton:GetTall() / 2
    draw_SimpleText(self:GetTitle(), "rpui.Fonts.NumSliderMenu.Title", w * 0.05, title_y, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:GetTitle()
    return self.Title
end

function PANEL:SetTitle(str)
    self.Title = str
end

function PANEL:SizeRebuild()
    self.CloseButton:SizeToContentsY(self:GetTall() * 0.02)
    self.CloseButton:SizeToContentsX(self.CloseButton:GetTall() + self:GetTall() * 0.03)
    self.CloseButton:SetPos(self:GetWide() - self.CloseButton:GetWide() - 8, 16)
    self.CloseButton:SetScale(self:GetWide() / 275)

    surface.CreateFont("rpui.Fonts.NumSliderMenu.Title", {
        font = "Montserrat",
        extended = true,
        weight = 550,
        size = self.CloseButton:GetTall() * 1.1
    })

    self.Slider:SetSize(self:GetWide() * 0.95, 32)
    self.Slider:SetPos(self:GetWide() * 0.025, self:GetTall() / 2 - self.Slider:GetTall())
    self.Slider:SizeRebuild()
    self.Button_1:Create(self:GetBtnText(), "rpui.Fonts.NumSliderMenu.Title")
    self.Button_2:Create(self:GetBtnText() .. ' ' .. (translates and translates.Get('всё') or 'всё'), "rpui.Fonts.NumSliderMenu.Title")
    local btns_wide = self.Button_1:GetWide() + self.Button_2:GetWide()
    self.Button_1:SetPos(self:GetWide() / 2 - btns_wide / 2 - 10, self:GetTall() - self.Button_1:GetTall() - self:GetTall() / 9)
    self.Button_2:SetPos(self:GetWide() / 2 - btns_wide / 2 + self.Button_1:GetWide() + 10, self:GetTall() - self.Button_2:GetTall() - self:GetTall() / 9)
end

function PANEL:GetSlider()
    return self.Slider.CVariableContainer.Slider
end

vgui.Register("rpui_numslider_menu", PANEL, "EditablePanel")
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
    self.Items = {}
    self.ItemPanels = {}

    self.place4items = vgui.Create("Panel", self)

    self.items_list = vgui.Create("rpui.ScrollPanel", self.place4items)
    self.items_list:Dock(FILL)
    self.items_list:DockMargin(0, 0, 0, 0)
    self.items_list:SetSpacingY()
    self.items_list:SetScrollbarMargin(0)
    self.items_list:InvalidateParent(true)
end

function PANEL:PerformLayout()
    if IsValid(self.items_list) then
        self.place4items:SetSize(self:GetWide(), self:GetTall())
        --self.place4items:SetPos(0, self:GetTall()*0.1)
        self.items_list.ySpacing = 10
        self.items_list:InvalidateParent(true)
    end
end

function PANEL:GetPlace4Items()
    return self.items_list, self.place4items
end

function PANEL:SetItemClickFunc(func)
    self.item_doclick_func = func
end

function PANEL:AddItem(category, uid, name, price, mdl, count, is_player_inventory, isnt_vendor, override_mat, override_count, experience)
    local already = self:GetItem(uid)
    if IsValid(already) then return end

    if not isnt_vendor and not experience then
        local exp, vendor_id = 0, self:GetParent().VendorEnt:GetVendorName();

        local et = (LocalPlayer():GetJobTable() or {}).experience;
        if et and et.actions then
            if et.actions["sell_vendor"] and et.actions["sell_vendor"][vendor_id] then
                exp = exp + et.actions["sell_vendor"][vendor_id];
            end

            if et.actions["sell_item"] and et.actions["sell_item"][uid] then
                exp = exp + et.actions["sell_item"][uid];
            end
        end

        if exp > 0 then experience = exp; end
    end

    self.Items[uid] = {
        ["uid"] = uid,
        ["name"] = name,
        ["price"] = price,
        ["override_mat"] = override_mat,
        ["mdl"] = mdl or "models/props_borealis/bluebarrel001.mdl",
        ["count"] = count,
        ["category"] = category,
        ["isnt_vendor"] = isnt_vendor,
        ["override_count"] = override_count,
        ["experience"] = experience,
    }

    local parent = self:GetPlace4Items()
    return self:AddItemButton(parent, self.Items[uid])
end

local math_max, string_len, utf8_len = math.max, string.len, utf8.len

function PANEL:AddItemButton(parent, data)
    local is_vendor = self.is_vendor_inv
    local parent = self:GetPlace4Items()
    local that = self:GetItem(data.uid)

    if IsValid(that) then
        that["data_table"].count = (that["data_table"].count or 0) + (data["count"] or 1)

        return
    end

    local item_btn = vgui.Create("DButton")
    item_btn:SetText("")
    item_btn:Dock(TOP)
    item_btn:SetTall(56)
    item_btn:InvalidateParent(true)

    item_btn.DoClick = function(this)
        self.item_doclick_func(this)
    end

    item_btn.data_table = table.Copy(data)

    item_btn.AddCount = function(this, toadd)
        item_btn.data_table["count"] = item_btn.data_table["count"] + toadd
    end

    local utf8_sub = utf8.sub

    item_btn.Paint = function(that, w, h)
        if not IsValid(self) then return end

        local baseColor = self.GetPaintStyle(that, STYLE_TRANSPARENT_SELECTABLE)
        local stock_cooldown;

		if not data.override_count then
			local cnt = 0
			local items = LocalPlayer():getInv():getItemsByUniqueID(data.uid)
			for k, item in pairs(items) do
				cnt = cnt + item:getCount() * (item.ammoAmount or 1)
			end

			that.realcount = cnt

			if is_vendor() then
				if not that.vendor_id then
					that.vendor_id = self:GetParent().VendorEnt:GetVendorName();
				end

				if rp.VendorsNPCsStock then
					stock_cooldown = (rp.VendorsNPCsStock[that.vendor_id] or {})[that.data_table["uid"]];

					if stock_cooldown and (stock_cooldown < CurTime()) then
						stock_cooldown = nil;
					end
				end
			end
		else
			that.realcount = data.count
		end

        if ((stock_cooldown) or (that.CustomRedCheck and that.CustomRedCheck()) or (not is_vendor() and (that.realcount < 1 or LocalPlayer():GetMoney() < that.data_table["price"])  or data.isnt_vendor and LocalPlayer():GetMoney() < data.price)) and not data.override_count then
            baseColor = Color(125, 0, 0, that._alpha)
        end

        surface_SetDrawColor(baseColor)
        surface_DrawRect(h, 0, w, h)
        surface_SetDrawColor(self.UIColors.Black)
        surface_DrawRect(0, 0, h, h)

        local txt = that._CurText or that.data_table["name"]

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

        draw_SimpleText(txt, "rpui.Fonts.VendorNpc_Title", h + 4, h / 2, white_color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        if item_btn.CustomText then
            local txt = (that:IsHovered() and item_btn.CustomTextHover) or item_btn.CustomText
            draw_SimpleText(txt, "rpui.Fonts.VendorNpc_Price", w - 12, h - 8, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        elseif that.data_table["price"] then
            local better_price = is_vendor() and rp.FormatMoney(that.data_table["price"])

            if stock_cooldown then
                better_price = string.FormattedTime( math.ceil(stock_cooldown - CurTime()), "%02i:%02i" );
            else
                local exp = (that.data_table["experience"] or 0) * that.realcount;
                local money = translates.Get( "%s за %i шт.", rp.FormatMoney(that.data_table["price"] * that.realcount), that.realcount )

				better_price = better_price or that:IsHovered() and that.realcount
                    and (exp > 0 and translates.Get("%i опыта, %s", exp, money) or money)
                    or rp.FormatMoney(that.data_table["price"])
			end

            draw_SimpleText(better_price, "rpui.Fonts.VendorNpc_Price", w - 12, h - 8, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end
    end

    item_btn.mdl_ico = vgui.Create("rpui.VendorItemIcon", item_btn)
    local sz = item_btn:GetTall() * 0.9
    item_btn.mdl_ico:SetSize(sz, sz)
    local ps = (item_btn:GetTall() - sz) / 2
    item_btn.mdl_ico:SetPos(ps, ps)
    item_btn.mdl_ico:SetMouseInputEnabled(false)

    local cur_data = table.Copy(data)
    local uid = cur_data["uid"]
    if uid and rp.item.icons[uid] then
        item_btn.mdl_ico.MatIcon = rp.item.icons[uid]
    else
		//print(cur_data.uid, cur_data.override_mat)
		if cur_data.override_mat then
			item_btn.mdl_ico.Icon.SetVisible(item_btn.mdl_ico.Icon, false)
			local my_mat = Material(cur_data.override_mat)
			item_btn.mdl_ico.ExtraPaint = function(self111, xvv, yvv)
                surface.SetMaterial(my_mat)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(0, 0, xvv, yvv)
			end
		else
			item_btn.mdl_ico:SetModel(cur_data["mdl"])
		end
    end

    item_btn.lbl = vgui.Create("Panel", item_btn)
    item_btn.lbl:SetSize(item_btn:GetTall(), item_btn:GetTall())
    item_btn.lbl:SetMouseInputEnabled(false)

    item_btn.lbl.Paint = function(this, w, h)
        if not is_vendor() then
			draw_SimpleText(item_btn.realcount, "rpui.Fonts.VendorNpc_Count", w - 4, h - 6, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		elseif data.isnt_vendor then
			draw_SimpleText(data.count, "rpui.Fonts.VendorNpc_Count", w - 4, h - 6, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		end
    end

    parent:AddItem(item_btn)

    self.ItemPanels[data.uid] = item_btn
    return item_btn
end

function PANEL:ClearItems()
    for _, item in pairs(self.ItemPanels) do
        if IsValid(item) then
            item:Remove()
        end
    end

    self.ItemPanels = {}
end

function PANEL:GetItem(uid)
    local item = self.ItemPanels[uid]

    if IsValid(item) then return item end
end

function PANEL:RemoveItem(uid)
    local item = self:GetItem(uid)

    if IsValid(item) then
        item:Remove()
    end
end

vgui.Register("rpui_tabsshop", PANEL, "EditablePanel")
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
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
        draw_SimpleText("✕", "rpui.Fonts.AmmoPrinter.Small", h / 2, h / 2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw_SimpleText(this:GetText(), this:GetFont(), w / 2 + h / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

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
    self.tabsshop.is_vendor_inv = function() return self.is_vendor_iventory end

    self.tabsshop:SetItemClickFunc(function(pnl)
        local data = pnl.data_table

		if data.isnt_vendor and not data.override_count and data.price > LocalPlayer():GetMoney() then
			rp.Notify(NOTIFY_ERROR, 'У вас недостаточно денег!')
			return
		end

        local data_table = {
            name = data["name"],
            price = data["price"],
            mdl = data["mdl"],
            count = data["count"],
            uid = data["uid"]
        }

        local cnt = 0
        local items = LocalPlayer():getInv():getItemsByUniqueID(data["uid"])
        for k, item in pairs(items) do
            cnt = cnt + item:getCount()
        end

        if self.is_vendor_iventory or cnt <= 1 then
            hook.Run("VendorNPC_TradeHook", self, data["uid"], 1, pnl, data_table)

            return
        end

        self:KillFocus()

        if IsValid(self.slider_menu) then
            self.slider_menu:MakePopup()

            return
        end

        if IsValid(self.second_shop_frame) and IsValid(self.second_shop_frame.slider_menu) then
            self.slider_menu:Remove()
        end

        local item_tab = rp.VendorsNPCs[self.VendorEnt:GetVendorName()].items
        local item = item_tab[data["uid"]]

        local buy_txt = translates and translates.Get("Купить") or "Купить"
        local sll_txt = translates and translates.Get("Продать") or "Продать"

        self.slider_menu = vgui.Create("rpui_numslider_menu")
        self.slider_menu:SetBtnText(self.is_vendor_iventory and buy_txt or sll_txt)
        self.slider_menu:SetDecimals(0)
        self.slider_menu:SetDrawOnTop(true)
        self.slider_menu:SetTitle(translates and translates.Get("Количество") or "Количество")
        --local smax = item.max
        --smax = data["count"] > smax and data["count"] or smax
        self.slider_menu:SetMax(cnt or 50)
        self.slider_menu:GetSlider():SetSlideX(0)
        self.slider_menu:SetSize(335, 180)
        self.slider_menu:SizeRebuild()
        self.slider_menu:Center()
        self.slider_menu:MakePopup()

        self.slider_menu.Slider.CurVal = math.floor(self.slider_menu:GetMax()*0.5)
        self.slider_menu:GetSlider():SetSlideX(0.5)

        self.slider_menu.Think = function(this)
            if not this:HasFocus() then
                this:MakePopup()
            end
        end

        self.slider_menu:SetButtonClick(1, function(this, cur, max)
            hook.Run("VendorNPC_TradeHook", self, data["uid"], cur, pnl, data_table)
            if IsValid(self) and IsValid(self.slider_menu) then
                self.slider_menu:Close()
            end
        end)

        self.slider_menu:SetButtonClick(2, function(this, cur, max)
            hook.Run("VendorNPC_TradeHook", self, data["uid"], max, pnl, data_table)
            if IsValid(self) and IsValid(self.slider_menu) then
                self.slider_menu:Close()
            end
        end)
    end)
end

function PANEL:SetVendor(ent, is_vendor_iventory)
    self.VendorEnt = ent
    self.is_vendor_iventory = is_vendor_iventory
end

function PANEL:InsertItems(items_tab)
    local sorted = SortItemsByCategory_(items_tab)

    for key, tab in pairs(sorted) do
        local category = tab.category
        local items = tab.items

        for kkk, item in pairs(items) do
            if self.is_vendor_iventory and not item.buyPrice then
                continue
            end
            if not self.is_vendor_iventory and not item.sellPrice then
                continue
            end

            local _price = self.is_vendor_iventory and item.buyPrice or item.sellPrice
            if not _price then continue end

            self.tabsshop:AddItem(category, item.uid, item.name, _price, item.mdl, (not self.is_vendor_iventory and not item.override_count and 0) or (item.is_vendor == false and item.amount), nil, item.is_vendor == false, nil, item.override_count, item.experience)
        end
    end
end

function PANEL:SetSize2(w, h)
    self:SetSize(w, h)
    self:RebuildSize()
end

function PANEL:SetText(str)
    if not isstring(str) then return end
    self.Text = str
end

function PANEL:GetText()
    return self.Text or ""
end

function PANEL:RebuildSize()
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
    surface_SetDrawColor(white_color)

    if self.titleico then
        surface.SetMaterial(self.titleico)
    end

    if IsValid(self.CloseButton) then
        surface_SetDrawColor(Color(0, 0, 0, 175))
        surface_DrawRect(12, 16, w * 0.65, self.CloseButton:GetTall())
        wide, tall = draw_SimpleText(self:GetText(), "VendorNpc_Name", w * 0.325 + (self.TitleTall or 0), 16 + self.CloseButton:GetTall() / 2, white_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

         surface_SetDrawColor(white_color)
        surface.DrawTexturedRect(w * 0.325 - wide / 2 - tall - 24 + (self.TitleTall or 0), 16 + self.CloseButton:GetTall() / 2 - tall / 2, tall, tall)
    elseif self.CloseBtnTall then
        surface_SetDrawColor(Color(0, 0, 0, 175))
        surface_DrawRect(12, 16, w - 24, self.CloseBtnTall)
        wide, tall = draw_SimpleText(self:GetText(), "VendorNpc_Name", w * 0.45 + (self.TitleTall or 0), 16 + self.CloseBtnTall / 2, white_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

         surface_SetDrawColor(white_color)
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

vgui.Register("Urf_VendorNpc_Menu", PANEL, "EditablePanel")

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local function IsItemLimit(ply, item_uid, max)
    local itemCount = ply:getInv():getItemCount(item_uid) + ply:GetCount(item_uid)

    if not max or max == 0 then
        max = rp.cfg.DroppedItemsLimit or 5
    end

    if itemCount >= max then return true end
    max = rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10
    if ply:GetCount("rp_item") >= max then return true end
end

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
local MenuSize = {
    w = 580,
    h = 800
}

function rp.item.openVendorMenu(net_index, is_vendor, custom_items)
	local self = ents.GetByIndex(net_index)
    if not IsValid(self) then return end

    local W, H = ScrW(), ScrH()
    local scale = math.Clamp(H / 1080, 0.7, 1)
    local wi, he = 290, 400
    wi = math.max(wi, MenuSize.w * scale)
    he = math.max(he, MenuSize.h * scale)

    main_pnl = vgui.Create("Urf_VendorNpc_Menu")
    main_pnl:SetSize2(wi, he)
    main_pnl:SetPos(ScrW()*0.9 - main_pnl:GetWide(), ScrH() / 2 - main_pnl:GetTall() / 2)
    main_pnl:SetText(translates and translates.Get("ПРОДАТЬ") or "ПРОДАТЬ")
    main_pnl.titleico = Material("sell.png", "smooth", "noclamp")
    main_pnl:SetVendor(self)
    main_pnl.VendorIndex = net_index
    --main_pnl:ParentToHUD()

    buy_pnl = vgui.Create("Urf_VendorNpc_Menu")
    buy_pnl:SetSize2(wi, he)
    --buy_pnl:SetPos(ScrW() / 2 - buy_pnl:GetWide() - 30, ScrH() / 2 - buy_pnl:GetTall() / 2)
    buy_pnl:SetPos(ScrW()*0.1, ScrH() / 2 - buy_pnl:GetTall() / 2)
    buy_pnl:SetText(translates and translates.Get("КУПИТЬ") or "КУПИТЬ")
    buy_pnl.titleico = Material("buy.png", "smooth", "noclamp")
    --buy_pnl.CloseBtnTall = buy_pnl.CloseButton:GetTall()
    --buy_pnl.CloseButton:Remove()
    buy_pnl:SetVendor(self, true)
    buy_pnl.VendorIndex = net_index

    main_pnl.buyframe = buy_pnl
    buy_pnl.sellframe = main_pnl

    local x1, y1 = main_pnl:GetPos()
    local x2, y2 = buy_pnl:GetPos()
    local abc = x1 + main_pnl:GetWide() + 16
    if abc > ScrW()*0.5 then
        main_pnl:SetPos(ScrW()*0.5 + 16, y1)
        buy_pnl:SetPos(ScrW()*0.5 - buy_pnl:GetWide() - 16, y2)
    end

    local items = {
        sell = {},
        buy = {}
    }

    local all_vendoritems

	if is_vendor then
		all_vendoritems = rp.VendorsNPCs[self:GetVendorName()].items

	else
		--local inv = rp.item.inventories[self.GetInvID and self:GetInvID() or -1]

		all_vendoritems = {}

		if custom_items then
			--local item

			for k, v in pairs(custom_items) do
				--item = rp.item.list[v.uniqueID] or rp.item.base[v.uniqueID]

				--print(item.uniqueID, v.uniqueID)

				--if v:getData('price') then
					--[[
					all_vendoritems[v.uniqueID] = table.Copy(v)
					all_vendoritems[v.uniqueID].price = v:getData('price')
					all_vendoritems[v.uniqueID].buyPrice = all_vendoritems[v.uniqueID].price
					all_vendoritems[v.uniqueID].amount = v:getData('count') or 1
					all_vendoritems[v.uniqueID].is_vendor = false
					all_vendoritems[v.uniqueID].mdl = v.model
					all_vendoritems[v.uniqueID].count = v:getData('count')
					]]

					local item_t = rp.item.list[v.uniqueID]

					all_vendoritems[v.uniqueID] = {}
					all_vendoritems[v.uniqueID].price = v.price
					all_vendoritems[v.uniqueID].buyPrice = v.price
					all_vendoritems[v.uniqueID].amount = v.count
					all_vendoritems[v.uniqueID].name = item_t.name
					all_vendoritems[v.uniqueID].is_vendor = false
					all_vendoritems[v.uniqueID].mdl = item_t.model --v.model
					all_vendoritems[v.uniqueID].count = v.count

				--end
			end
		end
	end

    for name, tab in pairs(all_vendoritems) do
        if tab["buyPrice"] then
            items.buy[name] = tab
        end

        if tab["sellPrice"] then
            items.sell[name] = tab
            if rp.IFoundWhereICanSell and (name == rp.WhatWeSell) then
                rp.IFoundWhereICanSell()
            end
        end
    end

    if table.Count(items.buy) > 0 then
        buy_pnl:InsertItems(items.buy)
    else
        buy_pnl.DontRemovePseudoParent = true
        buy_pnl:Remove()

        if IsValid(main_pnl) then
            --main_pnl:Center()
            main_pnl:SetPos(ScrW()*0.1, ScrH() / 2 - main_pnl:GetTall() / 2)
        end
    end

    if table.Count(items.sell) > 0 then
        main_pnl:InsertItems(items.sell)
    else
        main_pnl.DontRemovePseudoParent = true
        main_pnl:Remove()

        if IsValid(buy_pnl) then
            --buy_pnl:Center()
            buy_pnl:SetPos(ScrW()*0.1, ScrH() / 2 - buy_pnl:GetTall() / 2)
        end
    end

    if IsValid(buy_pnl) then
        if IsValid(main_pnl) then
            buy_pnl.CloseBtnTall = buy_pnl.CloseButton:GetTall()
            buy_pnl.CloseButton:Remove()
        end
    end

	if not IsValid(buy_pnl) and not is_vendor then
		rp.Notify(NOTIFY_GENERIC, "В этом магазине всё распродано!")
	end

    hook.Add("VendorNPC_TradeHook", "_hi_", function(pnl, uid, amount, item_btn, dt)
		amount = amount or 1

		if amount <= 0 then return end

		if is_vendor then
            if (!IsValid(pnl) or !IsValid(pnl.VendorEnt)) then return end
			local item_tab = table.Copy(rp.VendorsNPCs[pnl.VendorEnt:GetVendorName()].items)
			local item = item_tab[uid]
			if not item then return end
			net.Start(pnl.is_vendor_iventory and "VendorNpc_BuyItem" or "VendorNpc_SellItem")
				net.WriteInt(pnl.VendorIndex, 32)
				net.WriteString(uid)
				net.WriteInt(amount, 30)
			net.SendToServer()
		else
			if buy_pnl.tabsshop.Items[dt.uid].count < amount then return end

			buy_pnl.tabsshop.Items[dt.uid].count = buy_pnl.tabsshop.Items[dt.uid].count - amount
			item_btn.data_table.count = item_btn.data_table.count - amount

			custom_items[dt.uid].count = custom_items[dt.uid].count - amount

			if custom_items[dt.uid].count <= 0 then
				custom_items[dt.uid] = nil
			end

			net.Start('ShopEnt::BuyItem')
				net.WriteString(dt.uid)
				net.WriteUInt(net_index, 16)
				net.WriteUInt(amount, 8)
			net.SendToServer()

			if buy_pnl.tabsshop.Items[dt.uid].count <= 0 then
				--timer.Simple(0.2, function()
					--buy_pnl:Remove()
					--rp.item.openVendorMenu(net_index, is_vendor, custom_items)
					item_btn:Remove()

					if table.Count(custom_items) == 0 then
						buy_pnl:Remove()
					end
				--end)
			end
		end
    end)
end

net.Receive("VendorNpc_OpenMenu", function()
    local net_index = net.ReadInt(32)
	local is_vendor = net.ReadBool()

    rp.item.openVendorMenu(net_index, is_vendor)
end)

function rp.OpenVendorNpcMenu(ent)
    rp.item.openVendorMenu(ent:EntIndex(), true)
end

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
rp.VendorsNPCsStock = {};

net.Receive( "VendorNpc_StockCooldown", function()
    local vendor_id = net.ReadString();
    local item_id   = net.ReadString();
    local stock_cd  = net.ReadFloat();

    rp.VendorsNPCsStock[vendor_id]          = rp.VendorsNPCsStock[vendor_id] or {};
    rp.VendorsNPCsStock[vendor_id][item_id] = stock_cd;
end );

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
if not ENT then return end -- Что-бы я мог подгружать код с помощью lua_openscript_cl без удаления куска кода связанного с энтитёй.
-- Спасибо, ёбаный lua_refresh - который никогда не работает :( :( :(
-- Функционально на реальную работоспособность скрипта ни как не влияет, по этому просьба не убирать это для удобства дальнейших правок и обновлений.

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw()
    self:DrawModel()
end

function ENT:SetRagdollBones(bIn)
    self.m_bRagdollSetup = bIn
end

if rp.DrawInfoBubble then return end

local tr = translates
local cached
local function check_cached_string()
    if cached then return end

    if tr then
        cached = tr.Get( "[E] Открыть Магазин" )
    else
        cached = "[E] Открыть Магазин"
    end
end

function ENT:DrawTranslucent()
    local obb = self:OBBMaxs()
    local pos = (self:LookupBone("ValveBiped.Bip01_Head1") and self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")) or IsValid(self) and self:GetPos() + Vector(0, 0, 64) or Vector(0, 0, 0)) + Vector(0, 0, 16)
    if LocalPlayer():GetPos():DistToSqr(pos) > (800 * 800) then return end
    local ang = LocalPlayer():EyeAngles()
    ang:RotateAroundAxis(ang:Forward(), 90)
    ang:RotateAroundAxis(ang:Right(), 90)
    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1)
    local _, tall = draw_SimpleText(self:GetVendorName(), "VendorNpc_Name", 0, 0, white_color, TEXT_ALIGN_CENTER)
    check_cached_string()
    draw_SimpleText(cached, "VendorNpc_Text", 0, tall, color_green, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Initialize()
    local index = self:EntIndex()

    hook.Add("PostDrawTranslucentRenderables", "DrawNpc_" .. index, function()
        if not IsValid(self) then
            hook.Remove("PostDrawTranslucentRenderables", "DrawNpc_" .. index)

            return
        end

        self:DrawTranslucent()
    end)
end
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————