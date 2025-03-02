-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\custom_toolguns\\nw_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function PLAYER:SetCustomToolgun(class)
	local index = class and rp.ToolGunSWEPS_k[class]
	self:SetNetVar("Toolgun", index)

	if CLIENT then return end

	for k, tab in pairs(rp.ToolGunSWEPS) do
		self:StripWeapon(istable(tab) and tab.class or tab)
	end

	local class = index and (rp.ToolGunSWEPS[index] and rp.ToolGunSWEPS[index].class) or "gmod_tool"
	self:Give(class, true)
end

function PLAYER:GetCustomToolgun() -- LocalPlayer only
	return self:GetNetVar("Toolgun")
end