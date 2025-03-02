AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
ENT.SeizeReward = 10
ENT.RemoveOnJobChange = true
ENT.WantReason = translates and translates.Get( 'Запрещенные предметы' ) or 'Запрещенные предметы'

function ENT:Initialize()
	self:SetModel('models/props_lab/reciever01d.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
	self:SetTrigger(true)
end

function ENT:StartTouch(ent)
	if (not self.Used) and IsValid(ent) and (ent.IsMoneyPrinter) then
		self.Used = true
		self:Remove()
		ent:SetMaxInk(ent:GetMaxInk() + 5)
		ent:SetInk(ent:GetInk() + 5)
		ent:EmitSound('ambient/energy/weld2.wav')
	end
end