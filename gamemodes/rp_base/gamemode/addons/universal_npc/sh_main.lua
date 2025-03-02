rp.UniversalNPCs = rp.UniversalNPCs or {}

local _meta = {Name = "none", Sequence = "idle_all_01"}
_meta.__index = _meta

function _meta:SetName(name)
	self.Name = name
	return self
end

function _meta:SetModel(mdl)
	self.Model = mdl
	return self
end

function _meta:SetPos(x, y, z)
	self.Pos = isvector(x) and x or Vector(x, y, z)
	return self
end

function _meta:SetAngles(x, y, z)
	self.Angles = isangle(x) and x or Angle(x, y, z)
	return self
end

function _meta:SetVendor(vendor_name)
	self.Vendor = vendor_name
	return self
end

function _meta:SetEmployerFaction(faction_index)
	self.EmployerFaction = faction_index
	return self
end

function _meta:SetSpawnpoint(index)
	self.Spawnpoint = index
	return self
end

function _meta:SetSkin(skin)
	self.Skin = skin
	return self
end

function _meta:SetBodygroup(k, v)
	self.Bodygroups = self.Bodygroups or {}
	self.Bodygroups[k] = v
	return self
end

function _meta:SetSequence(uid)
	self.Sequence = uid
	return self
end

function rp.AddUniversalNPC(name)
	rp.UniversalNPCs[name] = table.Copy(_meta)
	return rp.UniversalNPCs[name]:SetName(name)
end




-- EXAMPLE:
--[[
rp.AddUniversalNPC("Игорь")
:SetModel("models/eli.mdl")
:SetPos(500, 2700, -372)
:SetAngles(0, -90, 0)
:SetVendor("Джейкоб") -- имя вендора которое вы указывали в rp.AddEntity vendor
:SetEmployerFaction(FACTION_MERCHANT)
:SetSpawnpoint(1) -- index of rp.cfg.SpawnPoints
:SetSkin(1)
:SetBodygroup(1, 2)
:SetSequence("idle_all_01")
]]--