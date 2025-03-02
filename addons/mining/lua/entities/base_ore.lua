AddCSLuaFile()
DEFINE_BASECLASS("base_gmodentity")
ENT.PrintName = 'Base Ore'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
if CLIENT then return end

function ENT:Initialize()
	self:SetModel(self.Model);
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetMass(0.5)

	SafeRemoveEntityDelayed(self, 180)
end

