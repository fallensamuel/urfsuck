util.AddNetworkString 'ba.LogPrint'
util.AddNetworkString 'ba.LogData'
util.AddNetworkString 'ba.PlayerData'
util.AddNetworkString 'ba.PlayerHashID'

local max_entries 	= 400
local log_data 		= ba.logs.Data
local player_logs 	= ba.logs.PlayerEvents
local log_mt 		= ba.log_mt

local db 			= ba.data.GetDB()

local net 			= net
local ipairs 		= ipairs
local IsValid 		= IsValid
local type 			= type
local table_insert 	= table.insert
local player_GetAll = player.GetAll
local os_date 		= os.date
local os_time 		= os.time

function log_mt:Log(term, ...)
	local tab = log_data[self:GetName()]

	table_insert(tab, 1, {Time = os.time(), Term = term, ...})

	hook.Run("Ba.OnLog", self:GetName(), {Time = os.time(), Term = term, Data = {...}})

	if self:GetColor() then
		net.Start('ba.LogPrint')
			net.WriteUInt(term, 6)
			net.WriteUInt(self:GetID(), 5)
			for k, v in ipairs({...}) do
				net.WriteString(tostring(v))
			end
		net.Send(ba.GetStaff())
	end

	if (#tab > max_entries) then
		tab[#tab] = nil
	end
end

function log_mt:PlayerLog(players, term, ...)
	for _, pl in ipairs((type(players) == 'table') and players or {players}) do
		if IsValid(pl) then
			local tab = player_logs[pl:SteamID()]
			if (not tab) then
				player_logs[pl:SteamID()] = {}
				tab = player_logs[pl:SteamID()]
			end
			local len = #tab
			table_insert(tab, 1, {Time = os.time(), Term = term, ...})

			if (#tab > max_entries) then
				tab[#tab] = nil
			end
		end
	end
	return self:Log(term, ...)
end

function ba.logs.OpenMenu(pl)
	local toWrite = {}
	for k, v in pairs(log_data) do if (not ba.logs.Get(k):GetColor()) or (not pl:GetBVar('LogsSynced')) then toWrite[#toWrite+1] = k end end
	
	if (#toWrite == 0) then return end -- something's bad wrong
	
	timer.Create('WriteLogData.' .. pl:SteamID64(), 0.06, #toWrite, function()
		if (IsValid(pl)) then
			local key = table.remove(toWrite, 1)
			local data = ba.logs.Encode(log_data[key] or {})
			local size = data:len()
			
			net.Start('ba.LogData')
				net.WriteString(key)
				net.WriteUInt(size, 16)
				net.WriteData(data, size)
			net.Send(pl)
		end
	end)
	pl:SetBVar('LogsSynced', true)
end


function ba.logs.OpenPlayerEvents(pl, steamid)
	local data = ba.logs.Encode(player_logs[steamid])
	local size = data:len()
	net.Start('ba.PlayerData')
		net.WriteUInt(size, 16)
		net.WriteData(data, size)
	net.Send(pl)
end


hook.Add('playerRankLoaded', 'ba.logs.playerRankLoaded', function(pl)
	db:query_ex('REPLACE INTO ba_iplog VALUES(?,?,"?");', {pl:SteamID64(), os.time(), pl:NiceIP()})
end)

net.Receive('ba.PlayerHashID', function(len, pl)
	if (not pl:GetBVar('HashIDLoaded')) then
		if net.ReadBool() then
			db:query_ex('REPLACE INTO ba_hashlog VALUES(?,?,"?");', {pl:SteamID64(), os.time(), net.ReadString()})
		else
			db:query_ex('REPLACE INTO ba_hashlog VALUES(?,?,"?");', {pl:SteamID64(), os.time(), pl:HashID()})
			net.Start('ba.PlayerHashID')
				net.WriteString(pl:HashID())
			net.Send(pl)
		end

		pl:SetBVar('HashIDLoaded', true)
	end
end)


function ba.logAction(pl, target, logname, logamount)
	target = isstring(target) and target or ba.InfoTo64(target)
	
	if isstring(target) and string.find(target, "STEAM") then
		target = util.SteamIDTo64(target)
	end
	
	ba.data.GetDB():query_ex('INSERT INTO ba_logs VALUES(NOW(), ?, "?", ?, IFNULL((SELECT Name FROM player_data WHERE SteamID="?"), "unknown"), "?", "?")', {pl:IsPlayer() and pl:SteamID64() or 0, pl:IsPlayer() and pl:Nick() or 'CONSOLE', (not target or target == '') and 0 or target, (not target or target == '') and 0 or target, logname, logamount})
end
