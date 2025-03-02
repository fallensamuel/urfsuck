-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\guard_day.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local awards = rp.awards.Types

--[[ День Защитника Отечества ]]--
local SEASON_GUARD_DAY = rp.seasonpass.AddSeason("Сезон 6", "За Родину", 6)
	:SetStart({year = 2022, day = 9, month = 3, hour = 0, })
	:SetEnd({year = 2022, day = 9, month = 5, hour = 0, })
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
		quests_background_material = Material("rpui/seasonpass/guard_day/quests.png", "smooth noclamp"),
		
		level_back_on_material = Material("rpui/seasonpass/guard_day/quest_on.png", "smooth noclamp"),
		level_back_off_material = Material("rpui/seasonpass/guard_day/quest_off.png", "smooth noclamp"),
		
		tab_back_material = Material("rpui/seasonpass/guard_day/level.png", "smooth noclamp"),
		
		head_back_material = Material("rpui/seasonpass/guard_day/prem_bg.png", "smooth noclamp"),
		
		buy_button_color = Color(45, 175, 50),
		
		title_font_color = Color(238, 224, 163, 255),
		--color_prem_name_too = true,
		
		season_name_x_offset = 150,
		season_name_size_mult = 1,
		
		logo_material = Material("rpui/seasonpass/chinese/tyan", "smooth noclamp"),
		logo_material_size_multiplier = 0.8,
		logo_offset = { x = -180, y = -150 },
		
		buy_menu_left_color = Color(110, 40, 170),
		buy_menu_left_material = Material("rpui/seasonpass/chinese/oneticket", "smooth noclamp"),
		
		buy_menu_right_color = Color(45, 175, 60),
		buy_menu_right_material = Material("rpui/seasonpass/chinese/threeticket", "smooth noclamp"),
		
		f4menu_button_back_material = Material("rpui/seasonpass/guard_day/f4.png", "smooth noclamp"),
		f4menu_button_color = Color(238, 224, 163, 255),
		
		premium_rppass_size_mult = 0.9,
		
		darkmode = 0.2,
		shadows = true,
		
		parallax = {
			{
				x = 0, y = 0,
				sizew  = 1.05,
				sizeh  = 1.05,
				mat    = Material("rpui/seasonpass/guard_day/guard_bg.png", "smooth", "noclamp"),
				error_mat = Material("rpui/seasonpass/guard_day/guard_bg.png", "smooth noclamp"),
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
		return 130000 + rerolls * 250
	end)

-- 1
SEASON_GUARD_DAY:AddReward({
	level = 1,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_CASE, 
			case_uid = 'cadet_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Особенный Кейс",
		},
		{ 
			is_premium = true,
			award_type = awards.AWARD_JOB, 
			job = 'agentsbu',
			
			icon = Material("rpui/seasonpass/icons/permajob", "smooth", "noclamp"), 
			desc = "Уникальная Профессия - Спецназ СБУ",
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
SEASON_GUARD_DAY:AddReward({
	level = 2,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_WEAPON, 
			weapon_class = 'swb_grand',
			duration = '30d',
			
			icon = Material("rpui/seasonpass/item/weapon", "smooth", "noclamp"), 
			desc = "M1 Grand на 30 дней",
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

SEASON_GUARD_DAY:AddReward({
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
			award_type = awards.AWARD_CASE, 
			case_uid = 'galactic_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Легендарный Кейс",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 4,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'gd_emoji_1', 
			
			icon = Material("rpui/seasonpass/guard_day/icons/emoji_1", "smooth", "noclamp"), 
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

SEASON_GUARD_DAY:AddReward({
	level = 5,
	color_premium = Color(151, 78, 210),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_MONEY, 
			amount = 130000, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "130000 Игровой Валюты",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 6,
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
			award_type = awards.AWARD_TIMEMULTIPLIER, 
			multiplier = 2,
			duration = '2h',
			
			icon = Material("cases_icons/time_x2", "smooth", "noclamp"), 
			desc = "Прирост игрового времени х2 на 2 часа",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 8,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_WEAPON, 
			weapon_class = 'stalker_rpzul',
			duration = '30d',
			
			icon = Material("rpui/seasonpass/item/weapon", "smooth", "noclamp"), 
			desc = "RP-74 на 30 дней",
		},
		{ 
			is_premium = true,
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 10,
	color_premium = Color(151, 78, 210),
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 15,
	color_premium = Color(151, 78, 210),
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

SEASON_GUARD_DAY:AddReward({
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
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 20,
	color_premium = Color(151, 78, 210),
	awards = {
		{ 
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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
			case_uid = 'rep_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Мистический Кейс",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 25,
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 27,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 28,
	color_premium = Color(151, 78, 210),
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

SEASON_GUARD_DAY:AddReward({
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
			case_uid = 'rep_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Мистический Кейс",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 30,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'gd_emoji_2', 
			
			icon = Material("rpui/seasonpass/guard_day/icons/emoji_2", "smooth", "noclamp"), 
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 34,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 35,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_WEAPON, 
			weapon_class = 'stalker_abatonfra',
			duration = '30d',
			
			icon = Material("rpui/seasonpass/item/weapon", "smooth", "noclamp"), 
			desc = "Абакан на 30 дней",
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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
			case_uid = 'cadet_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Особенный Кейс",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 40,
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 45,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
        },
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 47,
	color_premium = Color(151, 78, 210),
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

SEASON_GUARD_DAY:AddReward({
	level = 48,
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 50,
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
			award_type = awards.AWARD_MODEL, 
			shop_uid = 'model_guard_admin_1',
			
			icon = Material("rpui/seasonpass/guard_day/icons/ww_admin_model_1", "smooth", "noclamp"), 
			desc = "Модель Администратора - Красная Угроза",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 51,
	color_premium = Color(240, 181, 25),
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 55,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_MONEY, 
			amount = 130000, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "130000 Игровой Валюты",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 58,
	color_premium = Color(151, 78, 210),
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

SEASON_GUARD_DAY:AddReward({
	level = 59,
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

SEASON_GUARD_DAY:AddReward({
	level = 60,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'gd_emoji_3', 
			
			icon = Material("rpui/seasonpass/guard_day/icons/emoji_3", "smooth", "noclamp"), 
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

SEASON_GUARD_DAY:AddReward({
	level = 61,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/5h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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
			
			icon = Material("cases_icons/3h", "smooth", "noclamp"), 
			desc = "5 Часов игрового времени",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 68,
	color_premium = Color(76, 204, 89),
	awards = {
		{ 
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/3h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
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

SEASON_GUARD_DAY:AddReward({
	level = 69,
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 75,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_WEAPON, 
			weapon_class = 'swb_priboy',
			duration = '30d',
			
			icon = Material("rpui/seasonpass/item/weapon", "smooth", "noclamp"), 
			desc = "VSS Прибой на 30 дней",
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 81,
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 86,
	color_premium = Color(76, 204, 89),
	awards = {
        {
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/3h", "smooth", "noclamp"), 
			desc = "3 Часов игрового времени",
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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
			case_uid = 'rep_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Мистический Кейс",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
	level = 90,
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

SEASON_GUARD_DAY:AddReward({
	level = 91,
	color_premium = Color(240, 181, 25),
	awards = {
		{ 
			is_premium = true,
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'gd_emoji_4', 
			
			icon = Material("rpui/seasonpass/guard_day/icons/emoji_4", "smooth", "noclamp"), 
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
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
			amount = 130000, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "130000 Игровой Валюты",
		},
	},
})

SEASON_GUARD_DAY:AddReward({
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

SEASON_GUARD_DAY:AddReward({
	level = 98,
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

SEASON_GUARD_DAY:AddReward({
	level = 99,
	color_premium = Color(240, 181, 25),
	awards = {
			{
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'gd_emoji_5', 
			
			icon = Material("rpui/seasonpass/guard_day/icons/emoji_5", "smooth", "noclamp"), 
			desc = "Уникальный Смайл",
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

SEASON_GUARD_DAY:AddReward({
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
			award_type = awards.AWARD_WEAPON, 
			weapon_class = 'swb_aa_12_test',
			duration = '14d',
			
			icon = Material("rpui/seasonpass/item/stalker_weapon_1", "smooth", "noclamp"), 
			desc = "AA-12 на 14 дней",
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