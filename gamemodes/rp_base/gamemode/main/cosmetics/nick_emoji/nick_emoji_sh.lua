
-- META
function PLAYER:GetNickEmoji()
	return self:GetNetVar('NickEmoji')
end

-- NETWORK
nw.Register'NickEmoji'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()
