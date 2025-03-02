-- "gamemodes\\rp_base\\gamemode\\addons\\stream_banners\\cl_stream_banners.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function DrawStencilBorder(rotAngle, x, y, w, h, t, bottom_clr, top_clr, alpha )
    render.SetStencilWriteMask( 255 );
    render.SetStencilTestMask( 255 );
    render.SetStencilReferenceValue( 0 );
    render.SetStencilPassOperation( STENCIL_KEEP );
    render.SetStencilZFailOperation( STENCIL_KEEP );
    render.ClearStencil();
    render.SetStencilEnable( true );
    render.SetStencilReferenceValue( 1 );
    render.SetStencilCompareFunction( STENCIL_NEVER );
    render.SetStencilFailOperation( STENCIL_REPLACE );

    local bs = rpui.PowOfTwo(h * t);
    local ds = math.sqrt( w*w + h*h );

    draw.NoTexture();
    surface.SetDrawColor( rpui.UIColors.White );
    surface.DrawRect( x, y, w, bs );
    surface.DrawRect( x, y + h - bs, w, bs );
    surface.DrawRect( x, y, bs, h );
    surface.DrawRect( x + w - bs, y, bs, h );

    render.SetStencilCompareFunction( STENCIL_EQUAL );
    render.SetStencilFailOperation( STENCIL_KEEP );

    surface.SetAlphaMultiplier( alpha or 1 );
        --surface.SetDrawColor( bottom_clr );
        --surface.DrawRect(x, y, w, h );

        surface.SetDrawColor( top_clr );
        surface.SetMaterial( rpui.GradientMat );
        surface.DrawTexturedRectRotated(x + w*0.5, y + h*0.5, ds, ds, rotAngle);
    surface.SetAlphaMultiplier( 1 );

    render.SetStencilEnable( false );
end

file.CreateDir( "urf/streambanners/logos" );
file.CreateDir( "urf/streambanners/text_decoration" );

local StreamBannerDrawText = true;

function StreamBanner(id, preview, w, h)
    if not rp.cfg.StreamBanners then return end

    local ply, CurTime = LocalPlayer(), CurTime;

    local data = rp.cfg.StreamBanners[id];
    if not data then return end

    local MaxTextPos = #data.phrases;
    local NextTextChange = 0;
    local TextPos = 0;

    local Text = "";
    local TextW, TextH, textcolor, decor_color, textshadow, logo_url, italic_text, shadow_distance, text_decoration, animeborder, decoration_url, decoration_material;

    local scale = data.scale

    local logo_size = {
        w = 700 * scale,
        h = 165 * scale
    };

    local decor_size = {
        w = 770 * scale,
        h = 60  * scale
    };

    local text_pos = {
        x = logo_size.w * 0.5,
        y = logo_size.h + 24 * scale
    };

    local ScrW, ScrH = ScrW, ScrH;
    w, h = w or ScrW(), h or ScrH();

    local rotAngle = 0;
    local black_a = Color(0, 0, 0, 146);
    local transparent = Color(0, 0, 0, 0);

    local function ChangeText()
        local CT = CurTime();
        if NextTextChange > CT then return end

        NextTextChange = CT + data.delay;

        TextPos = TextPos + 1;
        if TextPos > MaxTextPos then TextPos = 1 end

        local PhraseData = data.phrases[TextPos];

        TextW, TextH = 0, 0;

        if istable( PhraseData ) then
            Text = PhraseData.text or translates.Get("garry's mod — значит urf.im");

            -- Text Color:
            if PhraseData.textcolor then
                textcolor = PhraseData.textcolor;
            else
                textcolor = data.textcolor;
            end

            -- Decoration Color:
            if PhraseData.decor_color then
                decor_color = PhraseData.decor_color;
            else
                decor_color = data.decor_color;
            end

            -- Text Shadow:
            if PhraseData.textshadow then
                textshadow = PhraseData.textshadow;
            else
                textshadow = data.textshadow;
            end

            -- Logo Shadow:
            if PhraseData.logo_shadow then
                logo_url = "https://urf.im/content/banner_logos/" .. (PhraseData.logo_shadow and 2 or 1) .. ".png";
                http.DownloadMaterial(
                    logo_url,
                    "urf/streambanners/logos/".. (PhraseData.logo_shadow and 2 or 1) ..".png",
                    function(mat) logo_material = mat end,
                    3
                );
            else
                logo_url = "https://urf.im/content/banner_logos/" .. (data.logo_shadow and 2 or 1) .. ".png";
                http.DownloadMaterial(
                    logo_url,
                    "urf/streambanners/logos/".. (data.logo_shadow and 2 or 1) ..".png",
                    function(mat) logo_material = mat end,
                    3
                );
            end

            -- Italic Text:
            if PhraseData.italic_text then
                italic_text = PhraseData.italic_text;
            else
                italic_text = data.italic_text;
            end

            -- Text Shadow Distance:
            if PhraseData.textshadow_distance then
                shadow_distance = PhraseData.textshadow_distance * 0.5;
            else
                shadow_distance = (data.textshadow_distance or 4) * 0.5;
            end

            -- Text Decoration:
            if PhraseData.text_decoration then
                text_decoration = (PhraseData.text_decoration == "blurshadow") or (PhraseData.text_decoration == "gradient");
                animeborder     = (PhraseData.text_decoration == "animeborder");
                decoration_url  = text_decoration and ("https://urf.im/content/text_decoration/" .. PhraseData.text_decoration .. ".png") or nil;
                if decoration_url then
                    decoration_material = Material( "models/effects/vol_light001" );
                    http.DownloadMaterial(
                        decoration_url,
                        "urf/streambanners/text_decoration/".. PhraseData.text_decoration ..".png",
                        function(mat) if not mat:IsError() then decoration_material = mat; end end,
                        3
                    );
                end
            else
                text_decoration = (data.text_decoration == "blurshadow") or (data.text_decoration == "gradient");
                animeborder     = (data.text_decoration == "animeborder");
                decoration_url  = text_decoration and ("https://urf.im/content/text_decoration/" .. data.text_decoration .. ".png") or nil;
                if decoration_url then
                    decoration_material = Material( "models/effects/vol_light001" );
                    http.DownloadMaterial(
                        decoration_url,
                        "urf/streambanners/text_decoration/".. data.text_decoration ..".png",
                        function(mat) if not mat:IsError() then decoration_material = mat; end end,
                        3
                    );
                end
            end
        else
            Text = PhraseData;

            -- Text Color:
            textcolor = data.textcolor;

            -- Decoration Color:
            decor_color = data.decor_color;

            -- Text Shadow:
            textshadow = data.textshadow;

            -- Logo Shadow:
            logo_url = "https://urf.im/content/banner_logos/" .. (data.logo_shadow and 2 or 1) .. ".png";
            http.DownloadMaterial(
                logo_url,
                "urf/streambanners/logos/".. (data.logo_shadow and 2 or 1) ..".png",
                function(mat) logo_material = mat end,
                3
            );

            -- Italic Text:
            italic_text = data.italic_text;

            -- Text Shadow Distance:
            shadow_distance = (data.textshadow_distance or 4) * 0.5;

            -- Text Decoration:
            text_decoration = (data.text_decoration == "blurshadow") or (data.text_decoration == "gradient");
            animeborder     = (data.text_decoration == "animeborder");
            decoration_url  = text_decoration and ("https://urf.im/content/text_decoration/" .. data.text_decoration .. ".png") or nil;
            if decoration_url then
                decoration_material = Material( "models/effects/vol_light001" );
                http.DownloadMaterial(
                    decoration_url,
                    "urf/streambanners/text_decoration/".. data.text_decoration ..".png",
                    function(mat) if not mat:IsError() then decoration_material = mat; end end,
                    3
                );
            end
        end

        surface.CreateFont( "urf.im/stream_banners/" .. TextPos, {
            font      = "Montserrat",
            extended  = true,
            antialias = true,
            size      = 43.2 * scale,
            italic    = italic_text or false
        } );
    end

    ChangeText();

    local Render = function()
        if logo_material == nil then return end

        ChangeText();

        surface.SetDrawColor( color_white );

        local logo_x = w - logo_size.w - data.margin;
        surface.SetMaterial( logo_material );
        surface.DrawTexturedRect( logo_x, data.margin, logo_size.w, logo_size.h );

        if StreamBannerDrawText then
            local txtx, txty = w - logo_size.w*0.5 - data.margin,  data.margin + text_pos.y;

            if animeborder then
                rotAngle = rotAngle + 50 * RealFrameTime();

                local w, h = TextW, TextH;
                local x, y = txtx - TextW*0.5, txty - TextH*0.375;

                DrawStencilBorder( rotAngle, x - h * 0.5, y - h * 0.2, w + h, h + h * 0.4, 0.06, transparent, decor_color, 1 );
            elseif decoration_material then
                surface.SetDrawColor( decor_color );
                surface.SetMaterial( decoration_material );

                local TextW, TextH = TextW * 1.1, TextH;
                surface.DrawTexturedRect( txtx - TextW * 0.5, txty - TextH * 0.375, TextW, TextH );
            end

            if textshadow then
                TextW, TextH = draw.SimpleTextShadow(
                    Text,
                    "urf.im/stream_banners/" .. TextPos,
                    txtx, txty,
                    textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
                    shadow_distance, decor_color.a, decor_color
                );
            else
                TextW, TextH = draw.SimpleText(
                    Text,
                    "urf.im/stream_banners/" .. TextPos,
                    txtx, txty,
                    textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
                );
            end
        end
    end

    if preview then
        return Render
    else
        if cvar.GetValue("enable_lawshud") then
            cvar.SetValue( "enable_lawshud", false );
        end

        hook.Add( "HUDPaint", "StreamBanners", Render );
    end
end

function BannersPreview()
    local menu = vgui.Create("urf.im/rpui/menus/blank&scroll")
    menu:SetSize(370, 700)
    menu:Center()
    menu:MakePopup()

    menu.header.SetIcon(menu.header, "ping_system/follow.png")
    menu.header.SetTitle(menu.header, "Стрим баннеры")
    menu.header.SetFont(menu.header, "rpui.playerselect.title")
    menu.header.IcoSizeMult = 1.5

    menu.scroll.SetSpacingY(menu.scroll, 10)

    for id, data in ipairs(rp.cfg.StreamBanners) do
        local preview = vgui.Create("DButton")
        preview:SetText("")
        preview.id = id
        menu.scroll:AddItem(preview)
        preview:Dock(TOP)
        preview:SetSize(370, 140)
        preview.Paint = StreamBanner(id, true, 340, 140)
        preview.Think = function(me)
            me:SetAlpha(me:IsHovered() and 255 or 150)
        end
        preview:SetTooltip("Нажмите что-бы скопировать команду")
        preview.DoClick = function()
            SetClipboardText("urf streambanner PLAYER ".. id)
        end
    end

    menu.Think = function(me)
        local exists = hook.Exists("HUDPaint", "StreamBanners")

        if me.scroll.Canvas:IsChildHovered() then
            if exists == false then
                StreamBanner(vgui.GetHoveredPanel().id)
            end
        elseif exists then
            DisableStreamBanner()
        end
    end
end


--
function DisableStreamBanner()
    if cvar.GetValue( "enable_lawshud" ) == false then
        cvar.SetValue( "enable_lawshud", true );
    end

    hook.Remove( "HUDPaint", "StreamBanners" );
end

local banner_id = 0;

net.Receive( "StreamBanners", function()
    local bBannerState = net.ReadBool();
    if bBannerState then
        banner_id = net.ReadUInt( math.BitCount(#rp.cfg.StreamBanners) );

        if banner_id > 0 then
            StreamBanner( banner_id );
        end
    else
        banner_id = 0;
        DisableStreamBanner();
    end

    local bShowText = net.ReadBool();
    if bShowText then
        StreamBannerDrawText = net.ReadBool();
    else
        if bBannerState then
            if banner_id < 1 then
                DisableStreamBanner();
            end
        end
    end
end );

cvar.Register( "enable_streambanner" )
    :SetDefault( false )
    :AddMetadata( "State", "RPMenu" )
    :AddMetadata( "Menu", "Включить отображение рекламного баннера" )
    :AddCallback( function( old, new )
        local c = #rp.cfg.StreamBanners;

        if (c < 1) or (banner_id > 0) then
            return
        end

        if not new then
            DisableStreamBanner();
            return
        end

        StreamBanner( c );
    end );