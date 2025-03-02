require 'mysql'

anticheat = {}

local db = mysql('mysql.urf.im','anticheat', 'dfoNOgd675tL8CdR', 'anticheat', 3306)

local api_key = '36CFC1AEDBA92504F7120B6AC422B572'

db:Query('CREATE TABLE IF NOT EXISTS unwanted_list(steamid BIGINT(20) NOT NULL PRIMARY KEY, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP);')
db:Query('CREATE TABLE IF NOT EXISTS ip_list(steamid BIGINT(20) NOT NULL, ip VARCHAR(30) NOT NULL, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY(steamid, ip));')


-- code 6 familyshare
-- code 8 unwanted id on spawn
-- code 5 unwanted ip on pass
-- code 3 unwanted id on pass

local function banmsg() 
	return [[
Ты забанен!
-------------------------------------
Причина: anticheat banned
-------------------------------------
Купить разбан @ ]] .. rp.cfg.ConsultUrl
end

local unwanted_id = {}
local unwanted_ip = {}

function anticheat.GetUnwantedByID(id)
	for k, v in pairs(unwanted_id) do
		print(k, type(k))
	end
	return unwanted_id[id]
end

function anticheat.Unban(steamid)
	db:Query('DELETE FROM unwanted_list WHERE steamid = ?;', steamid)
	reloadUnwanted()
end

function anticheat.Ban(steamid)
	db:Query('REPLACE INTO unwanted_list(steamid) VALUES("'..steamid..'");', function() reloadUnwanted() end)
	reloadUnwanted()
end

function reloadUnwanted()
	unwanted_id = {}
	unwanted_ip = {}
	db:Query('SELECT steamid FROM unwanted_list;', function(_data)
		for k, v in pairs(_data) do
			unwanted_id[v.steamid] = true
		end
	end)

	db:Query('SELECT ip FROM unwanted_ip;', function(_data)
		for k, v in pairs(_data) do
			unwanted_ip[v.ip] = true
		end
	end)
end

reloadUnwanted()
timer.Create('reloadUnwanted', 60, 0, reloadUnwanted)


util.AddNetworkString('thxfool')
net.Receive('thxfool', function(len, ply)
	if ply.ac_caught then return end
	ply.ac_caught = true
	db:Query('REPLACE INTO unwanted_list(steamid) VALUES("'..ply:SteamID64()..'");', function() reloadUnwanted() end)

	ply:Kick(banmsg()) --'code 2'..math.random(1, 400)..''
end)


hook.Add("CheckPassword", "AC_CheckPassword", function(steamID64, ipAddress)
	local is_unwanted_id = unwanted_id[steamID64]
	local is_unwanted_ip =  unwanted_ip[string.StripPort(ipAddress)]

	if is_unwanted_id or is_unwanted_ip then
		db:Query('REPLACE INTO ip_list VALUES("'..steamID64..'","'..string.StripPort(ipAddress)..'", NOW());')
	end

	if is_unwanted_id then 
		return false, banmsg() --'code 3'..math.random(1, 200) 
	elseif is_unwanted_ip then
		--db:Query('REPLACE INTO unwanted_list VALUES("' .. steamID64 .. '", NOW())')
		return false, banmsg() --'code 5'..math.random(1, 200) 
	end
end)

local function CheckFamilySharing(ply)
	--Send request to the SteamDEV API with the SteamID64 of the player who has just connected.
	http.Fetch(
	string.format("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&format=json&steamid=%s&appid_playing=4000",
		api_key,
		ply:SteamID64()
	),

	function(body)
		--Put the http response into a table.
		local body = util.JSONToTable(body)

		--If the response does not contain the following table items.
		if not body or not body.response or not body.response.lender_steamid then
			error(string.format("FamilySharing: Invalid Steam API response for %s | %s\n", ply:Nick(), ply:SteamID()))
		end

		--Set the lender to be the lender in our body response table.
		local lender = body.response.lender_steamid
		--If the lender is not 0 (Would contain SteamID64). Lender will only ever == 0 if the account owns the game.

		if lender ~= "0" then
			--Handle the player that is on a family shared account to decide their fate.
			if unwanted_id[lender] then
				db:Query('REPLACE INTO unwanted_list VALUES("' .. ply:SteamID64() .. '", NOW())')
				ply:Kick(banmsg()) -- 'code 6'..math.random(1, 200)
				unwanted_id[ply:SteamID64()] = true
			end
		end
	end,

	function(code)
		error(string.format("FamilySharing: Failed API call for %s | %s (Error: %s)\n", ply:Nick(), ply:SteamID(), code))
	end
	)
end

hook.Add("PlayerSpawn", "AC_PlayerAuthed", function(ply)
	db:Query('REPLACE INTO ip_list VALUES("'..ply:SteamID64()..'","'..ply:NiceIP()..'", NOW());', function()
		db:Query('SELECT * FROM unwanted_list WHERE steamid = "' .. ply:SteamID64() .. '" LIMIT 1;', function(_data)
			local data = _data[1] or {}
			if !next(data) then
				CheckFamilySharing(ply)
				return 
			end


			--db:Query('REPLACE INTO unwanted_list VALUES("' .. ply:SteamID64() .. '", NOW())')
			
			--reloadUnwanted()

			ply:Kick(banmsg()) -- 'code 8'..math.random(1, 200)
		end)
	end)
end)

