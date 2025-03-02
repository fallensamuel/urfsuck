
hook.Add('PlayerJoinSteamGroup', function(pl)
	pl:AddCredits(30, 'Steam group join')
	ba.notify_all(ba.Term('PlayerJoinedSteamGroup'), pl)
end)

hook.Add('PlayerJoinVKGroup', function(pl)
	pl:AddMoney(1000)
	ba.notify_all(ba.Term('PlayerJoinedVKGroup'), pl, rp.FormatMoney(1000))
end)

hook.Add('ShowHelp', 'motd.ShowHelp', function(pl)
	pl:ConCommand('urf motd')
	return true
end)