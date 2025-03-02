local disabled = rp.cfg.DisableStamina

function PLAYER:GetMaxStamina()
	return disabled and 100 or (self:GetJobTable() && self:GetJobTable().stamina && self:GetJobTable().stamina * rp.cfg.MaxStamina or rp.cfg.MaxStamina)
end

nw.Register 'LastDamageTime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()