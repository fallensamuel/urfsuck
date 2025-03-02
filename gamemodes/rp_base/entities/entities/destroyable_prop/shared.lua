-- "gamemodes\\rp_base\\entities\\entities\\destroyable_prop\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

ENT.PrintName = "Разрушаемый объект"
ENT.Type = "anim"
ENT.Base = 'base_gmodentity'
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.LazyFreeze = true

local PlyDistance = 6000

function ENT:TryToRestore(callback)
	local timer_id = 'TryToRestoreProp' .. self:EntIndex()
	
	local function restore()
		if not IsValid(self) then 
			timer.Remove(timer_id)
			return 
		end
		
		local penetrating = IsValid(self:GetPhysicsObject()) and self:GetPhysicsObject():IsPenetrating()
		local tooNearPlayer
		
		for _, v in pairs(player.GetAll()) do
			if self:GetPos():DistToSqr(v:GetPos()) <= PlyDistance then
				tooNearPlayer = true
			end
		end
		
		if not (penetrating or tooNearPlayer) then
			timer.Remove(timer_id)
			
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			
			for k, v in pairs(self.PDGlasses or {}) do
				v:SetCollisionGroup(COLLISION_GROUP_NONE)
			end
			
			callback(self)
		end
	end
	
	timer.Create(timer_id, 1, 0, restore)
	restore()
end

rp.cfg.LocalDestroyedProps = rp.cfg.LocalDestroyedProps or {}
local local_destroyed_props = rp.cfg.LocalDestroyedProps

function ENT:IsDestroyed() 
	return CLIENT and local_destroyed_props[self:EntIndex()] or self.PDBroken
end

function ENT:Restore()
	if CLIENT then
		net.Start('rp.Destoyable.Restore')
			net.WriteUInt(self:EntIndex(), 20)
		net.SendToServer()
	else
		local data = rp.cfg.DestroyablePropDynamics[self:GetModel()]
		
		timer.Remove('RestoreProp' .. self:EntIndex())
		timer.Remove('TryToRestoreProp' .. self:EntIndex())
		
		self:TryToRestore(function(self)
			self.PDBroken = nil
			
			net.Start('rp.Destoyable.Restore')
				net.WriteUInt(self:EntIndex(), 20)
			net.Broadcast()
		end)
	end
end

local dist = 300*300
local check_halos_for

if SERVER then
	util.AddNetworkString("Destroyable::HaloData")
	
	local function find_nearest_destroyable(ply)
		local ply_pos = ply:GetPos()
		local destroyables = ents.FindByClass("destroyable_prop")
		
		table.sort(destroyables, function(a, b)
			return (a:GetPos():DistToSqr(ply_pos) < b:GetPos():DistToSqr(ply_pos)) and not a:IsDestroyed()
		end)
		
		local dist = IsValid(destroyables[1]) and destroyables[1]:GetPos():DistToSqr(ply:GetPos()) or 0
		
		return (not rp.cfg.DestroyableMaxDistance or (dist <= rp.cfg.DestroyableMaxDistance * rp.cfg.DestroyableMaxDistance)) and destroyables[1]
	end
	
	check_halos_for = function(player, notify, newWeapon, oldWeapon)
		if IsValid(player) then
			if not (IsValid(newWeapon) and newWeapon.IsDestroyingProps) and IsValid(oldWeapon) and oldWeapon.IsDestroyingProps then
				net.Start("Destroyable::HaloData")
					net.WriteBool(false)
				net.Send(player)
			end
			
			if not (IsValid(oldWeapon) and oldWeapon.IsDestroyingProps) and IsValid(newWeapon) and newWeapon.IsDestroyingProps then
				local ent = find_nearest_destroyable(player)
				
				if IsValid(ent) and not ent:IsDestroyed() then
					if notify and (not player.DestoyableCDnotify or (player.DestoyableCDnotify < CurTime())) then
						player.DestoyableCDnotify = CurTime() + 1.2
						rp.Notify(player, NOTIFY_GREEN, rp.Term("Destroyable::MarkedNearest"))
					end
					
					net.Start("Destroyable::HaloData")
						net.WriteBool(true)
						net.WriteUInt(ent:EntIndex(), 16)
						net.WriteString(ent:GetModel())
						net.WriteVector(ent:GetPos())
						net.WriteAngle(ent:GetAngles())
					net.Send(player)
					
				else
					net.Start("Destroyable::HaloData")
						net.WriteBool(false)
					net.Send(player)
				end
			end
		end
	end
	
	hook.Add("PlayerSwitchWeapon", "Destoyable::SwitchHalos", function(player, oldWeapon, newWeapon)
		--if not player.DestoyableCDhalo or (player.DestoyableCDhalo < CurTime()) then
			--player.DestoyableCDhalo = CurTime() + 0.1
			check_halos_for(player, true, newWeapon, oldWeapon)
		--end
	end)
end

function ENT:Destroy()
	if SERVER then
		local data = rp.cfg.DestroyablePropDynamics[self:GetModel()]
		
		self.PDBroken = true
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		
		if data.connected then
			if not self.PDGlasses then
				local this_pos = self:GetPos()
				self.PDGlasses = {}
				
				for k, v in pairs(istable(data.connected) and data.connected or {data.connected}) do
					for _, glass in pairs(ents.FindByModel(v)) do
						if glass:GetPos():DistToSqr(this_pos) <= dist then
							table.insert(self.PDGlasses, glass)
						end
					end
				end
			end
			
			for k, v in pairs(self.PDGlasses) do
				v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			end
		end
		
		timer.Create('RestoreProp' .. self:EntIndex(), data.restoreTime, 1, function()
			if not IsValid(self) then return end
			self:Restore()
		end)
		
		net.Start('rp.Destoyable.Destroy')
			net.WriteUInt(self:EntIndex(), 20)
		net.Broadcast()
		
		timer.Simple(0.4, function()
			for k, v in pairs(player.GetAll()) do
				if not IsValid(v) then continue end
				check_halos_for(v, false, v:GetActiveWeapon())
			end
		end)
		
	else
		net.Start('rp.Destoyable.Destroy')
			net.WriteUInt(self:EntIndex(), 20)
		net.SendToServer()
	end
end


