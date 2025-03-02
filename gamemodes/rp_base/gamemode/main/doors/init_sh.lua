-- "gamemodes\\rp_base\\gamemode\\main\\doors\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local istable = istable

local doorClasses = {
	['func_door'] = true,
	['func_door_rotating'] = true,
	['prop_door_rotating'] = true,
	['gmod_sent_vehicle_fphysics_base'] = true, 
	['npc_horse'] = true
}

--['prop_dynamic'] = true,

if CLIENT then
	function ENTITY:IsDoor()
		if (!IsValid(self)) then return false end
		return self:IsVehicle() || (doorClasses[self:GetClass()] or false) || self:GetNetVar("IsDoor") || false
	end
else
	function ENTITY:IsDoor()
		if (!IsValid(self)) then return false end -- im not sure

		if self.IsDoorEnt == nil then
			self.IsDoorEnt = self:IsVehicle() || (doorClasses[self:GetClass()] or false) || self:GetNetVar("IsDoor") || false
		end
		
		return self.IsDoorEnt
	end
end

function PLAYER:CanLockUnlock(ent)
	return ent:CanLockUnlock(self)
end

function ENTITY:CanLockUnlock(ply)
	return self:DoorOwnedBy(ply) || self:DoorCoOwnedBy(ply)
end

function ENTITY:DoorIsOwnable()
	--print((self:GetNetVar('DoorData') == nil) and (self:GetNetVar('DoorData') ~= false))
	--if self:EntIndex() == 1576 then
	--	print(self:GetNetVar('DoorData'))
	--end
	
	return (self:GetNetVar('DoorData') == nil) and (self:GetNetVar('DoorData') ~= false)
end

function ENTITY:DoorIsUpgraded()
	return (istable(self:GetNetVar('DoorData')) and self:GetNetVar('DoorData').Upgraded or false)
end

function ENTITY:DoorOwnedBy(pl)
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner == pl) or false)
end

function ENTITY:DoorOrg()
	return (istable(self:GetNetVar('DoorData')) and self:GetNetVar('DoorData').Org or nil)
end

function ENTITY:DoorOrgOwned()
	return (istable(self:GetNetVar('DoorData')) and self:GetNetVar('DoorData').OrgOwn or self:DoorOrg() or false)
end

function ENTITY:DoorCoOwnedBy(pl)
	if (self:DoorGetGroup() ~= nil) then 
		return (rp.teamDoors[self:DoorGetGroup()] and rp.teamDoors[self:DoorGetGroup()][pl:Team()] or false)
	end
	
	if IsValid(self:DoorGetOwner()) and self:DoorGetOwner():GetOrg() and self:DoorOrgOwned() and (pl:GetOrg() == self:DoorGetOwner():GetOrg()) then
		return true
	end
	
	return (istable(self:GetNetVar('DoorData')) and table.HasValue(self:GetNetVar('DoorData').CoOwners or {}, pl) or false)
end

function ENTITY:DoorGetTitle()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Title) or nil)
end

function ENTITY:DoorGetOwner()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner) or nil)
end

function ENTITY:DoorGetCoOwners()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').CoOwners) or nil)
end

function ENTITY:DoorGetTeam()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Team) or nil)
end

function ENTITY:DoorGetGroup()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Group) or nil)
end

function ENTITY:DoorGetLocked()
	return self:GetNetVar('DoorLocked')
end

nw.Register('DoorData')
nw.Register('DoorLocked'):Write(net.WriteBool):Read(net.ReadBool)