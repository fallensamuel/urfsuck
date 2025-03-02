-- "gamemodes\\darkrp\\gamemode\\config\\cases.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local weighted_random

local give_randomized_job
local give_randomized_rank
local give_randomized_time
local give_randomized_weapon
local give_randomized_money
local give_randomized_credits

local give_job
local give_rank
local give_timemultiplier
local give_time
local give_weapon
local give_money
local give_credits
local give_hat

local give_perma_job
local give_perma_weapon
local give_perma_model

local give_item

local give_coupon

rp.lootbox.Add('daily_case', {
	name = 'Ежедневный Кейс',
	description = [[Бесплатный ежедневный кейс, который вы можете получить отыграв на сервере 3 часа в сутки.]],
	model = 'models/voidcases/plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(176, 195, 217),
	
	needed_time = 3 * 3600,
	cooldown_time = 24 * 3600,
	
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 30,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '2h')
			end,
			value = 10,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 30,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 2 часа',
			icon = Material('cases_icons/time_x3'),
			chance = 20,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '2h')
			end,
			value = 20,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 5,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 2 часа',
			icon = Material('cases_icons/time_x3'),
			chance = 10,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '2h')
			end,
			value = 40,
		},
		{
			name = 'VIP Статус 3 дн.',
			description = 'VIP привелегия на 72 часа',
			icon = Material('cases_icons/vip'),
			chance = 5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not (ply:IsVIP() or ply:IsAdmin())
			end,
			give = function(ply)
				give_rank(ply, 'vip', '3d')
			end,
			value = 30,
		},
	},
})

rp.lootbox.Add('mystery_case', {
	name = 'Таинственный Кейс',
	description = [[]],
	skin = 7,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'blogers.mp3',
	color = Color(253, 176, 0),
	price = 99,
	hidden = true,
	items = {
		{
			name = '3750 ГРН',
			description = '3750 игровой валюты',
			icon = Material('cases_icons/money'),
			chance = 47,
			notify = true,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 3750)
			end,
			value = 25,
		},
		{
			name = '50 Кредитов',
			description = '50 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			chance = 25,
			notify = true,
			give = function(ply)
				give_credits(ply, 50)
			end,
			value = 50,
		},
		{
			name = '13000 ГРН',
			description = '13000 игровой валюты',
			icon = Material('cases_icons/money'),
			chance = 15,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 13000)
			end,
			value = 100,
		},	
		{
			name = '150 Кредитов',
			description = '150 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 10,
			notify = true,
			give = function(ply)
				give_credits(ply, 150)
			end,
			value = 150,
		},	
		{
			name = '300 Кредитов',
			description = '300 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 2.999,
			notify = true,
			give = function(ply)
				give_credits(ply, 300)
			end,
			value = 300,
		},
		{
			name = 'Тайная Награда',
			description = 'Черезвычайно ценная и тайная награда!',
			icon = Material('cases_icons/mystery'),
			chance = 0.001,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not string.find( ply:GetRank(), "contributor" )
			end,
			give = function(ply)
				give_rank_perma(ply, 'globaladmin')
			end,
			value = 15000,
		},
	},
})

rp.lootbox.Add('winter_2023_case', {
	name = 'Новогоднее Чудо',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	skin = 4,
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'jingle_bells.mp3',
	color = Color(204, 51, 0),
	price = 79,
	hidden = true,
	items = {
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 1 часа',
			icon = Material('winter_icons/winter_uptime'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '1h')
			end,
			value = 25,
		},
		{
			name = '7500 ГРН',
			description = '7500 Гривен',
			icon = Material('winter_icons/winter_money'),
			chance = 20,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = '20 Часов',
			description = '20 часов игровго времени',
			icon = Material('winter_icons/20h'),
			chance = 35,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 20)
			end,
			value = 100,
		},
		{
			name = '13000 ГРН',
			description = '13000 Гривен',
			icon = Material('winter_icons/winter_money'),
			chance = 20,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 13000)
			end,
			value = 100,
		},
		{
			name = 'Новогодний Чудо Рюкзак',
			description = 'Новогодний Чудо Рюкзак навсегда',
			icon = Material('winter_icons/backpack_winter_2023'),
			chance = 10,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				local name = "Новогодний Чудо Рюкзак";
    			for _, mdl in ipairs( ply:GetNetVar("HatData") or {} ) do if (rp.hats.list[mdl] or {}).name == name then return false end end return true
			end,
			give = function(ply)
				give_hat(ply, "Новогодний Чудо Рюкзак")
			end,
			value = 250,
		},
		{
			name = 'Сладкая Дубина',
			description = 'Оружие - Сладкая Дубина',
			icon = Material('winter_icons/candy_2023'),
			chance = 5,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('weapon_candy'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'weapon_candy')
			end,
			value = 500,
		},
	},
})

rp.lootbox.Add('summer_case', {
	name = 'Лето-Лето Кейс',
	description = [[]],
	skin = 0,
	model = 'models/voidcases/wooden_crate_ivent.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'march.mp3',
	color = Color(51, 255, 0),
	price = 49,
	hidden = true,
	items = {
		{
			name = '3250 ГРН',
			description = '3250 Гривен',
			icon = Material('case_icons/urf_summer_money'),
			chance = 42,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игрового времени',
			icon = Material('case_icons/urf_summer_10h'),
			chance = 24.5,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '13000 ГРН',
			description = '13000 Гривен',
			icon = Material('case_icons/urf_summer_money'),
			chance = 14,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 13000)
			end,
			value = 100,
		},
        {
            name = 'Голововорот',
            description = 'Эмоция: Голововорот',
            icon = Material('case_icons/urf_summer_peely_blender'),
            chance = 15,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('f_peely_blender')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_peely_blender')
            end,
            value = 100,
        },
        {
            name = 'Модель - 2 Парня',
            description = 'Модель Администратора - 2 Парня',
            icon = Material('case_icons/urf_summer_male_male_07'),
            chance = 4,
            notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('urf_summer_male_male_07')
            end,
            give = function(ply)
                give_perma_model(ply, 'urf_summer_male_male_07')
            end,
            value = 150,
        },
        {
			name = 'Рюкзак URF.IM',
			description = 'Рюкзак URF.IM на 20 ячеек',
			icon = Material('case_icons/urf_summer_backpack'),
			chance = 0.5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
    			local name = "Рюкзак URF.IM";
    			for _, mdl in ipairs( ply:GetNetVar("HatData") or {} ) do if (rp.hats.list[mdl] or {}).name == name then return false end end return true
			end,
			give = function(ply)
				give_hat(ply, "Рюкзак URF.IM")
			end,
			value = 200,
		},
	},
})

rp.lootbox.Add('cadet_case', {
	name = 'Кейс Вечного Новичка',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0, 51, 204),
	price = 24,
	skin = 5,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 10,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Walker P9m',
			description = 'Скорострельный пистолет - Walker P9m',
			icon = Material('stalker_icons/walker'),
			chance = 5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_walter'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_walter')
			end,
			value = 100,
		},
	},
})

rp.lootbox.Add('nyf_case', {
	name = 'Подарок от Санты',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'ny_song.mp3',
	color = Color(0, 204, 51),
	price = 24,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 45,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = 'Временная Праздничная Маска',
			description = 'Временная Маска Пряни на 30 дней',
			icon = Material('cases_icons_ny/priania'),
			chance = 15,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				local name = "Временная Праздничная Маска";
    			for _, mdl in ipairs( ply:GetNetVar("HatData") or {} ) do if (rp.hats.list[mdl] or {}).name == name then return false end end return true
			end,
			give = function(ply)
				give_hat(ply, "Маска Пряни","30d")
			end,
			value = 50,
		},
		{
			name = 'Праздничная Маска',
			description = 'Маска Снежного Человека',
			icon = Material('cases_icons_ny/snowman'),
			chance = 4.9,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
    			local name = "Маска Снежного Человека";
    			for _, mdl in ipairs( ply:GetNetVar("HatData") or {} ) do if (rp.hats.list[mdl] or {}).name == name then return false end end return true
			end,
			give = function(ply)
				give_hat(ply, "Маска Снежного Человека")
			end,
			value = 50,
		},
		{
			name = '100 Кредитов',
			description = '100 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.1,
			notify = true,
			give = function(ply)
				give_credits(ply, 100)
			end,
			value = 100,
		},
	},
})

-- легендарный торговец

rp.lootbox.Add('lxy_case', {
	name = 'Хабар Якоря',
	description = [[]],
	model = 'models/voidcases/wooden_crate_stalker.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0, 204, 51),
	price = 24,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 22,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 30,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 20.4,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 10,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
	{
			name = 'Разведчик ВСУ',
			description = 'Профессию Разведчик ВСУ',
			icon = Material('icons/jobs/vsu0306'),
			chance = 0.1,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not rp.PlayerHasAccessToJob('casespecone', ply)
			end,
			give = function(ply)
				give_perma_job(ply, 'casespecone')
			end,
			value = 500,
		},
			},
})

rp.lootbox.Add('rep_case', {
	name = 'Кейс Наставника',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	skins = 4,
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0, 139, 139),
	price = 54,
	skin = 6,
	items = {
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 3 часа',
			icon = Material('cases_icons/time_x5'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '3h')
			end,
			value = 60,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 42.5,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '12500 ГРН',
			description = '12500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 24,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 12500)
			end,
			value = 100,
		},
		{
			name = '15 Часов',
			description = '15 часов игровго времени',
			icon = Material('cases_icons/15h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 75,
		},
		{
			name = '25000 ГРН',
			description = '25000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 4,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 25000)
			end,
			value = 200,
		},
		{
			name = 'Винтовка M16a2',
			description = 'Элитное вооружение Наемников - M16a2',
			icon = Material('stalker_icons/m16'),
			chance = 0.5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_m16a2'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_m16a2')
			end,
			value = 500,
		},
	},
})		

rp.lootbox.Add('haat_case', {
	name = 'Кейс Барыги',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	skins = 2,
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 204, 51),
	price = 149,
	skin = 7,
	items = {
		{
			name = '12999 ГРН',
			description = '12999 ГРН',
			icon = Material('cases_icons/money'),
			chance = 19,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 12999)
			end,
			value = 100,
		},
		{
			name = '125 Кредитов',
			description = '125 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			chance = 17,
			notify = true,
			give = function(ply)
				give_credits(ply, 125)
			end,
			value = 125,
		},
		{
			name = '19499 ГРН',
			description = '19499 ГРН',
			icon = Material('cases_icons/money'),
			chance = 22,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 19499)
			end,
			value = 150,
		},
		{
			name = '200 Кредитов',
			description = '200 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 4,
			notify = true,
			give = function(ply)
				give_credits(ply, 200)
			end,
			value = 200,
		},
		{
			name = '25999 ГРН',
			description = '25999 ГРН',
			icon = Material('cases_icons/money'),
			chance = 22,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 25999)
			end,
			value = 200,
		},
		{
			name = '300 Кредитов',
			description = '300 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.5,
			notify = true,
			give = function(ply)
				give_credits(ply, 300)
			end,
			value = 300,
		},
	},
})


rp.lootbox.Add('galactic_case', {
	name = 'Кейс Легенды ЧЗО',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(211, 44, 230),
	price = 199,
	skin = 8,
	items = {
		{
			name = '30 Часов',
			description = '30 часов игровго времени',
			icon = Material('cases_icons/30h'),
			chance = 45,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 30)
			end,
			value = 150,
		},
		{
			name = '26000 ГРН',
			description = '26000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 26000)
			end,
			value = 200,
		},
		{
			name = '39000 ГРН',
			description = '39000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 8,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 39000)
			end,
			value = 300,
		},
		{
			name = '400 Кредитов',
			description = '400 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 2,
			notify = true,
			give = function(ply)
				give_credits(ply, 400)
			end,
			value = 400,
		},
		{
			name = '59000 ГРН',
			description = '59000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 5,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_money(ply, 59000)
			end,
			value = 500,
		},
		{
			name = 'Пулемет РПД',
			description = 'Ручная модификация армейского пулемета с ленточным питанием',
			icon = Material('stalker_icons/rp74'),
			chance = 0.1,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_rpd'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_rpd')
			end,
			value = 1500,
		},
	},
})

rp.lootbox.Add('med_case', {
	name = 'Мэдик Кейс',
	description = [[]],
	model = 'models/voidcases/scifi_crate.mdl',
	skin = 5,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(51, 153, 51),
	price = 49,
	hidden = true,
	items = {
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 3 часа',
			icon = Material('cases_icons/time_x5'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '3h')
			end,
			value = 60,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 42.5,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '12500 ГРН',
			description = '12500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 24,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 12500)
			end,
			value = 100,
		},
		{
			name = '15 Часов',
			description = '15 часов игровго времени',
			icon = Material('cases_icons/30h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 75,
		},
		{
			name = '30 Часов',
			description = '30 часов игровго времени',
			icon = Material('cases_icons/30h'),
			chance = 4,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 30)
			end,
			value = 150,
		},
		{
			name = 'Винтовка M16',
			description = 'Элитное вооружение Наемников - M16',
			icon = Material('stalker_icons/m16'),
			chance = 0.5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_m16a2'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_m16a2')
			end,
			value = 500,
		},
	},
})

rp.lootbox.Add('mad_case_v2', {
	name = 'Мэдик Кейс v.2',
	description = [[]],
	model = 'models/voidcases/scifi_crate.mdl',
	skin = 6,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(51, 153, 51),
	price = 189,
	hidden = true,
	items = {
		{
			name = '30 Часов',
			description = '30 часов игровго времени',
			icon = Material('cases_icons/30h'),
			chance = 45,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 30)
			end,
			value = 150,
		},
		{
			name = '26000 ГРН',
			description = '26000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 26000)
			end,
			value = 200,
		},
		{
			name = '39000 ГРН',
			description = '39000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 8,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 39000)
			end,
			value = 300,
		},
		{
			name = '400 Кредитов',
			description = '400 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 2,
			notify = true,
			give = function(ply)
				give_credits(ply, 400)
			end,
			value = 400,
		},
		{
			name = 'Гаваец',
			description = 'Профессию Гаваец',
			icon = Material('stalker_icons/gavaec'),
			chance = 5,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not rp.PlayerHasAccessToJob('gavaec', ply)
			end,
			give = function(ply)
				give_perma_job(ply, 'gavaec')
			end,
			value = 500,
		},
		{
			name = 'Пулемет РП-74',
			description = 'Ручная модификация армейского пулемета с ленточным питанием',
			icon = Material('stalker_icons/rp74'),
			chance = 0.1,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_rpd'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_rpd')
			end,
			value = 1500,
		},
	},
})


rp.lootbox.Add('vipcase_case', {
	name = 'Кейс Мэдика',
	description = [[]],
	skin = 0,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 215, 0),
	price = 189,
	hidden = true,
	items = {
		{
			name = '30 Часов',
			description = '30 часов игрового времени',
			icon = Material('cases_icons/30h'),
			chance = 45,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 30)
			end,
			value = 150,
		},
		{
			name = '26000 ГРН',
			description = '26000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 26000)
			end,
			value = 200,
		},
		{
			name = '39000 ГРН',
			description = '39000 ГРН',
			icon = Material('cases_icons/money'),
			chance = 8,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 39000)
			end,
			value = 300,
		},
		{
			name = '400 Кредитов',
			description = '400 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 2,
			notify = true,
			give = function(ply)
				give_credits(ply, 400)
			end,
			value = 400,
		},
		{
			name = '60 Часов',
			description = '60 часов игрового времени',
			icon = Material('cases_icons/30h'),
			chance = 5,
		    colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 60)
			end,
			value = 300,
		},
		{
			name = 'Пулемет РП-74',
			description = 'Ручная модификация армейского пулемета с ленточным питанием',
			icon = Material('stalker_icons/rp74'),
			chance = 0.1,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_rpd'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_rpd')
			end,
			value = 1500,
		},
	},
})

rp.lootbox.Add('hecu_case', {
	name = 'Кейс ХЭКИЧА',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0, 51, 204),
	price = 19,
	skin = 5,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 10,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Walker P9m',
			description = 'Скорострельный пистолет - Walker P9m',
			icon = Material('stalker_icons/walker'),
			chance = 5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_walter'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'tfa_anomaly_walter')
			end,
			value = 100,
		},
	},
})

rp.lootbox.Add('bighecucase', {
	name = 'Кейс ХЭКИЧА',
	description = [[]],
	skin = 1,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0, 191, 255),
	price = 19,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 12500)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 10,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Лоли Канна',
			description = 'Модель Администратора - Лоли Канна',
			icon = Material('case_icons/kanna'),
			chance = 1,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_perma_model(ply, 'kanna')
			end,
			value = 100,
		},
	},
})

rp.lootbox.Add('case_cpn', {
	name = 'Обычный Кейс Спонсора',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	skin = 2,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 153, 0),
	price = 999,
	hidden = true,
	items = {
		{
			name = 'Скидка 10%',
			description = 'Скидка 10%',
			icon = Material('cases_icons/sale_10'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_coupon(ply, 'Скидка 10%')
			end,
			value = 500,
		},
		{
			name = 'Скидка 15%',
			description = 'Скидка 15%',
			icon = Material('cases_icons/sale_15'),
			chance = 25,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_coupon(ply, 'Скидка 15%')
			end,
			value = 1000,
		},
		{
			name = 'Личный Аксессуар',
			description = 'Личный Аксессуар',
			icon = Material('cases_icons/own_accessory'),
			chance = 20,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_coupon(ply, 'Личный Аксессуар')
			end,
			value = 500,
		},
		{
			name = 'Купон 500',
			description = 'Купон 500',
			icon = Material('cases_icons/cupon_500'),
			chance = 10,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_coupon(ply, 'Купон 500')
			end,
			value = 500,
		},
		{
			name = 'Купон 1000',
			description = 'Купон 1000',
			icon = Material('cases_icons/cupon_1000'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 1000')
			end,
			value = 1000,
		},
		{
			name = 'Личная Профессия',
			description = 'Личная Профессия',
			icon = Material('cases_icons/own_job'),
			chance = 4,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Личная Профессия')
			end,
			value = 1000,
		},
	},
})

rp.lootbox.Add('goldcase_cpn', {
	name = 'Золотой Кейс Спонсора',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	skin = 2,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 153, 0),
	price = 999,
	hidden = true,
	items = {
		{
			name = 'Скидка 10%',
			description = 'Скидка 10%',
			icon = Material('cases_icons/sale_10'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_coupon(ply, 'Скидка 10%')
			end,
			value = 500,
		},
		{
			name = 'Скидка 15%',
			description = 'Скидка 15%',
			icon = Material('cases_icons/sale_15'),
			chance = 25,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_coupon(ply, 'Скидка 15%')
			end,
			value = 1000,
		},
		{
			name = 'Личный Аксессуар',
			description = 'Личный Аксессуар',
			icon = Material('cases_icons/own_accessory'),
			chance = 20,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_coupon(ply, 'Личный Аксессуар')
			end,
			value = 500,
		},
		{
			name = 'Личная Профессия',
			description = 'Личная Профессия',
			icon = Material('cases_icons/own_job'),
			chance = 10,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Личная Профессия')
			end,
			value = 1000,
		},
		{
			name = 'Купон 1000',
			description = 'Купон 1000',
			icon = Material('cases_icons/cupon_1000'),
			chance = 4,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 1000')
			end,
			value = 1000,
		},
		{
			name = 'Купон 2000',
			description = 'Купон 2000',
			icon = Material('cases_icons/cupon_2000'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 2000')
			end,
			value = 2000,
		},
	},
})

rp.lootbox.Add('platcase_cpn', {
	name = 'Платиновый Кейс Спонсора',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	skin = 2,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 153, 0),
	price = 999,
	hidden = true,
	items = {
		{
			name = 'Скидка 15%',
			description = 'Скидка 15%',
			icon = Material('cases_icons/sale_15'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_coupon(ply, 'Скидка 15%')
			end,
			value = 1000,
		},
		{
			name = 'Скидка 20%',
			description = 'Скидка 20%',
			icon = Material('cases_icons/sale_20'),
			chance = 25,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_coupon(ply, 'Скидка 20%')
			end,
			value = 1500,
		},
		{
			name = 'Личный Рюкзак',
			description = 'Личный Рюкзак',
			icon = Material('cases_icons/own_bag'),
			chance = 20,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_coupon(ply, 'Личный Рюкзак')
			end,
			value = 1000,
		},
		{
			name = 'Личная Фракция',
			description = 'Личная Фракция',
			icon = Material('cases_icons/own_faction'),
			chance = 10,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Личная Фракция')
			end,
			value = 1500,
		},
		{
			name = 'Купон 2000',
			description = 'Купон 2000',
			icon = Material('cases_icons/cupon_2000'),
			chance = 4,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 2000')
			end,
			value = 2500,
		},
		{
			name = 'Купон 3000',
			description = 'Купон 3000',
			icon = Material('cases_icons/cupon_3000'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 3000')
			end,
			value = 3000,
		},
	},
})

rp.lootbox.Add('diamondcase_cpn', {
	name = 'Алмазный Кейс Спонсора',
	description = [[]],
	model = 'models/voidcases/plastic_crate_ny.mdl',
	skin = 2,
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 153, 0),
	price = 999,
	hidden = true,
	items = {
		{
			name = 'Скидка 20%',
			description = 'Скидка 20%',
			icon = Material('cases_icons/sale_20'),
			chance = 45,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_coupon(ply, 'Скидка 20%')
			end,
			value = 1500,
		},
		{
			name = 'Личный Рюкзак',
			description = 'Личный Рюкзак',
			icon = Material('cases_icons/own_bag'),
			chance = 25,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_coupon(ply, 'Личный Рюкзак')
			end,
			value = 1000,
		},
		{
			name = 'Личная Фракция',
			description = 'Личная Фракция',
			icon = Material('cases_icons/own_faction'),
			chance = 18,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Личная Фракция')
			end,
			value = 1500,
		},
		{
			name = 'Купон 2000',
			description = 'Купон 2000',
			icon = Material('cases_icons/cupon_2000'),
			chance = 8,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 2000')
			end,
			value = 2000,
		},
		{
			name = 'Купон 3000',
			description = 'Купон 3000',
			icon = Material('cases_icons/cupon_3000'),
			chance = 3.999,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Купон 3000')
			end,
			value = 3000,
		},
		{
			name = 'Франшиза',
			description = 'Франшиза',
			icon = Material('cases_icons/franc'),
			chance = 0.001,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_coupon(ply, 'Франшиза')
			end,
			value = 70000,
		},
	},
})

rp.lootbox.Add('time_case', {
	name = 'Кейс Умножения',
	description = [[]],
	model = 'models/voidcases/plastic_crate.mdl',
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(153, 0, 204),
	hidden = true,

	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 3 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 8,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 3 часа',
			icon = Material('cases_icons/time_x3'),
			chance = 16,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '3h')
			end,
			value = 23,
		},
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 3 часа',
			icon = Material('cases_icons/time_x5'),
			chance = 42,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '3h')
			end,
			value = 60,
		},
		{
			name = 'Время х10',
			description = 'Умножение игрового времени х10 на 3 часа',
			icon = Material('cases_icons/time_x10'),
			chance = 29,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 10, '3h')
			end,
			value = 120,
		},
		{
			name = 'Время х15',
			description = 'Умножение игрового времени х15 на 3 часа',
			icon = Material('cases_icons/time_x15'),
			chance = 4,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 15, '3h')
			end,
			value = 180,
		},
		{
			name = '30 Часов',
			description = '30 часов игровго времени',
			icon = Material('cases_icons/30h'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_time(ply, 30)
			end,
			value = 150,
		},
	},
})

rp.lootbox.Add('tg_case', {
	name = 'Телеграм Кейс',
	description = [[]],
	skin = 2,
	color = Color(0, 136, 204),
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'sw_standart_case.mp3',
	price = 19,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 11,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Волк',
			description = 'Профессия Волк',
			icon = Material('stalker_icons/wolf'),
			chance = 4,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not rp.PlayerHasAccessToJob('wolf', ply)
			end,
			give = function(ply)
				give_perma_job(ply, 'wolf')
			end,
			value = 200,
		},
	},
})

rp.lootbox.Add('report_case', {
	name = 'Кейс Благодарности',
	description = [[]],
	skin = 9,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(255, 204, 0),
	price = 100,
	hidden = true,
	items = {
		{
			name = '3250 ГРН',
			description = '3250 Гривен',
			icon = Material('cases_icons/money'),
			chance = 39,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 30,
		},
		{
			name = '5 Часов',
			description = '5 часов игрового времени',
			icon = Material('cases_icons/5h'),
			chance = 30.9999,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '6000 ГРН',
			description = '6000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 20,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 6000)
			end,
			value = 50,
		},
		{
			name = '15 Часов',
			description = '15 часов игрового времени',
			icon = Material('cases_icons/15h'),
			chance = 8,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 75,
		},
		{
			name = '100 Кредитов',
			description = '100 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 2,
			notify = true,
			give = function(ply)
				give_credits(ply, 100)
			end,
			value = 100,
		},
		{
			name = 'Тайная Награда',
			description = 'Черезвычайно ценная и тайная награда!',
			icon = Material('cases_icons/mystery'),
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			chance = 0.0001,
			notify = true,
			give = function(ply)
				give_credits(ply, 500)
			end,
			value = 500,
		},
	},
})

rp.lootbox.Add('bot_lucky_case', {
	name = 'Счастливый Шанс',
	description = [[]],
	skin = 10,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(0,153,0),
	price = 100,
	hidden = true,
	items = {
		{
			name = '6000 ГРН',
			description = '6000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 47.59,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 6000)
			end,
			value = 60,
		},
		{
			name = '50 Кредитов',
			description = '50 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			chance = 17.4,
			notify = true,
			give = function(ply)
				give_credits(ply, 50)
			end,
			value = 50,
		},
		{
			name = '12000 ГРН',
			description = '12000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 22,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 12000)
			end,
			value = 120,
		},
		{
			name = '100 Кредитов',
			description = '100 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 5,
			notify = true,
			give = function(ply)
				give_credits(ply, 100)
			end,
			value = 100,
		},
		{
			name = '24000 ГРН',
			description = '24000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 8,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_money(ply, 24000)
			end,
			value = 240,
		},
		{
			name = '300 Кредитов',
			description = '300 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.01,
			notify = true,
			give = function(ply)
				give_credits(ply, 300)
			end,
			value = 300,
		},
	},
})

rp.lootbox.Add('youtube_case', {
	name = 'YouTube Кейс',
	description = [[]],
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/wooden_open.wav',
	back_sound = 'blogers.mp3',
	color = Color(196, 48, 43),
	skin = 8,
	price = 19,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 11,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
			name = 'Волк',
			description = 'Профессия Волк',
			icon = Material('stalker_icons/wolf'),
			chance = 4,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not rp.PlayerHasAccessToJob('wolf', ply)
			end,
			give = function(ply)
				give_perma_job(ply, 'wolf')
			end,
			value = 200,
		},
	},
})

rp.lootbox.Add('autumn_case', {
    name = 'Кейс Золотой Осени',
    description = [[]],
    skin = 3,
    model = 'models/voidcases/wooden_crate_ivent.mdl',
    open_sound = 'voidcases/wooden_open.wav',
    back_sound = 'march.mp3',
    color = Color(255, 153, 0),
    price = 29,
    hidden = true,
    items = {
        {
            name = '3250 ГРН.',
            description = '3250 Гривен',
            icon = Material('cases_icons/money'),
            chance = 12,
            colors = {Color(170, 200, 235), Color(80, 110, 145)},
            chance_desc = 'Редкость: Обычная',
            give = function(ply)
                give_money(ply, 3250)
            end,
            value = 25,
        },
        {
            name = '5 Часов',
            description = '5 часов игрового времени',
            icon = Material('cases_icons/5h'),
            chance = 42.5,
            colors = {Color(170, 200, 235), Color(80, 110, 145)},
            chance_desc = 'Редкость: Обычная',
            give = function(ply)
                give_time(ply, 5)
            end,
            value = 25,
        },
        {
            name = 'Разбрызгиватель',
            description = 'Уникальный Танец Разбрызгивателя',
            icon = Material('autumn_icons/sprinkler'),
            chance = 25,
            colors = {Color(151, 78, 210), Color(61, 0, 120)},
            chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('f_sprinkler')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_sprinkler')
            end,
            value = 50,
        },
        {
            name = '10 Часов',
            description = '10 часов игрового времени',
            icon = Material('cases_icons/10h'),
            chance = 15,
            colors = {Color(151, 78, 210), Color(61, 0, 120)},
            chance_desc = 'Редкость: Мистическая',
            give = function(ply)
                give_time(ply, 10)
            end,
            value = 50,
        },
        {
            name = '100 Кредитов',
            description = '100 кредитов для игрового магазина',
            icon = Material('cases_icons/credits'),
            colors = {Color(240, 181, 25), Color(254, 121, 4)},
            chance_desc = 'Редкость: Легендарная',
            chance = 0.5,
            notify = true,
            give = function(ply)
                give_credits(ply, 100)
            end,
            value = 100,
        },
        {
            name = 'Модель - Мэй',
            description = 'Модель Администратора - Мэй',
            icon = Material('autumn_icons/may'),
            chance = 5,
            notify = true,
            colors = {Color(240, 181, 25), Color(254, 121, 4)},
            chance_desc = 'Редкость: Легендарная',
            calc_check = function(ply)
                return not ply:HasUpgrade('may')
            end,
            give = function(ply)
                give_perma_model(ply, 'may')
            end,
            value = 100,
        },
    },
})

rp.lootbox.Add('july_case', {
    name = 'Кейс Жаркого Июля',
    description = [[]],
    skin = 2,
    model = 'models/voidcases/wooden_crate_ivent.mdl',
    open_sound = 'voidcases/wooden_open.wav',
    back_sound = 'summer.mp3',
    color = Color(51, 255, 0),
    price = 39,
    hidden = true,
    items = {
        {
            name = '3250 ГРН.',
            description = '3250 Гривен',
            icon = Material('cases_icons/money'),
            chance = 47,
            colors = {Color(170, 200, 235), Color(80, 110, 145)},
            chance_desc = 'Редкость: Обычная',
            give = function(ply)
                give_money(ply, 3250)
            end,
            value = 25,
        },
        {
            name = '5 Часов',
            description = '5 часов игровго времени',
            icon = Material('cases_icons/5h'),
            chance = 25,
            colors = {Color(170, 200, 235), Color(80, 110, 145)},
            chance_desc = 'Редкость: Обычная',
            give = function(ply)
                give_time(ply, 5)
            end,
            value = 25,
        },
        {
            name = '10 Часов',
            description = '5 часов игровго времени',
            icon = Material('cases_icons/10h'),
            chance = 16,
            colors = {Color(76, 204, 89), Color(0, 102, 0)},
            chance_desc = 'Редкость: Особенная',
            give = function(ply)
                give_time(ply, 10)
            end,
            value = 50,
        },
        {
            name = 'Джазовый Танец',
            description = 'Уникальный Джазовый Танец',
            icon = Material('case_icons/jazzdance_icon'),
            chance = 8.5,
            colors = {Color(151, 78, 210), Color(61, 0, 120)},
            chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('jazzdance')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_jazz_dance')
            end,
            value = 100,
        },
        {
            name = 'Салли-Майк',
            description = 'Модель Администратора - Салли-Майк',
            icon = Material('case_icons/sally_icon'),
            chance = 3,
            notify = true,
            colors = {Color(240, 181, 25), Color(254, 121, 4)},
            chance_desc = 'Редкость: Легендарная',
            give = function(ply)
                give_perma_model(ply, 'sally')
            end,
            value = 200,
        },
        {
            name = '250 Кредитов',
            description = '200 кредитов для игрового магазина',
            icon = Material('cases_icons/credits'),
            colors = {Color(240, 181, 25), Color(254, 121, 4)},
            chance_desc = 'Редкость: Легендарная',
            chance = 0.1,
            notify = true,
            give = function(ply)
                give_credits(ply, 200)
            end,
            value = 250,
        },
    },
})      

rp.lootbox.Add('spring_case', {
	name = 'Подарок Весны',
	description = [[]],
    skin = 2,
    model = 'models/voidcases/wooden_crate_ivent.mdl',
    open_sound = 'voidcases/wooden_open.wav',
    back_sound = 'sw_standart_case.mp3',
    color = Color(51, 255, 0),
    price = 19,
    hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 15,
		},
		{
			name = '5 Часов',
			description = '5 часов игровго времени',
			icon = Material('cases_icons/5h'),
			chance = 40,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '3250 ГРН',
			description = '3250 ГРН',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 15,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '7500 ГРН',
			description = '7500 ГРН',
			icon = Material('cases_icons/money'),
			chance = 10,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 7500)
			end,
			value = 50,
		},
		{
            name = 'Ржумэн',
            description = 'Модель Администратора - Ржумэн',
            icon = Material('case_icons/roflman'),
            chance = 1,
            notify = true,
            colors = {Color(240, 181, 25), Color(254, 121, 4)},
            chance_desc = 'Редкость: Легендарная',
            give = function(ply)
                give_perma_model(ply, 'roflman')
            end,
            value = 100,
		},
	},
})	

rp.lootbox.Add('victory_case', {
	name = 'Кейс Победы',
	description = [[]],
	skin = 3,
	model = 'models/voidcases/plastic_crate_ny.mdl',
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'victory.mp3',
	color = Color(204, 0, 0),
	price = 29,
	hidden = true,
	items = {
		{
			name = '6455 ГРН',
			description = '6455 Гривен',
			icon = Material('cases_icons/money'),
			chance = 24,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 6455)
			end,
			value = 50,
		},
		{
			name = '10 Часов',
			description = '10 часов игровго времени',
			icon = Material('cases_icons/10h'),
			chance = 42.5,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '12999 ГРН',
			description = '12999 Гривен',
			icon = Material('cases_icons/money'),
			chance = 14,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 12999)
			end,
			value = 100,
		},
		{
			name = '15 Часов',
			description = '15 часов игровго времени',
			icon = Material('cases_icons/15h'),
			chance = 16,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 75,
		},
		{
			name = '200 Кредитов',
			description = '200 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 3,
			notify = true,
			give = function(ply)
				give_credits(ply, 200)
			end,
			value = 200,
		},
		{
			name = 'Оружие Победы',
			description = 'Уникальное Оружие Победы  - ВСС Винторез',
			icon = Material('case_icons/victory_gun'),
			chance = 0.5,
			notify = true,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('swb_priboy'))
			end,
			give = function(ply)
				give_perma_weapon(ply, 'swb_priboy')
			end,
			value = 400,
		},
	},
})

rp.lootbox.Add('ref_new', {
	name = 'Кейс Мега-Буста',
	description = [[]],
	skin = 4,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(51, 183, 117),
	price = 19,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 3 часа',
			icon = Material('cases_icons/time_x2'),
			chance = 35,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 20,
		},
		{
			name = '3250 ГРН',
			description = '3250 Гривен',
			icon = Material('cases_icons/money'),
			chance = 30,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '5 Часов',
			description = '5 часов игрового времени',
			icon = Material('cases_icons/5h'),
			chance = 24,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 25,
		},
		{
			name = '7000 ГРН',
			description = '7000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 8,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 7000)
			end,
			value = 50,
		},
		{
			name = '15 Часов',
			description = '15 часов игрового времени',
			icon = Material('cases_icons/15h'),
			chance = 2.9,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 50,
		},
		{
			name = '200 Кредитов',
			description = '200 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.1,
			notify = true,
			give = function(ply)
				give_credits(ply, 200)
			end,
			value = 200,
		},
	},
})

rp.lootbox.Add('ref_old', {
	name = 'Кейс Наставника',
	description = [[]],
	skin = 5,
	model = 'models/voidcases/blogers_plastic_crate.mdl',
	open_sound = 'voidcases/scifi1_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(126, 98, 255),
	price = 99,
	hidden = true,
	items = {
		{
			name = '3250 ГРН',
			description = '3250 Гривен',
			icon = Material('cases_icons/money'),
			chance = 25,
			notify = true,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 25,
		},
		{
			name = '7000 ГРН',
			description = '7000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 40,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 7000)
			end,
			value = 50,
		},
		{
			name = '100 Кредитов',
			description = '100 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			chance = 11,
			notify = true,
			give = function(ply)
				give_credits(ply, 100)
			end,
			value = 100,
		},
		{
			name = '14000 ГРН',
			description = '14000 Гривен',
			icon = Material('cases_icons/money'),
			chance = 20.9,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 14000)
			end,
			value = 100,
		},	
		{
			name = '200 Кредитов',
			description = '200 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 3,
			notify = true,
			give = function(ply)
				give_credits(ply, 200)
			end,
			value = 200,
		},	
		{
			name = '300 Кредитов',
			description = '300 кредитов для игрового магазина',
			icon = Material('cases_icons/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.1,
			notify = true,
			give = function(ply)
				give_credits(ply, 300)
			end,
			value = 300,
		},	
	},
})

-- Батлл-Пасс
rp.lootbox.Add('bp_uptime_low_case', {
	name = 'Кейс Умножения',
	description = [[]],
	skin = 3,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(76, 204, 89),
	price = 50,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 2 часа',
			icon = Material('icons/rewards/x2'),
			chance = 30,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '2h')
			end,
			value = 24,
		},
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 3 часа',
			icon = Material('icons/rewards/x2'),
			chance = 40,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 36,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 2 часа',
			icon = Material('icons/rewards/x3'),
			chance = 14,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '2h')
			end,
			value = 36,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 3 часа',
			icon = Material('icons/rewards/x3'),
			chance = 10,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '3h')
			end,
			value = 54,
		},
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 2 часа',
			icon = Material('icons/rewards/x5'),
			chance = 5,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '2h')
			end,
			value = 60,
		},
		{
			name = 'Время х10',
			description = 'Умножение игрового времени х10 на 1 часа',
			icon = Material('icons/rewards/x10'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 10, '1h')
			end,
			value = 60,
		},
	},
})

rp.lootbox.Add('bp_uptime_mid_case', {
	name = 'Кейс Мега-Умножения',
	description = [[]],
	skin = 4,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(151, 78, 210),
	price = 90,
	hidden = true,
	items = {
		{
			name = 'Время х2',
			description = 'Умножение игрового времени х2 на 3 часа',
			icon = Material('icons/rewards/x2'),
			chance = 14,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 2, '3h')
			end,
			value = 36,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 2 часа',
			icon = Material('icons/rewards/x3'),
			chance = 40,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '2h')
			end,
			value = 36,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 3 часа',
			icon = Material('icons/rewards/x3'),
			chance = 30,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '3h')
			end,
			value = 54,
		},
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 2 часа',
			icon = Material('icons/rewards/x5'),
			chance = 10,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '2h')
			end,
			value = 60,
		},
		{
			name = 'Время х10',
			description = 'Умножение игрового времени х10 на 1 час',
			icon = Material('icons/rewards/x10'),
			chance = 5,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 10, '1h')
			end,
			value = 60,
		},
		{
			name = 'Время х15',
			description = 'Умножение игрового времени х15 на 1 часа',
			icon = Material('icons/rewards/x15'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 15, '1h')
			end,
			value = 90,
		},
	},
})

rp.lootbox.Add('bp_uptime_high_case', {
	name = 'Кейс Ультра-Умножения',
	description = [[]],
	skin = 5,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(240, 181, 25),
	price = 120,
	hidden = true,
	items = {
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 2 часа',
			icon = Material('icons/rewards/x3'),
			chance = 10,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '2h')
			end,
			value = 36,
		},
		{
			name = 'Время х3',
			description = 'Умножение игрового времени х3 на 3 часа',
			icon = Material('icons/rewards/x3'),
			chance = 42,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 3, '3h')
			end,
			value = 54,
		},
		{
			name = 'Время х5',
			description = 'Умножение игрового времени х5 на 2 часа',
			icon = Material('icons/rewards/x5'),
			chance = 30.5,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 5, '2h')
			end,
			value = 60,
		},
		{
			name = 'Время х10',
			description = 'Умножение игрового времени х10 на 1 часа',
			icon = Material('icons/rewards/x10'),
			chance = 14,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 10, '1h')
			end,
			value = 60,
		},
		{
			name = 'Время х15',
			description = 'Умножение игрового времени х15 на 1 час',
			icon = Material('icons/rewards/x15'),
			chance = 3,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 15, '1h')
			end,
			value = 90,
		},
		{
			name = 'Время х20',
			description = 'Умножение игрового времени х20 на 1 часа',
			icon = Material('icons/rewards/x20'),
			chance = 0.5,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			calc_check = function(ply)
				return not ply:HasTimeMultiplayer('case_time')
			end,
			give = function(ply)
				give_timemultiplier(ply, 20, '1h')
			end,
			value = 120,
		},
	},
})

rp.lootbox.Add('bp_time_low_case', {
	name = 'Кейс Времени',
	description = [[]],
	skin = 0,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(76, 204, 89),
	price = 50,
	hidden = true,
	items = {
		{
			name = '3 Часа',
			description = '3 часа игрового времени',
			icon = Material('icons/rewards/3'),
			chance = 34,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 3)
			end,
			value = 18,
		},
		{
			name = '5 Часов',
			description = '5 часов игрового времени',
			icon = Material('icons/rewards/5'),
			chance = 60,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 30,
		},
		{
			name = '7 Часов',
			description = '7 часов игрового времени',
			icon = Material('icons/rewards/7'),
			chance = 5,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 7)
			end,
			value = 42,
		},
		{
			name = '10 Часов',
			description = '10 часов игрового времени',
			icon = Material('icons/rewards/10'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 60,
		},
	},
})

rp.lootbox.Add('bp_time_mid_case', {
	name = 'Кейса Мега-Времени',
	description = [[]],
	skin = 1,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(151, 78, 210),
	price = 90,
	hidden = true,
	items = {
		{
			name = '5 Часов',
			description = '5 Часов игрового времени',
			icon = Material('icons/rewards/5'),
			chance = 35,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 30,
		},
		{
			name = '7 Часов',
			description = '7 часов игрового времени',
			icon = Material('icons/rewards/7'),
			chance = 59,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 7)
			end,
			value = 42,
		},
		{
			name = '10 Часов',
			description = '10 часов игрового времени',
			icon = Material('icons/rewards/10'),
			chance = 5,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 60,
		},
		{
			name = '15 Часов',
			description = '15 часов игрового времени',
			icon = Material('icons/rewards/15'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 90,
		},
	},
})

rp.lootbox.Add('bp_time_high_case', {
	name = 'Кейс Ультра-Времени',
	description = [[]],
	skin = 2,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(240, 181, 25),
	price = 120,
	hidden = true,
	items = {
		{
			name = '5 Часов',
			description = '5 Часов игрового времени',
			icon = Material('icons/rewards/5'),
			chance = 29,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_time(ply, 5)
			end,
			value = 30,
		},
		{
			name = '10 Часов',
			description = '10 часов игрового времени',
			icon = Material('icons/rewards/10'),
			chance = 65,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_time(ply, 10)
			end,
			value = 60,
		},
		{
			name = '15 Часов',
			description = '15 часов игрового времени',
			icon = Material('icons/rewards/15'),
			chance = 5,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_time(ply, 15)
			end,
			value = 90,
		},
		{
			name = '25 Часов',
			description = '25 часов игрового времени',
			icon = Material('icons/rewards/25'),
			chance = 1,
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			give = function(ply)
				give_time(ply, 25)
			end,
			value = 150,
		},
	},
})

rp.lootbox.Add('bp_money_low_case', {
	name = 'Кейс Фортуны',
	description = [[]],
	skin = 6,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(76, 204, 89),
	price = 100,
	hidden = true,
	items = {
		{
			name = '1650 ГРН',
			description = '1650 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 10,
			notify = true,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 1650)
			end,
			value = 15,
		},
		{
			name = '3250 ГРН',
			description = '3250 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 60,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 30,
		},
		{
			name = '5000 ГРН',
			description = '5000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 23.9,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 5000)
			end,
			value = 45,
		},
		{
			name = '6500 ГРН',
			description = '6500 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 5,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 6500)
			end,
			value = 60,
		},
		{
			name = '11000 ГРН',
			description = '11000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 1,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 11000)
			end,
			value = 100,
		},
		{
			name = '100 Кредитов',
			description = '100 кредитов для игрового магазина',
			icon = Material('icons/rewards/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.1,
			notify = true,
			give = function(ply)
				give_credits(ply, 100)
			end,
			value = 100,
		},
	},
})

rp.lootbox.Add('bp_money_mid_case', {
	name = 'Кейс Мега-Фортуны',
	description = [[]],
	skin = 7,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(151, 78, 210),
	price = 200,
	hidden = true,
	items = {
		{
			name = '3250 ГРН',
			description = '3250 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 9.95,
			notify = true,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 3250)
			end,
			value = 30,
		},
		{
			name = '5000 ГРН',
			description = '5000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 30,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 5000)
			end,
			value = 45,
		},
		{
			name = '6500 ГРН',
			description = '6500 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 50,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 6500)
			end,
			value = 60,
		},
		{
			name = '11000 ГРН',
			description = '11000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 9,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 11000)
			end,
			value = 100,
		},
		{
			name = '22000 ГРН',
			description = '22000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 1,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 22000)
			end,
			value = 200,
		},
		{
			name = '200 Кредитов',
			description = '200 кредитов для игрового магазина',
			icon = Material('icons/rewards/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.05,
			notify = true,
			give = function(ply)
				give_credits(ply, 200)
			end,
			value = 200,
		},
	},
})

rp.lootbox.Add('bp_money_high_case', {
	name = 'Кейс Ультра-Фортуны',
	description = [[]],
	skin = 8,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'sw_standart_case.mp3',
	color = Color(240, 181, 25),
	price = 300,
	hidden = true,
	items = {
		{
			name = '6500 ГРН',
			description = '6500 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 14.45,
			notify = true,
			colors = {Color(170, 200, 235), Color(80, 110, 145)},
			chance_desc = 'Редкость: Обычная',
			give = function(ply)
				give_money(ply, 6500)
			end,
			value = 60,
		},
		{
			name = '11000 ГРН',
			description = '11000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 79,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 11000)
			end,
			value = 100,
		},
		{
			name = '22000 ГРН',
			description = '22000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 5,
			notify = true,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
			give = function(ply)
				give_money(ply, 22000)
			end,
			value = 200,
		},
		{
			name = '28000 ГРН',
			description = '28000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 1,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 28000)
			end,
			value = 250,
		},
		{
			name = '33000 ГРН',
			description = '33000 игровой валюты',
			icon = Material('icons/rewards/money'),
			chance = 0.5,
			notify = true,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
			give = function(ply)
				give_money(ply, 33000)
			end,
			value = 300,
		},
		{
			name = '300 Кредитов',
			description = '300 кредитов для игрового магазина',
			icon = Material('icons/rewards/credits'),
			colors = {Color(240, 181, 25), Color(254, 121, 4)},
			chance_desc = 'Редкость: Легендарная',
			chance = 0.05,
			notify = true,
			give = function(ply)
				give_credits(ply, 300)
			end,
			value = 300,
		},
	},
})

rp.lootbox.Add('bp_emoji_case', {
	name = 'Кейс Эмоджи',
	description = [[]],
	skin = 9,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'summer.mp3',
	color = Color(151, 78, 210),
	price = 100,
	hidden = true,
	items = {
        {
            name = 'Эмоджи - Сталкер 1',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_1'),
            chance = 20,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_1')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_1')
            end,
            value = 25,
        },
        {
            name = 'Эмоджи - Сталкер 2',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_2'),
            chance = 20,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_2')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_2')
            end,
            value = 25,
        },
        {
            name = 'Эмоджи - Сталкер 3',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_3'),
            chance = 20,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_3')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_3')
            end,
            value = 20,
        },
        {
            name = 'Эмоджи - Сталкер 4',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_4'),
            chance = 20,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_4')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_4')
            end,
            value = 20,
        },	
        {
            name = 'Эмоджи - Сталкер 5',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_5'),
            chance = 10,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_5')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_5')
            end,
            value = 20,
        },
        {
            name = 'Эмоджи - Сталкер 6',
            description = '',
            icon = Material('icons/rewards/aut_stalker_emoji_6'),
            chance = 10,
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			chance_desc = 'Редкость: Особенная',
            calc_check = function(ply)
                return not ply:HasUpgrade('aut_stalker_emoji_6')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOJI, 'aut_stalker_emoji_6')
            end,
            value = 20,
        },						
	},
})

rp.lootbox.Add('bp_taunts_case', {
	name = 'Кейс Эмоций',
	description = [[]],
	skin = 10,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'summer.mp3',
	color = Color(151, 78, 210),
	price = 100,
	hidden = true,
	items = {
        {
            name = 'Эмоция: Фэнси',
            description = 'Эмоция: Фэнси',
            icon = Material('icons/rewards/taunts'),
            chance = 30,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('f_fancyfeet')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_fancyfeet')
            end,
            value = 100,
        },	
        {
            name = 'Эмоция: Диско',
            description = 'Эмоция: Диско',
            icon = Material('icons/rewards/taunts'),
            chance = 30,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('f_dg_disco')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_dg_disco')
            end,
            value = 100,
        },
        {
            name = 'Эмоция: Волна',
            description = 'Эмоция: Волна',
            icon = Material('icons/rewards/taunts'),
            chance = 40,
			colors = {Color(151, 78, 210), Color(61, 0, 120)},
			chance_desc = 'Редкость: Мистическая',
            calc_check = function(ply)
                return not ply:HasUpgrade('f_octopus')
            end,
            give = function(ply)
                rp.awards.Give(ply, rp.awards.Types.AWARD_EMOTION, 'f_octopus')
            end,
            value = 100,
        },			
	},
})

rp.lootbox.Add('bp_wapons_case', {
	name = 'Оружейный Кейс',
	description = [[]],
	skin = 12,
	model = 'models/voidcases/plastic_crate_battlepass.mdl',
	open_sound = 'voidcases/plastic_open.wav',
	back_sound = 'summer.mp3',
	color = Color(213, 88, 80),
	price = 1000,
	hidden = true,
	items = {
		{
			name = '91-9A на 7 дней',
			description = 'Оружие - 91-9A на 7 дней',
			icon = Material('icons/rewards/tfa_anomaly_9a91'),
			chance = 20,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_9a91'))
			end,
			give = function(ply)
				give_weapon(ply, 'tfa_anomaly_9a91', '7d')
			end,
			value = 500,
		},
		{
			name = 'Walther WA 2000 на 7 дней',
			description = 'Оружие - Walther WA 2000 на 7 дней',
			icon = Material('icons/rewards/tfa_anomaly_wa2000'),
			chance = 20,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_wa2000'))
			end,
			give = function(ply)
				give_weapon(ply, 'tfa_anomaly_wa2000', '7d')
			end,
			value = 500,
		},
		{
			name = 'SIG SG552 Commando на 7 дней',
			description = 'Оружие - SIG SG552 Commando на 7 дней',
			icon = Material('icons/rewards/tfa_anomaly_sig552'),
			chance = 20,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_sig552'))
			end,
			give = function(ply)
				give_weapon(ply, 'tfa_anomaly_sig552', '7d')
			end,
			value = 500,
		},
		{
			name = 'Remington 870  на 7 дней',
			description = 'Оружие - Remington 870  на 7 дней',
			icon = Material('icons/rewards/tfa_anomaly_remington870'),
			chance = 20,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_remington870'))
			end,
			give = function(ply)
				give_weapon(ply, 'tfa_anomaly_remington870', '7d')
			end,
			value = 500,
		},
		{
			name = 'ПКП “ПЕЧЕНЕГ“ на 7 дней',
			description = 'Оружие - ПКП “ПЕЧЕНЕГ“ на 7 дней',
			icon = Material('icons/rewards/tfa_anomaly_pkp'),
			chance = 20,
			notify = true,
			colors = {Color(213, 88, 80), Color(213, 88, 80)},
			chance_desc = 'Редкость: Артефакт',
			calc_check = function(ply)
				return not IsValid(ply:GetWeapon('tfa_anomaly_pkp'))
			end,
			give = function(ply)
				give_weapon(ply, 'tfa_anomaly_pkp', '7d')
			end,
			value = 500,
		},			
	},
})

rp.lootbox.FTM = 2


weighted_random = function(tbl)
	local summ = 0
	local result
	local default_summ = 0
	local default
	
	for k, v in pairs(tbl) do
		if not default or default_summ < v then
			default = k
			default_summ = v
		end
		
		summ = summ + v
	end
	
	local chance = math.random(0, summ)
	
	for k, v in pairs(tbl) do
		chance = chance - v
		
		if chance <= 0 then
			result = k
			break
		end
	end
	
	return result or default
end


--calc_check = function(ply)
--	return not rp.PlayerHasAccessToJob('job_command', ply)
--end,
give_job = function(ply, job, time_id)
	if rp.PlayerHasAccessToJob(job, ply) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidJob'))
		
	else
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'профессию ' .. (rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job) .. ' на ' .. time_id .. '!')
		--ply:EmitSound("open_gift.mp3", 110)
			
		RunConsoleCommand("urf", "givetempjob", ply:SteamID(), job, time_id)
	end
end

--calc_check = function(ply)
--	return not (ply:IsVIP() or ply:IsAdmin())
--end,
give_rank = function(ply, privilege, time_id)
	if not (ply:IsVIP() or ply:IsAdmin()) then
		RunConsoleCommand("urf", "setgroup", ply:SteamID(), privilege, time_id, ply:GetUserGroup()) 
			
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'ранг ' .. ba.ranks.Get(privilege).NiceName .. ' на ' .. time_id)
		--ply:EmitSound("open_gift.mp3", 110)
		
	else
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidRank'))
	end
end

give_rank_perma = function(ply, privilege)
		RunConsoleCommand("urf", "setgroup", ply:SteamID(), privilege) 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'ранг ' .. ba.ranks.Get(privilege).NiceName)		
end

give_money = function(ply, amount)
	ply:AddMoney(amount)
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), rp.FormatMoney(amount))
end

give_credits = function(ply, amount)
	ply:AddCredits(amount, 'caseopen')
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), amount .. ' кредитов')
end

--calc_check = function(ply)
--     local name = "шапка";
--     for _, mdl in ipairs( ply:GetNetVar("HatData") or {} ) do if rp.hats.list[mdl].name == name then return false end end return true
--end,
give_hat = function(ply, hat_name, time)
    local hat;

    for _, data in pairs( rp.hats.list ) do
            if data.name == hat_name then
                    hat = data;
            end     
    end

    if not hat then
            return
    end

    rp.Notify( ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), translates.Get("шапку %s!", hat.name) );

    if not time then
            rp.hats.Give( ply, hat.model );
            return
    end

    RunConsoleCommand( "urf", "givetemphat", ply:SteamID(), hat.model, time );
end

--calc_check = function(ply)
--	return not IsValid(ply:GetWeapon('wep_class'))
--end,
give_weapon = function(ply, wep, time_id)
	if IsValid(ply:GetWeapon(wep)) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidWep'))
		return
	end
	
	net.Start('Lootbox::GaveWep')
		net.WriteString(wep)
		net.WriteBool(true)
		net.WriteString(time_id)
	net.Send(ply)
	
	--ply:EmitSound("open_gift.mp3", 110)
	
	RunConsoleCommand("urf", "givetempweapon", ply:SteamID(), wep, time_id) 
end

--calc_check = function(ply)
--	return not ply:HasTimeMultiplayer('case_time')
--end,
give_timemultiplier = function(ply, mult, time_id)
	if ply:HasTimeMultiplayer('case_time') then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidTime'))
		return false
	end
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'множитель времени x' .. mult .. ' на ' .. time_id)
	--ply:EmitSound("open_gift.mp3", 110)
	
	ply:AddTimeMultiplayerSaved('case_time', mult, 3600 * tonumber(string.sub(time_id, 1, -2)))
end

--calc_check = function(ply)
--	return ply:getInv() and ply:getInv():findEmptySlot(1, 1)
--end,
give_item = function(ply, uid)
	local inv = ply:getInv()
	
	if not inv then
		rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
		return
	end
	
	local status, result = inv:add(uid)

	if status == false then
		rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
		return
	end
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'предмет ' .. (rp.item.list[uid] and rp.item.list[uid].name or '') .. '!')

	timer.Simple(0.1, function()
		inv:sync(ply, true)
	end)
end

--calc_check = function(ply)
--	return not rp.PlayerHasAccessToJob('job_command', ply)
--end,
give_perma_job = function(ply, job)
	if rp.PlayerHasAccessToJob(job, ply) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidJob'))
		
	else
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'профессию ' .. (rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job) .. '!')
		
		rp.JobsWhitelist.GiveAccess(ply:SteamID64(), job)
	end
end

--calc_check = function(ply)
--	return not IsValid(ply:GetWeapon('weapon_class'))
--end,
give_perma_weapon = function(ply, wep)
	if IsValid(ply:GetWeapon(wep)) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidWep'))
		return
	end
	
	net.Start('Lootbox::GaveWep')
		net.WriteString(wep)
		net.WriteBool(false)
	net.Send(ply)
	
	RunConsoleCommand("urf", "givetempweapon", ply:SteamID(), wep, '-1h') 
end

--calc_check = function(ply)
--	return not ply:HasUpgrade('shop_uid')
--end,
give_perma_model = function(ply, shop_uid)
	if ply:HasUpgrade(shop_uid) then
		return rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidModel'))
	end
	
	rp._Stats:Query("INSERT INTO `kshop_purchases` VALUES(?, ?, ?, 0);", os.time(), ply:SteamID(), shop_uid, function(dat)
		local upgrades = ply:GetVar('Upgrades')
		upgrades[shop_uid] = upgrades[shop_uid] and (upgrades[shop_uid] + 1) or 1
		ply:SetVar('Upgrades', upgrades)
		
		shop_obj = rp.shop.GetByUID(shop_uid)
		shop_obj:OnBuy(ply)
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'модель ' .. shop_obj:GetName() .. '!')
	end)
end

give_time = function(ply, hours)
	ply:SetNetVar('PlayTime', ply:GetNetVar('PlayTime') + hours * 3600)
	ba.data.UpdatePlayTime(ply)
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), hours .. ' часов отыгранного времени!')
end

--calc_check = function(ply)
--	return not rp.PlayerHasAccessToJob('job_command', ply) and ...
--end,
give_randomized_job = function(ply, jobs, times)
	local jobs_copy = table.Copy(jobs)
	local job = weighted_random(jobs_copy)
	
	while table.Count(jobs_copy) > 0 and rp.PlayerHasAccessToJob(job, ply) do
		jobs_copy[job] = nil
		job = weighted_random(jobs_copy)
	end
	
	if rp.PlayerHasAccessToJob(job, ply) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidJob'))
		
	else
		local time_id = weighted_random(times)
		
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'профессию ' .. (rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job) .. ' на ' .. time_id .. '!')
		--ply:EmitSound("open_gift.mp3", 110)
			
		RunConsoleCommand("urf", "givetempjob", ply:SteamID(), job, time_id)
	end
end

--calc_check = function(ply)
--	return not (ply:IsVIP() or ply:IsAdmin())
--end,
give_randomized_rank = function(ply, ranks, times)
	if not (ply:IsVIP() or ply:IsAdmin()) then
		local privilege = weighted_random(ranks)
		local time_id = weighted_random(times)
		
		RunConsoleCommand("urf", "setgroup", ply:SteamID(), privilege, time_id, ply:GetUserGroup()) 
			
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'ранг ' .. ba.ranks.Get(privilege).NiceName .. ' на ' .. time_id)
		--ply:EmitSound("open_gift.mp3", 110)
		
	else
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidRank'))
	end
end

--calc_check = function(ply)
--	return not ply:HasTimeMultiplayer('case_time')
--end,
give_randomized_time = function(ply, multipliers, times)
	if ply:HasTimeMultiplayer('case_time') then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidTime'))
		return false
	end
	
	local mult = weighted_random(multipliers)
	local time_id = weighted_random(times)
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'множитель времени x' .. mult .. ' на ' .. time_id)
	--ply:EmitSound("open_gift.mp3", 110)
	
	ply:AddTimeMultiplayerSaved('case_time', mult, 3600 * tonumber(string.sub(time_id, 1, -2)))
end

--calc_check = function(ply)
--	return not IsValid(ply:GetWeapon('wep_class'))
--end,
give_randomized_weapon = function(ply, weapons, times)
	local weps_copy = table.Copy(weapons)
	local wep = weighted_random(weps_copy)
	
	while table.Count(weps_copy) > 0 and IsValid(ply:GetWeapon(wep)) do
		weps_copy[wep] = nil
		wep = weighted_random(weps_copy)
	end
	
	if IsValid(ply:GetWeapon(wep)) then
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::InvalidWep'))
		return
	end
	
	local time_id = weighted_random(times)
	
	net.Start('Lootbox::GaveWep')
		net.WriteString(wep)
		net.WriteBool(true)
		net.WriteString(time_id)
	net.Send(ply)
	
	--ply:EmitSound("open_gift.mp3", 110)
	
	RunConsoleCommand("urf", "givetempweapon", ply:SteamID(), wep, time_id) 
end

give_randomized_money = function(ply, min_amount, max_amount)
	local amount = math.ceil(math.random(min_amount, max_amount))
	
	ply:AddMoney(amount)
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), rp.FormatMoney(amount))
end

give_randomized_credits = function(ply, min_amount, max_amount)
	local amount = math.ceil(math.random(min_amount, max_amount))
	
	ply:AddCredits(amount, 'caseopen')
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), amount .. ' кредитов')
end

give_coupon = function(ply, coupon_desc)
	rp.syncHours.db:Query('INSERT INTO `lootbox_coupons`(`steamid`, `coupon_text`, `server`) VALUES(?, \'?\', \'?\');', ply:SteamID64(), coupon_desc, rp.cfg.ServerUID, function()
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('Lootbox::Reward'), coupon_desc)
	end)
end

if SERVER then
	util.AddNetworkString('Lootbox::GaveWep')
	
	hook.Add('Initialize', 'Lootbox::Coupons', function()
		rp.syncHours.db:Query('CREATE TABLE IF NOT EXISTS `lootbox_coupons` (`steamid` bigint(20) NOT NULL,`coupon_text` text NOT NULL,`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,`server` varchar(32),`consultant` varchar(32)) ENGINE=InnoDB DEFAULT CHARSET=utf8;')
	end)
	
else
	net.Receive('Lootbox::GaveWep', function()
		local wep = net.ReadString()
		
		if net.ReadBool() then
			local time_id = net.ReadString()
			rp.Notify(NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'оружие ' .. (weapons.Get(wep) and weapons.Get(wep).PrintName or wep) .. ' на ' .. time_id)
		
		else
			rp.Notify(NOTIFY_GREEN, rp.Term('Lootbox::Reward'), 'оружие ' .. (weapons.Get(wep) and weapons.Get(wep).PrintName or wep))
		end
	end)
end
