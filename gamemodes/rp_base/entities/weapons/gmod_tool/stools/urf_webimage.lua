-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\urf_webimage.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category    = "Roleplay";
TOOL.Name        = translates.Get("Веб-изображение");
TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
    { name = "reload" },
};

TOOL.IsWebImageTool             = true;

local isvalidurl                = false;
local maxpixels                 = 2048 * 2048;
TOOL.MaxImagePixels             = maxpixels;

TOOL.ClientConVar["url"]        = "https://urf.im/static/img/l-white.png";

TOOL.ClientConVar["w"]          = "1";
TOOL.ClientConVar["h"]          = "1";

TOOL.ClientConVar["alphatest"]  = "0";
TOOL.ClientConVar["additive"]   = "0";
TOOL.ClientConVar["nocull"]     = "0";
TOOL.ClientConVar["mirrorback"] = "0";

TOOL.ClientConVar["r"]          = "255";
TOOL.ClientConVar["g"]          = "255";
TOOL.ClientConVar["b"]          = "255";
TOOL.ClientConVar["a"]          = "255";

cleanup.Register( TOOL.Name );

local TOOL_Translations;
TOOL_Translations = {
    loading    = translates.Get("Дождитесь загрузки веб-изображения."),
    toomanypxl = translates.Get("Размер вашего веб-изображения слишком большой."),
};

if CLIENT then
    TOOL_Translations["name"]              = language.Add( "tool.urf_webimage.name", TOOL.Name );
    TOOL_Translations["desc"]              = language.Add( "tool.urf_webimage.desc", translates.Get("Позволяет вам создать изображение из интернета" ) );
    TOOL_Translations["left"]              = language.Add( "tool.urf_webimage.left", translates.Get("Создать веб-изображение" ) );
    TOOL_Translations["right"]             = language.Add( "tool.urf_webimage.right", translates.Get("Обновить веб-изображение" ) );
    TOOL_Translations["reload"]            = language.Add( "tool.urf_webimage.reload", translates.Get("Скопировать параметры веб-изображения" ) );
    TOOL_Translations["URL"]               = translates.Get( "URL:" );
    TOOL_Translations["scalew"]            = translates.Get( "Размер по ширине:" );
    TOOL_Translations["scaleh"]            = translates.Get( "Размер по высоте:" );
    TOOL_Translations["alphatest"]         = translates.Get( "Улучшение полупрозрачных краев?" );
    TOOL_Translations["additive"]          = translates.Get( "Смешивание цвета (добавление)?" );
    TOOL_Translations["nocull"]            = translates.Get( "Отрисовывать обе стороны?" );
    TOOL_Translations["mirrorback"]        = translates.Get( "Отзеркалить заднюю сторону?" );
    TOOL_Translations["color"]             = translates.Get( "Цвет:" );
    TOOL_Translations["preview"]           = translates.Get( "Предпросмотр:" );
    TOOL_Translations["toomanypxl_cpanel"] = translates.Get( "Изображение слишком большое" );
    TOOL_Translations["notvalidurl"]       = translates.Get( "Недействительная ссылка" );
    TOOL_Translations["URLError"]          = translates.Get( "ОШИБКА: Недопустимая ссылка" );

    language.Add( "Undone." .. TOOL.Name, translates.Get("Веб-изображение убрано") );
	language.Add( "Undone_" .. TOOL.Name, translates.Get("Веб-изображение убрано") );

	language.Add( "Cleanup." .. TOOL.Name, translates.Get("Веб-изображения") );
	language.Add( "Cleanup_" .. TOOL.Name, translates.Get("Веб-изображения") );

	language.Add( "Cleaned." .. TOOL.Name, translates.Get("Все веб-изображения удалены!") );
	language.Add( "Cleaned_" .. TOOL.Name, translates.Get("Все веб-изображения удалены!") );

	language.Add( "SBoxLimit." .. "webimages", translates.Get("Вы достигли лимита веб-изображений!") );
	language.Add( "SBoxLimit_" .. "webimages", translates.Get("Вы достигли лимита веб-изображений!") );

	cvar.Register( "enable_webimage_render" )
        :AddMetadata( "State", "RPMenu" )
        :AddMetadata( "Menu", translates.Get("Включить отображение веб-изображений") )
        :SetDefault( true )
end


if SERVER then
    util.AddNetworkString( "RequestWebImage" );

    if rp.GetLimit( "webimages" ) == 0 then
        rp.SetLimit( "webimages", 1 );
    end

    function MakeWebImage( origin, angles, url, w, h, color, renderflags )
        local webimage = ents.Create( "ent_urfim_webimage" );

        webimage:SetPos( origin );
        webimage:SetAngles( angles );
        webimage:SetColor( color );

        webimage:SetURL( url );

        webimage:SetScaleWidth( w );
        webimage:SetScaleHeight( h );

        webimage:SetRenderFlags( renderflags );

        webimage:Spawn();

        return webimage;
    end

    function TOOL:MakeWebImage( tr )
        local ply = self:GetOwner();

        if (not ply:IsRoot()) and (not self:GetWeapon():CheckLimit("webimages")) then return false end

        local origin = tr.HitPos + tr.HitNormal * 2;

        local angles = tr.HitNormal:Angle();
            angles:RotateAroundAxis( angles:Up(), 90 );
            angles:RotateAroundAxis( angles:Forward(), 90 );

        local scaling_w, scaling_h = tonumber(self:GetClientNumber("w") or 1), tonumber(self:GetClientNumber("h") or 1);

        local webimage = MakeWebImage(
            origin,
            angles,
            tostring( self:GetClientInfo("url") or "https://urf.im/static/img/l-white.png" ),
            ply:IsRoot() and scaling_w or math.Clamp( scaling_w, 0.25, 2 ),
            ply:IsRoot() and scaling_h or math.Clamp( scaling_h, 0.25, 2 ),
            Color(
                math.Clamp( tonumber(self:GetClientNumber("r") or 255), 0, 255 ),
                math.Clamp( tonumber(self:GetClientNumber("g") or 255), 0, 255 ),
                math.Clamp( tonumber(self:GetClientNumber("b") or 255), 0, 255 ),
                math.Clamp( tonumber(self:GetClientNumber("a") or 255), 0, 255 )
            ),
            bit.bor(
                tobool( self:GetClientNumber("alphatest") )  and WEBIMAGE_RENDERFLAG_ALPHATEST or 0,
                tobool( self:GetClientNumber("additive") )   and WEBIMAGE_RENDERFLAG_ADDITIVE or 0,
                tobool( self:GetClientNumber("nocull") )     and WEBIMAGE_RENDERFLAG_NOCULL or 0,
                tobool( self:GetClientNumber("mirrorback") ) and WEBIMAGE_RENDERFLAG_MIRRORBACK or 0
            )
        );

        webimage.ItemOwner = ply;

        undo.Create( self.Name );
            undo.AddEntity( webimage );
            undo.SetPlayer( webimage.ItemOwner );
        undo.Finish();

        webimage.ItemOwner:AddCount( "webimages", webimage );
        webimage.ItemOwner:AddCleanup( self.Name, webimage );
    end

    function TOOL:UpdateWebImage( tr )
        local ply = self:GetOwner();

        local webimage = tr.Entity;
        if webimage:GetClass() ~= "ent_urfim_webimage" then return end

        if (not ply:IsRoot()) and (webimage.ItemOwner ~= ply) then
            return
        end

        webimage:SetColor( Color(
            math.Clamp( tonumber(self:GetClientNumber("r") or 255), 0, 255 ),
            math.Clamp( tonumber(self:GetClientNumber("g") or 255), 0, 255 ),
            math.Clamp( tonumber(self:GetClientNumber("b") or 255), 0, 255 ),
            math.Clamp( tonumber(self:GetClientNumber("a") or 255), 0, 255 )
        ) );

        webimage:SetURL( self:GetClientInfo("url") );

        local scaling_w, scaling_h = tonumber(self:GetClientNumber("w") or 1), tonumber(self:GetClientNumber("h") or 1);
        webimage:SetScaleWidth( ply:IsRoot() and scaling_w or math.Clamp(scaling_w, 0.25, 2) );
        webimage:SetScaleHeight( ply:IsRoot() and scaling_h or math.Clamp(scaling_h, 0.25, 2) );

        webimage:SetRenderFlags( bit.bor(
            tobool( self:GetClientNumber("alphatest") )  and WEBIMAGE_RENDERFLAG_ALPHATEST or 0,
            tobool( self:GetClientNumber("additive") )   and WEBIMAGE_RENDERFLAG_ADDITIVE or 0,
            tobool( self:GetClientNumber("nocull") )     and WEBIMAGE_RENDERFLAG_NOCULL or 0,
            tobool( self:GetClientNumber("mirrorback") ) and WEBIMAGE_RENDERFLAG_MIRRORBACK or 0
        ) );

        webimage:SetUpdate( true );

        return true
    end

    net.Receive( "RequestWebImage", function( len, ply )
        local tool, pixels, update = ply:GetTool(net.ReadString()), net.ReadUInt(32), net.ReadBool();

        if not tool then return end
        if not tool.IsWebImageTool then return end

        local owner = tool:GetOwner();
        if owner ~= ply then return end

        if pixels > tool.MaxImagePixels then
            rp.Notify( ply, NOTIFY_ERROR, TOOL_Translations.toomanypxl );
            return
        end

        tool[update and "UpdateWebImage" or "MakeWebImage"]( tool, owner:GetEyeTraceNoCursor() );
    end );
end

function TOOL:LeftClick( tr, update )
    if CLIENT and IsFirstTimePredicted() then
        if not isvalidurl then
            rp.Notify( NOTIFY_ERROR, TOOL_Translations.notvalidurl );
            return
        end

        local mat = rp.WebMat:Get( GetConVar("urf_webimage_url"):GetString(), true );

        if not mat then
            rp.Notify( NOTIFY_GENERIC, TOOL_Translations.loading );
            return
        end

        net.Start( "RequestWebImage" );
            net.WriteString( self:GetMode() );
            net.WriteUInt( mat:Width() * mat:Height(), 32 );
        net.SendToServer();
    end

    return true
end

function TOOL:RightClick( tr )
    if CLIENT and IsFirstTimePredicted() then
        local webdecal = tr.Entity;

        if webdecal.IsWebImage then
            if not isvalidurl then
                rp.Notify( NOTIFY_ERROR, TOOL_Translations.notvalidurl );
                return
            end

            local mat = rp.WebMat:Get( GetConVar("urf_webimage_url"):GetString(), true );

            if not mat then
                rp.Notify( LocalPlayer(), NOTIFY_GENERIC, TOOL_Translations.loading );
                return
            end

            net.Start( "RequestWebImage" );
                net.WriteString( self:GetMode() );
                net.WriteUInt( mat:Width() * mat:Height(), 32 );
                net.WriteBool( true );
            net.SendToServer();

            return true
        end
    end
end


function TOOL:Reload( tr )
    if CLIENT and IsFirstTimePredicted() then
        local webdecal = tr.Entity;
        if webdecal:GetClass() ~= "ent_urfim_webimage" then return end

        GetConVar( "urf_webimage_url" ):SetString( webdecal:GetURL() );

        GetConVar( "urf_webimage_w" ):SetFloat( webdecal:GetScaleWidth() );
        GetConVar( "urf_webimage_h" ):SetFloat( webdecal:GetScaleHeight() );

        local webdecal_color = webdecal:GetColor();
        GetConVar( "urf_webimage_r" ):SetFloat( webdecal_color.r );
        GetConVar( "urf_webimage_g" ):SetFloat( webdecal_color.g );
        GetConVar( "urf_webimage_b" ):SetFloat( webdecal_color.b );
        GetConVar( "urf_webimage_a" ):SetFloat( webdecal_color.a );

        GetConVar( "urf_webimage_alphatest" ):SetBool( webdecal:HasRenderFlag(WEBIMAGE_RENDERFLAG_ALPHATEST) );
        GetConVar( "urf_webimage_additive" ):SetBool( webdecal:HasRenderFlag(WEBIMAGE_RENDERFLAG_ADDITIVE) );
        GetConVar( "urf_webimage_nocull" ):SetBool( webdecal:HasRenderFlag(WEBIMAGE_RENDERFLAG_NOCULL) );
        GetConVar( "urf_webimage_mirrorback" ):SetBool( webdecal:HasRenderFlag(WEBIMAGE_RENDERFLAG_MIRRORBACK) );

        return true
    end
end


local ConVarsDefault = TOOL:BuildConVarList();
function TOOL.BuildCPanel( CPanel )
    local error_icon = Material( "icon16/error.png" );

    CPanel:AddControl( "ComboBox", {
        MenuButton = 1,
        Folder     = "webimage",
        Options    = { [ "#preset.default" ] = ConVarsDefault },
        CVars      = table.GetKeys( ConVarsDefault )
    } );

    local userinput = CPanel:AddControl( "textbox", {
        Label   = TOOL_Translations.URL,
        Command = "urf_webimage_url"
    } );

    local err = CPanel:AddControl( "label", { Text = TOOL_Translations.URLError } );
    err:SetTextColor( Color(255, 0, 0) );
    err.Think = function( this )
        local val = userinput:GetValue();

        if not rp.WebMat:IsValidURL( val ) then
            if isvalidurl then
                isvalidurl = false;
                this:SizeToContentsY();
            end

            return
        end

        if not isvalidurl then
            isvalidurl = true;
            this:SetTall( 0 );
        end
    end

    CPanel:AddControl( "slider", {
        Type    = "float",
        Label   = TOOL_Translations.scalew,
        Command = "urf_webimage_w",
        Min     = 0.25,
        max     = 2
    } );

    CPanel:AddControl( "slider", {
        Type    = "float",
        Label   = TOOL_Translations.scaleh,
        Command = "urf_webimage_h",
        Min     = 0.25,
        Max     = 2
    } );

    CPanel:AddControl( "checkbox", {
        Label   = TOOL_Translations.alphatest,
        Command = "urf_webimage_alphatest"
    } );

    CPanel:AddControl( "checkbox", {
        Label   = TOOL_Translations.additive,
        Command = "urf_webimage_additive"
    } );

    CPanel:AddControl( "checkbox", {
        Label   = TOOL_Translations.nocull,
        Command = "urf_webimage_nocull"
    } );

    CPanel:AddControl( "checkbox", {
        Label   = TOOL_Translations.mirrorback,
        Command = "urf_webimage_mirrorback"
    } );

    CPanel:AddControl( "color", {
        Label = TOOL_Translations.color,
        Red   = "urf_webimage_r",
        Green = "urf_webimage_g",
        Blue  = "urf_webimage_b",
        Alpha = "urf_webimage_a"
    } );

    CPanel.PreviewPanel = vgui.Create( "DPanel" );
    CPanel.PreviewPanel:SetBackgroundColor( Color(50,50,50) );
    CPanel.PreviewPanel.PaintOver = function( this, w, h )
        if w ~= h then this:SetTall( w ); end

        -- Texture:
        local mat = rp.WebMat:Get( GetConVar("urf_webimage_url"):GetString() );

        local pixels = mat:Width() * mat:Height();
        local mat_w, mat_h = mat:Width() * GetConVar("urf_webimage_w"):GetFloat(), mat:Height() * GetConVar("urf_webimage_h"):GetFloat();

        local mat_ratio_w = mat_w / mat_h;
        local mat_ratio_h = mat_h / mat_w;

        local pw, ph;
        local ps = h * 0.65;

        if mat_ratio_w < mat_ratio_h then
            pw, ph = ps * mat_ratio_w, ps;
        else
            pw, ph = ps, ps * mat_ratio_h;
        end

        if GetConVar( "urf_webimage_additive" ):GetBool() then
            surface.SetDrawColor( Color(255,255,255,16) );
            surface.SetMaterial( Material("gui/colors_light.png") );
            surface.DrawTexturedRect( 0, 0, w, h );

            render.OverrideBlend( true, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD );
            this.BlendOverride = true;
        end

        surface.SetDrawColor( Color(
            GetConVar( "urf_webimage_r" ):GetInt(),
            GetConVar( "urf_webimage_g" ):GetInt(),
            GetConVar( "urf_webimage_b" ):GetInt(),
            GetConVar( "urf_webimage_a" ):GetInt()
        ) );
        surface.SetMaterial( mat );
        surface.DrawTexturedRect(
            w * 0.5 - pw * 0.5,
            h * 0.5 - ph * 0.5,
            pw, ph
        );

        if this.BlendOverride then
            render.OverrideBlend( false );
        end

        surface.SetDrawColor( Color(255,255,255,10) );
        surface.DrawOutlinedRect(
            w * 0.5 - pw * 0.5,
            h * 0.5 - ph * 0.5,
            pw, ph
        );

        -- Header:
        if not this.th then
            this.tw, this.th = draw.SimpleText( TOOL_Translations.preview, "DebugFixedSmall", w - 5, 5, Color(255,255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
        end

        surface.SetDrawColor( Color( 0, 0, 0, 200 ) );
        surface.DrawRect( 0, 0, w, this.th+10 );

        draw.SimpleText( TOOL_Translations.preview, "DebugFixedSmall", w - 5, 5, Color(255,255,255,127), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );

        if pixels > maxpixels then
            surface.SetDrawColor( color_white );
            surface.SetMaterial( error_icon );
            surface.DrawTexturedRect( 5, h - 5 - 16, 16, 16 );

            draw.SimpleText( TOOL_Translations.toomanypxl_cpanel, "DebugFixedSmall", 5 + 16 + 5, h - 5, Color(255,255,255,127), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
        end
    end

    CPanel:AddItem( CPanel.PreviewPanel );
end


function TOOL:DrawToolScreen( w, h )
    render.Clear( 50, 50, 50, 255, true, true );

    -- Texture:
    local blendoverride = false;
    local mat = rp.WebMat:Get( GetConVar("urf_webimage_url"):GetString() );
    local mat_w, mat_h = mat:Width() * GetConVar("urf_webimage_w"):GetFloat(), mat:Height() * GetConVar("urf_webimage_h"):GetFloat();

    local mat_ratio_w = mat_w / mat_h;
    local mat_ratio_h = mat_h / mat_w;

    local pw, ph;
    local ps = h * 0.65;

    if mat_ratio_w < mat_ratio_h then
        pw, ph = ps * mat_ratio_w, ps;
    else
        pw, ph = ps, ps * mat_ratio_h;
    end

    if GetConVar( "urf_webimage_additive" ):GetBool() then
        surface.SetDrawColor( Color(255,255,255,16) );
        surface.SetMaterial( Material("gui/colors_light.png") );
        surface.DrawTexturedRect( 0, 0, w, h );

        render.OverrideBlend( true, BLEND_SRC_ALPHA, BLEND_ONE, BLENDFUNC_ADD );
        blendoverride = true;
    end

    surface.SetDrawColor( Color(
        GetConVar( "urf_webimage_r" ):GetInt(),
        GetConVar( "urf_webimage_g" ):GetInt(),
        GetConVar( "urf_webimage_b" ):GetInt(),
        GetConVar( "urf_webimage_a" ):GetInt()
    ) );
    surface.SetMaterial( mat );
    surface.DrawTexturedRect(
        w * 0.5 - pw * 0.5,
        h * 0.5 - ph * 0.5,
        pw, ph
    );

    if blendoverride then render.OverrideBlend( false ); end
end