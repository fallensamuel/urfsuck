-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\sh_commands.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ba.cmd.Create( "auctioncreate", function( ply, args )
    local fn = auctions.commands["create"];
    if fn then fn( ply, args ) end
end )
:AddParam( "string", "upgrade_id" )
:AddParam( "string", "start_amount" )
:AddParam( "string", "step" )
:AddParam( "time", "duration" )
:SetFlag( "*" )
:SetHelp( "Создает лот для аукциона" )

ba.cmd.Create( "auctionbid", function( ply, args )
    local fn = auctions.commands["bid"];
    if fn then fn( ply, args ) end
end )
:RunOnClient( function( args )
    if args[1] then return end

    local lot = auctions.lots:GetActive();
    if not lot then return end

    auctions.networking:RequestBid( lot.id );
end )
:SetHelp( "Сделать ставку на аукционе" )

ba.cmd.Create( "auctionmute", function( ply, args )
    local fn = auctions.commands["mute"];
    if fn then fn( ply, args ); end
end )
:AddParam( "player_steamid", "target" )
:AddParam( "time", "duration" )
:AddParam( "string", "reason" )
:SetFlag( "M" )
:SetHelp( "Ограничивает доступ к аукционному чату указанному игроку" )
:SetIcon( "icon16/sound.png" )

ba.cmd.Create( "auctionunmute", function( ply, args )
    local fn = auctions.commands["unmute"];
    if fn then fn( ply, args ); end
end )
:AddParam( "player_steamid", "target" )
:SetFlag( "M" )
:SetHelp( "Разрешает доступ к аукционному чату указанному игроку" )
:SetIcon( "icon16/sound.png" )
