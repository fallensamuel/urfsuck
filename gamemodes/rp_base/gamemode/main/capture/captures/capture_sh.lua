
rp.Capture.ActiveCaptures    = rp.Capture.ActiveCaptures or {}
rp.Capture.ActiveCapturesMap = rp.Capture.ActiveCapturesMap or {}

function rp.Capture.IsBusy(side) 
	for __, v in pairs(rp.Capture.ActiveCaptures) do
		if v and (v:GetAttacker() == side or v:GetDefender() == side) then
			return v
		end
	end
	
	for _, v in pairs(player.GetAll()) do
		if IsValid(v) and (side == v:GetOrg() or side == v:GetAlliance()) then
			for __, c in pairs(rp.Capture.ActiveCaptures) do
				if c and c:IsPlayerParticipating(v) then
					return c
				end
			end
		end
	end
end

function rp.Capture.IsPointBusy(point)
	return point.isWar
end 

function rp.Capture.GetCaptureByUID(capture_uid)
	return rp.Capture.ActiveCapturesMap[capture_uid]
end