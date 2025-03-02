-- "gamemodes\\rp_base\\gamemode\\main\\player\\hitmen\\hitmen_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function PLAYER:HasHit()
	return (self:GetNetVar('HitPrice') ~= nil)
end

function PLAYER:GetHitPrice()
	return self:GetNetVar('HitPrice')
end

nw.Register 'HitPrice'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)