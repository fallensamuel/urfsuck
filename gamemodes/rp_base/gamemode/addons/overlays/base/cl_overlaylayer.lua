-- "gamemodes\\rp_base\\gamemode\\addons\\overlays\\base\\cl_overlaylayer.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SysTime, unpack, setmetatable, TypeID = SysTime, unpack, setmetatable, TypeID;
local surface_SetAlphaMultiplier, surface_SetDrawColor, surface_SetMaterial, surface_DrawTexturedRectRotated = surface.SetAlphaMultiplier, surface.SetDrawColor, surface.SetMaterial, surface.DrawTexturedRectRotated;
//local DrawColorModify, DrawSharpen, DrawMotionBlur, DrawBloom = DrawColorModify, DrawSharpen, DrawMotionBlur, DrawBloom;

rp.overlays.OverlayLayer = rp.overlays.OverlayLayer or {};

local OverlayLayer = rp.overlays.OverlayLayer;
OverlayLayer.__index = OverlayLayer;
OverlayLayer.__list = {};

OverlayLayer.Create = function( this, name )
    name = name or SysTime();
    if not OverlayLayer.__list[name] then
        local c_OverlayLayer = {};

        setmetatable( c_OverlayLayer, OverlayLayer );
        OverlayLayer.__list[name] = c_OverlayLayer;
    end

    return OverlayLayer.__list[name];
end

function OverlayLayer:Render( o, w, h )
    local dFadeDelta = o.dFade and 1 - o.FadeDelta or o.FadeDelta;
    local overlayFade = (o.IsFading and dFadeDelta or 1);

    if o.IsFading then
        surface_SetAlphaMultiplier( dFadeDelta );
    end

    if self.Pulse then
        local r, a = unpack( self.Pulse );
        self.PulseOut = (1 - a) + math.sin( CurTime() * r ) * a;
        surface_SetAlphaMultiplier( overlayFade * self.PulseOut );
    end

    if self.Opacity then
        surface_SetAlphaMultiplier( overlayFade * ((TypeID(self.Opacity) == TYPE_FUNCTION) and self:Opacity() or self.Opacity) * (self.PulseOut or 1) );
    end

    if self.Color then
        surface_SetDrawColor( (TypeID(self.Color) == TYPE_FUNCTION) and self:Color() or self.Color );
    else
        surface_SetDrawColor( color_white );
    end

    if self.Material then
        surface_SetMaterial( (TypeID(self.Material) == TYPE_FUNCTION) and self:Material() or self.Material );
        
        local _x, _y, _w, _h;

        if TypeID(self.Position) == TYPE_FUNCTION then
            _x, _y = self:Position();
        else
            _x, _y = self.Position[1] or 0.5, self.Position[2] or 0.5;
        end

        if TypeID(self.Scale) == TYPE_FUNCTION then
            _w, _h = self:Scale();
        else
            _w, _h = self.Scale[1] or 1, self.Scale[2] or 1;
        end

        surface_DrawTexturedRectRotated( _x * w, _y * h, w * _w, h * _h, 0 );
    end

    if self.Opacity then
        surface_SetAlphaMultiplier( overlayFade * ( self.PulseOut or 1 ) );
    end
    
    if self.ColorMod then
        if TypeID(self.ColorMod) == TYPE_FUNCTION then
            local ColorModRef = self:ColorMod();

            self.ColorModOut["$pp_colour_addr"]       = ColorModRef["$pp_colour_addr"]       or 0;
            self.ColorModOut["$pp_colour_addg"]       = ColorModRef["$pp_colour_addg"]       or 0;
            self.ColorModOut["$pp_colour_addb"]       = ColorModRef["$pp_colour_addb"]       or 0;
            self.ColorModOut["$pp_colour_brightness"] = ColorModRef["$pp_colour_brightness"] or 0;
            self.ColorModOut["$pp_colour_contrast"]   = ColorModRef["$pp_colour_contrast"]   or 1;
            self.ColorModOut["$pp_colour_colour"]     = ColorModRef["$pp_colour_colour"]     or 1;
            self.ColorModOut["$pp_colour_mulr"]       = ColorModRef["$pp_colour_mulr"]       or 0;
            self.ColorModOut["$pp_colour_mulg"]       = ColorModRef["$pp_colour_mulg"]       or 0;
            self.ColorModOut["$pp_colour_mulb"]       = ColorModRef["$pp_colour_mulb"]       or 0;
        else
            self.ColorModOut["$pp_colour_addr"]       = self.ColorMod["$pp_colour_addr"]       or 0;
            self.ColorModOut["$pp_colour_addg"]       = self.ColorMod["$pp_colour_addg"]       or 0;
            self.ColorModOut["$pp_colour_addb"]       = self.ColorMod["$pp_colour_addb"]       or 0;
            self.ColorModOut["$pp_colour_brightness"] = self.ColorMod["$pp_colour_brightness"] or 0;
            self.ColorModOut["$pp_colour_contrast"]   = self.ColorMod["$pp_colour_contrast"]   or 1;
            self.ColorModOut["$pp_colour_colour"]     = self.ColorMod["$pp_colour_colour"]     or 1;
            self.ColorModOut["$pp_colour_mulr"]       = self.ColorMod["$pp_colour_mulr"]       or 0;
            self.ColorModOut["$pp_colour_mulg"]       = self.ColorMod["$pp_colour_mulg"]       or 0;
            self.ColorModOut["$pp_colour_mulb"]       = self.ColorMod["$pp_colour_mulb"]       or 0;
        end

        if self.Pulse then
            self.ColorModOut["$pp_colour_addr"]       = self.ColorModOut["$pp_colour_addr"] * self.PulseOut;
            self.ColorModOut["$pp_colour_addg"]       = self.ColorModOut["$pp_colour_addg"] * self.PulseOut;
            self.ColorModOut["$pp_colour_addb"]       = self.ColorModOut["$pp_colour_addb"] * self.PulseOut;
            self.ColorModOut["$pp_colour_brightness"] = self.ColorModOut["$pp_colour_brightness"] * self.PulseOut;
            self.ColorModOut["$pp_colour_contrast"]   = (1 - self.PulseOut) + self.ColorModOut["$pp_colour_contrast"] * self.PulseOut;
            self.ColorModOut["$pp_colour_colour"]     = (1 - self.PulseOut) + self.ColorModOut["$pp_colour_colour"] * self.PulseOut;
            self.ColorModOut["$pp_colour_mulr"]       = self.ColorModOut["$pp_colour_mulr"] * self.PulseOut;
            self.ColorModOut["$pp_colour_mulg"]       = self.ColorModOut["$pp_colour_mulg"] * self.PulseOut;
            self.ColorModOut["$pp_colour_mulb"]       = self.ColorModOut["$pp_colour_mulb"] * self.PulseOut;
        end

        if o.IsFading then
            self.ColorModOut["$pp_colour_addr"]       = self.ColorModOut["$pp_colour_addr"] * overlayFade;
            self.ColorModOut["$pp_colour_addg"]       = self.ColorModOut["$pp_colour_addg"] * overlayFade;
            self.ColorModOut["$pp_colour_addb"]       = self.ColorModOut["$pp_colour_addb"] * overlayFade;
            self.ColorModOut["$pp_colour_brightness"] = self.ColorModOut["$pp_colour_brightness"] * overlayFade;
            self.ColorModOut["$pp_colour_contrast"]   = (1 - overlayFade) + self.ColorModOut["$pp_colour_contrast"] * overlayFade;
            self.ColorModOut["$pp_colour_colour"]     = (1 - overlayFade) + self.ColorModOut["$pp_colour_colour"] * overlayFade;
            self.ColorModOut["$pp_colour_mulr"]       = self.ColorModOut["$pp_colour_mulr"] * overlayFade;
            self.ColorModOut["$pp_colour_mulg"]       = self.ColorModOut["$pp_colour_mulg"] * overlayFade;
            self.ColorModOut["$pp_colour_mulb"]       = self.ColorModOut["$pp_colour_mulb"] * overlayFade;
        end

        DrawColorModify( self.ColorModOut );
    end

    if self.Sharpen then
        if TypeID(self.Sharpen) == TYPE_FUNCTION then
            local SharpenRef = self:Sharpen();

            self.SharpenOut.contrast = SharpenRef.contrast or 0;
            self.SharpenOut.distance = SharpenRef.distance or 0;
        else
            self.SharpenOut.contrast = self.Sharpen.contrast or 0;
            self.SharpenOut.distance = self.Sharpen.distance or 0;
        end
    
        if self.Pulse then
            self.SharpenOut.contrast = self.SharpenOut.contrast * self.PulseOut;
            self.SharpenOut.distance = self.SharpenOut.distance * self.PulseOut;
        end
    
        if o.IsFading then
            self.SharpenOut.contrast = self.SharpenOut.contrast * overlayFade;
            self.SharpenOut.distance = self.SharpenOut.distance * overlayFade;
        end
    
        DrawSharpen( self.SharpenOut.contrast, self.SharpenOut.distance );
    end

    if self.MotionBlur then
        if TypeID(self.MotionBlur) == TYPE_FUNCTION then
            local MotionBlurRef = self:MotionBlur();

            self.MotionBlurOut.addalpha  = MotionBlurRef.addalpha  or 0;
            self.MotionBlurOut.drawalpha = MotionBlurRef.drawalpha or 0;
            self.MotionBlurOut.delay     = MotionBlurRef.delay     or 0;
        else
            self.MotionBlurOut.addalpha  = self.MotionBlur.addalpha  or 0;
            self.MotionBlurOut.drawalpha = self.MotionBlur.drawalpha or 0;
            self.MotionBlurOut.delay     = self.MotionBlur.delay     or 0;
        end

        if self.Pulse then
            self.MotionBlurOut.addalpha  = self.MotionBlurOut.addalpha  * self.PulseOut;
            self.MotionBlurOut.drawalpha = self.MotionBlurOut.drawalpha * self.PulseOut;
            self.MotionBlurOut.delay     = self.MotionBlurOut.delay     * self.PulseOut;
        end

        if o.IsFading then
            self.MotionBlurOut.addalpha  = self.MotionBlurOut.addalpha  * overlayFade;
            self.MotionBlurOut.drawalpha = self.MotionBlurOut.drawalpha * overlayFade;
            self.MotionBlurOut.delay     = self.MotionBlurOut.delay     * overlayFade;
        end

        DrawMotionBlur( self.MotionBlurOut.addalpha, self.MotionBlurOut.drawalpha, self.MotionBlurOut.delay );
    end

    if self.Bloom then
        if TypeID(self.Bloom) == TYPE_FUNCTION then
            local BloomRef = self:Bloom();

            self.BloomOut.darken        = BloomRef.darken        or 0;
            self.BloomOut.multiply      = BloomRef.multiply      or 0;
            self.BloomOut.x             = BloomRef.x             or 0;
            self.BloomOut.y             = BloomRef.y             or 0;
            self.BloomOut.passes        = BloomRef.passes        or 0;
            self.BloomOut.colormultiply = BloomRef.colormultiply or 0;
            self.BloomOut.r             = BloomRef.r             or 1;
            self.BloomOut.g             = BloomRef.g             or 1;
            self.BloomOut.b             = BloomRef.b             or 1;
        else
            self.BloomOut.darken        = self.Bloom.darken        or 0;
            self.BloomOut.multiply      = self.Bloom.multiply      or 0;
            self.BloomOut.x             = self.Bloom.x             or 0;
            self.BloomOut.y             = self.Bloom.y             or 0;
            self.BloomOut.passes        = self.Bloom.passes        or 0;
            self.BloomOut.colormultiply = self.Bloom.colormultiply or 0;
            self.BloomOut.r             = self.Bloom.r             or 1;
            self.BloomOut.g             = self.Bloom.g             or 1;
            self.BloomOut.b             = self.Bloom.b             or 1;
        end

        if self.Pulse then
            self.BloomOut.darken        = self.BloomOut.darken        * self.PulseOut;
            self.BloomOut.multiply      = self.BloomOut.multiply      * self.PulseOut;
            self.BloomOut.x             = self.BloomOut.x             * self.PulseOut;
            self.BloomOut.y             = self.BloomOut.y             * self.PulseOut;
            self.BloomOut.passes        = self.BloomOut.passes        * self.PulseOut;
            self.BloomOut.colormultiply = self.BloomOut.colormultiply * self.PulseOut;
            self.BloomOut.r             = self.BloomOut.r             * self.PulseOut;
            self.BloomOut.g             = self.BloomOut.g             * self.PulseOut;
            self.BloomOut.b             = self.BloomOut.b             * self.PulseOut;
        end

        if o.IsFading then
            self.BloomOut.darken        = self.BloomOut.darken        * overlayFade;
            self.BloomOut.multiply      = self.BloomOut.multiply      * overlayFade;
            self.BloomOut.x             = self.BloomOut.x             * overlayFade;
            self.BloomOut.y             = self.BloomOut.y             * overlayFade;
            self.BloomOut.passes        = self.BloomOut.passes        * overlayFade;
            self.BloomOut.colormultiply = self.BloomOut.colormultiply * overlayFade;
            self.BloomOut.r             = self.BloomOut.r             * overlayFade;
            self.BloomOut.g             = self.BloomOut.g             * overlayFade;
            self.BloomOut.b             = self.BloomOut.b             * overlayFade;
        end

        DrawBloom( self.BloomOut.darken, self.BloomOut.multiply, self.BloomOut.x, self.BloomOut.y, self.BloomOut.passes, self.BloomOut.colormultiply, self.BloomOut.r, self.BloomOut.g, self.BloomOut.b );
    end

    if TypeID(self.Paint) == TYPE_FUNCTION then
        self:Paint( w, h );
    end

    surface_SetAlphaMultiplier( 1 );
end

function OverlayLayer:SetPos( x, y )
    if TypeID(x) == TYPE_NUMBER then
        self.Position = {x, y or 0.5};
    else
        self.Position = x;
    end
    return self;
end

function OverlayLayer:SetScale( w, h )
    if TypeID(w) == TYPE_NUMBER then
        self.Scale = {w, h or 1};
    else
        self.Scale = w;
    end
    return self;
end

function OverlayLayer:SetColor( clr )
    self.Color = clr;
    return self;
end

function OverlayLayer:SetMaterial( m )    
    if TypeID(m) == TYPE_STRING then m = Material(m); end

    self.Material = m;

    if not self.Position then self.Position = {0.5, 0.5}; end
    if not self.Scale    then self.Scale    = {1, 1};     end

    return self;
end

function OverlayLayer:SetOpacity( o )
    self.Opacity = o;
    return self;
end

function OverlayLayer:SetColorModify( addr, addg, addb, brightness, contrast, color, mulr, mulg, mulb )
    if TypeID(addr) == TYPE_NUMBER then
        self.ColorMod = {
            ["$pp_colour_addr"]       = addr or 0,
            ["$pp_colour_addg"]       = addg or 0,
            ["$pp_colour_addb"]       = addb or 0,
            ["$pp_colour_brightness"] = brightness or 0,
            ["$pp_colour_contrast"]   = contrast or 1,
            ["$pp_colour_colour"]     = color or 1,
            ["$pp_colour_mulr"]       = mulr or 0,
            ["$pp_colour_mulg"]       = mulg or 0,
            ["$pp_colour_mulb"]       = mulb or 0
        };
    else
        self.ColorMod = addr
    end

    self.ColorModOut = {};
    return self;
end

function OverlayLayer:SetSharpen( contrast, distance )
    if TypeID(contrast) == TYPE_NUMBER then
        self.Sharpen = {
            ["contrast"] = contrast,
            ["distance"] = distance or 0,
        };
    else
        self.Sharpen = contrast;
    end

    self.SharpenOut = {};
    return self;
end

function OverlayLayer:SetMotionBlur( addalpha, drawalpha, delay )
    if TypeID(addalpha) == TYPE_NUMBER then
        self.MotionBlur = {
            ["addalpha"]  = addalpha  or 0,
            ["drawalpha"] = drawalpha or 0,
            ["delay"]     = delay     or 0
        };
    else
        self.MotionBlur = addalpha;
    end

    self.MotionBlurOut = {};
    return self;
end

function OverlayLayer:SetBloom( darken, multiply, x, y, passes, colormultiply, r, g, b )
    if TypeID(darken) == TYPE_NUMBER then
        self.Bloom = {
            ["darken"]        = darken        or 0,
            ["multiply"]      = multiply      or 0,
            ["x"]             = x             or 0,
            ["y"]             = y             or 0,
            ["passes"]        = passes        or 0,
            ["colormultiply"] = colormultiply or 0,
            ["r"]             = r             or 1,
            ["g"]             = g             or 1,
            ["b"]             = b             or 1
        }
    else
        self.Bloom = darken;
    end

    self.BloomOut = {};
    return self;
end

function OverlayLayer:SetPaintFunction( f )
    self.Paint = f;
    return self;
end

function OverlayLayer:SetPulsation( rate, amount )
    self.Pulse = { rate, amount };
    return self
end

setmetatable( OverlayLayer, {__call = OverlayLayer.Create} );
