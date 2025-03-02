-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\meta\\quest_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_quest = rp.seasonpass.Meta._meta_quest

function _meta_quest:SetSeasons(seasons)
	self.ActiveSeasons = seasons
	return self
end

function _meta_quest:SetDifficulty(diff_id)
	rp.seasonpass.QuestPools[diff_id] = rp.seasonpass.QuestPools[diff_id] or {}
	
	self.DiffID = table.insert(rp.seasonpass.QuestPools[diff_id], self)
	
	self.Difficulty = diff_id
	return self
end

function _meta_quest:SetLevelScores(scores)
	self.Scores = scores
	return self
end

function _meta_quest:SetCompleteProgress(amount)
	self.MaxProgress = amount
	return self
end

function _meta_quest:SetType(quest_type, quest_data)
	self.Type = quest_type
	self.Data = quest_data
	
	local quest_type = rp.seasonpass.QuestsTypesMap[self.Type or '']
	
	if not quest_type then 
		error("SEASONPASS ERROR! Invalid quest TYPE '" .. (self.Type or '') .. "'")
	end
	
	if quest_type.Validator then
		if not quest_type.Validator(quest_data) then
			error("SEASONPASS ERROR! Invalid quest DATA for quest '" .. (self.Name) .. "' (" .. self.UID .. ")")
		end
	end
	
	if SERVER and quest_type.OnInitCallback then
		quest_type.OnInitCallback(quest_data)
	end
	
	return self
end

function rp.seasonpass.AddQuest(quest_uid, quest_name)
	if rp.seasonpass.QuestsMap[quest_uid] then return setmetatable({}, _meta_quest) end
	
	local t = {
		UID = quest_uid,
		Name = quest_name,
	}
	
	t.ID = table.insert(rp.seasonpass.Quests, t)
	rp.seasonpass.QuestsMap[quest_uid] = t
	
	setmetatable(t, _meta_quest)
	return t
end
