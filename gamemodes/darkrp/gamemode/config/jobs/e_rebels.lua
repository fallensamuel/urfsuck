local rebels_color = Color(34, 139, 34)

local rebels_models = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',}

local rebel_spawns = {
	rp_city17_alyx_urfim = {
Vector(-5306, -629, 80),
Vector(-5223, -630, 80),
Vector(-5107, -632, 80),
Vector(-5109, -770, 80),
Vector(-5225, -769, 80),
Vector(-5270, -768, 80),
Vector(-5273, -944, 80),
Vector(-5157, -946, 80),},
}

local rassel_spawn = {
    rp_city17_alyx_urfim = {Vector(-3427, 246, 80)},
}

local rebgun_spawns = {
	rp_city17_alyx_urfim = {Vector(-1074, 619, -144)
},
}

TEAM_REBONE = rp.addTeam("Новобранец Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Новобранец повстанческого сопротивления.

Прямые обязанности:
- Прохождение основного курса подготовки бойцов сопротивления;
- Патрулирование D6;

Запрещается:
- Учавствовать в Рейде/Восстании/Вылазках;

Подчиняется: Повстанцу и выше.
]],
	weapons = {"swb_knife"},
	spawns = rebel_spawns,
	canUseHire = true,
	salary = 5,
	command = 'rebel1',
	faction = FACTION_REBEL,
	rationCount = 1,
	reversed = true,
	armor = 50,
	loyalty = 7,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1,2},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})

TEAM_REBTWO = rp.addTeam("Повстанец", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Член основного подразделения сопротивления.

Подчиняется: Сержанту Повстанцев и выше.

]],
	weapons = {"swb_knife", 'swb_pistol'},
	spawns = rebel_spawns,
	salary = 6,
	command = 'rebel2',
	faction = FACTION_REBEL,
	unlockTime = 1.5 * 3600,
	unlockPrice = 750,
	rationCount = 1,
	reversed = true,
	canUseHire = true,
	armor = 80,
	loyalty = 7,
	max = 5,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1,2},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})

TEAM_REBTHREE = rp.addTeam("Вортигонт", {
	color = rebels_color,
	model = {'models/urf/hlalyx_vorty.mdl'},
	description = [[
Вортинг, примкнувший к повстанческому сопротивлению.

Разрешено:
- Находится в городе в одиночку и без маскировки;

Особенности:
- Возможность восполнять себе броню;

Подчиняется: Сержанту Повстанцев и выше.
]],
	weapons = {'swep_vortigaunt_beam'},
	spawns = rebel_spawns,
	salary = 7,
	command = 'rebel3',
	faction = FACTION_REBEL,
	unlockTime = 3 * 3600,
	unlockPrice = 1500,
	stamina = 2,
	speed = 0.9,
	rationCount = 1,
	reversed = true,
	CantUseDisguise = true,	
	disableDisguise = true,		
	disguise_team = TEAM_VORT,
	PlayerSpawn = function(ply) ply:SetMaxHealth(250) ply:SetHealth(250) end,
	canCapture = true,
	armor = 400,
	loyalty = 7,
	hpRegen = 3,
	forceLimit = true,
	max = 3,
	appearance = 
	{
        {mdl = {'models/urf/hlalyx_vorty.mdl'},
          skins       = {1},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {1},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
            			}
        },
    },
})

TEAM_VORTGUN = rp.addTeam("Вортигонт - Оружейник", {
	color = rebels_color,
	model = {'models/urf/hlalyx_vorty.mdl'},
	description = [[
Вортинг, примкнувший к повстанческому сопротивлению, способный производить оружие.

Разрешено:
- Находится в городе в одиночку и без маскировки;

Особенности:
- Возможность восполнять себе броню;

Подчиняется: Сержанту Повстанцев и выше.
]],
	weapons = {'swep_vortigaunt_beam','weapon_prop_destroy'},
	spawns = rebgun_spawns,
	salary = 7,
	command = 'rebelgun',
	faction = FACTION_REBEL,
	unlockTime = 3 * 3600,
	unlockPrice = 1500,
	stamina = 2,
	speed = 0.9,
	rationCount = 1,
	reversed = true,
	CantUseDisguise = true,	
	disableDisguise = true,		
	disguise_team = TEAM_VORT,
    PlayerSpawn = function(ply) ply:SetMaxHealth(250) ply:SetHealth(250) end,
	canCapture = true,
	armor = 400,
	loyalty = 7,
	hpRegen = 3,
	forceLimit = true,
	max = 2,
	appearance = 
	{
        {mdl = {'models/urf/hlalyx_vorty.mdl'},
          skins       = {1},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {1},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
            			}
        },
    },
})

TEAM_REBFOUR = rp.addTeam("Сержант Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Сержант повстанческого сопротивления.

Прямые обязанности:
- Формирование и управление группой из Новобранцев и Повстанцев;
- Вылазки в составе группы из 3 и более бойцов;

Подчиняется: Капитану Повстанцев и выше.
]],
	weapons = {"swb_knife", 'swb_pistol','swb_smg'},
	spawns = rebel_spawns,
	salary = 8,
	command = 'rebel4',
	faction = FACTION_REBEL,
	unlockTime = 5 * 3600,
	unlockPrice = 2500,
	rationCount = 1,
	canCapture = true,
	forceLimit = true,
	canUseHire = true,
	reversed = true,
	armor = 90,
	loyalty = 7,
	max = 3,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1,2},
                [3] = {2,3},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})

TEAM_REBFOUR = rp.addTeam("Элитный Сержант Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Сержант повстанческого сопротивления.

Прямые обязанности:
- Формирование и управление группой из Новобранцев и Повстанцев;
- Вылазки в составе группы из 3 и более бойцов;

Подчиняется: Капитану Повстанцев и выше.
]],
	weapons = {"swb_knife", 'swb_pistol','swb_smg',"weapon_frag"},
	spawns = rebel_spawns,
	salary = 12,
	command = 'promo_elit',
	faction = FACTION_REBEL,
	reversed = true,
	canCapture = true,
	forceLimit = true,
	disableDisguise = true,	
	canUseHire = true,
	armor = 120,
	loyalty = 7,
	max = 5,
	whitelisted = true,
	customCheck = function(ply) return CLIENT or rp.PlayerHasAccessToJob('promo_elit', ply) end,
	CustomCheckFailMsg = 'TestPromoDenied', 
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {7,8},
                [2] = {0,1,2},
                [3] = {2,3},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})


TEAM_REBFIVE = rp.addTeam("Медик Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Сержант Сопротивления, который имеет базовую медицинскую подготовку.

Прямые обязанности:
- Оказание медициниской помощи членам повстанческого движения;
- Вылазки в составе группы из 3 и более бойцов;

Особенности:
- Покупка раздатчика Здоровья;
- Покупка раздатчика Брони;
- Покупка Аптечек;
- Покупка Брони;

Подчиняется: Капитану Повстанцев и выше.

]],
	weapons = {"swb_knife", 'swb_pistol','swb_smg', "weapon_medkit",'swb_shotgun'},
	spawns = rebel_spawns,
	salary = 8,
	command = 'rebel5',
	faction = FACTION_REBEL,
	unlockTime = 8 * 3600,
	unlockPrice = 4000,
	rationCount = 1,
	reversed = true,
	DmHealTime = 5,
	canCapture = true,
	disableDisguise = true,
	canUseHire = true,
	medic = true,
	IsMedic = true,
	RescueReward = 35,
	RescueFactions = {[FACTION_CITIZEN] = true, [FACTION_CWU] = true, [FACTION_REBEL] = true, [FACTION_REFUGEES] = true},	
	armor = 100,
	loyalty = 7,
	forceLimit = true,
	max = 2,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1,2},
                [3] = {2,3},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})

TEAM_REBSPY = rp.addTeam("Разведчик Сопротивления", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Разведчик повстанческого сопротивления.

Бывший военный, принимавший участие в 7-ми часовой войне, отлично владеющий разведывательными навыками.

Прямые обязанности:
- Разведка обстановки в городе и добыча информации;

Запрещается:
- Первым нападать на Альянс в городе;

Особенности:
- Маскировка Гражданина;
- Имеет поддельную ID-карту;

Подчиняется: Капитану Повстанцев и выше.

]],
	weapons = {"swb_knife", 'swb_pistol','swb_bow','weapon_frag', "lockpick", "keypad_cracker", "weapon_cuff_elastic"},
	spawns = rebel_spawns,
	salary = 10,
	command = 'rebel15',
	faction = FACTION_REBEL,
	unlockTime = 30 * 3600,
	unlockPrice = 7500,
	canUseHire = true,
	rationCount = 1,
	speed = 1,
	reversed = true,
	canCapture = true,
	candisguise = true,
	disableDisguise = true,	
	disguise_faction = FACTION_CITIZEN,
	armor = 125,
	loyalty = 2,
	forceLimit = true,
	max = 2,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1,2},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {1,7,9,10},
                [7] = {0,1,2},
                [8] = {0,1,2},
            			}
        },
    },
})

TEAM_REBSIX = rp.addTeam("Штурмовик Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Штурмовик повстанческого сопротивления.

Бывший военный, принимавший участие в 7-ми часовой войне, отлично владующий боевыми навыками.

Прямые обязанности:
- Формирование и управление группой из Новобранцев и Повстанцев;
- Вылазки в составе группы из 2 и более бойцов;

Подчиняется: Капитану Повстанцев и выше.

]],
	weapons = {"swb_knife", 'swb_pistol','swb_oicw_v2','weapon_frag', "lockpick", "keypad_cracker"},
	spawns = rebel_spawns,
	salary = 12,
	command = 'rebel6',
	faction = FACTION_REBEL,
	unlockTime = 30 * 3600,
	unlockPrice = 15000,
	canUseHire = true,
	rationCount = 1,
	reversed = true,
	canCapture = true,
	disableDisguise = true,	
	armor = 175,
	loyalty = 7,
	forceLimit = true,
	max = 5,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {3,5,6,8},
                [2] = {0,2,3},
                [3] = {1},
                [4] = {0,1,2,3},
                [5] = {0},
                [6] = {2,4,5},
                [7] = {0,1,2},
                [8] = {1},
            			}
        },
    },
})

TEAM_REBSEVEN = rp.addTeam("Тяжелый Штурмовик Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Тяжелый Штурмовик повстанческого сопротивления.

Бывший военный, принимавший участие в 7-ми часовой войне, отлично владующий боевыми навыками.

Прямые обязанности:
- Обеспечение огневой поддержки союзникам;
- Формирование и управление группой из Новобранцев и Повстанцев;
- Вылазки в составе группы из 2 и более бойцов;

Подчиняется: Капитану Повстанцев и выше.
]],
	weapons = {"swb_knife", 'swb_pistol','swb_oicw_v2','swb_shotgun','weapon_frag', "lockpick", "keypad_cracker"},
	spawns = rebel_spawns,
	salary = 14,
	command = 'rebel7',
	faction = FACTION_REBEL,
	unlockTime = 45 * 3600,
	canUseHire = true,
	unlockPrice = 22500,
	disableDisguise = true,	
	rationCount = 1,
	reversed = true,
	canCapture = true,
	forceLimit = true,
	armor = 250,
	loyalty = 7,
	max = 3,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {3,5,6,8},
                [2] = {0,2,3},
                [3] = {1},
                [4] = {0,1,2,3},
                [5] = {0},
                [6] = {2,4,5},
                [7] = {0,1,2},
                [8] = {1},
            			}
        },
    },
})

TEAM_REBGO = rp.addTeam("Дезертир MPF", {
	color = rebels_color,
	model = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
	description = [[
Дезертир MPF.

Бывший сотрудник Гражданской Обороны, примкнувший к сопротивлению. 

Прямые обязанности:
- Разведка обстановки в городе и добыча информации;

Запрещается:
- Первым нападать на Альянс в городе;

Особенности:
- Маскировка MPF;
- Имеет поддельную ID-карту;

Подчиняется: Капитану Повстанцев и выше.

]],
	weapons = {"swb_knife", 'swb_pistol', 'swb_smg','weapon_frag', "lockpick", "keypad_cracker", "weapon_cuff_elastic"},
	spawns = rebel_spawns,
	salary = 16,
	command = 'rebel_go',
	faction = FACTION_REBEL,
	unlockTime = 30 * 3600,
	unlockPrice = 20000,
	canUseHire = true,
	rationCount = 1,
	reversed = true,
	canCapture = true,
	candisguise = true,
	disguise_faction = FACTION_MPF,
	disableDisguise = true,	
	armor = 125,
	loyalty = 2,
	forceLimit = true,
	max = 2,
	appearance = 
	{
        {mdl = {'models/rrp/metropolice/pm/umetropolicepm.mdl'},
          skins       = {5},
        },
    },
})

TEAM_REBSEVEN = rp.addTeam("Капитан Повстанцев", {
	color = rebels_color,
	model = rebels_models,
	description = [[
Капитан основного подразделения сопротивления.

Бывший военный, принимавший участие в 7-ми часовой войне, ранее имеющий высокое армейское звание.

Прямые обязанности:
- Формирование и управление группой из младших по званию повстанцев;
- Вылазки в составе группы из 2 и более бойцов;

Особенности:
- Выдача премии премии повстанцам;

Подчиняется: Доктору Кляйнеру и выше.
]],
	weapons = { "swb_knife", 'swb_357','swb_oicw_v2','weapon_frag', "lockpick", "keypad_cracker"},
	spawns = rebel_spawns,
	salary = 18,
	command = 'rebel8',
	faction = FACTION_REBEL,
	unlockTime = 70 * 3600,
	unlockPrice = 35000,
	disableDisguise = true,
	canUseHire = true,	
	rationCount = 1,
	reversed = true,
	canCapture = true,
	armor = 275,
	loyalty = 7,
	forceLimit = true,
	max = 2,
	appearance = 
	{
        {mdl = rebels_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {3,5,6,8},
                [2] = {0,2,3},
                [3] = {4},
                [4] = {0},
                [5] = {0,1},
                [6] = {2,4,5},
                [7] = {0,1,2},
                [8] = {1},
            			}
        },
    },
})

TEAM_HEVMK2 = rp.addTeam("Подавитель H.E.V.", {
	color = rebels_color,
	model = {"models/humans/hev_mark2.mdl"},
	description = [[
Подавитель - тяжеловооруженный штурмовой боец повстанческого движения, облаченный в H.E.V. костюм версии MK 2.
Вооружен перенастроенным тяжелым пулеметом Альянса - LMG.

Особенности:
- Безумная выносливость к урону;
- Огромная огневая мощь;

Подчиняется: Доктору Кляйнеру и выше.]],
	weapons = {"swb_357","swb_shotgun", "lockpick", "keypad_cracker", "swb_knife", 'weapon_frag', "tfa_suppressor", "weapon_cuff_elastic"},
	salary = 20,
	command = "hevmk2",
	max = 2,
	spawns = rebel_spawns,
	faction = FACTION_REBEL,
	rationCount = 1,
	disableDisguise = true,
	canUseHire = true,
	loyalty = 1,
	canCapture = true,
	reversed = true,
	forceLimit = true,
	armor = 300,
	PlayerSpawn = function(ply) ply:SetWalkSpeed(150) ply:SetRunSpeed(250) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('hevmk2', ply) end,
})

TEAM_KLEINER = rp.addTeam("Доктор Кляйнер", {
	color = rebels_color,
	model = {"models/player/kleiner.mdl"},
	description = [[
Доктор Кляйнер - "технологический мозг" всего сопротивления.
Имеет звания Генерала сопротивления, хотя сам неохотно им командует, ввиду мягкого характера доктора.

Особенности:
- Маскировка Гражданина;
- Перепрограммирование ОТА;
- Взлом раздатчика рациона - 8 рационов;
- Понижать в должности/выдавать премии повстанцам;
- Покупка раздатчика Здоровья;
- Покупка раздатчика Брони;
- Покупка Аптечек;
- Покупка Брони;

Может подчинить только одного юнита OTA.

Подчиняется: Илаю Вэнсу.
]],
	weapons = { "swb_357", "swb_smg", "lockpick", "keypad_cracker", "swb_knife", "weapon_ota_reprogrammer", "weapon_cuff_elastic"},
	salary = 20,
	command = "kleiner",
	spawns = rebel_spawns,
	faction = FACTION_REBEL,
	disableDisguise = true,
	candisguise = true,
	disguise_faction = FACTION_CITIZEN,
	armor = 225,
	rationCount = 8,
	reversed = true,
	unlockTime = 100 * 3600,
	unlockPrice = 50000,
	canCapture = true,
	canDiplomacy = true,
	canUseHire = true,
	loyalty = 7,
	max = 1,
})

TEAM_RASSEL = rp.addTeam("Рассел", {
	color = rebels_color,
	model = {"models/hlvr/characters/russell/russell_player.mdl"},
	description = [[
Рассел - "Инженер-Конструктор" всего сопротивления.
Имеет звания Генерала сопротивления.

Особенности:
- Выдача улучшенного снаряжения через свой специальный терминал;
- Запрещено участвовать в вылазках и в восстаниях;
- Понижать в должности/выдавать премии повстанцам;

Подчиняется: Илаю Вэнсу.
]],
	weapons = { "swb_357", "swb_smg", "lockpick", "weapon_prop_destroy" , "weapon_stunstick" , "keypad_cracker", "swb_knife"},
	salary = 22,
	command = "rassel",
	spawns = rassel_spawn,
	faction = FACTION_REBEL,
	disableDisguise = true,
	candisguise = true,
    canUseHire = true,
	armor = 225,
	rationCount = 4,
	reversed = true,
	unlockTime = 100 * 3600,
	unlockPrice = 50000,
	canCapture = true,
	canDiplomacy = true,
	canUseHire = true,
	loyalty = 7,
	max = 1,
})

TEAM_BARNEY = rp.addTeam("Барни Калхаун", {
	color = rebels_color,
	model = {"models/cultist/hl_a/vannila_combine/barney.mdl"},
	description = [[
Барни Калхаун - один из лидеров и символов сопротивления.
Вы носите звание генерала Сопротивления и имеете все его преференции.

Особенности:
- Понижать в должности/выдавать премии повстанцам;
- Маскировка MPF;
- Взлом раздатчика рациона - 4 рационов;
- Имеет поддельную ID-карту;
- Продажа Маскировки MPF;

Подчиняется: Илаю Вэнсу.
]],
	weapons = {"swb_357","swb_shotgun", "lockpick", "keypad_cracker", "swb_knife", 'weapon_frag','swb_oicw_v2', "weapon_cuff_elastic"},
	salary = 25,
	command = "barney",
	max = 1,
	spawns = rebel_spawns,
	faction = FACTION_REBEL,
	rationCount = 4,
	disableDisguise=true,
	unlockTime = 140 * 3600,
	unlockPrice = 70000,
	reversed = true,
	loyalty = 2,
	candisguise = true,
	disguise_faction = FACTION_MPF,
	canCapture = true,
	canDiplomacy = true,
	canUseHire = true,
	armor = 300,
		appearance = 
	{
        {mdl = {"models/cultist/hl_a/vannila_combine/barney.mdl"},
          skins       = {0},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0}},
            			}
        },
})

TEAM_ELI = rp.addTeam("Илай Вэнс", {
	color = rebels_color,
	model = {"models/chr_hla_eli_default.mdl"},
	description = [[
Илай Вэнс - основатель и ключевой лидер сопротивления, под командыванем которого находятся абсолютно все силы сопротивления.

Особенности:
- Увольнять/понижать в должности/выдавать премии повстанцам;
- Маскировка Гражданина;
- Взлом раздатчика рациона - 8 рационов;
- Покупка Аптечек;
- Покупка Брони;

]],
	weapons = {"swb_357","swb_shotgun", "lockpick", "keypad_cracker", "swb_knife", 'weapon_frag','swb_oicw_v2'},
	salary = 30,
	command = "eli",
	spawns = rebel_spawns,
	faction = FACTION_REBEL,
	disableDisguise = true,
	candisguise = true,
	disguise_faction = FACTION_CITIZEN,
	armor = 250,
	rationCount = 8,
	unlockTime = 170 * 3600,
	unlockPrice = 85000,
	canCapture = true,
	canDiplomacy = true,
	canUseHire = true,
	reversed = true,
	loyalty = 7,
	max = 1,
	appearance = 
	{
        {mdl = {"models/chr_hla_eli_default.mdl"},
           bodygroups = {
                [1] = {0},
            			}
        },
    },
})

TEAM_ALYX = rp.addTeam("Аликс Вэнс", {
	color = rebels_color,
	model = {"models/mark2580/ff/alyx_ff_v9_replika_player.mdl"},
	description = [[
Аликс Венс - дочь Илая Венса, и один из лидеров сопротивления.

Специализируется на особо важных заданиях, связанных с шпионажем и саботажем.

Особенности:
- Понижать в должности/выдавать премии повстанцам;
- Маскировка MPF;
- Повышенная скорость передвижения;
- Имеет поддельную ID-карту;
- Взлом раздатчика рациона - 4 рационов;

Подчиняется: Илаю Вэнсу.
]],
	weapons = {"swb_357","swb_shotgun", "lockpick", "keypad_cracker", "swb_knife", 'weapon_frag','swb_oicw_v2', "weapon_cuff_elastic"},
	salary = 35,
	command = "alyx",
	spawns = rebel_spawns,
	faction = FACTION_REBEL,
	rationCount = 4,
	unlockPrice = 105000,
	unlockTime = 210 * 3600,
	canUseHire = true,
	loyalty = 7,
	armor = 325,
	speed = 1.2,
	disableDisguise = true,
	canCapture = true,
	canDiplomacy = true,
	candisguise = true,
	reversed = true,
	disguise_faction = FACTION_MPF,
	loyalty = 2,
	max = 1,
})

-- Рация
rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_REBEL})) 

-- Двери
rp.AddDoorGroup('Сопротивление', rp.GetFactionTeams({FACTION_REBEL}))

-- Ранги отряда
rp.AddRelationships(TEAM_ELI, RANK_LEADER, {FACTION_REBEL})
rp.AddRelationships(TEAM_ALYX, RANK_OFFICER, {FACTION_REBEL})
rp.AddRelationships(TEAM_KLEINER, RANK_OFFICER, {FACTION_REBEL})
rp.AddRelationships(TEAM_RASSEL, RANK_OFFICER, {FACTION_REBEL})
rp.AddRelationships(TEAM_BARNEY, RANK_OFFICER, {FACTION_REBEL})
rp.AddRelationships(TEAM_REBSEVEN, RANK_TRAINER, {FACTION_REBEL})

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_REBEL})))


rp.SetFactionVoices({FACTION_REBEL}, {
	{
		label = 'Есть',
		sound = 'rebels/reb1_striderdown06.wav', 
		text = 'Есть!' 
	},
	{
		label = 'Сдохни',
		sound = 'rebels/reb1_striderdown11.wav', 
		text = 'Сдохни!' 
	},
	{
		label = 'Получай',
		sound = 'rebels/reb1_striderdown12.wav', 
		text = 'Получай!' 
	},
	{
		label = 'Сосредоточтесь',
		sound = 'rebels/reb1_prepare_battle_09.wav', 
		text = 'Сосредоточтесь!' 
	},
	{
		label = 'Все готовы?',
		sound = 'rebels/reb1_prepare_battle_02.wav', 
		text = 'Все готовы?' 
	},
	{
		label = 'Вот и все',
		sound = 'rebels/reb1_prepare_battle_01.wav', 
		text = 'Фух... вот и все.' 
	},
	{
		label = 'Вот зараза',
		sound = 'rebels/reb1_sawmillexplo03.wav', 
		text = 'Вот зараза!' 
	},
	{
		label = 'Уничтожить',
		sound = 'rebels/reb1_sawmillexplo06.wav', 
		text = 'Боже, да уничтожьте же его!' 
	},
	{
		label = 'Ха-ха',
		sound = 'rebels/reb1_striderdown05.wav', 
		text = 'Ха-ха! Да!' 
	},
	{
		label = 'Смех',
		sound = 'rebels/reb2_killshots22.wav', 
		text = '*смеется*' 
	},
	{
		label = 'Радость',
		sound = 'rebels/reb1_striderdown08.wav', 
		text = '*радуется*' 
	},
	{
		label = 'Ненавижу',
		sound = 'rebels/reb2_magblasted09.wav', 
		text = 'Как я их ненавижу!' 
	},
	{
		label = 'Нам конец',
		sound = 'rebels/reb1_lastwave01.wav', 
		text = 'Вот теперь все, нам конец!' 
	},
	{
		label = 'Защищаем базу',
		sound = 'rebels/reb1_lastwave02.wav', 
		text = 'Защищаем базу, ребята!' 
	},
	{
		label = 'Это они',
		sound = 'rebels/reb1_lastwave08.wav', 
		text = 'А вот и они!' 
	},
	{
		label = 'Враг',
		sound = 'rebels/reb1_lastwave09.wav', 
		text = 'Вра-аг!' 
	},
	{
		label = 'Да ну его',
		sound = 'rebels/reb1_lastwaveannounced03.wav', 
		text = 'Будь оно все проклято!' 
	},
	{
		label = 'Боятся',
		sound = 'rebels/reb1_lastwaveannounced05.wav', 
		text = 'Меня не убьют... меня не убьют!' 
	},
})

 rp.SetTeamVoices(TEAM_BARNEY, {
    {
		label = 'Граната',
		sound = 'vo/npc/Barney/ba_grenade01.wav', 
		text = 'Граната!' 
	},
    {
		label = 'Давай',
		sound = 'vo/npc/Barney/ba_bringiton.wav', 
		text = 'Давай!' 
	},
    {
		label = 'Прочь',
		sound = 'vo/npc/Barney/ba_getoutofway.wav', 
		text = 'Прочь с дороги!' 
	},
    {
		label = 'Чёрт',
		sound = 'vo/npc/Barney/ba_damnit.wav', 
		text = 'Чёрт!' 
	},
	{
		label = 'Да',
		sound = 'vo/npc/Barney/ba_laugh03.wav', 
		text = 'Да!' 
	},
	{
		label = '*Смех*',
		sound = {'vo/npc/Barney/ba_laugh04.wav', 'vo/npc/Barney/ba_laugh03.wav', 'vo/npc/Barney/ba_laugh02.wav', 'vo/npc/Barney/ba_laugh01.wav'}, 
		text = '*Смех*' 
	},
	{
		label = 'Они снаружи, шевелись',
		sound = 'vo/trainyard/ba_exitnag02.wav', 
		text = 'Они снаружи, шевелись!'  
	},
	{
		label = 'Удачи',
		sound = 'vo/trainyard/ba_goodluck01.wav', 
		text = 'Удачи тебе там, приятель.' 
	},
	{
		label = 'Пиво',
		sound = 'vo/trainyard/ba_thatbeer02.wav', 
		text = 'По поводу того пива, что я тебе должен!' 
	},
	{
		label = 'Я работаю под прикрытием в ГО.',
		sound = 'vo/trainyard/ba_undercover.wav', 
		text = 'Я работаю под прикрытием в ГО. Я не могу задерживаться иначе, они что-нибудь заподозрят. Я и так сильно отстаю от нормы избиений.', 
		soundDuration = 15
	},
	{
		label = 'Убирайся',
		sound = 'vo/npc/Barney/ba_getaway.wav', 
		text = 'Убирайся оттуда!' 
	},
	{
		label = 'Давай сделаем это!',
		sound = 'vo/npc/Barney/ba_letsdoit.wav', 
		text = 'Давай сделаем это!' 
	},
	{
		label = 'Я с тобой',
		sound = 'vo/npc/Barney/ba_imwithyou.wav', 
		text = 'Я с тобой, братан!' 
	},
	{
		label = 'Мне не нравится',
		sound = 'vo/npc/Barney/ba_getoutofway.wav', 
		text = 'Мне не нравится, как оно выглядит.' 
	},
	{
		label = 'Поторапливайся',
		sound = 'vo/npc/Barney/ba_getoutofway.wav', 
		text = 'Поторапливайся!' 
	},
 })

rp.SetTeamVoices(TEAM_ALYX, {
    {
		label = 'Сюда',
		sound = 'vo/trainyard/al_overhere.wav', 
		text = 'Сюда!' 
	},
	
	{
		label = 'Приветсвие',
		sound = 'vo/trainyard/al_nicetomeet_b.wav', 
		text = 'Приятно наконец встретить тебя!' 
	},
	{
		label = 'Не-ет',
		sound = 'vo/Streetwar/Alyx_gate/al_no.wav', 
		text = 'Не-ет!' 
	},
	{
		label = 'Идём',
		sound = 'vo/Streetwar/Alyx_gate/al_letsgo01.wav', 
		text = 'Идём!' 
	},
	{
		label = 'Не делай этого',
		sound = 'vo/trainyard/al_noyoudont.wav', 
		text = 'Нет, ты не должен этого делать.' 
	},
	{
		label = 'Поторопись',
		sound = 'vo/trainyard/al_suspicious.wav', 
		text = 'Нам стоит поторопиться.' 
	},
	{
		label = 'Проходи сюда',
		sound = 'vo/trainyard/al_thruhere.wav', 
		text = 'Проходи сюда.' 
	},
	{
		label = 'Давай,давай',
		sound = 'vo/Streetwar/Alyx_gate/al_cmoncmon.wav', 
		text = 'Давай,давай!' 
	},
	{
		label = 'Привет',
		sound = 'vo/Streetwar/Alyx_gate/al_hey.wav', 
		text = 'Привет' 
	},
	{
		label = 'Путь',
		sound = 'vo/Streetwar/Alyx_gate/al_scout.wav', 
		text = 'Дай-ка посмотрю, вдруг я найду новый путь.' 
	},
	{
		label = 'Двигаемся',
		sound = 'vo/Streetwar/Alyx_gate/al_thatway.wav', 
		text = 'Двигаемся этим путём!' 
	},
	{
		label = 'Они засекли нас',
		sound = 'vo/Streetwar/Alyx_gate/al_theysawus.wav', 
		text = 'Они засекли нас!' 
	},
	{
		label = 'Жди меня здесь',
		sound = 'vo/Streetwar/Alyx_gate/al_waitforme.wav', 
		text = 'Жди меня здесь!' 
	},
	{
		label = 'А вот и оно',
		sound = 'vo/Streetwar/Alyx_gate/al_thatsit_r.wav', 
		text = 'А вот и оно!' 
	},
	{
		label = 'Прикрой меня',
		sound = 'vo/Streetwar/Alyx_gate/al_watchmyback.wav', 
		text = 'Прикрой меня.' 
	},
 })

 rp.SetTeamVoices(TEAM_KLEINER, {
	{
		label = '*Крик*',
		sound = 'vo/k_lab/kl_ahhhh.wav', 
		text = '*Крик*'
	},
	{
		label = 'Боже мой',
		sound = 'vo/k_lab/kl_dearme.wav', 
		text = 'Боже мой.' 
	},
	{
		label = 'Прекрасно',
		sound = 'vo/k_lab/kl_excellent.wav', 
		text = 'Прекрасно.'
	},
	{
		label = 'О, Боже',
		sound = 'vo/k_lab/kl_ohdear.wav', 
		text = 'О, Боже.'
	},
	{
		label = 'Что это',
		sound = 'vo/k_lab/kl_whatisit.wav', 
		text = 'Что это?'
	},
	{
		label = 'Готов',
		sound = 'vo/novaprospekt/kl_ready.wav', 
		text = 'Готов, готов и ещё раз готов.'
	},
	{
		label = 'неприятно',
		sound = 'vo/k_lab2/kl_atthecitadel01.wav', 
		text = 'Это очень неприятно.'
	},
	{
		label = 'О, БОЖЕ',
		sound = 'vo/k_lab2/kl_greatscott.wav', 
		text = 'О, БОЖЕ!'
	},
	{
		label = 'Минутку',
		sound = 'vo/k_lab2/kl_cantleavelamarr.wav', 
		text = 'Минутку'
	},
	{
		label = 'Видишь',
		sound = 'vo/k_lab2/kl_notallhopeless.wav', 
		text = 'Видишь?'
	},
	{
		label = 'Очаровательно',
		sound = 'vo/k_lab2/kl_slowteleport01.wav', 
		text = 'Очаровательно!'
	},
	{
		label = 'Счастливого пути',
		sound = 'vo/k_lab/kl_bonvoyage.wav', 
		text = 'Счастливого пути и удачи в твоих стараньях.'
	},
	{
		label = 'Сделка',
		sound = 'vo/k_lab2/kl_blowyoustruck01.wav', 
		text = 'Отличная сделка, дорогуша.'
	},
 })

 rp.SetTeamVoices(TEAM_ELI, {
	{
		label = 'Посмотри',
		sound = 'vo/k_lab/eli_seeforyourself.wav', 
		text = 'Посмотри на себя'
	},
	{
		label = 'Э-э-э-э',
		sound = 'vo/eli_lab/eli_handle_b.wav', 
		text = 'Э-э-э-э'
	},
	{
		label = 'О Боже',
		sound = 'vo/citadel/eli_goodgod.wav', 
		text = 'О, Боже...' 
	},
	{
		label = 'Никогда',
		sound = 'vo/citadel/eli_nonever.wav', 
		text = 'Никогда!'
	},
	{
		label = 'Нет',
		sound = 'vo/citadel/eli_notobreen.wav', 
		text = 'Нет!'
	},
	{
		label = 'Я знаю',
		sound = 'vo/novaprospekt/eli_iknow.wav', 
		text = 'Я знаю, что ты это сделаешь.'
	},
	{
		label = 'Никогда бы не подумал',
		sound = 'vo/eli_lab/eli_surface_b.wav', 
		text = 'Никогда бы не подумал, что нужно так долго, чтобы вернуться ко мне.'
	},
	{
		label = 'Не думайте обо мне',
		sound = 'vo/novaprospekt/eli_nevermindme01.wav', 
		text = 'Не думайте обо мне, спасайтесь!'
	},
	{
		label = 'Увидимся там',
		sound = 'vo/novaprospekt/eli_notime01.wav', 
		text = 'Увидимся там, детка.'
	},
 })

 rp.SetTeamVoices(TEAM_REBTHREE, {  
	{
		label = 'Мы за тобой',
		sound = 'vo/npc/vortigaunt/honorfollow.wav', 
		text = 'Мы идем за тобой.' 
	},
	{
		label = 'Честь',
		sound = 'vo/npc/vortigaunt/honorours.wav', 
		text = 'Нам выпала честь.' 
	},
	{
		label = 'Клянусь',
		sound = 'vo/npc/vortigaunt/ourhonor.wav', 
		text = 'Клянусь честью.' 
	},
	{
		label = 'Проходи',
		sound = 'vo/npc/vortigaunt/passon.wav',
		text = 'Проходи!'  
	},
	{
		label = 'Мы победим',
		sound = 'vo/npc/vortigaunt/prevail.wav', 
		text = 'Мы победим.' 
	},
	{
		label = '*Вортигонтский*',
		sound = 'vo/npc/vortigaunt/vortigese12.wav', 
		text = '*Вотигонтский*'
	},
	{
		label = 'Мы поможем',
		sound = 'vo/npc/vortigaunt/wewillhelp.wav', 
		text = 'Мы поможем тебе.' 
	},
	{
		label = 'Успокойся',
		sound = 'vo/npc/vortigaunt/calm.wav', 
		text = 'Успокойся.' 
	},
	{
		label = 'Мы не можем стрелять',
		sound = 'vo/npc/vortigaunt/cannotfire.wav', 
		text = 'Мы не можем стрелять без вреда тебе.' 
	},
	{
		label = 'Мечта',
		sound = 'vo/npc/vortigaunt/dreamed.wav', 
		text = 'Мы мечтали об этой минуте.' 
	},
	{
		label = 'Честь',
		sound = 'vo/npc/vortigaunt/fmhonorsus.wav', 
		text = 'Ты оказал нам честь.' 
	},
	{
		label = 'За свободу',
		sound = 'vo/npc/vortigaunt/forfreedom.wav', 
		text = 'За свободу!' 
	},
	{
		label = 'Мы служим',
		sound = 'vo/npc/vortigaunt/mystery.wav', 
		text = 'Мы служим одной тайне.',
	},
})