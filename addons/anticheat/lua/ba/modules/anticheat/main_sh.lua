ba.AddTerm('AnticheatUnban', 'You have unbanned #.')
ba.AddTerm('AnticheatUnbanPlayerNotFound', 'Player # not found.')
ba.AddTerm('AnticheatBan', 'You have globally perma banned #.')

ba.cmd.Create('anticheatunban', function(pl, args)
	local target = ba.IsSteamID(args.target) && ba.InfoTo64(args.target) || args.target 

	if !anticheat.GetUnwantedByID(tostring(target)) then
		ba.notify(pl, ba.Term('AnticheatUnbanPlayerNotFound'), target)
		return
	end

	--ba.data.GetDB():query_ex('INSERT INTO ba_logs VALUES(NOW(), ?, "?", ?, IFNULL(?, \'unknown\'), "?", "?")', {pl:SteamID64(), pl:Nick(), target, '(SELECT Name FROM player_data WHERE SteamID='..target..')', 'ac unban', ''})
	ba.logAction(pl, target, 'ac unban', '')
	
	ba.notify(pl, ba.Term('AnticheatUnban'), target)

	anticheat.Unban(target)
end)
:AddParam('string', 'target')
:SetFlag('*')
:SetHelp('Unbans player from anticheat system')

ba.cmd.Create('anticheatban', function(pl, args)
	local steamid = ba.InfoTo64(args.target)
	anticheat.Ban(steamid)

	if ba.IsPlayer(args.target) then
		args.target:Kick()
	end

	ba.notify(pl, ba.Term('AnticheatBan'), target)

	--ba.data.GetDB():query_ex('INSERT INTO ba_logs VALUES(NOW(), ?, "?", ?, IFNULL(?, \'unknown\'), "?", "?")', {pl:SteamID64(), pl:Nick(), steamid, '(SELECT Name FROM player_data WHERE SteamID='..steamid..')', 'ac ban', ''})
	ba.logAction(pl, target, 'ac ban', tostring(args.reason or 'NoReason'))
	
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'reason')
:SetFlag('*')
:SetHelp('Globally perma bans player by anticheat system')