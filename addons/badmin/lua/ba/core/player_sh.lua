function PLAYER:GetPlayTime()
	return (self:GetNetVar('PlayTime') or 0) + (CurTime() - (self:GetNetVar('FirstJoined') or CurTime())) * (1 + (rp.GetTimeMultiplier and rp.GetTimeMultiplier() or 0) + (self.GetTimeMultiplayer and self:GetTimeMultiplayer() or 0))
end

nw.Register 'PlayTime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'FirstJoined'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()