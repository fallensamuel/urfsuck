AddCSLuaFile("sh_main.lua")
include("sh_main.lua")

util.AddNetworkString('Whitelist::PlayerInfo')
util.AddNetworkString('Whitelist::IDInfo')
util.AddNetworkString('Whitelist::ChangeAccess')

local function SyncWhitelistAccess(ply, tab)
    if IsValid(ply) then
        ply:SetNetVar("Whitelist", tab)
    end
end

function rp.JobsWhitelist.GiveAccess(id, team, initiator)
	if IsValid(initiator) and not initiator:IsRoot() and initiator:GetOrg() and not rp.orgs.CanTarget(initiator, id, true) then
		rp.Notify(initiator, NOTIFY_ERROR, rp.Term('WhiteListCant'))
		return
	end
	
    local ply = player.GetBySteamID64(id)
	
    local team_index = rp.teamscmd[team]
    local team_tab = team_index and rp.teams[team_index]
    local teamname = team_tab and team_tab.name or "N/A"

    if IsValid(ply) then
        rp.Notify(ply, NOTIFY_GREEN, rp.Term("WhiteListAdd"), teamname)
    end

    hook.Run("JobWhiteList.Log", true, ply or id, team_tab, initiator)

    rp._Stats:Query('REPLACE INTO `job_whitelist` (`steamid`, `job_id`) VALUES (?, ?)', id, team, function()
        rp.JobsWhitelist.Players[id] = rp.JobsWhitelist.Players[id] or {}
        rp.JobsWhitelist.Players[id][team] = true

        if IsValid(ply) then
            SyncWhitelistAccess(ply, rp.JobsWhitelist.Players[id])
        end

        if IsValid(initiator) then
            net.Start('Whitelist::ChangeAccess')
            net.Send(initiator)
        end
    end)
end

function rp.JobsWhitelist.RemoveAccess(id, team, initiator)
	if IsValid(initiator) and not initiator:IsRoot() and initiator:GetOrg() and not rp.orgs.CanTarget(initiator, id, true) then
		rp.Notify(initiator, NOTIFY_ERROR, rp.Term('WhiteListCant'))
		return
	end
	
    local ply = player.GetBySteamID64(id)

    local team_index = rp.teamscmd[team]
    local team_tab = team_index and rp.teams[team_index]
    local teamname = team_tab and team_tab.name or "N/A"

    if IsValid(ply) then
        rp.Notify(ply, NOTIFY_RED, rp.Term("WhiteListRemove"), teamname)
    end

    hook.Run("JobWhiteList.Log", false, ply or id, team_tab, initiator)

    rp._Stats:Query('DELETE FROM `job_whitelist` WHERE `steamid` = ? AND `job_id` = ?', id, team, function()
        rp.JobsWhitelist.Players[id] = rp.JobsWhitelist.Players[id] or {}
        rp.JobsWhitelist.Players[id][team] = nil

        if IsValid(ply) then
            SyncWhitelistAccess(ply, rp.JobsWhitelist.Players[id])
        end

        if IsValid(initiator) then
            net.Start('Whitelist::ChangeAccess')
            net.Send(initiator)
        end
    end)
end

local function initialise_whitelist()
    rp._Stats:Query('CREATE TABLE IF NOT EXISTS `job_whitelist` (`steamid` bigint(30) NOT NULL, `job_id` varchar(32) NOT NULL, PRIMARY KEY (`steamid`, `job_id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;')
end

hook.Add('Initialize', initialise_whitelist)

local function load_player_whitelist(ply, callback)
    local id = isstring(ply) and ply or IsValid(ply) and ply:IsPlayer() and ply:SteamID64()
    if id then 
		rp.JobsWhitelist.Players[id] = rp.JobsWhitelist.Players[id] or {}

		rp._Stats:Query('SELECT * FROM `job_whitelist` WHERE `steamid` = ?;', id, function(data)
			if not data then return end

			for k, v in pairs(data) do
				rp.JobsWhitelist.Players[id][v.job_id] = true
			end

			if IsValid(ply) then
				SyncWhitelistAccess(ply, rp.JobsWhitelist.Players[id])
			end

			if callback and isfunction(callback) then
				callback(data)
			end
		end)
	end
end

hook.Add('playerRankLoaded', 'JobWhitelistLoad', load_player_whitelist)

net.Receive('Whitelist::PlayerInfo', function(_, ply)
    if not rp.JobsWhitelist.Ranks[ply:GetRank()] then return end
    local user = net.ReadEntity()

    if IsValid(user) and user:IsPlayer() then
        net.Start('Whitelist::PlayerInfo')
        local teams = {}

        for job, _ in pairs(rp.JobsWhitelist.Players[user:SteamID64()] or {}) do
            if rp.JobsWhitelist.Map[job] then
                table.insert(teams, rp.JobsWhitelist.Map[job].team)
            end
        end

        net.WriteUInt(#teams, 10)

        for k, v in pairs(teams) do
            net.WriteUInt(v, 10)
        end

        net.Send(ply)
    end
end)

net.Receive('Whitelist::ChangeAccess', function(_, ply)
    if not rp.JobsWhitelist.Ranks[ply:GetRank()] then return end
    local sid64 = net.ReadString()
    local team = net.ReadUInt(10)

    if rp.teams[team] and rp.JobsWhitelist.Map[rp.teams[team].command or ''] then
        rp.JobsWhitelist.Players[sid64] = rp.JobsWhitelist.Players[sid64] or {}

        if rp.JobsWhitelist.Players[sid64][team] then
            rp.JobsWhitelist.RemoveAccess(sid64, rp.teams[team].command, ply)
        else
            rp.JobsWhitelist.GiveAccess(sid64, rp.teams[team].command, ply)
        end

        rp.JobsWhitelist.Players[sid64][team] = not rp.JobsWhitelist.Players[sid64][team]
    end
end)

local SendInfo = function(ply, teams)
    net.Start('Whitelist::IDInfo')
        net.WriteUInt(#teams, 10)

        for k, v in pairs(teams) do
            net.WriteUInt(v, 10)
        end
    net.Send(ply)
end

net.Receive("Whitelist::IDInfo", function(_, ply)
    if not rp.JobsWhitelist.Ranks[ply:GetRank()] then return end
    local steamid = string.Replace(net.ReadString(), " ", "")
    steamid = util.SteamIDTo64(steamid) ~= "0" and util.SteamIDTo64(steamid) or steamid -- конвертирую в SteamID64 если юзеринпут являеться SteamID32

    if rp.JobsWhitelist.Players[steamid] then
        SendInfo(ply, rp.JobsWhitelist.Players[steamid])
    else
        load_player_whitelist(steamid, function(data)
            SendInfo(ply, data)
        end)
    end
end)