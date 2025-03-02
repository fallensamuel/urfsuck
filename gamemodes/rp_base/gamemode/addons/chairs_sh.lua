-- "gamemodes\\rp_base\\gamemode\\addons\\chairs_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACT_GMOD_SIT_ROLLERCOASTER = ACT_GMOD_SIT_ROLLERCOASTER

function rp.RegisterChair(class, t)
    t.KeyValues = {
        vehiclescript = "scripts/vehicles/prisoner_pod.txt",
        limitview = "0"
    }
    t.Members = {
        HandleAnimation = function(vehicle, player)
            return player:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER) 
        end
    }
    t.Class = "prop_vehicle_prisoner_pod"
    t.Category = "Chairs Extended"
    t.Author = "urf.im"

    list.Set("Vehicles", class, t)
end