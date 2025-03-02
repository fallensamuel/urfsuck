-- "gamemodes\\rp_base\\gamemode\\default_config\\cfg.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

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

rp.cfg.MaxMoneyGive = 50
rp.cfg.MaxMoneyPerUser = 20

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
		name = translates.Get('Глобальный Premium'),
		grade = 2,
		
		global_rank = 31,
		
		custom_reward = function(ply)
			--ba.data.SetCustomToolgun(ply, 'gmod_tool_revolver', function() end)
			rp.awards.Give(ply, rp.awards.Types.AWARD_MODEL, 'premium')
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

rp.cfg.PremiumCost = rp.cfg.PremiumCost or 229
rp.cfg.PremiumYearCost = rp.cfg.PremiumYearCost or 999

rp.cfg.DonateInfo = rp.cfg.DonateInfo or {
	'Выберите способ оплаты',
	'За другими способами, пожалуйста,',
	'обратитесь к консультанту.'
}

rp.cfg.DefaultOrgBanners = rp.cfg.DefaultOrgBanners or {
	"https://i.imgur.com/cJ4KoM2.jpg",
	"https://i.imgur.com/luQYpFI.jpg",
	"https://i.imgur.com/5XF0iWU.jpg",
	"https://i.imgur.com/qpb2sxJ.jpg",
	"https://i.imgur.com/bF133cN.jpg",
	"https://i.imgur.com/t46Snwq.jpg",
	"https://i.imgur.com/zrXtomt.jpg",
	"https://i.imgur.com/6ou29Iv.jpg",
	"https://i.imgur.com/EtEKd5W.jpg",
	"https://i.imgur.com/vNZQp6i.jpg",
	"https://i.imgur.com/f9U7CSI.jpg",
	"https://i.imgur.com/X24ay6Y.jpg",
	"https://i.imgur.com/UcuKPCA.jpg",
	"https://i.imgur.com/5wngchS.jpg",
	"https://i.imgur.com/FYSalTr.jpg",
	"https://i.imgur.com/VZVJLeq.jpg",
	"https://i.imgur.com/wABHxLI.jpg",
	"https://i.imgur.com/CxSVvQV.jpg",
	"https://i.imgur.com/ZwaDLqk.jpg",
	"https://i.imgur.com/n44JSb2.jpg",
	"https://i.imgur.com/6s2STEH.jpg",
	"https://i.imgur.com/ZjMwf2a.jpg",
	"https://i.imgur.com/EmBu1wg.jpg",
	"https://i.imgur.com/DAJzWIW.jpg",
	"https://i.imgur.com/XNSAg2w.jpg",
	"https://i.imgur.com/kEC22KT.jpg",
	"https://i.imgur.com/ewKsbdX.jpg",
	"https://i.imgur.com/Ba2nrPc.jpg",
	"https://i.imgur.com/9OXruTw.jpg",
	"https://i.imgur.com/679zpXS.jpg",
	"https://i.imgur.com/ybMa52z.jpg",
	"https://i.imgur.com/8bpxvk2.jpg",
	"https://i.imgur.com/NmHmLNt.jpg",
	"https://i.imgur.com/w25Y41r.jpg",
	"https://i.imgur.com/Jdd9StN.jpg",
	"https://i.imgur.com/BjKoyYl.jpg",
	"https://i.imgur.com/7fJ3RZe.jpg",
	"https://i.imgur.com/3QLMuQU.jpg",
	"https://i.imgur.com/pEkcnaB.jpg",
	"https://i.imgur.com/V8KCRrD.jpg",
	"https://i.imgur.com/mgklsei.jpg",
	"https://i.imgur.com/vWorz6J.jpg",
	"https://i.imgur.com/N3fFDWi.jpg",
	"https://i.imgur.com/ODLT0Vn.jpg",
	"https://i.imgur.com/xt91Sa0.jpg",
	"https://i.imgur.com/wLcWfcy.jpg",
	"https://i.imgur.com/HspXnIr.jpg",
	"https://i.imgur.com/PzohlBG.jpg",
	"https://i.imgur.com/F1aNpyH.jpg",
	"https://i.imgur.com/dV1H4Pf.jpg",
	"https://i.imgur.com/ILrMXhw.jpg",
	"https://i.imgur.com/yp2SmkC.jpg",
	"https://i.imgur.com/uS2Im0G.jpg",
	"https://i.imgur.com/5Y6UhZL.jpg",
	"https://i.imgur.com/bOOIN6F.jpg",
	"https://i.imgur.com/ht7jvzp.jpg",
	"https://i.imgur.com/FJKV61V.jpg",
	"https://i.imgur.com/HyWHbYN.jpg",
	"https://i.imgur.com/iiPVLhC.jpg",
	"https://i.imgur.com/uqMer1j.jpg",

	-- old
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

if rp.cfg.AllowDisguiseName == nil then rp.cfg.AllowDisguiseName = false end
if rp.cfg.CharactersPrefix == nil then rp.cfg.CharactersPrefix = { disabled = true } end
if rp.cfg.CharactersSuffix == nil then rp.cfg.CharactersSuffix = { disabled = true } end

rp.cfg.ReferralRewards = rp.cfg.ReferralRewards or {
	["Referrer"] = {
--[[
		{
			type = "AWARD_CREDITS",
			name = "1 кредит",
			icon = Material("cases_icons/credits.png", "smooth"),
			colors = {Color(76, 204, 89), Color(0, 102, 0)},
			value = 1,
		},

		{
			type = "AWARD_CASE",
			name = "Ежедневный кейс",
			icon = Material("rpui/seasonpass/icons/case.png", "smooth"),
			value = "daily_case"
		}
]]--
	},

	["Referee"] = {
--[[
		{
			type = "AWARD_MONEY",
			name = "1 игровая валюта",
			icon = Material("cases_icons/money.png", "smooth"),
			value = 1,
		},

		{
			type = "AWARD_CASE",
			name = "Ежедневный кейс",
			icon = Material("rpui/seasonpass/icons/case.png", "smooth"),
			value = "daily_case"
		}
]]--
	}
};
