
local physguns = {
	weapon_physgun = true,
}

local premiums = { ['31'] = true, ['global_prem'] = true }
function PLAYER:HasPremium()
	local g_rank = self:GetNetVar('GlobalRank')
	return g_rank and (isstring(g_rank) and premiums[g_rank] or isnumber(g_rank) and premiums['' .. g_rank]) or false
end

local pg_data
hook.Add('PreDrawViewModel', 'test_phys', function(vm, pl, wep)
	if IsValid(pl) and pl:HasPremium() and IsValid(wep) and physguns[wep:GetClass()] then
		pg_data = pl:GetCustomPhysgun()
		
		if pg_data then
			vm:SetModel(pg_data.vmodel) 
		end
	end
end)

local wep
hook.Add('PrePlayerDraw', 'test_phys', function(pl)
	if IsValid(pl) and pl:HasPremium() then
		wep = pl:GetActiveWeapon()
		if IsValid(wep) and physguns[wep:GetClass()] then
			pg_data = pl:GetCustomPhysgun()
			
			if pg_data and pg_data.wmodel then
				wep:SetModel(pg_data.wmodel) 
			end
		end
	end
end)

hook.Add('PreDrawPlayerHands', 'test_phys', function(hands, vm, pl, wep)
	if IsValid(pl) and pl:HasPremium() and IsValid(wep) and physguns[wep:GetClass()] then
		pg_data = pl:GetCustomPhysgun()
		
		if pg_data and not pg_data.use_hands then
			return true
		end
	end
end)
