
local weapons = {}
local can_spawn_weapons = {}
local acceptable_swep_spawns = {}

function rp.AddPermaSWEP(steamid, swep)
	if weapons[steamid] then
		table.insert(weapons[steamid], swep)
	else
		weapons[steamid] = {swep}
	end
end

function rp.GiveSWEPSpawnPermission(steamid)
	can_spawn_weapons[steamid] = true
end

local spawn_swep = function(ply, ent)
	if can_spawn_weapons[ply:SteamID()] then
		return true
	end
end
hook("PlayerGiveSWEP", spawn_swep)
hook("PlayerSpawnSWEP", spawn_swep)
rp.HasSWEPSpawnPermission = function(ply)
	return can_spawn_weapons[isstring(ply) and ply or ply:SteamID()]
end

function rp.AcceptSwepSpawn(steamid, sweps)
	local steamid_64 = util.SteamIDTo64(steamid)
	steamid_64 = (steamid_64 == '0') and steamid or steamid_64
	
	acceptable_swep_spawns[steamid_64] = acceptable_swep_spawns[steamid_64] or {}
	
	for _, v in pairs(isstring(sweps) and {sweps} or sweps) do
		acceptable_swep_spawns[steamid_64][v] = true
	end
end
function rp.AcceptEntSpawn(steamid, ents)
	local steamid_64 = util.SteamIDTo64(steamid)
	steamid_64 = (steamid_64 == '0') and steamid or steamid_64
	
	acceptable_swep_spawns[steamid_64] = acceptable_swep_spawns[steamid_64] or {}
	
	for _, v in pairs(isstring(ents) and {ents} or ents) do
		acceptable_swep_spawns[steamid_64][v] = true
	end
end

function rp.IsSwepSpawnAcceptable(steamid, swep)
	steamid = isstring(steamid) and steamid or steamid:SteamID64()
	return acceptable_swep_spawns[steamid] and acceptable_swep_spawns[steamid][swep or -1]
end
function rp.IsEntSpawnAcceptable(steamid, ent)
	steamid = isstring(steamid) and steamid or steamid:SteamID64()
	return acceptable_swep_spawns[steamid] and acceptable_swep_spawns[steamid][ent or -1]
end

hook.Add("PlayerLoadout", function(ply)
	if weapons[ply:SteamID64()] and not (ply:GetJobTable() and ply:GetJobTable().build == false) then
		for k, v in pairs(weapons[ply:SteamID64()]) do
			ply:Give(v)
		end
	end
end)
