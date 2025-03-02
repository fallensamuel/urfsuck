hook.Add("PlayerSpawnedProp", function(ply, mdl, ent)
	ent:Fire('SetDamageFilter', 'FilterDamage', 0)
end)

local whitelisted = {
	prop_physics = true,
	prop_physics_multiplayer = true,
}

/*
local damages = {
	[DMG_BLAST] = true,
	[DMG_BURN] = true,
}
*/

local to_check = {}
local ignited

hook.Add('Think', 'PreventDamageIgnition', function()
	if #to_check > 0 then
		ignited = table.remove(to_check, 1)
		
		if IsValid(ignited) then
			//print(ignited, 'extinguish')
			ignited:Extinguish()
		end
	end
end)

hook.Add("EntityTakeDamage", "PreventDamageIgnition", function(target, dmg)
	if IsValid(target) and whitelisted[target:GetClass()] /*and damages[dmg:GetDamageType() or -1]*/ then
		timer.Simple(0, function()
			if IsValid(target) and target:IsOnFire() then
				//target.Ignite = function() end
				table.insert(to_check, target)
			end
		end)
	end
end)