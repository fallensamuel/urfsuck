function PLAYER:TeamUnlocked(t)
	return IsValid(self) and istable(t) and (self:IsVIP() or not t.unlockPrice or t.command and self:GetNetVar('JobUnlocks') and self:GetNetVar('JobUnlocks')[t.command])
end