-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_escmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface_CreateFont = surface.CreateFont
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier
local surface_SetMaterial = surface.SetMaterial
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_DrawLine = surface.DrawLine
local surface_DrawPoly = surface.DrawPoly
local draw_Blur = draw.Blur
local draw_NoTexture = draw.NoTexture
local draw_SimpleText = draw.SimpleText
local draw_RoundedBox = draw.RoundedBox
local math_min = math.min
local math_floor = math.floor
local math_sin = math.sin
local math_sqrt = math.sqrt

local PANEL = {}

function PANEL:RebuildFonts(frameW, frameH)
	surface_CreateFont("rpui.Fonts.ServerPanel.Default", {
		font = "Montserrat",
		extended = true,
		weight = 700,
		size = frameH * 0.16,
	})

	surface_CreateFont("rpui.Fonts.ServerPanel.Small", {
		font = "Montserrat",
		extended = true,
		weight = 500,
		size = frameH * 0.16,
	})

	surface_CreateFont("rpui.Fonts.ServerPanel.ExtraSmall", {
		font = "Montserrat",
		extended = true,
		weight = 500,
		size = frameH * 0.12,
	})

	surface_CreateFont("rpui.Fonts.ServerPanel.ExtraSmallBold", {
		font = "Montserrat",
		extended = true,
		weight = 700,
		size = frameH * 0.15,
	})
end

function PANEL:Init()
	self.ServerInfo = {}

	self.FeaturedIcon = vgui.Create("DImage", self)
	self.FeaturedIcon.SetMouseInputEnabled(self.FeaturedIcon, false)
	self.FeaturedIcon.SetImage(self.FeaturedIcon, "rpui/escmenu/icons/featured")

	self.FeaturedText = vgui.Create("DLabel", self)
	self.FeaturedText.SetTextColor(self.FeaturedText, rpui.UIColors.TextGold)
	self.FeaturedText.SetText(self.FeaturedText, translates.Get("СЕРВЕР МЕСЯЦА"))
	self.FeaturedText.SetMouseInputEnabled(self.FeaturedText, false)

	self.OnlineCount = vgui.Create("DLabel", self)
	self.OnlineCount.SetTextColor(self.OnlineCount, rpui.UIColors.White)
	self.OnlineCount.SetMouseInputEnabled(self.OnlineCount, false)
	self.ConnectAddress = "127.0.0.1"

	self.ConnectButton = vgui.Create("DLabel", self)
	self.ConnectButton.SetText(self.ConnectButton, translates.Get("ПОДКЛЮЧИТЬСЯ"))
	self.ConnectButton.SetMouseInputEnabled(self.ConnectButton, false)

	self.ConnectButton.Paint = function(this1, w, h)
		local baseColor, textColor1 = rpui.GetPaintStyle(self, STYLE_TRANSPARENT_INVERTED)
		surface_SetDrawColor(baseColor)
		surface_DrawRect(0, 0, w, h)
		draw_SimpleText(this1:GetText(), this1:GetFont(), w * 0.5, h * 0.5, textColor1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		return true
	end

	self.Name = vgui.Create("DLabel", self)
	self.Name.SetTextColor(self.Name, rpui.UIColors.White)
	self.Name.SetMouseInputEnabled(self.Name, false)

	self.PlayTime = vgui.Create("DLabel", self)
	self.PlayTime.SetTextColor(self.PlayTime, rpui.UIColors.White)
	self.PlayTime.SetMouseInputEnabled(self.PlayTime, false)

	self.PlayTimeIcon = vgui.Create("DImage", self)
	self.PlayTimeIcon.SetMouseInputEnabled(self.PlayTimeIcon, true)
	self.PlayTimeIcon.SetImage(self.PlayTimeIcon, "rpui/escmenu/icons/playtime")
	rpui.ESCMenu.RegisterTooltip(rpui.ESCMenu, self.PlayTimeIcon, translates.Get("Наигранное время"), TOOLTIP_OFFSET_CENTER)

	self.UserRankIcon = vgui.Create("DImage", self)
	self.UserRankIcon.SetMouseInputEnabled(self.UserRankIcon, true)
	rpui.ESCMenu.RegisterTooltip(rpui.ESCMenu, self.UserRankIcon, "", TOOLTIP_OFFSET_CENTER)

	self.TimeMultiplier = vgui.Create("DLabel", self)
	self.TimeMultiplier.SetTextColor(self.TimeMultiplier, rpui.UIColors.TextGold)
	self.TimeMultiplier.SetContentAlignment(self.TimeMultiplier, 4)
	self.TimeMultiplier.SetMouseInputEnabled(self.TimeMultiplier, false)

	self.TimeMultiplierIcon = vgui.Create("DImage", self)
	self.TimeMultiplierIcon.SetImage(self.TimeMultiplierIcon, "rpui/escmenu/icons/xtime")
	self.TimeMultiplierIcon.SetMouseInputEnabled(self.TimeMultiplierIcon, false)

	self.SalesAmount = vgui.Create("DLabel", self)
	self.SalesAmount.SetTextColor(self.SalesAmount, rpui.UIColors.TextGold)
	self.SalesAmount.SetContentAlignment(self.SalesAmount, 4)
	self.SalesAmount.SetMouseInputEnabled(self.SalesAmount, false)

	self.SalesIcon = vgui.Create("DImage", self)
	self.SalesIcon.SetImage(self.SalesIcon, "rpui/escmenu/icons/xdonate")
	self.SalesIcon.SetMouseInputEnabled(self.SalesIcon, false)
end

function PANEL:DoClick()
	if not self.Timeout then
		self.Timeout = SysTime() + 5
		self.ConnectButton.SetText(self.ConnectButton, translates.Get("ПОДТВЕРДИТЕ"))

		return
	end

	net.Start("rp.Stat.ServerConnections")
	net.WriteString(self.ConnectAddress)
	net.SendToServer()

	LocalPlayer():ConCommand("connect " .. self.ConnectAddress)
end

function PANEL:Think()
	if self.Timeout and self.Timeout < SysTime() then
		self.ConnectButton.SetText(self.ConnectButton, translates.Get("ПОДКЛЮЧИТЬСЯ"))
		self.Timeout = nil
	end
end

function PANEL:Paint(w, h)
	if self.ServerInfo then
		if not self.BackgroundMat then
			self.BackgroundMat = Material("rpui/escmenu/backgrounds/" .. self.ServerInfo.uid)
		end

		surface_SetDrawColor(rpui.UIColors.White)
		surface_SetMaterial(self.BackgroundMat)
		surface_DrawTexturedRect(0, 0, w, h)
		surface_SetDrawColor(rpui.UIColors.Background)
		surface_DrawRect(0, 0, w, h)
	end

	return true
end

function PANEL:SetServerInfo(serveraddress, serverinfo)
	self.ServerInfo.address = serveraddress
	table.Merge(self.ServerInfo, serverinfo)
end

function PANEL:RebuildLayout()
	self:InvalidateParent(true)
	self:SetTall(self:GetWide() * 0.25)

	local par1 = self:GetParent()
	par1:InvalidateLayout(true)
	par1:SizeToChildren(false, true)

	local w, h = self:GetSize()
	self:RebuildFonts(w, h)

	self.FeaturedText.SetFont(self.FeaturedText, "rpui.Fonts.ServerPanel.ExtraSmallBold")
	self.OnlineCount.SetFont(self.OnlineCount, "rpui.Fonts.ServerPanel.Default")
	self.ConnectButton.SetFont(self.ConnectButton, "rpui.Fonts.ServerPanel.ExtraSmall")
	self.Name.SetFont(self.Name, "rpui.Fonts.ServerPanel.Default")
	self.PlayTime.SetFont(self.PlayTime, "rpui.Fonts.ServerPanel.Small")
	self.TimeMultiplier.SetFont(self.TimeMultiplier, "rpui.Fonts.ServerPanel.ExtraSmallBold")
	self.SalesAmount.SetFont(self.SalesAmount, "rpui.Fonts.ServerPanel.ExtraSmallBold")
	surface_SetFont("rpui.Fonts.ServerPanel.ExtraSmallBold")

	local _, iconsize = surface_GetTextSize(" ")
	iconsize = 1.5 * iconsize
	self.FeaturedIcon.SetSize(self.FeaturedIcon, iconsize, iconsize)
	self.FeaturedIcon.SetPos(self.FeaturedIcon, h * 0.1, h * 0.05)
	self.FeaturedText.SizeToContentsX(self.FeaturedText)
	self.FeaturedText.SetTall(self.FeaturedText, iconsize)
	self.FeaturedText.SetPos(self.FeaturedText, h * 0.1 + iconsize + h * 0.025, h * 0.05)

	if self.ServerInfo.featured then
		self.FeaturedIcon.SetVisible(self.FeaturedIcon, true)
		self.FeaturedText.SetVisible(self.FeaturedText, true)
	else
		self.FeaturedIcon.SetVisible(self.FeaturedIcon, false)
		self.FeaturedText.SetVisible(self.FeaturedText, false)
	end

	self.OnlineCount.SetText(self.OnlineCount, translates.Get("Онлайн: %s/125", self.ServerInfo.players))
	self.OnlineCount.SizeToContents(self.OnlineCount)
	self.OnlineCount.SetPos(self.OnlineCount, h * 0.1, h * 0.95 - self.OnlineCount.GetTall(self.OnlineCount))

	self.ConnectAddress = self.ServerInfo.address
	self.ConnectButton.SizeToContentsX(self.ConnectButton, h * 0.1)
	self.ConnectButton.SetTall(self.ConnectButton, self.OnlineCount.GetTall(self.OnlineCount))
	self.ConnectButton.SetPos(self.ConnectButton, self.OnlineCount.x + self.OnlineCount.GetWide(self.OnlineCount) + h * 0.05, self.OnlineCount.y)

	self.Name.SetText(self.Name, self.ServerInfo.title)
	self.Name.SizeToContents(self.Name)
	self.Name.SetPos(self.Name, h * 0.1, h * 0.95 - self.OnlineCount.GetTall(self.OnlineCount) - self.Name.GetTall(self.Name))

	local playtime = self.ServerInfo.userdata["playtime"] or 0
	local sync_hours = self.ServerInfo.userdata["synchours"] or 0
	local cur_hours = math_floor(playtime / 3600)
	local new_hours = math_min(math_floor(sync_hours / 2), 150)

	if cur_hours < new_hours then
		self.PlayTime.SetText(self.PlayTime, ba.str.FormatTime(new_hours * 3600))
	else
		self.PlayTime.SetText(self.PlayTime, ba.str.FormatTime(playtime))
	end

	self.PlayTime.SizeToContentsX(self.PlayTime)
	surface_SetFont("rpui.Fonts.ServerPanel.Small")
	_, iconsize = surface_GetTextSize(" ")
	iconsize = 1.25 * iconsize
	self.PlayTime.SetPos(self.PlayTime, w - h * 0.1 - self.PlayTime.GetWide(self.PlayTime), h * 0.95 - iconsize)
	self.PlayTime.SetTall(self.PlayTime, iconsize)

	self.PlayTimeIcon.SetSize(self.PlayTimeIcon, iconsize, iconsize)
	self.PlayTimeIcon.SetPos(self.PlayTimeIcon, w - h * 0.1 - self.PlayTime.GetWide(self.PlayTime) - h * 0.025 - iconsize, h * 0.95 - iconsize)
	self.UserRankIcon.SetSize(self.UserRankIcon, iconsize, iconsize)
	self.UserRankIcon.SetPos(self.UserRankIcon, w - h * 0.1 - self.PlayTime.GetWide(self.PlayTime) - h * 0.025 - iconsize - h * 0.05 - iconsize, h * 0.95 - iconsize)
	self.UserRankIcon.SetMaterial(self.UserRankIcon, "rpui/escmenu/usericons/" .. (self.ServerInfo.userdata["rank"] or 1))
	self.UserRankIcon.TooltipText = ba.ranks.Get(tonumber(self.ServerInfo.userdata["rank"]) or 1).GetNiceName(ba.ranks.Get(tonumber(self.ServerInfo.userdata["rank"]) or 1))

	local ox, oy = 0, 0
	surface_SetFont("rpui.Fonts.ServerPanel.ExtraSmallBold")
	_, iconsize = surface_GetTextSize(" ")
	iconsize = 1.35 * iconsize

	if (tonumber(self.ServerInfo.serverdata.time_multiplier_time or "0") or 0) > 0 then
		self.TimeMultiplier.SetText(self.TimeMultiplier, translates.Get(" УСКОРЕННОЕ ПОЛУЧЕНИЕ ВРЕМЕНИ! (x%s)", (tonumber(self.ServerInfo.serverdata.time_multiplier) + 1 or "2")))
		self.TimeMultiplier.SizeToContentsX(self.TimeMultiplier)
		self.TimeMultiplier.SetTall(self.TimeMultiplier, iconsize)
		self.TimeMultiplier.SetPos(self.TimeMultiplier, w - h * 0.1 - self.TimeMultiplier.GetWide(self.TimeMultiplier), oy + h * 0.05)

		ox, oy = self.TimeMultiplier.GetPos(self.TimeMultiplier)
		self.TimeMultiplierIcon.SetSize(self.TimeMultiplierIcon, iconsize, iconsize)
		self.TimeMultiplierIcon.SetPos(self.TimeMultiplierIcon, ox - iconsize, oy)
		ox = w - 0.1 * h
		oy = oy + 0.85 * iconsize
	else
		self.TimeMultiplier.SetVisible(self.TimeMultiplier, false)
		self.TimeMultiplierIcon.SetVisible(self.TimeMultiplierIcon, false)
	end

	if (tonumber(self.ServerInfo.serverdata.sales_global_timeleft or "0") or 0) > 0 then
		self.SalesAmount.SetText(self.SalesAmount, translates.Get("СКИДКИ НА ДОНАТ! (%s", (self.ServerInfo.serverdata.sales_global_amount or "??")) .. "%)")
		self.SalesAmount.SizeToContentsX(self.SalesAmount)
		self.SalesAmount.SetTall(self.SalesAmount, iconsize)
		self.SalesAmount.SetPos(self.SalesAmount, ox - self.SalesAmount.GetWide(self.SalesAmount), oy)

		ox = ox - self.SalesAmount.GetWide(self.SalesAmount)
		self.SalesIcon.SetSize(self.SalesIcon, iconsize, iconsize)
		self.SalesIcon.SetPos(self.SalesIcon, ox - iconsize, oy)
	else
		self.SalesAmount.SetVisible(self.SalesAmount, false)
		self.SalesIcon.SetVisible(self.SalesIcon, false)
	end
end

vgui.Register("rpui.ServerPanel", PANEL, "DButton")

PANEL = {}
PANEL.MENUBUTTON_SPACER = 0
PANEL.MENUBUTTON_BUTTON = 1
PANEL.MENUBUTTON_BUTTONCONFIRM = 2

local PopupAddItem = function(self, text, data)
	if not IsValid(self.scroll) then return end

	if text == 0 then
		local pnl = vgui.Create("EditablePanel")
		pnl:Dock(TOP)
		pnl:SetTall(self.SpacerTall)

		self.scroll_items[text] = pnl
		self.scroll.AddItem(self.scroll, pnl)
		return
	end
	
	local pnl = vgui.Create("DButton")
	pnl:SetText("")
	pnl:Dock(TOP)
	pnl:SetFont("rpui.Fonts.ESCMenu.MenuButton")
	pnl:SetTall(self.ItemsTall)
	pnl.Paint = function(me, w, h)
		--draw_Blur(me)
		local baseColor, textColor = rpui.GetPaintStyle(me, STYLE_TRANSPARENT_INVERTED)
		surface_SetDrawColor(baseColor)
		surface_DrawRect(0, 0, w, h)
		draw_SimpleText(text, me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	pnl.DoClick = function()
		self.MainParent:SetText(translates.Get("СПРАВОЧНИК"))

		if isstring(data) then
			gui.OpenURL(data)
		else
			self:Close()
			data(pnl)
		end
		self.pseudo_parent.Callback(text, data)
	end

	pnl.data = data
	self.scroll_items[text] = pnl
	self.scroll.AddItem(self.scroll, pnl)
end


local Manual = {
	Type = PANEL.MENUBUTTON_BUTTON,
	Name = translates.Get("СПРАВОЧНИК"),
	DoClick = function(me)
		me.DropDown:DoClick()
	end,
	OnInit = function(me)
		local ManualButtons = {}
		table.insert(ManualButtons, {translates.Get("СООБЩИТЬ О БАГЕ"), rp.cfg.BugReportURL or "https://docs.google.com/forms/d/e/1FAIpQLSeaSn4L8lYfc3Vi-J7D5r-72eWov11ID3eaiCIM9Lo_gzMbag/viewform?fbzx=-5938950116545347063"})
		for i, v in pairs(rp.cfg.MoTD) do
			if utf8.lower(v[1]):find("контент") then continue end
			table.insert(ManualButtons, {utf8.upper(v[1]), v[2]})
		end

		local ManualBtn = me
		local bgCol = Color(0, 0, 0, 0)

		me.DropDown = me:Add("urf.im/rpui/dropdownselector")
		me.DropDown:SetPos( me:LocalToScreen(0, 0) )
		me.DropDown:Dock(FILL)
		me.DropDown:SetMouseInputEnabled(false)
		me.DropDown.Paint = function(me)
			if IsValid(me.popup) then
				if me.PopupDetected then return end
				me.PopupDetected = true
				me:OnPopupDetected(me.popup)
			else
				me.PopupDetected = nil
			end
		end
		me.DropDown.DoClick = function(self)
			if IsValid(self.popup) then
				self.popup.Close(self.popup)
				ManualBtn:SetText(translates.Get("СПРАВОЧНИК"))
				return
			else
				ManualBtn:SetText(translates.Get("ЗАКРЫТЬ СПРАВОЧНИК"))

				self.popup = vgui.Create("urf.im/rpui/dropdownselector/popup")
				self.popup.SpacerTall = rpui.ESCMenu.frameH * 0.025

				local popup = self.popup
				
				popup.pseudo_parent = self
				popup.MainParent = ManualBtn
				local x, y = self:LocalToScreen(0, 0)
				popup:SetPos(x + ManualBtn:GetWide() + 16, y) --+ rpui.ESCMenu.frameH * 0.025)
				popup:SetSize(self:GetWide(), ManualBtn:GetTall() * #ManualButtons)
				popup:MakePopup()
				--popup:SetFocusTopLevel(true)
				popup:SetZPos(999)
				popup:SetKeyboardInputEnabled(false)
				popup:PostSizeChange()
				popup.ScrollSpacer:Remove()
				popup.scroll:SetSpacingY(0)
				popup.scroll.VBar:SetScrollbarWidth(0)
				popup.Close = function(self)
					if self.InClose then return end
					self.InClose = true

					self:MakePopup()
					self:SetZPos(999)
					--self:SetFocusTopLevel(true)
					self:SetKeyboardInputEnabled(false)

					self:SizeTo(self:GetWide(), 0, 0.2, 0, -1, function()
						if IsValid(self) then
							self:Remove()
							if IsValid(ManualBtn) then ManualBtn:SetText(translates.Get("СПРАВОЧНИК")) end
						end
					end)
				end


				popup.PaintOver = function(me)
					if IsValid(rpui.ESCMenu) == false or rpui.ESCMenu:IsVisible() == false then
						me:Remove()
						if IsValid(ManualBtn) then ManualBtn:SetText(translates.Get("СПРАВОЧНИК")) end
					else
						me:SetAlpha(rpui.ESCMenu:GetAlpha())
					end
				end

				if self.NotFirstClick then return end
				self.NotFirstClick = true

				for k, v in pairs(self.items) do
					popup:AddItem(v[1], v[2])
				end

				popup:SetKeyboardInputEnabled(false)
			end
		end


		me.DropDown.OnPopupDetected = function(me, popup)
			popup.Colors.Background = bgCol
			popup.ItemsTall = ManualBtn:GetTall()
			popup.AddItem = PopupAddItem

			for k, v in pairs(ManualButtons) do
				me:AddItem(v[1], v[2])
			end
		end

		me.DropDown.Callback = function(ico, data) end

		me.DropDown:SetKeyboardInputEnabled(false)
	end,
}

PANEL.MenuButtons = {
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("ПРОДОЛЖИТЬ ИГРУ"),
		DoClick = function(this2)
			rpui.ESCMenu.HideMenu(rpui.ESCMenu)
		end
	},
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("НАЙТИ СЕТЕВУЮ ИГРУ"),
		DoClick = function(this3)
			rpui.ESCMenu.HideMenu(rpui.ESCMenu)

			if not rpui.ServerBrowser then
				rpui.ServerBrowser = vgui.Create("Panel")
				rpui.ServerBrowser.SetSize(rpui.ServerBrowser, ScrW(), ScrH())
				rpui.ServerBrowser.Center(rpui.ServerBrowser)
				rpui.ServerBrowser.MakePopup(rpui.ServerBrowser)
				rpui.ServerBrowser:SetKeyboardInputEnabled(false)

				rpui.ServerBrowser.Think = function(this4)
					if (input.IsKeyDown(KEY_ESCAPE) or input.IsKeyDown(KEY_X) or (input.IsKeyDown(KEY_F4) and this4.CanClose)) and not this4.Closing then
						gui.HideGameUI()

						if IsValid(rpui.ESCMenu) then
							rpui.ESCMenu.HideMenu(rpui.ESCMenu)
						end

						this4:Close()
					end
				end

				rpui.ServerBrowser.Paint = function(this5, w, h)
					draw_Blur(this5)
					surface_SetDrawColor(rpui.UIColors.Shading)
					surface_DrawRect(0, 0, w, h)
				end

				rpui.ServerBrowser.Close = function(this6)
					if not this6.Closing then
						this6:AlphaTo(0, 0.25, 0, function()
							this6:SetVisible(false)
							this6.Closing = false
						end)
					end

					this6.Closing = true
				end

				local frameW, frameH77 = rpui.ServerBrowser.GetSize(rpui.ServerBrowser)
				local framePadding = 0.05 * frameH77 * 1
				rpui.ServerBrowser.DockPadding(rpui.ServerBrowser, framePadding, framePadding, framePadding, framePadding)

				surface_CreateFont("rpui.Fonts.ServerBrowser.Title", {
					font = "Montserrat",
					extended = true,
					weight = 600,
					size = frameH77 * 0.06,
				})

				surface_CreateFont("rpui.Fonts.ServerBrowser.Close", {
					font = "Montserrat",
					extended = true,
					weight = 500,
					size = frameH77 * 0.025,
				})

				rpui.ServerBrowser.Header = vgui.Create("Panel", rpui.ServerBrowser)
				rpui.ServerBrowser.Header.Dock(rpui.ServerBrowser.Header, TOP)
				rpui.ServerBrowser.Header.DockMargin(rpui.ServerBrowser.Header, 0, 0, 0, framePadding)
				rpui.ServerBrowser.Header.InvalidateParent(rpui.ServerBrowser.Header, true)

				rpui.ServerBrowser.Header.Title = vgui.Create("DLabel", rpui.ServerBrowser.Header)
				rpui.ServerBrowser.Header.Title.SetFont(rpui.ServerBrowser.Header.Title, "rpui.Fonts.ServerBrowser.Title")
				rpui.ServerBrowser.Header.Title.SetTextColor(rpui.ServerBrowser.Header.Title, rpui.UIColors.White)
				rpui.ServerBrowser.Header.Title.SetText(rpui.ServerBrowser.Header.Title, translates.Get("СПИСОК СЕРВЕРОВ"))
				rpui.ServerBrowser.Header.Title.SizeToContentsX(rpui.ServerBrowser.Header.Title)
				rpui.ServerBrowser.Header.Title.SizeToContentsY(rpui.ServerBrowser.Header.Title)
				rpui.ServerBrowser.Header.InvalidateLayout(rpui.ServerBrowser.Header, true)
				rpui.ServerBrowser.Header.SizeToChildren(rpui.ServerBrowser.Header, false, true)

				rpui.ServerBrowser.Header.CloseButton = vgui.Create("DButton", rpui.ServerBrowser.Header)
				rpui.ServerBrowser.Header.CloseButton.Dock(rpui.ServerBrowser.Header.CloseButton, RIGHT)
				rpui.ServerBrowser.Header.CloseButton.DockMargin(rpui.ServerBrowser.Header.CloseButton, 0, framePadding * 0.25, 0, framePadding * 0.25)
				rpui.ServerBrowser.Header.CloseButton.SetFont(rpui.ServerBrowser.Header.CloseButton, "rpui.Fonts.ServerBrowser.Close")
				rpui.ServerBrowser.Header.CloseButton.SetText(rpui.ServerBrowser.Header.CloseButton, translates.Get("ЗАКРЫТЬ"))
				rpui.ServerBrowser.Header.CloseButton.SizeToContentsX(rpui.ServerBrowser.Header.CloseButton, framePadding + rpui.ServerBrowser.Header.CloseButton.GetTall(rpui.ServerBrowser.Header.CloseButton))
				rpui.ServerBrowser.Header.CloseButton.Paint = function(this7, w2, h2)
					local baseColor, textColor2 = rpui.GetPaintStyle(this7)
					surface_SetDrawColor(baseColor)
					surface_DrawRect(0, 0, w2, h2)
					surface_SetDrawColor(rpui.UIColors.White)
					surface_DrawRect(0, 0, h2, h2)
					surface_SetDrawColor(Color(0, 0, 0, this7._grayscale or 0))
					local p = 0.1 * h2
					surface_DrawLine(h2, p, h2, h2 - p)
					draw_SimpleText("✕", this7:GetFont(), h2 * 0.5, h2 * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw_SimpleText(this7:GetText(), this7:GetFont(), w2 * 0.5 + h2 * 0.5, h2 * 0.5, textColor2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					return true
				end

				rpui.ServerBrowser.Header.CloseButton.DoClick = function()
					rpui.ServerBrowser.Close(rpui.ServerBrowser)
				end

				rpui.ServerBrowser.ListScroll = vgui.Create("rpui.ScrollPanel", rpui.ServerBrowser)
				rpui.ServerBrowser.ListScroll.Dock(rpui.ServerBrowser.ListScroll, FILL)
				rpui.ServerBrowser.ListScroll.SetScrollbarMargin(rpui.ServerBrowser.ListScroll, framePadding * 0.23)
				rpui.ServerBrowser.ListScroll.SetAlpha(rpui.ServerBrowser.ListScroll, 0)
				rpui.ServerBrowser.List = vgui.Create("rpui.ColumnView")
				rpui.ServerBrowser.ListScroll.AddItem(rpui.ServerBrowser.ListScroll, rpui.ServerBrowser.List)
				rpui.ServerBrowser.List.Dock(rpui.ServerBrowser.List, FILL)
				rpui.ServerBrowser.List.SetColumns(rpui.ServerBrowser.List, 3)
				rpui.ServerBrowser.List.SetSpacingX(rpui.ServerBrowser.List, framePadding * 0.5)
				rpui.ServerBrowser.List.SetSpacingY(rpui.ServerBrowser.List, framePadding * 0.5)
				rpui.ServerBrowser.List.ServerCards = {}

				if rpui.ESCServerData then
					local ESCServerDataGroups = {}

					for k, v in pairs(rpui.ESCServerData) do
						local arrTitle = string.Explode(" | ", v.title)
						ESCServerDataGroups[arrTitle[2] .. ''] = ESCServerDataGroups[arrTitle[2] .. ''] or {}
						table.insert(ESCServerDataGroups[arrTitle[2] .. ''], k)
					end

					local cardHeight

					for servergroup, servers in pairs(ESCServerDataGroups) do
						local ServerCard = vgui.Create("Panel")
						rpui.ServerBrowser.List.AddItem(rpui.ServerBrowser.List, ServerCard)
						table.insert(rpui.ServerBrowser.List.ServerCards, ServerCard)
						ServerCard.Dock(ServerCard, TOP)
						ServerCard.InvalidateParent(ServerCard, true)

						ServerCard.Paint = function(__, w, h)
							surface_SetDrawColor(rpui.UIColors.Background)
							surface_DrawRect(0, 0, w, h)
						end

						ServerCard.UpdateServer = function(this8, address)
							if not address then
								if this8.__pointer then
									address = this8.__pointer
								else
									return
								end
							else
								this8.__pointer = address
							end

							local serverinfo = rpui.ESCServerData[address]
							local arrTitle = string.Explode(" | ", serverinfo.title)
							this8.MetaContainer.Gamemode.SetText(this8.MetaContainer.Gamemode, arrTitle[2])
							this8.MetaContainer.PlayersIcon.AlphaTo(this8.MetaContainer.PlayersIcon, 0, 0.25)

							this8.MetaContainer.Players.AlphaTo(this8.MetaContainer.Players, 0, 0.25, 0, function()
								this8.MetaContainer.Players.SetText(this8.MetaContainer.Players, translates.Get("%s человек онлайн", serverinfo.players))
								this8.MetaContainer.Players.SizeToContentsX(this8.MetaContainer.Players)
								this8.MetaContainer.Players.AlphaTo(this8.MetaContainer.Players, 255, 0.25)
								this8.MetaContainer.PlayersIcon.AlphaTo(this8.MetaContainer.PlayersIcon, 255, 0.25)
							end)

							this8.Description.AlphaTo(this8.Description, 0, 0.25, 0, function()
								local desc = string.Replace(serverinfo["card-description"], '\\"', '"')
								this8.Description.SetText(this8.Description, desc)
								this8.Description.AlphaTo(this8.Description, 255, 0.25)
							end)

							this8.ConnectButton.ConnectAddress = address
							this8.AboutButton.AboutAddress = serverinfo.server
						end

						-- ServerCard.HTML = vgui.Create("DHTML", ServerCard)
						-- ServerCard.HTML.Dock(ServerCard.HTML, LEFT)
						-- ServerCard.HTML.SetMouseInputEnabled(ServerCard.HTML, false)
						-- ServerCard.HTML.InvalidateParent(ServerCard.HTML, true)
						-- 
						-- ServerCard.HTML.Paint = function(___, w, h)
						-- 	surface_SetDrawColor(rpui.UIColors.Background)
						-- 	surface_DrawRect(0, 0, w, h)
						-- end
						-- 
						-- ServerCard.HTML.SetHTML(ServerCard.HTML, "<html><head><style>body {margin: 0;background-size: 100% 100%;box-shadow: inset 0px 0px 16px 0px rgba(0,0,0,0.75);background-image: url(https://urf.im/" .. rpui.ESCServerData[servers[1]]["card-cover"] .. ");}</style></head></html>")
						
						ServerCard.HTML = vgui.Create("Panel", ServerCard)
						ServerCard.HTML.Dock(ServerCard.HTML, LEFT)
						ServerCard.HTML.SetMouseInputEnabled(ServerCard.HTML, false)
						ServerCard.HTML.InvalidateParent(ServerCard.HTML, true)
						ServerCard.HTML.URL = "https://urf.im/" .. rpui.ESCServerData[servers[1]]["card-cover"]
						ServerCard.HTML.Paint = function(srvcard_html, srvcard_w, srvcard_h)
							surface_SetDrawColor(rpui.UIColors.Background)
							surface_DrawRect(0, 0, srvcard_w, srvcard_h)

							surface_SetDrawColor(rpui.UIColors.White)

							if (not srvcard_html.URLMaterial) or srvcard_html.URLMaterial:IsError() then
								srvcard_html.URLMaterial = rp.WebMat.Get(rp.WebMat, srvcard_html.URL, true)

								surface_SetMaterial(rp.WebMat.LoadingMat)
								local srvcard_icon = srvcard_w * 0.5; 
								surface_DrawTexturedRect(srvcard_w * 0.5 - srvcard_icon * 0.5, srvcard_h * 0.5 - srvcard_icon * 0.5, srvcard_icon, srvcard_icon)

								return
							end

							surface_SetMaterial(srvcard_html.URLMaterial)
							surface_DrawTexturedRect(0, 0, srvcard_w, srvcard_h)
						end

						ServerCard.Content = vgui.Create("Panel", ServerCard)
						ServerCard.Content.Dock(ServerCard.Content, FILL)
						ServerCard.Content.InvalidateParent(ServerCard.Content, true)

						timer.Simple(FrameTime() * 5, function()
							if not IsValid(ServerCard) then return end

							if not cardHeight then
								cardHeight = ServerCard:GetWide() / 2
							end

							ServerCard.SetTall(ServerCard, cardHeight)
							ServerCard.HTML.SetWide(ServerCard.HTML, ServerCard:GetWide() * 0.33)
							ServerCard.HTML.InvalidateParent(ServerCard.HTML, true)
							ServerCard.Content.InvalidateParent(ServerCard.Content, true)
							local w4 = ServerCard:GetWide()
							local h4 = ServerCard:GetTall()
							local cardPadding = 0.05 * ServerCard:GetTall()

							surface.CreateFont("ServerCard.Title", {
								font = "Montserrat",
								extended = true,
								weight = 700,
								size = w4 * 0.0425
							})

							surface.CreateFont("ServerCard.Meta", {
								font = "Montserrat",
								extended = true,
								weight = 500,
								size = w4 * 0.03
							})

							surface.CreateFont("ServerCard.MetaBold", {
								font = "Montserrat",
								extended = true,
								weight = 700,
								size = w4 * 0.03
							})

							ServerCard.Content.DockPadding(ServerCard.Content, cardPadding, cardPadding, cardPadding, cardPadding)
							local arrTitle

							if #servers > 1 then
								ServerCard.Selector = vgui.Create("rpui.ButtonWang", ServerCard.Content)
								ServerCard.Selector.Dock(ServerCard.Selector, TOP)
								ServerCard.Selector.SetFont(ServerCard.Selector, "ServerCard.Title")
								ServerCard.Selector.SetTall(ServerCard.Selector, h4 * 0.1)

								ServerCard.Selector.Prev.Paint = function(this9, w5, h5)
									local baseColor5, textColor5 = rpui.GetPaintStyle(this9, STYLE_TRANSPARENT_INVERTED)
									surface_SetDrawColor(baseColor5)
									surface_DrawRect(0, 0, w5, h5)
									draw_SimpleText(this9:GetText(), this9:GetFont(), w5 * 0.5, h5 * 0.5, textColor5, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

									return true
								end

								ServerCard.Selector.Next.Paint = function(this10, w6, h6)
									local baseColor6, textColor6 = rpui.GetPaintStyle(this10, STYLE_TRANSPARENT_INVERTED)
									surface_SetDrawColor(baseColor6)
									surface_DrawRect(0, 0, w6, h6)
									draw_SimpleText(this10:GetText(), this10:GetFont(), w6 * 0.5, h6 * 0.5, textColor6, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

									return true
								end
							else
								arrTitle = string.Explode(" | ", rpui.ESCServerData[servers[1] .. ''].title)
								ServerCard.Title = vgui.Create("DLabel", ServerCard.Content)
								ServerCard.Title.Dock(ServerCard.Title, TOP)
								ServerCard.Title.SetContentAlignment(ServerCard.Title, 5)
								ServerCard.Title.SetFont(ServerCard.Title, "ServerCard.Title")
								ServerCard.Title.SetTextColor(ServerCard.Title, rpui.UIColors.White)
								ServerCard.Title.SetText(ServerCard.Title, string.utf8upper(arrTitle[1]))
								ServerCard.Title.SetTall(ServerCard.Title, h4 * 0.1)
							end

							ServerCard.MetaContainer = vgui.Create("Panel", ServerCard.Content)
							ServerCard.MetaContainer.Dock(ServerCard.MetaContainer, TOP)
							ServerCard.MetaContainer.DockMargin(ServerCard.MetaContainer, 0, 0, 0, cardPadding)
							ServerCard.MetaContainer.InvalidateParent(ServerCard.MetaContainer, true)

							ServerCard.MetaContainer.Players = vgui.Create("DLabel", ServerCard.MetaContainer)
							ServerCard.MetaContainer.Players.Dock(ServerCard.MetaContainer.Players, RIGHT)
							ServerCard.MetaContainer.Players.SetContentAlignment(ServerCard.MetaContainer.Players, 5)
							ServerCard.MetaContainer.Players.SetFont(ServerCard.MetaContainer.Players, "ServerCard.Meta")
							ServerCard.MetaContainer.Players.SetTextColor(ServerCard.MetaContainer.Players, rpui.UIColors.White)
							ServerCard.MetaContainer.Players.SetText(ServerCard.MetaContainer.Players, translates.Get("%s человек онлайн", 0))

							ServerCard.MetaContainer.PlayersIcon = vgui.Create("DImage", ServerCard.MetaContainer)
							ServerCard.MetaContainer.PlayersIcon.Dock(ServerCard.MetaContainer.PlayersIcon, RIGHT)
							ServerCard.MetaContainer.PlayersIcon.SetWide(ServerCard.MetaContainer.PlayersIcon, ServerCard.MetaContainer.GetTall(ServerCard.MetaContainer))
							ServerCard.MetaContainer.PlayersIcon.SetImage(ServerCard.MetaContainer.PlayersIcon, "rpui/escmenu/usericons/1")

							ServerCard.MetaContainer.Gamemode = vgui.Create("DLabel", ServerCard.MetaContainer)
							ServerCard.MetaContainer.Gamemode.Dock(ServerCard.MetaContainer.Gamemode, FILL)
							ServerCard.MetaContainer.Gamemode.SetFont(ServerCard.MetaContainer.Gamemode, "ServerCard.Meta")
							ServerCard.MetaContainer.Gamemode.SetTextColor(ServerCard.MetaContainer.Gamemode, rpui.UIColors.White)
							ServerCard.MetaContainer.Gamemode.SetText(ServerCard.MetaContainer.Gamemode, "")

							ServerCard.ConnectButton = vgui.Create("DButton", ServerCard.Content)
							ServerCard.ConnectButton.Dock(ServerCard.ConnectButton, BOTTOM)
							ServerCard.ConnectButton.DockMargin(ServerCard.ConnectButton, 0, cardPadding * 0.5, 0, 0)
							ServerCard.ConnectButton.SetFont(ServerCard.ConnectButton, "ServerCard.MetaBold")
							ServerCard.ConnectButton.SetText(ServerCard.ConnectButton, translates.Get("ПОДКЛЮЧИТЬСЯ"))
							ServerCard.ConnectButton.SizeToContentsY(ServerCard.ConnectButton, cardPadding)
							ServerCard.ConnectButton.InvalidateParent(ServerCard.ConnectButton, true)
							ServerCard.ConnectButton.ConnectAddress = "127.0.0.1"

							ServerCard.ConnectButton.DoClick = function(this11)
								if not this11.Timeout then
									this11.Timeout = SysTime() + 5
									this11:SetText(translates.Get("ПОДТВЕРДИТЕ"))
								else
									net.Start("rp.Stat.ServerConnections")
									net.WriteString(this11.ConnectAddress)
									net.SendToServer()
									LocalPlayer():ConCommand("connect " .. this11.ConnectAddress)
								end
							end

							ServerCard.ConnectButton.Think = function(this12)
								if this12.Timeout and (this12.Timeout < SysTime()) then
									this12:SetText(translates.Get("ПОДКЛЮЧИТЬСЯ"))
									this12.Timeout = nil
								end
							end

							ServerCard.ConnectButton.Paint = function(this13, w7, h7)
								local baseColor7, textColor7 = rpui.GetPaintStyle(this13)
								surface_SetDrawColor(baseColor7)
								surface_DrawRect(0, 0, w7, h7)
								draw_SimpleText(this13:GetText(), this13:GetFont(), w7 * 0.5, h7 * 0.5, textColor7, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

								return true
							end

							ServerCard.AboutButton = vgui.Create("DButton", ServerCard.Content)
							ServerCard.AboutButton.Dock(ServerCard.AboutButton, BOTTOM)
							ServerCard.AboutButton.DockMargin(ServerCard.AboutButton, 0, cardPadding, 0, 0)
							ServerCard.AboutButton.SetFont(ServerCard.AboutButton, "ServerCard.MetaBold")
							ServerCard.AboutButton.SetText(ServerCard.AboutButton, translates.Get("УЗНАТЬ БОЛЬШЕ"))
							ServerCard.AboutButton.SizeToContentsY(ServerCard.AboutButton, cardPadding)
							ServerCard.AboutButton.InvalidateParent(ServerCard.AboutButton, true)
							ServerCard.AboutButton.AboutAddress = ""

							ServerCard.AboutButton.DoClick = function(this14)
								gui.OpenURL("https://urf.im/server/" .. this14.AboutAddress)
							end

							ServerCard.AboutButton.Paint = function(this15, w8, h8)
								local baseColor8, textColor8 = rpui.GetPaintStyle(this15)
								surface_SetDrawColor(baseColor8)
								surface_DrawRect(0, 0, w8, h8)
								draw_SimpleText(this15:GetText(), this15:GetFont(), w8 * 0.5, h8 * 0.5, textColor8, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

								return true
							end

							ServerCard.Description = vgui.Create("DLabel", ServerCard.Content)
							ServerCard.Description.Dock(ServerCard.Description, FILL)
							ServerCard.Description.SetWrap(ServerCard.Description, true)
							ServerCard.Description.SetContentAlignment(ServerCard.Description, 4)
							ServerCard.Description.SetFont(ServerCard.Description, "ServerCard.Meta")
							ServerCard.Description.SetTextColor(ServerCard.Description, rpui.UIColors.White)
							ServerCard.Description.SetText(ServerCard.Description, "")

							if #servers > 1 then
								ServerCard.Selector.OnValueChanged = function(this16, value)
									arrTitle = string.Explode(" | ", rpui.ESCServerData[value].title)
									this16:SetText(string.utf8upper(arrTitle[1]))
									ServerCard:UpdateServer(value)
								end

								ServerCard.Selector.SetValues(ServerCard.Selector, servers)
							else
								ServerCard:UpdateServer(servers[1])
							end
						end)
					end

					rpui.ServerBrowser.ListScroll.AlphaTo(rpui.ServerBrowser.ListScroll, 255, 0.25)
				end
			else
				for _, ServerCard in ipairs(rpui.ServerBrowser.List.ServerCards) do
					ServerCard:UpdateServer()
				end

				rpui.ServerBrowser.SetVisible(rpui.ServerBrowser, true)
				rpui.ServerBrowser.Stop(rpui.ServerBrowser)
				rpui.ServerBrowser.AlphaTo(rpui.ServerBrowser, 255, 0.25)
			end
		end
	},
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("ОТКРЫТЬ СТАРОЕ МЕНЮ"),
		DoClick = function()
			gui.ActivateGameUI()
			rpui.ESCMenu.HideMenu(rpui.ESCMenu)
		end
	},
	{
		Type = PANEL.MENUBUTTON_SPACER
	},
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("ДОНАТ"),
		DoClick = function()
			RunConsoleCommand("rp", "upgrades")
		end,
		Paint = function(this17, w10, h10)
			this17.rotAngle = (this17.rotAngle or 0) + 100 * FrameTime()
			local baseColor = rpui.GetPaintStyle(this17, STYLE_GOLDEN)
			surface_SetDrawColor(Color(0, 0, 0, this17:IsHovered() and 255 or 146))
			surface_DrawRect(0, 0, w10, h10)
			local distsize = math_sqrt(w10 * w10 + h10 * h10)
			local parentalpha = this17.ParentBase.GetAlpha(this17.ParentBase) / 255
			local alphamult = this17._alpha / 255
			surface_SetAlphaMultiplier(parentalpha * alphamult)
			surface_SetDrawColor(rpui.UIColors.BackgroundGold)
			surface_DrawRect(0, 0, w10, h10)
			surface_SetMaterial(rpui.GradientMat)
			surface_SetDrawColor(rpui.UIColors.Gold)
			surface_DrawTexturedRectRotated(w10 * 0.5, h10 * 0.5, distsize, distsize, (this17.rotAngle or 0))
			draw_SimpleText(this17:GetText(), "rpui.Fonts.ESCMenu.MenuButtonBold" or this17:GetFont(), w10 * 0.5, h10 * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface_SetAlphaMultiplier(parentalpha * (1 - alphamult))
			draw_SimpleText(this17:GetText(), "rpui.Fonts.ESCMenu.MenuButtonBold" or this17:GetFont(), w10 * 0.5, h10 * 0.5, rpui.UIColors.TextGold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface_SetAlphaMultiplier(1)

			return true
		end,
		PaintOver = function(this18, w11, h11)
			rpui.DrawStencilBorder(this18, 0, 0, w11, h11, 0.06, rpui.UIColors.BackgroundGold, rpui.UIColors.Gold, this18.ParentBase.GetAlpha(this18.ParentBase) / 255)
		end
	},
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		DoClick = function()
			RunConsoleCommand("rp", "upgrades")
		end,
		Paint = function(this00, w, h)
			local os_time = os.time()
			local is_sale = rp.GetDiscountTime() >= os_time
			local is_skinsmult = rp.GetSkinsDonateMultiplayerTime and (rp.GetSkinsDonateMultiplayerTime() >= os_time)
			local is_globalmult = rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() >= os_time
			local personal_ = LocalPlayer().GetPersonalDiscount and LocalPlayer():GetPersonalDiscount() * 100 or 0
			local multplyaer_personal_ = LocalPlayer().GetPersonalDonateMultiplayer and LocalPlayer():GetPersonalDonateMultiplayer() or 0

			if not is_sale and not is_skinsmult and not is_globalmult and personal_ <= 0 and multplyaer_personal_ <= 1 then
				this00:Remove()

				return
			end

			local Sale = is_sale and nw.GetGlobal("rp.shop.settings") or {
				global = 0,
				duntil = 0
			}

			local is_personal_sale

			if personal_ > Sale.global then
				Sale.global = personal_
			end

			if not is_sale and personal_ > 0 then
				is_sale = true
				is_personal_sale = true
			end

			local lines_num = 2
			local remain_txt = translates.Get("осталось")
			local sale_txt = is_personal_sale and translates.Get("ПЕРСОНАЛЬНАЯ СКИДКА") or translates.Get("СКИДКА")
			local on_all_txt = translates.Get("НА ВСЁ")
			this00.___dr_col = this00.___dr_col or Color(0, 0, 0, 255)
			local tooltip_phrase = ""
			local tooltip_phrase_args = {}
			local line2txt, custom_font_

			if is_sale then
				local allowed_cats = {
					["Шапки"] = true,
					["Время"] = true,
					["Профессии"] = true,
					["Валюта"] = true
				}

				local items = {}

				for k, v in pairs(rp.shop.GetTable()) do
					if allowed_cats[v.Cat] then
						table.insert(items, v)
					end
				end

				local item = items[math.random(1, #items)]
				local rub = " " .. translates.Get("РУБ")
				
				if item and item.Name then
					tooltip_phrase = "Например `%s` сейчас стоит %s вместо %s!"
					tooltip_phrase_args = {item.Name, math.floor(item.Price * (1 - Sale.global / 100)) .. rub, item.Price .. rub}
				end
			else
				if is_globalmult then
					local mult = (rp.GetDonateMultiplayer and rp.GetDonateMultiplayer() or 0)
					sale_txt = translates.Get("БОНУС")
					on_all_txt = translates.Get("НА ПОПОЛНЕНИЯ")

					Sale = {
						global = 100 * mult
					}

					tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"
					local min = rp.GetDonateMultiplayerMinimum()

					if min > 0 then
						lines_num = 3
						line2txt = translates.Get("при пожертвовании от %s руб", min)

						tooltip_phrase_args = {min + 50, (min + 50) * mult}
					else
						tooltip_phrase_args = {250, 250 * mult}
					end
				elseif is_skinsmult then
					sale_txt = translates.Get("БОНУС")
					on_all_txt = translates.Get("ДОНАТ СКИНАМИ")

					Sale = {
						global = 100 * rp.GetSkinsDonateMultiplayer()
					}

					tooltip_phrase = "Например если вы пожертвуете %s руб скинами, вы получите %s руб на ваш счёт"

					tooltip_phrase_args = {250, 250 * rp.GetSkinsDonateMultiplayer()}
				elseif multplyaer_personal_ > 1 then
					sale_txt = translates.Get("ПЕРСОНАЛЬНЫЙ БОНУС")
					on_all_txt = translates.Get("НА ПОПОЛНЕНИЯ")

					Sale = {
						global = multplyaer_personal_ * 100
					}

					custom_font_ = "rpui.Fonts.ESCMenu.Tooltip_2"
					tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"

					tooltip_phrase_args = {250, 250 * multplyaer_personal_}
				end
			end

			if tooltip_phrase ~= "" then
				this00:SetTooltip(translates.Get(tooltip_phrase, unpack(tooltip_phrase_args)))
			end

			local baseColor = rpui.GetPaintStyle(this00, STYLE_GOLDEN)
			surface.SetDrawColor(this00.___dr_col)
			local distsize = math.sqrt(w * w + h * h)
			local parentalpha = rpui.ESCMenu.GetAlpha(rpui.ESCMenu) / 255
			local alphamult = this00._alpha / 255

			rpui.ExperimentalStencil(function()
				draw.NoTexture()
				surface.SetDrawColor(rpui.UIColors.White)

				surface.DrawPoly({
					{
						x = 16,
						y = 16
					},
					{
						x = 0,
						y = 16
					},
					{
						x = 0,
						y = 0
					}
				})

				surface.DrawRect(0, 16, w, h)
				render.SetStencilCompareFunction(STENCIL_EQUAL)
				render.SetStencilFailOperation(STENCIL_KEEP)
				surface.SetAlphaMultiplier(rpui.ESCMenu.GetAlpha(rpui.ESCMenu) / 255)

				surface.SetDrawColor(rpui.UIColors.BackgroundGold)
				surface.DrawRect(0, 0, w, h)

				surface.SetMaterial(rpui.GradientMat)
				surface.SetDrawColor(rpui.UIColors.Gold)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, distsize, distsize, 0)

				local last = is_personal_sale and LocalPlayer():GetPersonalDiscountTime() or is_sale and (rp.GetDiscountTime() - os.time()) or (is_globalmult and (rp.GetDonateMultiplayerTime() - os.time()) or is_skinsmult and (rp.GetSkinsDonateMultiplayerTime() - os.time()) or LocalPlayer().GetPersonalDonateMultiplayerTime and LocalPlayer():GetPersonalDonateMultiplayerTime() or 0)
				local tb = string.FormattedTime((last > 0) and last or 0)
				local Out = remain_txt .. ' ' .. string.format("%02i:%02i:%02i", tb["h"], tb["m"], tb["s"])
				local show3lines = lines_num > 2
				local txt = sale_txt .. ' ' .. Sale.global .. '% ' .. on_all_txt

				surface.SetFont("rpui.Fonts.EscMenu.Hint1")
				local _w, _h = surface.GetTextSize(txt)
				draw.SimpleText(txt, "rpui.Fonts.EscMenu.Hint1" or Button:GetFont(), w * 0.5, show3lines and _h or h * 0.675, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_TOP or TEXT_ALIGN_BOTTOM)
				draw.SimpleText(line2txt or Out, "rpui.Fonts.EscMenu.Hint2" or Button:GetFont(), w * 0.5, h * 0.625, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_CENTER or TEXT_ALIGN_TOP)

				if show3lines then
					draw.SimpleText(Out, "rpui.Fonts.EscMenu.Hint2" or Button:GetFont(), w * 0.5, h * 0.95, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end

				surface.SetAlphaMultiplier(1)
			end)
		end,
		CustomCheck = function()
			local os_time = os.time()
			local b = (rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() >= os_time) or (rp.GetDiscountTime() >= os_time) or (rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() >= os_time) or (LocalPlayer().GetPersonalDiscountTime and LocalPlayer():GetPersonalDiscountTime() > 0) or (LocalPlayer().GetPersonalDonateMultiplayer and LocalPlayer():GetPersonalDonateMultiplayer() > 1)

			return b
		end,
		Renew = true,
		TallMult = function() return (rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() >= os.time()) and (rp.GetDonateMultiplayerMinimum and (rp.GetDonateMultiplayerMinimum() > 0)) and (1.15) or 1 end
	},
	{
		Type = PANEL.MENUBUTTON_SPACER
	},
--[[
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("ГРУППА ВКОНТАКТЕ"),
		DoClick = function()
			local content2

			for k, v in pairs(rp.cfg.MoTD or {}) do
				if v[1] == translates.Get('Группа ВК') then
					content2 = v[2]
					break
				end
			end

			gui.OpenURL(content2 or rp.cfg.VKGroup)
		end,
	},
]]
	Manual,
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("КОНТЕНТ СЕРВЕРА"),
		DoClick = function()
			local content1

			for k, v in pairs(rp.cfg.MoTD or {}) do
				if v[1] == translates.Get('Контент') then
					content1 = v[2]
					break
				end
			end

			gui.OpenURL(content1 or rp.cfg.ServerContentWorkshop)
		end
	},
	{
		Type = PANEL.MENUBUTTON_SPACER
	},
	{
		Type = PANEL.MENUBUTTON_BUTTON,
		Name = translates.Get("НАСТРОЙКИ"),
		DoClick = function()
			gui.ActivateGameUI()
			RunConsoleCommand("gamemenucommand", "openoptionsdialog")
			rpui.ESCMenu.HideMenu(rpui.ESCMenu)
		end
	},
	{
		Type = PANEL.MENUBUTTON_BUTTONCONFIRM,
		Name = translates.Get("ОТКЛЮЧИТЬСЯ"),
		DoClick = function()
			RunConsoleCommand("gamemenucommand", "disconnect")
		end
	},
	{
		Type = PANEL.MENUBUTTON_BUTTONCONFIRM,
		Name = translates.Get("ВЫЙТИ ИЗ ИГРЫ"),
		DoClick = function()
			RunConsoleCommand("gamemenucommand", "quit")
		end
	},
}

TOOLTIP_OFFSET_LEFT = 1 / 10
TOOLTIP_OFFSET_CENTER = 1 / 2

function PANEL:RegisterTooltip(panel, textfunc, offset, parentwidth, posfunc)
	if not self.Tooltip then
		self.Tooltip = vgui.Create("Panel", self)
		self.Tooltip.SetMouseInputEnabled(self.Tooltip, false)
		self.Tooltip.SetAlpha(self.Tooltip, 0)
		self.Tooltip.ArrowHeight = 0.01 * self.frameH
		self.Tooltip.DockPadding(self.Tooltip, self.frameW * 0.0075, self.frameH * 0.005, self.frameW * 0.0075, self.frameH * 0.005 + self.Tooltip.ArrowHeight)

		self.Tooltip.Label = vgui.Create("DLabel", self.Tooltip)
		self.Tooltip.Label.Dock(self.Tooltip.Label, TOP)
		self.Tooltip.Label.SetWrap(self.Tooltip.Label, true)
		self.Tooltip.Label.SetAutoStretchVertical(self.Tooltip.Label, true)
		self.Tooltip.Label.SetFont(self.Tooltip.Label, "rpui.Fonts.ESCMenu.Tooltip")
		self.Tooltip.Label.SetTextColor(self.Tooltip.Label, rpui.UIColors.White)
		self.Tooltip.Label.SetText(self.Tooltip.Label, "")
		self.Tooltip.TooltipOffset = -1
		self.Tooltip.IsActive = false

		self.Tooltip.Paint = function(this19, w, h)
			if string.Trim(this19.Label.GetText(this19.Label)) ~= "" then
				surface_SetDrawColor(rpui.UIColors.Tooltip)
				surface_DrawRect(0, 0, w, h - this19.ArrowHeight)

				if this19.BakedPoly then
					draw_NoTexture()
					surface_DrawPoly(this19.BakedPoly)
				end
			end
		end

		self.Tooltip.Think = function(this20)
			if IsValid(this20.ActivePanel) then
				if not this20.IsActive then
					this20.IsActive = true
					this20:Stop()
					this20:SetAlpha(0)
					this20:SetWide(this20.ActivePanel.GetWide(this20.ActivePanel))
					this20.Label.SetText(this20.Label, isfunction(this20.ActivePanel.TooltipText) and this20.ActivePanel.TooltipText(this20.ActivePanel) or this20.ActivePanel.TooltipText)
					this20.Label.SizeToContents(this20.Label)

					if not this20.ActivePanel.TooltipWidth then
						surface_SetFont(this20.Label.GetFont(this20.Label))
						local text_w, text_h = surface_GetTextSize(this20.Label.GetText(this20.Label))
						local pl, pt, pr, pb = this20:GetDockPadding()
						this20:SetWide(pl + text_w + pr)
					end

					timer.Simple(FrameTime() * 10, function()
						if not IsValid(self) then return end
						if not IsValid(this20.ActivePanel) then return end
						this20:SizeToChildren(false, true)
						local w12, h12 = this20:GetSize()
						this20:Stop()
						this20:AlphaTo(255, 0.25)
						this20.TooltipOffset = this20.ActivePanel.TooltipOffset

						this20.BakedPoly = {
							{
								x = w12 * this20.TooltipOffset - this20.ArrowHeight / 2,
								y = h12 - this20.ArrowHeight - 1
							},
							{
								x = w12 * this20.TooltipOffset + this20.ArrowHeight / 2,
								y = h12 - this20.ArrowHeight - 1
							},
							{
								x = w12 * this20.TooltipOffset,
								y = h12
							},
						}

						this20.PrevActivePanel = this20.ActivePanel
					end)
				else
					if not this20.ActivePanel.IsHovered(this20.ActivePanel) then
						this20.ActivePanel = nil
					else
						local x13 = 0
						local y13 = 0
						local w13 = 0
						local h13 = 0

						if this20.ActivePanel.TooltipPosFunc then
							x13, y13 = this20.ActivePanel.TooltipPosFunc(this20.ActivePanel)
						else
							x13, y13 = this20.ActivePanel.LocalToScreen(this20.ActivePanel, 0, 0)
						end

						w13, h13 = this20:GetSize()

						if this20.TooltipOffset == TOOLTIP_OFFSET_CENTER then
							this20.Label.SetContentAlignment(this20.Label, 5)

							if not this20.ActivePanel.TooltipPosFunc then
								this20:SetPos(x13 - w13 * 0.5 + this20.ActivePanel.GetWide(this20.ActivePanel) * 0.5, y13 - h13 - self.frameH * 0.0015)
							else
								this20:SetPos(x13 - w13 * 0.5, y13 - h13 - self.frameH * 0.0015)
							end
						else
							this20.Label.SetContentAlignment(this20.Label, 4)
							this20:SetPos(x13, y13 - h13 - self.frameH * 0.0015)
						end
					end
				end
			else
				if this20.IsActive then
					this20.IsActive = false
					this20:Stop()

					this20:AlphaTo(0, 0.05, 0, function()
						if IsValid(this20) then
							this20.PrevActivePanel = nil
						end
					end)
				end
			end
		end
	end

	if IsValid(panel) then
		panel.TooltipText = textfunc
		panel.TooltipOffset = offset or TOOLTIP_OFFSET_CENTER
		panel.TooltipWidth = parentwidth or false

		panel.TooltipPosition = {
			x = 0,
			y = 0
		}

		panel.TooltipPosFunc = posfunc or nil
		panel._OnCursorEntered = self.OnCursorEntered
		panel._OnCursorExited = self.OnCursorExited

		panel.OnCursorEntered = function(this21)
			if this21._OnCursorEntered then
				this21._OnCursorEntered()
			end

			if IsValid(self.Tooltip) then
				self.Tooltip.ActivePanel = this21
			end
		end

		panel.OnCursorExited = function(this22)
			if this22._OnCursorExited then
				this22._OnCursorExited()
			end

			if IsValid(self.Tooltip) then
				self.Tooltip.ActivePanel = nil
			end
		end
	end
end

function PANEL:RebuildFonts(frameW, frameH)
	surface_CreateFont("rpui.Fonts.EscMenu.Hint1", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.025,
	})

	surface_CreateFont("rpui.Fonts.EscMenu.Hint2", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.02,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.PlayerName", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.0375,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.PlayerTime", {
		font = "Montserrat",
		extended = true,
		weight = 500,
		size = frameH * 0.0375,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.MenuButton", {
		font = "Montserrat",
		extended = true,
		weight = 500,
		size = frameW * 0.0175,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.MenuButtonBold", {
		font = "Montserrat",
		extended = true,
		weight = 700,
		size = frameW * 0.0175,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.TabButton", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.03,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.Tooltip", {
		font = "Montserrat",
		extended = true,
		weight = 500,
		size = frameH * 0.0175,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.Tooltip_2", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.02,
	})

	surface_CreateFont("rpui.Fonts.ESCMenu.Tooltip_3", {
		font = "Montserrat",
		extended = true,
		weight = 600,
		size = frameH * 0.0225,
	})
end

function PANEL:HideMenu()
	self:SetVisible(true)
	self.ESCListen = false
	self:KillFocus()
	self:Stop()

	self:AlphaTo(0, 0.25, 0, function()
		self:SetVisible(false)
		self.ESCListen = true
	end)
end

function PANEL:ShowMenu()
	self:SetVisible(true)
	self.ESCListen = false
	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	self:Stop()

	self:AlphaTo(255, 0.25, 0, function()
		self.ESCListen = true
	end)

	if IsValid(self) then
		self:RebuildLeftBtns()
	end
end

function PANEL:RebuildServers()
	self.ServersList.AlphaTo(self.ServersList, 0, 0.25, 0, function()
		if not IsValid(self) then return end

		for k1, v1 in pairs(self.ServersList.GetChildren(self.ServersList)) do
			v1:Remove()
		end

		self.ServersList.SetTall(self.ServersList, 0)
		local ESCServerData = table.Copy(rpui.ESCServerData or {})
		local DisplayedServers = {}

		for addr, serverinfo1 in pairs(ESCServerData) do
			if (rp.cfg.IsFrance or serverinfo1.players > 0) and serverinfo1.players <= 100 then
				DisplayedServers[addr] = serverinfo1
			end
		end

		if table.Count(DisplayedServers) > 6 then
			while (table.Count(DisplayedServers) > 6) do
				local v22, k22 = table.Random(DisplayedServers)
				DisplayedServers[k22] = nil
			end
		end

		for serveraddress, serverinfo in pairs(DisplayedServers) do
			local ServerPanel = vgui.Create("rpui.ServerPanel", self.ServersList)
			ServerPanel.Dock(ServerPanel, TOP)
			ServerPanel.DockMargin(ServerPanel, 0, 0, 0, self.framePadding * 0.25)
			ServerPanel.InvalidateParent(ServerPanel, true)
			ServerPanel.SetTall(ServerPanel, self.ServersList.GetWide(self.ServersList) * 0.25)
			ServerPanel.SetServerInfo(ServerPanel, serveraddress, serverinfo)
			ServerPanel.SetAlpha(ServerPanel, 0)
		end

		self.ServersList.InvalidateLayout(self.ServersList, true)
		self.ServersList.SizeToChildren(self.ServersList, false, true)

		timer.Simple(FrameTime() * 5, function()
			if not IsValid(self.ServersList) then return end
			self.RightContainer.FrameContainer.Frames.Servers.Scroll.SetOffset(self.RightContainer.FrameContainer.Frames.Servers.Scroll, 0)
			self.RightContainer.FrameContainer.Frames.Servers.Scroll.PerformLayout(self.RightContainer.FrameContainer.Frames.Servers.Scroll)
			self.RightContainer.FrameContainer.Frames.Servers.Scroll.VBar.PerformLayout(self.RightContainer.FrameContainer.Frames.Servers.Scroll.VBar)

			for k2, v2 in pairs(self.ServersList.GetChildren(self.ServersList)) do
				v2:RebuildLayout()
				v2:AlphaTo(255, 0.25)
			end

			self.ServersList.AlphaTo(self.ServersList, 255, 0.25)
		end)
	end)
end

function PANEL:RebuildLeftBtns()
	local h17 = self.Menu.GetTall(self.Menu)

	for k3, option in ipairs(self.MenuButtons) do
		if option.CustomCheck then
			if option.CustomCheck(option) == false then
				if IsValid(self.Menu.Buttons[k3]) then
					self.Menu.Buttons[k3].Remove(self.Menu.Buttons[k3])
				end

				continue
			end
		end

		if IsValid(self.Menu.Buttons[k3]) then continue end

		if option.Type == self.MENUBUTTON_BUTTON or option.Type == self.MENUBUTTON_BUTTONCONFIRM then
			if IsValid(self.Menu.Buttons[k3]) then continue end
			self.Menu.Buttons[k3] = vgui.Create("DButton", self.Menu)
			if option.OnInit then option.OnInit(self.Menu.Buttons[k3]) end
			self.Menu.Buttons[k3].ParentBase = self
			self.Menu.Buttons[k3].Dock(self.Menu.Buttons[k3], BOTTOM)
			self.Menu.Buttons[k3].SetZPos(self.Menu.Buttons[k3], -k3)
			self.Menu.Buttons[k3].SetFont(self.Menu.Buttons[k3], "rpui.Fonts.ESCMenu.MenuButton")
			self.Menu.Buttons[k3].SetText(self.Menu.Buttons[k3], option.Name or "")

			if option.TallMult then
				self.Menu.Buttons[k3].TallMult = option.TallMult
			end

			if option.Paint then
				self.Menu.Buttons[k3].Paint = option.Paint
			else
				self.Menu.Buttons[k3].Paint = function(this23, w18, h18)
					local baseColor, textColor = rpui.GetPaintStyle(this23, STYLE_TRANSPARENT_INVERTED)
					surface_SetDrawColor(baseColor)
					surface_DrawRect(0, 0, w18, h18)
					draw_SimpleText(this23:GetText(), this23:GetFont(), w18 * 0.5, h18 * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					return true
				end
			end

			if option.PaintOver then
				self.Menu.Buttons[k3].PaintOver = option.PaintOver
			end

			if option.Type == self.MENUBUTTON_BUTTONCONFIRM then
				self.Menu.Buttons[k3].DoClick = function(this24)
					if not this24.Timeout then
						for _, v3 in pairs(self.Menu.Buttons) do
							if v3.Timeout then
								v3.Timeout = 0
							end
						end

						this24.Timeout = SysTime() + 3
						this24:SetText(translates.Get("ПОДТВЕРДИТЕ"))
					else
						this24:SetText(option.Name)
						this24.Timeout = nil
						option.DoClick(this24)
					end
				end

				self.Menu.Buttons[k3].Think = function(this24)
					if this24.Timeout and (this24.Timeout < SysTime()) then
						this24:SetText(option.Name)
						this24.Timeout = nil
					end
				end
			else
				self.Menu.Buttons[k3].DoClick = option.DoClick
			end
		elseif option.Type == self.MENUBUTTON_SPACER then
			if IsValid(self.Spacers_[k3]) then continue end
			self.Spacers_[k3] = vgui.Create("Panel", self.Menu)
			self.Spacers_[k3].Dock(self.Spacers_[k3], BOTTOM)
			self.Spacers_[k3].SetZPos(self.Spacers_[k3], -k3)
			self.Spacers_[k3].SetTall(self.Spacers_[k3], self.frameH * 0.025)
			h17 = h17 - self.Spacers_[k3].GetTall(self.Spacers_[k3])
		end
	end

	local buttonSize = h17 / table.Count(self.Menu.Buttons)

	for k4, menubtn in pairs(self.Menu.Buttons) do
		if IsValid(menubtn) then
			menubtn:SetTall(buttonSize * (menubtn.TallMult and menubtn.TallMult() or 1))
		end
	end
end

function PANEL:Init()
	if not rp.cfg.DisableEscServersInfo then
		if not rpui.ESCServerData then
			http.Fetch((rp.cfg.CustomESCHandler or "http://api.urf.im/handler/menu/escape_server_info.php") .. "?steamid=" .. LocalPlayer():SteamID64(), function(json)
				rpui.ESCServerData = util.JSONToTable(json)
				
				if IsValid( rpui.ESCMenu ) then
					rpui.ESCMenu.RebuildServers(rpui.ESCMenu)
				end
			end)
		end

		if timer.Exists("rpui.ESCMenu.ParseServerList") then
			timer.Remove("rpui.ESCMenu.ParseServerList")
		end

		timer.Create("rpui.ESCMenu.ParseServerList", 300, 0, function()
			http.Fetch((rp.cfg.CustomESCHandler or "http://api.urf.im/handler/menu/escape_server_info.php") .. "?steamid=" .. LocalPlayer():SteamID64(), function(json)
				rpui.ESCServerData = util.JSONToTable(json) or rpui.ESCServerData
				
				if IsValid( rpui.ESCMenu ) then
					rpui.ESCMenu.RebuildServers(rpui.ESCMenu)
				end
			end)
		end)
	end

	self.Spacers_ = {}
	self.ESCListen = true

	self:SetSize(ScrW(), ScrH())
	self:Center()
	self:SetAlpha(0)
	self:SetVisible(false)

	self.frameW, self.frameH = self:GetSize()
	self.framePadding = 0.05 * self.frameH
	self:RebuildFonts(self.frameW, self.frameH)

	self.Foreground = vgui.Create("Panel", self)
	self.Foreground.SetSize(self.Foreground, self:GetWide() - self.framePadding * 2, self:GetTall() - self.framePadding * 2)
	self.Foreground.Center(self.Foreground)

	self.LeftContainer = vgui.Create("Panel", self.Foreground)
	self.LeftContainer.Dock(self.LeftContainer, LEFT)
	self.LeftContainer.SetWide(self.LeftContainer, self:GetWide() * 0.5)
	self.LeftContainer.InvalidateParent(self.LeftContainer, true)

	self.PlayerData = vgui.Create("Panel", self.LeftContainer)
	self.PlayerData.Dock(self.PlayerData, TOP)
	self.PlayerData.InvalidateParent(self.PlayerData, true)

	self.PlayerData.Avatar = vgui.Create("AvatarImage", self.PlayerData)
	self.PlayerData.Avatar.SetSize(self.PlayerData.Avatar, self.frameH * 0.085, self.frameH * 0.085)
	self.PlayerData.Avatar.SetPlayer(self.PlayerData.Avatar, LocalPlayer(), self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar))
	self.PlayerData.SizeToChildren(self.PlayerData, false, true)

	self.PlayerData.Name = vgui.Create("DLabel", self.PlayerData)
	self.PlayerData.Name.SetFont(self.PlayerData.Name, "rpui.Fonts.ESCMenu.PlayerName")
	self.PlayerData.Name.SetTextColor(self.PlayerData.Name, rpui.UIColors.White)
	self.PlayerData.Name.SetText(self.PlayerData.Name, string.utf8upper(LocalPlayer():Name()))
	self.PlayerData.Name.SetTall(self.PlayerData.Name, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5)
	self.PlayerData.Name.SetPos(self.PlayerData.Name, self.PlayerData.Avatar.GetWide(self.PlayerData.Avatar) + self.framePadding * 0.5, 0)
	self.PlayerData.Name.SizeToContentsX(self.PlayerData.Name)

	self.PlayerData.UsergroupIcon = vgui.Create("DImage", self.PlayerData)
	self.PlayerData.UsergroupIcon.SetSize(self.PlayerData.UsergroupIcon, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5)
	self.PlayerData.UsergroupIcon.SetPos(self.PlayerData.UsergroupIcon, self.PlayerData.Avatar.GetWide(self.PlayerData.Avatar) + self.framePadding * 0.5 + self.PlayerData.Name.GetWide(self.PlayerData.Name) + self.framePadding * 0.1, 0)
	local rankt = LocalPlayer():GetRankTable()
	self.PlayerData.UsergroupIcon.SetImage(self.PlayerData.UsergroupIcon, "rpui/escmenu/usericons/" .. rankt:GetID())
	self.PlayerData.UsergroupIcon.SetMouseInputEnabled(self.PlayerData.UsergroupIcon, true)
	self:RegisterTooltip(self.PlayerData.UsergroupIcon, rankt:GetNiceName(), TOOLTIP_OFFSET_CENTER)

	self.PlayerData.TimeIcon = vgui.Create("DImage", self.PlayerData)
	self.PlayerData.TimeIcon.SetSize(self.PlayerData.TimeIcon, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5)
	self.PlayerData.TimeIcon.SetPos(self.PlayerData.TimeIcon, self.PlayerData.Avatar.GetWide(self.PlayerData.Avatar) + self.framePadding * 0.5, self.PlayerData.GetTall(self.PlayerData) - self.PlayerData.TimeIcon.GetTall(self.PlayerData.TimeIcon))
	self.PlayerData.TimeIcon.SetImage(self.PlayerData.TimeIcon, "rpui/escmenu/icons/clock")
	self.PlayerData.TimeIcon.SetMouseInputEnabled(self.PlayerData.TimeIcon, true)
	self:RegisterTooltip(self.PlayerData.TimeIcon, translates.Get("Наигранное время"), TOOLTIP_OFFSET_CENTER)

	self.PlayerData.Time = vgui.Create("DLabel", self.PlayerData)
	self.PlayerData.Time.SetFont(self.PlayerData.Time, "rpui.Fonts.ESCMenu.PlayerTime")
	self.PlayerData.Time.SetTextColor(self.PlayerData.Time, rpui.UIColors.White)
	self.PlayerData.Time.SetTall(self.PlayerData.Time, self.PlayerData.Avatar.GetTall(self.PlayerData.Avatar) * 0.5)
	self.PlayerData.Time.SetPos(self.PlayerData.Time, self.PlayerData.Avatar.GetWide(self.PlayerData.Avatar) + self.framePadding * 0.75 + self.PlayerData.TimeIcon.GetWide(self.PlayerData.TimeIcon), self.PlayerData.Time.GetTall(self.PlayerData.Time))

	self.PlayerData.Think = function()
		self.PlayerData.Time.SetText(self.PlayerData.Time, ba.str.FormatTime(LocalPlayer():GetPlayTime()))
		self.PlayerData.Time.SizeToContentsX(self.PlayerData.Time)
	end

	self.Menu = vgui.Create("Panel", self.LeftContainer)
	self.Menu.Dock(self.Menu, LEFT)
	self.Menu.DockMargin(self.Menu, 0, self.framePadding * 2, 0, 0)
	self.Menu.SetWide(self.Menu, self.LeftContainer.GetWide(self.LeftContainer) * 0.425)
	self.Menu.InvalidateParent(self.Menu, true)
	self.Menu.Buttons = {}
	self:RebuildLeftBtns()
	--if rp.cfg.DisableEscServersInfo then return end

	self.RightContainer = vgui.Create("Panel", self.Foreground)
	self.RightContainer.Dock(self.RightContainer, RIGHT)
	self.RightContainer.SetWide(self.RightContainer, self.frameW * 0.5 - self.framePadding * 2)
	self.RightContainer.InvalidateParent(self.RightContainer, true)
	self.RightContainer.SetPos(self.RightContainer, self.RightContainer.GetWide(self.RightContainer), 0)

	self.RightContainer.TabContainer = vgui.Create("Panel", self.RightContainer)
	self.RightContainer.TabContainer.Dock(self.RightContainer.TabContainer, TOP)
	self.RightContainer.TabContainer.DockMargin(self.RightContainer.TabContainer, 0, 0, 0, self.framePadding * 0.5)
	self.RightContainer.TabContainer.InvalidateParent(self.RightContainer.TabContainer, true)
	self.RightContainer.TabContainer.Tabs = {}

	if not rp.cfg.DisableEscServersInfo then
		self.RightContainer.TabContainer.Tabs.Servers = vgui.Create("DButton", self.RightContainer.TabContainer)
		self.RightContainer.TabContainer.Tabs.Servers.InvalidateLayout(self.RightContainer.TabContainer.Tabs.Servers, true)
		self.RightContainer.TabContainer.Tabs.Servers.SetFont(self.RightContainer.TabContainer.Tabs.Servers, "rpui.Fonts.ESCMenu.TabButton")
		self.RightContainer.TabContainer.Tabs.Servers.SetText(self.RightContainer.TabContainer.Tabs.Servers, translates.Get("СЕРВЕРА"))
		self.RightContainer.TabContainer.Tabs.Servers.SizeToContentsY(self.RightContainer.TabContainer.Tabs.Servers, self.framePadding * 0.25)
		self.RightContainer.TabContainer.Tabs.Servers.Selected = true

		self.RightContainer.TabContainer.Tabs.Servers.Paint = function(this25, w19, h19)
			local baseColor19, textColor19 = rpui.GetPaintStyle(this25, STYLE_TRANSPARENT_SELECTABLE)
			surface_SetDrawColor(baseColor19)
			surface_DrawRect(0, 0, w19, h19)
			draw_SimpleText(this25:GetText(), this25:GetFont(), w19 * 0.5, h19 * 0.5, textColor19, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end

		self.RightContainer.TabContainer.Tabs.Servers.DoClick = function(this26)
			if this26.Selected then return end
			this26.Selected = true
			self.RightContainer.TabContainer.Tabs.Updates.Selected = false
			self.RightContainer.FrameContainer.Frames.Updates.Stop(self.RightContainer.FrameContainer.Frames.Updates)

			self.RightContainer.FrameContainer.Frames.Updates.AlphaTo(self.RightContainer.FrameContainer.Frames.Updates, 0, 0.25, 0, function()
				self.RightContainer.FrameContainer.Frames.Updates.SetVisible(self.RightContainer.FrameContainer.Frames.Updates, false)
				self.RightContainer.FrameContainer.Frames.Servers.SetVisible(self.RightContainer.FrameContainer.Frames.Servers, true)
				self.RightContainer.FrameContainer.Frames.Servers.AlphaTo(self.RightContainer.FrameContainer.Frames.Servers, 255, 0.25)
			end)
		end
	end

	self.RightContainer.TabContainer.Tabs.Updates = vgui.Create("DButton", self.RightContainer.TabContainer)
	self.RightContainer.TabContainer.Tabs.Updates.InvalidateLayout(self.RightContainer.TabContainer.Tabs.Updates, true)
	self.RightContainer.TabContainer.Tabs.Updates.SetFont(self.RightContainer.TabContainer.Tabs.Updates, "rpui.Fonts.ESCMenu.TabButton")
	self.RightContainer.TabContainer.Tabs.Updates.SetText(self.RightContainer.TabContainer.Tabs.Updates, translates.Get("ОБНОВЛЕНИЯ"))
	self.RightContainer.TabContainer.Tabs.Updates.SizeToContentsX(self.RightContainer.TabContainer.Tabs.Updates, self.framePadding)
	self.RightContainer.TabContainer.Tabs.Updates.SizeToContentsY(self.RightContainer.TabContainer.Tabs.Updates, self.framePadding * 0.25)

	if rp.cfg.DisableEscServersInfo then
		self.RightContainer.TabContainer.Tabs.Updates.Selected = true
	end

	surface_CreateFont("__rpuiUpdateNotifyFont", {
		font = "Montserrat",
		extended = true,
		weight = 800,
		size = self.RightContainer.TabContainer.Tabs.Updates.GetTall(self.RightContainer.TabContainer.Tabs.Updates) * 0.5,
	})

	self.RightContainer.TabContainer.Tabs.Updates.Paint = function(this27, w20, h20)
		local baseColor20, textColor20 = rpui.GetPaintStyle(this27, STYLE_TRANSPARENT_SELECTABLE)
		surface_SetDrawColor(baseColor20)
		surface_DrawRect(0, 0, w20, h20)
		local tW, tH = draw_SimpleText(this27:GetText(), this27:GetFont(), w20 * 0.5, h20 * 0.5, textColor20, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if IsValid(self.UpdatesList) then
			local uc = self.UpdatesList.UpdateCount
			if not uc then return end
			local size = rpui.PowOfTwo(tH * 0.5)
			local r = 0.5 * size

			if uc ~= cookie.GetNumber("rpui-updatenotify" .. util.CRC(game.GetIPAddress()), -1) then
				draw_RoundedBox(r, w20 * 0.5 + tW * 0.5 - r, h20 * 0.5 - tH * 0.5, size, size, Color(225 + math_sin(CurTime()) * 30, 0, 0))
				draw_SimpleText("!", "__rpuiUpdateNotifyFont", w20 * 0.5 + tW * 0.5, h20 * 0.5 - tH * 0.5 + r, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		return true
	end

	self.RightContainer.TabContainer.Tabs.Updates.DoClick = function(this28)
		if this28.Selected then return end
		this28.Selected = true
		self.RightContainer.TabContainer.Tabs.Servers.Selected = false
		cookie.Set("rpui-updatenotify" .. util.CRC(game.GetIPAddress()), self.UpdatesList.UpdateCount)
		self.RightContainer.FrameContainer.Frames.Servers.Stop(self.RightContainer.FrameContainer.Frames.Servers)

		self.RightContainer.FrameContainer.Frames.Servers.AlphaTo(self.RightContainer.FrameContainer.Frames.Servers, 0, 0.25, 0, function()
			self.RightContainer.FrameContainer.Frames.Servers.SetVisible(self.RightContainer.FrameContainer.Frames.Servers, false)
			self.RightContainer.FrameContainer.Frames.Updates.SetVisible(self.RightContainer.FrameContainer.Frames.Updates, true)
			self.RightContainer.FrameContainer.Frames.Updates.AlphaTo(self.RightContainer.FrameContainer.Frames.Updates, 255, 0.25)
		end)
	end

	if not IsValid(self.RightContainer.TabContainer.Tabs.Updates) and IsValid(self.RightContainer.TabContainer.Tabs.Servers) then
		self.RightContainer.TabContainer.Tabs.Servers.SizeToContentsX(self.RightContainer.TabContainer.Tabs.Servers, self.framePadding)
	end

	self.RightContainer.TabContainer.InvalidateLayout(self.RightContainer.TabContainer, true)
	self.RightContainer.TabContainer.SizeToChildren(self.RightContainer.TabContainer, false, true)

	if IsValid(self.RightContainer.TabContainer.Tabs.Servers) then
		self.RightContainer.TabContainer.Tabs.Servers.Dock(self.RightContainer.TabContainer.Tabs.Servers, LEFT)
		self.RightContainer.TabContainer.Tabs.Servers.SetWide(self.RightContainer.TabContainer.Tabs.Servers, self.RightContainer.TabContainer.Tabs.Updates.GetWide(self.RightContainer.TabContainer.Tabs.Updates))
	end

	self.RightContainer.TabContainer.Tabs.Updates.Dock(self.RightContainer.TabContainer.Tabs.Updates, RIGHT)

	if not rp.cfg.IsFrance then
		self.RightContainer.Advert = vgui.Create("DButton", self.RightContainer)
		self.RightContainer.Advert.Dock(self.RightContainer.Advert, BOTTOM)
		self.RightContainer.Advert.DockMargin(self.RightContainer.Advert, 0, self.framePadding * 0.25, 0, 0)
		self.RightContainer.Advert.InvalidateParent(self.RightContainer.Advert, true)
		self.RightContainer.Advert.SetTall(self.RightContainer.Advert, self.RightContainer.Advert.GetWide(self.RightContainer.Advert) * 0.25)
		self.RightContainer.Advert.SwitchDelay = 10
		self.RightContainer.Advert.SwitchLength = 1 / 2
		self.RightContainer.Advert.URL = ""

		self.RightContainer.Advert.DoClick = function(this29)
			gui.OpenURL(this29.URL)
		end

		self.RightContainer.Advert.Think = function(this30)
			if not rpui.ESCBanners then return end

			if this30.ID then
				if not this30.SwitchTimeout then
					local data = rpui.ESCBanners[this30.ID]
					this30.URL = data.href or ""
					this30.SwitchTimeout = SysTime() + this30.SwitchDelay
				elseif this30.SwitchTimeout < SysTime() then
					this30.ID = (this30.ID % #rpui.ESCBanners) + 1
					this30.SwitchTimeout = nil
				end
			end
		end

		self.RightContainer.Advert.Paint = function(this30_p, w21, h21)
			surface_SetDrawColor(rpui.UIColors.Background)
			surface_DrawRect(0, 0, w21, h21)
			
			if not rpui.ESCBanners then
				return true
			end

			local data = rpui.ESCBanners[this30_p.ID]

			surface_SetDrawColor(rpui.UIColors.White)

			if (not this30_p.URLMaterial) or this30_p.URLMaterial:IsError() then
				this30_p.URLMaterial = rp.WebMat.Get(rp.WebMat, data.image, true)

				surface_SetMaterial(rp.WebMat.LoadingMat)
				local updcard_icon = h21 * 0.5; 
				surface_DrawTexturedRect(w21 * 0.5 - updcard_icon * 0.5, h21 * 0.5 - updcard_icon * 0.5, updcard_icon, updcard_icon)

				return true
			end

			surface_SetMaterial(this30_p.URLMaterial)
			surface_DrawTexturedRect(0, 0, w21, h21)

			return true
		end

		-- self.RightContainer.Advert.HTML = vgui.Create("DHTML", self.RightContainer.Advert)
		-- self.RightContainer.Advert.HTML.Dock(self.RightContainer.Advert.HTML, FILL)
		-- self.RightContainer.Advert.HTML.SetMouseInputEnabled(self.RightContainer.Advert.HTML, false)

		if not rpui.ESCBanners then
			http.Fetch("http://api.urf.im/handler/menu/escape_banners.php", function(body)
				local banners = util.JSONToTable(body)

				if not banners then
					self.RightContainer.Advert.SetTall(self.RightContainer.Advert, 0)
					self.RightContainer.Advert.DockMargin(self.RightContainer.Advert, 0, 0, 0, 0)
				else
					rpui.ESCBanners = banners
					self.RightContainer.Advert.ID = 1
				end
			end)
		else
			self.RightContainer.Advert.ID = 1
		end
	end

	self.RightContainer.FrameContainer = vgui.Create("Panel", self.RightContainer)
	self.RightContainer.FrameContainer.Dock(self.RightContainer.FrameContainer, FILL)
	self.RightContainer.FrameContainer.InvalidateParent(self.RightContainer.FrameContainer, true)
	self.RightContainer.FrameContainer.Frames = {}

	self.RightContainer.FrameContainer.Frames.Servers = vgui.Create("Panel", self.RightContainer.FrameContainer)
	self.RightContainer.FrameContainer.Frames.Servers.SetSize(self.RightContainer.FrameContainer.Frames.Servers, self.RightContainer.FrameContainer.GetSize(self.RightContainer.FrameContainer))
	self.RightContainer.FrameContainer.Frames.Servers.Scroll = vgui.Create("rpui.ScrollPanel", self.RightContainer.FrameContainer.Frames.Servers)
	self.RightContainer.FrameContainer.Frames.Servers.Scroll.Dock(self.RightContainer.FrameContainer.Frames.Servers.Scroll, FILL)
	self.RightContainer.FrameContainer.Frames.Servers.Scroll.SetScrollbarMargin(self.RightContainer.FrameContainer.Frames.Servers.Scroll, self.framePadding * 0.23)
	self.RightContainer.FrameContainer.Frames.Servers.Scroll.InvalidateParent(self.RightContainer.FrameContainer.Frames.Servers.Scroll, true)
	self.RightContainer.FrameContainer.Frames.Servers.Scroll.PerformLayout(self.RightContainer.FrameContainer.Frames.Servers.Scroll)

	self.ServersList = vgui.Create("Panel")
	self.RightContainer.FrameContainer.Frames.Servers.Scroll.AddItem(self.RightContainer.FrameContainer.Frames.Servers.Scroll, self.ServersList)
	self.ServersList.Dock(self.ServersList, TOP)
	self.ServersList.SetTall(self.ServersList, self.frameH)
	self.ServersList.InvalidateParent(self.ServersList, true)

	self.RightContainer.FrameContainer.Frames.Updates = vgui.Create("Panel", self.RightContainer.FrameContainer)
	self.RightContainer.FrameContainer.Frames.Updates.SetSize(self.RightContainer.FrameContainer.Frames.Updates, self.RightContainer.FrameContainer.GetSize(self.RightContainer.FrameContainer))
	self.RightContainer.FrameContainer.Frames.Updates.SetAlpha(self.RightContainer.FrameContainer.Frames.Updates, 0)
	self.RightContainer.FrameContainer.Frames.Updates.SetVisible(self.RightContainer.FrameContainer.Frames.Updates, false)

	self.RightContainer.FrameContainer.Frames.Updates.Scroll = vgui.Create("rpui.ScrollPanel", self.RightContainer.FrameContainer.Frames.Updates)
	self.RightContainer.FrameContainer.Frames.Updates.Scroll.Dock(self.RightContainer.FrameContainer.Frames.Updates.Scroll, FILL)
	self.RightContainer.FrameContainer.Frames.Updates.Scroll.SetScrollbarMargin(self.RightContainer.FrameContainer.Frames.Updates.Scroll, self.framePadding * 0.23)
	self.RightContainer.FrameContainer.Frames.Updates.Scroll.InvalidateParent(self.RightContainer.FrameContainer.Frames.Updates.Scroll, true)
	self.RightContainer.FrameContainer.Frames.Updates.Scroll.PerformLayout(self.RightContainer.FrameContainer.Frames.Updates.Scroll)

	if rp.cfg.DisableEscServersInfo then
		self.RightContainer.FrameContainer.Frames.Servers.SetAlpha(self.RightContainer.FrameContainer.Frames.Servers, 0)
		self.RightContainer.FrameContainer.Frames.Servers.SetVisible(self.RightContainer.FrameContainer.Frames.Servers, false)
		self.RightContainer.FrameContainer.Frames.Updates.SetAlpha(self.RightContainer.FrameContainer.Frames.Updates, 255)
		self.RightContainer.FrameContainer.Frames.Updates.SetVisible(self.RightContainer.FrameContainer.Frames.Updates, true)
	end

	self.UpdatesList = vgui.Create("Panel")
	self.UpdatesList.Dock(self.UpdatesList, TOP)
	self.RightContainer.FrameContainer.Frames.Updates.Scroll.AddItem(self.RightContainer.FrameContainer.Frames.Updates.Scroll, self.UpdatesList)
	self.UpdatesList.InvalidateParent(self.UpdatesList, true)
	local articlePattern = "<a href=\"/(@.-)%?.-article__title\">(.-)</span>.-article__description\">(.-)</p>.-article__info\">(.-)</span>.-url%((.-)%)"
	local content3

	for k, v in pairs(rp.cfg.MoTD or {}) do
		if v[1] == translates.Get('Группа ВК') then
			content3 = v[2]
			break
		end
	end

	rp.cfg.VKGroup = (content3 ~= rp.cfg.VKGroup and rp.cfg.VKGroup) or content3

	http.Fetch(string.Replace(rp.cfg.VKGroup, "vk.com/", "vk.com/@"), function(body)
		local articles = {}

		for href, title, desc, stats, image in string.gmatch(body, articlePattern) do
			local article = {}
			article.href = "https://vk.com/" .. href
			article.title = title
			article.desc = desc
			article.stats = {}
			stats = string.Explode(" · ", stats)
			article.stats.date = stats[1] or translates.Get("1 янв 1970")
			article.stats.viewercount = stats[2] or translates.Get("0 просмотров")
			article.image = image
			table.insert(articles, article)
		end

		for k5, article in ipairs(articles) do
			local UpdatePanel = vgui.Create("Panel", self.UpdatesList)
			UpdatePanel:Dock(TOP)
			UpdatePanel:DockMargin(0, 0, 0, self.framePadding * 0.25)
			UpdatePanel:DockPadding(self.framePadding * 0.25, self.framePadding * 0.25, self.framePadding * 0.25, self.framePadding * 0.25)
			UpdatePanel:SetTall(self.UpdatesList.GetWide(self.UpdatesList) * 0.3)
			UpdatePanel:InvalidateParent(true)

			UpdatePanel.Paint = function(______, w22, h22)
				surface_SetDrawColor(rpui.UIColors.Background)
				surface_DrawRect(0, 0, w22, h22)
			end

			local frameW23, frameH23 = UpdatePanel:GetSize()

			surface_CreateFont("rpui.Fonts.UpdatePanel.Title", {
				font = "Montserrat",
				extended = true,
				weight = 700,
				size = frameH23 * 0.125,
			})

			surface_CreateFont("rpui.Fonts.UpdatePanel.Description", {
				font = "Montserrat",
				extended = true,
				weight = 500,
				size = frameH23 * 0.085,
			})

			surface_CreateFont("rpui.Fonts.UpdatePanel.Stats", {
				font = "Montserrat",
				extended = true,
				weight = 500,
				size = frameH23 * 0.065,
			})

			-- UpdatePanel.HTML = vgui.Create("DHTML", UpdatePanel)
			-- UpdatePanel.HTML.Dock(UpdatePanel.HTML, LEFT)
			-- UpdatePanel.HTML.DockMargin(UpdatePanel.HTML, 0, 0, self.framePadding * 0.25, 0)
			-- UpdatePanel.HTML.SetWide(UpdatePanel.HTML, UpdatePanel:GetWide() * 0.45)
			-- UpdatePanel.HTML.SetMouseInputEnabled(UpdatePanel.HTML, false)
			-- UpdatePanel.HTML.SetHTML(UpdatePanel.HTML, '<html><head><style>body { margin: 0; } body::after { content: ""; position: absolute; left: 0; top: 0; right: 0; bottom: 0; background-size: 100% 100%; background-image: url(' .. article.image .. ');box-shadow: inset 0px 0px 16px 0px rgba(0,0,0,0.75);}</style></head></html>')
			-- UpdatePanel.HTML.InvalidateParent(UpdatePanel.HTML, true)

			UpdatePanel.HTML = vgui.Create("Panel", UpdatePanel)
			UpdatePanel.HTML.Dock(UpdatePanel.HTML, LEFT)
			UpdatePanel.HTML.DockMargin(UpdatePanel.HTML, 0, 0, self.framePadding * 0.25, 0)
			UpdatePanel.HTML.SetWide(UpdatePanel.HTML, UpdatePanel:GetWide() * 0.45)
			UpdatePanel.HTML.SetMouseInputEnabled(UpdatePanel.HTML, false)
			UpdatePanel.HTML.InvalidateParent(UpdatePanel.HTML, true)
			UpdatePanel.HTML.URL = article.image
			UpdatePanel.HTML.Paint = function(updcard_html, updcard_w, updcard_h)
				surface_SetDrawColor(rpui.UIColors.Background)
				surface_DrawRect(0, 0, updcard_w, updcard_h)

				surface_SetDrawColor(rpui.UIColors.White)

				if (not updcard_html.URLMaterial) or updcard_html.URLMaterial:IsError() then
					updcard_html.URLMaterial = rp.WebMat.Get(rp.WebMat, updcard_html.URL, true)

					surface_SetMaterial(rp.WebMat.LoadingMat)
					local updcard_icon = updcard_h * 0.5; 
					surface_DrawTexturedRect(updcard_w * 0.5 - updcard_icon * 0.5, updcard_h * 0.5 - updcard_icon * 0.5, updcard_icon, updcard_icon)

					return
				end

				surface_SetMaterial(updcard_html.URLMaterial)
				surface_DrawTexturedRect(0, 0, updcard_w, updcard_h)
			end
			

			UpdatePanel.Stats = vgui.Create("DLabel", UpdatePanel)
			UpdatePanel.Stats.SetFont(UpdatePanel.Stats, "rpui.Fonts.UpdatePanel.Stats")
			UpdatePanel.Stats.SetTextColor(UpdatePanel.Stats, Color(255, 255, 255, 200))
			UpdatePanel.Stats.SetText(UpdatePanel.Stats, article.stats.date .. " · " .. article.stats.viewercount)
			UpdatePanel.Stats.SetPos(UpdatePanel.Stats, UpdatePanel.HTML.x, UpdatePanel.HTML.y)
			UpdatePanel.Stats.SetWide(UpdatePanel.Stats, UpdatePanel.HTML.GetWide(UpdatePanel.HTML))
			UpdatePanel.Stats.SetContentAlignment(UpdatePanel.Stats, 5)
			UpdatePanel.Stats.SizeToContentsY(UpdatePanel.Stats, self.framePadding * 0.1)

			UpdatePanel.Stats.Paint = function(_______, w23, h23)
				surface_SetDrawColor(Color(0, 0, 0, 200))
				surface_DrawRect(0, 0, w23, h23)
			end

			UpdatePanel.Title = vgui.Create("DLabel", UpdatePanel)
			UpdatePanel.Title.SetWrap(UpdatePanel.Title, true)
			UpdatePanel.Title.SetAutoStretchVertical(UpdatePanel.Title, true)
			UpdatePanel.Title.SetFont(UpdatePanel.Title, "rpui.Fonts.UpdatePanel.Title")
			UpdatePanel.Title.SetTextColor(UpdatePanel.Title, rpui.UIColors.White)
			UpdatePanel.Title.SetText(UpdatePanel.Title, article.title)
			UpdatePanel.Title.Dock(UpdatePanel.Title, TOP)
			UpdatePanel.Title.DockMargin(UpdatePanel.Title, 0, 0, 0, self.framePadding * 0.25)

			UpdatePanel.Read = vgui.Create("DButton", UpdatePanel)
			UpdatePanel.Read.Dock(UpdatePanel.Read, BOTTOM)
			UpdatePanel.Read.DockMargin(UpdatePanel.Read, 0, self.framePadding * 0.25, 0, 0)
			UpdatePanel.Read.SetFont(UpdatePanel.Read, "rpui.Fonts.UpdatePanel.Title")
			UpdatePanel.Read.SetText(UpdatePanel.Read, translates.Get("ЧИТАТЬ"))
			UpdatePanel.Read.SizeToContentsY(UpdatePanel.Read, self.framePadding * 0.5)

			UpdatePanel.Read.Paint = function(this31, w24, h24)
				local baseColor, textColor = rpui.GetPaintStyle(this31, STYLE_TRANSPARENT_INVERTED)
				surface_SetDrawColor(baseColor)
				surface_DrawRect(0, 0, w24, h24)
				draw_SimpleText(this31:GetText(), this31:GetFont(), w24 * 0.5, h24 * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				return true
			end

			UpdatePanel.Read.DoClick = function()
				gui.OpenURL(article.href)
			end

			UpdatePanel.Desc = vgui.Create("DLabel", UpdatePanel)
			UpdatePanel.Desc.Dock(UpdatePanel.Desc, FILL)
			UpdatePanel.Desc.SetWrap(UpdatePanel.Desc, true)
			UpdatePanel.Desc.SetFont(UpdatePanel.Desc, "rpui.Fonts.UpdatePanel.Description")
			UpdatePanel.Desc.SetTextColor(UpdatePanel.Desc, Color(255, 255, 255, 200))
			UpdatePanel.Desc.SetText(UpdatePanel.Desc, article.desc)
			UpdatePanel.Desc.SetContentAlignment(UpdatePanel.Desc, 7)
		end

		self.UpdatesList.InvalidateLayout(self.UpdatesList, true)
		self.UpdatesList.SizeToChildren(self.UpdatesList, false, true)
		self.UpdatesList.UpdateCount = #articles
	end)
end

function PANEL:Paint(w25, h25)
	draw_Blur(self)
	surface_SetDrawColor(rpui.UIColors.Shading)
	surface_DrawRect(0, 0, w25, h25)
end

vgui.Register("rpui.ESCMenu", PANEL, "Panel")
