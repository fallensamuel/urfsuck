AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.FoodEnergy = 100

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:Use(activator, caller)
	if activator:IsBanned() then return end
	activator:SetHunger(activator:GetHunger() + self.FoodEnergy)
	self:Remove()
	
	StaminaResetVariables(activator)
	
	if activator:Health() < 20 then
		activator:SetHealth(20)
	end
end