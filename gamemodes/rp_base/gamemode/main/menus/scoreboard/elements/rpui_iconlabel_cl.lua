-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\elements\\rpui_iconlabel_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

AccessorFunc( PANEL, "m_IconColor", "IconColor", FORCE_COLOR );
AccessorFunc( PANEL, "m_TextColor", "TextColor", FORCE_COLOR );
AccessorFunc( PANEL, "m_Text", "Text", FORCE_STRING );
AccessorFunc( PANEL, "m_Font", "Font", FORCE_STRING );
AccessorFunc( PANEL, "fl_IconInset", "IconInset", FORCE_NUMBER );

--[[
function PANEL:PaintOver( w, h )
    surface.SetDrawColor( Color(255, 0, 0) );
    surface.DrawOutlinedRect( 0, 0, w, h );
end
]]--

function PANEL:Init()
    self:SetIconColor( Color(255, 255, 255) );
    self:SetIconInset( 1 );
    self:SetIcon( Material("error") );

    self:SetTextColor( Color(255, 255, 255) );
    self:SetFont( "DermaDefault" );
    self:SetText( "Label" );

    self:SetTall( draw.GetFontHeight(self:GetFont()) );
    self:SizeToContents();
end

function PANEL:SizeToContents( addValX, addValY )
    self:SizeToContentsY( addValY );
    self:SizeToContentsX( addValX );
end

function PANEL:SizeToContentsX( addVal )
    local w, h = self:GetContentSize();
    h = math.max( self:GetTall(), h ) - h;
    self:SetWide( h + w + (addVal or 0) );
end

function PANEL:SizeToContentsY( addVal )
    local w, h = self:GetContentSize();
    h = h + (addVal or 0);

    self:SetTall( h );
    self:SetWide( math.max(self:GetWide(), h + self.fl_FontWidth + w) );
end

function PANEL:GetContentSize()
    surface.SetFont( self:GetFont() );
    local w, h = surface.GetTextSize( self:GetText() );
    w = h + self.fl_FontWidth + w + self.fl_FontWidth;
    return w, h;
end

function PANEL:GetIcon()
    return self.m_Icon;
end

function PANEL:SetIcon( mat )
    self.m_Icon = mat;
end

function PANEL:SetFont( font )
    self.m_Font = font;

    surface.SetFont( self.m_Font );
    self.fl_FontWidth, self.fl_FontHeight = surface.GetTextSize( "  " );
end

function PANEL:OnMousePressed( key )
    self.b_MousePressed = true;
end

function PANEL:OnMouseReleased( key )
    if not self.b_MousePressed then return end
    self.b_MousePressed = nil;

    if self.DoClick and self:IsHovered() then
        self:DoClick();
    end
end

function PANEL:Paint( w, h )
    local hh, ih = h * 0.5, h * self:GetIconInset();
    local ix = hh - ih * 0.5;

    surface.SetDrawColor( self:GetIconColor() );
    surface.SetMaterial( self:GetIcon() );
    surface.DrawTexturedRect( ix, ix, ih, ih );

    surface.SetTextColor( self:GetTextColor() );
    surface.SetFont( self:GetFont() );
    surface.SetTextPos( h + self.fl_FontWidth, hh - self.fl_FontHeight * 0.5 );
    surface.DrawText( self:GetText() );
end

vgui.Register( "rpui.IconLabel", PANEL, "Panel" );