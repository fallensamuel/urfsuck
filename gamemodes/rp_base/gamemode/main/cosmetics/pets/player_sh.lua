-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\pets\\player_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

function PLAYER:GetPet()
	local pet = self:GetNetVar("Pet")
	return (pet and pet > 0) and pet or false
end
