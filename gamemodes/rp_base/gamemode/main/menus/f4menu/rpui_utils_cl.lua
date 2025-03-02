rpui = rpui or {};


rpui.EnableUIRedesign = rpui.EnableUIRedesign or (rp.cfg.EnableUIRedesign or false);
rpui.DebugMode        = rpui.DebugMode        or false;

rpui.EnableFactionGroupsUI = rp.cfg.EnableFactionGroupsUI and rp.cfg.EnableFactionGroupsUI or false;


rpui.cvars = rpui.cvars or {};

rpui.cvars.Enable = CreateClientConVar( "rpui_enable", (rpui.EnableUIRedesign and "1" or "0"), false );
rpui.cvars.Enable.SetBool( rpui.cvars.Enable, rpui.EnableUIRedesign );
cvars.AddChangeCallback( rpui.cvars.Enable.GetName(rpui.cvars.Enable), function( cvar, old, new )
    rpui.EnableUIRedesign = (tonumber(new) or 0) > 0;
end );

rpui.cvars.DebugMode = CreateClientConVar( "~rpui_debugmode", (rpui.DebugMode and "1" or "0"), false );
rpui.cvars.DebugMode.SetBool( rpui.cvars.DebugMode, rpui.DebugMode );
cvars.AddChangeCallback( rpui.cvars.DebugMode.GetName(rpui.cvars.DebugMode), function( cvar, old, new )
    rpui.DebugMode = (tonumber(new) or 0) > 0;
end );


rpui.UIColors = {
    Blank      = Color( 0, 0, 0, 0 ),
    
    White      = Color( 255, 255, 255, 255 ),
    Black      = Color( 0, 0, 0, 255 ),
    Pink       = Color( 250, 30, 78, 255 ),

    Tooltip    = Color( 0, 0, 0, 242 ),

    Active     = Color( 255, 255, 255, 255 ),
    Background = Color( 0, 0, 0, 127 ),
    Hovered    = Color( 0, 0, 0, 180 ),

    WhiteHighlight = Color( 255, 255, 255, 8 ),
    Shading        = Color( 0, 12, 24, 74 ),

    BackgroundGold = Color( 255, 110, 0, 255 ),
    TextGold       = Color( 255, 155, 0, 255 ),
    Gold           = Color( 255, 185, 0, 255 ),

    BackgroundDonateBuyed = Color( 39, 174, 96, 255 ),
    DonateBuyed           = Color( 46, 204, 113, 255 ),

    BackgroundDonateDisabled = Color( 192, 57, 43, 255 ),
    DonateDisabled           = Color( 231, 76, 60, 255 ),
};


rpui.GradientMat     = Material( "gui/gradient" );
rpui.GradientDownMat = Material( "gui/gradient_down" );
rpui.GradientUpMat   = Material( "gui/gradient_up" );


rpui.PowOfTwo = function( n )
    n = math.floor(n);
    return (n % 2 == 0) and n or n + 1;  
end


rpui.BakeCircle = function( x, y, size, seg )
    size = size * 0.5;

    local cir = {};

    table.insert( cir, { x = x + size, y = y + size } );

    for i = 0, seg do
        local a = math.rad( (i/seg) * -360 );

        table.insert( cir, {
            x = x + math.sin(a) * size + size,
            y = y + math.cos(a) * size + size,
        } );
    end

    local a = math.rad( 0 );
    table.insert( cir, {
        x = x + math.sin( a ) * size + size,
        y = y + math.cos( a ) * size + size,
    } );

    return cir;
end


rpui.BakeText = function( text, font, w, h )
    local BakedText       = {};
    local BakedTextHeight = 0;

    local x, y = 0, 0;

    surface.SetFont( font );
    local space, font_height = surface.GetTextSize(" ");

    local text_data = string.Explode( " ", text );
    for kstr, str in pairs( text_data ) do
        local strW, strH = surface.GetTextSize(str);

        if (x + strW) > w then
            x = 0;
            if not (#text_data == 1) then y = y + font_height; end
        end

        table.insert( BakedText, { text = str, x = x, y = y, w = strW, h = strH } );
        x = x + strW + space;

        BakedTextHeight = math.max( BakedTextHeight, y + font_height );
    end

    return BakedText, BakedTextHeight;
end


STYLE_SOLID                           = 0;
STYLE_BLANKSOLID                      = 1;
STYLE_TRANSPARENT_SELECTABLE          = 2;
STYLE_ERROR                           = 3;
STYLE_SOLID_INVERTED                  = 4;
STYLE_TRANSPARENT                     = 5;
STYLE_TRANSPARENT_INVERTED            = 6;
STYLE_TRANSPARENT_SELECTABLE_INVERTED = 7;
STYLE_GOLDEN                          = 8;
STYLE_GOLDEN_TRANSPARENT              = 9;

local Color = Color

rpui.GetPaintStyle = function( element, style )
    style = style or STYLE_SOLID;

    local baseColor, textColor = Color(0,0,0,0), Color(0,0,0,0);
    local animspeed            = 768 * FrameTime();

    if style == STYLE_SOLID then
        element._grayscale = math.Approach(
            element._grayscale or 0,
            (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1),
            animspeed
        );

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_BLANKSOLID then
        element._grayscale = math.Approach(
            element._alpha or 0,
            (element:IsHovered() and 0 or 255),
            animspeed
        );

        element._alpha = math.Approach(
            element._alpha or 0,
            (element:IsHovered() and 255 or 0),
            animspeed
        );

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_TRANSPARENT_SELECTABLE then
        element._grayscale = math.Approach(
            element._grayscale or 0,
            (element.Selected and 255 or 0),
            animspeed
        );
        
        if element.Selected then
            element._alpha = math.Approach( element._alpha or 0, 255, animspeed );
        else
            element._alpha = math.Approach( element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed );
        end

        local c_ = rp.cfg.UIColor.Selected
        local scale_ = element._grayscale/255
        baseColor = Color(c_.r * scale_, c_.g * scale_, c_.b * scale_, element._alpha)
        local invGrayscale = 255 - element._grayscale;
        --baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_ERROR then
        baseColor = Color( 150 + math.sin(CurTime() * 1.5) * 70, 0, 0 );
        textColor = rpui.UIColors.White;
    elseif style == STYLE_SOLID_INVERTED then
        element._grayscale = math.Approach(
            element._grayscale or 0,
            (element:IsHovered() and 0 or 255) * (element:GetDisabled() and 0 or 1),
            animspeed
        );

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_TRANSPARENT then
        element._grayscale = 0;
        element._alpha     = math.Approach( element._alpha or 0, (element:IsHovered() and 255 or 146), animspeed );

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_TRANSPARENT_INVERTED then
        element._grayscale = math.Approach(
            element._grayscale or 0,
            (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1),
            animspeed
        );

        element._alpha = math.Approach( element._alpha or 0, (element:IsHovered() and (element:GetDisabled() and 146 or 255) or 146), animspeed );

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale, element:GetDisabled() and 78 or 255 );
    elseif style == STYLE_TRANSPARENT_SELECTABLE_INVERTED then
        element._grayscale = 0;
        
        if element.Selected then
            element._alpha = math.Approach( element._alpha or 0, 255, animspeed );
        else
            element._alpha = math.Approach( element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed );
        end

        local invGrayscale = 255 - element._grayscale;
        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
    elseif style == STYLE_GOLDEN then
        element._alpha = math.Approach( element._alpha or 0, (element:IsHovered() or element.Selected) and 255 or 0, animspeed );
        
        local vecClrGold  = Vector(rpui.UIColors.BackgroundGold.r,rpui.UIColors.BackgroundGold.g,rpui.UIColors.BackgroundGold.b);
        local vecClrBlack = Vector(0,0,0);
        
        local vecTextColor = Lerp( animspeed, element._veccolor or vecClrBlack, element:IsHovered() and vecClrBlack or vecClrGold );

        textColor = Color( vecTextColor.x, vecTextColor.y, vecTextColor.z );
    end

    return baseColor, textColor;
end


rpui.DrawStencilBorder = function( this, x, y, w, h, t, bottom_clr, top_clr, alpha )
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
    surface.DrawRect( 0, 0, w, bs );
    surface.DrawRect( 0, h - bs, w, bs );
    surface.DrawRect( 0, 0, bs, h );
    surface.DrawRect( w - bs, 0, bs, h );

    render.SetStencilCompareFunction( STENCIL_EQUAL );
    render.SetStencilFailOperation( STENCIL_KEEP );
    
    surface.SetAlphaMultiplier( alpha or 1 );
        surface.SetDrawColor( bottom_clr );
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( top_clr );
        surface.SetMaterial( rpui.GradientMat );
        surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, ds, ds, (this.rotAngle or 0) );
    surface.SetAlphaMultiplier( 1 );

    render.SetStencilEnable( false );
end

rpui.ExperimentalStencil = function(Function)
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

    if (isfunction(Function)) then Function(); end

    render.SetStencilEnable( false );
end

local Ceil = math.ceil
local newx, newy

-- 0 < min <= 1
rpui.AdaptToScreen = function(x, y, mins, scalex, scaley)
    x, y = (x or 0), (y or 0)
    mins = (istable(mins) and mins) or {isnumber(mins) and mins or .5, .5}
    scalex, scaley = (scalex or 1920), (scaley or 1080)
    newx, newy = x * (ScrW() / scalex), y * (ScrH() / scaley)

    return {
        newx < (x * mins[1]) and (x * mins[1]) or newx,
        newy < (y * mins[2]) and (y * mins[2]) or newy
    }
end