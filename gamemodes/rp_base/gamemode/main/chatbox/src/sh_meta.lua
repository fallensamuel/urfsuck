PLAYER.OldIsTyping = PLAYER.OldIsTyping or PLAYER.IsTyping

nw.Register 'IsTyping'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

function PLAYER:IsTyping()
	return self:GetNetVar("IsTyping") or false
end