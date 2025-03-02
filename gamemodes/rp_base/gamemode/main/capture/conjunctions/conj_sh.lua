CONJ_NEUTRAL	= 0
CONJ_WAR 		= 1
CONJ_UNION 		= 2

function rp.ConjSetInvalid(allc1, state, allcs) 
	local all_allcs = isnumber(allcs) and {allcs} or allcs
	
	local real_allc = rp.Capture.Alliances[allc1]
	if not real_allc then return end
	
	real_allc.conj_invalid = real_allc.conj_invalid or {}
	
	for k, v in ipairs(all_allcs) do
		local real_v = rp.Capture.Alliances[v]
		if not real_v then continue end
		
		real_v.conj_invalid = real_v.conj_invalid or {}
		real_v.conj_invalid[allc1] 	= real_v.conj_invalid[allc1] or {}
		real_allc.conj_invalid[v] 	= real_allc.conj_invalid[v] or {}
		
		real_v.conj_invalid[allc1][state]	= true
		real_allc.conj_invalid[v][state] 	= true
	end
end

function rp.ConjGet(alliance1, alliance2) 
	if not rp.Capture.Alliances[alliance1] then return CONJ_NEUTRAL end
	return rp.Capture.Alliances[alliance1].conjes[alliance2] or CONJ_NEUTRAL
end

function rp.ConjIsInvalid(alliance1, alliance2, state)
	if not rp.Capture.Alliances[alliance1] then return false end
	return rp.Capture.Alliances[alliance1].conj_invalid[alliance2] && rp.Capture.Alliances[alliance1].conj_invalid[alliance2][state]
end

function rp.ConjGetName(state)
	return state == CONJ_WAR and translates.Get("Война") or state == CONJ_UNION and translates.Get("Союз") or translates.Get("Нейтралитет")
end

function rp.ConjGetColor(state)
	return state == CONJ_WAR and rp.col.Red or state == CONJ_UNION and rp.col.Green or rp.col.Grey
end