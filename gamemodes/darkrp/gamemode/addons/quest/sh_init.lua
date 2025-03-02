-- "gamemodes\\darkrp\\gamemode\\addons\\quest\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Quest = {}
rp.Quest.Rewards = {}
rp.Quest.NPC = {}
rp.Quest.Stored = {}
rp.Quest.Mapping = {}
rp.Quest.Rewards = {}
rp.Quest.NPCQuests = {}

-- QuestReward

local function defaultRewardNotify(ply, t, data)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestReward'), t.format(data))
end

function rp.Quest.AddRewardType(t)
	local id = #rp.Quest.Rewards + 1
	if !t.notify then
		t.notify = defaultRewardNotify
	end
	rp.Quest.Rewards[id] = t
	return id
end

function rp.Quest.GetReward(type)
	return rp.Quest.Rewards[type]
end

quest_mt = {}
quest_mt.__index = quest_mt

-- vars
AddMethod(quest_mt, 'Name')
AddMethod(quest_mt, 'ID')
AddMethod(quest_mt, 'UID')
AddMethod(quest_mt, 'Desc', 'invalid desc')
AddMethod(quest_mt, 'Objective')
AddMethod(quest_mt, 'Rewards', nil)
AddMethod(quest_mt, 'Prepayment', nil)

AddMethod(quest_mt, 'OnProgressChanged')
AddMethod(quest_mt, 'UnlockTime', 0)
AddMethod(quest_mt, 'VIP', false)
AddMethod(quest_mt, 'Cooldown', false)
AddMethod(quest_mt, 'RejectCooldown', nil)
AddMethod(quest_mt, 'FailCooldown', 0)
AddMethod(quest_mt, 'NotRepeatable', true)
AddMethod(quest_mt, 'AutoComplete', false)
AddMethod(quest_mt, 'CompletionTime')
AddMethod(quest_mt, 'ClientsideCompletion', false)

AddMethod(quest_mt, 'Color', Color(255, 204, 0))

-- utils
AddMethod(quest_mt, 'Timer')

-- methods
AddMethod(quest_mt, 'CustomCheck', function(ply) return true end)
AddMethod(quest_mt, 'OnFail')
AddMethod(quest_mt, 'OnStart')
AddMethod(quest_mt, 'OnComplete')
AddMethod(quest_mt, 'OnTaskComplete')
AddMethod(quest_mt, 'OnEnd')
AddMethod(quest_mt, 'OnReject')

AddMethod(quest_mt, 'TransmitStart')
AddMethod(quest_mt, 'ReadTransmitStart')
AddMethod(quest_mt, 'TransmitEnd')
AddMethod(quest_mt, 'ReadTransmitEnd')

AddMethod(quest_mt, 'CanAccept', function() return true end)

AddMethod(quest_mt, 'StartNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestStarted'), self.Name)
end)
AddMethod(quest_mt, 'FailNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestFailed'), self.Name)
end)
AddMethod(quest_mt, 'RejectNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestRejected'), self.Name)
end)
AddMethod(quest_mt, 'CompleteNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestCompleted'), self.Name)
end)
AddMethod(quest_mt, 'TaskCompleteNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestTaskCompleted'), self.Name)
end)
AddMethod(quest_mt, 'CustomCheckNotifyDesc', 'попробуйте позднее')
AddMethod(quest_mt, 'CustomCheckNotify', function(self, ply)
	ply:Notify(NOTIFY_GENERIC, rp.Term('QuestUnacceptableInTheMoment'), self:GetCustomCheckNotifyDesc())
end)

function quest_mt:Server(f)
	if SERVER then f() end
end

function quest_mt:Client(f)
	if CLIENT then f() end
end

function quest_mt:SetNPC(ids)
	if !istable(ids) then
		ids = {ids}
	end
	for k, v in pairs(ids) do
		table.insert(rp.Quest.NPCQuests[v], self)
	end
	return self
end

function quest_mt:SetItem(item_mt)

	local t = {}
	t.__index = t

	setmetatable(t, item_mt)

	t:SetQuest(self)
	self.Item = t


	return t
end
 
function quest_mt:GetItem() return self.Item end



quest_mt.RequireCompletion = {}
function quest_mt:SetRequireCompletion(t)
	if t[1] then
		self.RequireCompletion = t
	else
		self.RequireCompletion = {t}
	end
	return self
end
function quest_mt:GetRequireCompletion(t)
	return self.RequireCompletion
end



function quest_mt:CalculateCompletionTime(ply)
	return self:GetCompletionTime()
end

function quest_mt:SetCompletionTime(time)
	self:SetTimer(true)
	self.CompletionTime = time
	return self
end

function quest_mt:GetCompletionTime() return self.CompletionTime end


quest_mt.MaxProgress = 1
function quest_mt:SetMaxProgress(i)
	self.MaxProgress = i
	return self
end
function quest_mt:GetMaxProgress(i)
	return self.MaxProgress
end


quest_mt.Allowed = nil
quest_mt.Disallowed = nil
function quest_mt:SetAllowed(t)
	self.Allowed = {}
	if istable(t) then
		for k, v in pairs(t) do
			self.Allowed[v] = true
		end
	else
		self.Allowed[t] = true
	end
	return self
end

function quest_mt:SetDisallowed(t)
	self.Disallowed = {}
	if istable(t) then
		for k, v in pairs(t) do
			self.Disallowed[v] = true
		end
	else
		self.Disallowed[t] = true
	end
	return self
end

function quest_mt:SetNotRepeatable()
	self:SetCooldown(0)
	self.NotRepeatable = true
end

function quest_mt:GetAllowed() return self.Allowed, self.Disallowed end

function quest_mt:IsAllowed(ply)
	if self.Allowed == nil && self.Disallowed == nil then
		return true
	elseif self.Allowed && !self.Disallowed then
		return self.Allowed[ply:Team()]
	elseif !self.Allowed && self.Disallowed then
		return !self.Disallowed[ply:Team()]
	else
		return self.Allowed[ply:Team()] && !self.Disallowed[ply:Team()]
	end
	return true
end



local cooldown = 0
function quest_mt:CalculateCooldown(ply)
	local cooldown = self:GetCooldown()

	if cooldown != 0 then
		cooldown = cooldown + os.time()
	end
	return cooldown
end

function quest_mt:GetRemainingCooldown(ply)
	return (ply:GetQuestCooldown(self) - os.time())
end

function quest_mt:HasRemainingCooldown(ply)
	return ply:GetQuestCooldown(self) && (ply:GetQuestCooldown(self) == 0 || (ply:GetQuestCooldown(self) > os.time()))
end


function quest_mt:GetHooks()
	return self.Hooks
end
function quest_mt:AddHook(name, func)
	self.Hooks = self.Hooks or {}
	self.ActiveHookCount = 0

	self.Hooks[name] = function(...) func(self, ...) end
	return self
end


function quest_mt:CalculateRejectCooldown(ply)
	return self.RejectCooldown + os.time()
end

function quest_mt:CalculateFailCooldown(ply)
	local cooldown = self:GetFailCooldown()

	if cooldown != 0 then
		cooldown = cooldown + os.time()
	end
	return cooldown
end

function quest_mt:AddAssasinateTargetByTeam(t)
	if SERVER then
		self.AssasinateTeams = {}
		for k, v in pairs(istable(t) && t || {t}) do
			self.AssasinateTeams[v] = true
		end
		self:SetOnStart(function(self, ply)
			local last
			for k, v in pairs(player.GetAll()) do
				if self.AssasinateTeams[v:Team()] then
					if math.random(1, 3) == 3 then
						last = v
						break
					else
						last = v
					end
				end
			end
			if last then
				if istable(ply.currentHit) then
					ply.currentHits[last:UserID()] = self:GetID()
				else
					ply.currentHits = {}
					ply.currentHits[last:UserID()] = self:GetID()
				end

				ply:Notify(NOTIFY_GENERIC, rp.Term('QuestYourHitIs'), last:Nick())
			else
				self:Fail(ply)
			end
		end)

		self:SetCustomCheck(function(self)
			for k, v in pairs(player.GetAll()) do
				if self.AssasinateTeams[v:Team()] then
					return true
				end
			end
			return false
		end)

		self:SetCustomCheckNotifyDesc("нет подходящей цели")

		self:SetOnEnd(function(self, ply)
			if !ply.currentHits then return end
			for k, v in pairs(ply.currentHits) do
				if v == self:GetID() then
					ply.currentHits[k] = nil
					return
				end
			end
		end)

		self:AddHook("PlayerDeath", function(self, victim, inflictor, attacker)
			if attacker:IsPlayer() && attacker.currentHits && attacker.currentHits[victim:UserID()] == self:GetID() then
				hook.Call('playerCompletedHit', nil, attacker, victim)
				rp.NotifyAll(NOTIFY_GENERIC, rp.Term('HitComplete'), victim)
				self:Complete(attacker)
			end
		end)
	end

	return self
end

function quest_mt:AddAssasinateTargetByFaction(f, t)
	return self:AddAssasinateTargetByTeam(rp.GetFactionTeams(f, t))
end

rp.Quest.NPCTargetQuestList = {}
function quest_mt:AddNPCTarget(class)
	rp.Quest.NPCTargetQuestList[class] = self
	return self
end

function rp.Quest.GetNPCQuests(id)
	return rp.Quest.NPCQuests[id]
end

function rp.Quest.Get(id)
	return rp.Quest.Stored[id]
end

function rp.Quest.GetByUID(uid)
	return rp.Quest.Mapping[uid]
end

function rp.Quest.GetAll()
	return rp.Quest.Stored
end


local count = 1
function rp.Quest.Add(name, uid)
	if rp.Quest.Mapping[uid] then
		Error('UID for '..name..' ('..uid..') is already used! Rename it!')
	end
	local t = {
		Name = name,
		UID = uid:lower(),
		ID = count,
		Stackable = true
	}
	t.Parent = quest_mt

	setmetatable(t, quest_mt)
	rp.Quest.Stored[t.ID] = t
	rp.Quest.Mapping[t.UID] = t
	count = count + 1

	return t
end

local npc_id = 0
function rp.Quest.AddNPC(t)
	npc_id = npc_id + 1
	rp.Quest.NPCQuests[npc_id] = {}
	rp.Quest.NPC[npc_id] = t
	return npc_id
end

function rp.Quest.GetNPC(id)
	return rp.Quest.NPC[id]
end