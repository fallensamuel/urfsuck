-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local enabled = rp.cfg.EnableCharacters;
if not enabled then return end


----------------------------------------------------------------
rp.CharacterSystem = rp.CharacterSystem or {};
rp.CharacterSystem.Characters = {};
rp.CharacterSystem.Premium = {};

rp.CharacterSystem.MaxCharacters = rp.cfg.MaxCharacters or 4;
rp.CharacterSystem.NetworkString = "rp.CharacterSystem";
----------------------------------------------------------------


NET_CHARSYSTEM_CHARACTER = 1;
NET_CHARSYSTEM_REQUEST   = 2;
NET_CHARSYSTEM_REGISTER  = 3;
NET_CHARSYSTEM_SELECT    = 4;
NET_CHARSYSTEM_DELETE    = 5;
NET_CHARSYSTEM_REQNAME   = 6;


CHARSYSTEM_REGISTER_ERROR_LIMIT  = 0;
CHARSYSTEM_REGISTER_ERROR_SHORTF = 1;
CHARSYSTEM_REGISTER_ERROR_SHORTL = 2;
CHARSYSTEM_REGISTER_ERROR_LONGN  = 3;
CHARSYSTEM_REGISTER_ERROR_BAD    = 4;
CHARSYSTEM_REGISTER_ERROR_SVFAIL = 5;
CHARSYSTEM_REGISTER_ERROR_EXISTS = 6;


rp.include_sh( "player_sh.lua" );

rp.include_sv( "main_sv.lua" );
rp.include_sv( "hooks_sv.lua" );

rp.include_cl( "main_cl.lua" );
rp.include_cl( "hooks_cl.lua" );

rp.include_cl( "menus/charactermenu_cl.lua" );
rp.include_dir( "addons/characters/handlers" );

rp.include_dir( "addons/characters/addons", true );
