AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_junk/cardboard_box004a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	self:PhysWake()
end

function ENT:Use(activ, caller)
	caller:SetArmor(caller:GetMaxArmor())
	self:EmitSound('npc/combine_soldier/gear5.wav')
	self:Remove()
end
