-- "gamemodes\\darkrp\\gamemode\\libraries\\draw.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface, draw = surface, draw;
local color_white = Color(255,255,255);

draw.LegacyTextOutlined = draw.LegacyTextOutlined or draw.SimpleTextOutlined;

draw.SimpleText = function( text, font, x, y, color, xAlign, yAlign )
    text = tostring( text );
    font = font or "DermaDefault";
    x = x or 0;
    y = y or 0;
    color = color or color_white;
    xAlign = xAlign or TEXT_ALIGN_LEFT;
    yAlign = yAlign or TEXT_ALIGN_TOP;

    surface.SetFont( font );
    local w, h = surface.GetTextSize( text );

    if xAlign == TEXT_ALIGN_CENTER then
        x = x - w * 0.5;
    elseif xAlign == TEXT_ALIGN_RIGHT then
        x = x - w;
    end

    if yAlign == TEXT_ALIGN_CENTER then
        y = y - h * 0.5;
    elseif yAlign == TEXT_ALIGN_BOTTOM then
        y = y - h;
    end

    surface.SetTextPos( x, y );
    surface.SetTextColor( color.r, color.g, color.b, color.a );
    surface.DrawText( text );

    return w, h;
end

draw.SimpleTextOutlined = function( text, font, x, y, color, xAlign, yAlign, outlinewidth, outlinecolor )
    font = font or "DermaDefault";

    local outlinefont = font .. "Blur" .. outlinewidth;
    if not surface.RegistredFonts[outlinefont] then
        local fontData     = table.Copy(surface.RegistredFonts[font] or {});
        fontData.blursize  = (outlinewidth or 0) * 2;
        fontData.antialias = true;
        fontData.outline   = false;

        surface.CreateFont( outlinefont, fontData );
    end

    for i = 1, 3 do
        draw.SimpleText( text, outlinefont, x, y, outlinecolor, xAlign, yAlign );
        draw.SimpleText( text, outlinefont, x, y, outlinecolor, xAlign, yAlign );
    end

    return draw.SimpleText( text, font, x, y, color, xAlign, yAlign );
end