-- "gamemodes\\rp_base\\gamemode\\addons\\custom_weapons_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local weapons = {}
local can_spawn_weapons = {}
local can_spawn_ents = {}
local acceptable_swep_spawns = {}

function rp.AddPermaSWEP(steamid, swep)
	if weapons[steamid] then
		table.insert(weapons[steamid], swep)
	else
		weapons[steamid] = {swep}
	end
end

function rp.GiveSWEPSpawnPermission(steamid)
	local steamid_64 = util.SteamIDTo64(steamid)
	steamid_64 = (steamid_64 == '0') and steamid or steamid_64
	
	if steamid == steamid_64 then
		steamid = util.SteamIDFrom64(steamid)
	end
	
	can_spawn_weapons[steamid] = true
	can_spawn_weapons[steamid_64] = true
end
function rp.GiveENTSpawnPermission(steamid)
	local steamid_64 = util.SteamIDTo64(steamid)
	steamid_64 = (steamid_64 == '0') and steamid or steamid_64
	
	if steamid == steamid_64 then
		steamid = util.SteamIDFrom64(steamid)
	end
	
	can_spawn_ents[steamid] = true
	can_spawn_ents[steamid_64] = true
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
rp.HasENTSpawnPermission = function(ply)
	return can_spawn_ents[isstring(ply) and ply or ply:SteamID()]
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
	return acceptable_swep_spawns[steamid] and acceptable_swep_spawns[steamid][swep or -1] or rp.HasSWEPSpawnPermission(steamid) or false
end
function rp.IsEntSpawnAcceptable(steamid, ent)
	steamid = isstring(steamid) and steamid or steamid:SteamID64()
	return acceptable_swep_spawns[steamid] and acceptable_swep_spawns[steamid][ent or -1] or rp.HasENTSpawnPermission(steamid) or false
end

hook.Add("PlayerLoadout", function(ply)
	if weapons[ply:SteamID64()] and not (ply:GetJobTable() and ply:GetJobTable().build == false) then
		for k, v in pairs(weapons[ply:SteamID64()]) do
			ply:Give(v)
		end
	end
end)
