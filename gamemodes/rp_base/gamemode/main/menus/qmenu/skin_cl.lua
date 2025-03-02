-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\skin_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Color, Material, CreateMaterial, GetRenderTargetEx = Color, Material, CreateMaterial, GetRenderTargetEx;
local ScrW, ScrH, FrameNumber, DisableClipping = ScrW, ScrH, FrameNumber, DisableClipping;
local hook_Add, table_Copy = hook.Add, table.Copy;
local cam_Start2D, cam_End2D = cam.Start2D, cam.End2D;
local render_UpdateScreenEffectTexture, render_CopyTexture, render_GetScreenEffectTexture, render_PushRenderTarget, render_PopRenderTarget, render_SetScissorRect = render.UpdateScreenEffectTexture, render.CopyTexture, render.GetScreenEffectTexture, render.PushRenderTarget, render.PopRenderTarget, render.SetScissorRect;
local surface_SetDrawColor, surface_SetMaterial, surface_DrawTexturedRect, surface_DrawOutlinedRect, surface_DrawRect = surface.SetDrawColor, surface.SetMaterial, surface.DrawTexturedRect, surface.DrawOutlinedRect, surface.DrawRect;
local draw_SimpleText = draw.SimpleText;
local derma_GetDefaultSkin, derma_DefineSkin, derma_RefreshSkins = derma.GetDefaultSkin, derma.DefineSkin, derma.RefreshSkins;
----------------------------------------------------------------
local SKIN = {};
    
SKIN.Materials = {};
SKIN.Materials.PPBlur = Material( "pp/blurscreen" );
SKIN.Materials.__rt_blur = GetRenderTargetEx( "urf-DermaSkin__rt_blur", ScrW(), ScrH(), RT_SIZE_LITERAL, MATERIAL_RT_DEPTH_ONLY, 0, 0, IMAGE_FORMAT_DEFAULT );
SKIN.Materials.Blur = CreateMaterial( "urf-DermaSkin-Blur", "UnlitGeneric", {
    ["$basetexture"] = SKIN.Materials.__rt_blur:GetName(),
    ["$translucent"] = 1,
    ["$vertexcolor"] = 1,
    ["$vertexalpha"] = 1,
} );

hook_Add( "PostDrawHUD", "urf.DermaSkin::UpdateBlur", function()
    if SKIN.BlurUpdate then
        if not (FrameNumber()%2 == 0) then return end
        
        local PPBlur_tex = SKIN.Materials.PPBlur:GetTexture( "$basetexture" );

        cam_Start2D();
            render_UpdateScreenEffectTexture();
            render_CopyTexture( render_GetScreenEffectTexture(), SKIN.Materials.__rt_blur );

            render_PushRenderTarget( SKIN.Materials.__rt_blur );
                for i = 1, 3 do
                    SKIN.Materials.PPBlur:SetTexture( "$basetexture", SKIN.Materials.__rt_blur );
                    SKIN.Materials.PPBlur:SetFloat( "$blur", i * 0.5 * 5 );
                    SKIN.Materials.PPBlur:Recompute();

                    surface_SetDrawColor( color_white );
                    surface_SetMaterial( SKIN.Materials.PPBlur );
                    surface_DrawTexturedRect( 0, 0, ScrW(), ScrH() );
                end
            render_PopRenderTarget();
        cam_End2D();
            
        SKIN.Materials.PPBlur:SetTexture( "$basetexture", PPBlur_tex );
        SKIN.BlurUpdate = nil;
    end
end );

hook_Add( "rpBase.Loaded", "urf.DermaSkin::Initialize", function()
    cvar.Register( "urf-dermaskin.disable" ):SetDefault( false ):AddMetadata( "State", "RPMenu" ):AddMetadata( "Menu", "Выключить новое оформление спавн-меню" ):AddCallback( function() timer.Simple(RealFrameTime(), function() hook.Run("ForceDermaSkin") end) end );

    SKIN.Colours = table_Copy( derma_GetDefaultSkin().Colours );

    SKIN.Colours.__DEBUG = Color( 255, 0, 0 );
    SKIN.Colours.White = Color( 255, 255, 255 );
    SKIN.Colours.LightWhite = Color( 245, 245, 245 );
    SKIN.Colours.BackgroundClr = Color( 0, 0, 0, 200 );
    SKIN.Colours.BackgroundClr_Light = Color( 0, 0, 0, 100 );
    SKIN.Colours.BackgroundClr_Dark = Color( 0, 0, 0, 225 );
    SKIN.Colours.Shadow = Color( 0, 0, 0, 200 );
    SKIN.Colours.HoverHighlight = Color( 31, 133, 222, 64 );
    SKIN.Colours.FillClr = Color( 31, 133, 222 );
    SKIN.Colours.CollabsibleBackground = Color( 40, 40, 40, 200 );
	
    SKIN.Colours.Label.Default = SKIN.Colours.LightWhite;
	SKIN.Colours.Label.Dark = SKIN.Colours.LightWhite;
    SKIN.Colours.Label.Bright = SKIN.Colours.LightWhite;
    SKIN.Colours.Label.Highlight = SKIN.Colours.LightWhite;
    
    SKIN.Colours.Button.Normal = SKIN.Colours.LightWhite;
    SKIN.Colours.Button.Hover = SKIN.Colours.LightWhite;
    SKIN.Colours.Button.Down = SKIN.Colours.LightWhite;
    SKIN.Colours.Button.Disabled = SKIN.Colours.LightWhite;
    
    SKIN.Colours.Tree.Lines = SKIN.Colours.LightWhite;
    SKIN.Colours.Tree.Normal = SKIN.Colours.LightWhite;
    SKIN.Colours.Tree.Hover = SKIN.Colours.LightWhite;
    SKIN.Colours.Tree.Selected = SKIN.Colours.LightWhite;
    
    SKIN.Colours.Category.Line.Button = SKIN.Colours.BackgroundClr;
    SKIN.Colours.Category.Line.Button_Hover = SKIN.Colours.HoverHighlight;
    SKIN.Colours.Category.Line.Button_Selected = SKIN.Colours.BackgroundClr;
    SKIN.Colours.Category.LineAlt.Button = SKIN.Colours.BackgroundClr;
    SKIN.Colours.Category.LineAlt.Button_Hover = SKIN.Colours.HoverHighlight;
    SKIN.Colours.Category.LineAlt.Button_Selected = SKIN.Colours.BackgroundClr;

	SKIN.Colours.Category.Line.Text = SKIN.Colours.LightWhite;
    SKIN.Colours.Category.Line.Text_Hover = SKIN.Colours.LightWhite;
    SKIN.Colours.Category.Line.Text_Selected = SKIN.Colours.FillClr;
	SKIN.Colours.Category.LineAlt.Text = SKIN.Colours.LightWhite;
    SKIN.Colours.Category.LineAlt.Text_Hover = SKIN.Colours.LightWhite;
    SKIN.Colours.Category.LineAlt.Text_Selected = SKIN.Colours.FillClr;

    SKIN.Colours.TooltipText = SKIN.Colours.LightWhite;

    SKIN.PaintDebug = function( self, panel, w, h )
        surface_SetDrawColor( SKIN.Colours.__DEBUG );
        surface_DrawOutlinedRect( 0, 0, w, h );
    end

    function SKIN:PaintBlur( panel, x, y, w, h )
        SKIN.BlurUpdate = true;
        
        if (not w) or (not h) then
            w, h = x, y; x, y = 0, 0;
        end
        
        local px, py = panel:LocalToScreen( 0, 0 );
        x, y = x + px, y + py;

	    surface_SetDrawColor( Color(255,255,255,panel:GetAlpha()) );
	    surface_SetMaterial( SKIN.Materials.Blur );

        render_SetScissorRect( x, y, x + w, y + h, true );
        surface_DrawTexturedRect( -px, -py, ScrW(), ScrH() );
        render_SetScissorRect( 0, 0, 0, 0, false );
    end

    function SKIN:PaintPanel( panel, w, h )
        if not panel.m_bBackground then return end
        surface_SetDrawColor( self.Colours.BackgroundClr );
		surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintShadow( panel, w, h )
        self.tex.Shadow( 0, 0, w, h );
        surface_SetDrawColor( self.Colours.Shadow );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintFrame( panel, w, h ) -- UNUSED?
        if panel.m_bPaintShadow then
            DisableClipping( true );
                self.tex.Shadow( -4, -4, w + 8, h + 8 );
            DisableClipping( false );
        end

        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintButton( panel, w, h )
        if panel:GetName() ~= "DImageButton" then
            if panel:GetPaintBackground() then
                surface_SetDrawColor( self.Colours.BackgroundClr );
                surface_DrawRect( 0, 0, w, h );
                
                if panel:IsHovered() then
                    surface_SetDrawColor( self.Colours.HoverHighlight );
                    surface_DrawRect( 0, 0, w, h );
                end
            end
        end
    end

    function SKIN:PaintTree( panel, w, h )
        if not panel.m_bBackground then return end
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintCheckBox( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );

        if panel:GetChecked() then
            if not panel:GetDisabled() then
                surface_SetDrawColor( self.Colours.FillClr );
                surface_DrawRect( 4, 4, w - 8, h - 8 );
            end
        end

        if panel:IsHovered() then
            surface_SetDrawColor( self.Colours.HoverHighlight );
            surface_DrawRect( 0, 0, w, h );
        end

        surface_SetDrawColor( self.Colours.LightWhite );
        surface_DrawOutlinedRect( 0, 0, w, h );
    end

    function SKIN:PaintExpandButton( panel, w, h )
        self.tex[panel:GetExpanded() and "TreeMinus" or "TreePlus"]( 0, 0, w, h );
    end

    function SKIN:PaintTextEntry( panel, w, h )
        if panel.m_bBackground then
            if panel:GetDisabled() then
                self.tex.TextBox_Disabled( 0, 0, w, h );
            elseif panel:HasFocus() then
                self.tex.TextBox_Focus( 0, 0, w, h );
            else
                surface_SetDrawColor( self.Colours.LightWhite );
                surface_DrawRect( 0, 0, w, h );
            end
        end

        if panel.GetPlaceholderText and panel.GetPlaceholderColor and panel:GetPlaceholderText() and panel:GetPlaceholderText():Trim() ~= "" and panel:GetPlaceholderColor() and (not panel:GetText() or panel:GetText() == "") then
            local oldText = panel:GetText();

            local str = panel:GetPlaceholderText();
            if str:StartWith("#") then str = str:sub(2); end
            str = language.GetPhrase(str);
    
            panel:SetText( str );
            panel:DrawTextEntryText( panel:GetPlaceholderColor(), panel:GetHighlightColor(), panel:GetCursorColor() );
            panel:SetText( oldText );
    
            return
        end

        panel:DrawTextEntryText( panel:GetTextColor(), panel:GetHighlightColor(), panel:GetCursorColor() );
    end

    -- function SKIN:SchemeTextEntry( panel )
    --     panel:SetTextColor( panel:GetTextColor() or self.colTextEntryText );
    --     panel:SetHighlightColor( panel:GetHighlightColor() or self.colTextEntryTextHighlight );
    --     panel:SetCursorColor( panel:GetCursorColor() or self.colTextEntryTextCursor );
    -- end

    function SKIN:PaintMenu( panel, w, h )
        self.tex[panel:GetDrawColumn() and "MenuBG_Column" or "MenuBG"]( 0, 0, w, h );
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintMenuSpacer( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintMenuOption( panel, w, h )
        if panel.m_bBackground and (panel.Hovered or panel.Highlight) then
            self.tex.MenuBG_Hover( 0, 0, w, h );
        end

        if panel:GetChecked() then
            self.tex.Menu_Check( 5, h * 0.5 - 7, 15, 15 );
        end

        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintMenuRightArrow( panel, w, h )
        self.tex.Menu.RightArrow( 0, 0, w, h );
    end

    function SKIN:PaintPropertySheet( panel, w, h )
        self:PaintBlur( panel, 0, 20, w, h - 20 );
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 20, w, h - 20 );
    end

    function SKIN:PaintTab( panel, w, h )
        if panel:GetPropertySheet():GetActiveTab() == panel then
            return self:PaintTabActive( panel, w, h );
        end
        
        -- self:PaintBlur( panel, w - 5, h );
        -- surface.SetDrawColor( self.Colours.BackgroundClr_Light );
        -- surface.DrawRect( 0, 0, w - 5, h );
    end

    function SKIN:PaintTabActive( panel, w, h )
        self:PaintBlur( panel, w - 5, h - 8 );
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w - 5, h - 8 );
    end

    function SKIN:PaintWindowCloseButton( panel, w, h )
        if not panel.m_bBackground then return end

        if panel:GetDisabled() then
            return self.tex.Window.Close( 0, 0, w, h, Color(255,255,255,50) );
        end

        if panel.Depressed or panel:IsSelected() then
            return self.tex.Window.Close_Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Window.Close_Hover( 0, 0, w, h );
        end

        self.tex.Window.Close( 0, 0, w, h );
    end

    function SKIN:PaintWindowMinimizeButton( panel, w, h )
        if not panel.m_bBackground then return end

        if panel:GetDisabled() then
            return self.tex.Window.Mini( 0, 0, w, h, Color(255,255,255,50) );
        end

        if panel.Depressed or panel:IsSelected() then
            return self.tex.Window.Mini_Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Window.Mini_Hover( 0, 0, w, h );
        end

        self.tex.Window.Mini( 0, 0, w, h );
    end

    function SKIN:PaintWindowMaximizeButton( panel, w, h )
        if not panel.m_bBackground then return end

        if panel:GetDisabled() then
            return self.tex.Window.Maxi( 0, 0, w, h, Color(255,255,255,50) );
        end

        if panel.Depressed or panel:IsSelected() then
            return self.tex.Window.Maxi_Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Window.Maxi_Hover( 0, 0, w, h );
        end

        self.tex.Window.Maxi( 0, 0, w, h );
    end

    function SKIN:PaintVScrollBar( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintScrollBarGrip( panel, w, h )
        local bar = w - 8;
        surface_SetDrawColor( self.Colours.LightWhite );
        surface_DrawRect( w * 0.5 - bar * 0.5, 2, bar, h - 4 );
    end

    function SKIN:PaintButtonUp( panel, w, h )
        draw_SimpleText( "▲", "DermaDefault", w * 0.5 - 1, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end

    function SKIN:PaintButtonDown( panel, w, h )
        draw_SimpleText( "▼", "DermaDefault", w * 0.5 - 1, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end

    function SKIN:PaintButtonLeft( panel, w, h )
        draw_SimpleText( "◀", "DermaDefault", w * 0.5 - 1, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end

    function SKIN:PaintButtonRight( panel, w, h )
        draw_SimpleText( "▶", "DermaDefault", w * 0.5 - 1, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end

    function SKIN:PaintComboDownArrow( panel, w, h )
        -- unused, unstable
    end
        
    function SKIN:PaintComboBox( panel, w, h )
        if panel:GetDisabled() then
            surface_SetDrawColor( self.Colours.BackgroundClr );
            surface_DrawRect( 0, 0, w, h );

            return
        end

        if panel.Depressed or panel:IsMenuOpen() then
            surface_SetDrawColor( self.Colours.HoverHighlight );
            surface_DrawRect( 0, 0, w, h );

            draw_SimpleText( "▲", "DermaDefault", w - h * 0.5, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            
            return
        end

        if panel.Hovered then
            surface_SetDrawColor( self.Colours.HoverHighlight );
            surface_DrawRect( 0, 0, w, h );

            draw_SimpleText( "▼", "DermaDefault", w - h * 0.5, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            
            return
        end

        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );

        draw_SimpleText( "▼", "DermaDefault", w - h * 0.5, h * 0.5, self.Colours.LightWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end

    function SKIN:PaintListBox( panel, w, h )
		surface_SetDrawColor( self.Colours.BackgroundClr );
		surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintNumberUp( panel, w, h )
        if panel:GetDisabled() then
            return self.Input.UpDown.Up.Disabled( 0, 0, w, h );
        end

        if panel.Depressed then
            return self.tex.Input.UpDown.Up.Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Input.UpDown.Up.Hover( 0, 0, w, h );
        end

        self.tex.Input.UpDown.Up.Normal( 0, 0, w, h );
    end

    function SKIN:PaintNumberDown( panel, w, h )
        if panel:GetDisabled() then
            return self.Input.UpDown.Down.Disabled( 0, 0, w, h );
        end

        if panel.Depressed then
            return self.tex.Input.UpDown.Down.Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Input.UpDown.Down.Hover( 0, 0, w, h );
        end

        self.tex.Input.UpDown.Down.Normal( 0, 0, w, h );
    end

    function SKIN:PaintTreeNode( panel, w, h )
        if not panel.m_bDrawLines then return end
        
        surface_SetDrawColor( self.Colours.Tree.Lines );
        surface_DrawRect( 9, 0, 1, panel.m_bLastChild and 7 or h );
        surface_DrawRect( 9, 7, 9, 1 );
    end

    function SKIN:PaintTreeNodeButton( panel, w, h )
        if not panel.m_bSelected then return end

        local w = panel:GetTextSize();
        surface_SetDrawColor( self.Colours.FillClr );
        surface_DrawRect( 38, 0, w + 6, h );
    end

    function SKIN:PaintSelection( panel, w, h )
        self.tex.Selection( 0, 0, w, h );
    end

    function SKIN:PaintSliderKnob( panel, w, h )
        if panel:GetDisabled() then
            return self.tex.Input.H.Disabled( 0, 0, w, h );
        end

        if panel.Depressed then
            return self.tex.Input.Slider.H.Down( 0, 0, w, h );
        end

        if panel.Hovered then
            return self.tex.Input.Slider.H.Hover( 0, 0, w, h );
        end

        self.tex.Input.Slider.H.Normal( 0, 0, w, h );
    end

    local function PaintNotches( x, y, w, h, num )
        if not num then return end
        
        local space = w / num;
        
        for i = 0, num do
            surface_DrawRect( x + i * space, y + 4, 1, 5 );
        end
    end

    function SKIN:PaintNumSlider( panel, w, h )
        surface_SetDrawColor( self.Colours.LightWhite );
        surface_DrawRect( 8, h * 0.5 - 1, w - 15, 1 );
        PaintNotches( 8, h * 0.5 - 1, w - 16, 1, panel.m_iNotches );
    end

    function SKIN:PaintProgress( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );

        surface_SetDrawColor( self.Colours.FillClr );
        surface_DrawRect( 0, 0, w * panel:GetFraction(), h );
    end

    function SKIN:PaintCollapsibleCategory( panel, w, h )
        if panel:GetExpanded() then
            surface_SetDrawColor( self.Colours.FillClr );
        else
            draw_SimpleText( "▼", "DermaDefault", w - 5, 9, self.Colours.LightWhite, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
            surface_SetDrawColor( self.Colours.CollabsibleBackground );
        end

        surface_DrawRect( 0, 0, w, 20 );
    end

    function SKIN:PaintCategoryList( panel, w, h )
        if panel:GetParent() == g_ContextMenu then
            self:PaintBlur( panel, w, h );    
        end

        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintCategoryButton( panel, w, h )
        local t = panel.AltLine and "LineAlt" or "Line";
        
        if panel.Hovered then
            surface_SetDrawColor( self.Colours.Category[t].Button_Hover );
            surface_DrawRect( 0, 0, w, h );
            return
        else
            surface_SetDrawColor( self.Colours.Category[t].Button );
            surface_DrawRect( 0, 0, w, h );
            return
        end
    end

    function SKIN:PaintListViewLine( panel, w, h )
        if panel:IsSelected() then
            surface_SetDrawColor( self.Colours.FillClr );
            surface_DrawRect( 0, 0, w, h );
            return
        end
        
        if panel.Hovered then
            surface_SetDrawColor( self.Colours.HoverHighlight );
            surface_DrawRect( 0, 0, w, h );
            return
        end
    end

    function SKIN:PaintListView( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintTooltip( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr_Dark );
        surface_DrawRect( 0, 0, w, h );
    end

    function SKIN:PaintMenuBar( panel, w, h )
        surface_SetDrawColor( self.Colours.BackgroundClr );
        surface_DrawRect( 0, 0, w, h );
    end

    derma_DefineSkin( "urf-dermaskin", "[urf.im] Derma Skin", SKIN );
    
    local currentSkin = "Default";
    hook_Add( "ForceDermaSkin", "urf.DermaSkin::ForceDermaSkin", function()
        local newSkin = cvar.GetValue("urf-dermaskin.disable") and "Default" or "urf-dermaskin"; 
        
        if currentSkin ~= newSkin then
            currentSkin = newSkin;
            timer.Simple( 1, derma_RefreshSkins );
        end

        return currentSkin 
    end );
end );