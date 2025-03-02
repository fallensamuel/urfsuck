
local weapon_table = {
	swb_pistol = true,
	swb_smg1 = true,
	swb_357 = true,
	swb_ar2 = true,
	swb_shotgun = true
}

local IsValid = IsValid

hook.Add("EntityTakeDamage", function(ent, dmginfo)
	if not IsValid(ent) then return end
	local attacker = dmginfo:GetAttacker()
	local pos = dmginfo:GetDamagePosition()
	if ent:GetClass() == 'prop_door_rotating' && !ent.lock && dmginfo:IsBulletDamage() then
	//if ent:IsDoor() and weapon_table[attacker:GetActiveWeapon():GetClass()] then
	
		if ent:DoorIsUpgraded() then return end
		
		local handle = ent:LookupBone("handle")
		if handle then
			if (IsValid(attacker) and pos:DistToSqr(ent:GetBonePosition(handle)) <= 144) then
				ent:DoorLock(false)
				ent:EmitSound("physics/wood/wood_plank_break"..math.random(1, 4)..".wav", 100, 120)
			end
		end
	end
end)