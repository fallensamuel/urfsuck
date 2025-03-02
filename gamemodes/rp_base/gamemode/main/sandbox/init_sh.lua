cleanup.Register("props")
cleanup.Register("ragdolls")
cleanup.Register("effects")
cleanup.Register("npcs")
cleanup.Register("constraints")
cleanup.Register("ropeconstraints")
cleanup.Register("sents")
cleanup.Register("vehicles")

function GM:PlayerNoClip(pl, on)
	return false
end

if (SERVER) then
	function GM:PlayerShouldTakeDamage(ply, attacker)
		return true
	end

	function GM:CreateEntityRagdoll(entity, ragdoll)
		-- Replace the entity with the ragdoll in cleanups etc
		undo.ReplaceEntity(entity, ragdoll)
		cleanup.ReplaceEntity(entity, ragdoll)
	end

	function GM:CanEditVariable(ent, ply, key, val, editor)
		return false
	end

	return
end

function GM:OnUndo(name, strCustomString)
	notification.AddLegacy((strCustomString and strCustomString or "#Undone_" .. name), NOTIFY_UNDO, 2)
	surface.PlaySound("buttons/button15.wav")
end

function GM:OnCleanup(name)
	notification.AddLegacy("#Cleaned_" .. name, NOTIFY_CLEANUP, 5)
	surface.PlaySound("buttons/button15.wav")
end


-- Disable HL2 Weapons spawn
local HL2_Weapons = {
	["weapon_crowbar"]		= true,
	["weapon_pistol"]		= true,
	["weapon_smg1"]			= true,
	["weapon_357"]			= true,
	["weapon_physcannon"]	= true,
	["weapon_shotgun"]		= true,
	["weapon_ar2"]			= true,
	["weapon_rpg"]			= true,
	["weapon_frag"]			= true,
	["weapon_crossbow"]		= true,
	["weapon_bugbait"]		= true,
	["weapon_slam"] 		= true,
	["weapon_stunstick"] 	= true,
}

local Spawnable = list.Get("Weapon")
for k, v in pairs(Spawnable) do
	if HL2_Weapons[k] then
		v.Spawnable = false
		list.Set("Weapon", k, v)
	end
end