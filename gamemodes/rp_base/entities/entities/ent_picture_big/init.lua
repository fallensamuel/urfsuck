AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/hunter/plates/plate2x2.mdl')
	self:SetMaterial('models/debug/debugwhite')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self:SetURL('http://urf.im/urflogo.png')

	timer.Simple(0, function()
		if IsValid(self.ItemOwner) then
			self:CPPISetOwner(self.ItemOwner)
		end
	end)
end