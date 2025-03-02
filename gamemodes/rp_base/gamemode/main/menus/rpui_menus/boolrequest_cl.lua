local SimpleText = draw.SimpleText

local Align = {
	Center = TEXT_ALIGN_CENTER,
	Left = TEXT_ALIGN_LEFT,
	Top = TEXT_ALIGN_TOP,
	Right = TEXT_ALIGN_RIGHT,
	Bottom = TEXT_ALIGN_BOTTOM
}

local colors = {
	white = Color(255, 255, 255)
}


local PANEL = {}

function PANEL:Init()

	self.ok = vgui.Create("urf.im/rpui/button", self)
	self.ok.SetText(self.ok, translates and translates.Get("Принять") or "Принять")
	self.ok.SetFont(self.ok, "rpui.createorg.font") // rpui.slidermenu.font.button
	self.ok.DoClick = function()
		self:OnAccept()
	end

	self.cancel = vgui.Create("urf.im/rpui/button", self)
	self.cancel.SetText(self.cancel, translates and translates.Get("Отмена") or "Отмена")
	self.cancel.SetFont(self.cancel, "rpui.createorg.font")
	self.cancel.DoClick = function()
		self.header.btn.DoClick(self.header.btn)
	end

	self.Title = "DEFAULT self.Title"
	self.OverInputTitleFont = "rpui.slidermenu.font" --"rpui.slidermenu.font"

	self.mOffset = rpui.AdaptToScreen(23)[1]
	self.dOffset = rpui.AdaptToScreen(0, 18)[2]
	self.pOffset = rpui.AdaptToScreen(0, 13)[2]
end

function PANEL:PostPerformLayout()
	local selfW, selfH = self:GetWide(), self:GetTall()
	local HTall = self.header.GetTall(self.header)
	local RselfH = selfH - HTall

	local there = selfH

	local buttonSize = rpui.AdaptToScreen(217, 43)
	local btn_w, btn_h = buttonSize[1], buttonSize[2] --selfW*0.45 there*0.75

	self.ok.SetSize(self.ok, btn_w, btn_h)
	self.cancel.SetSize(self.cancel, btn_w, btn_h)

	local btnsY = selfH - self.ok:GetTall() - self.dOffset
	self.BtnY = btnsY
	self.ok.SetPos(self.ok, self.mOffset, btnsY)
	self.cancel.SetPos(self.cancel, selfW - self.cancel.GetWide(self.cancel) - self.mOffset, btnsY)

	self.TxtY = selfH*0.5 - (btnsY - selfH*0.5)*0.5
end

function PANEL:OnAccept(str) end -- for rewrite

function PANEL:PaintOver(w, h)
	SimpleText(self.Title, self.OverInputTitleFont, w*0.5, self.TxtY or 0, colors.white, Align.Center, Align.Center)
end

function PANEL:Close()
	self:AlphaTo(0, 0.2, 0, function()
		if IsValid(self) then
			self:Remove()
		end
	end)

	if self.OnClose then
		self:OnClose()
	end
end

vgui.Register("urf.im/rpui/menus/boolrequest", PANEL, "urf.im/rpui/menus/blank")


function rpui.BoolRequest(title, centertitle, icon, iconScale, callback, closeCallback)
	local menu  = vgui.Create("urf.im/rpui/menus/boolrequest")
	menu:SetSize( unpack(rpui.AdaptToScreen(500, 150)) )
	menu:Center()
	menu:MakePopup()

	menu.Title = centertitle
	menu.OnAccept = function(self, str)
		if callback(self, str) == false then return end
		menu.CloseByAccept = true
		self:Close()
	end

	menu.header.SetIcon(menu.header, icon)
	menu.header.SetTitle(menu.header, title)
	menu.header.SetFont(menu.header, "rpui.playerselect.title")
	menu.header.IcoSizeMult = iconScale

	menu.OnClose = function(this)
		if not this.CloseByAccept and closeCallback then
			closeCallback(this)
		end
	end

	return menu
end