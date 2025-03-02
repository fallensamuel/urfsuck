util.AddNetworkString 'RC_RadioSwitchSpeak'
net.Receive('RC_RadioSwitchSpeak', function(_, ply)
	if !rp.RadioSpeakers[ply:Team()] then return end
	ply:SetNetVar('RC_RadioOnSpeak', ply:GetNetVar('RC_RadioOnSpeak') ~= true)
end)

util.AddNetworkString 'RC_RadioSwitchHear'
net.Receive('RC_RadioSwitchHear', function(_, ply)
	ply:SetNetVar('RC_RadioOnHear', ply:GetNetVar('RC_RadioOnHear') ~= true)
end)

util.AddNetworkString 'RC_RadioSync'
hook.Add('PlayerChangedTeam', 'RC.RadioOnChangeTeam', function(Player, OldTeam, Team)
	--Player:SetNetVar('RC_RadioOnSpeak', false);
	Player:SetNetVar('RC_RadioOnHear', true);
	net.Start('RC_RadioSync'); net.Send(Player);
end)