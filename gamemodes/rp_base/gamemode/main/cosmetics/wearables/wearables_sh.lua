-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\wearables\\wearables_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.hats = rp.hats or {};
rp.hats.list = rp.hats.list or {};

-- rp.AddWearable: ---------------------------------------------
function rp.AddWearable( data )
    data.base = rp.Accessories.Enums["TYPE_WEARABLE"];

    data.type = data.type or rp.Accessories.Enums["TYPE_WEARABLE"];
    data.slot = data.slot or 0;

    data.name = data.name or "unknown";
    data.desc = data.desc or "";

    data.model = string.gsub( string.lower(data.model or "models/error.mdl"), "[\\/]+", "/" );

    data.price = data.price;
    data.donatePrice = data.donatePrice;

    data.attachment = data.attachment;
    data.bone = data.bone or "ValveBiped.Bip01_Head1";
    
    data.scale = data.scale or 1;

    data.Discount = 0.25;

    data.cfgDiscount = data.Discount;
    data.cfgPrice = data.Discount and data.price;
    data.cfgDonatePrice = data.donatePrice;

    data.modifyClientsideModel = data.modifyClientsideModel or function( self, ply, model, pos, ang ) return model, pos, ang end;
    data.can_wear = data.can_wear or data.custom_check;

    rp.hats.list[data.model] = data;

    return rp.AddAccessory( data );
end

----------------------------------------------------------------
hook.Add( "ConfigLoaded", "rp.Accessories::Discounts", function()
    rp.cfg.WearablesDiscountSettings = {
        interval = 24, -- часы
        count = 10 
    };

    hook.Run( "rp.DiscountWearables" );
    hook.Run( "rp.AddWearablesToShop" );
end );

hook.Add( "rp.AddWearablesToShop", "rp.Accessories::WearablesShop", function()
    for k, v in SortedPairsByMemberValue( rp.Accessories.List, "donatePrice", false ) do
        if not v.donatePrice then
            continue
        end

        local shop_uid = "wearable_" .. v.ACCESSORY_UID;

        rp.shop.Add( v.name, shop_uid )
            :SetCat( translates.Get("Аксессуары") )
            :SetDesc( v.desc or translates.Get("Купить %s навсегда", v.name) )
            :SetPrice( v.donatePrice )
            :SetCanBuy( function(self, pl)
                if pl:HasUpgrade(pl, shop_uid) or pl:GetAccessories()[v.ACCESSORY_UID] then
                    return false, translates.Get("Она у вас уже есть.")
                end

                return true
            end ):SetOnBuy( function(self, pl)
                rp.Accessories.Set( pl, v.ACCESSORY_UID );
            end )
    end
end );

hook.Add( "rp.DiscountWearables", "rp.Accessories::WearablesDiscount", function()
    if (not rp.cfg.WearablesDiscountSettings) or (not rp.cfg.WearablesDiscountSettings.interval) then
        return
    end
    
    math.randomseed( math.floor(os.time() / rp.cfg.WearablesDiscountSettings.interval / 3600) );

    local HasAltPrice = {};

    for k, v in pairs( rp.Accessories.List ) do
        if v.cfgDiscount then
            v = table.Copy( v );
            v.key = k;
            table.insert( HasAltPrice, v );
        end
    end

    local G = {};
    local AltPriceItems = table.GetKeys( HasAltPrice );

    rp.WearablesDiscount = {};

    for i = 1, (rp.cfg.WearablesDiscountSettings.count or 1) do
        local hat, key = table.Random( HasAltPrice );
        while G[key] do
            if #table.GetKeys(G) == #table.GetKeys(AltPriceItems) then break end
            hat, key = table.Random( HasAltPrice );
        end

        if not hat then return end
        G[key] = true;

        rp.WearablesDiscount[key] = hat;
    end

    for k, v in pairs( rp.WearablesDiscount ) do
        local Discount = istable(v.cfgDiscount) and table.Random(v.cfgDiscount) or v.cfgDiscount or 0;
        local disc = 1 - Discount;

        if rp.Accessories.List[v.key].cfgPrice then
            rp.Accessories.List[v.key].price = v.cfgPrice * disc;
        end

        if rp.Accessories.List[v.key].cfgDonatePrice then
            rp.Accessories.List[v.key].donatePrice = v.cfgDonatePrice * disc;
        end

        rp.Accessories.List[v.key].discount = Discount ~= 0 and Discount;
    end

    math.randomseed( os.time() );
end );