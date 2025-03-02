local var_cache = {}
var_cache["tostring"] = tostring
var_cache["istable"] = istable
var_cache["pairs"] = pairs
var_cache["util.SteamIDTo64"] = util.SteamIDTo64
var_cache["util.SteamIDFrom64"] = util.SteamIDFrom64

function rp.PlayerAddPermaAccessToCustomJob(key, steamid64)
	if rp.PlayerHasAccessToCustomJob(key, steamid) then
		return
	end

	rp.PlayerAddAccessToCustomJob(key, steamid64)

	local s = "INSERT INTO `perma_customjobs` (`SteamID`, `key`) VALUES(%s, %q);"
	rp._Stats:Query(s:format(steamid64, key))
end

hook.Add("InitPostEntity", "rp.PlayerAddPermaAccessToCustomJob", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `perma_customjobs` (`SteamID` bigint(20) NOT NULL, `key` TEXT NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")

	rp._Stats:Query("SELECT * FROM `perma_customjobs`;", function(data)
		for k, v in pairs(data) do
			rp.PlayerAddPermaAccessToCustomJob(v.key, v.SteamID)
		end
	end)
end)
