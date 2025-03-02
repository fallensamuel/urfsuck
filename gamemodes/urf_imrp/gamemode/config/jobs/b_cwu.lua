local cwu_color = Color(255, 140, 0)

local cwu_spawns = {
	rp_city17_alyx_urfim = {
		Vector(2910, 5365, 32),
		Vector(2912, 5228, 32),
		Vector(2906, 5055, 32),
	},
}

local curuier_spawns = {
	rp_city17_alyx_urfim = {
	Vector(3630, 1640, 64),
	Vector(3500, 1640, 64),
	Vector(3360, 1640, 64),
	},
}

local mayor_spawn = {
	rp_city17_alyx_urfim = {Vector(8861, 3428, 6912),
},
}

local cwu_models = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',}

local map = isSerious && 8 or 17

TEAM_CURIER = rp.addTeam("C"..map..".ГСР.Курьер", {
	color = cwu_color,
	model = cwu_models,
	description = [[Сотрудник Гражданского Союза Рабочих, отвечающий за доставку посылок.

В обязанности входит:
- Доставлять посылки адресатам;

Доступ к Нексус Надзору:
Запрещен, кроме Холла Нексус Надзора;

Лояльность Альянса: Средняя;]],
	weapons = {'weapon_prop_destroy'},
	salary = 25,
	command = "gsrcurier",
	max = 4,
	speed = 0.8,
	spawns = curuier_spawns,
	faction = FACTION_CWU,
	reversed = true,
	rationCount = 3,
	CantUseDisguise = true,
	forceLimit = true,
	canUseHire = true,
	appearance =
	{
        {mdl = cwu_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {3},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {2},
                [6] = {11},
                [7] = {0},
                [8] = {3},
            }
        },
    },
	loyalty = 2
})

TEAM_COOK = rp.addTeam("C"..map..".ГСР.Завпит", {
	color = cwu_color,
	model = cwu_models,
	description = [[Сотрудник Гражданского Союза Рабочих, отвечающий за распределение провизии.

В обязанности входит:
- Обеспечение сотрудников ГСР и граждан, с лояльностью - Средняя и выше, дополнительным питанием;
- Сооружение продовольственных лавок;

Особенности:
- Покупка Еды;

Лояльность Альянса: Средняя;]],
	weapons = {'weapon_prop_destroy'},
	salary = 25,
	command = "gsrcook",
	max = 4,
	speed = 0.8,
	spawns = cwu_spawns,
	faction = FACTION_CWU,
	reversed = true,
	rationCount = 3,
	CantUseDisguise = true,
	forceLimit = true,
	canUseHire = true,
	appearance =
	{
        {mdl = cwu_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {1},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {11},
                [7] = {0},
                [8] = {3},
            }
        },
    },
	loyalty = 2
})

TEAM_CWU_MEDIC = rp.addTeam("C"..map..".ГСР.Фельдшер", {
	color = cwu_color,
	model = cwu_models,
	description = [[Сотрудник Гражданского Союза Рабочих, оказывающий медицинскую помощь всем, кто в ней нуждается.

В обязанности входит:
- Оказание медицинской помощи;
- Сооружение точек "Стабилизации здоровья";

Особенности:
- Покупка раздатчика Здоровья;
- Покупка Аптечек;
- Покупка Брони;

Лояльность Альянса: Средняя;
]],
	weapons = {"weapon_medkit",'weapon_prop_destroy'},
	salary = 25,
	command = "gsrmed",
	spawns = cwu_spawns,
	faction = FACTION_CWU,
	reversed = true,
	rationCount = 3,
	CantUseDisguise = true,
	speed = 0.8,
	forceLimit = true,
	DmHealTime = 5,
	canUseHire = true,
	medic = true,
	IsMedic = true,	
	RescueReward = 25,
	RescueFactions = {[FACTION_CITIZEN] = true, [FACTION_CWU] = true, [FACTION_MPF] = true, [FACTION_HELIX] = true, [FACTION_GRID] = true, [FACTION_OTA] = true, [FACTION_REFUGEES] = true, [FACTION_CMD] = true},
	max = 4,
	appearance =
	{
        {mdl = cwu_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {11},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {11},
                [7] = {0},
                [8] = {3},
            }
        },
    },
	loyalty = 2
})

TEAM_VORTI = rp.addTeam("C"..map..".ГСР.Вортигонт - Раб", {
	color = cwu_color,
	model = {
		"models/urf/hlalyx_vorty.mdl"
	},
	description = [[Сотрудник Гражданского Союза Рабочих, оказавшийся в нем не по собственной воле.
Был пойман и закован в систему, подавляющую все способности вортигонта.

В обязанности входит:
- Прислуживание гражданам с высокой и максимальной лояльностью;
- Сооружение точек продажи провианта и медикаментов ГСР;

Особенности:
- Покупка Еды;
- Покупка Аптечек;
- Покупка Брони;

Лояльность Альянса: Низкая;
]],
	weapons = {'weapon_prop_destroy', "weapon_physgun", "gmod_tool", "weapon_hands", },
	salary = 35,
	command = "vortigaunt_slave",
	unlockPrice = 10000,
	speed = 0.8,
	unlockTime = 17 * 3600,
	faction = FACTION_CWU,
	reversed = true,
	loyalty = 1,
	forceLimit = true,
	max = 4,
	rationCount = 2,
	CantUseDisguise = true,
	spawns = cwu_spawns,
	hirable = true,
	hirePrice = 75,
	appearance = 
	{
        {mdl = {'models/urf/hlalyx_vorty.mdl'},
          skins       = {0},
           bodygroups = {
                [1] = {2},
                [2] = {0},
            			}
        },
    },
})

TEAM_CWU_FIVE = rp.addTeam("C"..map..".ГСР.Надзорный", {
	color = cwu_color,
	model = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
	description = [[Сотрудник Гражданского Союза Рабочих, контролирующий работу сотрудников ГСР.

В обязанности входит:
- Контроль всех сотрудников ГСР;
- Отлов и принуждение к работе уклоняющихся сотрудников ГСР;
- Выдача рабочих поручений сотрудникам ГСР;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

Особенности:
- Выдача премии сотрудникам ГСР;

Доступ к Нексус Надзору:
Запрещен, кроме Холла Нексус Надзора;

Лояльность Альянса: Высокая;
]],
	weapons = {"weapon_medkit", "weapon_stunstick",'weapon_prop_destroy'},
	salary = 35,
	command = "gsr_five",
	spawns = cwu_spawns,
	faction = FACTION_CWU,
	reversed = true,
	unlockTime = 25 * 3600,
	unlockPrice = 12500,
	CantUseDisguise = true,
	canUseHire = true,
	rationCount = 4,
	speed = 1,
	max = 2,
	loyalty = 3,
	forceLimit = true,
	appearance = 
	{
        {mdl = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {5},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {11},
                [7] = {0},
                [8] = {3},
            			}
        },
    },
    loyalty = 3
})

TEAM_CWU_LARRY = rp.addTeam("C"..map..".ГСР.Ларри", {
	color = cwu_color,
	model = {'models/hlvr/characters/larry/larry_player.mdl'},
	description = [[
Ларри - один из дизинсекторов Гражданского Союза Рабочих.

Ларри занимается очищением секторов от зомбированных при помощи своего любимого дробовика, ношение которого ему разрешено Альянсом.

В обязанности входит:
- Уничтожение Зомбированных в секторах;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

Доступ к Нексус Надзору:
Запрещен, кроме Холла Нексус Надзора;

Лояльность Альянса: Высокая;
]],
	salary = 45,
	command = "larry",
	weapons = {'weapon_prop_destroy','tfa_heavyshotgun'},
	max = 1,
	spawns = cwu_spawns,
	faction = FACTION_CWU,
	forceLimit = true,
	CantUseDisguise = true,
	hasLicense = true,
	canUseHire = true,
	rationCount = 4,
	reversed = true,
	loyalty = 3,
	armor = 250,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('larry', ply) end,
})

TEAM_CWU_LEADER = rp.addTeam("C"..map..".ГСР.Секретарь", {
	color = cwu_color,
	model = {
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
	description = [[Глава Гражданского Союза Рабочих, отвечающий за работу всего союза.

Секретарь может запросить себе в охрану юнита Гражданской Обороны, звания 05/03.

В обязанности входит:
- Контроль и координация всех сотрудников ГСР;
- Выдача рабочих поручений сотрудникам ГСР;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

Особенности:
- Покупка Еды;
- Покупка Аптечек;
- Покупка Брони;

Доступ к Нексус Надзору:
Полный доступ к Нексус Надзору, кроме тюремного блока, крыла А и Штаба CMD;

Лояльность Альянса: Высокая;
]],
	salary = 55,
	command = "gsrleader",
	weapons = {'weapon_taxation','weapon_prop_destroy'},
	max = 1,
	spawns = cwu_spawns,
	faction = FACTION_CWU,
	forceLimit = true,
	rationCount = 6,
	speed = 0.8,
	reversed = true,
	CantUseDisguise = true,
	canUseHire = true,
	unlockTime = 100*3600,
	unlockPrice = 20000,
	loyalty = 3,
	appearance = 
	{
        {mdl = {
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {4},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {11},
                [7] = {0},
                [8] = {3},
            			}
        },
    },
})

local nextMayor = 0
TEAM_MAYOR1 = rp.addTeam("C"..map..".Администратор Города", {
	color = Color(255, 0, 0),
	model = "models/teslacloud/citizens/male07.mdl",
	description = [[Главная персона в городе, которому было доверено управление целым городом Альянса.
На его плечах лежит большая ответственность, ведь каждое неправильное решение может стоит ему жизни.

Администратор Города не имеет полного контроля над силами Гражданской Обороны, однако его мнение всегда учитывается;

Наличие Администратора Города в секторе увеличивает заработную плату всем сотрудникам ГСР и Гражданской Обороны.

К администратору города должна быть приставлена охрана минимум от 2 юнитов или боевых единиц.

Особенности:
- Регулирование положения в городе;
- Изменение законов;
- Увольнять/понижать в должности/выдавать премии сотрудникам ГСР;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

В подчинении у SeC, OTA.KING.Overlord и OTA.СMD.Marshal;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"swb_357"},
	command = "mayor1",
	spawns = mayor_spawn,
	unlockPrice = 50000,
	salary = 65,
	mayor = true,
	speed = 0.8,
	reversed = true,
	hasLicense = true,
	max = 1,
	armor = 150,
	faction = FACTION_CWU,
	canUseHire = true,
	CantUseDisguise = true,
	rationCount = 7,
	unlockTime = 30*3600,
	loyalty = 4,
	forceLimit = true,
	appearance = 
	{
        {mdl = {
        'models/teslacloud/citizens/male07.mdl',
     },
          skins       = {0,1,2},
           bodygroups = {
                [1] = {0,6},
                [2] = {9},
                [3] = {4},
                [4] = {0,1,2},
                [5] = {0},
                [6] = {11},
            			}
        },
    },
	customCheck = function(ply) return nextMayor < CurTime() end,
	CustomCheckFailMsg = 'MayorDelay',
	PlayerDeath = function(ply, weapon, killer) 
		nextMayor = CurTime() + rp.cfg.MayorDelay
		if killer:IsPlayer() && killer:IsRebel() then
			for k, v in pairs(player.GetAll()) do
				if v:IsRebel() then
					v:AddMoney(rp.cfg.MayorKillReward)
				end
			end
			rp.FlashNotifyAll('Новости альянса', rp.Term('MayorKilled'), killer)
		else
			rp.FlashNotifyAll('Новости альянса', rp.Term('MayorKilledByIncident'))
		end
		ply:ChangeTeam(rp.GetDefaultTeam(ply), true)
	end,
	PlayerDisconnected = function(ply) 
		nextMayor = CurTime() + rp.cfg.MayorDelay
	end
})

if SERVER then
	local math_floor = math.floor
	local team_NumPlayers = team.NumPlayers
	hook.Add("PlayerPayDay", function(ply, amount)
		if (ply:IsCombine() || ply:IsCWU()) && team_NumPlayers(TEAM_MAYOR1) > 0 then
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('MayorSalaryIncrease'))
			return math_floor(amount * 1.4)
		end
	end)
end

rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_OTA, FACTION_CMD}, {TEAM_MAYOR1}))

rp.AddRelationships(TEAM_MAYOR1, RANK_LEADER, {FACTION_CWU})
rp.AddRelationships(TEAM_CWU_LEADER, RANK_OFFICER, {FACTION_CWU})
rp.AddRelationships(TEAM_CWU_FIVE, RANK_TRAINER, {FACTION_CWU})

rp.AddDoorGroup('Альянс', rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}, {TEAM_SEC, TEAM_MAYOR1}))
rp.AddDoorGroup('ГСР', rp.GetFactionTeams({FACTION_CWU, FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}))

rp.addGroupChat(unpack(rp.GetFactionTeams(FACTION_CWU)))

rp.SetTeamVoices(TEAM_MAYOR1, {
	{
		label = 'Коллаборационисты ч1',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration01.wav', 
		text = 'Мне стало известно, что в последнее время меня называют коллаборационистом, как будто сотрудничать — позорно.',  
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч2',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration02.wav', 
		text = ' Я спрашиваю вас, что может быть лучше стремления к сотрудничеству?',
		broadcast = true,
		soundDuration = 15 
	},
	{
		label = 'Коллаборационисты ч3',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration03.wav', 
		text = ' В нашей беспрецедентной ситуации отказ от сотрудничества — это отказ от развития, равный самоубийству.',
		broadcast = true,
		soundDuration = 15 
	},
	{
		label = 'Коллаборационисты ч4',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration04.wav', 
		text = 'Отказывалась ли двоякодышащая рыба от воздуха? Нет.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч5',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration05.wav', 
		text = 'Она храбро ползла по суше, тогда как ее сородичи оставались в черной бездне океана, вглядываясь во тьму, невежественные и обреченные, несмотря на вечную бдительность.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч6',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration06.wav', 
		text = 'Станем ли мы повторять путь трилобитов?',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч7',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration07.wav', 
		text = 'Неужели всем достижениям человечества суждено стать лишь осколками пластика, разбросанными на окаменевшем ложе между Бургес-Шейлом и тысячелетним слоем грязи?',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч8',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration08.wav', 
		text = 'Чтобы не изменять себе и своей судьбе, мы должны стремиться к большему. Мы выросли из своей колыбели. Бессмысленно требовать материнского молока, когда истинная помощь ждет нас среди звезд.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч9',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration09.wav', 
		text = 'И лишь всеобщий союз, который люди недалекие именуют «Комбайном», поможет нам достичь их.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч10',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration10.wav', 
		text = 'Поэтому я заявляю — да, я коллаборационист. Мы все должны охотно сотрудничать, если хотим пожать плоды объединения.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Коллаборационисты ч11',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_collaboration11.wav', 
		text = 'И мы определенно пожнем их.',
		broadcast = true,
		soundDuration = 8
	},
	{
		label = 'City 17 ч1',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome01.wav', 
		text = 'Добро пожаловать! Добро пожаловать в Сити 17.',
		broadcast = true,
		soundDuration = 7
	},
	{
		label = 'City 17 ч2',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome02.wav', 
		text = 'Сами вы его выбрали, или его выбрали за вас — это лучший город из оставшихся.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'City 17 ч3',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome03.wav', 
		text = 'Я такого высокого мнения о Сити 17, что решил разместить свое правительство здесь,',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'City 17 ч4',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome04.wav', 
		text = 'в Цитадели, столь заботливо предоставленной нашими Покровителями.',
		broadcast = true,
		soundDuration = 10
	},
	{
		label = 'City 17 ч5',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome05.wav', 
		text = 'Я горжусь тем, что называю Сити 17 своим домом. Итак, собираетесь ли вы остаться здесь, или же вас ждут неизвестные дали,',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'City 17 ч6',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome06.wav', 
		text = 'добро пожаловать в Сити 17.',
		broadcast = true,
		soundDuration = 8 
	},
	{
		label = 'City 17 ч7',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_welcome07.wav', 
		text = 'Здесь безопасно.',
		broadcast = true,
		soundDuration = 6
	},
	{
		label = 'Инстинкты ч1',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct01.wav', 
		text = 'Позвольте мне зачитать письмо, которое я получил. «Уважаемый доктор Брин. Почему Альянс подавляет наш цикл размножения? Искренне Ваш, обеспокоенный гражданин».',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч2',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct02.wav', 
		text = 'Спасибо за письмо, гражданин. Конечно, ваш вопрос касается основных биологических потребностей, надежд и страхов за будущее вида.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч3',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct03.wav', 
		text = 'Я вижу и несколько невысказанных вопросов. Знают ли наши Покровители, что для нас лучше? Что дает им право принимать такие решения за человечество? Отключат ли они когда-нибудь поле подавления и позволят ли нам размножаться?',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч4',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct04.wav', 
		text = 'Позвольте мне развеять сомнения, лежащие в основе вашего беспокойства, чем отвечать на каждый невысказанный вопрос.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч5',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct05.wav', 
		text = 'Сначала давайте рассмотрим факт того, что впервые в истории мы стоим на пороге бессмертия.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч6',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct06.wav', 
		text = 'Этот факт влечет за собой далеко идущие выводы. Он требует полного пересмотра наших генетических потребностей.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч7',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct07.wav', 
		text = 'Он требует планирования и обдумывания, что идет вразрез с нашими психологическими установками.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч8',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct08.wav', 
		text = 'В такое время необходимо, может быть, напомнить себе, что наш истинный враг — это инстинкт.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч9',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct09.wav', 
		text = 'Инстинкты воспитывали нас, когда мы только становились.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч10',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct10.wav', 
		text = 'Инстинкты заботились о нас и оберегали нас в те тяжкие годы, когда мы делали первые орудия, готовили скудную пищу на костре',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч11',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct11.wav', 
		text = 'и вздрагивали от теней, скачущих на стенах пещеры.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч12',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct12.wav', 
		text = 'Но инстинкт неотделим от своего двойника — суеверия.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч13',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct13.wav', 
		text = 'Инстинкт неразрывно связан с необдуманными импульсами, и теперь мы видим его истинную природу. Но инстинкт знает о своей бесполезности и, как загнанный в угол зверь, ни за что не сдастся без кровавого боя.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч14',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct14.wav', 
		text = 'Он может нанести человечеству смертельную рану.',
		broadcast = true,
		soundDuration = 8
	},
	{
		label = 'Инстинкты ч15',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct15.wav', 
		text = 'Инстинкт создает своих тиранов и призывает нас восставать против них.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч16',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct16.wav', 
		text = 'Он говорит нам, что неизвестное — это угроза, а не возможность.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч17',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct17.wav', 
		text = 'Инстинкт хитро и незаметно уводит нас с пути изменений и прогресса.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч18',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct18.wav', 
		text = 'Поэтому инстинкт должен быть подавлен.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч19',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct19.wav', 
		text = 'С ним нужно нещадно бороться, начиная с основной потребности человека — потребности в размножении.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч20',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct20.wav', 
		text = 'Мы должны благодарить Покровителей за помощь в борьбе с этой всепоглощающей силой.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч21',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct21.wav', 
		text = 'Нажав на переключатель, они изгнали наших демонов одним движением.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч22',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct22.wav', 
		text = 'Они дали нам силы, которые мы сами не могли найти, чтобы справиться с этой манией.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч23',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct23.wav', 
		text = 'Они указали нам цель. Они помогли нам обратить взоры к звездам.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч24',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct24.wav', 
		text = 'Я уверяю вас, подавляющее поле будет снято в тот день, когда мы овладеем собой, когда мы докажем, что больше в нем не нуждаемся.',
		broadcast = true,
		soundDuration = 15
	},
	{
		label = 'Инстинкты ч25',
		color = Color(255, 0, 0),
		sound = 'vo/Breencast/br_instinct25.wav', 
		text = 'И этот день превращения, по сведениям из надежного источника, недалек.',
		broadcast = true,
		soundDuration = 15
	},	
 })

if isIndsutrial then
	rp.AddTeamVoices(TEAM_MAYOR1, {
		{
			label = 'Рабочий Терминал',
			color = Color(0, 0, 205),
			sound = 'industrial17/bassfadeDEEPfactoryonlineHQ.wav', 
			text = 'Внимание City 17. Граждане рабочего класса, проследуйте в рабочий терминал, медленно.',
			broadcast = true,
			soundDuration = 10
		},
		{
			label = 'Долг',
			color = Color(0, 0, 205),
			sound = 'industrial17/c17_pa0.wav', 
			text = 'Истинный Гражданин знает, что долг — это величайший дар!',
			broadcast = true,
			soundDuration = 10
		},
		{
			label = 'Комфорт',
			color = Color(0, 0, 205),
			sound = 'industrial17/c17_pa1.wav', 
			text = 'Истинный Гражданин ценит комфорт City 17 и проявляет благоразумность!',
			broadcast = true,
			soundDuration = 10
		},
		{
			label = 'Работа',
			color = Color(0, 0, 205),
			sound = 'industrial17/c17_pa3.wav', 
			text = 'Работа Истинного Гражданина, это полная противоположность рабству!',
			broadcast = true,
			soundDuration = 10
		},
		{
			label = 'Кислород',
			color = Color(0, 0, 205),
			sound = 'industrial17/c17_pa4.wav', 
			text = 'Истинный Гражданин экономит ценный кислород!',
			broadcast = true,
			soundDuration = 10
		},
	})
end


rp.SetTeamVoices(TEAM_VORTI, {  
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

local NotAllowed = {
    [TEAM_CURIER]   = true,
    [TEAM_COOK]     = true,
    [TEAM_CWU_MEDIC]  = true,
    [TEAM_VORTI]     = true,
    [TEAM_CWU_FIVE]  = true,
    [TEAM_CWU_LARRY]     = true,
    [TEAM_MAYOR1]  = true
}

function PLAYER:CanCapture()
    return not NotAllowed[self:Team()]
end