-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\winter_2022_23.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local awards = rp.awards.Types

--[[ Лето-2022 ]]--
local SEASON_WINTER_2022_23 = rp.seasonpass.AddSeason("Сезон 9", "ЗИМА 2022/23", 9)
	:SetStart({ day = 1, month = 12, hour = 0, })
	:SetEnd({ day = 1, month = 3, hour = 0, })
	:SetMaxLevel(100)
	:SetCosts({
		premium_cost = 599,
		premium_cost_triple = 1799,

		one_level_cost = 38,
		unlock_all = 3799,
	})
	:SetPaidLevels({
		{ levels = 5, color = Color(76, 204, 89) },
		{ levels = 15, color = Color(151, 78, 210) },
		{ levels = 25, color = Color(240, 181, 25) },
		{ levels = 50, color = Color(235, 75, 75) },
	})
	:SetVisual({
		unlock_all_button_color = Color(235, 75, 75),

		--background_material = Material("rpui/seasonpass/guard_day/guard_day_bg.png"),
		quests_background_material = Material("rpui/seasonpass/winter2022/quests.png", "smooth noclamp"),

		level_back_on_material = Material("rpui/seasonpass/winter2022/quest_on.png", "smooth noclamp"),
		level_back_off_material = Material("rpui/seasonpass/winter2022/quest_off.png", "smooth noclamp"),

		tab_back_material = Material("rpui/seasonpass/winter2022/level.png", "smooth noclamp"),

		head_back_material = Material("rpui/seasonpass/winter2022/prem_bg.png", "smooth noclamp"),
		prem_head_margin = 0.075;

		buy_button_color = Color(45, 175, 50),

		title_font_color = Color(240, 245, 255, 255),
		--color_prem_name_too = true,

		season_name_x_offset = 150,
		season_name_size_mult = 1.1,

		logo_material = Material("rpui/seasonpass/winter2022/poro.png", "smooth noclamp"),
		logo_material_size_multiplier = 0.8,
		logo_offset = { x = -132, y = -92 },

		buy_menu_left_color = Color(110, 40, 170),
		buy_menu_left_material = Material("rpui/seasonpass/chinese/oneticket", "smooth noclamp"),

		buy_menu_right_color = Color(45, 175, 60),
		buy_menu_right_material = Material("rpui/seasonpass/chinese/threeticket", "smooth noclamp"),

		f4menu_button_back_material = Material("rpui/seasonpass/winter2022/f4.png", "smooth noclamp"),
		f4menu_button_color = Color(240, 245, 255, 255),

		premium_rppass_size_mult = 0.9,

		darkmode = 0.2,
		shadows = true,

		parallax = {
			{
				x = 0, y = 0,
				sizew  = 1.05,
				sizeh  = 1.05,
				mat    = Material("rpui/seasonpass/winter2022/winter_bg_anim", "smooth", "noclamp"),
				error_mat = Material("rpui/seasonpass/winter2022/winter_bg.png", "smooth noclamp"),
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
		return 250000 + rerolls * 250
	end)

-- 1
SEASON_WINTER_2022_23:AddReward({
	level = 1,
	color_premium = Color(240, 181, 25),
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
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
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

-- 2
SEASON_WINTER_2022_23:AddReward({
	level = 2,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Шляпа Оленя - Новогодняя",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/hat_1", "smooth", "noclamp"),
			desc = "Шляпа Новогодняя на 60 дней!",
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

SEASON_WINTER_2022_23:AddReward({
	level = 3,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
		},
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Тихони",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/mask_1", "smooth", "noclamp"),
			desc = "Маска Тихони на 60 дней!",
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

SEASON_WINTER_2022_23:AddReward({
	level = 4,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'winter_22_23_emoji_1',

			icon = Material("rpui/seasonpass/icons/emoji", "smooth", "noclamp"),
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

SEASON_WINTER_2022_23:AddReward({
	level = 5,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
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

SEASON_WINTER_2022_23:AddReward({
	level = 6,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'rep_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
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

SEASON_WINTER_2022_23:AddReward({
	level = 8,
	color_premium = Color(240, 181, 25),
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

SEASON_WINTER_2022_23:AddReward({
	level = 9,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 10,
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

SEASON_WINTER_2022_23:AddReward({
	level = 11,
	color_premium = Color(76, 204, 89),
	awards = {
		{
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
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

SEASON_WINTER_2022_23:AddReward({
	level = 12,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 13,
	color_premium = Color(76, 204, 89),
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
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 14,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 15,
	color_premium = Color(240, 181, 25),
	awards = {
		{
        	is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Шляпа Оленя - Спортивная",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/hat_2", "smooth", "noclamp"),
			desc = "Шляпа Спортивная на 60 дней",
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

SEASON_WINTER_2022_23:AddReward({
	level = 16,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
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

SEASON_WINTER_2022_23:AddReward({
	level = 17,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 18,
	color_premium = Color(76, 204, 89),
	awards = {
		{
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 19,
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

SEASON_WINTER_2022_23:AddReward({
	level = 20,
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
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 21,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 22,
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
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 23,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 24,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '3h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 25,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
        },
        {
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Задиры",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/mask_2", "smooth", "noclamp"),
			desc = "Маска Задиры на 60 дней!",
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

SEASON_WINTER_2022_23:AddReward({
	level = 26,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 27,
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

SEASON_WINTER_2022_23:AddReward({
	level = 28,
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

SEASON_WINTER_2022_23:AddReward({
	level = 29,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 30,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'winter_22_23_emoji_2',

			icon = Material("rpui/seasonpass/icons/emoji", "smooth", "noclamp"),
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

SEASON_WINTER_2022_23:AddReward({
	level = 31,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 32,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
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

SEASON_WINTER_2022_23:AddReward({
	level = 33,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 34,
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

SEASON_WINTER_2022_23:AddReward({
	level = 35,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 36,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
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

SEASON_WINTER_2022_23:AddReward({
	level = 37,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 38,
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

SEASON_WINTER_2022_23:AddReward({
	level = 39,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
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

SEASON_WINTER_2022_23:AddReward({
	level = 40,
	color_premium = Color(240, 181, 25),
	awards = {
		{
        	is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Шляпа Оленя - Элитная",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/hat_3", "smooth", "noclamp"),
			desc = "Шляпа Оленя - Элитная на 60 дней!",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 41,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 42,
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

SEASON_WINTER_2022_23:AddReward({
	level = 43,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 44,
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

SEASON_WINTER_2022_23:AddReward({
	level = 45,
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

SEASON_WINTER_2022_23:AddReward({
	level = 46,
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
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 47,
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

SEASON_WINTER_2022_23:AddReward({
	level = 48,
	color_premium = Color(151, 78, 210),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 49,
	color_premium = Color(76, 204, 89),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 50,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 51,
	color_premium = Color(76, 204, 89),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 52,
	color_premium = Color(76, 204, 89),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 53,
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

SEASON_WINTER_2022_23:AddReward({
	level = 54,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
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

SEASON_WINTER_2022_23:AddReward({
	level = 55,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_MODEL, 
			shop_uid = 'winter_22_23_adminmodel',
			
			icon = Material("rpui/seasonpass/winter2022/icons/admin_model", "smooth", "noclamp"), 
			desc = "Уникальная Модель Администратора",
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

SEASON_WINTER_2022_23:AddReward({
	level = 56,
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

SEASON_WINTER_2022_23:AddReward({
	level = 57,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
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

SEASON_WINTER_2022_23:AddReward({
	level = 58,
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

SEASON_WINTER_2022_23:AddReward({
	level = 59,
	color_premium = Color(151, 78, 210),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 60,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'winter_22_23_emoji_3',

			icon = Material("rpui/seasonpass/icons/emoji", "smooth", "noclamp"),
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

SEASON_WINTER_2022_23:AddReward({
	level = 61,
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
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 62,
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

SEASON_WINTER_2022_23:AddReward({
	level = 63,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 64,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
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

SEASON_WINTER_2022_23:AddReward({
	level = 65,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 66,
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

SEASON_WINTER_2022_23:AddReward({
	level = 67,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 68,
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
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 69,
	color_premium = Color(151, 78, 210),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 70,
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

SEASON_WINTER_2022_23:AddReward({
	level = 71,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
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

SEASON_WINTER_2022_23:AddReward({
	level = 72,
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

SEASON_WINTER_2022_23:AddReward({
	level = 73,
	color_premium = Color(76, 204, 89),
	awards = {
        {
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 74,
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

SEASON_WINTER_2022_23:AddReward({
	level = 75,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Ушаночка",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/hat_4", "smooth", "noclamp"),
			desc = "Ушаночка на 60 дней",
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

SEASON_WINTER_2022_23:AddReward({
	level = 76,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 77,
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

SEASON_WINTER_2022_23:AddReward({
	level = 78,
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

SEASON_WINTER_2022_23:AddReward({
	level = 79,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 80,
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

SEASON_WINTER_2022_23:AddReward({
	level = 81,
	color_premium = Color(151, 78, 210),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 82,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
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

SEASON_WINTER_2022_23:AddReward({
	level = 83,
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

SEASON_WINTER_2022_23:AddReward({
	level = 84,
	color_premium = Color(76, 204, 89),
	awards = {
        {
			is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 85,
	color_premium = Color(76, 204, 89),
	awards = {
        {
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 86,
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
            award_type = awards.AWARD_SALARY,
            multiplier = 1.25,
            duration = '2h',

            icon = Material("rpui/seasonpass/icons/salary", "smooth", "noclamp"),

            desc = "Увеличение зарплаты на 25% на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 87,
	color_premium = Color(76, 204, 89),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 88,
	color_premium = Color(76, 204, 89),
	awards = {
        {
        	is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 89,
	color_premium = Color(151, 78, 210),
	awards = {
        {
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 3,
			duration = '2h',

			icon = Material("cases_icons/time_x3", "smooth", "noclamp"),
			desc = "Прирост игрового времени х3 на 2 часа",
		},
		{
        	is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'reb_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Мистический Кейс",
		},
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 90,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
    		award_type = awards.AWARD_HAT,
    		hat_name = "Маска Капитана",
    		time = "60d",

			icon = Material("rpui/seasonpass/winter2022/icons/mask_3", "smooth", "noclamp"),
			desc = "Маска Капитана на 60 дней!",
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

SEASON_WINTER_2022_23:AddReward({
	level = 91,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'winter_22_23_emoji_4',

			icon = Material("rpui/seasonpass/icons/emoji", "smooth", "noclamp"),
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

SEASON_WINTER_2022_23:AddReward({
	level = 92,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			is_premium = true,
			award_type = awards.AWARD_TIMEMULTIPLIER,
			multiplier = 2,
			duration = '2h',

			icon = Material("cases_icons/time_x2", "smooth", "noclamp"),
			desc = "Прирост игрового времени х2 на 2 часа",
        },
	},
})

SEASON_WINTER_2022_23:AddReward({
	level = 93,
	color_premium = Color(76, 204, 89),
	awards = {
		{
			award_type = awards.AWARD_MONEY,
			amount = 65000,

			icon = Material("cases_icons/money", "smooth", "noclamp"),
			desc = "65000 Игровой Валюты",
		},
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

SEASON_WINTER_2022_23:AddReward({
	level = 94,
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

SEASON_WINTER_2022_23:AddReward({
	level = 95,
	color_premium = Color(151, 78, 210),
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

SEASON_WINTER_2022_23:AddReward({
	level = 96,
	color_premium = Color(151, 78, 210),
	awards = {
		{
			award_type = awards.AWARD_CASE,
			case_uid = 'cadet_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Особенный Кейс",
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

SEASON_WINTER_2022_23:AddReward({
	level = 97,
	color_premium = Color(151, 78, 210),
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

SEASON_WINTER_2022_23:AddReward({
	level = 98,
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

SEASON_WINTER_2022_23:AddReward({
	level = 99,
	color_premium = Color(240, 181, 25),
	awards = {
		{
			award_type = awards.AWARD_EMOJI,
			shop_uid = 'winter_22_23_emoji_5',

			icon = Material("rpui/seasonpass/icons/emoji", "smooth", "noclamp"),
			desc = "Уникальный Смайл",
        },
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
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

SEASON_WINTER_2022_23:AddReward({
	level = 100,
	color_premium = Color(235, 75, 75),
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
		{
			is_premium = true,
			award_type = awards.AWARD_CASE,
			case_uid = 'galactic_case',

			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"),
			desc = "Легендарный Кейс",
		},
	},
})