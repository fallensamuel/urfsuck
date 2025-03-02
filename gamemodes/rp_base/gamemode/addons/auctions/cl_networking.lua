-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\cl_networking.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
module( "auctions", package.seeall );

----------------------------------------------------------------
net.Receive( "auctions", function()
    local fn = networking.handlers[net.ReadUInt(32)];
    if isfunction( fn ) then
        fn( networking );
    end
end );

----------------------------------------------------------------
networking = {};

networking.actions = {
    SYNC = 0,
    LOT  = 1,
    BID  = 2,
    BEEP = 3,
    CHAT = 4,
    TIME = 5,
};

networking.action_id = 0;

networking.handlers = {
    [networking.actions.SYNC] = function( nw )
        for k = 1, net.ReadUInt( 32 ) do
            local lot = nw:ReceiveLot();
            hook.Run( "OnAuctionLotReceived", lot );
        end
    end,

    [networking.actions.LOT] = function( nw )
        local lot = nw:ReceiveLot();
        hook.Run( "OnAuctionLotReceived", lot );
    end,

    [networking.actions.BID] = function( nw )
        networking.action_id = math.random( 0x0, 0xFFFFFFFF );
    end,

    [networking.actions.BEEP] = function( nw )
        hook.Run( "OnAuctionBeep" );
    end,

    [networking.actions.CHAT] = function( nw )
        hook.Run( "OnAuctionChatMessage", nw:ReceiveChat() );
    end,

    [networking.actions.TIME] = function( nw )
        hook.Run( "OnAuctionTimeSynced", net.ReadUInt(32) );
    end
};

function networking:ReadLot()
    return {
        id = net.ReadUInt( 32 ),
        upgrade_id = net.ReadString(),
        amount = net.ReadUInt( 32 ),
        step = net.ReadUInt( 32 ),
        steamid = net.ReadString(),
        name = net.ReadString(),
        server_id = net.ReadString(),
        ts_start = net.ReadUInt( 32 ),
        ts_end = net.ReadUInt( 32 ),
        active = net.ReadBool()
    };
end

function networking:ReceiveLot()
    local lot = self:ReadLot();
    lots.cache[lot.id] = lot;

    return lot;
end

function networking:ReceiveChat()
    local message = {};
    message["text"] = net.ReadString();

    local b_player = net.ReadBool();
    if b_player then
        message["server_id"] = net.ReadString();
        message["steamid"] = net.ReadString();
        message["name"] = net.ReadString();
    end

    message["args"] = {};
    for k = 1, net.ReadUInt( 32 ) do
        message["args"][k] = net.ReadType();
    end

    return message;
end

function networking:RequestBid( lot_id )
    if not lot_id then return end

    net.Start( "auctions" );
        net.WriteUInt( self.actions.BID, 32 );
        net.WriteUInt( self.action_id, 32 );
        net.WriteUInt( lot_id, 32 );
    net.SendToServer();
end

function networking:RequestSync()
    net.Start( "auctions" );
        net.WriteUInt( self.actions.SYNC, 32 );
    net.SendToServer();
end

function networking:RequestTime()
    net.Start( "auctions" );
        net.WriteUInt( self.actions.TIME, 32 );
    net.SendToServer();
end