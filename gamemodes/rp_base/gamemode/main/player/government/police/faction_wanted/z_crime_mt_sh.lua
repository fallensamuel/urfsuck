
if not rp.cfg.NewWanted then return end

rp.meta.crime = {}
rp.meta.crime.__index = rp.meta.crime


function rp.meta.crime:SetStars(stars)
	self.Stars = stars
	return self
end

function rp.meta.crime:SetPoliceFactions(police_factions)
	self.PoliceFactions = police_factions
	return self
end

function rp.meta.crime:IsInPoliceFaction(ply)
	if not ply:GetFaction() then 
		return false 
	end
	
	local mf = rp.police.GetFaction(ply:GetFaction())
	
	if not mf then 
		return false 
	end
	
	for k, v in pairs(self.PoliceFactions or {}) do
		if mf.ID == v then
			return true
		end
	end
	
	return false
end

function rp.meta.crime:SetVictimCheck(check_func)
	self.VictimCheck = check_func
	return self
end

function rp.meta.crime:IsValidVictim(ply)
	return self.VictimCheck and self.VictimCheck(self, ply) or false
end

function rp.meta.crime:IsValidTarget(ply)
	if not IsValid(ply) or not ply:GetFaction() then
		return false
	end
	
	for k, v in pairs(self.PoliceFactions or {}) do
		if rp.police.Factions[v] and rp.police.Factions[v].can_want[ply:GetFaction()] then
			return true
		end
	end
	
	return false
end

function rp.meta.crime:SetHook(name, cback)
	hook.Add(name, function(...)
		cback(self, ...)
	end)
	
	return self
end

function rp.meta.crime:Apply(ply, police_faction)
	local factions
	local dummy_faction
	
	if not police_faction then
		factions = self.PoliceFactions
		
	else
		factions = istable(police_faction) and police_faction or {police_faction}
	end
	
	for k, v in pairs(factions or {}) do
		if not rp.police.Factions[v] then
			continue 
		end
		
		dummy_faction = rp.police.Factions[v].Factions[1]
		
		for i = 1, self.Stars or 1 do
			if ply:IsWanted(dummy_faction) then
				ply:AddWantedStar(nil, self.Name, dummy_faction, i > 1)
				
			else
				ply:Wanted(nil, self.Name, dummy_faction, i > 1)
			end
		end
	end
end
