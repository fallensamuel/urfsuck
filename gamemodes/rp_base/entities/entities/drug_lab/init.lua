AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('rp.DrugLabMenu')
util.AddNetworkString('rp.DrugLabCreate')
ENT.SeizeReward = 50
ENT.WantReason = translates and translates.Get( 'Нелегальные вещи (Мини лаборатория)' ) or 'Нелегальные вещи (Мини лаборатория)'
ENT.LazyFreeze = true
ENT.RemoveOnJobChange = true

function ENT:Initialize()
	self:SetModel('models/props_lab/crematorcase.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysWake()
	self.HP = 100
end

function ENT:OnTakeDamage(dmg)
	self.HP = self.HP - dmg:GetDamage()

	if (self.HP <= 0) then
		self:Explode()
	end
end

function ENT:Explode()
	timer.Remove(self:EntIndex() .. 'Drug')
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)
	self:Remove()

	if IsValid(self.ItemOwner) then
		rp.Notify(self.ItemOwner, NOTIFY_ERROR, rp.Term('DrugLabExploded'))
	end
end

function ENT:CraftDrug(class)
	local time = math.random(60, 180)
	self:SetCraftTime(CurTime() + time)
	self:SetCraftRate(time)

	timer.Create(self:EntIndex() .. 'Drug', time, 1, function()
		if IsValid(self) then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(1)
			effectdata:SetScale(1)
			effectdata:SetRadius(2)
			util.Effect('Sparks', effectdata)
			
			--[[
			local e = ents.Create(class)
			e:SetPos(self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 20)))
			e:Spawn()
			e:Activate()
			]]
			
			rp.item.spawn(class, self:GetPos() + ((self:GetAngles():Up() * 15) + (self:GetAngles():Forward() * 20)))
		end
	end)
end

function ENT:Use(pl)
	if pl:IsBanned() or (pl.LastDrugLabUse and (pl.LastDrugLabUse > CurTime())) then return end
	pl.LastDrugLabUse = CurTime() + 1
	net.Start('rp.DrugLabMenu')
	net.WriteEntity(self)
	net.Send(pl)
end

net.Receive('rp.DrugLabCreate', function(len, pl)
	local ent = net.ReadEntity()
	local class = net.ReadUInt(8)
	if (not IsValid(ent)) or (ent:GetClass() ~= 'drug_lab') or (not rp.Drugs[class]) or (ent:GetPerc() < 1) or (ent:GetPos():Distance(pl:GetPos()) >= 80) then return end
	ent:CraftDrug(rp.Drugs[class].Class)
end)