-- "gamemodes\\rp_base\\gamemode\\addons\\like_reactions\\sh_main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function PLAYER:GetLikeReacts()
	return self:GetNetVar("LikeReacts") or 0
end

function PLAYER:HasLikeReact(ofply)
	if CLIENT then return self.LikeReacted or false end
	if SERVER and IsValid(ofply) == false then return false end

	return (self.LikeReacts or {})[ofply:SteamID64()] or false
end