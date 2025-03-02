
rp.cfg.MaxArmor 	= rp.cfg.MaxArmor or 665
rp.cfg.MaxHealth 	= rp.cfg.MaxHealth or 260

rp.cfg.DoorColorWhite 	= rp.cfg.DoorColorWhite or Color(255, 255, 245)
rp.cfg.DoorColorBlack 	= rp.cfg.DoorColorBlack or Color(0, 0, 0)
rp.cfg.DoorColorGreen 	= rp.cfg.DoorColorGreen or Color(50, 200, 50)

rp.cfg.ScoreboardName 	= rp.cfg.ScoreboardName or 'За Фрименом!'

rp.cfg.MenuCategoryMoney 	= rp.cfg.MenuCategoryMoney or 'Деньги'
rp.cfg.MenuCategoryActions 	= rp.cfg.MenuCategoryActions or 'Действия'
rp.cfg.MenuCategoryRoleplay = rp.cfg.MenuCategoryRoleplay or 'Roleplay'
rp.cfg.MenuCategoryMayor 	= rp.cfg.MenuCategoryMayor or 'Сектор'
rp.cfg.MenuCategoryPolice 	= rp.cfg.MenuCategoryPolice or 'Правопорядок'

rp.cfg.NewsReport = rp.cfg.NewsReport or 'Новости Альянса'

rp.cfg.ServerUID = rp.cfg.ServerUID or 'not_assigned_' .. game.GetIPAdress()

rp.cfg.MaxNoobCreditsGive = 3000
rp.cfg.MaxNoobCreditsPerUser = 1000

rp.cfg.MaxNoobMoneyGive = 10
rp.cfg.MaxNoobMoneyPerUser = 3

rp.cfg.ServerMapId = rp.cfg.ServerMapId or game.GetMap()

rp.cfg.DeathSound = rp.cfg.DeathSound or false
if rp.cfg.FootstepSound == nil then rp.cfg.FootstepSound = true end

if rp.cfg.CheckTeamChange == nil then rp.cfg.CheckTeamChange = true end

rp.cfg.GlobalRankPlayers = rp.cfg.GlobalRankPlayers or {}
rp.cfg.GlobalRanks = rp.cfg.GlobalRanks or {
	['global_vip'] = {
		name = 'Глобальный VIP',
		grade = 1,
		global_rank = 2,
	}, 
	['global_prem'] = {
		name = 'Глобальный Premium',
		grade = 2,
		
		global_rank = 31,
		
		custom_reward = function(ply)
			--ba.data.SetCustomToolgun(ply, 'gmod_tool_revolver', function() end)
		end,
	}, 
	['sponsor_bronze'] = {
		name = 'Спонсор (Бронза)',
		grade = 3,
		
		main_rank = 23,
		global_rank = 11,
		
		global_hours = 500,
		global_credits = 1000,
	}, 
	['sponsor_gold'] = {
		name = 'Спонсор (Золото)',
		grade = 4,
		
		main_rank = 24,
		global_rank = 5,
		
		main_hours = 5000,
		global_hours = 2000,
		
		global_credits = 2000,
	}, 
	['sponsor_platinum'] = {
		name = 'Спонсор (Платина)',
		grade = 5,
		
		global_rank = 25,
		
		main_hours = 10000,
		global_hours = 5000,
		
		global_credits = 5000,
	}, 
	['sponsor_bronze_friend'] = {
		name = 'Друг спонсора (Бронза)',
		global_credits = 500,
	}, 
	['sponsor_gold_friend'] = {
		name = 'Друг спонсора (Золото)',
		global_credits = 1000,
	}, 
	['sponsor_platinum_friend'] = {
		name = 'Друг спонсора (Платина)',
		global_credits = 2500,
	}, 
}

rp.cfg.PremiumCost = rp.cfg.PremiumCost or 199

rp.cfg.DonateInfo = rp.cfg.DonateInfo or {
	'Дополнительные способы оплаты',
	'(PayPal/WebMoney/Криптовалюта и др.)',
	'доступны у консультанта.'
}

rp.cfg.DefaultOrgBanners = rp.cfg.DefaultOrgBanners or {
	'https://i.imgur.com/7AgnMgL.png',
	'https://i.imgur.com/32zcURd.png',
	'https://i.imgur.com/D2j9rq4.png', 
	'https://i.imgur.com/y1oTnQM.png', 
	'https://i.imgur.com/HKy7clR.png', 
	'https://i.imgur.com/ZpXBHpc.png', 
	'https://i.imgur.com/gmJI3k0.png', 
	'https://i.imgur.com/G1FyIkd.png', 
	'https://i.imgur.com/ED7CtBt.png', 
	'https://i.imgur.com/TeYCWS7.png', 
	'https://i.imgur.com/GX4NDXm.png', 
	'https://i.imgur.com/O2L61h1.png', 
	'https://i.imgur.com/KWwtERI.png', 
	'https://i.imgur.com/obKwSKj.png', 
	'https://i.imgur.com/X2kfMpp.png', 
	'https://i.imgur.com/PNrnopm.png', 
	'https://i.imgur.com/mcB5nL6.png', 
	'https://i.imgur.com/wMhLWBg.png', 
	'https://i.imgur.com/rLFBMkp.png', 
}

rp.cfg.IDCard = rp.cfg.IDCard or {
	statuses = {
		[0] = "Нищий",
		[3000] = "Бедный",
		[50000] = "Среднее",
		[90000] = "Выше среднего",
		[190000] = "Зажиточный",
		[550000] = "Богат"
	},
	-- "NICK показал документ под номером NUM LOYALITY. Благосостояние: STATUS"
	text = "%s показал документ под номером %s %s. Благосостояние: %s"
}