-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\nick_emoji\\nick_emoji_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-- META
function PLAYER:GetNickEmoji()
	return self:GetNetVar('NickEmoji')
end

-- NETWORK
nw.Register'NickEmoji'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()
