-- "gamemodes\\rp_base\\gamemode\\addons\\auto_code\\sh_main.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.JobsWhitelist = rp.JobsWhitelist or {
    Ranks = {
        ["root"] = true,
        ["manager"] = true,
        ["manager-plus"] = true,
        ["developer"] = true,
        ["deputy"] = true,

        --["executiveleader"] = false,
        --["executivespecialist"] = false,
        --["platinumcontributor"] = false,
        --["goldencontributor"] = false,
        --["globalcontributor"] = false,
        --["globaladmin*"] = false,
        --["superadmin*"] = false,
        --["helper"] = false,
        --["headadmin*"] = false,
        --["adminplus"] = false,
        --["admin*"] = false,
        --["globaladmin"] = false,
        --["superadmin"] = false,
        --["headadmin"] = false,
        --["admin"] = false,
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

local accessed_ranks = {
	["chiefmediapartner+"] = true,
}

function rp.PlayerHasAccessToJob(job, ply)
	if rp.cfg.Serious and accessed_ranks[ply:GetRankTable().Name] then
		return true
	end

	local id = ply:SteamID64()
	if SERVER then
		return (rp.JobsWhitelist.Players[id] and rp.JobsWhitelist.Players[id][job]) or false
	else
		return (ply:GetNetVar("Whitelist") or {})[job] or false
	end
end