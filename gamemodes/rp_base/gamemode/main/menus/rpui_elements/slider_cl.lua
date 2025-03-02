-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_elements\\slider_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local IsVALID, SetDrawColor, DrawRect, SetMaterial, DrawTexturedRect, SimpleText = IsValid, surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, surface.DrawTexturedRect, draw.SimpleText
local input_IsKeyDown = input.IsKeyDown
local RoundedBox = draw.RoundedBox
local math_max = math.max
local SimpleText = draw.SimpleText
local SKIN = SKIN
local inewyork, math_abs, math_ceil = ipairs, math.abs, math.Round
local tonum, str_format = tonumber, string.format
local math_Clamp = math.Clamp

local mouse_snap = {
	[MOUSE_MIDDLE] 	= true,
	[MOUSE_RIGHT] 	= true
}

local near_tab = {0, 0.25, 0.5, 0.75, 1}
local NearestValue = function(num)
    local smallestSoFar, smallestIndex
    for i, y in inewyork(near_tab) do
        if not smallestSoFar or (math_abs(num-y) < smallestSoFar) then
            smallestSoFar = math_abs(num-y)
            smallestIndex = i
        end
    end
    return smallestIndex, near_tab[smallestIndex]
end

local PaintSliderKnob = function(this, w, h)
	local col

	if this.GetDisabled and this:GetDisabled() then
		col = this.Colors.Disabled
	elseif this.Depressed then
		col = this.Colors.Depressed
	elseif this.Hovered then
		col = this.Colors.Hovered
	end

	SetDrawColor(col or this.Colors.Default)
	SetMaterial(this.Circle)
	DrawTexturedRect(w*0.1, h*0.1, w*0.8, h*0.8)
end

local Align = {
	Center = TEXT_ALIGN_CENTER,
	Left = TEXT_ALIGN_LEFT,
	Top = TEXT_ALIGN_TOP,
	Bottom = TEXT_ALIGN_BOTTOM,
	Right = TEXT_ALIGN_RIGHT
}

local PANEL = {}

PANEL.Colors = {
	Line = Color(166, 166, 166),
	White = Color(255, 255, 255)
}

PANEL.MaxValue = 500

function PANEL:GetMaxValue()
	return self.MaxValue
end

function PANEL:SetMaxValue(n)
	self.MaxValue = n
end

function PANEL:Init()
	self.Slider = vgui.Create("DSlider", self)
	local Slider = self.Slider
	
	Slider:SetLockY(0.5)
	Slider:SetTrapInside(false)
	Slider.Knob.Colors = {
		Disabled = Color(255, 255, 255, 150),
		Depressed = Color(255, 255, 255, 200),
		Hovered = Color(255, 255, 255),
		Default = Color(255, 255, 255, 200)
	}
	Slider.Knob.Circle = Material("circle_button/circle.png", "smooth", "noclamp")
	Slider.Knob.Paint = PaintSliderKnob
	Slider.Knob.OnMousePressed = function(this, mcode)
		if mouse_snap[mcode] then
			local smallest, near = NearestValue(Slider:GetSlideX())
			Slider:SetSlideX(near or 0.5)
			if self.OnSliderMove then
				self:OnSliderMove()
			end
			return
		end
		Slider:OnMousePressed(mcode)
	end
end

function PANEL:PerformLayout()
	local Slider = self.Slider
	
	Slider:SetSize(self:GetWide(), self:GetTall()*0.25)
	Slider:SetHeight(Slider:GetTall())

	Slider.Knob.SetSize(Slider.Knob, 20, 20)

	if self.PostPerformLayout then
		self:PostPerformLayout()
	end
end

surface.CreateFont("rpui.slider.font", {
    font = "Roboto", 
    extended = true,
    antialias = true,
    size = 16 * (ScrH() / 1080)
})

function PANEL:Paint(w, h)
	SetDrawColor(self.Colors.Line)

	local size = self.Slider.GetTall(self.Slider) + 4
	local offset = 0.5 * size

	DrawRect(0, size*0.175, w, size*0.35)

	local r_tall = 0.3871 * h

    DisableClipping( true );
        local x;
        local y = h - 3;

        local step = math.Round(self.MaxValue * 0.25);
        local ny, ns = size - 2, size * 0.6;
        
        x = 0;
        DrawRect( x, ny, 1, ns );
        SimpleText( "1", "rpui.slider.font", x, y, self.Colors.White, Align.Center, Align.Bottom );

        x = w * 0.25;
        DrawRect( x, ny, 1, ns );
        SimpleText( 1 + step * 1, "rpui.slider.font", x, y, self.Colors.White, Align.Center, Align.Bottom );

        x = w * 0.50;
        DrawRect( x, ny, 1, ns );
        SimpleText( 1 + step * 2, "rpui.slider.font", x, y, self.Colors.White, Align.Center, Align.Bottom );

        x = w * 0.75;
        DrawRect( x, ny, 1, ns );
        SimpleText( 1 + step * 3, "rpui.slider.font", x, y, self.Colors.White, Align.Center, Align.Bottom );

        x = w;
        DrawRect( x, ny, 1, ns );
        SimpleText( self.ShowMax and self.MaxValue or translates.Get("ВСЁ"), "rpui.slider.font", x, y, self.Colors.White, Align.Center, Align.Bottom );
    DisableClipping( false );
end

function PANEL:GetPseudoKnobPos()
    return Lerp( math_Clamp(self.Slider.GetSlideX(self.Slider), 0, 1), 1, self.MaxValue );
end

function PANEL:SetPseudoKnobPos(v)
    self.Slider.SetSlideX( self.Slider, math_Clamp(v / self.MaxValue, 0, 1) );
end

function PANEL:Think()
	if self.Slider.IsEditing(self.Slider) then
		if self.OnSliderMove then
			self:OnSliderMove()
		end
	end
end

vgui.Register("urf.im/rpui/numslider", PANEL, "EditablePanel")