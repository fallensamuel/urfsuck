-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\sh_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "PreAuctionLoaded", "auctions::Disable", function()
    return not rp.cfg.AuctionsDisabled;
end );

hook.Add( "ConfigLoaded", "auctions::Preload", function()
    local status = hook.Run( "PreAuctionLoaded" );
    if status == false then return end

    module( "auctions", package.seeall );

    hook.Run( "AuctionLoaded" );

    for key, tbl in pairs( auctions or {} ) do
        if not istable( tbl ) then continue end

        if isfunction( tbl.Initialize ) then
            tbl:Initialize();
        end

        if tbl.events then
            hook.Add( "OnAuctionEvent", "auctions::EventHandler-" .. key, function( t, event )
                local fn = tbl.events[t];
                if isfunction( fn ) then fn( event ); end
            end );
        end
    end

    if CLIENT then
        local rootcheck = function( ply ) return ply:IsRoot(); end

        for sid in pairs( utils.m_servernames or {} ) do
            CHATBOX:RegisterEmotesViaAPI( string.format("https://urf.im/content/emotes/%s/", sid), 21, 21, rootcheck );
        end
    end
end );