AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

ENT.RemoveOnJobChange = true

ENT.MinPrice = 1
ENT.MaxPrice = 100

function ENT:Initialize()
	self:SetModel('models/props_combine/suit_charger001.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:PhysWake()

	self:Setprice(20)


	timer.Simple(0, function()
		self:CPPISetOwner(self.ItemOwner)
	end)
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	if pl.LastTakenDamage and (pl.LastTakenDamage + 5) > CurTime() then
		return rp.Notify(pl, NOTIFY_ERROR, rp.Term("CantUseWhileFight"), math.floor((pl.LastTakenDamage + 5) - CurTime()))
	end

	if pl:GetMaxArmor() < 1 then

		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ArmorLabZeroMaxArmor'))
		return
	end

	local owner = self.ItemOwner
	if pl:Armor() < pl:GetMaxArmor() then
		local Cost = self:Getprice()

		if not pl:CanAfford(Cost) then 
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))
			return
		end
		
		if pl ~= owner then
			owner:AddMoney(Cost)
			rp.Notify(owner, NOTIFY_GREEN, rp.Term('ArmorLabProfit'), Cost)

			pl:AddMoney(-Cost)
			rp.Notify(pl, NOTIFY_GREEN, rp.Term('BoughtArmor'), Cost)
		end

		pl:SetArmor(pl:GetMaxArmor())
		self:EmitSound('items/suitchargeok1.wav')
	else
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ArmorLabZeroMaxArmor'))
	end
end

function ENT:OnRemove()
	self:Destruct()
	rp.Notify(self.ItemOwner, NOTIFY_ERROR, rp.Term('ArmorLabExploded'))
end


local armor_lab_jobs = {}

local function init_armor_lab_jobs()
	for k, v in pairs(rp and rp.item and rp.item.shop and rp.item.shop.entities or {}) do
		if v.uniqueID == 'armor_lab' then
			for _, j in pairs(v.allowed or {}) do
				if isnumber(j) then
					armor_lab_jobs[j] = true
				end
			end
			
			break
		end
	end
end

hook.Add("ConfigLoaded", "rp.InitMedLabJobs", init_armor_lab_jobs)
init_armor_lab_jobs()

hook.Add("OnPlayerChangedTeam", "rp.RemoveArmorLab", function(ply, t, _)
	if armor_lab_jobs[t] then
		for k, v in pairs(ents.FindByClass("armor_lab")) do
			if IsValid(v) and v:CPPIGetOwner() == ply then
				v:Remove()
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "Armor&HealthLAB", function(ent)
	if IsValid(ent) and ent:IsPlayer() then
		ent.LastTakenDamage = CurTime()
	end
end)