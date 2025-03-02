-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
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

--————————————————————————————————————————————————————————————————————————————————————————————————————————

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

function PANEL:AddItem(id, name, price, mdl, override_mat)
    local already = self:GetItem(id)
    if IsValid(already) then return end

    self.Items[id] = {
        ["id"] = id,
        ["name"] = name,
        ["price"] = price,
        ["override_mat"] = override_mat,
        ["mdl"] = mdl or "models/props_borealis/bluebarrel001.mdl",
        ["count"] = count,
        ["category"] = category, 
    }

    local parent = self:GetPlace4Items()
    return self:AddItemButton(parent, self.Items[id])
end

local math_max, string_len, utf8_len = math.max, string.len, utf8.len

function PANEL:AddItemButton(parent, data)
    local parent = self:GetPlace4Items()
    local that = self:GetItem(data.id)

    local item_btn = vgui.Create("DButton")
    item_btn:SetText("")
    item_btn:Dock(TOP)
    item_btn:SetTall(56)
    item_btn:InvalidateParent(true)

    item_btn.DoClick = self.item_doclick_func

    item_btn.data_table = table.Copy(data)
    
    local utf8_sub = utf8.sub

    item_btn.Paint = function(that, w, h)
        if not IsValid(self) then return end

		local cur_amount = self.Parent.StorageEnt:GetAmount()
        local baseColor = self.GetPaintStyle(that, STYLE_TRANSPARENT_SELECTABLE)

        if cur_amount < data.price then
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

        if that.data_table["price"] then
            draw_SimpleText(that.data_table["price"] .. " " .. translates.Get("Запасов"), "rpui.Fonts.VendorNpc_Price", w - 12, h - 8, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end
    end

    item_btn.mdl_ico = vgui.Create("rpui.VendorItemIcon", item_btn)
    local sz = item_btn:GetTall() * 0.9
    item_btn.mdl_ico:SetSize(sz, sz)
    local ps = (item_btn:GetTall() - sz) / 2
    item_btn.mdl_ico:SetPos(ps, ps)
    item_btn.mdl_ico:SetMouseInputEnabled(false)

    local cur_data = table.Copy(data)
    local id = cur_data["id"]
    if id and rp.item.icons[id] then
        item_btn.mdl_ico.MatIcon = rp.item.icons[id]
		
    else
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

    parent:AddItem(item_btn)

    self.ItemPanels[data.id] = item_btn
    return item_btn
end

function PANEL:GetItem(id)
    local item = self.ItemPanels[id]
    if IsValid(item) then return item end
end

vgui.Register("FactoryStorage_Tab", PANEL, "EditablePanel")

--————————————————————————————————————————————————————————————————————————————————————————————————————————

local PANEL = {}
PANEL.UIColors = local_ui_colrs
PANEL.GetPaintStyle = local_paint_style

function PANEL:Init()
	rp.factory.Menu = self
	
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

	self.Amt = vgui.Create("DLabel", self)
	self.Amt:SetText('Запас: 99999 / 99999')
	self.Amt:SetPos(30, 45)
	self.Amt:SetContentAlignment(5)
	self.Amt:SetSize(self:GetWide(), 50)
	self.Amt:SetFont('rpui.Fonts.VendorNpc_Count')
	
    self.tabsshop = vgui.Create("FactoryStorage_Tab", self)
    self.tabsshop.Parent = self
    self.tabsshop:SetSize(self:GetWide() - 60, self:GetTall() - 124)
    self.tabsshop:SetPos(30, 90)

    self.tabsshop:SetItemClickFunc(function(pnl)
        local data = pnl.data_table
		
		if data.price > self.StorageEnt:GetAmount() then
			rp.Notify(NOTIFY_ERROR, translates.Get('Недостаточно запасов!'))
			return
		end
		
		if data.price > self.StorageEnt:GetAmount() then
			rp.Notify(NOTIFY_ERROR, translates.Get('Недостаточно запасов!'))
			return
		end
		
        net.Start('Factory::GetFromStorage')
			net.WriteEntity(self.StorageEnt)
			net.WriteUInt(data.id, 16)
		net.SendToServer()
    end)
end

function PANEL:SetStorage(ent)
    self.StorageEnt = ent
    self.Storage = rp.factory.Storages[ent:GetStorageID()]
	
	for k, v in pairs(self.Storage.StorageBenefits) do
		if not v.check or v.check(LocalPlayer()) then
			self.tabsshop:AddItem(v.ID, v.name, v.price, v.model, v.icon)
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
        self.Amt:SetSize(self:GetWide() - 60, 50)
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
	
	if IsValid(self.StorageEnt) then
		self.Amt:SetText(translates.Get("Запасы: %s / %s", self.StorageEnt:GetAmount(), self.Storage.MaxAmount))
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
	
    if IsValid(self.slider_menu) then
        self.slider_menu:AlphaTo(0, 0.25, 0, function()
            if IsValid(self.slider_menu) then
                self.slider_menu:Remove()
            end
        end)
    end
end

vgui.Register("FactoryStorage_Menu", PANEL, "EditablePanel")
