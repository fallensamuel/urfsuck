
rp.meta.capture_action = {}
rp.meta.capture_action.__index = rp.meta.capture_action


function rp.meta.capture_action:SetPoint(point)
	self.point = point
end

function rp.meta.capture_action:SetEndingTime(ending_time)
	self.EndingTime = ending_time
end

function rp.meta.capture_action:SetCaptureTime(capture_time)
	self.CaptureTime = capture_time
end

function rp.meta.capture_action:SetAttacker(attacker)
	self.Attacker = attacker
end

function rp.meta.capture_action:SetDefender(defender)
	self.Defender = defender
end

function rp.meta.capture_action:SetScore(score)
	self.Score = score
end

function rp.meta.capture_action:SetIsOrg(is_org)
	self.is_org = is_org
end

function rp.meta.capture_action:SetMaxDuration(time)
	self.MaxDuration = time
end

function rp.meta.capture_action:Remove()
	self:SetEndingTime(CurTime())
	
	rp.Capture.ActiveCaptures[self.ID] = nil
	rp.Capture.ActiveCapturesMap[self.UID] = nil
end


function rp.meta.capture_action:GetPoint()
	return self.point
end

function rp.meta.capture_action:GetAttacker()
	return self.Attacker
end

function rp.meta.capture_action:GetDefender()
	return self.Defender or self.point.owner
end

function rp.meta.capture_action:IsOrg()
	return self.is_org
end

function rp.meta.capture_action:IsPointAttacker(ply)
	--return IsValid(ply) and (self:IsOrg() and self:GetAttacker() == ply:GetOrg() and ply:IsOrgAllowedCapture() or not self:IsOrg() and self:GetAttacker() == ply:GetAlliance())
	return IsValid(ply) and ply:CanCapture() and (self:IsOrg() and ply:OrgCanCapture() and self:GetAttacker() == ply:GetOrg() or not self:IsOrg() and self:GetAttacker() == ply:GetAlliance())
end

function rp.meta.capture_action:IsPointDefender(ply)
	--return IsValid(ply) and (self:IsOrg() and self:GetDefender() == ply:GetOrg() and ply:IsOrgAllowedCapture() or not self:IsOrg() and (self:GetDefender() == ply:GetAlliance() or rp.ConjGet(ply:GetAlliance(), self:GetDefender()) == CONJ_UNION))
	return IsValid(ply) and ply:CanCapture() and (self:IsOrg() and ply:OrgCanCapture() and self:GetDefender() == ply:GetOrg() or not self:IsOrg() and (self:GetDefender() == ply:GetAlliance() or rp.ConjGet(ply:GetAlliance(), self:GetDefender()) == CONJ_UNION))
end

function rp.meta.capture_action:GetScore() 
	return self.Score or 0
end

function rp.meta.capture_action:GetMaxScore() 
	return self.MaxScore or 0
end

function rp.meta.capture_action:GetEndingTime() 
	return self.EndingTime or 0
end

function rp.meta.capture_action:GetCaptureTime()
	 return self.CaptureTime or (CurTime() + 60)
end

function rp.meta.capture_action:GetActionMode() 
	return self.ActionMode or 0
end

function rp.meta.capture_action:GetMaxDuration()
	return self.MaxDuration or 0
end

function rp.meta.capture_action:IsPlayerParticipating(ply) 
	return (self:IsPointAttacker(ply) or self:IsPointDefender(ply))
end
