AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.activateSound = Sound('buttons/combine_button3.wav')
ENT.deactivateSound = Sound('buttons/combine_button5.wav')

ENT.Model = 'models/props_combine/breenconsole.mdl'
ENT.useDelay = 1

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysWake()

	self.nextUse = 0

end

function ENT:Use(activator)
	if (self.nextUse > CurTime()) then return end

	if !self.ents then
		self.ents = {}
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
			if v.IsGate then
				table.insert(self.ents, v)
			end
		end
	end
	
	for k, v in pairs(self.ents) do
		v:Toggle(activator)
	end

	self.nextUse = CurTime() + self.useDelay
end