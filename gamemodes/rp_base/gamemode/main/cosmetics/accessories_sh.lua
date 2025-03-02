-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\accessories_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Accessories = rp.Accessories or {};

rp.Accessories.Map = {};
rp.Accessories.List = {};

-- Enumerations: -----------------------------------------------
TYPE_WEARABLE = 0;
TYPE_HAT = 1;
TYPE_BAG = 2;
TYPE_BELT = 3;
TYPE_EFFECT = 4;
TYPE_PET = 255;

rp.Accessories.Enums = {};
rp.Accessories.Enums["TYPE_WEARABLE"] = TYPE_WEARABLE;
rp.Accessories.Enums["TYPE_HAT"] = TYPE_HAT;
rp.Accessories.Enums["TYPE_BAG"] = TYPE_BAG;
rp.Accessories.Enums["TYPE_BELT"] = TYPE_BELT;
rp.Accessories.Enums["TYPE_EFFECT"] = TYPE_EFFECT;
rp.Accessories.Enums["TYPE_PET"] = TYPE_PET;

-- nw: ---------------------------------------------------------
nw.Register( "Accessories" )
    :SetPlayer()
    :Write( function( tbl )
        local c = table.Count( tbl );
        net.WriteUInt( c, 8 ); -- 255

        for k, v in pairs( tbl ) do
            net.WriteString( k );
            net.WriteBool( v );
        end
    end )
    :Read( function()
        local tbl = {};

        local c = net.ReadUInt( 8 );
        for i = 1, c do
            tbl[net.ReadString()] = net.ReadBool();
        end

        return tbl
    end )

-- rp.AddAccessory: --------------------------------------------
function rp.AddAccessory( data )
    data.type = data.type or rp.Accessories.Enums["TYPE_WEARABLE"];
    data.slot = data.slot or 0;

    data.ACCESSORY_ID = table.insert( rp.Accessories.Map, data );

    local sk, mdl = string.match( data.model, "(%d+):" ), string.match( data.model, "/([^/]-).mdl$" ); 
    data.ACCESSORY_UID = (data.UID or data.uid) or (mdl .. (sk and "_" .. sk or ""));

    data.__r_model = string.match(data.model, ":(.+)$") or data.model;
    data.__r_skin = sk or 0;

    if CLIENT then
        data.__renderer = data.__renderer or rp.Accessories.DefaultRenderer;
    end

    rp.Accessories.List[data.ACCESSORY_UID] = data;

    return data
end

-- PLAYER: -----------------------------------------------------
local PLAYER = FindMetaTable( "Player" );

function PLAYER:IsWearingAccessories()
    -- highly unoptimized, find a way to cache this on netvar:Accessories change
    
    for k, v in pairs( self:GetNetVar("Accessories") or {} ) do
        if v then return true end
    end

    return false
end

function PLAYER:GetAccessories()
    return SERVER and self.Accessories or self:GetNetVar( "Accessories" ) or {};
end