-- "gamemodes\\darkrp\\gamemode\\addons\\stalker\\sh_exoskeleton.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register'IsInExoskeleton':Write(net.WriteBool):Read(net.ReadBool):SetLocalPlayer()

function PLAYER:IsInExoskeleton()
	return IsValid(self) and (self:GetJobTable() and self:GetJobTable().exoskeleton or self:GetNetVar('IsInExoskeleton'))
end

hook.Add("PlayerDeath", function(ply)
	if ply:GetNetVar('IsInExoskeleton') then
		ply:SetNetVar('IsInExoskeleton', nil)
	end
end)

hook.Add("OnPlayerChangedTeam", function(ply)
	if ply:GetNetVar('IsInExoskeleton') then
		ply:SetNetVar('IsInExoskeleton', nil)
	end
end)