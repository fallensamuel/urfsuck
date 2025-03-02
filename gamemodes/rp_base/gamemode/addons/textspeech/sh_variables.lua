-- "gamemodes\\rp_base\\gamemode\\addons\\textspeech\\sh_variables.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
require( "nw" );

nw.Register( "TextSpeech" )
    :Write( net.WriteUInt, 6 )
    :Read( net.ReadUInt, 6 )
    :SetLocalPlayer()