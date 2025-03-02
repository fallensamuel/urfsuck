AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/props_lab/reciever01a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:Wake()
	end
	
	self.once_print = false
	self.wasActivated = false
	self.friend_list = {}
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:SetUseType(SIMPLE_USE)
	ent:SetActive(false)

	
	return ent
end

function ENT:Use(activator, caller)
	if caller:IsValid() and self:GetOwner() == caller then
		if self.wasActivated == true then
			self.wasActivated = false
			self.once_print = false

			for k,v in pairs (ents.FindInSphere(self:GetPos(), self.radius or 512)) do
				if v:IsPlayer() and v != self:GetOwner() then
					self.friend_list = self.friend_list or {}
					table.insert(self.friend_list, v)
				end
			end
		end
	end
end

// Что-бы меньше было флуда. Все таки think хук же
-- rp.AddTerm("SignalizationWasActivated", "Сработала Сигнализация #")
function ENT:NicePrint()
	if self.once_print == false then
		rp.Notify(self:GetOwner(), NOTIFY_GREEN , rp.Term('SignalizationWasActivated'), self.name)
		self.once_print = true
	end
end

// DEBUG
-- local meta = FindMetaTable("Player")

-- function meta:GetFaction()
-- 	return self:IsBot() and 0 or 1
-- end

-- function meta:GetOrg()
-- 	return self:IsBot() and "LOL" or "LOL"
-- end

// Выполняется каждые 2 секунду. Вполне достатоточно.
// Хотел поставить 3 секунды но потом подумал что это слишком медленно
function ENT:Think()
	self:NextThink(CurTime() + 2)
	
	if (self.friend_list) and (istable(self.friend_list)) and (not table.IsEmpty(self.friend_list)) then
		for k,v in pairs (self.friend_list) do			
			if not table.HasValue(ents.FindInSphere(self:GetPos(), self.radius or 512), v) then
				table.RemoveByValue(self.friend_list, v)
			end
		end
	end
	
	if self.wasActivated == true then
		if not rp.cfg.DisableSignalizationSound then self:EmitSound(self.beepsound) end
	else
		for k,v in pairs (ents.FindInSphere(self:GetPos(), self.radius or 512)) do
			if v:IsPlayer() and self:GetOwner() != v then
				if table.HasValue(self.friend_list or {}, v) then return end
				if self.wasActivated == false then 
					if (!self.ignore_frac or self:GetOwner():GetFaction() != v:GetFaction()) and (!self.ignore_org or self:GetOwner():GetOrg() != v:GetOrg()) then
						if not rp.cfg.DisableSignalizationSound then self:EmitSound(self.beepsound) end
						self.wasActivated = true
						if self.name then
							self:NicePrint()
						end
					end
				end
			end
		end
	end

	return true
end
