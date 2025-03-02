-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_menus\\slidermenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SimpleText = draw.SimpleText
local mathRound = math.Round
local rp_FormatMoney = rp.FormatMoney

local colors = {
	white = Color(255, 255, 255)
}

local Align = {
	Center = TEXT_ALIGN_CENTER,
	Left = TEXT_ALIGN_LEFT,
	Top = TEXT_ALIGN_TOP,
	Right = TEXT_ALIGN_RIGHT,
	Bottom = TEXT_ALIGN_BOTTOM
}

surface.CreateFont("rpui.slidermenu.font", {
    font = "Montserrat", -- Montserrat
    extended = true,
    antialias = true,
    size = 22 * (ScrH()/1080)
})

local PANEL = {}

function PANEL:Init()
	self.slider = vgui.Create("urf.im/rpui/numslider", self)

	self.input = vgui.Create("urf.im/rpui/txtinput", self)
	self.input.UID = "SliderMenu"
	self.input.ApplyDesign(self.input)

	self.slider_x = 0
	self.input_y = 0
	self.input_h = 0

	self.slider.OnSliderMove = function(this1)
		self:SetInputVal( math.floor(this1:GetPseudoKnobPos()) )
	end

	self.input.OnChange = function(this2)
		if not self.slider then return end
		local num = string.Replace(this2:GetText(), ",", "") or "0"
		this2.RealValue = tonumber( num )
		if not this2.RealValue then return end
		self.slider.SetPseudoKnobPos(self.slider, this2.RealValue)
	end

	self.drop = vgui.Create("urf.im/rpui/button", self)
	local drop = self.drop
	
	local word = translates.Get("Принять")
	drop:SetText(word)
	drop:SetFont("rpui.slidermenu.font")
	drop.DoClick = function(this)
		if this:GetText() == word then
			this:SetText(translates.Get("ПОДТВЕРДИТЕ"))
			return
		else
			this:SetText(word)
		end

		if self.DropCallback then
			self.DropCallback(self.input.RealValue)
		end

		if not self.NotByPlayerMoney then
			self.slider.MaxValue = LocalPlayer():GetMoney() - (self.input.RealValue or 0);
		end
		self:SetInputVal( mathRound(self.slider.GetPseudoKnobPos(self.slider)) )
	end

	self.cancel = vgui.Create("urf.im/rpui/button", self)
	self.cancel.SetText(self.cancel, translates and translates.Get("Отмена") or "Отмена")
	self.cancel.SetFont(self.cancel, "rpui.slidermenu.font")
	self.cancel.DoClick = function()
		self.header.btn.DoClick(self.header.btn)
	end
end

function PANEL:SetValues()
	if not self.NotByPlayerMoney then
		self.slider.MaxValue = LocalPlayer():GetMoney()
	else
		self.slider.ShowMax = true
	end
	self:SetInputVal(self.slider.GetPseudoKnobPos(self.slider))
end

function PANEL:PostPerformLayout()
	local selfW, selfH = self:GetWide(), self:GetTall()

	local sl_w, sl_h = selfW*0.925, 0.18 * selfH
	local in_w, in_h = selfW*0.16923076, 0.16 * selfH

	self.slider.SetSize(self.slider, sl_w, sl_h)
	local sl_x, sl_y = selfW*0.5 - sl_w*0.5, selfH*0.6 - 0.5 * sl_h
	self.slider.SetPos(self.slider, sl_x, sl_y)

	self.slider_x = sl_x
	self.input_y = sl_y - 1.25 * in_h
	self.input_h = in_h

	self.input.SetSize(self.input, in_w, in_h)
	self.input.SetPos(self.input, sl_x + sl_w - in_w, self.input_y)
	self.input.ApplyDesign(self.input)

	local btn_w, btn_h = selfW*0.45, sl_h

	self.drop.SetSize(self.drop, btn_w, btn_h)
	self.cancel.SetSize(self.cancel, btn_w, btn_h)

	local offset = 0.025 * selfW

	self.drop.SetPos(self.drop, offset, selfH - btn_h*1.4)
	self.cancel.SetPos(self.cancel, selfW - btn_w - offset, selfH - btn_h*1.4)
end

local polz_txt = translates and translates.Get("Воспользуйтесь ползунком или введите значение.") or "Воспользуйтесь ползунком или введите значение."
local drop_txt = translates and translates.Get("Сколько выбросить?") or "Сколько выбросить?"
local give_txt = translates and translates.Get("Сколько вы хотите передать?") or "Сколько вы хотите передать?"

function PANEL:PostPaint(w, h)
	SimpleText(self.OverSliderTitle or polz_txt, "rpui.slidermenu.font", self.slider_x, self.input_y + self.input_h*0.5, colors.white, Align.Left, Align.Center)
end

function PANEL:SetInputVal(v)
	self.input.RealValue = v
	self.input.SetValue( self.input, '' .. v )
end

vgui.Register("urf.im/rpui/menus/slidermenu", PANEL, "urf.im/rpui/menus/blank")

rpui.SliderRequest = function(title, icon, iconScale, callback)
	local ScrScale = ScrH()/1080

	local menu = vgui.Create("urf.im/rpui/menus/slidermenu")
	menu:SetSize(650*ScrScale, 250*ScrScale)
	menu:Center()
	menu:MakePopup()

	menu:SetValues()
	
	menu.header.SetIcon(menu.header, icon)
	menu.header.SetTitle(menu.header, title)
	menu.header.SetFont(menu.header, "rpui.playerselect.title")
	menu.header.IcoSizeMult = iconScale

	local knob_val = rp.cfg.StartMoney*0.1
	menu.slider.SetPseudoKnobPos(menu.slider, knob_val)
	menu:SetInputVal(math.Round(knob_val))

	menu.DropCallback = callback

	return menu
end

rpui.SliderRequestFree = function(title, icon, iconScale, max, callback)
	local ScrScale = ScrH()/1080

	local menu = vgui.Create("urf.im/rpui/menus/slidermenu")
	menu:SetSize(650*ScrScale, rpui.AdaptToScreen(0, 301)[2])
	menu:Center()
	menu:MakePopup()
	
	menu.NotByPlayerMoney = true
	menu.slider.MaxValue = max
	
	menu:SetValues()
	
	menu.header.SetIcon(menu.header, icon)
	menu.header.SetTitle(menu.header, title)
	menu.header.SetFont(menu.header, "rpui.playerselect.title")
	menu.header.IcoSizeMult = iconScale

	local knob_val = max * 0.5
	menu.slider.SetPseudoKnobPos(menu.slider, knob_val)
	menu:SetInputVal(math.Round(knob_val))

	menu.DropCallback = callback

	return menu
end

concommand.Add("givemoney_menu", function(ply, cmd, args)
	rpui.SliderRequest(give_txt, "diplomacy/neutic64.png", 1, function(val)
		if not val or val < 0 then return end
		RunConsoleCommand("say", "/give " .. val)
	end)
end)
