-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_screenpopup_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:SetTitle( text ) self.Content.Title:SetText( string.Trim(text) ); end
function PANEL:GetTitle() return self.Content.Title:GetText(); end

function PANEL:SetDescription( text ) self.Content.Description:SetText( string.Trim(text) ); end
function PANEL:GetDescription() return self.Content.Description:GetText(); end

function PANEL:SetAcceptText( text ) self.Content.Controls.Accept:SetText( string.Trim(text) ); end
function PANEL:GetAcceptText() return self.Content.Controls.Accept:GetText(); end

function PANEL:SetRejectText( text ) self.Content.Controls.Reject:SetText( string.Trim(text) ); end
function PANEL:GetRejectText() return self.Content.Controls.Reject:GetText(); end

function PANEL:SetIcon( mat ) self.mat_Icon = isstring( mat ) and Material( mat, "smooth noclamp" ) or mat; end
function PANEL:GetIcon() return self.mat_Icon; end

function PANEL:SetAccentColor( col ) self.col_Accent = col; self.Content.Title:SetTextColor( self.col_Accent ); end
function PANEL:GetAccentColor() return self.col_Accent; end

function PANEL:DoAccept() end
function PANEL:DoReject() end

function PANEL:Init()
    self.b_FontsInitialized = false;

    self.Content = vgui.Create( "Panel", self );
    self.Content.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Black );
        surface.DrawRect( 0, 0, w, h );
    end

    self.Content.Icon = vgui.Create( "DPanel", self.Content );
    self.Content.Icon:Dock( LEFT );
    self.Content.Icon.Paint = function( this, w, h )
        local icon = self:GetIcon();
        if not icon then return end

        surface.SetDrawColor( self:GetAccentColor() );
        surface.SetMaterial( icon );
        surface.DrawTexturedRect( 0, 0, w, w );
    end

    self.Content.Title = vgui.Create( "DLabel", self.Content );
    self.Content.Title:Dock( TOP );
    self.Content.Title:SetWrap( true );
    self.Content.Title:SetAutoStretchVertical( true );
    self.Content.Title:SetContentAlignment( 4 );

    self.Content.Description = vgui.Create( "DLabel", self.Content );
    self.Content.Description:Dock( TOP );
    self.Content.Description:SetWrap( true );
    self.Content.Description:SetAutoStretchVertical( true );
    self.Content.Description:SetContentAlignment( 4 );

    self.Content.Controls = vgui.Create( "Panel", self.Content );
    self.Content.Controls:Dock( TOP );

    self.Content.Controls.Accept = vgui.Create( "DButton", self.Content.Controls );
    self.Content.Controls.Accept:Dock( LEFT );
    self.Content.Controls.Accept.DoClick = function( this )
        self:Close(); self:DoAccept();
    end
    self.Content.Controls.Accept.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        surface.SetDrawColor( color_white );
        surface.DrawRect( 0, h - h * 0.1, w, h * 0.1 );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Content.Controls.Reject = vgui.Create( "DButton", self.Content.Controls );
    self.Content.Controls.Reject:Dock( LEFT );
    self.Content.Controls.Reject.DoClick = function( this )
        self:Close(); self:DoReject();
    end
    self.Content.Controls.Reject.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );
        baseColor.g, baseColor.b = 0, 0;
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self:SetAccentColor( color_white );
    self:SetTitle( "Title" );
    self:SetDescription( "Description" );
    self:SetAcceptText( translates.Get("ПРИНЯТЬ") );
    self:SetRejectText( translates.Get("ОТМЕНА") );
    self:SetIcon( Material("rpui/exclamation.png", "smooth noclamp") );

    self:SetAlpha( 0 );
    self:AlphaTo( 255, 0.25 );
end

function PANEL:Close()
    if self.b_Removing then return end
    self.Content.Controls.Accept:SetDisabled( true );
    self.Content.Controls.Reject:SetDisabled( true );
    self:AlphaTo( 0, 0.25, 0, function( anim, pnl ) pnl:Remove(); end );
end

function PANEL:PerformLayout( w, h )
    self.fl_Padding = math.Round( h * 0.05 );

    if not self.b_FontsInitialized then
        surface.CreateFont( "rpui.Fonts.ScreenNotify-Large", {
            font = "Montserrat Bold",
            size = self.fl_Padding,
            weight = 800,
            extended = true,
        } );

        surface.CreateFont( "rpui.Fonts.ScreenNotify-Default", {
            font = "Montserrat",
            size = self.fl_Padding * 0.35,
            weight = 400,
            extended = true,
        } );

        self.Content.Title:SetFont( "rpui.Fonts.ScreenNotify-Large" );
        self.Content.Description:SetFont( "rpui.Fonts.ScreenNotify-Default" );
        self.Content.Controls.Accept:SetFont( "rpui.Fonts.ScreenNotify-Default" );
        self.Content.Controls.Reject:SetFont( "rpui.Fonts.ScreenNotify-Default" );
    end

    self.Content:DockPadding( self.fl_Padding * 4, self.fl_Padding, self.fl_Padding * 4, self.fl_Padding );

    self.Content.Icon:DockMargin( 0, 0, self.fl_Padding, 0 );
    self.Content.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Content.Description:DockMargin( self.fl_Padding * 0.5, 0, 0, self.fl_Padding * 0.5 );
    self.Content.Controls.Accept:DockMargin( 0, 0, self.fl_Padding * 0.5, 0 );

    self.Content:SetWide( w );

    self.Content.Controls.Accept:Dock( NODOCK ); self.Content.Controls.Accept:SizeToContentsX( self.fl_Padding ); self.Content.Controls.Accept:SizeToContentsY( self.fl_Padding * 0.5 );
    self.Content.Controls.Reject:Dock( NODOCK ); self.Content.Controls.Reject:SizeToContentsX( self.fl_Padding ); self.Content.Controls.Reject:SizeToContentsY( self.fl_Padding * 0.5 );
    self.Content.Controls:InvalidateLayout( true );
    self.Content.Controls:SizeToChildren( false, true );
    self.Content.Controls.Accept:Dock( LEFT );
    self.Content.Controls.Reject:Dock( LEFT );

    self.Content.Icon:Dock( NODOCK );
    self.Content.Icon:SetSize( 0, 0 );

    self.Content:InvalidateLayout( true );
    self.Content:SizeToChildren( false, true );

    local icon_width = math.min( (w - self.fl_Padding * 8) * 0.2, self.Content:GetTall() - self.fl_Padding * 2 );
    self.Content.Icon:Dock( LEFT );
    self.Content.Icon:SetWide( icon_width );

    self.Content:Center();

    self:Stop();
    self:SetAlpha( 0 );
    self:AlphaTo( 255, 0.25 );
end

function PANEL:Paint( w, h )
    surface.SetDrawColor( rpui.UIColors.Background );
    surface.DrawRect( 0, 0, w, h );
    draw.Blur( self );
end

vgui.Register( "rpui.ScreenPopup", PANEL, "EditablePanel" );