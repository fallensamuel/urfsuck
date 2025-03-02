local db = rp._Stats

hook('PlayerInitialSpawn', function(ply)
	db:Query("SELECT Name, Cooldown FROM player_cooldowns WHERE Cooldown > UNIX_TIMESTAMP() AND SteamID = "..ply:SteamID64(), function(data)
		if !data then return end
		local t = {}
		for k, v in pairs(data) do
			if rp.abilities.GetByName(v.Name) then
				t[rp.abilities.GetByName(v.Name):GetID()] = v.Cooldown
			end
		end
		ply:SetNetVar('AbilitiesCooldown', t)
	end)
end)

timer.Create('ClearDB', 3600, 0, function()
	db:Query("DELETE FROM player_cooldowns WHERE Cooldown < UNIX_TIMESTAMP()")
end)

util.AddNetworkString('AbilityUse')
net.Receive('AbilityUse', function(len, ply)
	local ability = net.ReadInt(6)
	if !(ability && rp.abilities.Get(ability)) then return end

	ability = rp.abilities.Get(ability)

	if ability:InCooldown(ply) then ply:Notify(NOTIFY_ERROR, rp.Term('AbilityCooldown')) return end
	if !ability:CanUse(ply) then ply:Notify(NOTIFY_ERROR, rp.Term('AbilityCantUse'), ability:CantUseReason(ply)) return end
	if ability:GetPlayTime(ply) > ply:GetPlayTime() then ply:Notify(NOTIFY_ERROR, rp.Term('AbilityNotEnoughHours')) return end
	if ability:IsVIP() && !ply:IsVIP() then ply:Notify(NOTIFY_ERROR, rp.Term('AbilityVIP')) return end
	if ability.NickCustomCheck and not ability.NickCustomCheck(ply) then
		ply:Notify(NOTIFY_ERROR, rp.Term('RequireUrfimInName'))
		return
	end
	
	ability:UpdateCooldown(ply)
	ability:Use(ply)
	ability:PlaySound(ply)

	ply:Notify(NOTIFY_GENERIC, rp.Term('SkillUsed'), ability:GetName(), ability:GetDescription())
end)