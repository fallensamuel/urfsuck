local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

local function checkBadType(name, object)
	local objectType = type(object)

	if (objectType == "function") then
		ErrorNoHalt("Net var '"..name.."' contains a bad object type!")

		return true
	elseif (objectType == "table") then
		for k, v in pairs(object) do
			-- Check both the key and the value for tables, and has recursion.
			if (checkBadType(name, k) or checkBadType(name, v)) then
				return true
			end
		end
	end
end

function entityMeta:setNetVar(key, value, receiver)
	if (checkBadType(key, value)) then return end

	rp.net[self] = rp.net[self] or {}

	if (rp.net[self][key] != value) then
		rp.net[self][key] = value
	end

	self:sendNetVar(key, receiver)
end

function entityMeta:getNetVar(key, default)
	if (rp.net[self] and rp.net[self][key] != nil) then
		return rp.net[self][key]
	end

	return default
end

function entityMeta:sendNetVar(key, receiver)
	netstream.Start(receiver, "nVar", self:EntIndex(), key, rp.net[self] and rp.net[self][key])
end

playerMeta.getLocalVar = entityMeta.getNetVar