-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\utilities_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local g_Material, g_ColorAlpha = _G.Material, _G.ColorAlpha;

module( "rp.Scoreboard.Utils", package.seeall );

-- rp.Scoreboard.Utils.GetServerTimezone:
function GetServerTimezone()
    return 10800; -- GMT+3
end

-- rp.Scoreboard.Utils.FormattedTime:
local lookup_time = { 3600, 60, 1 };

function FormattedTime( t, padded )
    local ft = {};

    for k, amount in ipairs( lookup_time ) do
        local v = math.floor( t / amount );
        ft[k] = v;
        t = t - amount * v;
    end

    return string.format( padded and "%02i:%02i:%02i" or "%i:%02i:%02i", unpack(ft) );
end

-- rp.Scoreboard.Utils.RefreshTime:
local refresh_frame, refresh_ts = 0, 0;

function RefreshTime()
    local frame = FrameNumber();
    if refresh_frame >= frame then return true; end

    local ts = SysTime();
    if refresh_ts > ts then return false; end

    refresh_frame = frame + 1;
    refresh_ts = ts + 1;

    return true;
end

-- rp.Scoreboard.Utils.ColorAlpha:
local CachedColors = {};

function ColorAlpha( color, alpha )
    if not CachedColors[color] then
        CachedColors[color] = g_ColorAlpha( color, alpha );
    end

    return CachedColors[color];
end

-- rp.Scoreboard.Utils.Material:
local CachedMaterials = {};

function Material( path, options )
    if not CachedMaterials[path] then
        CachedMaterials[path] = g_Material( path, options );
    end

    return CachedMaterials[path];
end

-- rp.Scoreboard.Utils.DermaOptimizeThink:
function OptimizeDermaThink( panel )
    if not panel.Think then return end

    local think = panel.Think or function() end
    local paint = panel.Paint or function() end

    panel.Think = function()
    end

    panel.Paint = function( pnl, w, h )
        if RefreshTime() then think( pnl ); end
        return paint( pnl, w, h );
    end

    think( panel );
end

-- rp.Scoreboard.Utils.GetPing:
function GetPing( ping )
    if ping < 100 then
        return Material( "rpui/scoreboard/ping.png", "smooth" );
    end

    if ping < 150 then
        return Material( "rpui/scoreboard/ping_m.png", "smooth" ), Material( "rpui/scoreboard/ping.png", "smooth" );
    end

    if ping < 300 then
        return Material( "rpui/scoreboard/ping_l.png", "smooth" ), Material( "rpui/scoreboard/ping.png", "smooth" );
    end

    return nil, Material( "rpui/scoreboard/ping.png", "smooth" );
end