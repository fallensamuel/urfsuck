-- Модуль больше не работает при дисконнекте игроков.
-- Он сохраняет профу только перед авто-рестартом сервера!

hook.Add("InitPostEntity", "rp.CreateJobRecoveryTable", function()
    rp._Stats:Query("CREATE TABLE IF NOT EXISTS job_recovery(steamid BIGINT PRIMARY KEY, job VARCHAR(255), ip VARCHAR(255), mdldata VARCHAR(255));")
    rp._Stats:Query("ALTER TABLE job_recovery ADD COLUMN mdldata VARCHAR(255);")
end)

local function GetMdlCustomize(ply)
    local data = {}
    data.skin = ply:GetSkin()
    data.mdl = ply:GetModel()
    data.scale = ply:GetModelScale()
    data.bodygroups = {}

    for key, bg in pairs(ply:GetBodyGroups()) do
        data.bodygroups[key] = ply:GetBodygroup(key)
    end

    return data
end

local function SetMdlCustomize(ply, data)
    if not data or #data < 1 then return end

    ply:SetSkin(data.skin)
    ply:SetModel(data.mdl)
    ply:SetModelScale(data.scale)

    for key, bg in pairs(data.bodygroups) do
        ply:SetBodygroup(key, bg)
    end
end

function PLAYER:SaveJobRecovery()
    if self:IsBanned() then return end
    if self:GetJobTable().notRecoverOnRestart then return end

    rp._Stats:Query("SELECT * FROM job_recovery WHERE steamid=?;", self:SteamID64(), function(result)
        local mdl_data = pon.encode( GetMdlCustomize(self) )

        if #result ~= 0 then
            rp._Stats:Query("UPDATE job_recovery SET job=?, ip=?, mdldata=? WHERE steamid=?;", self:GetJobTable().command, game.GetIPAddress(), mdl_data, self:SteamID64())
        else
            rp._Stats:Query("INSERT INTO job_recovery(steamid, job, ip, mdldata) VALUES (?, ?, ?, ?);", self:SteamID64(), self:GetJobTable().command, game.GetIPAddress(), mdl_data)
        end
    end)
end

hook.Add("PlayerDataLoaded", "rp.SetSavedJob", function(ply)
    if (CurTime() > rp.cfg.timeJobRecovery) or ply:IsBanned() then return end
    
    rp._Stats:Query("SELECT * FROM job_recovery WHERE steamid = ? AND ip = ?;", ply:SteamID64(), game.GetIPAddress(), function(result)
        if(result[1] != nil) then
        	local indexJob
        	for k,v in pairs(rp.teams) do
        		if result[1].job == v.command then
        			indexJob = k
        		end
        	end
        	
        	if !indexJob or rp.teams[indexJob].notRecoverOnRestart then return end
            if !IsValid(ply) then return end

            local countJobPlayers = 0
            local maxPlayersInJob = 0 
            for k,v in pairs(player.GetAll()) do
                if v:GetJobTable() && v:GetJobTable().command == result[1].job then 
                    countJobPlayers = countJobPlayers + 1 
                    maxPlayersInJob = v:GetJobTable().max
                end
            end

            if countJobPlayers >= maxPlayersInJob && maxPlayersInJob != 0 then return end
            local model_data = result[1].mdldata

			rp._Stats:Query("DELETE FROM job_recovery WHERE steamid = ? AND ip = ?;", ply:SteamID64(), game.GetIPAddress())
			
            ply:StripWeapons();
            ply:SetTeam(indexJob, true);
            ply:Spawn();

            timer.Simple(0, function()
                if model_data then
                    SetMdlCustomize(ply, pon.decode(model_data))
                end
            end)

            ply:Notify(NOTIFY_GENERIC, rp.Term("JobRecovery"))
        end
    end)
end)

--[[
hook.Add("OnPlayerChangedTeam","rp.JobSave",function(ply, oldTeam, newTeam)
    if ply:IsBanned() then return end
    if rp.teams[newTeam] and rp.teams[newTeam].notRecoverOnRestart then return end
    rp._Stats:Query("SELECT * FROM job_recovery WHERE steamid=?;", ply:SteamID64(), function(result)
        local mdl_data = pon.encode(GetMdlCustomize(ply))

        if #result ~= 0 then
            rp._Stats:Query("UPDATE job_recovery SET job=?, ip=?, mdldata=? WHERE steamid=?;", ply:GetJobTable().command, game.GetIPAddress(), mdl_data, ply:SteamID64())
        else
            rp._Stats:Query("INSERT INTO job_recovery(steamid, job, ip, mdldata) VALUES (?, ?, ?, ?);", ply:SteamID64(), ply:GetJobTable().command, game.GetIPAddress(), mdl_data)
        end
    end)
end)
]]--