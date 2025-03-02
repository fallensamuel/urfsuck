include('shared.lua')

function ENT:Initialize()
end

function ENT:OnRemove()
	if IsValid(self.WeaponEnt) then
		self.WeaponEnt:Remove()
	end
end

local job, wep
function ENT:Draw()
	if not IsValid(LocalPlayer()) or not self:GetWeaponID() then
		return
	end
	
	if not job then
		job = rp.cfg.Arena.job()
	end
	
	if LocalPlayer():Team() ~= job or self:GetUsedUntil() and self:GetUsedUntil() > CurTime() then 
		if IsValid(self.WeaponEnt) then
			self.WeaponEnt:Remove()
		end
		
		return 
	end
	
	if not IsValid(self.WeaponEnt) then
		wep = weapons.GetStored(rp.cfg.Arena.weapon_spawns[game.GetMap()][self:GetWeaponID()].weapon)
		if not wep then return end
		
		self.WeaponEnt = ClientsideModel(wep.WorldModel)
		self.WeaponEnt:SetPos(self:GetPos() + Vector(0, 0, 32))
	end
	
	self.WeaponEnt:SetAngles(self.WeaponEnt:GetAngles() + Angle(0, 0.3, 0))
	self.WeaponEnt:SetPos(self:GetPos() + Vector(0, 0, 32 + math.sin(CurTime()) * 5))
	
	self:DrawModel()
end
