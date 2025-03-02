
function PLAYER:GetAlliance()
	return rp.Capture.AlliancesFactionMap[self:GetFaction()]
end

function PLAYER:GetAllianceTable()
	return rp.Capture.Alliances[self:GetAlliance()]
end

function PLAYER:OrgCanCapture() 
	return self:GetOrg() and not (rp.cfg.CantCapture and rp.cfg.CantCapture[self:Team()]) or false 
end

function PLAYER:CanCapture() return true end
function PLAYER:IsOrgAllowedCapture() return true end
