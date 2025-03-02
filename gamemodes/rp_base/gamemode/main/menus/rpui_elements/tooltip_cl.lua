-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_elements\\tooltip_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
surface.CreateFont( "rpui.DefaultTooltipFont", {
    font = "Montserrat",
    extended = true,
    size = 17
} );

local PANEL = {};

AccessorFunc( PANEL, "BackgroundColor", "BackgroundColor", FORCE_COLOR );

function PANEL:Init()
    self:SetAlpha( 0 );
    self:SetFont( "rpui.DefaultTooltipFont" );
    self:SetBackgroundColor( rpui.UIColors.Hovered );
end

function PANEL:Close()
    if self.Closing then return end
    self.Closing = true;

    if not self.DeleteContentsOnClose and IsValid( self.Contents ) then
        self.Contents:SetVisible( false );
        self.Contents:SetParent();
    end

    self:AlphaTo( 0, 0.25, 0, function( anim, pnl )
        if IsValid( pnl ) then pnl:Remove(); end
    end );
end

function PANEL:PositionTooltip()
    if not IsValid( self.TargetPanel ) then
        self:Close();
        return
    end

    self:PerformLayout();

    local x, y = input.GetCursorPos();
    local w, h = self:GetSize();

    local lx, ly = self.TargetPanel:LocalToScreen( 0, 0 );

    y = math.min( y, ly - h * 1.25 );
    if y < 2 then y = 2; end

    x = math.Clamp( x - w * 0.5, 0, ScrW() - w );
    y = math.Clamp( y, 0, ScrH() - h );

    self:SetPos( x, y );
end

function PANEL:Paint( w, h )
    self:PositionTooltip();

    if not self.StartDraw then
        self.StartDraw = true;
        self:AlphaTo( 255, 0.25 );
    end
end

function PANEL:PaintOver( w, h )
    draw.Blur( self );

    surface.SetDrawColor( self:GetBackgroundColor() );
    surface.DrawRect( 0, 0, w, h );

    draw.SimpleText( self:GetText(), self:GetFont(), w * 0.5, h * 0.5, self:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
end

vgui.Register( "rpui.Tooltip", PANEL, "DTooltip" );