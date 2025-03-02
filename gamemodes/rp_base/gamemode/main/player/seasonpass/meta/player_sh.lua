-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\meta\\player_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local player_quests = rp.seasonpass.PlayerQuests
local player_quests_map = rp.seasonpass.PlayerQuestsMap
local player_quests_ts = rp.seasonpass.PlayerQuestsTimestamps

local function redo_quests(ply)
	local cur_season = ply:GetSeason()

	if not cur_season then return end

	local ply_ts = player_quests_ts[ply:SteamID()]

	local ply_quests = {}
	local ply_quests_map = {}

	local rerolls = (1 + ply:SeasonRerollsCount())

	if cur_season.IsOrderedQuests then
		local cur_quest_page = rerolls - 1 --ply:GetNetVar("SeasonpassOrderedQuests") or 0

		for k, v in pairs(rp.seasonpass.QuestPools) do
			local cur_page = 0

			for i, j in pairs(v) do
				if j.ID and j.ActiveSeasons and j.ActiveSeasons[cur_season.name] then
					if cur_page < cur_quest_page then
						cur_page = cur_page + 1
						continue
					end

					ply_quests[k] = j.ID
					ply_quests_map[ ply_quests[k] ] = k

					break
				end
			end
		end

	else
		math.randomseed(math.ceil(ply:SteamID64() + ply_ts * rerolls * rerolls * 1.5))

		for k, v in pairs(rp.seasonpass.QuestPools) do
			local quest = v[math.random(#v)]
			local quest_type = rp.seasonpass.QuestsTypesMap[quest.Type or '']

			ply_quests[k] = quest

			if cur_season.IsRestrictedQuests then
				while not ply_quests[k].ActiveSeasons or not ply_quests[k].ActiveSeasons[cur_season.name] or not ply_quests[k].ID do
					quest = v[math.random(#v)]
					quest_type = rp.seasonpass.QuestsTypesMap[quest.Type or '']

					if quest_type.AccessValidator and (quest_type.AccessValidator(ply, quest.Data or {}) == false) then
						continue
					end

					ply_quests[k] = quest
				end
			else
				while ply_quests[k].ActiveSeasons and not ply_quests[k].ActiveSeasons[cur_season.name] or not ply_quests[k].ID do
					quest = v[math.random(#v)]
					quest_type = rp.seasonpass.QuestsTypesMap[quest.Type or '']

					if quest_type.AccessValidator and (quest_type.AccessValidator(ply, quest.Data or {}) == false) then
						continue
					end

					ply_quests[k] = quest
				end
			end

			ply_quests[k] = ply_quests[k].ID
			ply_quests_map[ ply_quests[k] ] = k
		end
	end

	if SERVER then
		if player_quests[ply:SteamID()] then
			for k, v in pairs(player_quests[ply:SteamID()]) do
				timer.Simple(0, function()
					rp.seasonpass.Quests[v]:SetupHooks()
				end)
			end
		end
	end

	player_quests[ply:SteamID()] = ply_quests
	player_quests_map[ply:SteamID()] = ply_quests_map

	if SERVER then
		--PrintTable(ply_quests)
		for k, v in pairs(ply_quests) do
			rp.seasonpass.Quests[v]:SetupHooks()
		end
	end

	math.randomseed(os.time())
end

function PLAYER:GetSeason(timestamp)
	if self:GetNetVar("SeasonpassOverride") and rp.seasonpass.Seasons[self:GetNetVar("SeasonpassOverride")] then
		return rp.seasonpass.Seasons[self:GetNetVar("SeasonpassOverride")]
	end

	for k, v in pairs(rp.seasonpass.Seasons) do
		if v.OverrideCheck and v.OverrideCheck(self) then
			local completed_seasons = self:GetNetVar('SeasonpassCompletedSeasons') or {}

			if completed_seasons[v.ID] then
				continue
			end

			if SERVER then
				rp._Stats:Query("REPLACE INTO `seasonpass_completed` VALUES(?, ?, ?);", self:SteamID64(), v.ID, 0)
				self:SetNetVar("SeasonpassOverride", v.ID)
			end

			return v
		end
	end

	return rp.seasonpass.GetSeason(timestamp)
end

function PLAYER:SeasonGetQuests()
	local cur_date = os.date("!*t")
	local need_to_reset_progress = player_quests_ts[self:SteamID()] and player_quests_ts[self:SteamID()] ~= cur_date.day * cur_date.month * cur_date.year

	if not player_quests[self:SteamID()] or not player_quests_ts[self:SteamID()] or need_to_reset_progress then
		if need_to_reset_progress and SERVER then
			self:SetNetVar('SeasonpassQuests', {})
		end

		player_quests_ts[self:SteamID()] = cur_date.day * cur_date.month * cur_date.year
		redo_quests(self)
	end

	return player_quests[self:SteamID()]
end

function PLAYER:SeasonGetQuestsMap()
	local cur_date = os.date("!*t")
	local need_to_reset_progress = player_quests_ts[self:SteamID()] and player_quests_ts[self:SteamID()] ~= cur_date.day * cur_date.month * cur_date.year

	if not player_quests_map[self:SteamID()] or not player_quests_ts[self:SteamID()] or need_to_reset_progress then
		if need_to_reset_progress and SERVER then
			self:SetNetVar('SeasonpassQuests', {})
		end

		player_quests_ts[self:SteamID()] = cur_date.day * cur_date.month * cur_date.year
		redo_quests(self)
	end

	return player_quests_map[self:SteamID()]
end

function PLAYER:SeasonHasQuest(quest_name)
	local quests_map = self:SeasonGetQuestsMap()

	if not quests_map then
		return false
	end

	if isstring(quest_name) then
		quest_name = rp.seasonpass.QuestsMap[quest_name] and rp.seasonpass.QuestsMap[quest_name].ID
	end

	if not quest_name then
		return false
	end

	return self:SeasonGetQuestsMap()[quest_name] and true or false
end

function PLAYER:SeasonQuestProgress(quest_name)
	if isstring(quest_name) then
		quest_name = rp.seasonpass.QuestsMap[quest_name] and rp.seasonpass.QuestsMap[quest_name].ID
	end

	if not quest_name or not self:SeasonGetQuestsMap()[quest_name] then
		return 0
	end

	local progresses = self:GetNetVar('SeasonpassQuests') or {}
	return progresses[ self:SeasonGetQuestsMap()[quest_name] ] or 0
end

function PLAYER:SeasonCompletedQuest(quest_name)
	if isstring(quest_name) then
		quest_name = rp.seasonpass.QuestsMap[quest_name] and rp.seasonpass.QuestsMap[quest_name].ID
	end

	if not quest_name or not self:SeasonGetQuestsMap()[quest_name] then
		return false
	end

	local progress = self:GetNetVar('SeasonpassQuests') or {}
	progress = progress[ self:SeasonGetQuestsMap()[quest_name] ] or 0

	return progress >= (rp.seasonpass.Quests[quest_name].MaxProgress or 1)
end

function PLAYER:SeasonGetLevel()
	return self:GetNetVar('SeasonpassLevel') or 1
end

function PLAYER:SeasonGetProgress()
	return self:GetNetVar('SeasonpassProgress') or 0
end

function PLAYER:SeasonIsDonated()
	local season = self:GetSeason()

	if season and season.CustomPremCheck then
		return season.CustomPremCheck and season.CustomPremCheck(self) and true or false
	end

	return self:GetNetVar('SeasonpassDonated') and true or false
end

function PLAYER:SeasonRerollsCount()
	return self:GetNetVar('SeasonpassRerolls') or 0
end

function PLAYER:SeasonGetRewards()
	return self:GetNetVar('SeasonpassRewards') or { {}, {} }
end
