-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.seasonpass = rp.seasonpass or {
	Seasons = {},
	SeasonsMap = {},
	
	QuestsTypes = {},
	QuestsTypesMap = {},
	
	Quests = {},
	QuestsMap = {},
	QuestPools = {},
	
	PlayerQuests = {},
	PlayerQuestsMap = {},
	PlayerQuestsTimestamps = {},
	
	Meta = {},
}


--[[ Classes ]]--
local _meta_quest_type = {}
_meta_quest_type.__index = _meta_quest_type
rp.seasonpass.Meta._meta_quest_type = _meta_quest_type

local _meta_quest = {}
_meta_quest.__index = _meta_quest
rp.seasonpass.Meta._meta_quest = _meta_quest

local _meta_season = {}
_meta_season.__index = _meta_season
rp.seasonpass.Meta._meta_season = _meta_season


--[[ Lib ]]--
function rp.seasonpass.GetCurDateID()
	local cur_date = os.date("!*t")
	return cur_date.day .. cur_date.month .. cur_date.year
end

function rp.seasonpass.GetSeason(timestamp)
	if not rp.seasonpass.CurrentSeason or timestamp then
		local cur_date = os.date("!*t", timestamp)
		local cur_time = os.time(cur_date)
		
		for k, v in pairs(rp.seasonpass.Seasons) do
			if not v.StartDate then continue end
			
			local s_start = table.Copy(v.StartDate)
			local s_end = table.Copy(v.EndDate)
			
			s_start.year = s_start.year or cur_date.year
			s_end.year = s_end.year or cur_date.year
			
			local cs_start = os.time(s_start)
			local cs_end = os.time(s_end)
			
			if cs_start < cs_end then
				if cur_time > cs_start and cur_time <= cs_end then
					if not timestamp then
						rp.seasonpass.CurrentSeason = k
						
						v.StartTimestamp = cs_start
						v.EndTimestamp = cs_end
						
						break
					else
						return rp.seasonpass.Seasons[k], cs_start, cs_end
					end
				end
				
			else
				if cur_time > cs_start then
					s_end.year = s_end.year + 1
					cs_end = os.time(s_end)
					
					if cur_time <= cs_end then
						if not timestamp then
							rp.seasonpass.CurrentSeason = k
							
							v.StartTimestamp = cs_start
							v.EndTimestamp = cs_end
							
							break

						else
							return rp.seasonpass.Seasons[k], cs_start, cs_end
						end
					end
					
				else 
					s_start.year = s_start.year - 1
					cs_start = os.time(s_start)
					
					if cur_time > cs_start and cur_time <= cs_end then
						if not timestamp then
							rp.seasonpass.CurrentSeason = k
							
							v.StartTimestamp = cs_start
							v.EndTimestamp = cs_end
							
							break

						else
							return rp.seasonpass.Seasons[k], cs_start, cs_end
						end
					end
				end
			end
		end
	end
	
	if timestamp then
		return false
	end
	
	return rp.seasonpass.Seasons[ rp.seasonpass.CurrentSeason or -1 ] or false
end

function rp.seasonpass.GetSeasonTimeLeft()
	if not rp.seasonpass.TimeSeasonEnd or os.time() > rp.seasonpass.TimeSeasonEnd then
		local cur_date 	= os.date("!*t")
		local cur_time 	= os.time(os.date("!*t"))
		
		local season 	= rp.seasonpass.GetSeason()
		
		local s_start 	= table.Copy(season.StartDate)
		local s_end 	= table.Copy(season.EndDate)
		
		s_start.year = s_start.year or cur_date.year
		s_end.year = s_end.year or cur_date.year
		
		local cs_start = os.time(s_start)
		local cs_end = os.time(s_end)

		if cs_start > cs_end and cur_time > cs_start then
			s_end.year = cur_date.year + 1
			cs_end = os.time(s_end)
		end

		rp.seasonpass.TimeSeasonEnd = cs_end - os.time(os.date("!*t"))
	end
	
	return rp.seasonpass.TimeSeasonEnd
end

function rp.seasonpass.GetDayTimeLeft()
	local cur_date = os.date("!*t")
	cur_date.day = cur_date.day + 1
	
	local next_date = os.date("!*t", os.time(cur_date))
	
	next_date.hour = 0
	next_date.min = 0
	next_date.sec = 0
	
	return os.time(next_date) - os.time(os.date("!*t"))
end

function rp.seasonpass.PrettyTime(time_left, show_minutes, show_full_timename)
	local minutes = math.ceil(time_left / 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	
	minutes = minutes % 60
	hours = hours % 24
	
	local result = ""
	
	if days > 0 then
		result = days .. translates.Get("д.")
	end
	
	if hours > 0 then
		result = result .. (result == "" and "" or " ") .. hours .. (show_full_timename and (((hours % 10 == 1) and (math.floor(hours / 10) ~= 1)) and " " .. translates.Get("час") or ((hours % 10 > 1) and (hours % 10 < 5) and (math.floor(hours / 10) ~= 1)) and " " .. translates.Get("часа") or " " .. translates.Get("часов")) or translates.Get("ч."))
	end
	
	if show_minutes and minutes > 0 then
		result = result .. (result == "" and "" or " ") .. minutes .. (show_full_timename and (((minutes % 10 == 1) and (math.floor(minutes / 10) ~= 1)) and " " .. translates.Get("минуту") or ((minutes % 10 > 1) and (minutes % 10 < 5) and (math.floor(minutes / 10) ~= 1)) and " " .. translates.Get("минуты") or " " .. translates.Get("минут")) or translates.Get("мин."))
	end
	
	return result
end


--[[ Vars ]]--
nw.Register("SeasonpassQuests")
	:Write(function(tbl)
		net.WriteUInt(table.Count(tbl), 8)

		for k, v in pairs(tbl) do
			net.WriteUInt(k, 8)
			net.WriteUInt(v, 16)
		end
	end)
	:Read(function()
		local tbl = {}

		for i = 1, net.ReadUInt(8) do
			local quest_id = net.ReadUInt(8)
			local progress = net.ReadUInt(16)
			
			tbl[quest_id] = progress
			
			if not rp.seasonpass.QuestUpdateProgress[quest_id] or rp.seasonpass.QuestUpdateProgress[quest_id] ~= progress then
				rp.seasonpass.QuestUpdateStamps[quest_id] = CurTime()
				rp.seasonpass.QuestUpdateProgress[quest_id] = progress
			end
		end

		return tbl
	end)
	:SetLocalPlayer()
	
nw.Register("SeasonpassRewards")
	:Write(function(tbl)
		local usual	= tbl[1]
		local prem 	= tbl[2]
		
		net.WriteUInt(table.Count(usual), 8)
		
		for k, v in pairs(usual) do
			net.WriteUInt(k, 8)
		end
		
		net.WriteUInt(table.Count(prem), 8)
		
		for k, v in pairs(prem) do
			net.WriteUInt(k, 8)
		end
	end)
	:Read(function()
		local tbl = { {}, {} }
		
		for i = 1, net.ReadUInt(8) do
			tbl[1][net.ReadUInt(8)] = true
		end
		
		for i = 1, net.ReadUInt(8) do
			tbl[2][net.ReadUInt(8)] = true
		end

		return tbl
	end)
	:SetLocalPlayer()

nw.Register('SeasonpassLevel')
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetLocalPlayer()
	
nw.Register("SeasonpassCompletedSeasons")
	:Write(function(tbl)
		net.WriteUInt(table.Count(tbl), 8)
		
		for k, v in pairs(tbl) do
			net.WriteUInt(k, 8)
		end
	end)
	:Read(function()
		local tbl = {}
		
		for i = 1, net.ReadUInt(8) do
			tbl[net.ReadUInt(8)] = true
		end
		
		return tbl
	end)
	:SetLocalPlayer()
	
nw.Register('SeasonpassRerolls')
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetLocalPlayer()
	
nw.Register('SeasonpassRerolledToday')
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()
	
nw.Register('SeasonpassProgress')
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetLocalPlayer()
	
nw.Register('SeasonpassOverride')
	:Write(net.WriteUInt, 8)
	:Read(net.ReadUInt, 8)
	:SetLocalPlayer()
	
nw.Register('SeasonpassDonated')
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()
