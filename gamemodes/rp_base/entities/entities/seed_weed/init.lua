rp.include_cl'cl_init.lua'
rp.include_sh'shared.lua'
ENT.MaxHealth = 100
ENT.HighLagRisk = true

function ENT:Initialize()
	self:SetModel('models/Items/AR2_Grenade.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end