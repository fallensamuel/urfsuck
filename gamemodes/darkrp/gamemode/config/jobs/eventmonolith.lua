-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\eventmonolith.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  eventmonolith_spawns = {
rp_limanskhospital_urfim = {Vector(-578, -836, 51), Vector(-368, -802, 36), Vector(-460, -680, 30), Vector(-321, -645, 38), Vector(-179, -710, 65), Vector(-428, -1135, 65)},
}

TEAM_EVENTMONONE = rp.addTeam("Боец Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_gp5/monolith_gp5.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_fort", "tfa_anomaly_mp5sd", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventmonone",
    spawn_points = {},
    max = 0,
    reversed = true,
    spawns = eventmonolith_spawns,
    faction = FACTION_EVENTMONOLITH,
    armor = 100,
    anomaly_resistance = .1,    
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_gp5/monolith_gp5.mdl"},
    skins = {0,1},
}, 
},   
})

TEAM_EVENTMONTWO = rp.addTeam("Снайпер Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_seva/monolith_seva.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_sv98", "tfa_anomaly_beretta", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventmontwo",
    spawn_points = {},
    max = 5,
    reversed = true,
    health = 100,
    spawns = eventmonolith_spawns,
    faction = FACTION_EVENTMONOLITH,
    armor = 175,   
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_seva/monolith_seva.mdl"},
    skins = {0,1},
},  
},
})

TEAM_EVENTMONTREE = rp.addTeam("Пулеметчик Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_old/monolith_old.mdl",
    description = [[
Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_pkm", "tfa_anomaly_colt1911", "tfa_anomaly_knife_combat"},
    salary = 0,
    command = "eventmontree",
    max = 3,
    spawns = eventmonolith_spawns,
    spawn_points = {},
    faction = FACTION_EVENTMONOLITH,
    armor = 235,
    health = 100,
    reversed = true,
    exoskeleton = true,
    canCapture = true,  
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_old/monolith_old.mdl"},
    skins = {0,1,2,3},
},
},       
})

TEAM_EVENTMONFOUR = rp.addTeam("Штурмовик Монолита", {
    color = Color(23, 130, 130),
    model = {'models/player/stalker_monolith/monolith_bulat_proto/monolith_bulat_proto.mdl'},
    description = [[
    Ивент профессия. 
    ]],
    weapons = {"tfa_anomaly_fn2000", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat" },
    salary = 0,
    command = "eventmonfour",
    max = 2,
    spawns = eventmonolith_spawns,
    faction = FACTION_EVENTMONOLITH,
    reversed = true,
    armor = 300,  
    canCapture = true,
    speed = 1.1,
})

TEAM_EVENTMONFIVE = rp.addTeam("Подрывник Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_exo/monolith_exo.mdl",
    description = [[ 
    Ивент профессия.
    ]],
    weapons = {"tfa_anomaly_fn2000", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat", "tfa_anomaly_f1", "tfa_anomaly_rgd5"},
    salary = 0,
    command = "eventmonfive",
    max = 1,
    spawns = eventmonolith_spawns,
    spawn_points = {},
    faction = FACTION_EVENTMONOLITH,
    reversed = true,
    armor = 300,
    canCapture = true,
    exoskeleton = true,
    forceLimit = true,
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_exo/monolith_exo.mdl"},
    skins = {0,2,4},
    bodygroups = {
        [1] = {0},
    },
        },
},      
})

--rp.AddRelationships(TEAM_HARON, RANK_LEADER, {FACTION_EVENTMONOLITH})
--rp.AddRelationships(TEAM_SUPERVISOR, RANK_LEADER, {FACTION_EVENTMONOLITH})
--rp.AddRelationships(TEAM_INKV, RANK_OFFICER, {FACTION_EVENTMONOLITH})
--rp.AddRelationships(TEAM_SNIPMONOL, RANK_OFFICER, {FACTION_EVENTMONOLITH})

--rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_EVENTMONOLITH})))
--rp.AddDoorGroup('Монолит', rp.GetFactionTeams(FACTION_EVENTMONOLITH))
rp.SetFactionVoices({FACTION_EVENTMONOLITH}, { 
    { 
        label = 'Проповедь', 
        sound = 'monolite/propoved.wav', 
        text = '*Говорит проповедь монолита*',
    },
    { 
        label = 'Иди!', 
        sound = 'monolite/idi.wav', 
        text = 'Иди!',
    },
    { 
        label = 'Противник!', 
        sound = {'monolite/protivnik.wav', 'monolite/protivnik2.wav', 'monolite/protivnik3.wav'},
        text = 'Противник!',
    },
    { 
        label = 'Вперёд!', 
        sound = 'monolite/v_ataku.wav', 
        text = 'Вперёд братья!!!',
    },
    { 
        label = 'Веду бой', 
        sound = {'monolite/boi.wav', 'monolite/boi2.wav'},
        text = 'Веду бой',
    },
    { 
        label = 'Искореним', 
        sound = 'monolite/iskorenim.wav', 
        text = 'Искореним врагов монолита',
    },
    { 
        label = 'Обнаружить', 
        sound = 'monolite/obnar.wav', 
        text = 'Обнаружить и искоренить',
    },
    { 
        label = 'Получай', 
        sound = 'monolite/poluchi.wav', 
        text = 'Получай слепец!',
    },
    { 
        label = 'Я попал', 
        sound = 'monolite/popal.wav', 
        text = 'Я попал в него',
    },
    { 
        label = 'Ты ликвидирован', 
        sound = 'monolite/ti_likvidir.wav', 
        text = 'Ты будешь ликвидирован!',
    },
    { 
        label = 'Защищаю', 
        sound = 'monolite/zashit.wav', 
        text = 'Я буду защищать!' 
    },
    { 
        label = 'Помогите мне!', 
        sound = 'monolite/pamag.wav', 
        text = 'Помогите мне!!!' 
    },
    { 
        label = 'Монолит помоги', 
        sound = 'monolite/monolit_pomogi.wav', 
        text = 'Монолит, помоги мне.',
    },
    { 
        label = 'Монолит это', 
        sound = 'monolite/monolit.wav', 
        text = 'Монолит это свет и знание,знание и свет.' 
    },
    { 
        label = 'Молитвы', 
        sound = {'monolite/mi_plak.wav', 'monolite/mi_zhdem.wav', 'monolite/ostav.wav'},
        text = '*Молятся монолиту*' 
    }
})
