ba.AddTerm( "ScreenCapture.Started",    "Отправлен запрос на снимок экрана игрока #." );
ba.AddTerm( "ScreenCapture.Processing", "Снимок экрана игрока # обрабатывается, примерное время ожидания: # секунд" );

ba.cmd.Create( "sg", function( pl, args )
    local q = math.Clamp( tonumber(args[2]) or 70, 10, 100 );
    ScreenCapture_RequestScreen( args.target, pl, q );
    ba.notify( pl, ba.Term("ScreenCapture.Started"), args.target );
end)
:AddParam( "player_entity", "target" )
:SetFlag( "A" )
:SetHelp( "Shows screen of a player" )
:SetIcon( "icon16/eye.png" )