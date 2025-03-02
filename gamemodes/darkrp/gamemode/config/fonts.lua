-- "gamemodes\\darkrp\\gamemode\\config\\fonts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function FullHDScreenScale( n, mult ) return (n / 1080) * ScrH() * (mult or 1) end

-- взято из rp_base\gamemode\core\hud_cl.lua
surface.CreateFont('PlayerInfo', {
	font = 'RUSBoycott',
	size = FullHDScreenScale(20, 0.9),
	weight = 300,
	antialias = true,
	extended = true,
})

surface.CreateFont('PlayerInfoBig', {
	font = 'RUSBoycott',
	size = FullHDScreenScale(50, 0.9),
	weight = 300,
	antialias = true,
	extended = true,
})

surface.CreateFont('HudFont', {
	font = 'Open Sans Light',
	size = 21,
	weight = 500,
	antialias = true,
	extended = true,
})

surface.CreateFont('HudFontSmall', {
	font = 'Open Sans Light',
	size = 18,
	weight = 650,
	antialias = true,
	extended = true,
})

surface.CreateFont('HudFont2', {
	font = 'Open Sans Light',
	size = 24,
	weight = 700,
	extended = true,
})

surface.CreateFont('NLRFont', {
	font = 'Open Sans Light',
	size = 42,
	weight = 700,
	extended = true,
})

-- взято из rp_base\gamemode\entities\entities\keypad\cl_init.lua
surface.CreateFont("Keypad", {font = "Trebuchet", size = 34, weight = 900})
surface.CreateFont("KeypadState", {font = "Trebuchet", size = 20, weight = 600})
surface.CreateFont("KeypadButton", {font = "roboto", size = 24, weight = 500})
surface.CreateFont("KeypadSButton", {font = "Trebuchet", size = 16, weight = 900})

-- взято из rp_base\gamemode\entities\entities\money_printer\cl_init.lua
surface.CreateFont('PrinterLarge', {
	font = 'roboto',
	size = 55,
	weight = 500
})

surface.CreateFont('PrinterSmall', {
	font = 'roboto',
	size = 50,
	weight = 500
})

-- взято из rp_base\gamemode\entities\weapons\gmod_tool\cl_init.lua
surface.CreateFont("GModToolName", {
	font = "Roboto Bk",
	size = 80,
	weight = 1000
})

surface.CreateFont("GModToolSubtitle", {
	font = "Roboto Bk",
	size = 24,
	weight = 1000
})

surface.CreateFont("GModToolHelp", {
	font = "Roboto Bk",
	size = 17,
	weight = 1000
})

-- взято из rp_base\gamemode\entities\weapons\gmod_tool\cl_viewscreen.lua
surface.CreateFont("GModToolScreen", {
	font = "Helvetica",
	size = 60,
	weight = 900
})

-- взято из rp_base\gamemode\cl_init.lua
surface.CreateFont("3d2d",{font = "RUSBoycott",size = 150,weight = 300,shadow = true, extended = true})
surface.CreateFont("Trebuchet22", {size = 22,weight = 500,antialias = true,shadow = false,font = "Trebuchet MS"})

-- взято из rp_base\gamemode\core\attributes\cl_menu.lua
surface.CreateFont("AttributeFontBig",{font = "Open Sans Light",size = 25,weight = 1700,shadow = true, antialias = true, extended = true,})

-- взято из rp_base\gamemode\core\capture\hud_cl.lua
surface.CreateFont("CaptureBig",{
	font = "RUSBoycott",
	extended = true,
	size = 33,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont("CaptureSmall",{
	font = "RUSBoycott",
	extended = true,
	size = 43,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

-- взято из rp_base\gamemode\core\cosmetics\appearance\vgui_djobslist_cl.lua
surface.CreateFont( "ImpactF4", {
    font = "Impact",
    extended = true,
    size = 25,
    weight = 250,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
} );

surface.CreateFont( "ImpactVIP", {
	font = "Impact",
	extended = true,
	size = 15,
	weight = 200,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
} );

-- взято из rp_base\gamemode\core\doors\init_cl.lua
surface.CreateFont('DoorFont', {
	font = 'RUSBoycott',
	size = 150 / 2,
	weight = 300,
	antialias = true,
	extended = true,
})

-- взято из rp_base\gamemode\core\npcs\menu_cl.lua
surface.CreateFont("cnChatFont", {
	font = "Tahoma",
	size = 16,
	weight = 800
})

-- взято из rp_base\gamemode\core\sandbox\spawnmenu\creationmenu\content\contentheader_cl.lua
surface.CreateFont("ContentHeader", {
	font = "Helvetica",
	size = 50,
	weight = 1000
})

-- взято из rp_base\gamemode\core\ui\main_cl.lua
surface.CreateFont('rp.ui.40', {
	font = 'Sans',
	size = 40,
	weight = 500
})

surface.CreateFont('rp.ui.39', {
	font = 'Sans',
	size = 39,
	weight = 500
})

surface.CreateFont('rp.ui.38', {
	font = 'Sans',
	size = 38,
	weight = 500
})

surface.CreateFont('rp.ui.37', {
	font = 'Sans',
	size = 37,
	weight = 500
})

surface.CreateFont('rp.ui.36', {
	font = 'Sans',
	size = 36,
	weight = 500
})

surface.CreateFont('rp.ui.35', {
	font = 'Sans',
	size = 35,
	weight = 500
})

surface.CreateFont('rp.ui.34', {
	font = 'Sans',
	size = 34,
	weight = 500
})

surface.CreateFont('rp.ui.33', {
	font = 'Sans',
	size = 33,
	weight = 500
})

surface.CreateFont('rp.ui.32', {
	font = 'Sans',
	size = 32,
	weight = 500
})

surface.CreateFont('rp.ui.31', {
	font = 'Sans',
	size = 31,
	weight = 500
})

surface.CreateFont('rp.ui.30', {
	font = 'Sans',
	size = 30,
	weight = 500
})

surface.CreateFont('rp.ui.29', {
	font = 'Sans',
	size = 29,
	weight = 500
})

surface.CreateFont('rp.ui.28', {
	font = 'Sans',
	size = 28,
	weight = 500
})

surface.CreateFont('rp.ui.27', {
	font = 'Sans',
	size = 27,
	weight = 400
})

surface.CreateFont('rp.ui.26', {
	font = 'Sans',
	size = 26,
	weight = 400
})

surface.CreateFont('rp.ui.25', {
	font = 'Sans',
	size = 25,
	weight = 400
})

surface.CreateFont('rp.ui.24', {
	font = 'Sans',
	size = 24,
	weight = 400
})

surface.CreateFont('rp.ui.23', {
	font = 'Sans',
	size = 23,
	weight = 400
})

surface.CreateFont('rp.ui.22', {
	font = 'Sans',
	size = 22,
	weight = 400
})

surface.CreateFont('rp.ui.20', {
	font = 'Sans',
	size = 20,
	weight = 400
})

surface.CreateFont('rp.ui.19', {
	font = 'Sans',
	size = 19,
	weight = 400
})

surface.CreateFont('rp.ui.18', {
	font = 'Sans',
	size = 18,
	weight = 400
})

surface.CreateFont('rp.ui.15', {
	font = 'Sans',
	size = 15,
	weight = 550
})

-- взято из rp_base\gamemode\modules\hud\cl_hud.lua
surface.CreateFont( "HUDBarFont", {
	font = "Open Sans Light",
	size = 18,
	extended = true,
	weight = 100
})

surface.CreateFont( "HUDInfoFont", {
	font = "Open Sans Light",
	size = 32,
	extended = true,
	antialias = true,
	weight = 300
})

-- взято из rp_base\gamemode\modules\hud\cl_weaponselector.lua
surface.CreateFont( "WeaponSelectorFont", {
	font = "Open Sans Light",
	size = 32,
	extended = true,
	antialias = true,
	weight = 600
})

surface.CreateFont( "WeaponSelectorFontBlur", {
	font = "Open Sans Light",
	size = 32,
	extended = true,
	antialias = true,
	weight = 600,
	blursize = 1
})

-- взято из rp_base\gamemode\modules\scanner\cl_init.lua
surface.CreateFont("nutScannerFont", {
	font = "Lucida Sans Typewriter",
	antialias = false,
	outline = true,
	weight = 800,
	size = 18
})

-- взято из rp_base\gamemode\modules\scoreboard\player_infocard.lua
surface.CreateFont("suiscoreboardcardinfo", {
	font = "DefaultSmall",
	size = 12,
	weight = 0
})

-- взято из rp_base\gamemode\modules\scoreboard\scoreboard.lua
surface.CreateFont("switchteambutton", {
	font = "coolvetica",
	size = 30,
	weight = 300
})

surface.CreateFont("suiscoreboardheader", {
	font = "coolvetica",
	size = 50,
	weight = 300
})

surface.CreateFont("suiscoreboardsubtitle", {
	font = "coolvetica",
	size = 20,
	weight = 100
})

surface.CreateFont("suiscoreboardlogotext", {
	font = "coolvetica",
	size = 75,
	weight = 100
})

surface.CreateFont("TextFontSmall", {
	font = "verdana",
	size = 12,
	weight = 100
})

surface.CreateFont("suiscoreboardplayername", {
	font = "trebuchet",
	size = 17,
	weight = 530
})

surface.CreateFont("suiscoreboardplayernamebold", {
	font = "trebuchet",
	size = 18,
	weight = 650
})

-- взято из rp_base\gamemode\modules\stamina\cl_bur_sprintmod.lua
surface.CreateFont( "SprintFont", {
	font = "roboto condensed", 
	size = 24, 
	weight = 0, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false, 
} )


-- взято из rp_base\gamemode\modules\car_interface\cl_carint.lua
surface.CreateFont("VehicleFontBig",{
	font = "RUSBoycott",
	extended = true,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	--shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont("VehicleFontSmall",{
	font = "RUSBoycott",
	extended = true,
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	--shadow = true,
	additive = false,
	outline = false,
})