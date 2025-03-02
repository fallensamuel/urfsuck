util.AddNetworkString('rp.UnlockTeam')
net.Receive('rp.UnlockTeam', function(len, ply)
	local num = net.ReadInt(10)
	if !num then return end
	t = rp.teams[num]
	if !(t && !ply:TeamUnlocked(t)) then return end

	local SkillBonus = 0;
	if (ply.GetAttributeAmount and ply:GetAttributeAmount('pro') and t.unlockPrice) then
		SkillBonus = math.ceil(t.unlockPrice * ply:GetAttributeAmount('pro') / 500);
	end

	if (ply.GetAttributeAmount and ply:GetAttributeAmount('jew') and t.unlockPrice) then
		SkillBonus = math.ceil(t.unlockPrice * (0.25 * ply:GetAttributeAmount('jew') / 100));
	end

	if !ply:CanAfford(t.unlockPrice - SkillBonus) then return rp.Notify(ply, NOTIFY_ERROR, 'CannotAfford') end

	ply:AddMoney(-t.unlockPrice + SkillBonus)
	local old = ply:GetNetVar('JobUnlocks')
	old[t.command] = true
	ply:SetNetVar('JobUnlocks', old)
	rp.Notify(ply, NOTIFY_GENERIC, rp.Term('TeamUnlocked'))
	rp.data.SaveUnlocks(ply)
end)

function rp.data.SaveUnlocks(ply)
	rp._Stats:Query('UPDATE player_data SET Unlocked=? WHERE SteamID=' .. ply:SteamID64() .. ';', pon.encode(ply:GetNetVar('JobUnlocks')))
end