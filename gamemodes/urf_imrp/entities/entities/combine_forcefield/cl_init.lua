include("shared.lua")

ENT.PrintName = "Поле Альянса - Малое"
ENT.Category = "Half-Life Alyx RP"

function ENT:Initialize()
	self:SetCustomCollisionCheck(true)
end

function ENT:Think()
	self:CollisionRulesChanged()
	
	self:NextThink( CurTime() + 5 )
	return true
end

ENT.isForceField = true