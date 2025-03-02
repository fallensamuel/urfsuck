game.ConsoleCommand( "sv_allowupload 0\n" );

hook.Add( "PlayerSpray", "rp.DisablePlayerSprays", function()
    return true
end );