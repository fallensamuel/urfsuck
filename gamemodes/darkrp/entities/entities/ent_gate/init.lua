AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


ENT.Model = 'models/props_combine/combine_door01.mdl'

ENT.mins, ENT.maxs = Vector(-50,0,-95), Vector(50, 25, 90)

ENT.closeDelay = 7
ENT.useDelay = 11

ENT.IsGate = true

function ENT:Initialize()
	self:SetModel(self.Model)
	--self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetSolid(SOLID_VPHYSICS)
	--self:PhysWake()

	self.opened = false
	self.lastUsed = nil
	self.nextUse = 0

	self.invert = false


	local mins, maxs = Vector(), Vector()

	mins:Set(self.mins)
	maxs:Set(self.maxs)

	mins:Rotate(self:GetAngles())
	maxs:Rotate(self:GetAngles())

	self:PhysicsInitBox( mins, maxs )
end

function ENT:Open()
	self:SetSequence(2)
	self:ResetSequenceInfo()
	self:SetCycle( 0 )

	self.opened = true

	--self:EmitSound(self.activateSound)

	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetSolid(SOLID_NONE)
end

function ENT:Close()
	self:SetSequence(3)
	self:ResetSequenceInfo()
	self:SetCycle( 0 )

	self.opened = false

	--self:EmitSound(self.deactivateSound)

	self:SetCollisionGroup(COLLISION_GROUP_NONE)

	self:SetSolid(SOLID_BBOX)
end

function ENT:Think()
	if self.lastUsed && self.lastUsed < CurTime() then
		if !self.invert then
			if self.opened then
				self:Close()
				self.lastUsed = nil
			end
		elseif !self.opened then
			self:Open()
			self.lastUsed = nil
		end
	end
	self:NextThink( CurTime() )
	return true
end

function ENT:Use(activator)
	if (self.nextUse < CurTime()) then
		self.nextUse = CurTime() + self.useDelay
	else
		return
	end

	self.lastUsed = CurTime() + self.closeDelay

	if (activator:IsCombine()) then
		if self.opened then
			self:Close()
		else
			self:Open()
		end
	end
end

function ENT:Toggle(activator)
	if (self.nextUse < CurTime()) then
		self.nextUse = CurTime() + self.useDelay
	else
		return
	end

	self.lastUsed = CurTime() + self.closeDelay

	if self.opened then
		self:Close()
	else
		self:Open()
	end
end