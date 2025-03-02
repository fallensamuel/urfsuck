-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\fonts_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local w, h = ScrW(), ScrH();

surface.CreateFont( "rpui.Fonts.ScoreboardSmall", {
    font = "Montserrat",
    size = h * 0.015,
    weight = 500,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardSmallBold", {
    font = "Montserrat",
    size = h * 0.015,
    weight = 1000,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardDefault", {
    font = "Montserrat",
    size = h * 0.0165,
    weight = 500,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardDefaultBold", {
    font = "Montserrat",
    size = h * 0.0165,
    weight = 1000,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardMedium", {
    font = "Montserrat",
    size = h * 0.015,
    weight = 700,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardLarge", {
    font = "Montserrat",
    size = h * 0.02,
    weight = 1000,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.ScoreboardHuge", {
    font = "Montserrat",
    size = h * 0.0275,
    weight = 1000,
    extended = true,
} );