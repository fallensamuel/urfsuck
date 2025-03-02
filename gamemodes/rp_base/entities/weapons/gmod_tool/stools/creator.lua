TOOL.AddToMenu = false
TOOL.ClientConVar[ "type" ] = "0"
TOOL.ClientConVar[ "name" ] = "0"
TOOL.ClientConVar[ "arg" ] = "0"

TOOL.SpawnTypes = {
	[0] = function(ply, name, arg, trace)
		Spawn_SENT(ply, name, trace)
	end,
	[1] = function(ply, name, arg, trace)
		Spawn_Vehicle(ply, name, trace)
	end,
	[2] = function(ply, name, arg, trace)
		Spawn_NPC(ply, name, arg, trace)
	end,
	[3] = function(ply, name, arg, trace)
		Spawn_Weapon(ply, name, trace)
	end,
	[4] = function(ply, name)
		CCSpawn(ply, nil, {name})
	end
}

function TOOL:LeftClick(trace)
	local type 	= self:GetClientNumber("type", 0)
	local name 	= self:GetClientInfo("name", 0)
	local arg 	= self:GetClientInfo("arg", 0)

	if CLIENT then return true end

	local todo = self.SpawnTypes[type]
	if todo then
		todo(self:GetOwner(), name, arg, trace)
	end

	return true
end
