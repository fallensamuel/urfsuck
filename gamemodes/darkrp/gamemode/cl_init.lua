-- "gamemodes\\darkrp\\gamemode\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("sh_init.lua")

hook("InitPostEntity", function()
	LocalPlayer():ConCommand("mat_autoexposure_max 1; mat_autoexposure_min 0; mat_bloomscale 1;")
end)