AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


local to_respawn = {
	prop_dynamic = true
}

local destroyable = {
	destroyable_prop = true
}

local minimum_time
local last_action_time = {}


function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
end

local function respawn_perma_props()
	timer.Simple(10, function()
		--print('Perma props reloaded')
		
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) and v.PermaProps and rp.cfg.DestroyablePropDynamics and rp.cfg.DestroyablePropDynamics[v:GetModel()] and rp.cfg.DestroyablePropDynamics[v:GetModel()].force_classes and rp.cfg.DestroyablePropDynamics[v:GetModel()].force_classes[v:GetClass()] then
				local dest_prop = ents.Create('destroyable_prop')
				
				dest_prop:SetModel(v:GetModel())
				dest_prop:SetSkin(v:GetSkin())
				dest_prop:SetPos(v:GetPos())
				dest_prop:SetAngles(v:GetAngles())
				
				dest_prop:PhysicsInit(SOLID_VPHYSICS)
				dest_prop:SetMoveType(MOVETYPE_NONE)
				dest_prop:SetCollisionGroup(COLLISION_GROUP_NONE)
				
				local phys = dest_prop:GetPhysicsObject()
				if IsValid(phys) then
					phys:Sleep()
					phys:EnableMotion(false)
				end
				
				v:Remove()
			end
		end
	end)
end

hook.Add('PermaPropsReloaded', 'RespawnDestroyablePermaProps', respawn_perma_props)

hook.Add('InitPostEntity', 'rp.Destroyable.Initialize', function()
	if not rp.cfg.DestroyablePropDynamics then return end
	
	for k, v in pairs(ents.GetAll()) do
		if IsValid(v) and v:GetClass() == 'destroyable_prop' then 
			v:Remove()
		end
	end
	
	respawn_perma_props()
	
	--timer.Simple(10, function()
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) and to_respawn[v:GetClass()] and rp.cfg.DestroyablePropDynamics[v:GetModel()] then
				local dest_prop = ents.Create('destroyable_prop')
				
				dest_prop:SetModel(v:GetModel())
				dest_prop:SetSkin(v:GetSkin())
				dest_prop:SetPos(v:GetPos())
				dest_prop:SetAngles(v:GetAngles())
				
				dest_prop:PhysicsInit(SOLID_VPHYSICS)
				dest_prop:SetMoveType(MOVETYPE_NONE)
				dest_prop:SetCollisionGroup(COLLISION_GROUP_NONE)
				
				local phys = dest_prop:GetPhysicsObject()
				if IsValid(phys) then
					phys:Sleep()
					phys:EnableMotion(false)
				end
				
				v:Remove()
			end
		end
	--end)
end)

concommand.Add("respawn_destroyableprops", function(ply)
	if not ply:IsRoot() then return end

	for k, v in pairs(ents.FindByClass("destroyable_prop")) do
		local dest_prop = ents.Create('destroyable_prop')
				
		dest_prop:SetModel(v:GetModel())
		dest_prop:SetSkin(v:GetSkin())
		dest_prop:SetPos(v:GetPos())
		dest_prop:SetAngles(v:GetAngles())
				
		dest_prop:PhysicsInit(SOLID_VPHYSICS)
		dest_prop:SetMoveType(MOVETYPE_NONE)
		dest_prop:SetCollisionGroup(COLLISION_GROUP_NONE)
		
		local phys = dest_prop:GetPhysicsObject()	
		if IsValid(phys) then
			phys:Sleep()
			phys:EnableMotion(false)
		end

		local oSc = dest_prop:GetModelScale()
		dest_prop:SetModelScale(0)
		dest_prop:SetModelScale(oSc, 0.75)
				
		v:Remove()
	end
end)

local function checkValidDestroying(ply, ent)
	if not minimum_time then
		for k, v in pairs(rp.cfg.DestroyablePropDynamics) do
			if minimum_time and v.restoreTime > minimum_time then continue end
			minimum_time = v.restoreTime
		end
	end
	
	if not ent.IsDestroyed or ent:IsDestroyed() then
		return false
	end
	
	local delay = CurTime() - (last_action_time[ply:SteamID()] or 0)
	
	if delay < 1 then
		return false 
	end
	
	local weapon = ply:GetActiveWeapon()
	
	if not IsValid(weapon) or not weapon.IsDestroyingProps then
		return false
	end
	
	if ply:GetPos():DistToSqr(ent:GetPos()) > 22000 then
		return false
	end
	
	last_action_time[ply:SteamID()] = CurTime()
	
	return true
end

local function checkValidRestoring(ply, ent)
	if not minimum_time then
		for k, v in pairs(rp.cfg.DestroyablePropDynamics) do
			if minimum_time and v.restoreTime > minimum_time then continue end
			minimum_time = v.restoreTime
		end
	end
	
	if not (ent.IsDestroyed and ent:IsDestroyed()) then
		return false
	end
	
	local delay = CurTime() - (last_action_time[ply:SteamID()] or 0)
	
	if delay < 1 then
		return false 
	end
	
	local weapon = ply:GetActiveWeapon()
	
	if not IsValid(weapon) or not weapon.IsRepairingProps then
		return false
	end
	
	if ply:GetPos():DistToSqr(ent:GetPos()) > 22000 then
		return false
	end
	
	last_action_time[ply:SteamID()] = CurTime()
	
	return true
end

util.AddNetworkString('rp.Destoyable.Destroy')
util.AddNetworkString('rp.Destoyable.Restore')

net.Receive('rp.Destoyable.Destroy', function(_, ply)
	if ply:CantDoAfterNoclip(true) then return false end
	
	local ent = Entity(net.ReadUInt(20) or -1)
	
	if not IsValid(ent) or not ent.IsDestroyed then return end
	
	if checkValidDestroying(ply, ent) then 
		local inv = ply:getInv()
		if not inv then return end
		
		local data = rp.cfg.DestroyablePropDynamics[ent:GetModel()]
		local count
		
		for k, v in pairs(data.items or {}) do
			if not rp.item.list[k] then continue end
			
			count = 0
			
			for i = 1, v.max_amount do
				count = count + (math.Rand(0, 1) <= v.chance and 1 or 0)
			end
			
			if count > 0 then
				inv:add(k, count)
				rp.Notify(ply, NOTIFY_GREEN, rp.Term('FoundItems'), rp.item.list[k].name, count)
			end
		end
	end
	
	ent:Destroy()
end)

net.Receive('rp.Destoyable.Restore', function(_, ply)
	local ent = Entity(net.ReadUInt(20) or -1)
	
	if not IsValid(ent) or not (ent.IsDestroyed and ent:IsDestroyed()) then return end
	
	if checkValidRestoring(ply, ent) then
		ent:Restore()
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('PropRepaired'), rp.FormatMoney(rp.cfg.RepairPropReward or 50))
		ply:AddMoney(rp.cfg.RepairPropReward or 50)
	end
end)
