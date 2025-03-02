-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\monolith.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  monolith_spawns = {
rp_stalker_urfim_v3 = {Vector(-5374, 2729, -4128), Vector(-5361, 2403, -4128)},
rp_pripyat_urfim = {Vector(2060, 14767, 32), Vector(2018, 14504, 32), Vector(2292, 14645, 32)},
rp_stalker_urfim = {Vector(577, 3066, -869), Vector(526, 3068, -869), Vector(437, 3072, -873)},
rp_st_pripyat_urfim = {Vector(-3104, 11570, 128), Vector(-2684, 11582, 128)}
}

TEAM_OSEP = rp.addTeam("Неофит Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_gp5/monolith_gp5.mdl",
    description = [[ Ты неофит секты Монолита. Ты пока только узнаешь про его мощь.
    Уничтожай всех кто хочет опровергнуть факт силы Монолита.
    ]],
    weapons = {"tfa_anomaly_fort", "tfa_anomaly_mp5sd", "tfa_anomaly_knife_combat"},
    salary = 7,
    command = "osep",
    spawn_points = {},
    max = 5,
    reversed = true,
    spawns = monolith_spawns,
    faction = FACTION_MONOLITH,
    armor = 130,
    anomaly_resistance = .1,    
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_gp5/monolith_gp5.mdl"},
    skins = {0,1},
}, 
},   
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_GSEP = rp.addTeam("Адепт Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_seva/monolith_seva.mdl",
    description = [[ Ты Адепт секты Монолита. Заставь всех поверить в него.
    Уничтожай всех кто хочет опровергнуть факт мощи Монолита.
    ]],
    weapons = {"tfa_anomaly_fn2000", "tfa_anomaly_beretta", "tfa_anomaly_knife_combat"},
    salary = 8,
    command = "gsep",
    spawn_points = {},
    max = 3,
    reversed = true,
    health = 110,
    spawns = monolith_spawns,
    faction = FACTION_MONOLITH,
    unlockTime = 25*3600, --75
    armor = 170,
    unlockPrice = 2500,
    anomaly_resistance = .15,    
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_seva/monolith_seva.mdl"},
    skins = {0,1},
},  
},
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_ASEP = rp.addTeam("Проповедник Монолита", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_old/monolith_old.mdl",
    description = [[
Ты проповедник монолита. Защити монолит и заставь всех поклонятся ему.
    ]],
    weapons = {"tfa_anomaly_svu", "tfa_anomaly_groza_nimble", "tfa_anomaly_colt1911", "tfa_anomaly_knife_combat", "tfa_anomaly_f1"},
    unlockPrice = 50000,
    salary = 11,
    command = "asep",
    max = 1,
    spawns = monolith_spawns,
    spawn_points = {},
    faction = FACTION_MONOLITH,
    unlockTime = 155*3600, --250
    armor = 220,
    health = 150,
    unlockPrice = 9500,
    --vip = true,
    reversed = true,
    upgrader = {["officer_support"] = true},
    exoskeleton = true,
    canCapture = true,
    anomaly_resistance = .2,    
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_old/monolith_old.mdl"},
    skins = {0,1,2,3},
},
},
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции       
})

TEAM_INKV = rp.addTeam("Истязатель Монолита", {
    color = Color(23, 130, 130),
    model = {'models/player/stalker_monolith/monolith_bulat_proto/monolith_bulat_proto.mdl'},
    description = [[Ты Истязатель Монолита, 
    прошедший крещение огнем и кровью ветеран своей группировки, 
    ты вырезал столько неверных что тебя боятся все сталкеры ЧЗО. 
    Очисти Зону от сталкерской грязи во имя Монолита! 
    ]],
    weapons = {"tfa_anomaly_protecta", "tfa_anomaly_lr300", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat" },
    salary = 15,
    command = "inkv",
    max = 2,
    spawns = monolith_spawns,
    spawn_points = {},
    faction = FACTION_MONOLITH,
    canDiplomacy = true,
    reversed = true,
    --unlockTime = 335*3600, --400
    customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('inkv', ply) end,
    armor = 400,
    health = 150,
    vip = true,
    anomaly_resistance = .2,    
    canCapture = true,
    slavePrice = 350, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 100, -- Время заключения для пленника этой профы / фракции  
})

TEAM_PREMBAST = rp.addTeam("Бастион", {
    color = Color(23, 130, 130),
    model = {"models/stalker_monolith/stalker_monolith_4_proto.mdl"},
    description = [["Бастион" известен так же как непробиваемый командир монолита, поговаривают что даже мертвым он не ступит ни шагу назад. 

    Очисти Зону от сталкерской грязи во имя Монолита! 
    ]],
    weapons = {"tfa_anomaly_protecta", "tfa_anomaly_m249", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat"},
    salary = 17,
    command = "prembast",
    max = 1,
    spawns = monolith_spawns,
    spawn_points = {},
    faction = FACTION_MONOLITH,
    canDiplomacy = true,
    reversed = true,
    PlayerSpawn = function(ply) ply:SetRunSpeed(260) ply:SetWalkSpeed(140) end,
    --unlockTime = 335*3600, --400
    armor = 450,
    health = 100,
    anomaly_resistance = .2,  
    scaleDamage = 0.70,  
    canCapture = true, 
    customCheck = function(ply) return (ply:IsRoot() or rp.PlayerHasAccessToJob('prembast', ply)) end,
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 90, -- Время заключения для пленника этой профы / фракции  
    forceLimit = true,
})

TEAM_HARON = rp.addTeam("Харон", {
    color = Color(23, 130, 130),
    model = "models/player/stalker_monolith/monolith_exo/monolith_exo.mdl",
    description = [[ Таинственный лидер «Монолита». 
    Несмотря на то, что, по имеющейся информации, он командует группировкой, этому нет подтверждения. 
    Харон не выходит на контакты с представителями других группировок Зоны
    ]],
    weapons = {"tfa_anomaly_gauss", "tfa_anomaly_fn2000", "tfa_anomaly_desert_eagle", "tfa_anomaly_knife_combat", "tfa_anomaly_rgd5", "health_kit_normal"},
    salary = 22,
    command = "haron",
    max = 1,
    spawns = monolith_spawns,
    spawn_points = {},
    faction = FACTION_MONOLITH,
    arrivalMessage = true,
    canDiplomacy = true,
    reversed = true,
    armor = 300,
    health = 200,
    canCapture = true,
    unlockTime = 375*3600,
    unlockPrice = 30000,
    exoskeleton = true,
    --vip = true,
    disableDisguise = true,
appearance = {
    {mdl = {"models/player/stalker_monolith/monolith_exo/monolith_exo.mdl"},
    skins = {0,2,4},
    bodygroups = {
        [1] = {0},
    },
        },
},  
    slavePrice = 500, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 360, -- Время заключения для пленника этой профы / фракции    
})

TEAM_SUPERVISOR = rp.addTeam("Воплощение Монолита", {
    color = Color(23, 130, 130),
    model = {"models/oso.mdl"},
    description = [[ Призрак, посланный самим Монолитом, наблюдающий за действиями группировки в зоне.
Имеет возможность слиться с духом монолита, чтобы обрести часть его сил.

Не вступает в контакт с представителями других группировок .
Может выходить с территории базы, но вербовать в монолит может только в пределах базы(Пси-вышек)
Не имеет право убивать кого либо.
    ]],
    weapons = {'keys'},
    salary = 16,
    command = "monolit",
    max = 1,
    reversed = true,
    spawns = monolith_spawns,
    spawn_points = {},
    faction = FACTION_MONOLITH,
    unlockTime = 100 * 3600,
    unlockPrice = 10000,
    PlayerSpawn = function(pl) pl:GodEnable(true) end,
    disableDisguise = true,
    build = false,
})

--rp.AddRelationships(TEAM_HARON, RANK_LEADER, {FACTION_MONOLITH})
--rp.AddRelationships(TEAM_SUPERVISOR, RANK_LEADER, {FACTION_MONOLITH})
--rp.AddRelationships(TEAM_INKV, RANK_OFFICER, {FACTION_MONOLITH})
--rp.AddRelationships(TEAM_SNIPMONOL, RANK_OFFICER, {FACTION_MONOLITH})

--rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_MONOLITH})))
--rp.AddDoorGroup('Монолит', rp.GetFactionTeams(FACTION_MONOLITH))
rp.SetFactionVoices({FACTION_MONOLITH}, { 
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

rp.SetTeamVoices(TEAM_SUPERVISOR, {
    {
        label = 'Цель здесь!',
        sound = 'monolith_disp/1.mp3',
        text = 'Твоя Цель Здесь!'
    },
    {
        label = 'Иди ко мне',
        sound = 'monolith_disp/2.mp3',
        text = 'Иди ко мне!'
    },
    {
        label = 'Вознагражден',
        sound = 'monolith_disp/3.mp3',
        text = 'Вознагражден будет только один!'
    },
    {
        label = 'Что заслуживаешь',
        sound = 'monolith_disp/4.mp3',
        text = 'Ты обретешь то, что заслуживаешь!'
    },
    {
        label = 'Желание',
        sound = 'monolith_disp/6.mp3',
        text = 'Твое желание скоро исполниться! Иди ко мне!'
    },
})


--rp.AddToRadioChannel({TEAM_GSEP, TEAM_AKOL, TEAM_ASEP, TEAM_RAZVEDMONOL, TEAM_INKV, TEAM_AGP, TEAM_SNIPMONOL, TEAM_SUPERVISOR, TEAM_HARON}, rp.GetFactionTeams(FACTION_MONOLITH))