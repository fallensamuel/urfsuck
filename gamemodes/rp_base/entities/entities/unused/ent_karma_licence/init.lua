AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/bindergreen.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	if pl.nextCarma or 0 > CurTime() then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('KarmaCooldown'))
	else
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('KarmaAdeed'))
		pl:AddKarma(20)
	end
	

	pl.nextCarma = CurTime() + 3600

	self:Remove()
end


