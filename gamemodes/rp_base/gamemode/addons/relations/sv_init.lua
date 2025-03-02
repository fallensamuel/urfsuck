local cooldownRewardDuration = rp.cfg.RewardCooldown
local cooldownDemoteDuration = rp.cfg.DemoteCooldown

util.AddNetworkString('rp.Relations.Actions')

local banned = {}

local RealTime = RealTime

local actionCooldown = {}

local function wrongReason(reason)
	if !reason or utf8.len(reason) < 3 or utf8.len(reason) > 20 then return false end
end

local ACTION_KICK = 1
local ACTION_FIRE = 2
local ACTION_DEMOTE = 2
local ACTION_REWARD = 3
local ACTION_REPRESS = 4

local actions = {}

net.Receive('rp.Relations.Actions', function(len, ply)
	local id = net.ReadUInt(3)
	if actions[id] then actions[id](len, ply) end
end)

local rewardCooldown = {}

actions[ACTION_REWARD] = function(len, ply)
	local target = net.ReadEntity()
	local reason = net.ReadString()


	if wrongReason(reason) then return ply:Noyify(NOTIFY_ERROR, rp.Term('WrongReason')) end

	if !(target && target:IsPlayer()) then return end
	if rewardCooldown[target:UserID()] && (rewardCooldown[target:UserID()] > RealTime()) then ply:Notify(NOTIFY_ERROR, rp.Term('TargerHasRewardCooldown'), math.floor(rewardCooldown[ply:UserID()] - RealTime())) return end

	if ply:GetFactionRank() < RANK_TRAINER then return end
	if target == ply then
		local targets = 0
		for k, target in pairs(ents.FindInSphere(ply:GetPos(), 1000)) do
			if target:IsPlayer() && rp.IsHigherRank(ply, target) then
				targets = targets + 1

				local reward = target:GetSalary()
				target:AddMoney(reward * 2)
				target:Notify(NOTIFY_GENERIC, rp.Term('RewardReceivedBy'), rp.FormatMoney(reward * 2), ply:Nick(), reason)
				ply:Notify(NOTIFY_GENERIC, rp.Term('RewardGivenBy'), target:Nick(), rp.FormatMoney(reward * 2))
			end
		end

		if targets > 0 then
			rewardCooldown[target:UserID()] = RealTime() + cooldownRewardDuration
		else
			ply:Notify(NOTIFY_GENERIC, rp.Term('PPTargNotFound'))
		end
	else
		if !(rp.IsHigherRank(ply, target)) then return end
	
		rewardCooldown[target:UserID()] = RealTime() + cooldownRewardDuration
	
		local reward = target:GetSalary()
		target:AddMoney(reward * 2)
	
		target:Notify(NOTIFY_GENERIC, rp.Term('RewardReceivedBy'), rp.FormatMoney(reward * 2), ply:Nick(), reason)
		ply:Notify(NOTIFY_GENERIC, rp.Term('RewardGivenBy'), target:Nick(), rp.FormatMoney(reward * 2))
	end
end

actions[ACTION_FIRE] = function(len, ply)
	local target = net.ReadEntity()
	local reason = net.ReadString()

	if wrongReason(reason) then return ply:Noyify(NOTIFY_ERROR, rp.Term('WrongReason')) end

	if actionCooldown[ply:UserID()] && (actionCooldown[ply:UserID()] && actionCooldown[ply:UserID()] > RealTime()) then ply:Notify(NOTIFY_ERROR, rp.Term('DemoteCooldown'), math.floor(actionCooldown[ply:UserID()] - RealTime())) return end

	if ply:GetFactionRank() < RANK_OFFICER then return end
	if !rp.IsHigherRank(ply, target) then return end
	
	target:TeamBan()

	actionCooldown[ply:UserID()] = RealTime() + cooldownDemoteDuration

	target:ChangeTeam(rp.GetDefaultTeam(target), true)

	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('HasFired'), ply:Nick(), target:Nick(), reason)
end

actions[ACTION_KICK] = function(len, ply)
	local target = net.ReadEntity()
	local reason = net.ReadString()

	if wrongReason(reason) then return ply:Noyify(NOTIFY_ERROR, rp.Term('WrongReason')) end

	if actionCooldown[ply:UserID()] && (actionCooldown[ply:UserID()] && actionCooldown[ply:UserID()] > RealTime()) then ply:Notify(NOTIFY_ERROR, rp.Term('DemoteCooldown'), math.floor(actionCooldown[ply:UserID()] - RealTime())) return end

	if ply:GetFactionRank() < RANK_LEADER then return end

	if !rp.IsHigherRank(ply, target) then return end

	banned[target:UserID()] = banned[target:UserID()] or {}
	for k, v in pairs(ply:GetFactionRelations().factions) do
		banned[target:UserID()][v] = RealTime()	+ 600
	end

	actionCooldown[ply:UserID()] = RealTime() + cooldownDemoteDuration

	target:ChangeTeam(rp.GetDefaultTeam(target), true)

	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('HasKickedFromFaction'), ply:Nick(), target:Nick(), reason)
end

actions[ACTION_DEMOTE] = function(len, ply)
	local target = net.ReadEntity()
	local reason = net.ReadString()

	if wrongReason(reason) then return ply:Noyify(NOTIFY_ERROR, rp.Term('WrongReason')) end

	if actionCooldown[ply:UserID()] && (actionCooldown[ply:UserID()] && actionCooldown[ply:UserID()] > RealTime()) then ply:Notify(NOTIFY_ERROR, rp.Term('DemoteCooldown'), math.floor(actionCooldown[ply:UserID()] - RealTime())) return end

	if ply:GetFactionRank() < RANK_OFFICER then return end

	if !rp.IsHigherRank(ply, target) then return end

	target:TeamBan()

	actionCooldown[ply:UserID()] = RealTime() + cooldownDemoteDuration

	target:ChangeTeam(rp.GetFactionPreviousRank(target), true)

	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('HasDemoted'), ply:Nick(), target:Nick(), reason)
end

actions[ACTION_REPRESS] = function(len, ply)
	local target = net.ReadEntity()
	local reason = net.ReadString()

	if wrongReason(reason) then return ply:Noyify(NOTIFY_ERROR, rp.Term('WrongReason')) end

	if actionCooldown[ply:UserID()] && (actionCooldown[ply:UserID()] && actionCooldown[ply:UserID()] > RealTime()) then ply:Notify(NOTIFY_ERROR, rp.Term('DemoteCooldown'), math.floor(actionCooldown[ply:UserID()] - RealTime())) return end

	if !rp.CanRepress(ply, target) then return end
	
	if !target:IsHandcuffed() then ply:Notify(NOTIFY_ERROR, rp.Term('RepressRequiresCuffs')) return end

	banned[target:UserID()] = banned[target:UserID()] or {}
	for k, v in pairs(ply:GetFactionRelations().factions) do
		banned[target:UserID()][v] = RealTime()	+ 600
	end
	
	target:TeamBan()

	actionCooldown[ply:UserID()] = RealTime() + cooldownDemoteDuration

	target:ChangeTeam(rp.cfg.RepressedTeam, true)

	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('HasRepressed'), ply:Nick(), target:Nick(), reason)
end

hook.Add("PlayerDisconnected", function(ply)
	rewardCooldown[ply:UserID()] = nil
	actionCooldown[ply:UserID()] = nil
	banned[ply:UserID()] = nil
end)

hook.Add("playerCanChangeTeam", function(ply, t, force)
	if !force && banned[ply:UserID()] && (banned[ply:UserID()][rp.teams[t].faction] or 0) > RealTime() then
		ply:Notify(NOTIFY_ERROR, rp.Term('FactionDemote'), math.floor(banned[ply:UserID()][rp.teams[t].faction] - RealTime()))
		return false
	end
end)