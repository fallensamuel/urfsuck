
local db = ba.data.GetDB()

local admins = {
	["superadmin*"] = true, 
	["globaladmin*"] = true, 
	["helper"] = true, 
	["headadmin*"] = true, 
	["root"] = true, 
	["moderator*"] = true, 
	["admin*"] = true, 
	["adminplus"] = true, 
	["developer"] = true, 
	["manager"] = true, 
	["manager-plus"] = true,
	["cheifstaffleader"] = true,
	["chiefstaffleader"] = true,
	["staffleader*"] = true,
	["executiveleader"] = true,
	["executivespecialist"] = true,
	["staffleaderplus"] = true,
	["staffleader"] = true,
}

db:query_ex('DELETE FROM `ba_adminlog` WHERE `TimeEnd` < ?;', {os.time() - 2592000})

local function saveAdminTime(ply, is_on_job)
	local atime		= ply._isAdminTime
	
	--if not ply._onlineTime and ply._JoinedOn then
	--	ply._onlineTime = ply._JoinedOn - os.time()
	--end
	
	local otime		= ply._onlineTime
	local ctime		= os.time()
	local steamid 	= ply:SteamID64()
	
	if is_on_job then
		--print(steamid, atime, otime)
		
		if otime then
			db:query_sync('DELETE FROM `ba_adminlog` WHERE `SteamID` = ? and (`TimeStart` = ? and `IsOnJob` = 1 or `TimeStart` = ? and `IsOnJob` != 1);', {steamid, atime, otime})
			db:query_ex('INSERT INTO `ba_adminlog` (`SteamID`, `TimeStart`, `TimeEnd`, `IsOnJob`) VALUES(?, ?, ?, 1),(?, ?, ?, 0);', {steamid, atime, ctime, steamid, otime, ctime})
		else
			db:query_sync('DELETE FROM `ba_adminlog` WHERE `SteamID` = ? and `TimeStart` = ? and `IsOnJob` = 1;', {steamid, atime})
			db:query_ex('INSERT INTO `ba_adminlog` (`SteamID`, `TimeStart`, `TimeEnd`, `IsOnJob`) VALUES(?, ?, ?, 1);', {steamid, atime, ctime})
		end
	elseif otime then 
		db:query_sync('DELETE FROM `ba_adminlog` WHERE `SteamID` = ? and `TimeStart` = ? and `IsOnJob` = 0;', {steamid, otime})
		db:query_ex('INSERT INTO `ba_adminlog` (`SteamID`, `TimeStart`, `TimeEnd`, `IsOnJob`) VALUES(?, ?, ?, 0);', {steamid, otime, ctime})
	end
end

local function setIsAdmin(ply, admin)
	if not IsValid(ply) then return end
	ply._isAdminJob = admin
	
	local steamid = ply:SteamID()
	
	if admin then
		ply._isAdminTime = os.time()
		
	elseif ply._isAdminTime then 
		saveAdminTime(ply, true)
		ply._isAdminTime = nil
	end
end

local function setOnline(ply, online)
	if not IsValid(ply) then return end
	local steamid = ply:SteamID()
	
	if online then
		if not ply._onlineTime then
			ply._onlineTime = os.time()
		end
		
		timer.Create('rp.admin_job_log_' .. steamid, 180, 0, function()
			if not IsValid(ply) then 
				timer.Remove('rp.admin_job_log_' .. steamid)
				return 
			end
			
			saveAdminTime(ply, ply._isAdminJob)
		end)
		
	elseif ply._onlineTime then 
		saveAdminTime(ply, ply._isAdminJob)
	end
end

function rp.GetAdminTimelog(steamid64, callback)
	db:query_ex('SELECT * FROM `ba_adminlog` WHERE `SteamID` = ?;', {steamid64}, function(data)
		local result = {}
		
		for k, v in ipairs(data) do
			result[v.TimeStart] = v.TimeEnd
		end
		
		callback(result)
	end)
end

function rp.GetAllAdminsTimelog(callback)
	db:query_ex('SELECT * FROM `ba_adminlog`;', {}, function(data)
		local result = {}
		
		for k, v in ipairs(data) do
			result[v.SteamID] = result[v.SteamID] or {}
			result[v.SteamID][v.TimeStart] = v.TimeEnd
		end
		
		callback(result)
	end)
end

hook.Add("OnPlayerChangedTeam", "rp.admin_job_log", function(ply) 
	local admin = ply:IsSOD()
	
	if admin and not ply._isAdminJob then
		setIsAdmin(ply, true)
		
	elseif not admin and ply._isAdminJob then
		setIsAdmin(ply, false)
	end
end)

hook.Add("PlayerDisconnected", "rp.admin_left", function(ply)
	if ply._isAdminJob then
		setIsAdmin(ply, false)
		
	elseif ply._onlineTime then
		setOnline(ply, false)
	end
end)

hook.Add('playerRankLoaded', 'rp.admin_joined', function(ply)
	--PrintTable(managers)
	--print('rank', ply:GetRank())
	
	if admins[ply:GetRank()] then
		--saveAdminTime(ply)
		setOnline(ply, true)
	end
	
	--ply._JoinedOn = os.time()
end)

hook.Add("ShutDown", "rp.admin_shutdown", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply._isAdminJob then
			setIsAdmin(ply, false)
			
		elseif ply._onlineTime then
			setOnline(ply, false)
		end
	end
end)