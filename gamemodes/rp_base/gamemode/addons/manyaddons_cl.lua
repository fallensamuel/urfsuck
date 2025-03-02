-- "gamemodes\\rp_base\\gamemode\\addons\\manyaddons_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local cv_manyaddons = cvar.Register("enable_manyaddonsnotify"):SetDefault(true):AddMetadata("State", "RPMenu"):AddMetadata("Menu", "Включить нотификацию о большом количестве аддонов");

local function ShowMessage()
    local popup = rp.NotifyVoteClient( "", 0, 120 );
    local title = translates.Get( "Кажется, у вас много аддонов" );

    popup.SetupButton = function( self, text, callback )
        local button = vgui.Create( "DButton" );

        button:SetFont( "rpui.notifyvote.font" );
        button:SetText( text or "Button" );
        button:SizeToContentsY( (self.fl_Padding or 0) * 0.75 );

        button.DoClick = function( this )
            this:SetMouseInputEnabled( false );

            if isfunction( callback ) then
                callback( this );
            end
        end

        button.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end

        return button;
    end

    popup.WrapText = function( text, font, w )
        surface.SetFont( font );

        local sw, sh = surface.GetTextSize( " " );
        local ret = {};
        local x, y = 0, 1;
        local line = "";
        local words = string.Explode( " ", text );

        for k, word in ipairs( words ) do
            local tw = surface.GetTextSize( word );
            local nx = x + tw;

            if nx > w then
                ret[y] = string.SetChar( line, #line, "" );
                x, y = tw + sw, y + 1;
                line = word .. " ";
                continue
            end

            line = line .. word .. " ";
            x = nx + sw;
        end

        ret[y] = string.SetChar( line, #line, "" );

        return ret, sh;
    end

    popup.Initialize = function( self )
        local fontData = table.Copy( surface.RegistredFonts["rpui.notifyvote.font"] );
        fontData.weight = 1000;
        surface.CreateFont( "rpui.notifyvote.font-bold", fontData );

        self.__OnPopupSizeTo = self.OnPopupSizeTo;
        self.OnPopupSizeTo = function( this, w, h )
            this:__OnPopupSizeTo( w, h );

            local parent = this.popup;
            for _, child in ipairs( parent:GetChildren() ) do
                child:Remove();
            end

            local padding = this:GetWide() * 0.025;
            this.fl_Padding = padding;

            parent:DockPadding( padding, padding, padding, padding );

            local actions = vgui.Create( "Panel", parent );
            actions:Dock( BOTTOM );
            actions:DockMargin( 0, padding, 0, 0 );

            actions.PerformLayout = function( pnl, pnl_w, pnl_h )
                pnl:SizeToChildren( false, true ); pnl_h = pnl:GetTall();

                local childrens = pnl:GetChildren();
                local count = #childrens;

                local s = (pnl_w - (padding * (count - 1))) / count;

                for k, child in ipairs( childrens ) do
                    child:SetSize( s, pnl_h );
                    child:Dock( LEFT );
                    child:DockMargin( 0, 0, padding, 0 );
                end
            end

            actions:Add( this:SetupButton(translates.Get("Отписаться"), function( btn )
                this:Close();
                gui.OpenURL( "https://steamcommunity.com/profiles/" .. LocalPlayer():SteamID64() .. "/myworkshopfiles/?appid=4000&browsefilter=mysubscriptions" );
            end) );

            actions:Add( this:SetupButton(translates.Get("Отказаться"), function( btn )
                this:Close();
            end) );

            actions:Add( this:SetupButton(translates.Get("Спрятать"), function( btn )
                this:Close();
                cv_manyaddons:SetValue( false );
            end) );

            --
            local content = vgui.Create( "DPanel", parent );
            content:Dock( FILL );

            content.Cache = {};
            content.Paint = function( pnl, pnl_w, pnl_h )

                if not pnl.Cache[pnl_w] then
                    pnl.Cache[pnl_w] = { self.WrapText(translates.Get("Советуем отписаться от всех аддонов для повышения FPS!"), "rpui.notifyvote.font-bold", pnl_w) };
                end

                local block_h = (#pnl.Cache[pnl_w][1] * pnl.Cache[pnl_w][2]);

                local x = pnl_w * 0.5;
                local y = pnl_h * 0.5 - block_h * 0.5;

                for k, line in ipairs( pnl.Cache[pnl_w][1] ) do
                    draw.SimpleTextOutlined( line, "rpui.notifyvote.font", x, y, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, rpui.UIColors.Shading );
                    y = y + pnl.Cache[pnl_w][2];
                end
            end
        end
    end

    popup.__Think = popup.Think;
    popup.Think = function( self )
        self:__Think();
        self.Title = title;
    end

    popup:Initialize();
end

rp.RegisterLoginPopup( 5, ShowMessage, function()
   return cv_manyaddons:GetValue() and #(engine.GetAddons() or {}) >= 200;
end );