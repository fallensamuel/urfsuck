-- "gamemodes\\rp_base\\gamemode\\addons\\bodylooting\\sh_bodylooting.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.cfg.BodyLooting = rp.cfg.BodyLooting or {
    Cooldown = 5,

    Items = {
        [100] = { "rpitem_metal", "rpitem_battery" },
        [10] = { "rpitem_battery" },
    },

    CustomRender = {
        ["rpitem_metal"] = function( mdl, origin, angles, scale )
            return {
                mdl = "models/fallout/components/glass.mdl",
                origin = Vector(2, 0, -1),
                angles = Angle(45, 45, -90),
                scale = scale * 2,
            };
        end,
    }
};

hook.Add( "BodyLooting::Filter", "Filter", function( initiator, victim )
    if not victim:IsInDeathMechanics() then
        return false
    end

    if (initiator:GetJobTable() or {}).canBodyloot == false then
        return false
    end

    if (victim:GetJobTable() or {}).canBodylooted == false then
        return false
    end
end );