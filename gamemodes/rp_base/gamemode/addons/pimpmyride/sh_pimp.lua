PIMP = PIMP or {}

function PIMP.IsCarOwned(ent, pl)
	return ent:DoorOwnedBy(pl) or (!IsValid(ent:DoorGetOwner()) and ent:CanLockUnlock(pl))
end