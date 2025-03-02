-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_dropmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

AccessorFunc( PANEL, "m_bDeleteSelf", "DeleteSelf" );
AccessorFunc( PANEL, "m_fSpacing", "Spacing" );
AccessorFunc( PANEL, "m_cFontName", "Font" );
AccessorFunc( PANEL, "m_pBasePanel", "Base" );
AccessorFunc( PANEL, "m_bNoScroll", "NoScroll" );

function PANEL:Init()
    self.m_fSpacing = 0;
    self.m_cFontName = "DermaDefault";

    self:SetDeleteSelf( true );
    self:SetDrawOnTop( true );

    self.m_Scroll = self:Add( "rpui.ScoreboardScroll" );
    self.m_Scroll:Dock( TOP );
    self.m_Scroll:SetDrawOnTop( true );

    local vbar = self.m_Scroll:GetVerticalBar();
    vbar:SetWide( ScrW() * 0.005 );
    vbar.m_bIsMenuComponent = true;
    vbar.PaintTrack = function( this, w, h )
        local baseColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
    end
    vbar.PaintGrip = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.White );
        surface.DrawRect( 0, 0, w, h );
    end

    hook.Add( "PreventScreenClicks", self, function( this )
        if this.m_Scroll:GetVerticalBar().Depressed then
            return true;
        end
    end );

    RegisterDermaMenuForClose( self );
end

function PANEL:SetBase( pnl )
    self.m_pBasePanel = pnl;
    self:SetWide( pnl:GetWide() );
end

function PANEL:AddOption( name, func )
    -- local Option = vgui.Create( "DButton", self );
    local Option = self.m_Scroll:Add( "DButton" );

    Option.m_bIsMenuComponent = true;
    Option.Spacing = self.m_fSpacing;

    Option:SetFont( self.m_cFontName );
    Option:SetText( name );

    Option:SizeToContentsX( self.m_fSpacing * 2 );
    Option:SizeToContentsY( self.m_fSpacing );

    if isfunction(func) then Option.DoClick = func; end

    self:SetWide( math.max( self:GetWide(), Option:GetWide() ) );

    Option:Dock( TOP );
    Option:InvalidateParent( true );

    self.m_Scroll:SizeToChildren( false, true );

    if not self:GetNoScroll() then
        self.m_Scroll:SetTall( math.min(self.m_Scroll:GetTall(), ScrH() * 0.35) );
    end

    return Option;
end

function PANEL:Open()
    self:InvalidateLayout( true );
    self:SizeToChildren( false, true );

    if self.m_pBasePanel then
		local base = self:GetBase();
        local x, y = base:LocalToScreen();
        self:SetPos( x, y - self:GetTall() );
    end

    self:MakePopup();
	self:SetVisible( true );
    self:SetKeyboardInputEnabled( false );

    self:SetAlpha( 0 );
    self:AlphaTo( 255, 0.25 );
end

vgui.Register( "rpui.DropMenu", PANEL, "Panel" );