-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\noobie.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local awards = rp.awards.Types

--[[ Бп для новичков ]]--
local SEASON_NOOBIE = rp.seasonpass.AddSeason("Обучение", "Знакомство с URF.IM", 0)
	:SetMaxLevel(10)
	:SetOverrideCheck(function(ply)
		return (ply.lastjoin and (ply.lastjoin + 3600 * 24 * 14 < os.time())) or (ply.firstjoin and (ply.firstjoin + 3600 * 24 > os.time()))
	end)
	:SetCustomCallbacks({
		pass_check = function(ply)
			return true --ply:HasPremium()
		end,
		on_buy_pass_pressed = function(pass_menu)
			--pass_menu:Close()
			--rp.RunCommand("upgrades")
		end,
		on_buy_levels_pressed = function(pass_menu)
			--pass_menu:Close()
			--rp.RunCommand("upgrades")
		end,
	})
	--:SetCosts({
		--premium_cost = 199,
	--})
	:SetOrderedQuests(true)
	:SetAutoRerollOnDone(true)
	:SetVisual({
		disable_premium_levels = Material("rpui/seasonpass/chinese/test.png", "smooth noclamp"),
		
		--f4menu_button_color = Color(113, 128, 68, 255),
		
		title_font_color = Color(255, 120, 0, 255),
		background_color = Color(0, 0, 0, 255),
		
		f4menu_button_back_material = Material("rpui/seasonpass/chinese/test_f4.png", "smooth noclamp"),
		f4menu_button_color = Color(0, 200, 127, 255),
		
		buy_button_color = Color(45, 175, 50),
		head_back_material = Material("rpui/seasonpass/chinese/prem_head_bg", "smooth noclamp"),
		
		quests_custom_text = "Задания",
		
		head_custom_text = { "ПРЕМИУМ", "RP ПРОПУСК" },
		buy_levels_custom_text = "Преобрети URF PREMIUM чтобы получить двойную награду!",
		
		premium_rppass_size_mult = 1.1,
		
		logo_material = Material("rpui/seasonpass/chinese/cloneguy.png", "smooth noclamp"),
		logo_material_size_multiplier = 0.73,
		logo_offset = { x = -186, y = -80 },
		season_name_x_offset = 130,
		season_name_size_mult = 0.6,
		
		parallax = {
			{
				x = 0, y = 0,
				sizew  = 1.05,
				sizeh  = 1.05,
				mat    = Material("rpui/seasonpass/chinese/test_back.png", "smooth noclamp"),
				range  = 0.04,
				speed  = 1,
			},
			/*{
				x      = 0,
				y      = 0,
				color  = Color(75, 85, 45, 255),
				mat    = Material("rpui/donatemenu/sparkles"),
				range  = -0.5,
				speed  = 1,
			},
			{
				x      = 0,
				y      = 0,
				color  = Color(75, 85, 45, 255),
				mat    = Material("rpui/donatemenu/flash_bottom"),
				range  = 0,
				speed  = 0,
			},
			{
				x      = 0,
				y      = 0,
				color  = Color(75, 85, 45, 255),
				mat    = Material("rpui/donatemenu/flash_middle"),
				range  = 0,
				speed  = 0,
			},
			{
				x      = 0,
				y      = 0,
				color  = Color(75, 85, 45, 255),
				mat    = Material("rpui/donatemenu/flash_top"),
				range  = 0,
				speed  = 0,
			},
			{
				x      = 0,
				y      = 0,
				sizew  = 1,
				sizeh  = 1,
				color  = Color(75, 85, 45, 255),
				mat    = Material("rpui/donatemenu/shards"),
				range  = 0.5,
				speed  = 1,
			},*/
		},
	})
	:SetColor(Color(255, 255, 255)) -- Color(113, 128, 68)
	:SetLevelScoreFormula(function(ply, level)
		return 1500 + level * 0
	end)


--[[ КВЕСТЫ ]]--
rp.seasonpass.AddQuest("noobie_quest_1", "Открыть F4 меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('f4menu_open')

rp.seasonpass.AddQuest("noobie_quest_2", "Получи награду из Боевого Пропуска")
    :SetSeasons({ ["Знакомство с URF.IM"] = true, })
    :SetDifficulty(2)
    :SetLevelScores(500)
    :SetType('sp_reward')

rp.seasonpass.AddQuest("noobie_quest_3", "Открой полученный кейс, перейдя в меню Донат - Кейсы")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('case_spawned', {
		lootbox_uid = 'cadet_case'
	})

rp.seasonpass.AddQuest("noobie_quest_4", "Открой Радиальное Меню, удерживая клавишу 'E' на любом игроке")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('radial_open')	

rp.seasonpass.AddQuest("noobie_quest_5", "Покажи Документы Через Радиальное Меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('circle_show_idcard')

rp.seasonpass.AddQuest("noobie_quest_6", "Передай Игровую Валюту Через Радиальное Меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('transfer_money')

rp.seasonpass.AddQuest("noobie_quest_7", "Открой C-меню, удерживая клавишу 'C'")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('c_menu_open')

rp.seasonpass.AddQuest("noobie_quest_8", "Станцуй, используя Эмоции в С-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('dance')

rp.seasonpass.AddQuest("noobie_quest_9", "Смени настроение, используя Настроения в С-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('set_mood')

rp.seasonpass.AddQuest("noobie_quest_10", "Выбери профессию в F4-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('menu_select_job_any')	

rp.seasonpass.AddQuest("noobie_quest_11", "Смени свою профессию")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('team_taken_any')

rp.seasonpass.AddQuest("noobie_quest_12", function() return "Открой чат на [" .. utf8.upper(input.LookupBinding("messagemode") or "t") .. "] и отправь любой Смайл" end)
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('chat_emoji')

rp.seasonpass.AddQuest("noobie_quest_13", "Открой Q-меню, удерживая клавишу 'Q'")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('q_menu_open')

rp.seasonpass.AddQuest("noobie_quest_14", "Купи боеприпасы в Q-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('q_buy_ammo')

rp.seasonpass.AddQuest("noobie_quest_15", "Приобрети любое Энтити в Q-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('q_spawn_entity')

rp.seasonpass.AddQuest("noobie_quest_16", "Открой любой Ящик с Лутом, исследуя локации")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('open_loot')

rp.seasonpass.AddQuest("noobie_quest_17", "Найди 5 любых предметов в Ящиках с Лутом")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetCompleteProgress(5)
	:SetLevelScores(500)
	:SetType('take_loot')

rp.seasonpass.AddQuest("noobie_quest_18", "Скрафти любой предмет, используя Крафт в F4-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('craft_item')

rp.seasonpass.AddQuest("noobie_quest_19", "Найди любого НПС-торговца, исследуя локации")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('vendor_menu_open')

rp.seasonpass.AddQuest("noobie_quest_20", "Купи любой предмет у НПС-торговца")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('trade_bought')

rp.seasonpass.AddQuest("noobie_quest_21", "Продай любой предмет НПС-торговцу")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('trade_sold')

rp.seasonpass.AddQuest("noobie_quest_22", "Возьми любую профессию Долга или Свободы")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('factions_taken', {
        factions = {
			[FACTION_DOLG] = true,
			[FACTION_SVOBODA] = true,
        },
    })

rp.seasonpass.AddQuest("noobie_quest_23", "Прими участие в Захвате Контрольной Точки")
:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('captured_point')

rp.seasonpass.AddQuest("noobie_quest_24", "Забери свою награду с Контрольной Точки, отыскав на ней ящики со снаряжением")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('capture_bonus_used')

rp.seasonpass.AddQuest("noobie_quest_25", "Прими участие в Ограблении Склада Противника, отыскав его на территории противника")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(1)
	:SetLevelScores(500)
	:SetType('start_hesit')

rp.seasonpass.AddQuest("noobie_quest_26", "Забери свою награду с Ограбления Склада Противника, отыскав ящик со снаряжением")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(2)
	:SetLevelScores(500)
	:SetType('take_loot_armory_heist')

rp.seasonpass.AddQuest("noobie_quest_27", "Получи любой бонус в F4-меню")
	:SetSeasons({ ["Знакомство с URF.IM"] = true, })
	:SetDifficulty(3)
	:SetLevelScores(500)
	:SetType('social_promo_or_bonus')

--[[ НАГРАДЫ ]]--
-- 1
SEASON_NOOBIE:AddReward({
	level = 1,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_CASE, 
			case_uid = 'cadet_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Маленький Кейс",
		},
	},
})

-- 2
SEASON_NOOBIE:AddReward({
	level = 2,
	color_premium = Color(170, 200, 235),
	awards = {
		{ 
			award_type = awards.AWARD_MONEY, 
			amount = 3250, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "3250 Игровой Валюты",
		},
	},
})

-- 3
SEASON_NOOBIE:AddReward({
	level = 3,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_TIME, 
			hours = 1,
			
			icon = Material("cases_icons/1h", "smooth", "noclamp"), 
			desc = "1 час игрового времени",
		},
	},
})

-- 4
SEASON_NOOBIE:AddReward({
	level = 4,
	color_premium = Color(170, 200, 235),
	awards = {
		{ 
			award_type = awards.AWARD_TIMEMULTIPLIER, 
			multiplier = 3,
			duration = '2h',
			
			icon = Material("cases_icons/time_x3", "smooth", "noclamp"), 
			desc = "Умножение времени х3 на 2 часа",
		},
	},
})

-- 5
SEASON_NOOBIE:AddReward({
	level = 5,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_MONEY, 
			amount = 3250, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "3250 Игровой Валюты",
		},
	},
})

-- 6
SEASON_NOOBIE:AddReward({
	level = 6,
	color_premium = Color(170, 200, 235),
	awards = {
		{ 
			award_type = awards.AWARD_CASE, 
			case_uid = 'cadet_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Маленький Кейс",
		},
	},
})

-- 7
SEASON_NOOBIE:AddReward({
	level = 7,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_TIME, 
			hours = 3,
			
			icon = Material("cases_icons/3h", "smooth", "noclamp"), 
			desc = "3 часа игрового времени",
		},
	},
})

-- 8
SEASON_NOOBIE:AddReward({
	level = 8,
	color_premium = Color(170, 200, 235),
	awards = {
		{ 
			award_type = awards.AWARD_MONEY, 
			amount = 3250, 
			
			icon = Material("cases_icons/money", "smooth", "noclamp"), 
			desc = "3250 Игровой Валюты",
		},
	},
})

-- 9
SEASON_NOOBIE:AddReward({
	level = 9,
	color_premium = Color(235, 75, 75),
	awards = {
		{ 
			award_type = awards.AWARD_EMOJI, 
			shop_uid = 'noobie_emoji', 
			
			icon = Material("rpui/seasonpass/noobie/noobie_emoji", "smooth", "noclamp"), 
			desc = "Культовое Эмоджи Успешного Успеха",
		},
	},
})

-- 10
SEASON_NOOBIE:AddReward({
	level = 10,
	color_premium = Color(170, 200, 235),
	awards = {
		{ 
			award_type = awards.AWARD_CASE, 
			case_uid = 'galactic_case',
			
			icon = Material("rpui/seasonpass/icons/case", "smooth", "noclamp"), 
			desc = "Большой Кейс",
		},
	},
})
