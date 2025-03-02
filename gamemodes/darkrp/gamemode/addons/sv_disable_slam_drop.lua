-- "gamemodes\\darkrp\\gamemode\\addons\\sv_disable_slam_drop.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("CanDropWeapon", function(pl, ent)
	if ent:GetClass() == "weapon_slam" then return false end
end)