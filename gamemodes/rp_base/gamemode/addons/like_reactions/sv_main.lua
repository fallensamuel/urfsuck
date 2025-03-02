util.AddNetworkString("LikeReactSystem")
util.AddNetworkString("LikeReactSystem.Send")

local format = string.format
local LikeReactSystem = {}

---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————---

LikeReactSystem.SqlHandlers = {}

function LikeReactSystem:AddQuery(uid, handle)
    self.SqlHandlers[uid] = handle
end

function LikeReactSystem:SqlQuery(uid, callback, ...)
    local handle = self.SqlHandlers[uid]
    if not handle then return false end

    rp._Stats:Query(format(handle, ...), callback)
    return true
end

LikeReactSystem:AddQuery("InitTable", "CREATE TABLE IF NOT EXISTS `like_reascts` (`ReactorID` bigint(20) NOT NULL, `TargetID` bigint(20) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
LikeReactSystem:AddQuery("FixMyBad", "ALTER TABLE `like_reascts` DROP PRIMARY KEY;")
LikeReactSystem:AddQuery("LoadPlayerData", "SELECT `ReactorID` FROM `like_reascts` WHERE `TargetID` = %s;")
LikeReactSystem:AddQuery("AddLikeReact", "INSERT INTO `like_reascts` (`ReactorID`, `TargetID`) VALUES (%s, %s);")
LikeReactSystem:AddQuery("RemoveLikeReact", "DELETE FROM `like_reascts` WHERE `ReactorID` = %s AND `TargetID` = %s;")
--[[
LikeReactSystem:AddQuery("InitLimitTable", "CREATE TABLE IF NOT EXISTS `like_reascts_limit` (`ReactorID` bigint(20) NOT NULL, `ActTime` int(11) NOT NULL, PRIMARY KEY (`ReactorID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
LikeReactSystem:AddQuery("InsertLimit", "INSERT INTO `like_reascts_limit` (`ReactorID`, `ActTime`) VALUES (%s, %s);")
LikeReactSystem:AddQuery("UpdateLimit", "UPDATE `like_reascts_limit` SET `ActTime` = %s WHERE `ReactorID` = %s;")
LikeReactSystem:AddQuery("CheckLimit", "SELECT `ActTime` FROM `like_reascts_limit` WHERE `ReactorID` = %s;")
]]--
---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————---

LikeReactSystem.LimitsCache = {}

function LikeReactSystem:ProcessLimit(from_id, to_id, action)
    self.LimitsCache[from_id] = self.LimitsCache[from_id] or {}

    if action then
        if table.Count(self.LimitsCache[from_id]) >= (rp.cfg.MaxLikeReactionsPerDay or 1) then return true end

        self.LimitsCache[from_id][to_id] = true
    else
        self.LimitsCache[from_id][to_id] = nil
    end

    return false
end

--[[ наверное зря намудрил,ё энивэй лимиты всего на 1 день.
LikeReactSystem.ProcessLimits = function(ply, callback)
    local sid64, curtime = ply:SteamID64(), os.time()
    local limit_time = curtime + LikeReactSystem.OneDayDelay

    if LikeReactSystem.LimitsCache[sid64] then
        if LikeReactSystem.LimitsCache[sid64] > curtime then
            return callback(false)
        else
            LikeReactSystem:SqlQuery("UpdateLimit", nil, sid64, limit_time)
            callback(true)
        end
    end

    LikeReactSystem:SqlQuery("CheckLimit", function(data)
        if table.Count(data) > 0 then
            LikeReactSystem.LimitsCache[sid64]

            if data[1].ActTime > curtime then
                callback(false)
            else
                LikeReactSystem:SqlQuery("UpdateLimit", nil, sid64, limit_time)
                callback(true)
            end
        else
            LikeReactSystem:SqlQuery("InsertLimit", nil, sid64, limit_time)

            callback(true)
        end
    end, sid64)
end
]]
LikeReactSystem.LoadPlayerData = function(ply)
    ply.LikeReacts = {}
    LikeReactSystem.LimitsCache[ply:SteamID64()] = {}

    LikeReactSystem:SqlQuery("LoadPlayerData", function(data)
        if not (data or {})[1] then return end

        local PlayersBySteamID64 = {}
        for k, ply in pairs(player.GetHumans()) do
            PlayersBySteamID64[ply:SteamID64()] = ply
        end

        local count = 0
        for k, v in pairs(data) do
            count = count + 1

            ply.LikeReacts[v.ReactorID] = true
            local reactor = PlayersBySteamID64[v.ReactorID]
            if reactor then
                net.Start("LikeReactSystem.Send")
                    net.WritePlayer(ply)
                net.Send(reactor)
            end
        end

        ply:SetNetVar("LikeReacts", count)
    end, ply:SteamID64())
end

LikeReactSystem.AddLikeReact = function(reactor, target)
    local from_id, to_id = reactor:SteamID64(), target:SteamID64()

    if LikeReactSystem:ProcessLimit(from_id, to_id, true) then
        return rp.Notify(reactor, NOTIFY_ERROR, rp.Term("CantAddMoreLikeReacts"))
    end

    LikeReactSystem:SqlQuery("AddLikeReact", function(data)
        if IsValid(target) == false then return end
        
        target.LikeReacts[from_id] = true
        target:SetNetVar("LikeReacts", target:GetLikeReacts() + 1)

        if IsValid(reactor) == false then return end
        net.Start("LikeReactSystem")
        net.Send(reactor)
    end, from_id, to_id)
end

LikeReactSystem.RemoveLikeReact = function(reactor, target)
    local from_id, to_id = reactor:SteamID64(), target:SteamID64()
    
    LikeReactSystem:SqlQuery("RemoveLikeReact", function(data)
        if IsValid(target) == false then return end
        
        LikeReactSystem:ProcessLimit(from_id, to_id, false)
        target.LikeReacts[from_id] = nil
        target:SetNetVar("LikeReacts", target:GetLikeReacts() - 1)

        if IsValid(reactor) == false then return end
        net.Start("LikeReactSystem")
        net.Send(reactor)
    end, from_id, to_id)
end

---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————---

hook.Add("InitPostEntity", "LikeReactSystem.InitSQLTable", function()
    LikeReactSystem:SqlQuery("InitTable")
    LikeReactSystem:SqlQuery("FixMyBad")
end)

hook.Add("PlayerDataLoaded", "LikeReactSystem.LoadPlayerData", LikeReactSystem.LoadPlayerData)

net.Receive("LikeReactSystem", function(len, ply)
    if ply.IsCooldownAction and ply:IsCooldownAction("LikeReactSystem", 2) then
        return rp.Notify(ply, NOTIFY_ERROR, rp.Term("CooldownAction"), math.Round(ply:GetCooldownActionTIme("LikeReactSystem"), 1))
    end

    local target = net.ReadPlayer()
    if IsValid(target) == false or target:IsPlayer() == false or target == ply or not target.LikeReacts or target:IsBot() then return end

    LikeReactSystem[target:HasLikeReact(ply) and "RemoveLikeReact" or "AddLikeReact"](ply, target)
end)