
util.AddNetworkString('rp.SyncHours')
local not_ru = translates and (translates.cur_lang != 'ru')

rp.syncHours = rp.syncHours or {
	db = mysql('mysql.urf.im', 'sync_hours', 'A13irQepdf9PxYx1', 'sync_hours', 3306), 
	lastTabledPlaytime = {}
}

if not_ru then
	rp.syncHours.custom_db = mysql('127.0.0.1', 'sync_hours', 'A13irQepdf9PxYx1', 'sync_hours', 3306)
end

function rp.syncHours.Load(ply)
	if not rp.cfg.DisableSyncHours then
		local steam = ply:SteamID64()
		local sh_db = rp.syncHours.custom_db or rp.syncHours.db
		
		timer.Simple(5, function()
			sh_db:Query("SELECT * FROM `sync_hours` WHERE `SteamID` = ? LIMIT 1;", steam, function(data)
				if not data[1] or not IsValid(ply) or not ply:GetPlayTime() then return end
				
				local udata = data[1]
				local serv_name = udata.Server
				
				local cur_hours = math.floor(ply:GetPlayTime() / 3600)
				local new_hours = math.min(math.floor(udata.Hours / 2), rp.cfg.MaxSyncHours or 50)
				
				rp.syncHours.lastTabledPlaytime[ply:SteamID()] = udata.Hours
				
				if new_hours > cur_hours then
					ply:SetNetVar('PlayTime', new_hours * 3600)
					ba.data.UpdatePlayTime(ply)
					
					local print_hours = new_hours - cur_hours
					
					net.Start('rp.SyncHours')
						net.WriteUInt(print_hours, 16)
						net.WriteString(serv_name)
					net.Send(ply)
					
					ba.notify_all(ba.Term('SyncHoursAdd'), ply:Name(), print_hours, serv_name)
					sh_db:Log("Added hours for " .. ply:GetName() .. " (" .. steam .. "): " .. print_hours)
				end
			end)
		end)
	end
end

function rp.syncHours.Save(ply)
	if not rp.cfg.HoursDbServerName then return end
	local sh_db = rp.syncHours.custom_db or rp.syncHours.db
	
	if ply:GetPlayTime() then 
		local hours = math.floor(ply:GetPlayTime() / 3600)
		
		if rp.syncHours.lastTabledPlaytime[ply:SteamID()] and rp.syncHours.lastTabledPlaytime[ply:SteamID()] > hours then 
			rp.syncHours.lastTabledPlaytime[ply:SteamID()] = nil
			return 
		end
		
		local steam	= ply:SteamID64()
		local name 	= ply:GetName()
		
		sh_db:Query("REPLACE INTO `sync_hours`(`SteamID`, `Server`, `Hours`) VALUES(?, ?, ?);", steam, rp.cfg.HoursDbServerName, hours, function() 
			sh_db:Log("Saved hours for " .. name .. " (" .. steam .. "): " .. hours)
		end)
	end
	
	rp.syncHours.lastTabledPlaytime[ply:SteamID()] = nil
end

function rp.syncHours.Sync(start_index)
	local db = ba.data.GetDB()
	local sh_db = rp.syncHours.custom_db or rp.syncHours.db
	
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
		
		sh_db:Query("SELECT `Hours` FROM `sync_hours` WHERE `SteamID` = ?;", user.steamid, function(data_hours)
			if data_hours and data_hours[1] and data_hours[1].Hours < hours or not data_hours or not data_hours[1] then
				sh_db:Query("REPLACE INTO `sync_hours`(`SteamID`, `Server`, `Hours`) VALUES(?, ?, ?);", user.steamid, rp.cfg.HoursDbServerName, hours, function() 
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


hook.Add('playerRankLoaded', 'rp.SyncHours.connect', rp.syncHours.Load)
hook.Add('PlayerDisconnected', 'rp.SyncHours.disconnect', rp.syncHours.Save)
