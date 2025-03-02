-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\cl_hooks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--
hook.Add( "StartCommand", "rp.Experiences::Sync", function()
    hook.Remove( "StartCommand", "rp.Experiences::Sync" );
    net.Start( "rp.Experiences" ); net.SendToServer();
end );