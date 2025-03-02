AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = 'models/hunter/plates/plate4x6.mdl'
ENT.LeftOffset = Vector(55, 150, 2)
ENT.RightOffset = Vector(55, -150, 2)

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial('cyberpunkurfim/neutralshield')

	self:SetColor(Color(98,255,255))

	self.enabled = true
	self.autoClose = true
	self.invert = false
	self.delay = 15

	self.lastUsed = 0
	self.nextUse = 0

	self.Dummies = {}

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Forward(), 0)

	local dummy = ents.Create("prop_dynamic")
	dummy:SetModel('models/props_combine/combine_fence01a.mdl')
	dummy:SafeSetPos(self:LocalToWorld(self.LeftOffset))
	dummy:SetAngles(ang)
	dummy:Spawn()
	dummy:SetParent(self)
	dummy.PhysgunDisabled = true
	self:DeleteOnRemove(dummy)
	table.insert(self.Dummies, dummy)

	local dummy = ents.Create("prop_dynamic")
	dummy:SetModel('models/props_combine/combine_fence01b.mdl')
	dummy:SafeSetPos(self:LocalToWorld(self.RightOffset))
	dummy:SetAngles(ang)
	dummy:Spawn()
	dummy:SetParent(self)
	dummy.PhysgunDisabled = true
	self:DeleteOnRemove(dummy)
	table.insert(self.Dummies, dummy)

	self:SetCustomCollisionCheck(true)
	
	self:GetPhysicsObject():EnableMotion(false)
end