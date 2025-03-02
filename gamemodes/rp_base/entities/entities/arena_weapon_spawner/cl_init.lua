-- "gamemodes\\rp_base\\entities\\entities\\arena_weapon_spawner\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

function ENT:Initialize()
end

function ENT:OnRemove()
	if IsValid(self.WeaponEnt) then
		self.WeaponEnt:Remove()
	end
	
	if IsValid(self.LightEnt) then
		self.LightEnt:Remove()
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
		
		if IsValid(self.LightEnt) then
			self.LightEnt:Remove()
		end
		
		return 
	end
	
	if not IsValid(self.WeaponEnt) then
		wep = weapons.GetStored(rp.cfg.Arena.weapon_spawns[game.GetMap()][self:GetWeaponID()].weapon)
		if not wep then return end
		
		self.WeaponEnt = ClientsideModel(wep.WorldModel)
		self.WeaponEnt:SetPos(self:GetPos() + Vector(0, 0, 32))
	end
	
	if not IsValid(self.LightEnt) then
		self.LightEnt = ClientsideModel('models/effects/vol_light128x128.mdl')
		self.LightEnt:SetPos(self:GetPos())
		self.LightEnt:SetModelScale(0.5)
		self.LightEnt:SetAngles( Angle(0, 0, 180) );
		self.LightEnt:SetColor( Color(180, 100, 0, 100) );
	end
	
	self.WeaponEnt:SetAngles(self.WeaponEnt:GetAngles() + Angle(0, 0.3, 0))
	self.WeaponEnt:SetPos(self:GetPos() + Vector(0, 0, 32 + math.sin(CurTime()) * 5))
	
	//self:DrawModel()
end
