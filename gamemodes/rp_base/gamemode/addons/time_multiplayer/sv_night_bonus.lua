
local time_start	= rp.cfg.StartNightTimeMultiplier
local time_end		= rp.cfg.EndNightTimeMultiplier
local bonus			= rp.cfg.NightTimeMultiplier

local night 		= false
local night_remain 	= 0
local night_print 	= ''

local function updateNightState()
	local current_time = (os.time() % 86400) / 3600 + 3
	
	local cur_hour = math.floor(current_time)
	local cur_mint = math.floor((current_time - cur_hour) * 60)
	
	local is_night = 	((time_start > time_end) and ((cur_hour >= time_start) or (cur_hour <= time_end))) or 
						((time_end > time_start) and (cur_hour >= time_start) and (cur_hour <= time_end))
	
	night_remain 	= ((cur_hour > time_end and 24 or 0) + time_end - cur_hour) * 3600 - cur_mint * 60
	
	local temp_hrs = math.ceil(night_remain / 3600)
	local temp_mins = night_remain / 60
	
	night_print 	= (night_remain > 3600) and (translates and translates.Get("%i часов", temp_hrs) or (temp_hrs .. ' часов')) or (translates and translates.Get("%i минут", temp_mins) or (temp_mins .. ' минут'))
	
	if not night and is_night then
		rp.SetTimeMultiplier('night', bonus, night_remain, 'NightMultiplayer')
	end
	
	night = is_night
end

timer.Create('rp.CheckNight', 1, 0, updateNightState)

local function checkNightBonus()
	if night and rp.GlobalTimeMultipliers then
		rp.SetTimeMultiplier('night', bonus, night_remain, 'NightMultiplayer')
	end
end

--checkNightBonus()

--hook.Add('TimeMultiplierInitialized', function()
--	checkNightBonus()
--end)

hook.Add("PlayerSpawn", function(ply)
	updateNightState()

	nw.WaitForPlayer(ply, function()
		if night then
			rp.Notify(ply, NOTIFY_GENERIC, rp.Term('NightMultiplayerAll'), bonus * 100, night_print)
		end
	end)
end)