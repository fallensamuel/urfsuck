ba.AddTerm('SeeConsole', 'See console for output.')

-- File log
ba.AddTerm('FileLogSwitch', '# # режим сохранения логов в файл.')

ba.cmd.Create('savelogs', function(pl)
	ba.EnableFileLog = not ba.EnableFileLog
	local state = ba.EnableFileLog and (translates and translates.Get("Включен") or "Включен") or (translates and translates.Get("Выключен") or "Выключен")
	ba.notify_staff(ba.Term('FileLogSwitch'), pl, state)
end)
:SetFlag('*')
:SetHelp('Switches logs save mode to saving in files')

-------------------------------------------------
-- Reload
-------------------------------------------------
ba.cmd.Create('Reload', function(pl, args)
	ba.logAction(pl, '', 'reload', '')
	RunConsoleCommand('changelevel', game.GetMap())
end)
:SetFlag('e') -- before I
:SetHelp('Reloads the map')

-------------------------------------------------
-- Reload
-------------------------------------------------
ba.cmd.Create('Restart', function(pl, args)
	game.GetWorld():Remove() -- do the hack
end)
:SetFlag('*')
:SetHelp('Restarts the server')

-------------------------------------------------
-- Change password
-------------------------------------------------
ba.AddTerm('PassChanged', 'Пароль сервера успешно изменен.');

ba.cmd.Create('changepassword', function(pl, args)
	RunConsoleCommand('sv_password', args.password);
	ba.notify(pl, ba.Term('PassChanged'));
end)
:AddParam('string', 'password')
:SetFlag('e')
:SetHelp('Changes server password')

-------------------------------------------------
-- Bots
-------------------------------------------------
ba.cmd.Create('Bots', function(pl, args)
	for i = 1, tonumber(args.number) do
		RunConsoleCommand('bot')
	end
end)
:SetFlag('e')
:AddParam('string', 'number')
:SetHelp('Spawns bots')

ba.cmd.Create('kickbots', function(pl)
	for _, bot in pairs(player.GetBots()) do
		bot:Kick()
	end
end)
:SetFlag('e')
:SetHelp('Kick all bots')

------
local vectr, tonum = Vector, tonumber

ba.cmd.Create('setpos', function(pl, args)
	local vec = vectr(tonum(args.X), tonum(args.Y), tonum(args.Z))

	args.target:Teleport(vec)
end)
:SetFlag('*')
:AddParam('player_entity', 'target')
:AddParam('string', 'X')
:AddParam('string', 'Y')
:AddParam('string', 'Z')
:SetHelp('Teleports on position')

ba.AddTerm('baGodOn', 'Вы включили год-мод.');
ba.AddTerm('baGodOff', 'Вы выключили год-мод.');

ba.cmd.Create('god', function(ply)
	if ply:HasGodMode() then
		ply:GodDisable()
		ba.notify(ply, ba.Term('baGodOff'))
	else
		ply:GodEnable()
		ba.notify(ply, ba.Term('baGodOn'))
	end
end)
:SetFlag('*')
:SetHelp('Toggles god mode')

-------------------------------------------------
-- Previous offences
-------------------------------------------------
--[[
ba.cmd.Create('PO')
:RunOnClient(function(args)
	ba.ui.OpenURL('http://portal.superiorservers.co/bans/?steamid=' .. ba.InfoTo32(args.target))
end)
:AddParam('player_steamid', 'target')
:SetHelp('Show\'s a players previous bans')
]]--

-------------------------------------------------
-- Staff MoTD
-------------------------------------------------
--ba.cmd.Create('SMoTD')
--:RunOnClient(function(args)
--	ba.ui.OpenURL('http://portal.superiorservers.co/smotd.php')
--end)
--:SetHelp('Opens the staff MoTD')

-------------------------------------------------
-- Lookup
-------------------------------------------------
local white = Color(220,220,220)
local ws = '\n           '
ba.cmd.Create('Lookup', function(pl, args)
	ba.notify(pl, ba.Term('SeeConsole'))
end)
:RunOnClient(function(args)
	local pl = args.target

	MsgC(white, '---------------------------\n')
	MsgC(white, pl:Name() ..'\n')
	MsgC(white, '---------------------------\n')

	MsgC(white, 'SteamID:' .. ws .. pl:SteamID() ..'\n')

	MsgC(white, 'Rank:' .. ws .. pl:GetRank() ..'\n')

	MsgC(white, 'Play Time:' .. ws .. ba.str.FormatTime(pl:GetPlayTime()) ..'\n')
end)
:AddParam('player_entity', 'target')
:SetHelp('Show\'s a players rank info')

-------------------------------------------------
-- Who
-------------------------------------------------
local white = Color(200,200,200)
ba.cmd.Create('Who', function(pl, args)
	ba.notify(pl, ba.Term('SeeConsole'))
end)
:RunOnClient(function(args)
	MsgC(white, '--------------------------------------------------------\n')
	MsgC(white, '          SteamID      |      Name      |      Rank\n')
	MsgC(white, '--------------------------------------------------------\n')

	for k, v in ipairs(player.GetAll()) do
		local id 	= v:SteamID()
		local nick 	= v:Name()
		local text 	= string.format("%s%s %s%s ", id, string.rep(" ", 2 - id:len()), nick, string.rep(" ", 20 - nick:len()))
		text 		= text .. v:GetRank()
		MsgC(white, text .. '\n')
	end
end)
:SetHelp('Show\'s the ranks for all users online')

-------------------------------------------------
-- Exec
-------------------------------------------------
ba.cmd.Create('Exec', function(pl, args)
	args.target:SendLua([[pcall(RunString, ]] .. args.lua .. [[)]])
end)
:SetFlag('*')
:AddParam('player_entity', 'target')
:AddParam('string', 'lua')
:SetHelp('Execs lua on your target')

-------------------------------------------------
-- Cheater Search
-------------------------------------------------
--[[
ba.cmd.Create('Cheater Search')
:RunOnClient(function(args)
	ba.ui.OpenURL('http://portal.superiorservers.co/adminisration/cheaters.php?steamid=' .. ba.InfoTo32(args.target))
end)
:AddParam('player_steamid', 'target')
:SetFlag('D')
:SetHelp('List\'s a players cheating infractions')
]]--