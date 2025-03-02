local meta = {
	VehicleName = "nil",
	Name = translates and translates.Get("Автомобиль") or "Автомобиль",
	bodygroups = nil,
    skins = nil,
    colors = nil,
    booletproof = nil,
    wheels = nil,
    canSpawn = function(pl) return true end
}
meta.__index = meta

local __pimpcustoms = {}

PIMP = PIMP or {}

function PIMP.Get(name)
	return __pimpcustoms[name]
end

function PIMP.GetByEntity(ent)
	local name = ent:GetNWString("VehicleName")
	return __pimpcustoms[name]
end

function PIMP.GetNames()
	return table.GetKeys(__pimpcustoms)
end

function PIMP.RegisterCustomData(data)
	__pimpcustoms[data.VehicleName] = data
	setmetatable(__pimpcustoms[data.VehicleName], meta)
end

local path = engine.ActiveGamemode() .. "/gamemode/config/pimp_cars/"
local files = file.Find(path .. "*.lua", "LUA")
for _, name in SortedPairs(files, true) do
	AddCSLuaFile(path .. name)
	include(path .. name) 
end
