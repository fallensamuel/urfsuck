util.AddNetworkString( "net.foodsystem.InterpolateArm" );

rp.FoodSystem = rp.FoodSystem or {};

rp.FoodSystem.SpawnFood = function( class, pos, ang )
    local me = weapons.GetStored(class);
    if not istable(me) then return end

    local ent = ents.Create( "spawned_weapon" );
    ent:SetPos( pos );
    ent:SetAngles( ang );
    ent:SetModel( me.WorldModel );
    ent.weaponclass = class;
    ent:Spawn();
end

--[[
rp.cfg.FoodSystem = rp.cfg.FoodSystem or {
    Faction = {
        [FACTION_COMBINE]   = "urf_foodsystem_ration_mpf",
        [FACTION_HELIX]     = "urf_foodsystem_ration_mpf",
        [FACTION_DAP]       = "urf_foodsystem_ration_mpf",
        [FACTION_DPF]       = "urf_foodsystem_ration_mpf",
        [FACTION_ANTIHUMAN] = "urf_foodsystem_ration_mpf",
        [FACTION_OTA]       = "urf_foodsystem_ration_mpf",

        [FACTION_CWU]       = "urf_foodsystem_ration_cwu",
    },

    Loyalty = {
        [1] = "urf_foodsystem_ration_minimal",
        [2] = "urf_foodsystem_ration_normal",
        [3] = "urf_foodsystem_ration_normal",
        [4] = "urf_foodsystem_ration_expanded",
    },
};
]]--