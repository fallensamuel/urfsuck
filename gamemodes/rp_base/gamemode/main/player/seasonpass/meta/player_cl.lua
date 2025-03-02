-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\meta\\player_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.seasonpass.QuestUpdateProgress = rp.seasonpass.QuestUpdateProgress or {}
rp.seasonpass.QuestUpdateStamps = rp.seasonpass.QuestUpdateStamps or {}

function PLAYER:SeasonQuestFakedProgress(quest_id)
	local progresses = self:GetNetVar('SeasonpassQuests') or {}
	
	local quest = rp.seasonpass.Quests[ self:SeasonGetQuests()[quest_id] ]
	local quest_type = rp.seasonpass.QuestsTypesMap[quest.Type or '']
	
	if not quest_type then 
		error("SEASONPASS ERROR! Invalid quest TYPE '" .. (quest.Type or '') .. "'")
	end
	
	if quest_type.FakeProgress then
		return quest_type.FakeProgress(quest.Data, self, progresses[quest_id] or 0, quest.MaxProgress or 1, rp.seasonpass.QuestUpdateStamps[quest_id] or CurTime())
	end
	
	return progresses[quest_id] or 0
end
