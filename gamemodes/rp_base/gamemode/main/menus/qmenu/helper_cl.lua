-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\helper_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if true then return end

QMenu.AddCategory( translates.Get("Справочник"),
    function()
        local RootFrame = vgui.Create( "Panel" );

        RootFrame.PerformLayout = function( this, w, h )
            if this.LayoutPerformed then return end

            this.RowView = vgui.Create( "rpui.RowView", RootFrame );

            this.RowView:SetWide( RootFrame:GetWide() * 0.75 );
            this.RowView:SetSpacingX( RootFrame:GetTall() * 0.025 );
            this.RowView:SetSpacingY( RootFrame:GetTall() * 0.025 );

            this.RowView.Paint = function( self, w, h )
                self:Center();
            end

            surface.CreateFont( "rpui.Fonts.QMenu.HelperTitle", {
                font     = "Montserrat",
                size     = this.RowView:GetWide() * 0.03,
                weight   = 1000,
                extended = true,
            } );

            surface.CreateFont( "rpui.Fonts.QMenu.HelperTitleSub", {
                font     = "Montserrat",
                size     = this.RowView:GetWide() * 0.025,
                weight   = 600,
                extended = true,
            } );

            for k, v in ipairs( rp.cfg.MoTD ) do
                local HelperButton = vgui.Create( "DButton" );
                HelperButton:SetWide( this.RowView:GetWide() * 0.5 - this.RowView:GetSpacingX() * 0.5 );
                HelperButton:SetTall( HelperButton:GetWide() * 0.25 );
                HelperButton:SetText( v[1] );

                HelperButton.DoClick = function()
                    gui.OpenURL( v[2] );
                end

                HelperButton.Paint = function( self, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( self, STYLE_SOLID );

                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );

                    local s = rpui.PowOfTwo( h * 0.85 );
                    local o = (h - s) * 0.5;

                    surface.SetDrawColor( Color(255,0,0) );
                    surface.DrawRect( o, o, s, s );

                    local _, th = draw.SimpleText( self:GetText(), "rpui.Fonts.QMenu.HelperTitle", s + o * 2, o, textColor );

                    local descText = v[3] or "описание? описание? описание? описание? описание? описание? описание? описание?";
                    
                    if not self.BakedText then
                        self.BakedText = rpui.BakeText( descText, "rpui.Fonts.QMenu.HelperTitleSub", w - s - o * 3, h - o * 3 - th );
                    end

                    for k, v in ipairs( self.BakedText ) do
                        draw.SimpleText( v.text, "rpui.Fonts.QMenu.HelperTitleSub", s + o * 2 + v.x, o + th + v.y, Color(127,127,127) );
                    end

                    return true
                end

                this.RowView:AddItem( HelperButton, "" );
            end

            this.RowView.CategoriesLabel[""]:Remove();
            this.RowView:InvalidateLayout( true );
            this.RowView:SizeToChildren( false, true );

            this.LayoutPerformed = true;
        end
    
        return RootFrame;
    end,
nil, "icon16/star.png", 0 );