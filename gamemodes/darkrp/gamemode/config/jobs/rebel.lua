-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\rebel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local empty = {}
local  rebel_spawns = {
rp_stalker_urfim_v3 = {Vector(-14614, 4726, -3824), Vector(-14766, 4735, -3824), Vector(-14911, 4723, -3824), Vector(-14142, 4374, -3824), Vector(-14380, 4372, -3824),},
rp_pripyat_urfim = {Vector(-1724, -12354, 32), Vector(-2046, -12326, 32), Vector(-1889, -12440, 32)},
rp_stalker_urfim = {Vector(-8818, -4344, -4), Vector(-8818, -4444, -5), Vector(-8710, -4444, -4), Vector(-8710, -4356, -4)},
rp_st_pripyat_urfim = {Vector(5608, -2246, 32), Vector(6127, -2231, 32)},
}

local  rebel2_spawns = {
rp_stalker_urfim_v3 = {Vector(2163, -5983, -3824)},
}

rp.addTeam("Поц", {
    color = Color(100, 117, 109),
    model = "models/player/stalker_bandit/bandit_jacket/bandit_jacket.mdl",
    description = [[
Недавно примкнувший к бандитам ровный пацан, который ещё с большой земли занимался мелким воровством. Брат за брата- такое за основу взято!

• Исполняй все порученные дела, даже если тебе в лом;
• Щими лохов и организовывай движуху;
• Помогай братве, особенно если это кто-то из авторитетов;
Это лишь малость того, чем вы можете заняться!

Командует: Никем, а ты что думал?
Подчиняется: Кого в авторитете держишь с тем и двигайся.
    ]],
    weapons = {"tfa_anomaly_hpsa", "tfa_anomaly_bm16","pickpocket"},
    salary =6,
    command = "rebel1",
    spawns = rebel_spawns,
    spawn_points = {},
    armor = 100,    
    faction = FACTION_REBEL,    
appearance = {
    {mdl = {"models/player/stalker_bandit/bandit_jacket/bandit_jacket.mdl"},
    skins = {0,1,2},
    bodygroups = {
        [1] = {0,1},
    },
},  
},
    slavePrice = 150, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции      
})

TEAM_REBEL_PROH = rp.addTeam("Бывалый", {
    color = Color(100, 117, 109),
    model = {'models/player/stalker_bandit/bandit_gear/bandit_gear.mdl'},
    description = [[
Ты стал на одну ступень выше к старшим авторитетам Зоны, но всё ешё пытаешься заслужить их почёта и уважения.

• Запрягайся с братвой на всякие движухи;
• Продвигайся и не забывай о пацанах;
• Набирайся опыта у старших;
Это лишь малость того, чем вы можете заняться!

Командует: Никем, а ты что думал?
Подчиняется: Атаману и старше.
    ]],
    weapons = {"tfa_anomaly_hpsa", "tfa_anomaly_mp5_nimble","pickpocket"},
    salary =8,
    command = "rebel2",
    spawns = rebel_spawns,
    spawn_points = {},
    armor = 130,    
    faction = FACTION_REBEL,
    slavePrice = 200, 
    slaveJailTime = 60,
    unlockPrice = 1000,
    unlockTime = 10*3600,
    appearance = {
    {mdl = {"models/player/stalker_bandit/bandit_gear/bandit_gear.mdl"},
    skins = {0,1},
    bodygroups = {
        [1] = {0,1},
    },
},
},
})

TEAM_REBEL_CAPTAIN = rp.addTeam("Пахан", {
    color = Color(100, 117, 109),
    model = {'models/player/stalker_bandit/bandit_cloak/bandit_cloak.mdl'},
    description = [[
- Нихуя себе, кого вижу, говорит басяк при виде тебя, ведь твои слова уже имеют вес и ты можешь крышовать поцов. 

• В падлу впрячься за пацанов;
• Щими лохов и организовывай движуху;
• Помогай братве, продвигай пацанов;
• Организовывай банды и обеспечь пацанов;
Это лишь малость того, чем вы можете заняться!

Командует: Кого подомнешь, теми и будешь крутить.
Подчиняется: Атаману и старше.
    ]],
    weapons = {"tfa_anomaly_ak74", "tfa_anomaly_tt33","pickpocket"},
    salary = 9,
    command = "rebel5",
    spawns = rebel_spawns,
    spawn_points = {},
    faction = FACTION_REBEL,
    unlockPrice = 3500,
    unlockTime = 35*3600,
    armor = 150,
    max = 5, 
appearance = {
    {mdl = {"models/player/stalker_bandit/bandit_cloak/bandit_cloak.mdl"},
    skins = {0,1},
    bodygroups = {
        [1] = {0},
        [2] = {0},
    },
        },
},
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции     
})

TEAM_REBEL_VETERAN = rp.addTeam("Атаман", {
    color = Color(100, 117, 109),
    model = {'models/player/stalker_bandit/bandit_guard/bandit_guard.mdl'},
    description = [[
Уважаемый всеми вор, пересидевший по тюрьмам большую часть жизни. Смотрящий за братвой и главный следящий за общаком.

• Собирай с братвы на общак;
• Щими лохов и организовывай движуху;
• Помогай братве, продвигай пацанов;
• Организовывай банды и обеспечь пацанов;
Это лишь малость того, чем вы можете заняться!

Командует: Пахан и ниже.
Подчиняется: Султану и Борову.  
    ]],
    weapons = {"tfa_anomaly_ppsh41", "tfa_anomaly_toz34", "tfa_anomaly_knife","pickpocket"},
    salary = 12,
    command = "rebel6",
    spawns = rebel_spawns,
    spawn_points = {},
    faction = FACTION_REBEL,
    armor = 215,
    unlockPrice = 7500,
    unlockTime = 75*3600,
    armor = 210,
    max = 4, 
    appearance = 
    {
        {mdl = "models/player/stalker_bandit/bandit_guard/bandit_guard.mdl",
          skins       = {0,1},
           bodygroups = {
                [1] = {0,1,2,3,4},
                [2] = {0,1,2},
            }
        },
    },
    canCapture = true,
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции   
})

TEAM_BRIGADIR = rp.addTeam("Бригадир", {
    color = Color(100, 117, 109),
    model = {'models/player/stalker_bandit/bandit_exo/bandit_exo.mdl'},
    description = [[
Ты правая рука Борова, делишь общак и управляешь бригадой. Султан доверяет тебе самые ответственные дела братвы. 
    
• Щими лохов и организовывай движуху;
• Будь первым охранником Султана;
• Участвуй во всех перестрелках;
Это лишь малость того, чем вы можете заняться!

Командует: Атаман и ниже.
Подчиняется: Султану.  
    ]],
    weapons = {"tfa_anomaly_hpsa", "tfa_anomaly_f1", "tfa_anomaly_spas12", "tfa_anomaly_rgd5","pickpocket"},
    salary = 16,
    command = "brigadir",
    max = 2,
    forceLimit = true,
    spawns = rebel_spawns,
    spawn_points = {},
    faction = FACTION_REBEL,
    unlockPrice = 17500,
    unlockTime = 175*3600,
    canDiplomacy = true,
    armor = 340,
    speed = 1.1,
    canCapture = true,
    exoskeleton = true,
    appearance = 
    {
        {mdl = "models/player/stalker_bandit/bandit_exo/bandit_exo.mdl",
          skins       = {0,1,2},
           bodygroups = {
                [1] = {0,1,2},
            }
        },
    },
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 90, -- Время заключения для пленника этой профы / фракции   
})

TEAM_SULTAN = rp.addTeam("Султан", {
    color = Color(100, 117, 109),
    model = {'models/player/stalker_bandit/bandit_bulat_proto/bandit_bulat_proto.mdl'},
    description = [[
Ты один из главных авторитетов в Зоне, почти каждый бандит зоны готов пойти за тобой сквозь огонь и воду. Тут уже от твоих слов никто не может отказаться.
Так же Султан может устраивать азартные игры с помощью команды /lottery (от 500 до 50 000) 

• Собирай с братвы на общак;
• Щими лохов и организовывай движуху;
• Помогай братве, продвигай пацанов;
• Организовывай банды и обеспечь пацанов;
Это лишь малость того, чем вы можете заняться!

Командует: Бригадир и ниже.
Подчиняется: никому.   

    ]],
    weapons = {"tfa_anomaly_protecta", "tfa_anomaly_mp5_nimble", "guitar_stalker", "tfa_anomaly_desert_eagle","pickpocket"},
    salary = 17,
    command = "sultan",
    max = 1,
    spawns = rebel_spawns,
    spawn_points = {},
    faction = FACTION_REBEL,
    unlockPrice = 22000,
    CanConfiscate = true,
    reversed = true,
    unlockTime = 225*3600, --250
    canDiplomacy = true,
    armor = 300,
    speed = 1.1,
    upgrader = {["officer_support"] = true},
    canCapture = true,
    disableDisguise = true,
    CanStartLottery = true,
    slavePrice = 400, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 120, -- Время заключения для пленника этой профы / фракции   
})

/*
TEAM_BOROV = rp.addTeam("Боров", {
    color = Color(100, 117, 109),
    model = {"models/player/stalker/compiled 0.34/borov.mdl"},
    description = [[
Самый главный и авторитетный в братве. Пролил не мало крови, чтобы добиться вершин! Не зря ты проделал такой путь.

• Собирай с братвы на общак;
• Щими лохов и организовывай движуху;
• Помогай братве, продвигай пацанов;
• Организовывай банды и обеспечь пацанов;
Это лишь малость того, чем вы можете заняться!

Командует: Бригадир и ниже.
    ]],
    weapons = {"swb_ak74su_gold", "swb_winchester", "m9k_machete", "weapon_ciga_pachka", "guitar_stalker", "swb_deagle_gold","pickpocket"},
    salary = 19,
    command = "borov",
    reversed = true,
    max = 1,
    spawns = rebel_spawns,
    spawn_points = {},
    faction = FACTION_REBEL,
    CanConfiscate = true,
    canDiplomacy = true,
    arrivalMessage = true,
    upgrader = {["officer_support"] = true},
    armor = isNoDonate && 500 || 550,
    customCheck = function(ply) return ply:HasUpgrade('borov') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() end,
    canCapture = true,
    disableDisguise = true,
    slavePrice = 500, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 120, -- Время заключения для пленника этой профы / фракции   
})*/


rp.SetFactionVoices({FACTION_REBEL}, { 
    { 
        label = 'Привет', 
        sound = 'bandit/tipo_priv.wav', 
        text = 'Ну типо привет',
    },
    { 
        label = 'Отвали!', 
        sound = 'bandit/otvali.wav', 
        text = 'Отвали!',
    },
    { 
        label = 'Заныкал волыну', 
        sound = 'bandit/volina.wav', 
        text = 'Заныкал волыну быренько',
    },
    { 
        label = 'Вали на хрен!', 
        sound = 'bandit/vali_nahren.wav', 
        text = 'Вали на хрен!',
    },
    { 
        label = 'Ты труп!', 
        sound = 'bandit/ti_trup.wav', 
        text = 'Бычара, ты труп, ты понял?!',
    },
    { 
        label = 'Атас!', 
        sound = 'bandit/atas.wav', 
        text = 'Пацаны, атас!!',
    },
    { 
        label = 'Ныкайся!', 
        sound = 'bandit/nikaisya.wav', 
        text = 'Ныкайся ныкайся пацаны!',
    },
    { 
        label = 'От сучара!', 
        sound = 'bandit/suchara.wav', 
        text = 'От сучааара!',
    },
    { 
        label = 'Мля маслина', 
        sound = 'bandit/mlya.wav', 
        text = 'Мляяя, я маслину поймал!',
    },
    { 
        label = 'Вали!', 
        sound = 'bandit/vali_pet.wav', 
        text = 'Вали петушаааар!',
    },
    { 
        label = 'Чики брики', 
        sound = 'bandit/chiki.wav', 
        text = 'А ну, чики брики и в дамки!',
    },
    { 
        label = 'Пацанов валят!', 
        sound = 'bandit/pacanov.wav', 
        text = 'Пацанов валят!',
    },
    { 
        label = 'Веселее!', 
        sound = 'bandit/veselee.wav', 
        text = 'Каньдёхаем веселее!',
    },
    { 
        label = 'Ахаха', 
        sound = 'bandit/chertila.wav', 
        text = '*Ржёт* Чертыла в натуре чертыла',
    },
    { 
        label = 'Всосали', 
        sound = 'bandit/vsosali.wav', 
        text = 'Пришли и всосали *Ржёт*',
    },
})

--rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_REBEL, FACTION_REBELVIP}))