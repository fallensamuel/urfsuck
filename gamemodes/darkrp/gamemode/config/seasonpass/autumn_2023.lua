-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\autumn_2023.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local awards = rp.awards.Types

--[[ Весенний Сезон ]]--
local SEASON_AUTUMN_2023 = rp.seasonpass.AddSeason("Сезон 12", "ОСЕНЬ'23", 12)
	:SetStart({year = 2023, day = 27, month = 08, hour = 0, })
	:SetEnd({year = 2023, day = 30, month = 11, hour = 0, })
	:SetMaxLevel(30)
	:SetCosts({
		premium_cost = 300,
		premium_cost_triple = 900,
		
		one_level_cost = 35,
		unlock_all = 1199,
	})
	:SetPaidLevels({
		{ levels = 5, color = Color(76, 204, 89) },
		{ levels = 15, color = Color(151, 78, 210) },
		{ levels = 20, color = Color(240, 181, 25) },
		{ levels = 30, color = Color(235, 75, 75) },
	})
	:SetVisual({
		unlock_all_button_color = Color(235, 75, 75),
		
		quests_background_material = Material("rpui/seasonpass/autumn2023/quests.png", "smooth noclamp"),
		
		level_back_on_material = Material("rpui/seasonpass/autumn2023/quest_on.png", "smooth noclamp"),
		level_back_off_material = Material("rpui/seasonpass/autumn2023/quest_off.png", "smooth noclamp"),
		
		tab_back_material = Material("rpui/seasonpass/autumn2023/level.png", "smooth noclamp"),
		
		head_back_material = Material("rpui/seasonpass/autumn2023/prem_bg.png", "smooth noclamp"),
		
		buy_button_color = Color(45, 175, 50),
		
		title_font_color = Color(255, 255, 255, 255),
		--color_prem_name_too = true,
		
		season_name_x_offset = 270,
		season_name_size_mult = 1.15,
		
		logo_material = Material("rpui/seasonpass/autumn2023/ground_pic.png", "smooth noclamp"),
		logo_material_size_multiplier = 0.8,
		logo_offset = { x = -115, y = -162 },
		
		buy_menu_left_color = Color(110, 40, 170),
		buy_menu_left_material = Material("rpui/seasonpass/chinese/oneticket", "smooth noclamp"),
		
		buy_menu_right_color = Color(45, 175, 60),
		buy_menu_right_material = Material("rpui/seasonpass/chinese/threeticket", "smooth noclamp"),
		
		f4menu_button_back_material = Material("rpui/seasonpass/autumn2023/f4.png", "smooth noclamp"),
		f4menu_button_color = Color(255, 255, 255, 255),
		
		premium_rppass_size_mult = 0.9,
		
		darkmode = 0.2,
		shadows = true,
		
		parallax = {
			{
				x = 0, y = 0,
				sizew  = 1.05,
				sizeh  = 1.05,
				mat    = Material("rpui/seasonpass/autumn2023/background.png", "smooth", "noclamp"),
				error_mat = Material("rpui/seasonpass/autumn2023/background.png", "smooth noclamp"),
				range  = 0.04,
				speed  = 1,
			},
		},
	})
	--:SetColor(Color(132, 138, 148))
	:SetColor(Color(255, 255, 255))
	:SetLevelScoreFormula(function(ply, level)
		return 1000 + level * 0
	end)
	:SetRerollCostFormula(function(ply, rerolls)
		return 7000 + rerolls * 2
	end)



-- 1
SEASON_AUTUMN_2023:AddReward({
	level = 1,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_JOB, 
			job = 'prembast',
			time = "30d",
			
			icon = Material("icons/rewards/prembast", "smooth", "noclamp"), 
			desc = "Уникальная Профессия - Бастион на 30 дней",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})

-- 2
SEASON_AUTUMN_2023:AddReward({
	level = 2,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_low_case',

			icon = Material("icons/cases/uptime_low", "smooth", "noclamp"),
			desc = "Кейс Умножения",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_high_case',

			icon = Material("icons/cases/money_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Фортуны",
		},
	},
})

-- 3
SEASON_AUTUMN_2023:AddReward({
	level = 3,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_mid_case',

			icon = Material("icons/cases/time_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_wapons_case',

			icon = Material("icons/cases/guns", "smooth", "noclamp"),
			desc = "Оружейный Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})

-- 4
SEASON_AUTUMN_2023:AddReward({
	level = 4,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_high_case',

			icon = Material("icons/cases/money_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Фортуны",
		},
	},
})

-- 5
SEASON_AUTUMN_2023:AddReward({
	level = 5,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_mid_case',

			icon = Material("icons/cases/uptime_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Умножения",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_taunts_case',

			icon = Material("icons/cases/taunts", "smooth", "noclamp"),
			desc = "Кейс Эмоций",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})

-- 6
SEASON_AUTUMN_2023:AddReward({
	level = 6,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_low_case',

			icon = Material("icons/cases/time_low", "smooth", "noclamp"),
			desc = "Кейс Времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})

-- 7
SEASON_AUTUMN_2023:AddReward({
	level = 7,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_mid_case',

			icon = Material("icons/cases/money_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_mid_case',

			icon = Material("icons/cases/time_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Времени",
		},
	},
})

-- 8
SEASON_AUTUMN_2023:AddReward({
	level = 8,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_low_case',

			icon = Material("icons/cases/uptime_low", "smooth", "noclamp"),
			desc = "Кейс Умножения",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
	},
})

-- 9
SEASON_AUTUMN_2023:AddReward({
	level = 9,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_wapons_case',

			icon = Material("icons/cases/guns", "smooth", "noclamp"),
			desc = "Оружейный Кейс",
		},
	},
})

-- 10
SEASON_AUTUMN_2023:AddReward({
	level = 10,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})


-- 11
SEASON_AUTUMN_2023:AddReward({
	level = 11,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_low_case',

			icon = Material("icons/cases/time_low", "smooth", "noclamp"),
			desc = "Кейс Времени",
		},
	},
})

-- 12
SEASON_AUTUMN_2023:AddReward({
	level = 12,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_low_case',

			icon = Material("icons/cases/money_low", "smooth", "noclamp"),
			desc = "Кейс Фортуны",
		},
	},
})

-- 13
SEASON_AUTUMN_2023:AddReward({
	level = 13,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_mid_case',

			icon = Material("icons/cases/uptime_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Умножения",
		},
	},
})

-- 14
SEASON_AUTUMN_2023:AddReward({
	level = 14,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_mid_case',

			icon = Material("icons/cases/time_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Времени",
		},
	},
})

-- 15
SEASON_AUTUMN_2023:AddReward({
	level = 15,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_low_case',

			icon = Material("icons/cases/uptime_low", "smooth", "noclamp"),
			desc = "Кейс Умножения",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_wapons_case',

			icon = Material("icons/cases/guns", "smooth", "noclamp"),
			desc = "Оружейный Кейс",
		},
	},
})

-- 16
SEASON_AUTUMN_2023:AddReward({
	level = 16,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_taunts_case',

			icon = Material("icons/cases/taunts", "smooth", "noclamp"),
			desc = "Кейс Эмоций",
		},
	},
})

-- 17
SEASON_AUTUMN_2023:AddReward({
	level = 17,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
	},
})

-- 18
SEASON_AUTUMN_2023:AddReward({
	level = 18,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_mid_case',

			icon = Material("icons/cases/money_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Фортуны",
		},
	},
})

-- 19
SEASON_AUTUMN_2023:AddReward({
	level = 19,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_low_case',

			icon = Material("icons/cases/time_low", "smooth", "noclamp"),
			desc = "Кейс Времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_mid_case',

			icon = Material("icons/cases/uptime_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Умножения",
		},
	},
})

-- 20
SEASON_AUTUMN_2023:AddReward({
	level = 20,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_high_case',

			icon = Material("icons/cases/uptime_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Умножения",
		},
	},
})

-- 21
SEASON_AUTUMN_2023:AddReward({
	level = 21,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_mid_case',

			icon = Material("icons/cases/money_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Фортуны",
		},
	},
})

-- 22
SEASON_AUTUMN_2023:AddReward({
	level = 22,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_mid_case',

			icon = Material("icons/cases/money_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_wapons_case',

			icon = Material("icons/cases/guns", "smooth", "noclamp"),
			desc = "Оружейный Кейс",
		},
	},
})

-- 23
SEASON_AUTUMN_2023:AddReward({
	level = 23,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_high_case',

			icon = Material("icons/cases/uptime_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Умножения",
		},
	},
})

-- 24
SEASON_AUTUMN_2023:AddReward({
	level = 24,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_high_case',

			icon = Material("icons/cases/time_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Времени",
		},
	},
})

-- 25
SEASON_AUTUMN_2023:AddReward({
	level = 25,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_high_case',

			icon = Material("icons/cases/money_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Фортуны",
		},
	},
})

-- 26
SEASON_AUTUMN_2023:AddReward({
	level = 26,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_time_mid_case',

			icon = Material("icons/cases/time_mid", "smooth", "noclamp"),
			desc = "Кейс Мега-Времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_uptime_high_case',

			icon = Material("icons/cases/uptime_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Умножения",
		},
	},
})

-- 27
SEASON_AUTUMN_2023:AddReward({
	level = 27,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
	},
})

-- 28
SEASON_AUTUMN_2023:AddReward({
	level = 28,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_taunts_case',

			icon = Material("icons/cases/taunts", "smooth", "noclamp"),
			desc = "Кейс Эмоций",
		},
	},
})

-- 29
SEASON_AUTUMN_2023:AddReward({
	level = 29,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_money_high_case',

			icon = Material("icons/cases/money_high", "smooth", "noclamp"),
			desc = "Кейс Ультра-Фортуны",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
	},
})


-- 30
SEASON_AUTUMN_2023:AddReward({
	level = 30,
	color_premium = Color(235, 75, 75),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_emoji_case',

			icon = Material("icons/cases/emoji", "smooth", "noclamp"),
			desc = "Кейс Эмодзи",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_JOB, 
			job = 'premhulban',
			time = "30d",
			
			icon = Material("icons/rewards/premhulban", "smooth", "noclamp"), 
			desc = "Уникальная Профессия - Жульбан на 30 дней",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'bp_wapons_case',

			icon = Material("icons/cases/guns", "smooth", "noclamp"),
			desc = "Оружейный Кейс",
		},
	},
})


