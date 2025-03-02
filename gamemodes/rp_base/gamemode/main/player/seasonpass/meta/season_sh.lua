-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\meta\\season_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local _meta_season = rp.seasonpass.Meta._meta_season

function _meta_season:SetStart(date_data)
	self.StartDate = date_data
	return self
end

function _meta_season:SetEnd(date_data)
	self.EndDate = date_data
	return self
end

function _meta_season:SetOverrideCheck(callback)
	self.OverrideCheck = callback
	return self
end

function _meta_season:SetRestrictedQuests(is_restricted_quests)
	self.IsRestrictedQuests = is_restricted_quests
	return self
end

function _meta_season:SetOrderedQuests(is_ordered_quests)
	if is_ordered_quests then
		self:SetRestrictedQuests(true)
	end

	self.IsOrderedQuests = is_ordered_quests
	return self
end

function _meta_season:SetAutoRerollOnDone(is_auto_reroll)
	self.IsAutoReroll = is_auto_reroll
	return self
end

function _meta_season:SetOnLevelsComplete(callback)
	self.OnLevelsComplete = callback
	return self
end

function _meta_season:SetCustomCallbacks(custom_callbacks)
	self.CustomPremCheck = custom_callbacks.pass_check
	self.CustomOnBuyPressed = custom_callbacks.on_buy_pass_pressed
	self.CustomOnBuyLevelsPressed = custom_callbacks.on_buy_levels_pressed

	return self
end

function _meta_season:SetMaxLevel(max_level)
	self.MaxLevel = max_level
	return self
end

function _meta_season:SetPaidLevels(paid_levels)
	self.PaidLevels = paid_levels
	return self
end

function _meta_season:SetCosts(data)
	self.PremiumCost = data.premium_cost
	self.TriplePremiumCost = data.premium_cost_triple
	self.OneLevelCost = data.one_level_cost
	self.UnlockAllCost = data.unlock_all

	return self
end

function _meta_season:SetVisual(data)
	self.NoPremium = data.disable_premium_levels

	self.PremiumTabMat = data.tab_back_material
	self.PremiumTabShowBehind = data.tab_show_material_behind

	self.LevelFontColor = data.level_font_color
	self.LevelOnFontColor = data.level_on_font_color
	self.LevelOffFontColor = data.level_off_font_color

	self.PremiumHeadBack = data.head_back_material
	self.PremiumHeadBackColor = data.buy_button_color

	self.BackBuyPremColorLeft = data.buy_menu_left_color
	self.BackBuyPremImageLeft = data.buy_menu_left_material

	self.PremHeadCustomText = data.head_custom_text
	self.BuyLevelsCustomText = data.buy_levels_custom_text
	self.QuestsCustomText = data.quests_custom_text

	self.BackBuyPremColorRight = data.buy_menu_right_color
	self.BackBuyPremImageRight = data.buy_menu_right_material

	self.F4ButtonMaterial = data.f4menu_button_back_material
	self.F4ButtonColor = data.f4menu_button_color
	self.F4ButtonBackColor = data.f4menu_button_back_color
	self.F4ButtonNoShadowing = data.f4menu_button_no_shadowing

	self.ColorPremNameToo = data.color_prem_name_too

	self.TitleColor = data.title_font_color
	self.BackColor = data.background_color

	self.ParallaxElements = data.parallax

	self.UnlockAllColor = data.unlock_all_button_color

	self.BackMaterial = data.background_material
	self.DarkMode = data.darkmode

	self.RewardBtnMaterialBack = data.reward_button_back_material
	self.RewardBtnMaterialOn = data.reward_button_on_material
	self.RewardBtnMaterialOff = data.reward_button_off_material

	self.LogoMaterial = data.logo_material
	self.LogoMaterialMult = data.logo_material_size_multiplier
	self.LogoOffset = data.logo_offset
	self.LogoNameOffsetX = data.season_name_x_offset
	self.LogoNameMult = data.season_name_size_mult
	self.RPPassNameMult = data.premium_rppass_size_mult
	self.RPPassSeasonNameMult = data.seasonname_pass_size_mult

	self.Shadows = data.shadows

	self.QuestHudMenuOffsetY = data.quest_hud_offset_y

	self.LevelOnMat = data.level_back_on_material
	self.LevelOffMat = data.level_back_off_material

	self.QuestsBackMat = data.quests_background_material

	self.PremHeadMargin = data.prem_head_margin

	return self
end

function _meta_season:SetColor(color)
	self.Color = color
	return self
end

function _meta_season:SetLevelScoreFormula(calc_func)
	self.CalcScoreFunc = calc_func
	return self
end

function _meta_season:SetRerollCostFormula(calc_func)
	self.RerollFormula = calc_func
	return self
end

function _meta_season:AddReward(reward_data)
	local reward_level = reward_data.level
	if not reward_level then return end

	self.UsualRewards = self.UsualRewards or {}
	self.PremiumRewards = self.PremiumRewards or {}

	if self.UsualRewards[reward_level] then return end

	self.UsualRewards[reward_level] = {}
	self.PremiumRewards[reward_level] = {}

	for k, v in pairs(reward_data.awards or {}) do
		if v.is_premium then
			table.insert(self.PremiumRewards[reward_level], v)

		else
			table.insert(self.UsualRewards[reward_level], v)
		end
	end

	self.RewardsData = self.RewardsData or {}
	self.RewardsData[reward_level] = reward_data

	self.HasUsualRewards = #(self.UsualRewards[reward_level]) > 0

	return self
end

function _meta_season:GetRerollCost(ply)
	if not self.RerollFormula then
		return 100
	end

	return self.RerollFormula(ply, ply:SeasonRerollsCount())
end

function _meta_season:GetLevelupScore(ply)
	if not self.CalcScoreFunc then
		return 1000
	end

	return self.CalcScoreFunc(ply, ply:SeasonGetLevel())
end


function rp.seasonpass.AddSeason(season_prename, season_name, season_id)
	if rp.seasonpass.SeasonsMap[season_name] then return end

	local t = {
		ID = season_id or (table.Count(rp.seasonpass.Seasons) + 1),
		pre_name = season_prename,
		name = season_name,
	}

	rp.seasonpass.Seasons[t.ID] = t
	rp.seasonpass.SeasonsMap[season_name] = t

	setmetatable(t, _meta_season)
	return t
end
