AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.MaxHealth = 1
ENT.RechargeTime = 1
ENT.Model = 'models/rarerocks/crystal2.mdl'
ENT.DamageIncomeMultiplayer = 1

--ENT.Ores = {"ore_copper"}

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)

	self.health = self.MaxHealth
	self.mutiplier = 1

	self.RechargeTimeMin = self.RechargeTime * 0.9
	self.RechargeTimeMax = self.RechargeTime * 1.1
end

function ENT:GetRechargeTime()
	return math.random(self.RechargeTimeMin, self.RechargeTimeMax)
end

local damage, mutiplier
function ENT:OnTakeDamage(dmg)
	if dmg:GetInflictor() and dmg:GetInflictor():GetClass() == "weapon_pickaxe" and dmg:GetDamage() > 0 then
		
		--[[
		if self:GetBonusPos() and dmg:GetDamagePosition():DistToSqr(self:LocalToWorld(self:GetBonusPos())) < 100 then
			mutiplier = 2
			self:SelectBonusPos()
		end
		
		if dmg:GetAttacker() and dmg:GetAttacker():GetOrg() and dmg:GetAttacker():GetOrg() == rp.Capture.Points[2].owner then
			mutiplier = mutiplier + 1
		end
		]]--
		
		damage = dmg:GetDamage() * self.mutiplier
		self.health = self.health - damage

		--[[
		dmg:GetAttacker():AddMoney(damage * self.DamageIncomeMultiplayer * 50)
		rp.Notify(dmg:GetAttacker(), NOTIFY_GREEN, rp.Term((mutiplier == 1) and 'MiningIncome' or 'MiningBonus'), damage * self.DamageIncomeMultiplayer * 50)
		]]--

		if self.health <= 0 then
			self:Disable()
		end
	end
end

function ENT:GetOre()
	return table.Random(self.Ores)
end

--local vec = Vector(0, 0, 25)
--function ENT:SpawnOre()
--	self:Disable()
--
--	self.disabled = CurTime() + self:GetRechargeTime()
--
--	local ore_class = self:GetOre()
--	
--	local ore = ents.Create(ore_class)
--	ore:SafeSetPos(self:GetPos() + vec)
--	ore:Spawn()
--	ore:Activate()
--end

function ENT:Think()
	if self.disabled && self.disabled < CurTime() then
		self:Enable()
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:Enable()
	self:SetNotSolid(false)
	self:SetNoDraw(false)
	self.disabled = nil
	self.health = self.MaxHealth
end

function ENT:Disable()
	self.disabled = CurTime() + self:GetRechargeTime()
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	for Index, Entity in pairs(self:GetChildren()) do
		if (IsValid(Entity)) then
			Entity:Remove();
		end
	end
end

