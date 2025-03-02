-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\cl_lots.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
module( "auctions", package.seeall );

----------------------------------------------------------------
lots = {};

lots.cache = {};

function lots:GetByID( lot_id )
    return self.cache[lot_id];
end

function lots:HasActive()
    return tobool( self:GetActive() );
end

function lots:GetActive()
    for lot_id, lot in pairs( self.cache ) do
        if tobool( lot.active ) then return lot; end
    end
end

function lots:Initialize()
    hook.Add( "InitPostEntity", "auctions.lots::Sync", function()
        networking:RequestSync();
    end );
end