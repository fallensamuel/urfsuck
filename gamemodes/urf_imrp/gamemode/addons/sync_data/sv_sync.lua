
util.AddNetworkString('rp.SyncData')

rp.syncData = rp.syncData or {
	db = mysql('mysql.urf.im', 'sync_hours', 'A13irQepdf9PxYx1', 'sync_hours', 3306), 
	given_cache = {},
}

local query_str
local function ecapeString(str)
    local new_str = ''
    
    for v in string.gmatch(str, utf8.charpattern) do 
        local cp = utf8.codepoint(v) 
        if cp == 32 or cp == 45 or cp == 95 or cp > 47 and cp < 58 or cp > 64 and cp < 91 or cp > 96 and cp < 123 or cp > 1039 and cp < 1104 then 
            new_str = new_str .. v
        end 
    end
    
    return new_str
end

local function prepareServerIds()
	query_str = ''
	
	for k, v in pairs(rp.cfg.SyncData.get) do
		query_str = query_str .. (query_str == '' and '"' or '","') .. ecapeString(k)
	end
	
	query_str = query_str .. (query_str == '' and '"' or '","') .. ecapeString(rp.cfg.HoursDbServerName) .. '"'
end

function rp.syncData.Load(ply)
		if rp.cfg.SyncData and rp.cfg.SyncData.get then 
		
		if not query_str then
			prepareServerIds()
		end
		
		local steam = ply:SteamID64()
		
		--print(steam, query_str)
		
		timer.Simple(2, function()
			rp.syncData.db:Query('SELECT * FROM `sync_data` WHERE `SteamID` = ? AND `Server` IN(' .. query_str .. ');', steam, function(data)
				if not data[1] or not IsValid(ply) or not ply:GetPlayTime() then return end
				
				local printed = false
				
				for k, v in pairs(data) do
					--print(v.Server, rp.cfg.HoursDbServerName, rp.cfg.HoursDbServerName == v.Server)
					if v.Server == rp.cfg.HoursDbServerName then
						rp.syncData.given_cache[ply:SteamID64()] = v.Given
						continue
					end
					
					local values = util.JSONToTable(v.Data or '[]') or {}
					local given = util.JSONToTable(v.Given or '[]') or {}
					
					if given[rp.cfg.HoursDbServerName] then continue end
						
					for _, inf in pairs(rp.cfg.SyncData.get[v.Server] or {}) do
						if not values[inf.id] then continue end
						
						local cur_value = inf.getter(ply)
						local db_value = math.min(math.floor(values[inf.id] * inf.percent), inf.max)
						
						if cur_value < db_value then
							inf.setter(ply, db_value)
							rp.syncData.db:Log("Set " .. inf.id .. " for " .. ply:GetName() .. " (" .. steam .. "): " .. db_value)
							
							if inf.id == 'hours' and not printed then
								net.Start('rp.SyncHours')
									net.WriteUInt(db_value, 16)
									net.WriteString(v.Server)
									net.WriteBool(true)
								net.Send(ply)
								
								printed = true
							end
						end
					end
					
					given[rp.cfg.HoursDbServerName] = true
					
					rp.syncData.db:Query('UPDATE `sync_data` SET `Given` = ? WHERE `SteamID` = ? AND `Server` = ?;', util.TableToJSON(given), steam, v.Server)
				end
			end)
		end)
	end
end

function rp.syncData.Save(ply)
	if not (rp.cfg.SyncData and rp.cfg.SyncData.set) then return end
	
	local data = {}
	
	for k, v in pairs(rp.cfg.SyncData.set) do
		data[v.id] = v.getter(ply)
	end
	
	rp.syncData.db:Query('REPLACE INTO `sync_data`(`SteamID`, `Server`, `Data`, `Given`) VALUES(?, ?, ?, ?);', ply:SteamID64(), rp.cfg.HoursDbServerName, util.TableToJSON(data), rp.syncData.given_cache[ply:SteamID64()] or '[]')
	
	rp.syncData.given_cache[ply:SteamID64()] = nil
end

function rp.syncData.Sync(start_index)
	local db = ba.data.GetDB()
	
	start_index = start_index or 1
	
	local counter = 0
	local total = 0
	
	local function checkSync(data, index)
		if not data[index] then
			print('Done ' .. (index - 1) .. ' users sync hours.')
			return
		end
		
		local user = data[index]
		local hours = math.floor(user.playtime / 3600)
		
		rp.syncData.db:Query("SELECT `Hours` FROM `sync_hours` WHERE `SteamID` = ?;", user.steamid, function(data_hours)
			if data_hours and data_hours[1] and data_hours[1].Hours < hours or not data_hours or not data_hours[1] then
				rp.syncData.db:Query("REPLACE INTO `sync_hours`(`SteamID`, `Server`, `Hours`) VALUES(?, ?, ?);", user.steamid, rp.cfg.HoursDbServerName, hours, function() 
					checkSync(data, index + 1)
				end)
			else
				checkSync(data, index + 1)
			end
		end)
		
		counter = counter + 1
		
		if counter >= 100 then
			print(index .. ' / ' .. total)
			counter = 0
		end
	end
	
	db:query('SELECT `steamid`, `playtime` FROM `ba_users`;', function(data)
		total = #data
		checkSync(data, start_index)
	end)
end


hook.Add('PlayerDataLoaded', 'rp.SyncData.connect', rp.syncData.Load)
hook.Add('PlayerDisconnected', 'rp.SyncData.disconnect', rp.syncData.Save)
