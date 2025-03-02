-- "gamemodes\\darkrp\\gamemode\\addons\\artifactmod\\sh_modifiers.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ArtifactMod = ArtifactMod or {};

--[[------------------------------------------------------------
How to add new modifier:

> Modifier structure:
["modifier_name"] = {
    function( ply )
        -- This is setup function, called when player has been spawned.
        -- `ply`        => player

        -- Registers into PLAYER.ArtifactMod["modifier_name"]
        -- You should register players' initial values by returning

        return ply:GetMaxHealth();
    end,
    
    function( ply, initial, mod )
        -- This is modifier function, called when player wants to apply modifiers from an artifact.
        -- `ply`        => player
        -- `initial`    => value from setup function
        -- `mod`        => summed values from equipped artifacts

        -- For more advanced examples check `ArtifactMod.Modifiers` table

        ply:SetMaxHealth( initial + mod );
    end
},
------------------------------------------------------------]]--

ArtifactMod.Modifiers = {
    -- (+) Maximal health:
    ["maxhealth"] = {
        function( ply )
            return ply:GetMaxHealth();
        end,

        function( ply, initial, mod )
            ply:_SetMaxHealth( initial + mod );
            ply:_SetHealth( math.min(ply:Health(), ply:GetMaxHealth()) );
        end,
    },

    -- (%) Movement speed:
    ["movespeed"] = {
        function( ply )
            return { ply:GetWalkSpeed(), ply:GetRunSpeed() };
        end,

        function( ply, initial, mod )
            ply:SetWalkSpeed( math.max(initial[1] * (1 + mod), 1) );
            ply:SetRunSpeed( math.max(initial[2] * (1 + mod), 1) );
        end
    },

    -- (%) Jump power:
    ["jumppower"] = {
        function( ply )
            return ply:GetJumpPower();
        end,

        function( ply, initial, mod )
            ply:SetJumpPower( initial * (1 + mod) );
        end
    },

    -- (%) Hunger rate:
    ["hungerrate"] = {
        function( ply )
            return ply:GetHungerRateMultiplier();
        end,

        function( ply, initial, mod )
            ply:SetHungerRateMultiplier( initial * (1 + mod) );
        end
    },

    -- (%) Damage multiplier:
    ["damagemult"] = {
        function( ply )
        end,

        function( ply, initial, mod )
            ply.ArtifactMod["damagemult"] = math.max(0, 1 + mod);
            if ply.ArtifactMod["damagemult"] == 1 then ply.ArtifactMod["damagemult"] = nil; end
        end
    },

    -- (+) Regeneration:
    ["regeneration"] = {
        function( ply )
        end,

        function( ply, initial, mod )
            ply.ArtifactMod["regeneration"] = math.max(0, mod);
            if ply.ArtifactMod["regeneration"] == 0 then ply.ArtifactMod["regeneration"] = nil; end
        end
    },

    -- (+) Radiation:
    ["radiation"] = {
        function( ply )
        end,

        function( ply, initial, mod )
            ply.ArtifactMod["radiation"] = math.max(0, mod);
            if ply.ArtifactMod["radiation"] == 0 then ply.ArtifactMod["radiation"] = nil; end
        end
    },

    -- (b) Teleport:
    ["teleport"] = {
        function( ply )
        end,

        function( ply, initial, mod )
            ply.ArtifactMod["teleport"] = tobool( mod );
            if not ply.ArtifactMod["teleport"] then ply.ArtifactMod["teleport"] = nil; end
            ply:SetNWBool( "ArtifactMod-teleport", ply.ArtifactMod["teleport"] );
        end
    },
};


ArtifactMod.PlayerTimer = function( self, ply )
    if ply.ArtifactMod["regeneration"] then
        if ply:GetInternalVariable( "m_flLastDamageTime" ) <= -5 then
            ply:_SetHealth( math.min(ply:Health() + ply.ArtifactMod.regeneration, ply:GetMaxHealth()) );
        end
    end

    if ply.ArtifactMod["radiation"] and ply.AddRadiation then
        ply:AddRadiation( ply.ArtifactMod.radiation );
    end
end


hook.Add( "EntityTakeDamage", "ArtifactMod::PlayerDamageHandler", function( target, damageinfo )
    if not target.ArtifactMod then return end
    
    if target.ArtifactMod["damagemult"] then
        damageinfo:ScaleDamage( target.ArtifactMod["damagemult"] );
    end
end );