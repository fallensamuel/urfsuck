AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------]]
function ENT:Initialize()
	self:SetModel("models/items/healthkit.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:PhysWake()
	self:SetUseType(SIMPLE_USE)
end

--[[---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------]]
function ENT:Use(activator, caller)
	if activator:IsBanned() then return end
	self:EmitSound(Sound("HealthVial.Touch"))

	local max = activator:GetMaxHealth()
	
	if activator:Health() < max then
		activator:SetHealth(max)
	end

	self:Remove()
end