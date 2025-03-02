-- "gamemodes\\rp_base\\gamemode\\addons\\upgraders\\sh_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.include_dir( "addons/upgraders/classes" );

rp.Upgraders = rp.Upgraders or {};

-- Networking: -------------------------------------------------
NET_UPGRADERS_ACTION_DATA = 0;
NET_UPGRADERS_ACTION_RUN = 1;
NET_UPGRADERS_ACTION_EFFECT = 2;
NET_UPGRADERS_ACTION_GESTURE = 3;