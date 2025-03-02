local gsub = string.gsub
local format = function(str, f)
    return gsub(str, "#", f)
end

local CurrentAction, CurrentActionTargetName, CurrentActionTarget
local LastAction = 0

local ResetVars = function()
    CurrentActionTarget = nil
    CurrentActionTargetName = nil
    CurrentAction = nil
end

local ACTION_ADD, ACTION_REMOVE = 3, 1 -- NOTIFY_GREEN, NOTIFY_RED

local Terms = {}
Terms[ACTION_ADD]       = translates and translates.Get("# получил от вас лайк :)") or "# получил от вас лайк :)"
Terms[ACTION_REMOVE]    = translates and translates.Get("Вы забрали лайк у # :(") or "Вы забрали лайк у # :("
Terms["cooldown"]       = translates and translates.Get("Не так быстро!") or "Не так быстро!"

local CheckIsProcessing = function(notify)
    if LastAction > CurTime() then
        if notify then
            rp.Notify(ACTION_REMOVE, Terms["cooldown"])
        end
        return true
    end

    LastAction = CurTime() + 1.25
    return false
end

function PLAYER:AddLikeReaction()
    if CheckIsProcessing(true) then return end

    net.Start("LikeReactSystem")
        net.WritePlayer(self)
    net.SendToServer()

    CurrentActionTarget = self
    CurrentActionTargetName = self:Nick()
    CurrentAction = ACTION_ADD
end

function PLAYER:RemoveLikeReaction()
    if CheckIsProcessing(true) then return end

    net.Start("LikeReactSystem")
        net.WritePlayer(self)
    net.SendToServer()

    CurrentActionTarget = self
    CurrentActionTargetName = self:Nick()
    CurrentAction = ACTION_REMOVE
end

function PLAYER:ToggleLikeReaction()
    self[self:HasLikeReact() and "RemoveLikeReaction" or "AddLikeReaction"](self)
end

net.Receive("LikeReactSystem", function()
    --if CheckIsProcessing() == false then return end

    rp.Notify(CurrentAction, format(Terms[CurrentAction], CurrentActionTargetName))
    if IsValid(CurrentActionTarget) then
        CurrentActionTarget.LikeReacted = CurrentAction == ACTION_ADD
    end

    ResetVars()
end)

---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————--- —=— ---—————---—————---—————---

net.Receive("LikeReactSystem.Send", function()
    local ply = net.ReadPlayer()
    if IsValid(ply) and ply:IsPlayer() then
        ply.LikeReacted = true
    end
end)