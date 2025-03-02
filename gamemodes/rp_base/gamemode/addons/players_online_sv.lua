
hook.Add("InitPostEntity", "rp.MPO.Clear", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `players_online` (`steamid` bigint(20) NOT NULL, `server_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '', PRIMARY KEY (`steamid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;", function()
		print('[MONITOR] Table initialised')
		rp._Stats:Query("DELETE FROM players_online WHERE server_id = ?;", rp.cfg.ServerUniqID or '')
	end)
end)

local function removeFromTable(key)
	print('[MONITOR] Removed ' .. key)
	rp._Stats:Query("DELETE FROM players_online WHERE steamid = ?;", key)
end

hook.Add("PlayerInitialSpawn", "rp.MPO.PlayerJoin", function(ply)
	if ply:IsBot() then return end
	
	local key = ply:SteamID64()
	
	rp._Stats:Query("INSERT INTO players_online VALUES(?, ?);", key, rp.cfg.ServerUniqID or '', function()
		print('[MONITOR] Added ' .. key)
		
		if not IsValid(ply) then 
			return removeFromTable(key)
		end
		
		ply.MonitorUpdated = true
	end)
end)

hook.Add("PlayerDisconnected", "rp.MPO.PlayerDisconnect", function(ply)
	if ply.MonitorUpdated then
		removeFromTable(ply:SteamID64())
	end
end)
