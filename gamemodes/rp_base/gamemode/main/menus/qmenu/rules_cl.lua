-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\rules_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ChromiumBranches = {
    ["chromium"] = true,
    ["x86-64"]   = true,
};

QMenu.AddCategory( translates.Get("Правила сервера"),
    function()
        local URL = rp.cfg.MoTD[1][2];

        local RootFrame = vgui.Create( "Panel" );

        RootFrame.PerformLayout = function( self, w, h )
            if self.LayoutPerformed then return end
            self.LayoutPerformed = true;
            
            --[[
            self.Footer = vgui.Create( "Panel", self );
            self.Footer:Dock( BOTTOM );
            self.Footer:SetTall( h * 0.075 );
            self.Footer:InvalidateParent( true );
            self.Footer.PerformLayout = function( this, w, h )
                if IsValid( this.OpenInBrowser ) then
                    this.OpenInBrowser:Center();
                end
            end

            self.Footer.OpenInBrowser = vgui.Create( "DButton", self.Footer );
            self.Footer.OpenInBrowser:SetFont( "DermaDefault" );
            self.Footer.OpenInBrowser:SetText( translates.Get("Открыть в браузере") );
            self.Footer.OpenInBrowser:SizeToContentsY( self.Footer:GetTall() * 0.25 );
            self.Footer.OpenInBrowser:SizeToContentsX( self.Footer.OpenInBrowser:GetTall() );
            self.Footer.OpenInBrowser.DoClick = function( this )
                gui.OpenURL( URL );
            end
            ]]--

            if ChromiumBranches[BRANCH] then
                self.HTMLViewer = vgui.Create( "DHTML", self );
                self.HTMLViewer:OpenURL( URL );
                self.HTMLViewer:SetVisible( false );

                self.HTMLViewer.OnDocumentReady = function( this, url )
                    this:Dock( FILL );
                    this:SetVisible( true );
                end

                return
            else
                self.MessageViewer = vgui.Create( "Panel", self );
                self.MessageViewer:Dock( FILL );
                self.MessageViewer:InvalidateParent( true );
                self.MessageViewer.Paint = function( this, w, h )
                    -- draw.RoundedBox( 4, 0, 0, w, h, Color( 100, 100, 100 ) );

                    if IsValid( this.Content ) then
                       this.Content:Center();
                    end
                end

                self.MessageViewer.Content = vgui.Create( "Panel", self.MessageViewer );

                surface.SetFont( "DermaLarge" );
                local _, blockheight = surface.GetTextSize( " " );

                local URFLogo = vgui.Create( "Panel", self.MessageViewer.Content );
                URFLogo.URLMaterial = "https://urf.im/content/banner_logos/2.png";
                URFLogo:SetTall( blockheight * 2 );
                URFLogo:SetWide( URFLogo:GetTall() * 4 );
                URFLogo.Paint = function( this, w, h )
                    if not this.Material then
                        this.Material = rp.WebMat:Get( this.URLMaterial or "https://urf.im/content/banner_logos/2.png", true );
                        return
                    end

                    surface.SetDrawColor( rpui.UIColors.White );
                    surface.SetMaterial( this.Material );
                    surface.DrawTexturedRect( 0, 0, w, h );
                end

                local Label1 = vgui.Create( "DLabel", self.MessageViewer.Content );
                Label1:SetY( URFLogo:GetTall() + blockheight );
                Label1:SetFont( "DermaLarge" );
                Label1:SetText( translates.Get("Чтобы просматривать правила прямо в игре,") );
                Label1:SizeToContents();

                local Label2 = vgui.Create( "DLabel", self.MessageViewer.Content );
                Label2:SetY( Label1:GetY() + Label1:GetTall() );
                Label2:SetFont( "DermaLarge" );
                Label2:SetText( translates.Get("смените версию игры на Chromium") );
                Label2:SizeToContents();

                local Label3 = vgui.Create( "DButton", self.MessageViewer.Content );
                Label3:SetY( Label2:GetY() + Label2:GetTall() + blockheight );
                --Label3:SetFont( "DermaLarge" );
                Label3:SetText( translates.Get("Узнать подробнее") );
                Label3:SizeToContentsY( h * 0.025 );
                Label3:SizeToContentsX( Label3:GetTall() * 2 );
                --Label3.Paint = function( this, w, h )
                --    local clr = this:GetTextColor() or rpui.UIColors.White;
                --    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, clr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                --    surface.SetDrawColor( clr );
                --    surface.DrawRect( 0, h - 2, w, 2 );
                --    return true
                --end
                Label3.DoClick = function( this )
                    gui.OpenURL( "https://urf.im/page/tech#chromium" );
                end

                self.MessageViewer.Content:SizeToChildren( true, true );

                URFLogo:CenterHorizontal();
                Label1:CenterHorizontal();
                Label2:CenterHorizontal();
                Label3:CenterHorizontal();
            end
        end
    
        return RootFrame;
    end,
nil, "icon16/report.png", 0 );