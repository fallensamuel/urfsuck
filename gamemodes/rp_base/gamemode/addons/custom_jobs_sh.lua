customJobs = customJobs or {}

local var_cache = {}
var_cache["tostring"] = tostring
var_cache["istable"] = istable
var_cache["pairs"] = pairs
var_cache["util.SteamIDTo64"] = util.SteamIDTo64
var_cache["util.SteamIDFrom64"] = util.SteamIDFrom64

function rp.PlayerHasAccessToCustomJob(key, steamid)
	steamid = var_cache["tostring"](steamid)
	
	if var_cache["istable"](key) then
		for k, v in var_cache["pairs"](key) do
			--print(v)
			if customJobs[v] and customJobs[v][steamid] then return true end
		end
	else
		return customJobs[key] and customJobs[key][steamid] or false
	end
end

function rp.PlayerAddAccessToCustomJob(key, steamids)
	for k, v in pairs(istable(steamids) and steamids or {steamids}) do
		local steamid = var_cache["tostring"](v)

		local id = var_cache["util.SteamIDTo64"](steamid) ~= "0" and var_cache["util.SteamIDTo64"](steamid) or var_cache["util.SteamIDFrom64"](steamid) ~= "STEAM_0:0:0" and var_cache["util.SteamIDFrom64"](steamid) or steamid
		customJobs[key] = customJobs[key] or {}
		customJobs[key][steamid] = true
		customJobs[key][id] = true
	end
end