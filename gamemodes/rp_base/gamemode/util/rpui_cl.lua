-- "gamemodes\\rp_base\\gamemode\\util\\rpui_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = FindMetaTable("Panel")
PANEL.OldSetTooltip = PANEL.OldSetTooltip or PANEL.SetTooltip

function PANEL:SetTooltip(str)
	self:SetTooltipPanelOverride("rpui.Tooltip")
	self:OldSetTooltip(str)
end

OldVguiRegister = OldVguiRegister or vgui.Register

local Col = Color
local Frame_Time = FrameTime
local math_Approach = math.Approach
local pairs_ = pairs
local ColAlpha = ColorAlpha
local math_sin = math.sin
local CurrentTime = CurTime

local base_cache_Color, text_cache_Color = Col(0,0,0,0), Col(0,0,0,0);
local STYLE_SOLID, STYLE_BLANKSOLID, STYLE_TRANSPARENT_SELECTABLE, STYLE_ERROR = 0, 1, 2, 3;

vgui.Register = function(a, b, c) -- принудительное добавление rpui функций в таблицу панели при регистрации нового vgui

	b.UIColors = rp.cfg.UIColor or b.UIColors or rp.cfg.UIColors

	b.GetPaintStyle = function(element, style)
	    style = style or STYLE_SOLID;

	    local baseColor, textColor = base_cache_Color, text_cache_Color
	    local animspeed            = 768 * Frame_Time();

	    if style == STYLE_SOLID then
	        element._grayscale = math_Approach(
	            element._grayscale or 0,
	            (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1),
	            animspeed
	        );

	        local invGrayscale = 255 - element._grayscale;
	        baseColor = Col( element._grayscale, element._grayscale, element._grayscale );
	        textColor = Col( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_BLANKSOLID then
	        element._grayscale = math_Approach(
	            element._alpha or 0,
	            (element:IsHovered() and 0 or 255),
	            animspeed
	        );

	        element._alpha = math_Approach(
	            element._alpha or 0,
	            (element:IsHovered() and 255 or 0),
	            animspeed
	        );

	        local invGrayscale = 255 - element._grayscale;
	        baseColor = Col( element._grayscale, element._grayscale, element._grayscale, element._alpha );
	        textColor = Col( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_TRANSPARENT_SELECTABLE then
	        element._grayscale = math_Approach(
	            element._grayscale or 0,
	            (element.Selected and 255 or 0),
	            animspeed
	        );
	        
	        if element.Selected then
	            element._alpha = math_Approach( element._alpha or 0, 255, animspeed );
	        else
	            element._alpha = math_Approach( element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed );
	        end

	        local invGrayscale = 255 - element._grayscale;
	        --
	        local cfg_col = table.Copy(rp.cfg.UIColor and rp.cfg.UIColor.Selected or rpui.UIColors.White)
	        local mult = element._grayscale
	        for k, v in pairs_(cfg_col) do
	            cfg_col[k] = (v/255)*mult
	        end
	        --
	        baseColor = ColAlpha(cfg_col, element._alpha)--Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
	        textColor = Col( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_ERROR then
	        baseColor = Col( 150 + math_sin(CurrentTime() * 1.5) * 70, 0, 0 );
	        textColor = PANEL.UIColors.White;
	    end

	    return baseColor, textColor;
	end

	OldVguiRegister(a, b, c)
end

local Panel = FindMetaTable("Panel")

function Panel:CenterX(fraction)
    fraction = fraction or 0.5
    self.X = self:GetParent():GetWide() * fraction - self:GetWide() * fraction
end

function Panel:CenterY(fraction)
    fraction = fraction or 0.5
    self.Y = self:GetParent():GetTall() * fraction - self:GetTall() * fraction
end

function draw.LineBetweenPanels(from, to, size)
	local from_x, from_y = from.X + from:GetWide()*0.5, from.Y + from:GetTall()*0.5
	local to_x, to_y = to.X + to:GetWide()*0.5, to.Y + to:GetTall()*0.5
	
	surface.DrawWideLine(from_x, from_y, to_x, to_y, size)
end

function surface.DrawWideLine(x1, y1, x2, y2, width)
    local angle = math.atan2(y2 - y1, x2 - x1) - math.pi / 2;
    local offset_x, offset_y = width * math.cos(angle), width * math.sin(angle)

    surface.DrawPoly({
        {x = x1 + offset_x, y = y1 + offset_y},
        {x = x2 + offset_x, y = y2 + offset_y},
        {x = x2 - offset_x, y = y2 - offset_y},
        {x = x1 - offset_x, y = y1 - offset_y},
    })
end