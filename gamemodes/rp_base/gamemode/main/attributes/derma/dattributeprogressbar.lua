-- "gamemodes\\rp_base\\gamemode\\main\\attributes\\derma\\dattributeprogressbar.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {
	RawData 	 = {},
	AmountValue  = 0,
	UpgradeValue = 0,
	BoostValue	 = 0,
	Text		 = nil,
	_textcolor   = color_white,
	_font 		 = "Default",
}

AccessorFunc(PANEL, "Color", "Color")

PANEL:SetColor(Color(255, 0, 0))

function PANEL:SetAttributeData( attribdata )
	self.RawData = attribdata;
end

function PANEL:SetAmountValue( num )
	self.AmountValue = num;
end

function PANEL:SetUpgradeValue( num )
	self.UpgradeValue = num;
end

function PANEL:SetBoostValue( num )
	self.BoostValue = num;
end

function PANEL:SetText( text )
	self.Text = text;
end

function PANEL:SetTextColor( clr )
	self._textcolor = clr;
end

function PANEL:SetFont( font )
	self._font = font;
end


function PANEL:PaintOver( w, h )
	x = x or 0
	y = y or 0
	--surface.SetDrawColor(255, 255, 255, 220)
	--surface.DrawLine(1, 0, w - 2, 0)
	--surface.DrawLine(0, 1, 0, h - 2)
	--surface.DrawLine(w - 1, 2, w - 1, h - 2)
	--surface.DrawLine(1, h - 1, w - 2, h -1)

	local w_Amount  = math.Round( (w - 2) * ( self.AmountValue / self.RawData.MaxAmount ) );
	local w_Upgrade = math.Round( (w - 2) * ( self.UpgradeValue * self.RawData.UpgradeConversionRate / self.RawData.MaxAmount ) );
	local w_Boost   = math.Round( (w - 2) * ( self.BoostValue / self.RawData.MaxAmount ) );

	surface.SetDrawColor( self:GetColor() );
	surface.DrawRect( 1, 1, w_Amount, h-2 );

	surface.SetDrawColor( Color(255,0,0,95+math.sin(CurTime()*6)*55) );
	surface.DrawRect( w_Amount, 0, w_Upgrade, h - 2);

	surface.SetDrawColor( Color(255,155,0,200) );
	surface.DrawRect( w_Amount+w_Upgrade, 0, w_Boost, h -2);

	draw.SimpleText( (self.Text or (self.AmountValue .. "/" .. self.RawData.UpgradeMax)), self._font, w/2, h/2, self._textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
end


vgui.Register( "DAttributeProgressBar", PANEL, "DPanel" );