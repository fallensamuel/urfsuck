-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\hats\\hats_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- rp.AddHat: --------------------------------------------------
function rp.AddHat( data )
    -- `bag`-type fallback:
    if data.bag and rp.AddBag then
        return rp.AddBag( data );
    end

    data.type = rp.Accessories.Enums["TYPE_HAT"];
    return rp.AddWearable( data );
end