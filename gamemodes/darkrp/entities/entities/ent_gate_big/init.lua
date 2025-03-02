AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.doorLoop = Sound('doors/doormove1.wav')
ENT.deactivateSound = Sound('doors/doormove3.wav')

ENT.Model = 'models/combine_gate_Vehicle.mdl'

ENT.mins, ENT.maxs = Vector(16,-135,-30), Vector(50, 135, 165)

ENT.closeDelay = 40
ENT.useDelay = 8

ENT.openSoundDelay = 2.7
ENT.closeSoundDelay = 4.8
ENT.stopSound = 0

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.sound = CreateSound(self, self.doorLoop)
end

function ENT:Open()
	self.BaseClass.Open(self)
	self.emitClose = false

	self.sound:Play()

	self.stopSound = CurTime() + self.openSoundDelay

	self:SetSolid(SOLID_NONE)
end

function ENT:Close()
	self.BaseClass.Close(self)
	self.emitClose = false

	self.sound:Play()

	self.stopSound = CurTime() + self.closeSoundDelay

	self:SetSolid(SOLID_NONE)
end

function ENT:Use(activator)

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

function ENT:Think()


	--if CurTime() % 5 == 0 then
	--	local mins, maxs = Vector(16,-135,-30), Vector(50, 135, 165)
	--	mins:Rotate(self:GetAngles())
	--	maxs:Rotate(self:GetAngles())
	--	self:PhysicsInitBox( mins, maxs )
	--	
	--end
	if !self.emitClose && self.stopSound < CurTime() then
		self.sound:Stop()
		self:EmitSound('doors/door_metal_large_chamber_close1.wav')
		self.emitClose = true

		if !self.opened then
			self:SetSolid(SOLID_BBOX)
		end
	end

	return self.BaseClass.Think(self)
end