AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/effects/vol_light128x128.mdl") 
	self:SetModelScale(0.5)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

function ENT:GiveArenaWeapon(ply)
	if self:GetUsedUntil() and self:GetUsedUntil() > CurTime() then return end
	self:SetUsedUntil(CurTime() + self.Cooldown)
	
	ply.ArenaTakingWeapon = self.Weapon
	
	ply:Give(self.Weapon)
	ply:SelectWeapon(self.Weapon)
end

hook.Add('InitPostEntity', function()
	--for k, v in pairs(ents.GetAll()) do
	--	if IsValid(v) and v:GetClass() == "arena_weapon_spawner" then
	--		v:Remove()
	--	end
	--end
	
	if rp.cfg.Arena and rp.cfg.Arena.weapon_spawns then
		for k, v in pairs(rp.cfg.Arena.weapon_spawns[game.GetMap()] or {}) do
			local wep = ents.Create( "arena_weapon_spawner" );
			wep:SetPos( v.pos + Vector(0, 0, -5) );
			wep:SetAngles( Angle(0, 0, 180) );
			wep:SetColor( Color(180, 100, 0, 100) );
			wep:Spawn();
			
			wep.Cooldown = v.respawn
			wep.Weapon = v.weapon
			
			wep:SetWeaponID(k)
		end
	end
end)

hook.Add("CustomWeaponCheck", "rp.Arena.WeaponWorkaround", function(ply, wep)
    if ply.ArenaTakingWeapon and wep:GetClass() == ply.ArenaTakingWeapon then
		ply.ArenaTakingWeapon = nil
        return true
    end
end)
