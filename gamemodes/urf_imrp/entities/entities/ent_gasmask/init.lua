AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tnb/items/gasmask.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysWake()
end

function ENT:Use(pl)
	if self.used then return end
	if pl:GetJobTable().canWear then
		pl:SetBodygroup(4, 2)
		pl:SetBodygroup(1, 1)
		pl:SetBodygroup(3, 1)
		self.used = true
		self:Remove()
		pl:Notify(NOTIFY_GREEN, rp.Term('WearUsed'))
	else
		pl:Notify(NOTIFY_ERROR, rp.Term('CantWear'))
	end
end