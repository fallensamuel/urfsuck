
--[[
	TODO:
	
	На старте сервера создавать таблицу выданных глобальных рангов global_ranks_given базы rp._Stats, получать глобальные ранги из таблицы global_ranks базы sync_hours
	При заходе на сервер, проверяется наличие игрока в таблице выданных глобальных рангов
	Если игрок есть, проверяется, выдавалось ли ему всё на текущем сервере в таблице global_ranks базы rp._Stats
	Если нет - производить выдачу привелегий в зависимости от конфига в cfg_default
]]

local function is_higher_rank(rank_check, rank_with)
	local rank_data1 = rp.cfg.GlobalRanks[rank_check]
	local rank_data2 = rp.cfg.GlobalRanks[rank_with]
	
	if not rank_data1 or not rank_data1.grade then 
		return false 
	end
	
	if not rank_data2 or not rank_data2.grade then 
		return true
	end
	
	return rank_data1.grade > rank_data2.grade
end


local function get_global_ranks()
	rp.syncHours.db:Query('SELECT * FROM `global_ranks`;', function(data)
		rp.cfg.GlobalRankPlayers = {}
		
		for k, v in pairs(data or {}) do
			rp.cfg.GlobalRankPlayers[v.steamid] = v
			
			--if v.custom_data then
			--	rp.cfg.GlobalRankPlayers[v.steamid].custom_data = util.JSONToTable(v.custom_data)
			--end
		end
	end)
end

local function initialize()
	rp._Stats:Query('CREATE TABLE IF NOT EXISTS `global_ranks_given` (`steamid` bigint(20) NOT NULL, `rank` varchar(32) CHARACTER SET utf8 NOT NULL, `active_until` int(11) DEFAULT NULL, PRIMARY KEY (`steamid`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;')
	
	rp.cfg.GlobalRanksMap = {}
	
	for k, v in pairs(rp.cfg.GlobalRanks) do
		if v.main_rank or v.global_rank then
			rp.cfg.GlobalRanksMap[v.main_rank or v.global_rank] = v
		end
	end
	
	timer.Create('rp.GlobalRanks.LoadPlayers', 60, 0, get_global_ranks)
	get_global_ranks()
end

hook.Add('InitPostEntity', 'rp.GetGlobalRanks', initialize)


local function give_priveleges(ply, data)
	--PrintTable(data)
	--print(ply:GetRankTable())
	
	if data.rank and ply:GetRankTable():GetID() < 3 then --data.rank then
		ba.data.SetRank(ply, data.rank, data.rank, 0) -- cback
	end
	
	if data.time and data.time > 0 then
		ply:SetNetVar('PlayTime', ply:GetNetVar('PlayTime') + data.time * 3600)
		ba.data.UpdatePlayTime(ply)
	end
	
	if data.credits and data.credits > 0 then
		ply:AddCredits(data.credits, data.printname) -- cback
	end
	
	if data.custom_reward then
		data.custom_reward(ply)
	end
	
	ply:SetNetVar('GlobalRank', data.name)
	ply:SetNetVar('GlobalRankData', data.custom_data or '')
	ply:SetNetVar('GlobalRankUntil', data.active_until or 0)
	
	rp._Stats:Query('REPLACE INTO `global_ranks_given` SET `steamid` = ?, `rank` = ?, active_until = ?;', ply:SteamID64(), data.name, data.active_until or 'NULL', function()
		if not IsValid(ply) then return end
		rp.NotifyAll(NOTIFY_GREEN, rp.Term('GlobalRankGiven'), ply:Nick(), data.printname)
	end)
end

local function give_global_rank(ply)
	if not IsValid(ply) then return end
	
	local steamid = ply:SteamID64()
	
	local rank_info = rp.cfg.GlobalRankPlayers[steamid] or {}
	local rank_data = rp.cfg.GlobalRanks[rank_info.rank or 'invalid rank']
	
	if not rank_data then 
		return print('[GLOBAL RANKS]', ply, 'has invalid global rank!', rank_info.rank)
	end
	
	local is_main_server = rank_info.main_server and rp.cfg.ServerUID == rank_info.main_server
	
	give_priveleges(ply, {
		name = rank_info.rank, 
		printname = rank_data.name, 
		custom_reward = rank_data.custom_reward, 
		custom_data = rank_info.custom_data, 
		active_until = rank_info.active_until,
		
		rank = is_main_server and rank_data.main_rank or rank_data.global_rank, 
		time = is_main_server and rank_data.main_hours or rank_data.global_hours, 
		credits = is_main_server and rank_data.main_credits or rank_data.global_credits, 
	})

	if rp.AutoGiveWhitelist[rank_info.rank] then
		for k, v in pairs(rp.AutoGiveWhitelist[rank_info.rank]) do
			rp.JobsWhitelist.GiveAccess(ply:SteamID64(), v)
		end
	end
end

local function update_global_rank(ply, old_rank)
	if not IsValid(ply) then return end
	
	local steamid = ply:SteamID64()
	
	local rank_info = rp.cfg.GlobalRankPlayers[steamid] or {}
	local rank_data = rp.cfg.GlobalRanks[rank_info.rank or 'invalid rank']
	
	local old_rank_data = rp.cfg.GlobalRanks[old_rank or 'invalid rank']
	
	if not rank_data or not old_rank_data then 
		return print('[GLOBAL RANKS]', ply, 'has invalid global rank!', rank_info.rank, '(' .. tostring(old_rank) .. ')')
	end
	
	local is_main_server 	= rank_info.main_server and rp.cfg.ServerUID == rank_info.main_server
	
	local old_time = is_main_server and old_rank_data.main_hours or old_rank_data.global_hours
	local old_credits = is_main_server and old_rank_data.main_credits or old_rank_data.global_credits
	
	local needed_time = is_main_server and rank_data.main_hours or rank_data.global_hours
	local needed_credits = is_main_server and rank_data.main_credits or rank_data.global_credits
	
	give_priveleges(ply, {
		name = rank_info.rank, 
		printname = rank_data.name, 
		custom_data = rank_info.custom_data, 
		active_until = rank_info.active_until,
		
		rank = is_main_server and rank_data.main_rank or rank_data.global_rank, 
		time = math.max(needed_time - old_time, 0), 
		credits = math.max(needed_credits - old_credits, 0), 
	})
end

local function check_global_rank(ply)
	local steamid = ply:SteamID64()
	
	local needed_rank = rp.cfg.GlobalRankPlayers[steamid]
	
	if needed_rank then 
		local needed_rank_data = rp.cfg.GlobalRanks[needed_rank.rank or 'invalid rank']
		local rank_expired = needed_rank.active_until and needed_rank.active_until <= os.time()
		
		if needed_rank_data then
			timer.Simple(10, function()
				if not IsValid(ply) then return end
				
				rp._Stats:Query('SELECT * FROM `global_ranks_given` WHERE `SteamID` = ?;', steamid, function(data)
					if data and data[1] then 
						
						if rank_expired then
							rp.GlobalRanks.ClearRank(steamid)
							return
						end
						
						if not is_higher_rank(needed_rank_data.grade, data[1].rank) then
							ply:SetNetVar('GlobalRank', needed_rank.rank)
							ply:SetNetVar('GlobalRankData', needed_rank.custom_data or '')
							ply:SetNetVar('GlobalRankUntil', needed_rank.active_until or 0)
							
							if needed_rank.active_until and needed_rank.active_until > os.time() and IsValid(ply) then
								timer.Create('GlobalRankExpire' .. steamid, needed_rank.active_until - os.time(), 1, function()
									rp.GlobalRanks.ClearRank(steamid)
								end)
							end
							
							return
						end
						
						print('[GLOBAL RANKS]', ply, 'needs to update his global rank!')
						return update_global_rank(ply, data[1].rank)
					end
					
					if not rank_expired then
						print('[GLOBAL RANKS]', ply, 'needs to setup his global rank!')
						give_global_rank(ply)
					end
				end)
			end)
		end
	end
end

hook.Add('playerRankLoaded', 'rp.GlobalRankCheck', check_global_rank)


-- GLOBAL INTERFACES
rp.GlobalRanks = rp.GlobalRanks or {}

function rp.GlobalRanks.GetInfo(steamid)
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	if not rank_info then return {} end
	
	return (not rank_info.active_until or rank_info.active_until > os.time()) and rank_info or {}
end

function rp.GlobalRanks.IsRanked(steamid)
	return rp.GlobalRanks.GetInfo(steamid).rank and true or false
end

function rp.GlobalRanks.IsHigherRank(rank_check, rank_with)
	return is_higher_rank(rank_check, rank_with)
end

function rp.GlobalRanks.GiveRank(steamid, rank, custom_data, cback, forced, active_until, only_update)
	if not rp.cfg.GlobalRanks[rank] then return end
	if not forced and rp.GlobalRanks.IsRanked(steamid) then return end
	
	if custom_data then
		custom_data = util.TableToJSON(custom_data)
	end
	
	local callback = function(data)
		rp.cfg.GlobalRankPlayers[steamid] = {
			steamid = steamid, 
			rank = rank, 
			main_server = rp.cfg.ServerUID, 
			custom_data = custom_data,
			active_until = active_until,
		}
		
		local ply = player.GetBySteamID64(steamid)
		
		if IsValid(ply) then
			give_global_rank(ply)
		end
		
		if cback then
			cback()
		end
	end
	
	if only_update then
		if active_until then
			rp.syncHours.db:Query('UPDATE `global_ranks` SET `rank` = ?, `custom_data` = ?, `active_until` = ? WHERE `steamid` = ?;', rank, custom_data, tonumber(active_until) or 'NULL', steamid, callback)
		else
			rp.syncHours.db:Query('UPDATE `global_ranks` SET `rank` = ?, `custom_data` = ? WHERE `steamid` = ?;', rank, custom_data, steamid, callback)
		end
	else
		rp.syncHours.db:Query('REPLACE INTO `global_ranks` VALUES(?, ?, ?, ?, ?)', steamid, rank, rp.cfg.ServerUID, custom_data, tonumber(active_until) or 'NULL', callback)
	end
end

function rp.GlobalRanks.ClearRank(steamid)
	if not rp.cfg.GlobalRankPlayers[steamid] then return end
	local prev_rank = rp.cfg.GlobalRankPlayers[steamid].rank
	
	rp._Stats:Query('DELETE FROM `global_ranks_given` WHERE `SteamID` = ?;', steamid, function()
		local ply = player.GetBySteamID64(steamid)
		
		rp._Stats:Query('DELETE FROM `player_emoji` WHERE `steamid` = ?;', steamid)
		rp._Stats:Query('DELETE FROM `custom_toolguns` WHERE `SteamID` = ?;', steamid)
		
		if IsValid(ply) then
			if ply:GetRankTable().ID == rp.cfg.GlobalRanks.global_prem.global_rank then
				ba.data.SetRank(ply, 1, 1, 0)
			end
			
			ply:SetCustomToolgun(nil)
			
			ply:SetNetVar('NickEmoji', nil)
			ply:SetNetVar('GlobalRank', nil)
			ply:SetNetVar('GlobalRankData', nil)
			ply:SetNetVar('GlobalRankUntil', nil)
		else
			ba.data.SetRank(util.SteamIDFrom64(steamid), 'user', 'user', 0)
		end
		
		hook.Run('GlobalRankDiscarded', steamid, prev_rank)
	end)
end
