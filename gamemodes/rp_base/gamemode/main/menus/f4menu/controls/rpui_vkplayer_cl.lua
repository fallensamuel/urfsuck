-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_vkplayer_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
-- rpui.VKPlayer
----------------------------------------------------------------
do
    local PANEL = {};

    function PANEL:SetHandler( entity )
        self.Entity = entity;
    end

    function PANEL:RefreshTracks( tracks )
        if not IsValid( self ) then return end

        self.Browse.Container:Clear();

        local size = (self.Browse:GetWide() - self.Browse:GetScrollbarMargin() - self.Browse:GetScrollbarWidth() - self.innerPadding) / 3;

        for k, data in ipairs( tracks or {} ) do
            local track = self.Browse.Container:Add( "DButton" );
            track:SetSize( size, size );
            track:SetAlpha( 0 );
            track:AlphaTo( 255, 0.5, k * 0.025 );

            track.dtHovered = 1;
            track.t_ascr = 0;
            track.t_tscr = 0;
            track.data = data;

            track.DoClick = function( this )
                if not IsValid( self.Entity ) then return end
                self.Entity.Network.Handlers[self.Entity.Network.SEND_TRACK]( self.Entity, this.data );
            end

            track.Paint = function( this, w, h )
                track.dtHovered = Lerp( RealFrameTime() * 12, track.dtHovered, this:IsHovered() and 1 or 0 );

                local px, py = self.Browse:LocalToScreen();
                local pw, ph = self.Browse:GetSize();
                
                local s, is = 1 + track.dtHovered * 0.2;
                local is = (1 - s);
                local wx, wy = this:LocalToScreen( 0, 0 );
                local sw, sh = w * s, h * s;
                
                local sp = h * 0.05;

                self.RenderMatrix:SetTranslation( Vector(wx * is - sw * 0.5 + w * 0.5, wy * is - sh * 0.5 + h * 0.5, 0) );
                self.RenderMatrix:SetScale( Vector(1 * s,1 * s,1) );

                render.SetScissorRect( px, py, px + pw, py + ph, true );
                render.PushFilterMag( TEXFILTER.ANISOTROPIC );
                cam.PushModelMatrix( self.RenderMatrix );
                
                this:SetDrawOnTop( this:IsHovered() );
                
                if this:IsHovered() then
                    DisableClipping( true );

                    for i = 1, 3 do
                        local s = 2;
                        this:GetSkin().tex.Shadow( -5*s, -5*s, w+10*s, h+10*s );
                    end

                    DisableClipping( false );

                    if not this.hoverring then
                        this.hoverring = SysTime();
                    end
                end

                surface.SetDrawColor( Color(50,50,50) );
                surface.DrawRect( 0, 0, w, h );
                
                if not track.cover then
                    draw.SimpleText( "?", "rpui.Fonts.VKPlayer.LargeBold", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    track.cover = rp.WebMat:Get( track.data.cover, true );
                else
                    surface.SetMaterial( track.cover );
                    surface.SetDrawColor( color_white );
                    surface.DrawTexturedRect( 0, 0, w, h );
                end

                local hh = math.Round( h * 0.75 );
                surface.SetDrawColor( Color(0,0,0,225) );
                surface.SetMaterial( Material("gui/gradient_up") );
                surface.DrawTexturedRect( 0, 0, w, h );

                local t_tw, t_th = draw.SimpleText( track.data.title, "rpui.Fonts.VKPlayer.Small", sp + this.t_tscr, h - sp, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
                local t_aw, t_ah = draw.SimpleText( track.data.artist, "rpui.Fonts.VKPlayer.SmallBold", sp + this.t_ascr, h - sp - t_th, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

                if this:IsHovered() then
                    if (SysTime() - this.hoverring) > 2 then
                        local s = RealFrameTime() * 32;
                        local sp2 = sp * 2;

                        if (this.t_tscr + t_tw + sp2) > w then
                            this.t_tscr = this.t_tscr - s;
                        end

                        if (this.t_ascr + t_aw + sp2) > w then
                            this.t_ascr = this.t_ascr - s;
                        end
                    end
                else
                    if this.t_tscr ~= 0 then this.t_tscr = 0; end
                    if this.t_ascr ~= 0 then this.t_ascr = 0; end
                    if this.hoverring then this.hoverring = nil; end
                end

                cam.PopModelMatrix();
                render.PopFilterMag();
                render.SetScissorRect( 0, 0, 0, 0, false );

                return true
            end
        end
    end

    function PANEL:RebuildFonts( w, h )
        surface.CreateFont( "rpui.Fonts.VKPlayer.Default", {
            font     = "Montserrat",
            size     = h * 0.035,
            weight   = 0,
            extended = true,
        } );

        surface.CreateFont( "rpui.Fonts.VKPlayer.LargeBold", {
            font     = "Montserrat",
            size     = h * 0.165,
            weight   = 1000,
            extended = true,
        } );

        surface.CreateFont( "rpui.Fonts.VKPlayer.SmallBold", {
            font     = "Montserrat",
            size     = h * 0.03,
            weight   = 1000,
            extended = true,
        } );

        surface.CreateFont( "rpui.Fonts.VKPlayer.Small", {
            font     = "Montserrat",
            size     = h * 0.0225,
            weight   = 600,
            extended = true,
        } );
    end

    function PANEL:Init()
        self.RenderMatrix = Matrix();

        self.Header = vgui.Create( "Panel", self );
        self.Header:Dock( TOP );

        self.Header.Close = vgui.Create( "DButton", self.Header );
        self.Header.Close:Dock( RIGHT );
        self.Header.Close:SetText( translates.Get("ЗАКРЫТЬ") );
        self.Header.Close.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this );

            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            surface.SetDrawColor( self.UIColors.White );
            surface.DrawRect( 0, 0, h, h );

            surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );

            local p = h * 0.1;
            surface.DrawLine( h, p, h, h - p );

            draw.SimpleText( "✕", this:GetFont(), h * 0.5, h * 0.5, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        
            return true
        end
        self.Header.Close.DoClick = function( this )
            self:Close();
        end

        self.Header.Search = vgui.Create( "urf.im/rpui/txtinput", self.Header );
        self.Header.Search:Dock( FILL );
        self.Header.Search:ApplyDesign();
        self.Header.Search:SetPlaceholderText( translates.Get("Поиск...") );

        self.Header.Search.OnEnter = function( this )
            self.Queried = true;

            VKPlayer:Search( string.URLEncode(this:GetValue()), function( tracks )
                if not IsValid( self ) then return end
                self.Queried = false;
                self:RefreshTracks( tracks );
            end );
        end

        self.Browse = vgui.Create( "rpui.ScrollPanel", self );
        self.Browse:Dock( FILL );
        self.Browse:AlwaysLayout( true );

        self.Browse.Container = vgui.Create( "DIconLayout", self.Browse );
        self.Browse.Container:Dock( TOP );
        self.Browse.Container:SetStretchHeight( true );

        self.Browse:AddItem( self.Browse.Container );
    end

    function PANEL:PerformLayout( w, h )
        self:RebuildFonts( w, h );

        self.Header.Close:SetFont( "rpui.Fonts.VKPlayer.Default" );
        self.Header.Search:SetFont( "rpui.Fonts.VKPlayer.Default" );
        self.Header.Search:SetFontInternal( self.Header.Search:GetFont() );

        self.frameW, self.frameH = w, h;

        self.innerPadding = self.frameH * 0.04;

        self.Header:SetTall( self.innerPadding * 1.5 );
        self.Header:DockMargin( self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding );

        self.Header.Close:SetWide( self.Header:GetTall() * 4 );
        self.Header.Close:DockMargin( self.innerPadding, 0, 0, 0 );

        self.Browse:SetScrollbarMargin( self.innerPadding );
        self.Browse:DockMargin( 0, 0, self.innerPadding, self.innerPadding );
        self.Browse:GetCanvas():DockPadding( self.innerPadding, self.innerPadding, 0, self.innerPadding );
    end

    function PANEL:Think()
        if not input.IsKeyDown(KEY_F4) then self.CanClose = true; end

        local focus = vgui.GetKeyboardFocus();
        if (input.IsKeyDown(KEY_ESCAPE) or (input.IsKeyDown(KEY_X) and not (focus:GetClassName() == "TextEntry")) or (input.IsKeyDown(KEY_F4) and self.CanClose)) and !self.Closing then
            gui.HideGameUI();
            self:Close();
        end
    end

    function PANEL:Close()
        self.Closing = true;

        self:AlphaTo( 0, 0.25, 0, function()
            if IsValid( self ) then self:Remove(); end
        end );
    end

    function PANEL:Paint( w, h )
        draw.Blur( self );
        surface.SetDrawColor( rpui.UIColors.Shading );
        surface.DrawRect( 0, 0, w, h );
    end

    vgui.Register( "rpui.VKPlayer", PANEL, "EditablePanel" );
end


----------------------------------------------------------------
-- rpui.VKPlayer_CaptchaSolver
----------------------------------------------------------------
do
    local PANEL = {};

    function PANEL:SetCallback( func )
        self.CallbackFunc = func;
    end

    function PANEL:SetCaptchaURL( url )
        self.CaptchaURL = url;
    end

    function PANEL:RebuildFonts( w, h )
        if self.FontsInitialized then return end
        self.FontsInitialized = true;

        surface.CreateFont( "rpui.Fonts.VKPlayer_CaptchaSolver.Default", {
            font = "Montserrat",
            size = w * 0.065,
            weight = 0,
            extended = true,
        } );
    end

    function PANEL:Think()
        if not input.IsKeyDown(KEY_F4) then self.CanClose = true; end

        local focus = vgui.GetKeyboardFocus();
        if (input.IsKeyDown(KEY_ESCAPE) or ((input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT)) and (vgui.GetHoveredPanel() == self)) or (input.IsKeyDown(KEY_X) and not (focus:GetClassName() == "TextEntry")) or (input.IsKeyDown(KEY_F4) and self.CanClose)) and !self.Closing then
            gui.HideGameUI();
            self:Close();
        end
    end

    function PANEL:Close()
        self.Closing = true;

        self:AlphaTo( 0, 0.25, 0, function()
            if IsValid( self ) then self:Remove(); end
        end );
    end

    function PANEL:Init()
        self:SetSize( ScrW(), ScrH() );
        self:SetAlpha( 0 );
        self:AlphaTo( 255, 0.25 );
        self:Center();
        self:MakePopup();

        self.Canvas = vgui.Create( "EditablePanel", self );
        self.Canvas.Paint = function( this, w, h )
            surface.SetDrawColor( rpui.UIColors.Shading );
            surface.DrawRect( 0, 0, w, h ); surface.DrawRect( 0, 0, w, h );
        end
    
        self.Image = vgui.Create( "Panel", self.Canvas );
        self.Image:SetZPos( 0 );
        self.Image.Paint = function( this, w, h )
            if not self.CaptchaURL then
                surface.SetDrawColor( Color(65,65,65,255) );
                surface.DrawRect( 0, 0, w, h );
                return    
            end
    
            if not self.CaptchaMaterial then
                self.CaptchaMaterial = rp.WebMat:Get( self.CaptchaURL, true );
                surface.SetDrawColor( Color(65,65,65,255) );
                surface.DrawRect( 0, 0, w, h );
                return
            end
    
            surface.SetDrawColor( color_white );
            surface.SetMaterial( self.CaptchaMaterial );
            surface.DrawTexturedRect( 0, 0, w, h );
        end
    
        self.Input = vgui.Create( "urf.im/rpui/txtinput", self.Canvas );
        self.Input:SetZPos( 1 );
        self.Input:SetUpdateOnType( true );
        self.Input:SetPlaceholderText( translates.Get("Введите каптчу, пожалуйста") );
        self.Input:ApplyDesign();
        self.Input.OnEnter = function( this )
            if IsValid( self ) then return end
            self.Send:DoClick();
        end
    
        self.Send = vgui.Create( "DButton", self.Canvas );
        self.Send:SetZPos( 2 );
        self.Send:SetText( translates.Get("ОТПРАВИТЬ") );
        self.Send.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
        self.Send.DoClick = function( this )
            if not IsValid( self ) then return end
            self:Close();
    
            if not self.CallbackFunc then return end
    
            local v = utf8.lower( self.Input:GetValue() );
            self.CallbackFunc( v );
        end
    end

    function PANEL:PerformLayout( w, h )
        self.Canvas:Dock( TOP );
        self.Canvas:DockPadding( h * 0.01, h * 0.075, h * 0.01, h * 0.075 );
        self.Canvas:DockMargin( w * 0.425, 0, w * 0.425, 0 );
        self.Canvas:InvalidateParent( true );

        w = self.Canvas:GetWide();

        self:RebuildFonts( w, h );
        self.Send:SetFont( "rpui.Fonts.VKPlayer_CaptchaSolver.Default" );
        self.Input:SetFont( "rpui.Fonts.VKPlayer_CaptchaSolver.Default" );
        self.Input:SetFontInternal( self.Input:GetFont() );

        local p = w * 0.05;

        self.Image:Dock( TOP );
        self.Image:DockMargin( p * 4, 0, p * 4, p );
        self.Image:SetTall( self.Image:GetWide() * 0.384 );

        self.Input:Dock( TOP );
        self.Input:DockMargin( 0, 0, 0, p );
        self.Input:SetTall( p * 2 );

        self.Send:Dock( TOP );
        self.Send:DockMargin( p * 4, 0, p * 4, p );
        self.Send:SetTall( p * 2 );

        self.Canvas:Dock( NODOCK );
        self.Canvas:SizeToChildren( false, true );
        self.Canvas:Center();
    end

    function PANEL:Paint( w, h )
        draw.Blur( self );
    end

    vgui.Register( "rpui.VKPlayer_CaptchaSolver", PANEL, "EditablePanel" );
end