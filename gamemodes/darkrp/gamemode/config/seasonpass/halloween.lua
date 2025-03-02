-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\halloween.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local awards = rp.awards.Types

--[[ Зимний сезон ]]--
local SEASON_HALLOWEEN_2022 = rp.seasonpass.AddSeason("Сезон 8", "ХЭЛЛОУИН 2022", 8)
	:SetStart({year = 2022, day = 1, month = 10, hour = 0, })
	:SetEnd({year = 2022, day = 1, month = 11, hour = 0, })
	:SetMaxLevel(30)
	:SetCosts({
		premium_cost = 159,
		premium_cost_triple = 1199,
		
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
		
		--background_material = Material("rpui/seasonpass/halloween/halloween_bg.png"),
		quests_background_material = Material("rpui/seasonpass/halloween/quests.png", "smooth noclamp"),
		
		level_back_on_material = Material("rpui/seasonpass/halloween/quest_on.png", "smooth noclamp"),
		level_back_off_material = Material("rpui/seasonpass/halloween/quest_off.png", "smooth noclamp"),
		
		tab_back_material = Material("rpui/seasonpass/halloween/level.png", "smooth noclamp"),
		
		head_back_material = Material("rpui/seasonpass/halloween/prem_bg.png", "smooth noclamp"),
		
		buy_button_color = Color(45, 175, 50),
		
		title_font_color = Color(240, 100, 10, 255),
		--color_prem_name_too = true,
		
		season_name_x_offset = 170,
		season_name_size_mult = 1.1,
		
		logo_material = Material("rpui/seasonpass/halloween/pumpkin.png", "smooth noclamp"),
		logo_material_size_multiplier = 0.8,
		logo_offset = { x = -132, y = -92 },
		
		buy_menu_left_color = Color(110, 40, 170),
		buy_menu_left_material = Material("rpui/seasonpass/chinese/oneticket", "smooth noclamp"),
		
		buy_menu_right_color = Color(45, 175, 60),
		buy_menu_right_material = Material("rpui/seasonpass/chinese/threeticket", "smooth noclamp"),
		
		f4menu_button_back_material = Material("rpui/seasonpass/halloween/f4.png", "smooth noclamp"),
		f4menu_button_color = Color(240, 100, 10, 255),
		
		premium_rppass_size_mult = 0.9,
		
		darkmode = 0.2,
		shadows = true,
		
		parallax = {
			{
				x = 0, y = 0,
				sizew  = 1.05,
				sizeh  = 1.05,
				mat    = Material("rpui/seasonpass/halloween/halloween_bg_anim", "smooth", "noclamp"),
				error_mat = Material("rpui/seasonpass/halloween/halloween_bg.png", "smooth noclamp"),
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
		return 1500 + rerolls * 250
	end)


-- 1
SEASON_HALLOWEEN_2022:AddReward({
	level = 1,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'rep_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Чумного Доктора",
    		time = "30d",

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_accessory_1", "smooth", "noclamp"),
			desc = "Маска Чумного Доктора на 30 дней!",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 2,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 3,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 10,
			duration = '1h',

			icon = Material("cases_icons/time_x10", "smooth", "noclamp"),
			desc = "Прирост игрового времени х10 на 1 час",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 4,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 5,
			duration = '2h',

			icon = Material("cases_icons/time_x5", "smooth", "noclamp"),
			desc = "Прирост игрового времени х5 на 2 часа",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'halloween2022_emoji_1',

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_emoji_1", "smooth", "noclamp"),
			desc = "Уникальный Смайл",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 5,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 6,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 7,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 8,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
        },
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 9,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 10,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Каонаси",
    		time = "14d",

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_accessory_3", "smooth", "noclamp"),
			desc = "Маска Каонаси на 14 дней!",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 11,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 12,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 13,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 14,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'halloween2022_emoji_2',

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_emoji_2", "smooth", "noclamp"),
			desc = "Уникальный Смайл",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 15,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 16,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 5,
			duration = '2h',

			icon = Material("cases_icons/time_x5", "smooth", "noclamp"),
			desc = "Прирост игрового времени х5 на 2 часа",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 17,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 18,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x5", "smooth", "noclamp"),
			desc = "Прирост игрового времени х5 на 2 часа",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},		
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 19,
	color_premium = Color(151, 78, 210),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'rep_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 20,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Карателя",
    		time = "14d",

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_accessory_2", "smooth", "noclamp"),
			desc = "Маска Карателя на 14 дней!",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 21,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'halloween2022_emoji_3',

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_emoji_3", "smooth", "noclamp"),
			desc = "Уникальный Смайл",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 22,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 10,
			duration = '1h',

			icon = Material("cases_icons/time_x10", "smooth", "noclamp"),
			desc = "Прирост игрового времени х10 на 1 часа",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 23,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 24,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 25,
	color_premium = Color(151, 78, 210),
	awards = {
        {
			award_type = awards.AWARD_CASE,
			case_uid = 'rep_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'rep_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 26,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIME,
			hours = 5,

			icon = Material("cases_icons/5h", "smooth", "noclamp"),
			desc = "5 Часов игрового времени",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 27,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 10,
			duration = '1h',

			icon = Material("cases_icons/time_x10", "smooth", "noclamp"),
			desc = "Прирост игрового времени х10 на 1 часа",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 28,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'halloween2022_emoji_4',

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_emoji_4", "smooth", "noclamp"),
			desc = "Уникальный Смайл",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 29,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
		},
	},
})

SEASON_HALLOWEEN_2022:AddReward({
	level = 30,
	color_premium = Color(235, 75, 75),
	awards = {
		{
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Зомби",
    		time = "14d",

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_accessory_4", "smooth", "noclamp"),
			desc = "Маска Зомби на 14 дней!",
		},
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Хэллоуинский Рюкзак",

			icon = Material("rpui/seasonpass/halloween/icons/halloween2022_accessory_5", "smooth", "noclamp"),
			desc = "Хэллоуинский Рюкзак!",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})
