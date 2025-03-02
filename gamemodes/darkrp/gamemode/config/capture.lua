-- "gamemodes\\darkrp\\gamemode\\config\\capture.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.cfg.CaptureIncomePerPoint = 10
rp.cfg.CaptureCooldown = 60 --300
rp.cfg.DefaultPointPrice = 0

rp.cfg.CaptureVehicleRespawnDuration = 300

rp.cfg.ConjunctionTimeout = 10

rp.cfg.CaptureWarMaxScoreMultiplier = 2
rp.cfg.CaptureWarDurationMin = 150
rp.cfg.CaptureWarDurationMax = 400
rp.cfg.CaptureWarAskingDuration = 20

rp.cfg.CaptureDurationMin = 100
rp.cfg.CaptureDurationMax = 300
rp.cfg.CaptureDurationIncrease = 30

rp.cfg.CaptureFlagSpeed = 60


rp.cfg.CantCapture = rp.cfg.CantCapture or rp.GetFactionTeamsMap({ FACTION_MILITARY })

ALLIANCE_BANDITS = rp.Capture.AddAlliance {
	name = 'Bandits',
	printName = 'Бандиты',
	factions = {
		[FACTION_REBEL] = true,
	},
	color = Color(100, 117, 109),
	flagMaterial = 'https://sun9-19.userapi.com/c855728/v855728691/c5b27/IQAjhTmUFXw.jpg',
}

ALLIANCE_ARMY = rp.Capture.AddAlliance {
	name = 'Army',
	printName = 'ВСУ',
	factions = {
		[FACTION_MILITARY] = true,
		[FACTION_MILITARYS] = true,
	},
	color = Color(0, 72, 255),
	flagMaterial = 'https://sun9-19.userapi.com/c855728/v855728691/c5b43/Y9NEbAOxdBE.jpg',
}

ALLIANCE_SVOBODA = rp.Capture.AddAlliance {
	name = 'Svoboda',
	printName = 'Свобода',
	factions = {
		[FACTION_SVOBODA] = true,
	},
	color = Color(233, 150, 122),
	flagMaterial = 'https://sun9-21.userapi.com/c855728/v855728691/c5b35/zT1ZPmvgz6I.jpg',
}


ALLIANCE_DOLG = rp.Capture.AddAlliance {
	name = 'Dolg',
	printName = 'ДОЛГ',
	factions = {
		[FACTION_DOLG] = true,
	},
	color = Color(128, 0, 0),
	flagMaterial = 'https://sun9-35.userapi.com/c855728/v855728691/c5b2e/IS6Y1ATgO6s.jpg',
}

ALLIANCE_MONOLIT = rp.Capture.AddAlliance {
	name = 'Monolit',
	printName = 'Монолит',
	factions = {
		[FACTION_MONOLITH] = true,
		[FACTION_EVENTMONOLITH] = true,
	},
	color = Color(23, 130, 130),
	flagMaterial = 'https://sun9-53.userapi.com/c855728/v855728691/c5b4a/ERRekdPhwgg.jpg',
}

ALLIANCE_CLEAR = rp.Capture.AddAlliance {
	name = 'ClearSky',
	printName = 'Чистое Небо',
	factions = {
		[FACTION_NEBO] = true,
		[FACTION_EVENTNEBO] = true,
	},
	color = Color(0, 191, 255),
	flagMaterial = 'https://sun9-49.userapi.com/c855728/v855728691/c5b20/7K0JnO6VpmY.jpg',
}

ALLIANCE_NIG = rp.Capture.AddAlliance {
	name = 'NIG',
	printName = 'НИГ',
	factions = {
		[FACTION_ECOLOG] = true,
	},
	color = Color(0, 186, 15),
	flagMaterial = 'https://sun9-4.userapi.com/c855728/v855728691/c5b3c/mGgZRY8I3gk.jpg',
}

--Bandits
rp.ConjSetInvalid(ALLIANCE_BANDITS, CONJ_UNION, {ALLIANCE_DOLG,  ALLIANCE_NIG, ALLIANCE_ARMY, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_BANDITS, CONJ_NEUTRAL, {ALLIANCE_DOLG,  ALLIANCE_NIG, ALLIANCE_ARMY, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_BANDITS, CONJ_WAR, {})


--Dolg
rp.ConjSetInvalid(ALLIANCE_DOLG, CONJ_UNION, {ALLIANCE_SVOBODA, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_DOLG, CONJ_NEUTRAL, {ALLIANCE_NIG, ALLIANCE_ARMY, ALLIANCE_SVOBODA, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_DOLG, CONJ_WAR, {ALLIANCE_NIG, ALLIANCE_ARMY})


--SVOBODA
rp.ConjSetInvalid(ALLIANCE_SVOBODA, CONJ_UNION, {ALLIANCE_NIG, ALLIANCE_DOLG, ALLIANCE_ARMY, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_SVOBODA, CONJ_NEUTRAL, {ALLIANCE_DOLG, ALLIANCE_ARMY, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_SVOBODA, CONJ_WAR, {})


--Army
rp.ConjSetInvalid(ALLIANCE_ARMY, CONJ_UNION, {ALLIANCE_SVOBODA, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_ARMY, CONJ_NEUTRAL, {ALLIANCE_DOLG, ALLIANCE_SVOBODA, ALLIANCE_NIG, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_ARMY, CONJ_WAR, {ALLIANCE_DOLG, ALLIANCE_NIG})


--Monolit
rp.ConjSetInvalid(ALLIANCE_MONOLIT, CONJ_UNION, {ALLIANCE_DOLG, ALLIANCE_SVOBODA, ALLIANCE_NIG, ALLIANCE_ARMY, ALLIANCE_BANDITS, ALLIANCE_CLEAR})
--rp.ConjSetInvalid(ALLIANCE_MONOLIT, CONJ_NEUTRAL, {ALLIANCE_DOLG, ALLIANCE_SVOBODA, ALLIANCE_NIG, ALLIANCE_ARMY, ALLIANCE_BANDITS})
--rp.ConjSetInvalid(ALLIANCE_MONOLIT, CONJ_WAR, {ALLIANCE_MUT})

--Clear
rp.ConjSetInvalid(ALLIANCE_CLEAR, CONJ_UNION, {ALLIANCE_MONOLIT, ALLIANCE_BANDITS, ALLIANCE_DOLG, ALLIANCE_SVOBODA, ALLIANCE_NIG, ALLIANCE_ARMY})
--rp.ConjSetInvalid(ALLIANCE_CLEAR, CONJ_NEUTRAL, {ALLIANCE_ARMY, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
--rp.ConjSetInvalid(ALLIANCE_CLEAR, CONJ_WAR, {})

--NIG
rp.ConjSetInvalid(ALLIANCE_NIG, CONJ_UNION, {ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_NIG, CONJ_NEUTRAL, {ALLIANCE_DOLG, ALLIANCE_ARMY, ALLIANCE_BANDITS, ALLIANCE_MONOLIT})
rp.ConjSetInvalid(ALLIANCE_NIG, CONJ_WAR, {ALLIANCE_DOLG, ALLIANCE_ARMY})

-- Основная карта --
local POINT_STROIKA = rp.AddCapturePoint('rp_stalker_urfim', 'stroika')
	:SetPrintName('Стройка')
	:SetPos({Vector(7082, -3087, -302), Vector(9286, -1958, 598)})
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(7875.086914, -2759.246826, 326.187469))

	POINT_STROIKA:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Снаряжение')
		:SetPos(Vector(7772.053711, -2869.495850, 336.395355), Angle(-0.003, 76.179, -0.001))
		:SetAddMoney(500)
		:SetGiveArmor(25)
		:SetWeaponDefault('tfa_anomaly_scar')

local POINT_CLEARWATER = rp.AddCapturePoint('rp_stalker_urfim', 'clearwater')
	:SetPrintName('Водоочистная Станция')
	:SetPos({Vector(-207, -8659, -270), Vector(4631, -5799, 1468)})
	:SetAddHealth(15)
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(997.205566, -7193.264160, 102.187500))

	POINT_CLEARWATER:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Снаряжение')
		:SetPos(Vector(1223.537964, -7206.903809, 112.303635), Angle(0.000, 90.000, 0.000))
		:SetAddMoney(500)
		:SetWeaponDefault('tfa_anomaly_val')

local POINT_WATERPUMP = rp.AddCapturePoint('rp_stalker_urfim', 'waterpump')
	:SetPrintName('Водонапорная Башня')
	:SetPos({Vector(5691, 4271, -830), Vector(8765, 4938, 779)})
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(7354.378906, 4504.804199, -565.575317))

	POINT_WATERPUMP:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Аммуниция')
		:SetPos(Vector(7326.114746, 4531.876953, -557.291687), Angle(-11.299, 39.188, -0.857))
		:SetAddMoney(300)
		:SetGiveAmmo("Buckshot", 30)
	    :SetWeaponDefault('tfa_anomaly_aug_a1')


local POINT_SECLAGER = rp.AddCapturePoint('rp_stalker_urfim', 'seclager')
	:SetPrintName('Тайный Лагерь')
	:SetPos({Vector(3214, -1852, -1142), Vector(4124, -384, -578)})
    --:SetPayBonus(1000)
	:SetAddHealth(25)
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(3486, -983, -973))
	:SetFlagHeight(115)

	POINT_SECLAGER:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Снаряжение')
		:SetPos(Vector(3478.020020, -676.530640, -815.650513), Angle(-0.048, -95.446, -0.038))
		:SetAddMoney(500)
		:SetGiveAmmo("smg1", 180)
		:SetGiveAmmo("ar2", 120)
		:SetGiveAmmo("Buckshot", 60)
		:SetGiveArmor(35)
		:SetWeaponDefault('tfa_anomaly_ak101')

local POINT_SVALKAD = rp.AddCapturePoint('rp_stalker_urfim', 'svalkad')
	:SetPrintName('Свалка')
	:SetPos({Vector(-9017, -1645, -767), Vector(-5814, 4089, 753)}) --не охватывает базу ООН
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(-7419.295410, 648.615601, -340.511719))

	POINT_SVALKAD:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Снаряжение')
		:SetPos(Vector(-7451.653320, 621.015991, -376.974457), Angle(1.263, -179.018, -2.338))
		:SetAddMoney(500)
		:SetGiveAmmo("smg1", 60)
		:SetGiveAmmo("ar2", 60)
		:SetGiveAmmo("Buckshot", 20)
		:SetGiveArmor(25)
		:SetWeaponDefault('tfa_anomaly_lr300')

local POINT_ZABRDOM = rp.AddCapturePoint('rp_stalker_urfim', 'zabrdom')
	:SetPrintName('Заброшенный Дом')
	:SetPos({Vector(9020, 833, -429), Vector(10365, 1746, 376)})
	:SetIsOrg(true)
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(9431.834961, 1313.583130, -20.801193))

	POINT_ZABRDOM:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Доход')
		:SetPos(Vector(9746.605469, 1413.077148, -158.600204), Angle(-0.097, -179.991, 0.025))
		:SetAddMoney(250)
		:SetWeaponDefault('tfa_anomaly_l85')

local POINT_DEADLAGER = rp.AddCapturePoint('rp_stalker_urfim', 'deadlager')
	:SetPrintName('Лагерь Мертвых')
	:SetPos({Vector(4199, -10365, -998), Vector(4888, -9571, -628)})
	:SetIsOrg(true)
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(4789, -10076, -957))
	:SetFlagHeight(115)

	POINT_DEADLAGER:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Снаряжение')
		:SetPos(Vector(4912.143066, -10156.864258, -815.702576), Angle(-0.000, 135.030, 0.000))
		:SetAddMoney(500)
		:SetGiveArmor(50)
		:SetGiveAmmo("smg1", 180)
		:SetGiveAmmo("ar2", 150)
		:SetGiveAmmo("Buckshot", 60)
		:SetWeaponDefault('tfa_anomaly_hk416')

local POINT_BARTWO = rp.AddCapturePoint('rp_stalker_urfim', 'bartwo')
	:SetPrintName('Бар Крота')
	:SetPos({Vector(-1229, -1101, 224), Vector(-544, -224, 644)})
	:SetIsOrg(true)
	:SetNoHunger()
	:SetFlagPos(Vector(-830, -575, 530.187500))

		POINT_BARTWO:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Аммуниция')
		:SetPos(Vector(-679.991089, -790.981934, 540.337341), Angle(0.005, 134.968, 0.019))
		:SetAddMoney(500)
		:SetGiveAmmo("smg1", 150)
		:SetGiveAmmo("ar2", 120)
		:SetGiveAmmo("Buckshot", 45)
	    :SetWeaponDefault('tfa_anomaly_galil')

local POINT_BARTHREE = rp.AddCapturePoint('rp_stalker_urfim', 'barthree')
	:SetPrintName('Бар Еврея')
	:SetPos({Vector(-11180, 11471, -466), Vector(-8218, 13142, 948)})
	:SetIsOrg(true)
	:SetNoHunger()
	:SetFlagPos(Vector(-9407, 12167, 32))

	POINT_BARTHREE:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Аммуниция')
		:SetPos(Vector(-9353, 12429, 251), Angle(0, -68, 0))
		:SetAddMoney(250)
		:SetGiveAmmo("smg1", 120)
		:SetGiveAmmo("ar2", 90)
	    :SetWeaponDefault('tfa_anomaly_g36')

--------------------------EVENT------------------------------

local POINT_EVENTONE = rp.AddCapturePoint('rp_limanskhospital_urfim', 'eventone')
	:SetPrintName('Костер')
	:SetPos({Vector(387, 3351, -76), Vector(717, 3668, 25)})
	--:SetIsOrg(true)
	:SetNoHunger()
	:SetFlagPos(Vector(485.406219, 3513.757812, -57.812492))

local EVENTTWO = rp.AddCapturePoint('rp_limanskhospital_urfim', 'eventtwo')
	:SetPrintName('Мост')
	:SetPos({Vector(171, 5201, 185), Vector(925, 5498, 150)})
	--:SetIsOrg(true)
	:SetNoHunger()
	:SetFlagPos(Vector(448.239655, 5308.956055, 166.156250))


local EVENTTREE = rp.AddCapturePoint('rp_limanskhospital_urfim', 'eventtree')
	:SetPrintName('Завал')
	:SetPos({Vector(380, 6639, -68), Vector(698, 7005, 53)})
	--:SetIsOrg(true)
	:SetNoHunger()
	:SetFlagPos(Vector(553.002625, 6822.149414, -57.812496))

hook.Call("CapturePointsLoaded")



