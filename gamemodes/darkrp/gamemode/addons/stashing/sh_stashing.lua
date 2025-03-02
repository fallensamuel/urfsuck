-- "gamemodes\\darkrp\\gamemode\\addons\\stashing\\sh_stashing.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Stashing = rp.Stashing or {};

rp.Stashing.Config = {
    Messages = {
        ["ERR_ALREADY_IN_CHALLENGE"] = translates.Get( "Вы уже закладываете закладку" ),
        ["ERR_SPOTS_NOT_AVAILABLE"] = translates.Get( "Вы не можете заложить закладку" ),
        ["ERR_NO_SPOT"] = translates.Get( "Нет доступной точки закладки" ),
        ["ERR_INTERRUPT"] = translates.Get( "Вам помешали заложить закладку" ),
        ["ERR_NOT_ALIVE"] = translates.Get( "Вы не можете заложить закладку мертвым" ),
        ["ERR_KNOCKED_DOWN"] = translates.Get( "Вы не можете заложить закладку находять при смерти!" ),
        ["ERR_TOO_FAR"] = translates.Get( "Точка закладки была отмечена на экране" ),
        ["ERR_NOT_IN_CHALLENGE"] = translates.Get( "Вы не закладываете закладку" ),
    },

    Spots = {
        Radius = 76,
        ["gm_construct"] = { Vector(0, 0, 0) },
    },

    Challenge = {
        Rate = 1 / 4,

        Length = 30,

        Alert = {
            Rate = 2 / 1,
            Chance = 0.75,
            Sounds = { "physics/cardboard/cardboard_box_shake1.wav", "physics/cardboard/cardboard_box_shake2.wav", "physics/cardboard/cardboard_box_shake3.wav" }
        }
    },

    Circles = {
        Rate = 1 / 2,
        Radius = 0.075,
        Overscale = 6,
        Lifetime = 1.33,
        Bonus = 0.1,
        Sound = "ui/buttonclick.wav"
    },
};

function rp.Stashing:GetMessage( message )
    return self.Config.Messages[message] or message;
end

hook.Add( "ConfigLoaded", "rp.Stashing::Config", function()
    local status, config = pcall( function()
        return rp.cfg.Stashing or {};
    end );

    if not status then
        return
    end

    table.Merge( rp.Stashing.Config, config );
end );