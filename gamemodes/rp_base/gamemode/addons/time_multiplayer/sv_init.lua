local CurTime 				= CurTime
local timeMultiplayers 		= {}

rp.GlobalTimeMultipliers = rp.GlobalTimeMultipliers or {}
local globalTimeMultipliers	= rp.GlobalTimeMultipliers


local function checkGlobalMultiplier(dont_print)
	local max_bonus, min_bonus	= { bonus = 0 }, { time = 10000000000 }
	
	for k, v in pairs(globalTimeMultipliers) do
		if v.bonus > max_bonus.bonus then
			max_bonus = v
		end
		
		if v.time > 0 and v.time < min_bonus.time then
			min_bonus = v
		end
	end
	
	if not dont_print and max_bonus.term and rp.GetTimeMultiplier() ~= max_bonus.bonus then
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term(max_bonus.term), math.floor(max_bonus.bonus * 100), math.floor((max_bonus.time - os.time()) / 60))
	end
	
	if max_bonus.bonus == 0 and rp.GetTimeMultiplier() > 0 then
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ResetGlobalTimeMultiplayer'))
	end
	
	nw.SetGlobal('TimeMultiplier', max_bonus.bonus)
	nw.SetGlobal('TimeMultiplierRemain', min_bonus.time)
end

function rp.SetTimeMultiplier(id, bonus, time, term)
	if bonus and bonus > 0 and time and time > 0 then
		bonus = math.max(math.min(bonus, 20), 0.1)
		
		globalTimeMultipliers[id] = { 
			bonus 	= bonus, 
			time 	= time + os.time(), 
			term 	= term
		}
		
		timer.Create('rp.TimeMultiplier:' .. id, time, 1, function() rp.SetTimeMultiplier(id) end)
		
	elseif id then
		timer.Remove('rp.TimeMultiplier:' .. id)
		globalTimeMultipliers[id] = nil
		
		if id == 'general' then
			ba.svar.SetGlobal('time_multiplier_time', 0)
			ba.svar.SetGlobal('time_multiplier', 0)
		end
	end
	
	checkGlobalMultiplier()
end

hook.Call('TimeMultiplierInitialized')

hook.Add('OnReloaded', function()
	timer.Simple(0, function()
		if table.Count(globalTimeMultipliers) > 0 then
			for k, v in pairs(globalTimeMultipliers) do
				if v.time < os.time() then
					globalTimeMultipliers[k] = nil
				else
					timer.Create('rp.TimeMultiplier:' .. k, v.time - os.time(), 1, function() rp.SetTimeMultiplier(k) end)
				end
			end
			
			checkGlobalMultiplier(true)
		end
	end)
end)


local function globalBdTimeMultiplier()
	timer.Simple(0, function()
		local bonus	= tonumber(ba.svar.GetGlobal('time_multiplier') or 0)
		local time 	= tonumber(ba.svar.GetGlobal('time_multiplier_time') or 0)
		
		local general = globalTimeMultipliers['general'] or {}
		
		local cur_bonus	= general.bonus or 0
		local cur_time	= general.time or 0
		
		if cur_bonus ~= bonus or cur_time ~= time then
			rp.SetTimeMultiplier('general', bonus, time - os.time(), 'SetGlobalTimeMultiplayer')
		end
	end)
end

ba.svar.Create('time_multiplier_time', nil, nil, globalBdTimeMultiplier, true)
ba.svar.Create('time_multiplier', nil, nil, globalBdTimeMultiplier, true)

hook.Add('Initialize', function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `saved_timemultipliers` (`steamid` bigint(20) NOT NULL,`id` varchar(20) NOT NULL,`value` int(16) NOT NULL,`until` int(12) NOT NULL,PRIMARY KEY (`steamid`,`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;", function()
		rp._Stats:Query("DELETE FROM `saved_timemultipliers` WHERE `until` < ?;", os.time())
	end)
end)

hook.Add("PlayerDataLoaded", function(ply)
	timer.Simple(5, function()
		rp._Stats:Query("SELECT `id`, `value`, `until` as ctime FROM `saved_timemultipliers` WHERE `steamid` = ? AND `until` >= ?;", ply:SteamID64(), os.time(), function(data)
			for k, v in pairs(data or {}) do
				ply:AddTimeMultiplayerSaved(v.id, tonumber(v.value) / 100, tonumber(v.ctime) - os.time(), true)
			end
		end)
	end)
end)

hook.Add("PlayerDisconnected", function(ply)
	timeMultiplayers[ply] = nil
end)

function PLAYER:AddTimeMultiplayer(id, value)
	timeMultiplayers[self] = timeMultiplayers[self] or {}

	self:SetNetVar('PlayTime', self:GetPlayTime())
	self:SetNetVar('FirstJoined', CurTime())
	
	if timeMultiplayers[self][id] then
		self:SetNetVar('TimeMultiplayer', self:GetTimeMultiplayer() - timeMultiplayers[self][id] + value)
	else
		self:SetNetVar('TimeMultiplayer', self:GetTimeMultiplayer() + value)
	end
	
	timeMultiplayers[self][id] = value
end

function PLAYER:AddTimeMultiplayerSaved(id, value, duration, noquery)
	self:AddTimeMultiplayer(id, value)
	
	timer.Simple(duration, function()
		if not IsValid(self) then return end
		self:RemoveTimeMultiplayer(id)
	end)
	
	if not noquery then
		rp._Stats:Query("REPLACE INTO `saved_timemultipliers` VALUES(?, ?, ?, ?);", self:SteamID64(), id, value * 100, os.time() + duration)
	end
end

function PLAYER:RemoveTimeMultiplayer(id)
	timeMultiplayers[self] = timeMultiplayers[self] or {}

	self:SetNetVar('PlayTime', self:GetPlayTime())
	self:SetNetVar('FirstJoined', CurTime())
	
	if timeMultiplayers[self][id] then
		self:SetNetVar('TimeMultiplayer', self:GetNetVar('TimeMultiplayer') - timeMultiplayers[self][id])
	end

	timeMultiplayers[self][id] = nil
end

function PLAYER:HasTimeMultiplayer(id)
	return timeMultiplayers[self] and timeMultiplayers[self][id] and true or false
end