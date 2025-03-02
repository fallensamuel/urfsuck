rp.JobsWhitelist = rp.JobsWhitelist or {
	Ranks = {
		["root"] = true,
		["manager"] = true,
		["manager-plus"] = true,
		["developer"] = true
	},
	Players = {}
}

hook.Add('ConfigLoaded', 'WhitelistSetupTeamsMap', function()
	rp.JobsWhitelist.Map = {}
	
	for _, v in pairs(rp.teams) do
		if v.command and v.whitelisted then
			rp.JobsWhitelist.Map[v.command] = v
		end
	end
end)

hook.Add("ConfigLoaded", "WhitelistAllowedRanks", function()
	if rp.cfg.WhiteListAllowedRanks then
		for _, rank in pairs(rp.cfg.WhiteListAllowedRanks) do
			rp.JobsWhitelist.Ranks[rank] = true
		end
	end
end)

function rp.PlayerHasAccessToJob(job, ply)
	local id = ply:SteamID64()
	if SERVER then
		return (rp.JobsWhitelist.Players[id] and rp.JobsWhitelist.Players[id][job])
	else
		return ply:GetNetVar("Whitelist")[job]
	end
end