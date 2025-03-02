local timer = timer

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.RemoveOnJobChange = true
ENT.LazyFreeze = true

ENT.SeizeReward = false
ENT.WantReason = translates and translates.Get( 'Наркотики' ) or 'Наркотики'

AccessorFunc(ENT, 'stage', 'Stage')

local function Stages(self)
	if not IsValid(self) then return end

	timer.Create('WeedPlant' .. self:EntIndex(), 25, 4, function()
		if not IsValid(self) then return end
		self:SetStage(self:GetStage() + 1)
		self:SetModel('models/alakran/marijuana/marijuana_stage' .. self:GetStage() .. '.mdl')

		self.SeizeReward = self:GetStage() * 8

		if self:GetStage() == 5 then
			self.isUsable = true
		end
	end)
end

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:PhysWake()
	self.isUsable = false
	self.isPlantable = false
	self.damage = 60
	self:SetModel('models/alakran/marijuana/marijuana_stage1.mdl')
	self:SetStage(1)
	Stages(self);
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if self.damage <= 0 then
		self:Remove()
	end
end

function ENT:Use(activator, caller)
	if activator:IsBanned() then return end
	if not IsValid(activator) or not activator:IsPlayer() then return end

	if not self.isUsable then
		return
	end

	if self.isUsable == true then
		self.isUsable = false
		self.isPlantable = false
		self:SetModel('models/alakran/marijuana/marijuana_stage1.mdl')
		local SpawnPos = self:GetPos() + Vector(0, 0, 30)
		
		rp.item.spawn('durgz_weed', SpawnPos, function(item, entity)
			local phys = entity:GetPhysicsObject()
			
			if IsValid(phys) then
				phys:EnableMotion(true)
				phys:Wake()
			end
		end)
		
		/*
		local WeedBag = ents.Create('durgz_weed')
		WeedBag:SetPos(SpawnPos)
		WeedBag:Spawn()
		*/
		
		self:SetStage(1)
		self.SeizeReward = nil
		timer.Remove('WeedPlant' .. self:EntIndex())
		Stages(self)
	end
end

function ENT:OnRemove()
	timer.Remove('WeedPlant' .. self:EntIndex())
end