	

AddCSLuaFile()
DEFINE_BASECLASS("base_gmodentity")


ENT.Spawnable = true
ENT.Category = "Gifts"
ENT.PrintName = "Gift"

if SERVER then
	ENT.IsGift = true

	function ENT:Initialize()
		self:SetModel(table.Random({'models/christmas_gift2/christmas_gift2.mdl'}, {'models/christmas_gift/christmas_gift.mdl'}))
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetUseType(SIMPLE_USE)
		self:PhysWake()
	end

	function ENT:Use(ply)
		if !(self.Used && ply:IsPlayer()) then
			self.Used = true
			if !self.Action then
				ba.notify(ply, 'Админ такой тупой, что не настроил подарок, позови его, он исправит!')
				return
			end
			self:Action(ply)
			self:Remove()
		end
	end
end

