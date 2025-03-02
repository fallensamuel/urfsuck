-- "gamemodes\\rp_base\\gamemode\\addons\\overlays\\base\\cl_overlay.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local setmetatable               = setmetatable;
local SysTime, RealFrameTime     = SysTime, RealFrameTime;
local math_max                   = math.max;
local ipairs, pairs, SortedPairs = ipairs, pairs, SortedPairs;
local table_insert, table_remove = table.insert, table.remove;
local timer_Create, timer_Remove = timer.Create, timer.Remove;
local hook_Add                   = hook.Add;
local ScrW, ScrH                 = ScrW, ScrH;
local cam_Start2D, cam_End2D     = cam.Start2D, cam.End2D;

rp.overlays.Overlay = rp.overlays.Overlay or {};

local Overlay = rp.overlays.Overlay;
Overlay.__index = Overlay;

Overlay.__list        = Overlay.__list or {};
Overlay.__renderqueue = Overlay.__renderqueue or {};

Overlay.Create = function( this, name )
    name = name or SysTime();

    if not Overlay.__list[name] then
        local c_Overlay = {
            ID        = name,
            IsActive  = false,
            IsFading  = false,
            Duration  = 0,
            Weight    = 0,
            Layers    = {},
            FadeIn    = 0,
            FadeOut   = 0,
            FadeDelta = 1
        };

        setmetatable( c_Overlay, Overlay );
        Overlay.__list[name] = c_Overlay;
    end

    return Overlay.__list[name];
end

-- Overlay.GetList = function() return Overlay.__list; end

function Overlay:Render( w, h )
    if self.IsFading then
        if self.tFade < SysTime() then
            self.IsFading = false;
        end

        self.FadeDelta = math_max( (self.tFade - SysTime()) / (self.dFade and self.FadeIn or self.FadeOut), 0 );

        if (not self.dFade) and (self.FadeDelta <= 0.1) then
            self.IsActive = false;
        end
    end

    for _, layer in pairs( self.Layers ) do
        layer:Render( self, w, h );
    end
end

function Overlay:Enable()
    if self.IsActive then
        for _, layer in ipairs( self.Layers ) do
            if layer.OnUpdate then layer:OnUpdate( self ); end
        end
    else
        self.Shutdown = false;

        Overlay.__renderqueue[self.Weight] = Overlay.__renderqueue[self.Weight] or {};
        table_insert( Overlay.__renderqueue[self.Weight], self );

        self.tFade = SysTime() + self.FadeIn;
        self.dFade = true;

        self.IsFading = true;

        self.IsActive = true;

        for _, layer in ipairs( self.Layers ) do
            if layer.OnStart then layer:OnStart( self ); end
        end

        if self.Duration > 0 then
            timer_Create( self.ID, self.FadeIn + self.Duration, 1, function()
                if not self then return end
                self:Disable();
            end );
        end
    end
end

function Overlay:ForceDisable()
    timer_Remove( self.ID );

    self.IsActive = false;

    if not Overlay.__renderqueue[self.Weight] then return end

    for k, v in pairs( Overlay.__renderqueue[self.Weight] ) do
        if v == self then table_remove( Overlay.__renderqueue[self.Weight], k ); end
    end
end

function Overlay:Disable()
    if self.IsActive and not self.Shutdown then
        self.Shutdown = true;

        self.tFade = SysTime() + self.FadeOut;
        self.dFade = false;

        self.IsFading = true;

        for _, layer in ipairs( self.Layers ) do
            if layer.OnEnd then layer:OnEnd( self ); end
        end

        timer_Create( self.ID, self.FadeOut, 1, function()
            self.IsActive = false;

            if not Overlay.__renderqueue[self.Weight] then return end

            for k, v in pairs( Overlay.__renderqueue[self.Weight] ) do
                if v == self then table_remove( Overlay.__renderqueue[self.Weight], k ); end
            end
        end );
    end
end

function Overlay:Toggle()
    if self.IsActive then self:Enable(); else self:Disable(); end
end

function Overlay:SetWeight( w )
    self.Weight = w;
    return self;
end

function Overlay:SetFadeIn( t )
    self.FadeIn = t;
    return self;
end

function Overlay:SetFadeOut( t )
    self.FadeOut = t;
    return self;
end

function Overlay:SetDuration( n )
    self.Duration = n;
    return self;
end

function Overlay:AddLayer( overlayLayer )
    if rp.overlays.OverlayLayer.__list[overlayLayer] then
        overlayLayer = rp.overlays.OverlayLayer.__list[overlayLayer];
    end

    table_insert( self.Layers, overlayLayer );
    return self;
end

setmetatable( Overlay, {__call = Overlay.Create} );

local w, h = ScrW(), ScrH();
hook_Add( "PreDrawHUD", "OverlayBase::RenderOverlays", function()
    cam_Start2D();
        for weight, overlays in SortedPairs( Overlay.__renderqueue ) do
            for _, overlay in ipairs( overlays ) do
                if not overlay.IsActive then continue end
                overlay:Render( w, h );
            end
        end
    cam_End2D();
end );