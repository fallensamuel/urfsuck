local mpf_color = Color(72, 255, 255)
local helix_color = Color(244, 194, 66)
local ota_color = Color(58, 95, 205)
local cmd_color = Color(255, 0, 0)
local grid_color = Color(0, 204, 204)

local mpf_spawns = {
	rp_city17_alyx_urfim = {
		Vector(6860, 759, -64),
		Vector(6860, 693, -64),
		Vector(6860, 635, -64),
		Vector(6860, 571, -64),
		Vector(6911, 759, -64),
		Vector(6911, 693, -64),
		Vector(6911, 635, -64),
		Vector(6911, 571, -64),
		Vector(6986, 759, -64),
		Vector(6986, 693, -64),
		Vector(6986, 635, -64),
		Vector(6986, 571, -64),
	},
}

local mpf_spawns_station = {
	rp_city17_alyx_urfim = {
		Vector(1000, 5365, 32),
		Vector(900, 5365, 32),
		Vector(800, 5365, 32),
		Vector(700, 5365, 32),
		Vector(600, 5365, 32),
		Vector(500, 5365, 32),
		Vector(400, 5365, 32),
		Vector(300, 5365, 32),
		Vector(200, 5365, 32),
		Vector(1000, 5430, 32),
		Vector(900, 5430, 32),
		Vector(800, 5430, 32),
		Vector(700, 5430, 32),
		Vector(600, 5430, 32),
		Vector(500, 5430, 32),
		Vector(400, 5430, 32),
		Vector(300, 5430, 32),
		Vector(200, 5430, 32),
	},
}

local ota_spawns = {
		rp_city17_alyx_urfim = {
		Vector(7425, 223, -64),
		Vector(7346, 223, -64),
		Vector(7194, 223, -64),
		Vector(7100, 223, -64),
		Vector(7425, 144, -64),
		Vector(7346, 144, -64),
		Vector(7194, 144, -64),
		Vector(7100, 144, -64),
	},
}

local cmd_spawn = {
rp_city17_alyx_urfim = {
		Vector(7690, 3785, 384),
        Vector(7565, 3785, 384),
        Vector(7430, 3785, 384),
        Vector(7690, 3700, 384),
        Vector(7565, 3700, 384),
        Vector(7430, 3700, 384),
	},
}

local stasis_spawn = {
	rp_city17_alyx_urfim = {
		Vector(7425, 223, -64),
		Vector(7346, 223, -64),
		Vector(7194, 223, -64),
		Vector(7100, 223, -64),
		Vector(7425, 144, -64),
		Vector(7346, 144, -64),
		Vector(7194, 144, -64),
		Vector(7100, 144, -64),
	},
}

local map = isC17 && 17 or 17

TEAM_RCT = rp.addTeam("C"..map..".MPF.RCT", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/rctmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Recruit

Рекрут основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Прохождение основного курса подготовки сотрудников Гражданской Обороны;
- Патрулирование в составе группы из 3 и более юнитов, со старшим по званию;

Запрещается:
- Покидать пост или же вокзал своевольно;
- Использовать огнестрельное оружие;
- Выдавать и исполнять предписания без приказа старшего по званию;
- Ампутировать;
- Учавствовать в Зачистке;

Подчиняется: 
Гражданская Оборона: 03 и выше, любого дивизиона;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступ к Секторам:
D1 - D5 Разрешен;
D6 Запрещен; 

Доступ к Нексус Надзору:
Тюрьма и допросная Запрещен;
Тюремный холл и чипировальня Запрещен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Запрещен;
Крыло С Запрещен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Низкая;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_cuff_elastic"},
	spawns = mpf_spawns_station,
	salary = 10,
	command = 'rct',
	faction = FACTION_MPF,
	rationCount = 2,
	stamina = 2,
	reversed = true,
	randomName = true,
	CantUseDisguise = true,
	armor = 40,
	loyalty = 1,
})

TEAM_MPF05 = rp.addTeam("C"..map..".MPF.05", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
	description = [[
Metropolis Police Force.05

Рядовой (05) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Патрулирование в составе группы из 3 и более юнитов, со старшим по званию;
- Выдача и исполнение предписаний;
- Проведение допросов;

Запрещается:
- Покидать Нексус Надзор своевольно;
- Проводить допросы в одиночку;
- Ампутировать;
- Учавствовать в Зачистке;

Подчиняется: 
Гражданская Оборона: 03 и выше, любого дивизиона;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешена охрана периметра;

Доступ к Нексус Надзору:
Тюрьма и допросная Запрещен;
Тюремный холл и чипировальня Запрещен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Запрещен;
Крыло С Запрещен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Средняя;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_pistol","weapon_cuff_elastic"},
	spawns = mpf_spawns_station,
	salary = 15,
	command = 'mpf05',
	faction = FACTION_MPF,
	unlockTime = 1.5 * 3600,
	unlockPrice = 750,
	rationCount = 2,
	stamina = 2,
	reversed = true,
	hasLicense = true,
	randomName = true,
	CantUseDisguise = true,
	armor = 50,
	loyalty = 2,
	max = 8,
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
          skins       = {0},
        },
    },
})

TEAM_MPF03 = rp.addTeam("C"..map..".MPF.03", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
	description = [[
Metropolis Police Force.03

Сержант (03) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Формирование и управление группой из RCT/05;
- Патрулирование в составе группы из 3 и более юнитов;
- Выдача и исполнение предписаний;
- Проведение допросов;

Запрещается:
- Проводить допросы в одиночку;
- Ампутировать граждан с Максимальной Лояльностью;
- Участвовать в Зачистке;

Подчиняется: 
Гражданская Оборона: 01 и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Тюрьма и допросная Запрещен;
Тюремный холл и чипировальня Разрешен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Запрещен;
Крыло С Запрещен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Средняя;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_pistol","swb_smg","weapon_cuff_elastic"},
	spawns = mpf_spawns_station,
	salary = 20,
	command = 'mpf03',
	faction = FACTION_MPF,
	unlockTime = 5 * 3600,
	unlockPrice = 2500,
	rationCount = 3,
	stamina = 2,
	reversed = true,
	hasLicense = true,
	randomName = true,
	CantUseDisguise = true,
	armor = 75,
	loyalty = 2,
	max = 4,
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
          skins       = {2},
        },
    },
})

TEAM_MPF03 = rp.addTeam("C"..map..".MPF.Elite.03", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/jepumetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Elite.03

Элитный Сержант (03) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Формирование и управление группой из RCT/05;
- Патрулирование в составе группы из 3 и более юнитов;
- Выдача и исполнение предписаний;
- Проведение допросов;

Запрещается:
- Проводить допросы в одиночку;
- Ампутировать граждан с Максимальной Лояльностью;
- Участвовать в Зачистке;

Подчиняется: 
Гражданская Оборона: 01 и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Тюрьма и допросная Разрешен;
Тюремный холл и чипировальня Разрешен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Разрешен;
Крыло С Разрешен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Средняя;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_357","swb_smg","weapon_frag" ,"weapon_cuff_elastic"},
	spawns = mpf_spawns_station,
	salary = 25,
	command = 'promo_elit',
	faction = FACTION_MPF,
	rationCount = 4,
	stamina = 2,
	reversed = true,
	hasLicense = true,
	randomName = true,
	CantUseDisguise = true,	
	disableDisguise = true,
	armor = 90,
	loyalty = 2,
	max = 5,
	whitelisted = true,
	customCheck = function(ply) return CLIENT or rp.PlayerHasAccessToJob('promo_elit', ply) end,
	CustomCheckFailMsg = 'TestPromoDenied', 
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/jepumetropolicepm.mdl'},
          skins       = {2},
        },
    },
})

TEAM_GU01 = rp.addTeam("C"..map..".MPF.01", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
	description = [[
Metropolis Police Force.01

Старший Сержант (01) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Формирование и управление группой из RCT/05/03;
- Патрулирование в составе группы из 3 и более юнитов;
- Выдача и исполнение предписаний;
- Проведение допросов;
- Участие в Зачистке;

Подчиняется: 
Гражданская Оборона: OfC и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Тюрьма и допросная Разрешен;
Тюремный холл и чипировальня Разрешен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Разрешен;
Крыло С Разрешен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Высокая;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_pistol","swb_smg","weapon_frag","weapon_cuff_elastic"},
	spawns = mpf_spawns,
	salary = 30,
	command = 'mpf01',
	faction = FACTION_MPF,
	unlockTime = 15 * 3600,
	unlockPrice = 7500,
	rationCount = 5,
	stamina = 2,
	reversed = true,
	hasLicense = true,
	randomName = true,
	canCapture = true,
	CantUseDisguise = true,
	disableDisguise = true,
	armor = 90,
	loyalty = 3,
	max = 4,
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
          skins       = {4},
        },
    },
})

TEAM_OFC = rp.addTeam("C"..map..".MPF.OfC", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/ofcmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Officer

Офицер (OfC) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Формирование и управление группой из RCT/05/03/01;
- Слежение за работой юнитов основного наземного подразделения;
- Премирование и повышение юнитов основного наземного подразделения;
- Участие в Зачистке;

Особенности:
- Выдача премии сотрудникам ГО;

Подчиняется: 
Гражданская Оборона: DvL и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Высокая;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_ar2", "swb_shotgun","weapon_frag","swb_pistol","weapon_cuff_elastic"},
	spawns = mpf_spawns,
	salary = 35,
	command = 'mpfofc',
	faction = FACTION_MPF,
	unlockTime = 30 * 3600,
	unlockPrice = 9000,
	rationCount = 6,
	stamina = 2,
	reversed = true,
	hasLicense = true,
	randomName = true,
	usemask = {2, 0},
	canCapture = true,
	forceLimit = true,
	CantUseDisguise = true,	
	disableDisguise = true,
	armor = 125,
	loyalty = 3,
	max = 3,
})

TEAM_DVL = rp.addTeam("C"..map..".MPF.DvL", {
	color = mpf_color,
	model = {'models/rrp/metropolice/pm/zdvlmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Division Leader

Дивизионный Лидер (DvL) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Осуществление командования основным наземным подразделением Гражданской Обороны;
- Премирование и повышение юнитов основного наземного подразделения;
- Изменения кода положения города, согласно регламенту;
- Инициирование Зачисток;

Особенности:
- Понижать в должности/выдавать премии сотрудникам ГО;
- Регулирование положения в городе;

Подчиняется: 
Гражданская Оборона: SeC;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser", "swb_ar2" ,"swb_shotgun", "weapon_frag", "swb_357", "weapon_cuff_elastic"},
	spawns = mpf_spawns,
	salary = 40,
	command = 'mpfdvl',
	faction = FACTION_MPF,
	unlockTime = 150 * 3600,
	unlockPrice = 30000,
	rationCount = 7,
	stamina = 2,
	reversed = true,
	randomName = true,
	canCapture = true,
	hasLicense = true,
	canDiplomacy = true,
	CantUseDisguise = true,
	disableDisguise = true,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	armor = 250,
	loyalty = 4,
	max = 1,
	CanStartLockdown = true,
})

-- Grid
TEAM_PILOTGRID = rp.addTeam("C"..map..".MPF.GRID.OfC", {
	color = grid_color,
	model = {'models/hlvr/characters/combine/grunt/combine_beta_grunt_hlvr_player.mdl'},
	description = [[
Metropolis Police Force.GRID.Officer

Офицер (OfC) инженерного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Управление наземным транспортом Альянса;
- Формирование и управление группой из RCT/05/03/01;
- Слежение за работой юнитов основного наземного подразделения;
- Премирование и повышение юнитов основного наземного подразделения;
- Участие в Зачистке;

Особенности:
- Выдача премии сотрудникам ГО;
- Покупка АПК;
- Покупка раздатчика Здоровья;
- Покупка раздатчика Брони;
- Покупка Аптечек;
- Покупка Брони;

Подчиняется: 
Гражданская Оборона: DvL и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Высокая;
]],
	weapons = {"door_ram", "weapon_taser","swb_ar2","swb_shotgun","weapon_frag","swb_pistol","weapon_cuff_elastic", "weapon_simrepair"},
	spawns = mpf_spawns,
	salary = 35,
	command = 'ofcgrid',
	faction = FACTION_GRID,
	forceLimit = true,
	rationCount = 6,
	stamina = 3,
	reversed = true,
	hasLicense = true,
	randomName = true,
	canCapture = true,
	CantUseDisguise = true,
	disableDisguise = true,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('ofcgrid', ply) end,
	armor = 150,
	loyalty = 3,
	max = 1,
	appearance =
	{
        {mdl = {
	'models/hlvr/characters/combine/grunt/combine_beta_grunt_hlvr_player.mdl',
		},
          skins       = {0},
           bodygroups = {
           		[1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {1},
                [9] = {1},
                [10] = {1},
                [11] = {1},
                [12] = {1},
            			}
        },
    },
})

--Helix 
TEAM_HELIX03 = rp.addTeam("C"..map..".MPF.Helix.03", {
	color = helix_color,
	model = {'models/rrp/metropolice/pm/hmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Helix.03

Сержант (03) медицинского подразделения Гражданской Обороны.

Прямые обязанности:
- Оказание медицинской помощи всем юнитам MpF и б.е. OTA;
- Патрулирование в составе группы из 3 и более юнитов из другого дивизиона;

Запрещается:
- Проводить допросы;
- Участвовать в Зачистке;

Особенности:
- Покупка Аптечек;

Подчиняется: 
Гражданская Оборона: Helix.OfC, DvL и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Тюрьма и допросная Разрешен;
Тюремный холл и чипировальня Разрешен;
Холл Нексус Надзора Разрешен;
Крыло А Разрешен;
Крыло B Разрешен;
Крыло С Разрешен;
Кабинет Администратора Города Запрещен;

Лояльность Альянса: Средняя;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser","swb_pistol","swb_smg","weapon_frag","weapon_cuff_elastic", "weapon_medkit"},
	spawns = mpf_spawns,
	salary = 20,
	command = 'helix03',
	faction = FACTION_HELIX,
	unlockTime = 5 * 3600,
	unlockPrice = 2500,
	rationCount = 4,
	hasLicense = true,
	stamina = 2,
	medic = true,
	IsMedic = true,	
	RescueReward = 30,
	DmHealTime = 5,
	RescueFactions = {[FACTION_MPF] = true, [FACTION_HELIX] = true, [FACTION_OTA] = true, [FACTION_CMD] = true, [FACTION_GRID] = true},
	reversed = true,
	randomName = true,
	CantUseDisguise = true,
	disableDisguise = true,
	armor = 75,
	loyalty = 2,
	max = 4,
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/hmetropolicepm.mdl'},
          skins       = {2},
        },
    },
})

TEAM_OFCHELIX = rp.addTeam("C"..map..".MPF.Helix.OfC", {
	color = helix_color,
	model = {'models/rrp/metropolice/pm/hofcmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Helix.Officer

Офицер (OfC) медицинского подразделения Гражданской Обороны.

Прямые обязанности:
- Формирование и управление группой из RCT/05/03/01;
- Оказание медицинской помощи всем юнитам MpF и б.е. OTA;
- Слежение за работой юнитов основного наземного подразделения;
- Премирование и повышение юнитов основного наземного подразделения;
- Участие в Зачистке;

Особенности:
- Выдавача премии сотрудникам Helix;
- Покупка раздатчика Здоровья;
- Покупка Аптечек;

Подчиняется: 
Гражданская Оборона: DvL и выше;
Сверхчеловеческий Отдел: OTA.СMD.Marshal;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Высокая;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser", "swb_ar2","swb_shotgun","weapon_frag","swb_pistol","weapon_cuff_elastic", "weapon_medkit"},
	spawns = mpf_spawns,
	salary = 35,
	command = 'ofchelix',
	faction = FACTION_HELIX,
	unlockTime = 30 * 3600,
	unlockPrice = 9000,
	rationCount = 6,
	stamina = 2,
	reversed = true,
	medic = true,
	IsMedic = true,	
	RescueReward = 40,
	RescueFactions = {[FACTION_MPF] = true, [FACTION_HELIX] = true, [FACTION_OTA] = true, [FACTION_CMD] = true, [FACTION_GRID] = true},
	hasLicense = true,
	randomName = true,
	canCapture = true,
	DmHealTime = 5,
	CantUseDisguise = true,
	disableDisguise = true,
	armor = 125,
	forceLimit = true,
	loyalty = 3,
	max = 2,
})

TEAM_DISPATCH = rp.addTeam("C"..map..".MPF.CMD.Dispatcher", {
	color = cmd_color,
	model = {'models/rrp/metropolice/pm/cmdmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Commander.Dispatcher

Диспетчер всех наземных подразделений Гражданской Обороны и Сверхчеловеческого Отдела.

Прямые обязанности:
- Контроль всех наземных юнитов и боевых единиц;
- Выдача улучшенного снаряжения;
- Премирование и повышение юнитов всех наземных подразделений;
- Вывод OTA из стазиса;

Особенности:
- Понижать в должности/выдавать премии сотрудникам ГО;
- Регулирование положения в городе;

Запрещается:
- Покидать Нексус Надзор и его территорию;

Подчиняется:
Гражданская Оборона: SeC;
Сверхчеловеческий Отдел: OTA.KING.Overlord и OTA.СMD.Marshal;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"door_ram", "weapon_taser","swb_smg","swb_shotgun","weapon_frag","swb_357","weapon_cuff_elastic"},
	spawns = cmd_spawn,
	salary = 55,
	command = 'dispatch',
	max = 1,
	armor = 250,
	faction = FACTION_CMD,
	rationCount = 8,
	rationCount = 250 * 3600,
	CanStartLockdown = true,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	stamina = 2,
	noHunger = true, 
	reversed = true,
	canDiplomacy = true,
	CantDeathmechanics = true,
	hasLicense = true,
	randomName = true,
	CantUseDisguise = true,
	disableDisguise = true,
	loyalty = 4,
})

TEAM_SEC = rp.addTeam("C"..map..".MPF.CMD.SeC", {
	color = cmd_color,
	model = {'models/rrp/metropolice/pm/secmetropolicepm.mdl'},
	description = [[
Metropolis Police Force.Commander.Sectorial Commander

Командующий Сектором (SeC) основного наземного подразделения Гражданской Обороны.

Прямые обязанности:
- Осуществление командования всеми наземным подразделением Гражданской Обороны;
- Осуществление командования сверхчеловеческим отделом, в случае отсутствия Overlord'а в секторе;
- Премирование и повышение юнитов основного наземного подразделения;
- Изменения кода положения города, согласно регламенту;
- Надзор за работой Администратора Города;
- Инициирование Зачисток;
- Вывод OTA из стазиса;

Особенности:
- Понижать в должности/выдавать премии сотрудникам ГО;
- Регулирование положения в городе;

В подчинении у OTA.СMD.Marshal;

Командует всеми силами Гражданской Обороны, а также Администратором Города;

Доступы Секторов:
D1 - D5 Разрешен;
D6 Разрешен;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"police_stunstick", "door_ram", "weapon_taser", "swb_ar3", "swb_shotgun", "weapon_frag","swb_357","weapon_cuff_elastic"},
	spawns = cmd_spawn,
	salary = 70,
	command = 'sec',
	faction = FACTION_CMD,
	unlockTime = 350 * 3600,
	rationCount = 9,
	stamina = 2,
	reversed = true,
	randomName = true,
	CanStartLockdown = true,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	canCapture = true,
	canDiplomacy = true,
	hasLicense = true,
	CantUseDisguise = true,
	disableDisguise = true,
	CantDeathmechanics = true,
	armor = 300,
	loyalty = 4,
	max = 1,
})

TEAM_MAR = rp.addTeam("C"..map..".OTA.CMD.Marshal", {
	color = cmd_color,
	model = {"models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl"},
	description = [[
Overwatch Transhuman Arm.Commander.Marshal
Маршал Альянса.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Командование всеми отделами Альянса;
- Премирование и повышение юнитов;
- Изменения кода положения города, согласно регламенту;
- Надзор за работой Администратора Города;
- Вывод OTA из стазиса;

Запрещается:
- Покидать Нексус Надзор и его территорию;

Особенности:
- Увольнять/понижать в должности/выдавать премии сотрудникам Альянса;
- Регулирование положения в городе;
- Покупка Аптечек;
- Покупка Брони;

Командует всеми силами Альянса, а также Администратором Города;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"swb_ar3", "swb_shotgun", "swb_357", "weapon_frag", "door_ram", "weapon_taser","weapon_cuff_elastic", "weapon_rpg"},
	command = "mar",
	spawns = cmd_spawn,
	salary = 115,
	noHunger = true,
	stamina = 9999,
	max = 1,
	CanStartLockdown = true,
	armor = 500,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetMaxHealth(250) end,
	faction = FACTION_CMD,
	rationCount = 10,
	forceLimit = true,
	unlockTime = 700 * 3600,
	noHunger = true,
	reversed = true,
	hasLicense = true,
	canDiplomacy = true,
	randomName = true,
	CantUseDisguise = true,
	noReProgrammer = true,
	CantDeathmechanics = true,
	unlockPrice = 350000,
	loyalty = 4,
	appearance = {
        {
        	mdl = "models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl",
        	skins       = {2},
        	bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
                [12] = {0},
                [13] = {0},
                [14] = {0},
            }
        },
    },	
})

--Радио
rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_GRID, FACTION_CMD}))

-- Двери
rp.AddDoorGroup('Альянс', rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}, {TEAM_SEC, TEAM_MAYOR1}))
rp.AddDoorGroup('ГСР', rp.GetFactionTeams({FACTION_CWU, FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}))

--Понижение
/*rp.AddRepress({TEAM_MAR, TEAM_SEC, TEAM_DISPATCH, TEAM_DVL}, {FACTION_CITIZEN, FACTION_CWU, FACTION_MPF, FACTION_OTA, FACTION_HELIX})*/

--MpF
rp.AddRelationships(TEAM_MAR, RANK_LEADER, {FACTION_MPF, FACTION_HELIX, FACTION_CMD, FACTION_GRID, FACTION_OTA})
rp.AddRelationships(TEAM_SEC, RANK_OFFICER, {FACTION_MPF, FACTION_HELIX, FACTION_CMD, FACTION_GRID})
rp.AddRelationships(TEAM_DISPATCH, RANK_OFFICER, {FACTION_MPF, FACTION_HELIX, FACTION_GRID})
rp.AddRelationships(TEAM_DVL, RANK_OFFICER, {FACTION_MPF, FACTION_HELIX, FACTION_GRID})
rp.AddRelationships(TEAM_PILOTGRID, RANK_TRAINER, {FACTION_MPF})
rp.AddRelationships(TEAM_OFC, RANK_TRAINER, {FACTION_MPF})

--Helix
rp.AddRelationships(TEAM_OFCHELIX, RANK_TRAINER, {FACTION_HELIX})

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID})))

rp.SetFactionVoices({FACTION_MPF, FACTION_HELIX, FACTION_GRID}, {
            {
				label = 'Гражданин',
				sound = 'npc/metropolice/vo/citizen.wav',
				text = 'Гражданин.'
			},
			{
				label = 'Антигражданин',
				sound = 'npc/metropolice/vo/anticitizen.wav',
				text = 'Антигражданин.'
			},
			{
				label = 'Назовись',
				sound = 'npc/metropolice/vo/apply.wav',
				text = 'Назовись.'
			},
			{
				label = 'Принято',
				sound = 'npc/metropolice/vo/affirmative2.wav',
				text = 'Утверждать.'
			},
			{
				label = 'Первое предупреждение',
				sound = 'npc/metropolice/vo/firstwarningmove.wav',
				text = 'Первое предупреждение.'
			},
			{
				label = 'Второе предупреждение',
				sound = 'npc/metropolice/vo/thisisyoursecondwarning.wav',
				text = 'Второе предупреждение.'
			},
			{
				label = 'Последнее предупреждение!',
				sound = 'npc/metropolice/vo/finalwarning.wav',
				text = 'Последнее предупреждение!'
			},
			{
				label = 'Стой',
				sound = 'npc/metropolice/vo/holditrightthere.wav',
				text = 'Стой где стоишь.'
			},
			{
				label = 'Ампутировать',
				sound = 'npc/metropolice/vo/amputate.wav',
				text = 'Ампутировать.'
			},
			{
				label = 'Неподчинение',
				sound = 'npc/metropolice/vo/malcompliant10107my1020.wav',
				text = 'Неподчинение 10-1-07. 10-20 пресекаю!'
			},
			{
				label = 'Неповиновение',
				sound = 'npc/metropolice/vo/issuingmalcompliantcitation.wav',
				text = 'Выдаю предписание о неповиновении!'
			},
			{
				label = 'Вынесение приговора',
				sound = 'npc/metropolice/vo/prepareforjudgement.wav',
				text = 'Подозреваемый, приготовтесь к вынесению приговора.'
			},
			{
				label = 'Приговор выполнен',
				sound = 'npc/metropolice/vo/finalverdictadministered.wav',
				text = 'Приговор приведен в исполнение.'
			},
			{
				label = 'Угроза офицеру',
				sound = 'npc/metropolice/vo/dispatchineed10-78.wav',
				text = 'База 10-7. Офицер под угрозой!'
			},
			{
				label = 'Убит',
				sound = 'npc/metropolice/vo/expired.wav',
				text = 'Убит!'
			},
			{
				label = 'Подходит',
				sound = 'npc/metropolice/vo/matchonapblikeness.wav',
				text = 'Объект подходит по ориентировки.'
			},
			{
				label = 'Помочь?',
				sound = 'npc/metropolice/vo/needanyhelpwiththisone.wav',
				text = 'Помощь нужна?'
			},
			{
				label = 'Убирайся',
				sound = 'npc/metropolice/vo/nowgetoutofhere.wav',
				text = 'А теперь убирайся!'
			},
			{
				label = 'Сломать укрытие',
				sound = 'npc/metropolice/vo/breakhiscover.wav',
				text = 'Сломать его укрытие!'
			},
			{
				label = 'Ха-ха',
				sound = 'npc/metropolice/vo/chuckle.wav',
				text = 'Ха-ха.'
			},
			{
				label = 'Блок управления',
				sound = 'npc/metropolice/vo/controlsection.wav',
				text = 'Блок управления.'
			},
			{
				label = 'Принято!',
				sound = 'npc/metropolice/vo/copy.wav',
				text = 'Принято!'
			},
			{
				label = 'Разрушьте укрытие!',
				sound = 'npc/metropolice/vo/destroythatcover.wav',
				text = 'Разрушьте укрытие!',
			},
			{
				label = 'Изучить',
				sound = 'npc/metropolice/vo/examine.wav',
				text = 'Изучить.'
			},
			{
				label = 'Ложись!',
				sound = 'npc/metropolice/vo/getdown.wav',
				text = 'Ложись!'
			},
			{
				label = 'Убирайся отсюда',
				sound = 'npc/metropolice/vo/getoutofhere.wav',
				text = 'Убирайся отсюда.'
			},
			{
				label = 'Граната!',
				sound = 'npc/metropolice/vo/grenade.wav',
				text = 'Граната!'
			},
			{
				label = 'Все чисто',
				sound = 'npc/metropolice/vo/clearandcode100.wav',
				text = 'Все чисто. Код 100'
			},
			{
				label = 'Помогите!',
				sound = 'npc/metropolice/vo/help.wav',
				text = 'Помогите!'
			},
			{
				label = 'Он убегает',
				sound = 'npc/metropolice/vo/hesrunning.wav',
				text = 'Он убегает!'
			},
			{
				label = 'Он там',
				sound = 'npc/metropolice/vo/hesupthere.wav',
				text = 'Он там.'
			},
			{
				label = 'На позиции',
				sound = 'npc/metropolice/vo/inposition.wav',
				text = 'На позиции.'
			},
			{
				label = 'Расследовать',
				sound = 'npc/metropolice/vo/investigate.wav',
				text = 'Расследовать.'
			},
			{
				label = 'Изолировать',
				sound = 'npc/metropolice/vo/isolate.wav',
				text = 'Изолировать.'
			},
			{
				label = 'Проходи',
				sound = 'npc/metropolice/vo/keepmoving.wav',
				text = 'Давай, проходи!'
			},
			{
				label = 'Осторжнее',
				sound = 'npc/metropolice/vo/lookout.wav',
				text = 'Осторжнее!',
			},
			{
				label = 'Двигайся',
				sound = 'npc/metropolice/vo/move.wav',
				text = 'Двигайся.'
			},
			{
				label = 'Отошёл!',
				sound = 'npc/metropolice/vo/movebackrightnow.wav',
				text = 'Отошёл, немедленно!'
			},
			{
				label = 'Отошёл 2',
				sound = 'npc/metropolice/vo/isaidmovealong.wav',
				text = 'Я сказал отойти!'
			},
			{
				label = 'Патруль',
				sound = 'npc/metropolice/vo/patrol.wav',
				text = 'Патруль.'
			},
			{
				label = 'Преследуем',
				sound = 'npc/metropolice/vo/prosecute.wav',
				text = 'Преследуем.'
			},
			{
				label = 'Ограничить',
				sound = 'npc/metropolice/vo/restrict.wav',
				text = 'Ограничить.'
			},
			{
				label = 'Искать',
				sound = 'npc/metropolice/vo/search.wav',
				text = 'Искать.'
			},
			{
				label = 'Выполнить',
				sound = 'npc/metropolice/vo/serve.wav',
				text = 'Выполнить.'
			},
			{
				label = 'Дерьмо!',
				sound = 'npc/metropolice/vo/shit.wav',
				text = 'Дерьмо!'
			},
			{
				label = 'Стерилизовать',
				sound = 'npc/metropolice/vo/sterilize.wav',
				text = 'Стерилизовать.'
			},
			{
				label = 'В укрытие',
				sound = 'npc/metropolice/vo/takecover.wav',
				text = 'В укрутие!'
			},
			{
				label = 'Проблема?',
				sound = 'npc/metropolice/vo/lookingfortrouble.wav',
				text = 'Ищешь неприятности?'
			},
			{
				label = 'Рег.смерть',
				sound = 'npc/metropolice/vo/classifyasdbthisblockready.wav',
				text = 'Зарегистрирована смерть. Квартал готов к зачистке.'
			},
			{
				label = 'Следите за ним',
				sound = 'npc/metropolice/vo/watchit.wav',
				text = 'Следите за ним.'
			},
			{
				label = 'Банка 1',
				sound = 'npc/metropolice/vo/pickupthecan1.wav',
				text = 'Подними эту банку!'
			},
			{
				label = 'Банка 2',
				sound = 'npc/metropolice/vo/pickupthecan2.wav',
				text = 'Подними банку!'
			},
			{
				label = 'Банка 3',
				sound = 'npc/metropolice/vo/pickupthecan3.wav',
				text = 'Я сказал, подними банку!'
			},
			{
				label = 'Банка 4',
				sound = 'npc/metropolice/vo/putitinthetrash1.wav',
				text = 'А теперь положи ее в мусорку!'
			},
			{
				label = 'Банка 5',
				sound = 'npc/metropolice/vo/putitinthetrash2.wav',
				text = 'Я сказал, положи ее в мусорку!'
			},
})

rp.SetTeamVoices(TEAM_DISPATCH, {
	{
		label = 'Сообщники',
		sound = 'npc/overwatch/radiovoice/accomplicesoperating.wav', 
		text = 'Внимание отрядам ГО, в районе сообщники'
	},
	{
		label = 'Вперед',
		sound = 'npc/overwatch/radiovoice/allunitsapplyforwardpressure.wav', 
		text = 'Всем силам выдвинуться вперед'
	},
	{
		label = 'Стерилизовать',
		sound = 'npc/overwatch/radiovoice/allunitsbeginwhitnesssterilization.wav', 
		text = 'Внимание! Начать стерилизацию свидетелей' 
	},
	{
		label = 'Казнь',
		sound = 'npc/overwatch/radiovoice/allunitsdeliverterminalverdict.wav', 
		text = 'Всем немедленно осуществить смертную казнь'
	},
	{
		label = 'Нападение на ГО',
		sound = 'npc/overwatch/radiovoice/assault243.wav', 
		text = '2-4-3 Нападение на силы ГО'
	},
	{
		label = 'Нарушение',
		sound = 'npc/overwatch/radiovoice/attemptedcrime27.wav', 
		text = '2-7 Попытка нарушения'
	},
	{
		label = 'Вы обвиняетесь',
		sound = 'npc/overwatch/radiovoice/attentionyouhavebeenchargedwith.wav', 
		text = 'Внимание, вы обвиняетесь'
	},
	{
		label = 'Приговор по усмотрению',
		sound = 'npc/overwatch/radiovoice/completesentencingatwill.wav', 
		text = 'Всем силам ГО, исполнять приговор по усмотрению'
	},
	{
		label = 'АО поведение',
		sound = 'npc/overwatch/radiovoice/devisivesociocidal.wav', 
		text = 'Сознательное антиобщественное поведение'
	},
	{
		label = 'Душевно больной',
		sound = 'npc/overwatch/radiovoice/disturbancemental10-103m.wav', 
		text = '10-103 Душевно больной нарушитель'
	},
	{
		label = 'Проверить',
		sound = 'npc/overwatch/radiovoice/examine.wav', 
		text = 'Проверить'
	},
	{
		label = 'Неповиновение',
		sound = 'npc/overwatch/radiovoice/failuretocomply.wav', 
		text = 'Неповиновение воле общества'
	},
	{
		label = 'Исполнено',
		sound = 'npc/overwatch/radiovoice/finalverdictadministered.wav', 
		text = 'Окончательный приговор исполнен'
	},
	{
		label = 'Стерилизовать',
		sound = 'npc/overwatch/radiovoice/sterilize.wav', 
		text = 'Стерилизовать'
	},
	{
		label = 'Ампутировать',
		sound = 'npc/overwatch/radiovoice/immediateamputation.wav', 
		text = 'Немедленное отсечение'
	},
	{
		label = 'Предотвратить',
		sound = 'npc/overwatch/radiovoice/innoculate.wav', 
		text = 'Предотвратить'
	},
	{
		label = 'Вмешаться',
		sound = 'npc/overwatch/radiovoice/intercede.wav', 
		text = 'Вмешаться'
	},
	{
		label = 'Расследовать',
		sound = 'npc/overwatch/radiovoice/investigateandreport.wav', 
		text = 'Расследовать и доложить'
	},
	{
		label = 'Отчет о стерилизованных',
		sound = 'npc/overwatch/radiovoice/leadersreportratios.wav', 
		text = 'Внимание лидерам команд стабилизации, докладывать о количестве стерилизованных. Последует награда или наказание.'
	},
	{
		label = 'Держать позицию',
		sound = 'npc/overwatch/radiovoice/lockdownlocationsacrificecode.wav', 
		text = 'Отряд ГО, держать позицию. Код самопожертвования.'
	},
	{
		label = 'Виновный отряд',
		sound = 'npc/overwatch/radiovoice/youarejudgedguilty.wav', 
		text = 'Вы признаны виновным отрядом ГО'
	},
	{
		label = 'Не гражданин',
		sound = 'npc/overwatch/radiovoice/noncitizen.wav', 
		text = 'Не гражданин'
	},
	{
		label = 'Патруль',
		sound = 'npc/overwatch/radiovoice/patrol.wav', 
		text = 'Патруль'
	},
	{
		label = 'Выселение',
		sound = 'npc/overwatch/radiovoice/permanentoffworld.wav', 
		text = 'Выселение в нежилое пространство'
	},
	{
		label = 'Готовься к наказанию',
		sound = 'npc/overwatch/radiovoice/preparetoreceiveverdict.wav', 
		text = 'Приготовься принять наказание'
	},
	{
		label = 'Халатность',
		sound = 'npc/overwatch/radiovoice/recklessoperation99.wav', 
		text = '99 Халатность'
	},
	{
		label = 'Доложите',
		sound = 'npc/overwatch/radiovoice/reportplease.wav', 
		text = 'Доложите'
	},
	{
		label = 'Угроза обществу',
		sound = 'npc/overwatch/radiovoice/sociocide.wav', 
		text = 'Угроза обществу'
	},
	{
		label = 'Набор рабсилы',
		sound = 'npc/overwatch/radiovoice/workforceintake.wav', 
		text = 'Набор рабочей силы'
	},
	{
		label = 'Виктор',
		sound = 'npc/overwatch/radiovoice/victor.wav', 
		text = 'Виктор'
	},
	{
		label = 'Vice',
		sound = 'npc/overwatch/radiovoice/vice.wav', 
		text = 'Vice'
	},
	{
		label = 'Код беспорядок',
		sound = 'npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav', 
		text = 'Граждане, введен код действия при беспорядках. Код: обезвредить, защитить, усмирить. Код: подавить, меч, стерилизовать.', 
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Отказ в сотруднечестве',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav', 
		text = 'Граждане, отказ в сотрудничестве будет наказан выселением в нежилое пространство.',
		broadcast = true,
		soundDuration = 15 
	},
	{
		label = 'Отклонение в численности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/f_trainstation_cooperation_spkr.wav', 
		text = 'Вниманию жителей! Замечено отклонение численности. Сотрудничество с отрядом ГО награждается полным пищевым рационом.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Идентификация',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav', 
		text = 'Вниманию гражданам! Производится проверка идентификации. Займите назначенные для инспекции места.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Угроза 1 уровня',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav', 
		text = 'Гражданин, Вы угроза обществу первого уровня. Подразделениям ГО, код пресечения: долг, меч, полночь.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Недоносительство',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav', 
		text = 'Вниманию жителей! Ваш квартал обвиняется в недоносительстве. Штраф - пять пищевых единиц.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Красный Код',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav', 
		text = 'Вниманию всех наземных сил: судебное разбирательство отменено. Смертная казнь - по усмотрению.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Уклонение от надзора',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav', 
		text = 'Вниманию отряда гражданской обороны, обнаружено уклонение от надзора. Отреагировать, изолировать, допросить.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Беспорядки',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_localunrest_spkr.wav', 
		text = 'Тревога! Подразделениям гражданской обороны, обнаружены локальные беспорядки. Собрать, исполнить, усмирить.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Бездействие преступно',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav', 
		text = 'Граждане: бездействие преступно. О противоправном поведении немедленно доложить силам ГО.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Неопознанное лицо',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav', 
		text = 'Внимание! Неопознанное лицо. Немедленно подтвердить статус в отделе гражданской обороны.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Множественно нарушение',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav', 
		text = 'Гражданин, вы обвиняетесь во множественных нарушениях. Гражданство отозвано. Статус: злостный нарушитель.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Угроза 5 уровня',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_ceaseevasionlevelfive_spkr.wav', 
		text = 'Гражданин, теперь Вы угроза обществу пятого уровня. Немедленно прекратить уклонение и выслушать приговор.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Нелегальное оружие',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fcitadel_confiscating.wav', 
		text = 'Тревога безопасности: обнаружено незарегистрированное оружие. Конфискационное поле включено.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Антиобщественная деятельность',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav', 
		text = 'Отряду гражданской обороны: признаки антиобщественной деятельности. Код: собрать, окружить, задержать.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Нарушение 2 уровня',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav', 
		text = 'Гражданин, Вы обвиняетесь в несоответствии второго уровня и антиобщественной деятельности первого уровня. Силам ГО, обвинительный код: долг, меч, выполнять.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Код изолировать',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav', 
		text = 'Вниманию отряда гражданской обороны, обнаружено уклонение от надзора. Отреагировать, изолировать, допросить.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Отключены ограничители периметра',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_restrictorsdisengaged.wav', 
		text = 'Приоритетное предупреждение: ограничители периметра отключены. Всем участникам стабилизации немедленно выдвинуться в месте вторжения.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Аномальная активность',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_nonstandardexogen.wav', 
		text = 'Тревога, обнаружена аномальна внешняя активность, следовать процедуре сдерживания и докладывать.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Код:Пожертвовать,остановить,устронить',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_missionfailurereminder.wav', 
		text = 'Внимание наземным частям: провал миссии влечёт за собой выселение в нежилое пространство. Напоминаю код: жертва, коагуляция, зажим.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Вирусный интерфейс',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_interfacebypass.wav', 
		text = 'Внимание,обнаружено подключение вирусного интерфейса, стабилизаторы и поля сдерживания в опасности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Угроза вторжения',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_freemanlocated.wav', 
		text = 'Внимание, обнаружен злокачественный взлом интерфейса. Обнаружено перепрограммирование полифазного ядра. Стерилизаторы и заграждающие поля могут оказаться под угрозой.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Доложите о вторжении',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_detectionsystemsout.wav', 
		text = 'Внимание, системы наблюдения и обнаружения неактивны. Оставшимся членам стабилизационного отряда сообщить статус сдерживания.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Директива 2',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fprison_containexogens.wav', 
		text = 'Директива номер два, задействовать резерв, сдерживать вторжение из вне.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Последовательность сингуляностей',
		color = Color(220, 20, 60),
		sound = 'npc/overwatch/cityvoice/fcitadel_transportsequence.wav', 
		text = 'Внимание. Последовательная блокировка сингулярного перемещения приведена в действие.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '3 минуты до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_3minutestosingularity.wav', 
		text = 'Внимание: три минуты до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '2 минуты до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_2minutestosingularity.wav', 
		text = 'Внимание: две минуты до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '1 минуты до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_1minutetosingularity.wav', 
		text = 'Внимание: одна минута до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '45 секунд до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_45sectosingularity.wav', 
		text = 'Приоритетное внимание: сорок пять секунд до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '30 секунд до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_30sectosingularity.wav', 
		text = 'Приоритетное внимание: тридцать секунд до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '15 секунд до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_15sectosingularity.wav', 
		text = 'Приоритетное внимание: пятнадцать секунд до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = '10 секунд до сингулярности',
		color = Color(0, 0, 205),
		sound = 'npc/overwatch/cityvoice/fcitadel_10sectosingularity.wav', 
		text = 'Приоритетное внимание: десять секунд до сингулярности.',
		broadcast = true,
		soundDuration = 15
	},
 })

rp.SetTeamVoices(TEAM_SEC, {
	{
				label = 'Гражданин',
				sound = 'npc/metropolice/vo/citizen.wav',
				text = 'Гражданин.'
			},
			{
				label = 'Антигражданин',
				sound = 'npc/metropolice/vo/anticitizen.wav',
				text = 'Антигражданин.'
			},
			{
				label = 'Назовись',
				sound = 'npc/metropolice/vo/apply.wav',
				text = 'Назовись.'
			},
			{
				label = 'Принято',
				sound = 'npc/metropolice/vo/affirmative2.wav',
				text = 'Утверждать.'
			},
			{
				label = 'Первое предупреждение',
				sound = 'npc/metropolice/vo/firstwarningmove.wav',
				text = 'Первое предупреждение.'
			},
			{
				label = 'Второе предупреждение',
				sound = 'npc/metropolice/vo/thisisyoursecondwarning.wav',
				text = 'Второе предупреждение.'
			},
			{
				label = 'Последнее предупреждение!',
				sound = 'npc/metropolice/vo/finalwarning.wav',
				text = 'Последнее предупреждение!'
			},
			{
				label = 'Стой',
				sound = 'npc/metropolice/vo/holditrightthere.wav',
				text = 'Стой где стоишь.'
			},
			{
				label = 'Ампутировать',
				sound = 'npc/metropolice/vo/amputate.wav',
				text = 'Ампутировать.'
			},
			{
				label = 'Неподчинение',
				sound = 'npc/metropolice/vo/malcompliant10107my1020.wav',
				text = 'Неподчинение 10-1-07. 10-20 пресекаю!'
			},
			{
				label = 'Неповиновение',
				sound = 'npc/metropolice/vo/issuingmalcompliantcitation.wav',
				text = 'Выдаю предписание о неповиновении!'
			},
			{
				label = 'Вынесение приговора',
				sound = 'npc/metropolice/vo/prepareforjudgement.wav',
				text = 'Подозреваемый, приготовтесь к вынесению приговора.'
			},
			{
				label = 'Приговор выполнен',
				sound = 'npc/metropolice/vo/finalverdictadministered.wav',
				text = 'Приговор приведен в исполнение.'
			},
			{
				label = 'Угроза офицеру',
				sound = 'npc/metropolice/vo/dispatchineed10-78.wav',
				text = 'База 10-7. Офицер под угрозой!'
			},
			{
				label = 'Убит',
				sound = 'npc/metropolice/vo/expired.wav',
				text = 'Убит!'
			},
			{
				label = 'Подходит',
				sound = 'npc/metropolice/vo/matchonapblikeness.wav',
				text = 'Объект подходит по ориентировки.'
			},
			{
				label = 'Помочь?',
				sound = 'npc/metropolice/vo/needanyhelpwiththisone.wav',
				text = 'Помощь нужна?'
			},
			{
				label = 'Убирайся',
				sound = 'npc/metropolice/vo/nowgetoutofhere.wav',
				text = 'А теперь убирайся!'
			},
			{
				label = 'Сломать укрытие',
				sound = 'npc/metropolice/vo/breakhiscover.wav',
				text = 'Сломать его укрытие!'
			},
			{
				label = 'Ха-ха',
				sound = 'npc/metropolice/vo/chuckle.wav',
				text = 'Ха-ха.'
			},
			{
				label = 'Блок управления',
				sound = 'npc/metropolice/vo/controlsection.wav',
				text = 'Блок управления.'
			},
			{
				label = 'Принято!',
				sound = 'npc/metropolice/vo/copy.wav',
				text = 'Принято!'
			},
			{
				label = 'Разрушьте укрытие!',
				sound = 'npc/metropolice/vo/destroythatcover.wav',
				text = 'Разрушьте укрытие!',
			},
			{
				label = 'Изучить',
				sound = 'npc/metropolice/vo/examine.wav',
				text = 'Изучить.'
			},
			{
				label = 'Ложись!',
				sound = 'npc/metropolice/vo/getdown.wav',
				text = 'Ложись!'
			},
			{
				label = 'Убирайся отсюда',
				sound = 'npc/metropolice/vo/getoutofhere.wav',
				text = 'Убирайся отсюда.'
			},
			{
				label = 'Граната!',
				sound = 'npc/metropolice/vo/grenade.wav',
				text = 'Граната!'
			},
			{
				label = 'Все чисто',
				sound = 'npc/metropolice/vo/clearandcode100.wav',
				text = 'Все чисто. Код 100'
			},
			{
				label = 'Помогите!',
				sound = 'npc/metropolice/vo/help.wav',
				text = 'Помогите!'
			},
			{
				label = 'Он убегает',
				sound = 'npc/metropolice/vo/hesrunning.wav',
				text = 'Он убегает!'
			},
			{
				label = 'Он там',
				sound = 'npc/metropolice/vo/hesupthere.wav',
				text = 'Он там.'
			},
			{
				label = 'На позиции',
				sound = 'npc/metropolice/vo/inposition.wav',
				text = 'На позиции.'
			},
			{
				label = 'Расследовать',
				sound = 'npc/metropolice/vo/investigate.wav',
				text = 'Расследовать.'
			},
			{
				label = 'Изолировать',
				sound = 'npc/metropolice/vo/isolate.wav',
				text = 'Изолировать.'
			},
			{
				label = 'Проходи',
				sound = 'npc/metropolice/vo/keepmoving.wav',
				text = 'Давай, проходи!'
			},
			{
				label = 'Осторжнее',
				sound = 'npc/metropolice/vo/lookout.wav',
				text = 'Осторжнее!',
			},
			{
				label = 'Двигайся',
				sound = 'npc/metropolice/vo/move.wav',
				text = 'Двигайся.'
			},
			{
				label = 'Отошёл!',
				sound = 'npc/metropolice/vo/movebackrightnow.wav',
				text = 'Отошёл, немедленно!'
			},
			{
				label = 'Отошёл 2',
				sound = 'npc/metropolice/vo/isaidmovealong.wav',
				text = 'Я сказал отойти!'
			},
			{
				label = 'Патруль',
				sound = 'npc/metropolice/vo/patrol.wav',
				text = 'Патруль.'
			},
			{
				label = 'Преследуем',
				sound = 'npc/metropolice/vo/prosecute.wav',
				text = 'Преследуем.'
			},
			{
				label = 'Ограничить',
				sound = 'npc/metropolice/vo/restrict.wav',
				text = 'Ограничить.'
			},
			{
				label = 'Искать',
				sound = 'npc/metropolice/vo/search.wav',
				text = 'Искать.'
			},
			{
				label = 'Выполнить',
				sound = 'npc/metropolice/vo/serve.wav',
				text = 'Выполнить.'
			},
			{
				label = 'Дерьмо!',
				sound = 'npc/metropolice/vo/shit.wav',
				text = 'Дерьмо!'
			},
			{
				label = 'Стерилизовать',
				sound = 'npc/metropolice/vo/sterilize.wav',
				text = 'Стерилизовать.'
			},
			{
				label = 'В укрытие',
				sound = 'npc/metropolice/vo/takecover.wav',
				text = 'В укрутие!'
			},
			{
				label = 'Проблема?',
				sound = 'npc/metropolice/vo/lookingfortrouble.wav',
				text = 'Ищешь неприятности?'
			},
			{
				label = 'Рег.смерть',
				sound = 'npc/metropolice/vo/classifyasdbthisblockready.wav',
				text = 'Зарегистрирована смерть. Квартал готов к зачистке.'
			},
			{
				label = 'Следите за ним',
				sound = 'npc/metropolice/vo/watchit.wav',
				text = 'Следите за ним.'
			},
			{
				label = 'Банка 1',
				sound = 'npc/metropolice/vo/pickupthecan1.wav',
				text = 'Подними эту банку!'
			},
			{
				label = 'Банка 2',
				sound = 'npc/metropolice/vo/pickupthecan2.wav',
				text = 'Подними банку!'
			},
			{
				label = 'Банка 3',
				sound = 'npc/metropolice/vo/pickupthecan3.wav',
				text = 'Я сказал, подними банку!'
			},
			{
				label = 'Банка 4',
				sound = 'npc/metropolice/vo/putitinthetrash1.wav',
				text = 'А теперь положи ее в мусорку!'
			},
			{
				label = 'Банка 5',
				sound = 'npc/metropolice/vo/putitinthetrash2.wav',
				text = 'Я сказал, положи ее в мусорку!'
			},
 })

rp.SetTeamVoices(TEAM_MAR, {
            {
				label = 'Бунтарь', 
				sound = 'npc/combine_soldier/vo/boomer.wav',
				text = 'Бунтарь!'
			},
			{
				label = 'Чисто', 
				sound = 'npc/combine_soldier/vo/cleaned.wav',
				text = 'Чисто!'
			},
			{
				label = 'Заключение', 
				sound = 'npc/combine_soldier/vo/closing.wav',
				text = 'Заключить!'
			},
			{
				label = 'Контакт', 
				sound = 'npc/combine_soldier/vo/contact.wav',
				text = 'Есть контакт!'
			},
			{
				label = 'Задержать', 
				sound = 'npc/combine_soldier/vo/contained.wav',
				text = 'Задержать!'
			},
			{
				label = 'Повтори', 
				sound = 'npc/combine_soldier/vo/copythat.wav',
				text = 'Повтори!'
			},
			{
				label = 'В укрытие', 
				sound = 'npc/combine_soldier/vo/coverhurt.wav',
				text = 'Всем укрыться!'
			},
			
			{
				label = 'Врываемся', 
				sound = 'npc/combine_soldier/vo/dash.wav',
				text = 'Врываемся!'
			},
			{
				label = 'Подражатель', 
				sound = 'npc/combine_soldier/vo/echo.wav',
				text = 'Подражатель!'
			},
			{
				label = 'Очаровательно', 
				sound = 'npc/combine_soldier/vo/engaging.wav',
				text = 'Очаровательно!'
			},
			{
				label = 'Вспышка', 
				sound = 'npc/combine_soldier/vo/flash.wav',
				text = 'Вспышка!'
			},
			{
				label = 'Чисто', 
				sound = 'npc/combine_soldier/vo/flatline.wav',
				text = 'Можно идти!'
			},
			{
				label = 'Призрак', 
				sound = 'npc/combine_soldier/vo/ghost.wav',
				text = 'Призрак!'
			},
			{
				label = 'Сетка', 
				sound = 'npc/combine_soldier/vo/grid.wav',
				text = 'Тут сетка!'
			},
			{
				label = 'Медик', 
				sound = 'npc/combine_soldier/vo/helix.wav',
				text = 'МЕДИК!'
			},
			{
				label = 'Прибывший', 
				sound = 'npc/combine_soldier/vo/inbound.wav',
				text = 'Ей, прибывший!'
			},
			{
				label = 'Заражение', 
				sound = 'npc/combine_soldier/vo/infected.wav',
				text = 'Он заражен!'
			},
			{
				label = 'Юниты прибывают', 
				sound = 'npc/combine_soldier/vo/unitisinbound.wav',
				text = 'Юниты уже прибывают!'
			},
			{
				label = 'Юнит движется', 
				sound = 'npc/combine_soldier/vo/unitismovingin.wav',
				text = 'Юнит движется вперед!'
			},
			{
				label = 'Осуждение', 
				sound = 'npc/combine_soldier/vo/judge.wav',
				text = 'Осуждение!'
			},
			{
				label = 'Лидер', 
				sound = 'npc/combine_soldier/vo/leader.wav',
				text = 'Лидер!'
			},
			{
				label = 'Нет контакта', 
				sound = 'npc/combine_soldier/vo/lostcontact.wav',
				text = 'Контакт потерян!'
			},
			{
				label = 'Проходи', 
				sound = 'npc/combine_soldier/vo/movein.wav',
				text = 'Проходи!'
			},
			{
				label = 'Бродяга', 
				sound = 'npc/combine_soldier/vo/nomad.wav',
				text = 'Бродяга!'
			},
			{
				label = 'Взрыв', 
				sound = 'nnpc/combine_soldier/vo/outbreak.wav',
				text = 'Взрыв!'
			},
			{
				label = 'Возвращаемся', 
				sound = 'npc/combine_soldier/vo/payback.wav',
				text = 'Возвращаемся!'
			},
			{
				label = 'Фантом', 
				sound = 'npc/combine_soldier/vo/phantom.wav',
				text = 'Фантом!'
			},
			{
				label = 'Преследовать', 
				sound = 'npc/combine_soldier/vo/procecuting.wav',
				text = 'Преследуем его!'
			},
			{
				label = 'Ловушка', 
				sound = 'npc/combine_soldier/vo/quicksand.wav',
				text = 'Это ловушка!'
			},
			{
				label = 'Найти', 
				sound = 'npc/combine_soldier/vo/range.wav',
				text = 'Прочешите здесь все!'
			},
			{
				label = 'Приготовить взрывчатку', 
				sound = 'npc/combine_soldier/vo/readycharges.wav',
				text = 'Приготовить взрывчатку!'
			},
			{
				label = 'Приготовить оружие', 
				sound = 'npc/combine_soldier/vo/readyweapons.wav',
				text = 'Приготовить оружие!'
			},
			
			{
				label = 'Здесь чисто', 
				sound = 'npc/combine_soldier/vo/reportingclear.wav',
				text = 'Докладываю, здесь чисто!'
			},
			{
				label = 'Дикарь', 
				sound = 'npc/combine_soldier/vo/savage.wav',
				text = 'Дикарь!'
			},

			{
				label = 'Сектор не стерилен', 
				sound = 'npc/combine_soldier/vo/confirmsectornotsterile.wav',
				text = 'Сектор не стерилен!'
			},
			{
				label = 'Охрана Сектора', 
				sound = 'npc/combine_soldier/vo/sectorisnotsecure.wav',
				text = 'Сектор под охраной!'
			},
			{
				label = 'Охранять', 
				sound = 'npc/combine_soldier/vo/secure.wav',
				text = 'Охранять!'
			},
			{
				label = 'Опасная Зона', 
				sound = 'npc/combine_soldier/vo/sharpzone.wav',
				text = 'Здесь опасная зона!'
			},
			{
				label = 'Мина', 
				sound = 'npc/combine_soldier/vo/slam.wav',
				text = 'Здесь мина!'
			},
			{
				label = 'Стой', 
				sound = 'npc/combine_soldier/vo/standingby].wav',
				text = 'Стой на месте'
			},
			{
				label = 'Внимательнее', 
				sound = 'npc/combine_soldier/vo/stayalert.wav',
				text = 'Будь внимательнее!'
			},
			{
				label = 'Попал ', 
				sound = 'npc/combine_soldier/vo/striker.wav',
				text = 'Я попал!'
			},
			{
				label = 'Зачищаю', 
				sound = 'npc/combine_soldier/vo/sweepingin.wav',
				text = 'Зачищаю!'
			},
			{
				label = 'Быстрее', 
				sound = 'npc/combine_soldier/vo/swift.wav',
				text = 'Давай быстрее!'
			},
			
			{
				label = 'Займите Позиции', 
				sound = 'npc/combine_soldier/vo/stabilizationteamholding.wav',
				text = 'Группа захвата, займите позиции!'
			},
			{
				label = 'Маскировка', 
				sound = 'npc/combine_soldier/vo/uniform.wav',
				text = 'Это маскировка!'
			},
			{
				label = 'Наблюдаю', 
				sound = 'npc/combine_soldier/vo/visualonexogen.wav',
				text = 'Наблюдаю за обьектом!'
			},
			{
				label = 'Вот и все', 
				sound = 'npc/combine_soldier/vo/thatsitwrapitup.wav',
				text = 'Что ж, вот и все!'
			},
			{
				label = 'Код Меч', 
				sound = 'npc/combine_soldier/vo/sword.wav',
				text = 'Код : Меч!'
			},
			{
				label = 'Код Нова', 
				sound = 'npc/combine_soldier/vo/nova.wav',
				text = 'Код : Нова!'
			},
			{
				label = 'Код Нож', 
				sound = 'npc/combine_soldier/vo/stab.wav',
				text = 'Код : Нож'
			},
			{
				label = 'Код Зачистка', 
				sound = 'npc/combine_soldier/vo/sweeper.wav',
				text = 'Код : Зачистка!'
			},
			{
				label = 'Код Закат', 
				sound = 'npc/combine_soldier/vo/sundown.wav',
				text = 'Код : Закат!'
			},
			{
				label = 'Код Отсечь', 
				sound = 'npc/combine_soldier/vo/slash.wav',
				text = 'Код : Отсечь'
			},
			{
				label = 'Код Тень', 
				sound = 'npc/combine_soldier/vo/shadow.wav',
				text = 'Код : Тень!'
			},
			{
				label = 'Код Жнец', 
				sound = 'npc/combine_soldier/vo/reaper.wav',
				text = 'Код : Жнец!'
			},
			{
				label = 'Код Бритва', 
				sound = 'npc/combine_soldier/vo/razor.wav',
				text = 'Код : Бритва!'
			},
			{
				label = 'Код Булава', 
				sound = 'npc/combine_soldier/vo/mace.wav',
				text = 'Код : Булава!'
			},
			{
				label = 'Код Ураган', 
				sound = 'npc/combine_soldier/vo/hurricane.wav',
				text = 'Код : Ураган!'
			},
			{
				label = 'Код Молот', 
				sound = 'npc/combine_soldier/vo/hammer.wav',
				text = 'Код : Молот!'
			},
			{
				label = 'Код Кинжал', 
				sound = 'npc/combine_soldier/vo/dagger.wav',
				text = 'Код : Кинжал!'
			},
			{
				label = 'Код Антисептик',
				sound = 'npc/combine_soldier/vo/antiseptic.wav',
				text = 'Код : Антисептик!'
			},
			{
				label = 'Код Апекс', 
				sound = 'npc/combine_soldier/vo/apex.wav',
				text = 'Код : Апекс!'
			},
})
