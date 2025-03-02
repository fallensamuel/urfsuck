local mVec = FindMetaTable("Vector")
local Dot, GetNormalized = mVec.Dot, mVec.GetNormalized
local ENTITY = FindMetaTable("Entity")
local EyeAngles, EyePos, GetPos = ENTITY.EyeAngles, ENTITY.EyePos, ENTITY.GetPos
local mAng = FindMetaTable("Angle")
local Forward = mAng.Forward

function ENTITY:IsInFovOf(ent)
    return Dot(Forward(EyeAngles(self)), GetNormalized(GetPos(ent) - EyePos(self))) > 0.25
end
function PLAYER:IsRunning()
	return self:IsOnGround() and not self:InVehicle() and self:GetVelocity():Length() >= self:GetRunSpeed()
end

function rp.FindPlayer(info)
	if not info or (info == '') then return end
	info = tostring(info)

	for _, pl in ipairs(player.GetAll()) do
		if (info == pl:SteamID()) then
			return pl
		elseif (info == pl:SteamID64()) then
			return pl
		elseif string.find(string.lower(pl:Name()), string.lower(info), 1, true) ~= nil then
			return pl
		end
	end
end

function PLAYER:GetMaxArmor()
	return (self:GetJobTable().armor or 0) + (self:HasUpgrade("armor") and self:GetUpgradeCount("armor")*33 or 0)
end

if CLIENT then
	function rp.SendMoney(ply, amount)
		amount = math.floor(amount)
		net.Start("GivePlayerMoney")
			net.WriteEntity(ply)
			net.WriteUInt(amount, 32)
		net.SendToServer()
	end
end