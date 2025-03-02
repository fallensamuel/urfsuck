
surface.CreateFont("FPS_Font.Title", {
    font     = "Montserrat",
    extended = true,
    weight   = 540,
    size     = 22,
});

surface.CreateFont("FPS_Font.Text", {
    font     = "Montserrat",
    extended = true,
    weight   = 500,
    size     = 18,
});

local function ShowMessage()
	menu = vgui.Create('urf.im/rpui/menus/blank')
	menu:SetSize(500, 150)
	menu:Center()
	menu:MakePopup()
	
	menu.header.SetIcon(menu.header, 'cmenu/order.png')
	menu.header.SetTitle(menu.header, translates and translates.Get("Кажется, у вас много аддонов") or 'Кажется, у вас много аддонов')
	menu.header.SetFont(menu.header, "FPS_Font.Title")
	menu.header.IcoSizeMult = 1.8
	
	local label = vgui.Create('DLabel', menu)
	label:SetPos(10, 53)
	label:SetText(translates and translates.Get("Советуем отписаться от всех аддонов для повышения FPS!") or 'Советуем отписаться от всех аддонов для повышения FPS!')
	label:SetContentAlignment(5)
	label:SetTextColor(Color(210, 210, 210, 255))
	label:SetSize(480, 40)
	label:SetFont('FPS_Font.Text')
	
	local ok = vgui.Create("urf.im/rpui/button", menu)
	ok.SetSize(ok, 235, 40)
	ok.SetPos(ok, 10, 100)
	ok.SetText(ok, translates and translates.Get("Отписаться") or 'Отписаться')
	ok.SetFont(ok, "FPS_Font.Text") 
	ok.DoClick = function()
		gui.OpenURL('https://steamcommunity.com/profiles/' .. LocalPlayer():SteamID64() .. '/myworkshopfiles/?appid=4000&browsefilter=mysubscriptions');
		menu:Close()
	end

	local cancel = vgui.Create("urf.im/rpui/button", menu)
	cancel.SetSize(cancel, 235, 40)
	cancel.SetPos(cancel, 255, 100)
	cancel.SetText(cancel, translates and translates.Get("Нет, спасибо") or 'Нет, спасибо')
	cancel.SetFont(cancel, "FPS_Font.Text")
	cancel.DoClick = function()
		if menu.Close then menu:Close() else menu:Remove() end
	end
	
	/*
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 90)
		self:SetTitle()
		self:MakePopup()
		self:Center()
		self:RequestFocus()
	end)

	ui.Create('DLabel', function(self, p) 
		self:SetText()
		self:SetFont('ba.ui.24')
		self:SetTextColor(ui.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 32)
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText()
		self:SetPos(5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			
			p:Close()
		end
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText()
		self:SetPos(p:GetWide()/2 + 2.5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			p:Close()
		end
	end, fr)
	*/
end

rp.RegisterLoginPopup(5, ShowMessage, function()
   return #(engine.GetAddons() or {}) >= 50
end)