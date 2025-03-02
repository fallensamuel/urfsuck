AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------]]
function ENT:Initialize()
	self:SetModel('models/custom/ballisticshield.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
end

--[[---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------]]
function ENT:Use(activator, caller)
	if activator:IsBanned() then return end
	activator:Give('weapon_shield')
	self:Remove()
end