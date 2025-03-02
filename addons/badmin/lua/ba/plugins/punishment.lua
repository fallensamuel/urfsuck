ba.AddTerm('AdminKickedPlayer', '# кикнул #. Причина: #.')
ba.AddTerm('AdminBannedPlayer', '# забанил # на #. Причина: #.')
ba.AddTerm('BannedTimeIncreased', 'Время бана увеличено на # минут за прошлые нарушения.')
ba.AddTerm('AdminUpdatedBan', '# обновил бан # до #. Причина: #.')
ba.AddTerm('PlayerAlreadyBanned', 'Этот игрок уже имеет бан. Чтобы его продлить вам нужен флаг доступа "D".')
ba.AddTerm('BanNeedsPermission', 'Для бесконечного бана вам нужно разрешение, укажите ник кто вам его дал. Добавьте в причину perm:НикАдмина')
ba.AddTerm('AdminPermadPlayer', '# забанил навсегда #. Причина: #.')
ba.AddTerm('AdminUpdatedBanPerma', '# продлил бан навсегда #. Причина: #.')
ba.AddTerm('PlayerAlreadyPermad', 'Этот игрок уже имеет бан! Чтобы его продлить навсегда, вам нужен флаг доступа "G".')
ba.AddTerm('AdminUnbannedPlayer', '# разбанил #. Причина: #.')
ba.AddTerm('TerminalBan', '# получил терминальный бан от # на # за # нарушений подряд. Причина: #.')
ba.AddTerm('TerminalBanLeft', 'Если вы будете забанены ещё # раз, то получите терминальный бан на #.')

-------------------------------------------------
-- Kick
-------------------------------------------------
ba.cmd.Create('Kick', function(pl, args)
	if not ba.cmd.IsValidAmount(pl, 'kick') then return end
	
	ba.notify_all(ba.Term('AdminKickedPlayer'), pl, args.target, args.reason)
	args.target:Kick(args.reason)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'reason')
:SetFlag('M')
:SetHelp('Kicks your target from the server')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Ban
-------------------------------------------------
local baBansAmount = {}
local baBanRefillTime = 10 * 60
local baMaxBans = 7

local function isValidBansAmount(pl)
	if not IsValid(pl) then return true end -- if console
	baBansAmount[pl:SteamID()] = baBansAmount[pl:SteamID()] or { 
		LastBan 	= 0, 
		BansAmount 	= 0 
	}
	
	if baBansAmount[pl:SteamID()].LastBan ~= 0 then
		local bans_refilled = math.floor((CurTime() - baBansAmount[pl:SteamID()].LastBan) / baBanRefillTime)
		
		baBansAmount[pl:SteamID()].LastBan 		= baBansAmount[pl:SteamID()].LastBan + bans_refilled * baBanRefillTime
		baBansAmount[pl:SteamID()].BansAmount 	= baBansAmount[pl:SteamID()].BansAmount - bans_refilled
	end
	
	if baBansAmount[pl:SteamID()].BansAmount >= baMaxBans then
		ba.notify_err(pl, ba.Term('BansLimitExceeded'), string.FormattedTime(math.ceil(baBansAmount[pl:SteamID()].LastBan + baBanRefillTime - CurTime()), "%02i:%02i"))
		return false
	end
	
	baBansAmount[pl:SteamID()].LastBan 		= (baBansAmount[pl:SteamID()].LastBan == 0) and CurTime() or baBansAmount[pl:SteamID()].LastBan
	baBansAmount[pl:SteamID()].BansAmount 	= baBansAmount[pl:SteamID()].BansAmount + 1
	
	return true
end

local time_table = {
	{
		id = 'mo', 
		ln = 2592000,
	}, 
	{
		id = 'w', 
		ln = 604800,
	}, 
	{
		id = 'd', 
		ln = 86400,
	}, 
	{
		id = 'h', 
		ln = 3600,
	}, 
	{
		id = 'mi', 
		ln = 60,
	}, 
}

local function get_len_str(raw_time) 
	local raw_time_str
	
	for k, v in pairs(time_table) do 
		if raw_time < v.ln then continue end
		raw_time_str = math.ceil(raw_time / v.ln) .. v.id
		break
	end
	
	return raw_time_str
end

ba.cmd.Create('Ban', function(pl, args)
	local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))

	if args.time == 0 and not pl:HasFlag('P') then
		ba.notify_err(pl, ba.Term('NeedFlagToUseCommand'), 'P', 'perma')
	end
	
	if args.time > 40 * 60 then
		args.time = 40 * 60
		args.raw.time = '40mi'
	end
	
	if not ba.cmd.IsValidAmount(pl, 'ban') then return end
	
	if not banned then
		ba.Ban(args.target, args.reason, args.time, pl, function(data)
			if data.is_terminal then
				local raw_time = data.unban_time - data.ban_time
				ba.notify_all(ba.Term('TerminalBan'), args.target, pl, get_len_str(raw_time) or args.raw.time, data.bans_count, args.reason)
			else
				--local left_bans = data.bans_count < 10 and 10 - data.bans_count or data.bans_count < 20 and 20 - data.bans_count or data.bans_count < 30 and 30 - data.bans_count
				
				local left_bans = 10 - (data.bans_count % 10)
				local ban_len = math.ceil(data.bans_count / 10)
				ban_len = ban_len == 1 and '6h' or ban_len == 2 and '1w' or ban_len == 3 and '1mo'
				
				ba.notify_all(ba.Term('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
				
				if ban_len then
					ba.notify(args.target, ba.Term('TerminalBanLeft'), left_bans, ban_len)
				end
			end
		end)
	elseif banned and (not ba.IsPlayer(pl) or args.time > 0 and pl:HasAccess('S') or args.time == 0 and pl:IsRoot()) then
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
			ba.notify_all(ba.Term('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
		end)
	else
		ba.notify_err(pl, ba.Term('PlayerAlreadyBanned'))
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag('M')
:SetHelp('Bans your target from the server')
:SetIcon('icon16/door_open.png')

ba.cmd.Create('Prolonged Ban', function(pl, args)
	if not pl:IsRoot() then return end
	
	local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))

	if args.time > 3 * 30 * 24 * 60 * 60 then
		args.time = 3 * 30 * 24 * 60 * 60
		args.raw.time = '3mo'
	end
	
	if not banned then
		ba.Ban(args.target, args.reason, args.time, pl, function(data)
			if data.is_terminal then
				local raw_time = data.unban_time - data.ban_time
				ba.notify_all(ba.Term('TerminalBan'), args.target, pl, get_len_str(raw_time) or args.raw.time, data.bans_count, args.reason)
			else
				ba.notify_all(ba.Term('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
			end
		end, true)
	else
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
			ba.notify_all(ba.Term('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
		end)
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('time', 'time')
:AddParam('string', 'reason')
:SetFlag('P')
:SetHelp('Bans your target from the server')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Perma
-------------------------------------------------
ba.cmd.Create('Perma', function(pl, args)
	local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))

	if not banned then
		ba.Ban(args.target, args.reason, 0, pl, function()
			ba.notify_all(ba.Term('AdminPermadPlayer'), pl, args.target, args.reason)
		end)
	elseif banned --[[and (not ba.IsPlayer(pl) or (pl:HasAccess('S') and pl:HasAccess("H") and pl:HasAccess("D"))) ]] then
		ba.UpdateBan(ba.InfoTo64(args.target), args.reason, 0, pl, function()
			ba.notify_all(ba.Term('AdminUpdatedBanPerma'), pl, args.target, args.reason)
		end)
	else
		ba.notify_err(pl, ba.Term('PlayerAlreadyPermad'))
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'reason')
:SetFlag('P')
:SetHelp('Bans your target from the server forever')
:SetIcon('icon16/door_open.png')

-------------------------------------------------
-- Unban
-------------------------------------------------
ba.cmd.Create('Unban', function(pl, args)
	ba.Unban(ba.InfoTo64(args.steamid), args.reason, function()
		ba.notify_all(ba.Term('AdminUnbannedPlayer'), pl, args.steamid, args.reason)
		ba.logAction(pl, args.steamid, 'unban', args.reason)
	end)
end)
:AddParam('player_steamid', 'steamid')
:AddParam('string', 'reason')
:SetFlag('S')
:SetHelp('Unbans your target from the server forever')
:SetIcon('icon16/door_open.png')
