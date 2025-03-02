-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\libs\\networking_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

rp.net.globals = rp.net.globals or {}

netstream.Hook("nVar", function(index, key, value)
	rp.net[index] = rp.net[index] or {}
	rp.net[index][key] = value
end)

function getNetVar(key, default)
	local value = rp.net.globals[key]

	return value != nil and value or default
end

function entityMeta:getNetVar(key, default)
	local index = self:EntIndex()

	if (rp.net[index] and rp.net[index][key] != nil) then
		return rp.net[index][key]
	end

	return default
end

playerMeta.getLocalVar = entityMeta.getNetVar