-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\nebo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*local  nebo_spawns = {
rp_stalker_urfim_v3 = {Vector(7019, 1040, -4244), Vector(6927, 1182, -4244)},
rp_pripyat_urfim = {Vector(11800, 8144, -164), Vector(11784, 8343, -170), Vector(11503, 8206, -169)},
rp_stalker_urfim = {Vector(10873, 3797, -507), Vector(10861, 3894, -507), Vector(10861, 3999, -511)},
rp_st_pripyat_urfim = {Vector(12472, 2354, -2), Vector(12400, 2653, -8)}
}

local model_nebo1 = {    
"models/tnb/stalker/male_cs3.mdl",
"models/tnb/stalker/male_cs3_mask.mdl",
}

TEAM_NEBOB = rp.addTeam("Боец ЧН", {
	color = Color(0, 191, 255),
	model = model_nebo1,
	description = [[
Ты основная боевая единица Чистого Неба, именно ты охраняешь подступы к своей базе и защищаешь своих товарищей от напасти зоны.

• Участие в боевых баталиях и перестрелках;
• Охрана научних экспедиций;
• Обеспечение охраны базы Чистого Неба;	
Это лишь малость того, чем вы можете заняться!

Не имеешь права выходить с базы в одиночку!
Подчиняется: Лидер Разведки и выше.

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
	]],
	weapons = {"swb_mp5","swb_winchester","swb_makarov", "weapon_cuff_elastic"},
	command = "nebob",
	salary = 7,
	armor = isNoDonate && 50 || 100,
	spawns = nebo_spawns,
	spawn_points = {},
	faction = FACTION_NEBO,
    appearance = {
        {
            mdl = model_nebo1,
        skins = {2},    
        },
    },
    experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 15,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_NEBOYCHEN = rp.addTeam("Ученый ЧН", {
	color = Color(0, 191, 255),
	model =  {'models/tnb/stalker/male_cs3_mask.mdl'},
	description = [[
Ты основная исследовательская единица Чистого Неба, именно ты изучаешь зону.

• Участие в научных экспедициях;
• Изучение зоны вблизи базы;
Это лишь малость того, чем вы можете заняться!

Не имеешь права выходить с базы в одиночку!
Подчиняется: Старший Ученый и выше.

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Сканирование территорий на наличие радиации - 20;
	]],
	weapons = {"swb_mp5", "swb_makarov", 'weapon_dosimeter'},
	command = "neboychen",
	salary = 9,
	armor = isNoDonate && 50 || 100,
	spawns = nebo_spawns,
	spawn_points = {},
	faction = FACTION_NEBO,
	appearance = {
        {
            mdl = 'models/tnb/stalker/male_cs3_mask.mdl',
        skins = {2},    
        },
    },
    experience = {
		id = "nebo",
			actions = 
			{
			["healing"] = 15,
			["sell_slave"] = 25,
   			["revive"] = 15,
   			["broom"] = 20,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_NEBOR = rp.addTeam("Разведчик ЧН", {
	color = Color(0, 191, 255),
	model = {
		"models/tnb/stalker/male_cs2.mdl"
	},
	description = [[
Разведай новые горизонты для своей группировки, но будь осторожен, каждая неизведанная тропа может быть опасна, осталось проверить так ли это.

• Обнаружение новых аномалий;
• Найди новые безопасные тропы;
• Слушай командира и ты не пропадешь;
Это лишь малость того, чем вы можете заняться!

Подчиняется: Лидер ЧН и выше.	

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Хронирование ценной документации - 25;
	]],
	weapons = {"swb_ak74su_mod", "swb_colt1911", "stalker_knife", "weapon_cuff_elastic", "weapon_cuff_elastic"},
	command = "nebor",
	salary = 10,
	armor = isNoDonate && 100 || 150,
	spawns = nebo_spawns,
	spawn_points = {},
	faction = FACTION_NEBO,
	max = 6,		
	stashing = true, 
    appearance =
    {
        {mdl = "models/tnb/stalker/male_cs2.mdl",
          skins       = {2},
        },
    },
unlockExperience = {		
id = "nebo",
amount = 500,
},
experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 15,
   			["sell_slave"] = 25,
   			["stashing"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_HOLOD = rp.addTeam("Суслов", {
	color = Color(0, 191, 255),
	model = {
	"models/stalker_nebo/nebo_simple/nebo_simple.mdl"
	},
	description = [[ Ведёт жизнь бармена в группировке «Чистое небо» в своём баре и продаёт еду другим сталкерам. Известен среди своих товарищей как веселый и добродушный человек, а также любитель пошлых шуток. В Зону пришёл потому, что не нашёл места во внешнем мире.
	
• Торгуй с другими сталкерами и снабжай "Чистое Небо" всем необходимым! 
• Выдавай работу сталкерам; 
• Налаживание отношений с другими группировками; 
• Принимай все меры для процветания группировки; 

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;

	]],
	weapons = {"swb_ak107", "swb_colt", "stalker_knife","health_kit_bad"},
	command = "syslov",
	salary = 12,
	armor = isNoDonate && 250 || 350,
	health = isNoDonate && 125 || 150,
	max = 1,
    canDiplomacy = true,
	spawns = nebo_spawns,
	spawn_points = {},
	reversed = true,
	faction = FACTION_NEBO,
	canCapture = true,
    disableDisguise = true,
    appearance = 
    {
        {mdl = "models/stalker_nebo/nebo_simple/nebo_simple.mdl",
          skins       = {0,1},
           bodygroups = {
                [1] = {0,1,2,3},
                [2] = {0,1},
            }
        },
    },
unlockExperience = {		
id = "nebo",
amount = 1000,
},
experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_NEBOSTYCHEN = rp.addTeam("Старший Ученый ЧН", {
	color = Color(0, 191, 255),
	model = {'models/stalker_nebo/nebo_seva/nebo_seva.mdl'},
	description = [[
Ты старший ученный Чистого Неба, руководите иследовательскими группами.

• Организовывайте научные экспедиции;
• Изучение все зоны;
• Проводите исследования;
Это лишь малость того, чем вы можете заняться!

Не имеешь права выходить с базы в одиночку!
Подчиняется: Проффесор и выше.
Командует: Учеными ЧН.

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Сканирование территорий на наличие радиации - 20;

	]],
	weapons = {"swb_double_long_shotgun", "swb_makarov", 'weapon_dosimeter', 'weapon_art_buyer_x3'},
	command = "nebostychen",
	salary = 13,
	armor = isNoDonate && 50 || 100,
	spawns = nebo_spawns,
	spawn_points = {},
	faction = FACTION_NEBO,
unlockExperience = {		
id = "nebo",
amount = 1500,
},
experience = {
		id = "nebo",
			actions = 
			{
		    ["healing"] = 15,
		    ["sell_slave"] = 25,
   			["revive"] = 20,
   			["broom"] = 20,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_shurmnbo = rp.addTeam("Штурмовик ЧН", {
	color = Color(0, 191, 255),
	model = {"models/tnb/stalker/male_cs2_helmet.mdl"},
	description = [[
Тяжелая боевая единица Чистого Неба, именно на тебя в бою рассчитывают все и именно тебе под силу захватить Лиманск. Лебедев смотрит на тебя с небес и гордится тобой, ведь ты - его оружие по истреблению мутантов и врагов Чистого Неба.

* Охота на мутантов;
* Защита базы;
* Будь танком и впитывай в себя урон;
Это лишь малость того, чем вы можете заняться!

Командует: Ученый ЧН.
Подчиняется: Мастер ЧН и выше.

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;

	]],
	weapons = {"swb_pkm","swb_spas14","swb_usp", "weapon_cuff_elastic"},
	command = "shurmnbo",
	salary = 14,
    armor = isNoDonate && 300 || 350,
    health = isNoDonate && 150 || 150,
    max = 3,
    forceLimit = true,
    canCapture = true,
	spawns = nebo_spawns,
	faction = FACTION_NEBO,
	speed = 1.1,
	appearance = {
		{  mdl        = "models/tnb/stalker/male_cs2_helmet.mdl",
			skins      = {2},
		},
	},
unlockExperience = {		
id = "nebo",
amount = 2000,
},
experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_MASTERCHN = rp.addTeam("Мастер ЧН", {
	color = Color(0, 191, 255),
	model = {'models/tnb/stalker/male_cs4.mdl', 'models/stalker_nebo/nebo_charged/nebo_charged.mdl',
	},
	description = [[
Ты Мастер Чистого Неба - боец закалённый в боях! Профессор и лидер доверяют тебе и доверяют самые важные задания.

• Организовывай защиту экспедиций; 
• Будь впереди всех перестрелок и баталий; 
• Нанимай сталкеров для обеспечения охраны; 
Это лишь малость того, чем вы можете заняться! 

Командует: Ученый ЧН и ниже. 
Подчиняется: Лидеру ЧН и Лебедеву.  

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;		
	]],
	weapons = {"swb_ak103", "swb_svu", "swb_colt", "stalker_knife","health_kit_normal", "weapon_cuff_elastic"},
	command = "masterchn",
	salary = 16,
	armor = isNoDonate && 350 || 400,
	health = isNoDonate && 150 || 200,
	max = 2,
	forceLimit = true,
	spawns = nebo_spawns,
	anomaly_resistance = .3,	
	spawn_points = {},
	faction = FACTION_NEBO,
	canCapture = true,
    appearance = {
        {
            mdl = {
"models/tnb/stalker/male_cs4.mdl",
                    },
        skins = {2},    
        },
    }, 
unlockExperience = {		
id = "nebo",
amount = 2500,
},
experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },	
})

TEAM_PROFESSOR_CH = rp.addTeam("Профессор ЧН", {
	color = Color(0, 191, 255),
	model = {'models/tnb/stalker/male_seva_cs4.mdl'},
	description = [[
Самый почитаемый и наиболее влиятельный человек в Чистом Небе,после Лебедева.
Твоими научными достижениями может гордится всё "Чистое небо",ты выдающийся учёный!

• Организовывай экспедиции в зону;
• Изучай зону, собирай интересные артефакты;
• Скупай ценные артефакты;
• Поручай ценные задания сталкерам;
Это лишь малость того, чем вы можете заняться!

Командует: Учеными ЧН.
Подчиняется: Лидеру ЧН и Лебедеву.  

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Сканирование территорий на наличие радиации - 25;		
]],
	weapons = {"swb_abaton","stalker_knife", "swb_colt1911","weapon_art_buyer_x3","health_kit_best", 'weapon_dosimeter'},
	command = "nebo2z",
	salary = 18,
	armor = isNoDonate && 180 || 250,
	health = isNoDonate && 125 || 150,
	max = 1,
	spawns = nebo_spawns,
	reversed = true,
	spawn_points = {},
	anomaly_resistance = .4,
	faction = FACTION_NEBO,
	exoskeleton = true,
    appearance = {
        {
            mdl = {
"models/tnb/stalker/male_seva_cs4.mdl",
                    },
        skins = {10},    
        },
    }, 
unlockExperience = {		
id = "nebo",
amount = 3000,
},
experience = {
		id = "nebo",
			actions = 
			{
			["healing"] = 15,
			["sell_slave"] = 25,
   			["revive"] = 20,
   			["broom"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },	
})

TEAM_LEADERCH = rp.addTeam("Лидер ЧН", {
	color = Color(0, 191, 255),
	model = {"models/stalkertnb/cs2_vivid.mdl"},
	description = [[
Лидер группировки, главный на территории базы и её округи. Тебе часто приходится ходить на переговоры, договариваться о снабжении и составлять стратегии ведения войны.

• Будь впереди всех перестрелок и баталий; 
• Организация и координация всех действий ЧН; 
• Налаживание отношений с другими группировками; 
• Принимай все меры для процветания группировки; 

Подчиняется: Лебедеву и Суслову.
Командует: Мастером ЧН и ниже.	

Получает опыт мастерства за:
- Сдачу пленных - 25;
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
	]],
	weapons = {"swb_val_shturm", "swb_psg1", "swb_uzi", "swb_baretta_single", "stalker_knife", "weapon_crowbar", "health_kit_best", "weapon_cuff_elastic"},
	command = "leaderch",
	salary = 20,
    armor = isNoDonate && 390 || 450,
    health = isNoDonate && 200 || 250,
    reversed = true,
	canDiplomacy = true,
	upgrader = {["officer_support"] = true, ["officer_supply"] = true},
    max = 1,
    canCapture = true,
    disableDisguise = true,
	spawns = nebo_spawns,
	faction = FACTION_NEBO,
	canCapture = true,
unlockExperience = {		
id = "nebo",
amount = 3500,
},
experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

TEAM_LEBEDEV = rp.addTeam("Лебедев", {
	color = Color(0, 191, 255),
	model = {
		"models/lebed.mdl"
	},
	description = [[
Основатель группировки Чистое Небо и легендарная личность в зоне. Его считали погибшим во время супер выброса, но судьба распорядилась его жизнью иначе.

• Будь впереди всех перестрелок и баталий; 
• Организация и координация всех действий ЧН; 
• Налаживание отношений с другими группировками; 
• Принимай все меры для процветания группировки; 

Подчиняется: Никому.
Командует: Мастером ЧН и ниже.   
	]],
	weapons = {"swb_aug_kekler", "swb_spas14", "swb_vss_kekler", "stalker_knife","health_kit_bad"},
	command = "lebedev",
	salary = 22,
	armor = isNoDonate && 420 || 485,
	health = isNoDonate && 200 || 250,
	max = 1,
    canDiplomacy = true,
	spawns = nebo_spawns,
	arrivalMessage = true,
	spawn_points = {},
	reversed = true,
	    disableDisguise = true,
	faction = FACTION_NEBO,
	upgrader = {["officer_support"] = true, ["officer_supply"] = true},
	canCapture = true,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('lebedev', ply) end,
    canCapture = true,
    experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})


TEAM_SKAR = rp.addTeam("Шрам", {
	color = Color(0, 191, 255),
	model = {
		"models/player/stalker/compiled 0.34/scarsunrise.mdl", "models/player/stalker/compiled 0.34/coprookiemain2.mdl"
	},
	description = [[
Легендарный Наемник! О нем лишь можно было услышать в рассказах Чистого Неба. Возможно он был как-то связан с ними?

• Выполняй заказы из собственных интересов; 
• Налаживание отношений с другими группировками; 
• Не попадайся на глаза, ведь много людей ищут тебя; 
Это лишь малость того, чем вы можете заняться! 

(Одиночка / Наемник / Мастер Чистого Неба) 
	]],
	weapons = {"swb_priboy", "swb_beretta_kekler", "stalker_knife", "weapon_cuff_elastic"},
	command = "skar",
	salary = 17,
	hitman = true,
	armor = isNoDonate && 400 || 450,
	max = 1,
	health = isNoDonate && 200 || 250,
	unlockPrice = 25000,
    unlockTime = 365*3600,
    reversed = true,
	spawns = nebo_spawns,
	faction = FACTION_NEBO,
	canCapture = true,
    disableDisguise = true,
	appearance = {
		{
			mdl        = "models/player/stalker/compiled 0.34/scarsunrise.mdl",
			skins      = {0,11},
			bodygroups = {
				[1] = nil,
				[2] = {0,1,3,5,6},
				[3] = {0,1,2,3,4},
				[4] = {0,1,2}
			}
		},
		{
			mdl        = "models/player/stalker/compiled 0.34/coprookiemain2.mdl",
			skins      = {0,1},
			bodygroups = {
				[1] = nil,
				[2] = {0},
				[3] = {0,1,2,3,4},
				[4] = {0,1,2}
			}
		}
	},
	experience = {
		id = "nebo",
			actions = 
			{
   			["revive"] = 20,
   			["sell_slave"] = 25,
   			["sell_vendor"] = {["Ученый ЧН"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25},
    	},
  },
})

if !isNoDonate then 
TEAM_NEBOZ = rp.addTeam("Ветеран ЧН", {
	color = Color(0, 191, 255),
	model = {
		"models/tnb/stalker/male_cs4.mdl"
	},
	description = [[
	]],
	weapons = {"door_ram"},
	command = "newboz",
	salary = 10,
	armor = 300,
	spawns = nebo_spawns,
	faction = FACTION_NEBO,
	customCheck = function(ply) return rp.PlayerHasAccessToCustomJob({'neboz'}, ply:SteamID64()) or ply:IsRoot() end,
    disableDisguise = true,
    appearance =
    {
        {mdl = "models/tnb/stalker/male_cs4.mdl",
          skins       = {2},
        },
    },
})

	TEAM_DONAT2 = rp.addTeam('Проводник Ликвидаторов', {
		color = Color(104, 94, 0),
		model = 'models/tnb/stalker/male_cs2.mdl',
		description = [[
		Удачного дня.
		]],
		weapons = {'swb_ak103', "swb_p99"},
		customCheck = function(ply) return rp.PlayerHasAccessToCustomJob({'Donat2'}, ply:SteamID64()) or ply:IsRoot() end,
		command = 'Donat2',
		salary = 10,
		armor = 300,
		faction = FACTION_NEBO,
		disableDisguise = true,
		appearance =
		{
				{mdl = "models/tnb/stalker/male_cs2.mdl",
         	 skins       = {0,2},
        	},
    	},
	})
	end

TEAM_SUSLOV = rp.addTeam("Суслов", {
	color = Color(0, 191, 255),
	model = {
		"models/stalkertnb2/cs1_lone.mdl"
	},
	description = [[
	]],
	weapons = {"weapon_art_buyer", "stalker_knife", "swb_browning"},
	command = "suslov",
	salary = 10,
	armor = 100,
	unlockPrice = 10000000,
    unlockTime = 1000*3600,
	spawns = nebo_spawns,
	faction = FACTION_NEBO,
	max = 1,
})

rp.AddRelationships(TEAM_NEBOLR, RANK_TRAINER, {FACTION_NEBO})
rp.AddRelationships(TEAM_NEBOG, RANK_LEADER, {FACTION_NEBO})
rp.AddRelationships(TEAM_LEBEDEV, RANK_LEADER, {FACTION_NEBO})
rp.AddRelationships(TEAM_LEADERCH, RANK_LEADER, {FACTION_NEBO})
rp.AddRelationships(TEAM_PROFESSOR_CH, RANK_LEADER, {FACTION_NEBO})
rp.AddRelationships(TEAM_UCHENIY_HN, RANK_OFFICER, {FACTION_NEBO})

--rp.AddDoorGroup('ЧН', rp.GetFactionTeams(FACTION_NEBO))
--rp.addGroupChat(unpack(rp.GetFactionTeams(FACTION_NEBO)))
rp.SetFactionVoices({FACTION_NEBO}, { 
	{ 
		label = 'Слушаю', 
		sound = 'csky/meet_comander_start_3.wav', 
		text = 'Я тебя слушаю',
	},
	{ 
		label = 'Чего тебе?', 
		sound = 'csky/meet_hello_4.wav', 
		text = 'Чего тебе?',
	},
	{ 
		label = 'В атаку!', 
		sound = {'csky/attack_1.wav', 'csky/attack_2.wav', 'csky/attack_3.wav'},
		text = 'В атаку!!!',
	},
	{ 
		label = 'Бей ублюдков', 
		sound = 'csky/attack_many_3.wav', 
		text = 'Бей ублюдков!!!',
	},
	{ 
		label = 'Не стой', 
		sound = 'csky/backoff_3.wav', 
		text = 'Не стой тут, уходи',
	},
	{ 
		label = 'На те', 
		sound = 'csky/backup_4.wav', 
		text = 'На те в борщ!!!',
	},
	{ 
		label = 'Прикрою', 
		sound = 'csky/cover_fire_5.wav', 
		text = 'Прикрою, носа не высунет!',
	},
	{ 
		label = 'Прикрой', 
		sound = 'csky/detour_1.wav', 
		text = 'Прикрой меня!',
	},
	{ 
		label = 'Враг!', 
		sound = {'csky/enemy_5.wav', 'csky/enemy_6.wav' },
		text = 'Враг!',
	},
	{ 
		label = 'Допрыгался', 
		sound = 'csky/enemy_down_4.wav', 
		text = 'Опа, всё допрыгался!',
	},
	{ 
		label = 'Убери оружие', 
		sound = {'csky/meet_hide_weapon_1.wav', 'csky/meet_hide_weapon_3.wav'},
		text = 'Убери оружие',
	},
	{ 
		label = 'Не стреляй', 
		sound = 'csky/panic_human_4.wav', 
		text = 'Мужик не стреляй!',
	},
	{ 
		label = 'Отбой', 
		sound = 'csky/relax_3.wav', 
		text = 'Всё, отбой',
	},
	{ 
		label = 'Ты покойник', 
		sound = 'csky/threat_close_5.wav', 
		text = 'Ты покойник!',
	},
	{ 
		label = 'Я доберусь', 
		sound = 'csky/threat_distant_3.wav', 
		text = 'Уш я до тебя доберусь!',
	},
	{ 
		label = 'Ждём', 
		sound = {'csky/wait_2.wav', 'csky/wait_5.wav'},
		text = 'Ждём',
	},
})
    local speed = rp.cfg.RunSpeed
	local team_NumPlayers = team.NumPlayers 
	hook.Add("PlayerLoadout", function(ply) 
	if (ply:GetFaction() == FACTION_NEBO) && team_NumPlayers(TEAM_TEXNEBO) > 0 then 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('TexBoost'))
		ply:GiveArmor(20)
		ply:AddAnomalyResistance(0.15)	
		ply:GiveAmmo(180, "smg1")
		ply:GiveAmmo(210, "ar2")
		ply:GiveAmmo(60, "Buckshot")				 
		end 
	if (ply:GetFaction() == FACTION_NEBO) && team_NumPlayers(TEAM_SKAR) > 0 then 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('LiderSkyBoost')) 
		ply:SetRunSpeed(speed * 1.2)
		ply:AddHealth(20)		 
		end
	end)
--rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_NEBO}))

local NEBO_Experiences = {
    [0]      = 1,
    [500]   = 2,
    [1000]   = 3,
    [1500]   = 4,
    [2000]   = 5,
    [2500]   = 6,
    [3000]   = 7,
    [3500]   = 8,
};

local NEBO_Levels = {
    [1]  = 0,
    [2]  = 500,
    [3]  = 1000,
    [4]  = 1500,
    [5]  = 2000,
    [6]  = 2500,
    [7]  = 3000,
    [8]  = 3500,
};

rp.Experiences:GetExperienceType( "nebo" )
    :SetPrintName( "ЧН" )
    :SetLevelFormula( function( v, reverse )
        if reverse then
            local keys = table.GetKeys( NEBO_Levels );
            table.sort( keys );

            local exp = 0;

            for k, level in ipairs( keys ) do
                if level > v then break end
                exp = NEBO_Levels[level];
            end

            return exp;
        end

        --

        local keys = table.GetKeys( NEBO_Experiences );
        table.sort( keys );

        local lv = 0;

        for k, experience in ipairs( keys ) do
            if experience > v then break end
            lv = NEBO_Experiences[experience];
        end

        return lv;
    end )
    	:SetLevelRewards( 1, "Профессия: Разведчик ЧН"  )
    	:SetLevelRewards( 2, "Профессия: Суслов" )
    	:SetLevelRewards( 3, "Профессия: Старший Ученый ЧН" )
   		:SetLevelRewards( 4, "Профессия: Штурмовик ЧН" )
   		:SetLevelRewards( 5, "Профессия: Мастер ЧН" )
   		:SetLevelRewards( 6, "Профессия: Проффесор ЧН" )
   		:SetLevelRewards( 7, "Профессия: Лидер ЧН" )

*/