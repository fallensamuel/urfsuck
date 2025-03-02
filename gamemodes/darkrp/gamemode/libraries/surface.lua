-- "gamemodes\\darkrp\\gamemode\\libraries\\surface.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface = surface;

surface.RegistredFonts = {};

surface.RegisterFont = surface.RegisterFont or surface.CreateFont;

surface.CreateFont = function( Name, CFontData )
    surface.RegistredFonts[Name] = CFontData;
    surface.RegisterFont( Name, CFontData );
end