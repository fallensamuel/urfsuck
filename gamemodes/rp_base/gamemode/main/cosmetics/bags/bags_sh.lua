-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\bags\\bags_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- rp.AddBag: --------------------------------------------------
function rp.AddBag( data )
    data.type = rp.Accessories.Enums["TYPE_BAG"];
    return rp.AddWearable( data );
end

-- PLAYER: -----------------------------------------------------
local playerMeta = FindMetaTable( "Player" );

function playerMeta:getBagInv()
	return rp.item.inventories[self:getBagInvID()]
end

function playerMeta:getBagInvID()
	return self:GetNWInt( "InventoryBagID", -1 );
end