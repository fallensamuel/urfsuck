-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\eventnebo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  eventnebo_spawns = {
rp_limanskhospital_urfim = {Vector(962, 11305, 87), Vector(865, 11200, 53), Vector(882, 11023, 40), Vector(882, 11023, 40), Vector(650, 11115, 48)},
}

TEAM_EVENTNEBOONE = rp.addTeam("Боец ЧН", {
    color = Color(0, 191, 255),
    model = "models/player/stalker_nebo/nebo_gp5/nebo_gp5.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_fort", "tfa_anomaly_mp7", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventneboone",
    spawn_points = {},
    max = 0,
    reversed = true,
    spawns = eventnebo_spawns,
    faction = FACTION_EVENTNEBO,
    armor = 100,
    anomaly_resistance = .1,      
})

TEAM_EVENTNEBOTWO = rp.addTeam("Снайпер ЧН", {
    color = Color(0, 191, 255),
    model = "models/player/stalker_nebo/nebo_seva/nebo_seva.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_svd", "tfa_anomaly_beretta", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventnebotwo",
    spawn_points = {},
    max = 5,
    reversed = true,
    health = 100,
    spawns = eventnebo_spawns,
    faction = FACTION_EVENTNEBO,
    armor = 175,   
})

TEAM_EVENTNEBOTREE = rp.addTeam("Пулеметчик ЧН", {
    color = Color(0, 191, 255),
    model = "models/player/stalker_nebo/nebo_sunrise_proto/nebo_sunrise_proto.mdl",
    description = [[
Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_rpk", "tfa_anomaly_colt1911", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventnebotree",
    max = 3,
    spawns = eventnebo_spawns,
    spawn_points = {},
    faction = FACTION_EVENTNEBO,
    armor = 235,
    health = 100,
    reversed = true,
    exoskeleton = true,
    canCapture = true,        
})

TEAM_EVENTNEBOFOUR = rp.addTeam("Штурмовик ЧН", {
    color = Color(0, 191, 255),
    model = {'models/player/stalker_nebo/nebo_bulat/nebo_bulat.mdl'},
    description = [[
    Ивент профессия. 
    ]],
    weapons = {"tfa_anomaly_ak101", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat" },
    salary = 0,
    command = "eventnebofour",
    max = 2,
    spawns = eventNEBO_spawns,
    faction = FACTION_EVENTNEBO,
    reversed = true,
    armor = 300,  
    speed = 1.1,
    canCapture = true,
})

TEAM_EVENTNEBOFIVE = rp.addTeam("Подрывник ЧН", {
    color = Color(0, 191, 255),
    model = "models/player/stalker_nebo/nebo_exo/nebo_exo.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_ak101", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat", "tfa_anomaly_f1", "tfa_anomaly_rgd5"},
    salary = 0,
    command = "eventnebofive",
    max = 1,
    spawns = eventnebo_spawns,
    spawn_points = {},
    faction = FACTION_EVENTNEBO,
    reversed = true,
    armor = 300,
    canCapture = true,
    exoskeleton = true,
    forceLimit = true,     
})

rp.SetFactionVoices({FACTION_EVENTNEBO}, { 
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
  