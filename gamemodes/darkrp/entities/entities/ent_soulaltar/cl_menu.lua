-- "gamemodes\\darkrp\\entities\\entities\\ent_soulaltar\\cl_menu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:SetControllerEntity( e )
    self.m_eController = isentity(e) and e or NULL;
end

function PANEL:GetControllerEntity()
    return self.m_eController or NULL;
end

function PANEL:GetSoulsAmount()
    local e = self:GetControllerEntity();
    return IsValid(e) and e:GetSouls() or 0;
end

function PANEL:Init()
    self.Header = vgui.Create( "Panel", self );
    self.Header:Dock( TOP );
    self.Header.PerformLayout = function( this, w, h )
        local padding = self.Padding or 0;

        this.Close:SizeToContentsX();
        this.Close:SetWide( this.Close:GetWide() + padding + this.Close:GetTall() );
        this.Close:DockMargin( padding, 0, 0, 0 );
    end

    self.Header.Close = vgui.Create( "DButton", self.Header );
    self.Header.Close:Dock( RIGHT );
    self.Header.Close:SetText( "ЗАКРЫТЬ" );
    self.Header.Close.DoClick = function()
        self:Close();
    end
    self.Header.Close.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this );
        local p = h * 0.1;
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        surface.SetDrawColor( color_white );
        surface.DrawRect( 0, 0, h, h );
        surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );
        surface.DrawLine( h, p, h, h - p );
        draw.SimpleText( "✕", self.font_Symbol or "DermaDefault", h * 0.5, h * 0.5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Header.Title = vgui.Create( "Panel", self.Header );
    self.Header.Title:Dock( FILL );
    self.Header.Title.PerformLayout = function( this, w, h )
        local padding = self.Padding or 0;

        this.Icon:SetSize( h, h );
        this.Label:SetTall( h );

        local x = w * 0.5 - (this.Icon:GetWide() + this.Label:GetWide()) * 0.5
        this.Icon:SetX( x );

        x = x + this.Icon:GetWide() + padding;
        this.Label:SetX( x );
    end
    self.Header.Title.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    self.Header.Title.Icon = vgui.Create( "Panel", self.Header.Title );
    self.Header.Title.Icon._Material = Material( "buy.png", "smooth noclamp" );
    self.Header.Title.Icon.Paint = function( this, w, h )
        surface.SetDrawColor( color_white );
        surface.SetMaterial( this._Material );
        surface.DrawTexturedRect( 0, 0, w, h );
    end

    self.Header.Title.Label = vgui.Create( "DLabel", self.Header.Title );
    self.Header.Title.Label.Think = function( this )
        local text = string.format( "СОБРАНО ДУШ: %d", self:GetSoulsAmount() );

        if this:GetText() ~= text then
            this:SetText( text );
            this:SizeToContentsX();
            this:InvalidateLayout( true );
        end
    end

    self.Content = vgui.Create( "rpui.ScrollPanel", self );
    self.Content:Dock( FILL );

    self:PopulateItems();
end

function PANEL:RebuildFonts( w, h )
    if not self.b_FontsInitialized then
        self.b_FontsInitialized = true;

        surface.CreateFont( "SoulsVendor.Symbol", {
            font = "Montserrat",
            size = h * 0.03,
            weight = 500,
            extended = true,
        } );

        surface.CreateFont( "SoulsVendor.Close", {
            font = "Montserrat Medium",
            size = h * 0.02,
            weight = 600,
            extended = true,
        } );

        surface.CreateFont( "SoulsVendor.Large", {
            font = "Montserrat Medium",
            size = h * 0.04,
            weight = 600,
            extended = true,
        } );

        surface.CreateFont( "SoulsVendor.Default", {
            font = "Montserrat",
            size = h * 0.025,
            weight = 400,
            extended = true,
        } );

        self.font_Symbol = "SoulsVendor.Symbol";
        self.font_Large = "SoulsVendor.Large";
        self.font_Default = "SoulsVendor.Default";

        self.Header.Title.Label:SetFont( "SoulsVendor.Large" );
        self.Header.Close:SetFont( "SoulsVendor.Close" );
    end
end

function PANEL:PerformLayout( w, h )
    self:RebuildFonts( w, h );

    local padding = rpui.PowOfTwo( h * 0.02 );
    self.Padding = padding;

    self:DockPadding( padding, padding, padding, padding );

    self.Header:SetTall( padding * 2.5 );
    self.Header:DockMargin( 0, 0, 0, padding );

    self.Content:DockMargin( padding, padding, padding, padding );
    self.Content:SetScrollbarWidth( padding * 0.5 );
    self.Content:SetSpacingY( padding * 0.5 );
end

function PANEL:Close()
    if self.b_IsClosing then return end
    self.b_IsClosing = true;

    self:AlphaTo( 0, 0.25, 0, function( anim, pnl )
        if not IsValid( pnl ) then return end
        pnl:Remove();
    end );
end

function PANEL:BuyFunc( class )
    local e = self:GetControllerEntity();
    if not IsValid( e ) then return end

    net.Start( "SoulAltar" );
        net.WriteEntity( e );
        net.WriteString( class );
    net.SendToServer();
end

function PANEL:PopulateItems()
    local items = rp.cfg.SoulAltar;
    if not items then return end

    self.Content:ClearItems();

    for class, price in pairs( items ) do
        self:PopulateItem( class, price or 0 );
    end
end

function PANEL:PopulateItem( class, price )
    local item = weapons.Get( class );
    if not item then return end

    local pnl = vgui.Create( "DButton" );
    pnl:Dock( TOP );

    pnl.PrintName = item.PrintName or class;
    pnl.PriceText = string.format( "за %d душ алтаря", price );

    pnl.Icon = vgui.Create( "Panel", pnl );
    pnl.Icon:Dock( LEFT );
    pnl.Icon.Paint = function( this, w, h )
        surface.SetDrawColor( color_black );
        surface.DrawRect( 0, 0, h, h );
    end

    pnl.Icon._ModelImage = vgui.Create( "ModelImage", pnl.Icon );
    pnl.Icon._ModelImage:Dock( FILL );
    pnl.Icon._ModelImage:SetModel( item.WorldModel or "models/props_junk/cardboard_box001a.mdl" );

    pnl.DoClick = function()
        self:BuyFunc( class );

        self.Content:SetMouseInputEnabled( false );

        timer.Simple( 1, function()
            if not IsValid( self.Content ) then return end
            self.Content:SetMouseInputEnabled( true );
        end );
    end

    pnl.PerformLayout = function( this, w, h )
        local padding = (self.Padding or 0) * 0.25;
        h = self:GetTall() * 0.075;

        this:SetTall( h );
        this.Icon:SetWide( h );
        this.Icon:DockPadding( padding, padding, padding, padding );
    end

    pnl.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        if price > self:GetSoulsAmount() then
            surface.SetDrawColor( Color(255,0,0,32) );
            surface.DrawRect( 0, 0, w, h );
        end

        local x, y, p = 0, 0, h * 0.2;

        x, y = x + this.Icon:GetWide() + p, h * 0.5;
        draw.SimpleText( this.PrintName or "Неизвестный предмет", self.font_Large or "DermaLarge", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

        x, y = w - p, h - p;
        draw.SimpleText( this.PriceText, self.font_Default or "DermaDefault", x, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM );

        return true
    end

    self.Content:AddItem( pnl );
end

function PANEL:Paint( w, h )
    draw.Blur( self );

    surface.SetDrawColor( rpui.UIColors.Background );
    surface.DrawRect( 0, 0, w, h );
end

vgui.Register( "SoulAltarMenu", PANEL, "EditablePanel" );