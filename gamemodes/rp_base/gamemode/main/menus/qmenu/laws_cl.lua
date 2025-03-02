-- "gamemodes\\rp_base\\gamemode\\main\\menus\\qmenu\\laws_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
surface.CreateFont( "rpui.Fonts.QMenuLaws", {
    font = (surface.RegistredFonts["HudFont"] or {}).font or "Montserrat",
    size = ScrH() * 0.03,
    weight = 400,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.QMenuLaws.Large", {
    font = (surface.RegistredFonts["HudFont"] or {}).font or "Montserrat",
    size = ScrH() * 0.05,
    weight = 400,
    extended = true,
} );

local function LineRenderer( self, w, h )
    local padding = (w * 0.05);
    local line = self:GetText();
    local font = self:GetFont();
    local x = padding;
    local y = 0;
    local color = self:GetTextColor();
    local bold = false;
    local italic = false;

    surface.SetFont( font or "DermaDefault" );
    local tw, th = surface.GetTextSize( " " );
    y = th * 0.5;

    -- Fonts:
    if not surface.RegistredFonts[font .. ":lr-b"] then
        local f = table.Copy( surface.RegistredFonts[font] );
        f.weight = 1000;
        surface.CreateFont( font .. ":lr-b", f );
    end

    if not surface.RegistredFonts[font .. ":lr-i"] then
        local f = table.Copy( surface.RegistredFonts[font] );
        f.italic = true;
        surface.CreateFont( font .. ":lr-i", f );
    end

    if not surface.RegistredFonts[font .. ":lr-bi"] then
        local f = table.Copy( surface.RegistredFonts[font] );
        f.weight = 1000;
        f.italic = true;
        surface.CreateFont( font .. ":lr-bi", f );
    end

    -- Mods:
    local colors = {};
    for v in string.gmatch( line, "$%x[%xw]%x" ) do
        if v[3] == "w" then
            if (v[2] == "0") and (v[4] == "0") then
                colors[v] = HSVToColor( CurTime() * 32 % 360, 1, 1 );
            end

            break;
        end

        colors[v] = Color( tonumber(v[2], 16) * 17, tonumber(v[3], 16) * 17, tonumber(v[4], 16) * 17 );
    end

    -- Renderer:
    local c = 1;
    for k, text in ipairs( string.Explode("%s+", line, true) ) do
        local mod_color = colors[text];
        if mod_color then
            color = mod_color; c = c + #text + 1;
            continue
        end

        local mod_bold = text[1] == "*";
        if mod_bold then
            if bold then
                bold, text = false, string.SetChar( text, 1, "" );
            else
                if string.find( line, "*", c + 1 ) then
                    bold, text = true, string.SetChar( text, 1, "" );
                end
            end
        end

        local mod_italic = text[1] == "_";
        if mod_italic then
            if italic then
                italic, text = false, string.SetChar( text, 1, "" );
            else
                if string.find( line, "_", c + 1 ) then
                    italic, text = true, string.SetChar( text, 1, "" );
                end
            end
        end

        local mod_list = string.match( text, "^(%s*[%+%-%>%d%.]+)" );
        if (k == 1) and mod_list then
            if not isnumber(tonumber(mod_list[1])) then
                text = mod_list[1];
                self.TextInset = padding * #mod_list;
            else
                self.TextInset = 0;
            end
        end

        c = c + #text + 1;
        font = (bold or italic) and self:GetFont() .. ":lr-" .. (bold and "b" or "") .. (italic and "i" or "") or self:GetFont();

        surface.SetFont( font or "DermaDefault" );
        tw, th = surface.GetTextSize( text );
        if (x + tw) > (self:GetWide() - padding - padding) then
            x = 0; y = y + th;
        end

        local mod_bold = text[#text] == "*";
        if mod_bold then
            if bold then
                bold, text = false, string.SetChar( text, #text, "" );
            end
        end

        local mod_italic = text[#text] == "_";
        if mod_italic then
            if italic then
                italic, text = false, string.SetChar( text, #text, "" );
            end
        end

        x = x + draw.SimpleTextOutlined( text .. " ", font, (self.TextInset or 0) + x, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black );
    end

    if not self.TextInset then
        surface.SetDrawColor( color_white );
        DisableClipping( true );
            surface.DrawRect( 0, -2, w, 2 );
        DisableClipping( false );
        self:DockMargin( 0, th, 0, 0 );
    end
end


QMenu.AddCategory( translates.Get("Законы"),
    function()
        local RootFrame = vgui.Create( "rpui.ScrollPanel" );
        RootFrame:AlwaysLayout( true );

        RootFrame.UpdateLaws = function( self )
            self:ClearItems();
        
            for k, textline in ipairs( string.Explode("\n", self.Laws or "") ) do
                if #string.Trim(textline) == 0 then continue end
        
                local Label = vgui.Create( "DLabel" );
        
                Label:SetWrap( true );
                Label:SetAutoStretchVertical( true );
                Label:SetTextColor( color_white );
                Label:SetText( textline );
                Label:Dock( TOP );
        
                if k > 1 then
                    Label:SetFont( "rpui.Fonts.QMenuLaws" );

                    Label.Paint = function( this, w, h )
                        LineRenderer( this, w, h );
                        return true
                    end
                else
                    Label:SetFont( "rpui.Fonts.QMenuLaws.Large" );
                    
                    Label.Paint = function( this, w, h )
                        draw.SimpleTextOutlined( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black );
                        return true
                    end
                end
        
                self:AddItem( Label );
            end
        end

        RootFrame.BaseThink = RootFrame.Think;
        RootFrame.Think = function( self )
            RootFrame:BaseThink();

            local Laws = rp.cfg.DefaultLaws .. "";

            local DefaultLaws_assoc = {};
            for k, v in ipairs( string.Explode( "\n", rp.cfg.DefaultLaws, true ) ) do
                DefaultLaws_assoc[v] = true;
            end

            local NewLaws = "";
            for k, v in ipairs( string.Explode( "\n", nw.GetGlobal("TheLaws") or "", true ) ) do
                if not DefaultLaws_assoc[v] then
                    NewLaws = NewLaws .. v .. "\n";
                end
            end

            if #NewLaws > 0 then
                Laws = rp.cfg.DefaultLaws .. "\n" .. translates.Get( "Временные" ) .. ":\n" .. NewLaws;
            end 
            
            if (self.Laws or "") ~= Laws then
                self.Laws = Laws;
                self:UpdateLaws();
            end
        end

        return RootFrame;
    end,
nil, "icon16/page.png", 10 );