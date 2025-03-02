-- "gamemodes\\rp_base\\gamemode\\addons\\pimpmyride\\sh_pimp.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
PIMP = PIMP or {}

function PIMP.IsCarOwned(ent, pl)
	return ent:DoorOwnedBy(pl) or (!IsValid(ent:DoorGetOwner()) and ent:CanLockUnlock(pl))
end