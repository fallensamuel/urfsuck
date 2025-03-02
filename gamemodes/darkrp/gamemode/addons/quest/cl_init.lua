-- "gamemodes\\darkrp\\gamemode\\addons\\quest\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local sounds = Sound('skyrim/intro.wav')

quests = quests or {}
quest_cooldown = quest_cooldown or {}
quest_entities = quest_entities or {}
quest_timer = quest_timer or {}
quest_rewards = quest_rewards or {}

local QUEST_COMPLETED = 0
local QUEST_REJECTED = 1
local QUEST_FAILED = 2
local QUEST_TASK_COMPLETED = 3

rp.Quest.NextThink = 0

function rp.Quest.Start(quest)
	net.Start('rp.StartQuest')
		net.WriteUInt(isnumber(quest) && quest || quest:GetID(), 7)
	net.SendToServer()
end

function rp.Quest.CompleteQuest(quest)
	net.Start('rp.QuestCompleted')
		net.WriteUInt(isnumber(quest) && quest || quest:GetID(), 7)
	net.SendToServer()

	quest_rewards[isnumber(quest) && quest || quest:GetID()] = nil
end

function rp.Quest.Reject(id)
	net.Start('rp.QuestRejected')
		net.WriteUInt(id, 7)
	net.SendToServer()
end

function PLAYER:HasIncompleteTask(quest)
	return self:GetQuest(quest) && !self:IsQuestCompleted(quest)
end

function PLAYER:GetQuest(quest)
	if isnumber(quest) then
		return quests[quest]
	else
		return quests[quest:GetID()]
	end
end

function PLAYER:IsQuestCompleted(quest)
	if isnumber(quest) then
		return quest_rewards[quest]
	else
		return quest_rewards[quest:GetID()]
	end
end

function PLAYER:GetQuestCooldown(quest)
	return quest_cooldown[quest:GetID()]
end

function PLAYER:GetQuestEntity(quest)
	return quest_entities[quest:GetID()]
end

function PLAYER:CompleteQuestTask(quest)
	if quest:GetClientsideCompletion() then
		net.Start('rp.QuestEnded')
			net.WriteInt(quest:GetID(), 7)
		net.SendToServer()
	end
end

function quest_mt:AddMapIcon(pos, name, color)
	quest_mt.MapIcons = quest_mt.MapIcons or {}
	table.insert(quest_mt.MapIcons, {pos = pos, name = name, color = color})
end

function quest_mt:GetMapIcons() return self.MapIcons end

local desc
function quest_mt:BuildDesc()
	desc = self:GetDesc()
	if self:GetObjective() then
		desc = desc .. "\n\nЗадача:\n"..self:GetObjective()
	end

	if self:GetRewards() then
		desc = desc .. "\n\nНаграда:\n"..self:BuildRewards()
	end

	local s
	for k, v in pairs(self:GetRequireCompletion()) do
		if !ply:GetQuestCooldown(v) then
			if s then
				s = s .. ", "..v:GetName()
			else
				s = v:GetName()
			end
		end
	end
	if s then
		desc = desc .. "\n\nТребует выполнения:\n"..s
	end
	return desc
end

local rewards = nil
function quest_mt:BuildRewards()
	rewards = nil
	for k, v in pairs(self:GetRewards()) do
		rewards = rewards && rewards .. ", ".. rp.Quest.GetReward(k).format(v) || rp.Quest.GetReward(k).format(v)
	end
	return rewards
end

local item
net.Receive('rp.QuestStarted', function()
	local questID = net.ReadUInt(8)
	local quest = rp.Quest.Get(questID)
	
	quests[questID] = true

	if quest:GetOnStart() then
		quest:OnStart(ply)
	end

	if quest:GetTimer() then
		quest_timer[questID] = quest:CalculateCompletionTime(LocalPlayer())
	end

	if quest:GetReadTransmitStart() then
		quest:ReadTransmitStart()
	end

	item = quest:GetItem()
	if item then
		if item:GetOnStart() then
			item:OnStart(ply)
		end

		if item:GetReadTransmitStart() then
			item:ReadTransmitStart(quest_entities)
		end
	end

	rp.Quest.NextThink = 0
end)

net.Receive('rp.QuestEnded', function()
	local questID = net.ReadUInt(8)
	local quest = rp.Quest.Get(questID)
	local status = net.ReadUInt(3)

	if quest:GetOnEnd() then
		quest:OnEnd(ply, status)
	end

	if quest:GetTransmitEnd() && quest:GetReadTransmitEnd() then
		quest:GetReadTransmitEnd(status)
	end

	quests[questID] = nil
	quest_entities[questID] = nil

	if status == QUEST_COMPLETED then

		if quest:GetOnComplete() then
			quest:OnComplete(ply)
		end

		if quest:GetCooldown() then
			quest_cooldown[questID] = net.ReadUInt(32)
		end
	elseif status == QUEST_TASK_COMPLETED then
		if quest:GetOnTaskComplete() then
			quest:OnTaskComplete(ply)
		end
		if !quest:GetAutoComplete() then
			quest_rewards[questID] = true
		end
	elseif status == QUEST_REJECTED then
		if quest:GetRejectCooldown() then
			quest_cooldown[questID] = net.ReadUInt(32)
		end
	elseif status == QUEST_FAILED then
		if quest:GetFailCooldown() then
			quest_cooldown[questID] = net.ReadUInt(32)
		end
	end

	rp.Quest.NextThink = 0
end)

net.Receive('rp.QuestCompleted', function()
	local questID = net.ReadUInt(8)
	local quest = rp.Quest.Get(questID)

	if quest:GetOnComplete() then
		quest:OnComplete(ply)
	end

	if quest:GetCooldown() then
		quest_cooldown[questID] = net.ReadUInt(32)
	end

	rp.Quest.NextThink = 0

	surface.PlaySound(sounds)
end)

net.Receive('rp.RetrieveQuestsCooldown', function()
	local id = 0
	local status = 0
	local cooldown = 0
	for i=1, net.ReadUInt(8) do
		local id = net.ReadUInt(8)
		quest_cooldown[id] = net.ReadUInt(32)
	end

	rp.Quest.NextThink = 0
end)

net.Receive('rp.QuestMenu', function()
	local ent = net.ReadEntity()

	local pos = ent:GetPos():ToScreen()

	if pos.x > ScrW() / 2 then
		pos.x = pos.x - ScrW() / 2
	else
		pos.x = pos.x + ScrW() * .1
	end
	pos.x = math.Clamp(pos.x, ScrW() * .1, ScrW() * .9)
	
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		self:SetTitle(rp.Quest.GetNPC(ent:GetNPCQuestID()).name)
		self:SetPos(pos.x, pos.y)
		self:CenterVertical()
		self:MakePopup()
	end)

	ui.Create('rp_questlist', function(self, p)
		self:SetQuestNPC(ent:GetNPCQuestID())
		self:SetPos(5, 25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)
	end, fr)
end)

function rp.OpenQuestMenu(npc)
	
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.4, ScrH() * 0.6)
		self:SetTitle(rp.Quest.GetNPC(npc).name)
		self:CenterVertical()
		self:CenterHorizontal()
		self:MakePopup()
	end)

	ui.Create('rp_questlist', function(self, p)
		self:SetQuestNPC(npc)
		self:SetPos(5, 25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)
	end, fr)
end