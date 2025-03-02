-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\dolg.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  dolg_spawns = {
rp_stalker_urfim_v3 = {Vector(-4827, -7439, -3824), Vector(-4696, -7885, -3824)},
rp_pripyat_urfim = {Vector(-4237, -3400, 32), Vector(-3966, -3330, 32)},
rp_stalker_urfim = {Vector(10, -4888, 160), Vector(-569, -4876, 160)},
rp_st_pripyat_urfim = {Vector(4063, 4748, 160), Vector(3854, 4754, 160)},
}
TEAM_RCTDOLG = rp.addTeam('Рядовой ДОЛГа', {
    color = Color(128, 0, 0),
    model = 'models/player/stalker_dolg/dolg_jacket/dolg_jacket.mdl',
    description = [[
Только влился в ряды ДОЛГа. Мальчик на побегушках, пушечное мясо, гонец, обитатель КПП - это всё твои имена. Бегай по кругу на территории базы, охраняя склад, стой на КПП, перетаскивай водку с места на место и носи своих товарищей на себе. Работай, работай и ещё раз работай.

• Исполняй все приказы
• Веди себя достойно.
• Таскать водку - твоё призвание.
Защити мир от заразы зоны!

Командует: никем.
Подчиняется: Лейтенанту и выше
]],
    weapons = {"tfa_anomaly_knife_combat", "salute"},
    command = 'rctdolg',
    spawn_points = {},
    salary = 8,
    armor = 100,
    faction = FACTION_DOLG,
    spawns = dolg_spawns,
appearance = {
    {mdl = {"models/player/stalker_dolg/dolg_jacket/dolg_jacket.mdl"},
    skins = {0,1},
    bodygroups = {
        [1] = {0,1},
    },
},
},
        slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_RCTDOLG, "Стандартный", 0, {"tfa_anomaly_ak74u","tfa_anomaly_colt1911"})
 rp.AddJobArmory(TEAM_RCTDOLG, "Тяжелый", 15000, {"tfa_anomaly_mp133","tfa_anomaly_colt1911"})

TEAM_LTDOLG = rp.addTeam('Лейтенант ДОЛГа', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker_dolg/dolg_old/dolg_old.mdl'},
    description = [[
Младший офицер, готов отдать жизнь за одну лишь идею... Принимает участие в организации захватов и рейдов, подготавливает солдат для активной войны и обучит их азам стратегии.

• Организовывай массовые захваты.
• Объявляй и осуществляй рейды.
• Проводи инструктаж младшему составу.
Защити мир от заразы зоны!

Командует: Рядовыми.
Подчиняется: Капитану и выше.    
    ]],
    weapons = {"tfa_anomaly_knife_combat", "salute", "gmod_camera"},
    command = 'ltdolg',
    spawn_points = {},
    salary = 9,
    armor = 260 ,
    max = 2,
    forceLimit = true,
    faction = FACTION_DOLG,
    unlockTime = 25 * 3600, --200
    unlockPrice = 2500,
    spawns = dolg_spawns,
    canCapture = true,
    appearance =
    {
        {mdl = "models/player/stalker_dolg/dolg_old/dolg_old.mdl",
          skins       = {0,1},
        },
    },
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_LTDOLG, "Стандартный", 0, {"tfa_anomaly_akm","tfa_anomaly_fort"})
 rp.AddJobArmory(TEAM_LTDOLG, "Тяжелый", 15000, {"tfa_anomaly_fort500","tfa_anomaly_fort"})


TEAM_CAPDOLG = rp.addTeam('Капитан ДОЛГа', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker_dolg/dolg_noexo/dolg_noexo.mdl'},
    description = [[
Из-за своего ранга в группировке, ты получил улучшенное снаряжение. В бою предпочитаешь близкие дистанции из-за своей любви к дробовикам. Принимаешь участие в руковолстве группировкой, руководишь порядком на базе и патрулями.

• Руководи порядком на базе.
• Собирай и командуй патрулями.
• Следи за исполнением приказов.
Защити мир от заразы зоны!

Командует: Лейтенантом и ниже.
Подчиняется: Подполковнику и выше. 
    ]],
    weapons = {"health_kit_bad", "tfa_anomaly_knife_combat", "salute"},
    command = 'capkdolg',
    spawn_points = {},
    max = 3,
    forceLimit = true,
    salary = 10,
    armor = 350,
    faction = FACTION_DOLG,
    unlockTime = 65 * 3600, --400
    unlockPrice = 5000,
    spawns = dolg_spawns,
    canCapture = true,
    appearance = 
    {
        {mdl = "models/player/stalker_dolg/dolg_noexo/dolg_noexo.mdl",
          skins       = {0},
           bodygroups = {
                [1] = {0,1},
            }
        },
    },
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_CAPDOLG, "Стандартный", 0, {"tfa_anomaly_bizon","tfa_anomaly_fort"})
 rp.AddJobArmory(TEAM_CAPDOLG, "Снайперский", 20000, {"tfa_anomaly_svd","tfa_anomaly_fort"})

/*
TEAM_DOLGMORGAN = rp.addTeam('Прапорщик "Морган"', {
    color = Color(128, 0, 0),
    model = 'models/stalkertnb/rad_duty.mdl',
    description = [[
Снабженец, что не против толкнуть казённый товар своим врагам, часто ходишь на сделки, где пытаешься получить максимальную выгоду для себя любимого. Часто используешь младший состав, как курьеров и охраны, но приходится часто убирать лишних свидетелей, чтоб не прилечь у ближайшей стеночки…

• Торгуй всем, чем захочешь.
• Продавай тем, кому можно и нельзя.
• Действуй скрытно.
Защити мир от заразы зоны!

Командует: никем.
Подчиняется: Лейтенанту и выше.   
    ]],
    weapons = isNoDonate && {"tfa_anomaly_rpk74", "tfa_anomaly_fort", "weapon_wep_buyer", "weapon_art_buyer"} || {"swb_rp74", "tfa_anomaly_saiga", "swb_p99", "weapon_wep_buyer", "weapon_art_buyer"},
    command = 'dolgmorgan',
    customCheck = function(ply) return ply:HasUpgrade('morgan') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() or ply:HasPremium() or rp.PlayerHasAccessToJob('dolgmorgan', ply) end,
    spawn_points = {},
    armor = isNoDonate && 400 || 450,
    reversed = true,
    max = 1,
    salary = 17,
    unlockTime = 115 * 3600, --500
    --unlockPrice = 15000,
    faction = FACTION_DOLG,
    spawns = dolg_spawns,
    disableDisguise = true,
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})*/


TEAM_PODDOLG = rp.addTeam('Подполковник ДОЛГа', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker_dolg/dolg_exo/dolg_exo.mdl', "models/player/stalker_dolg/dolg_noexo/dolg_noexo.mdl"},
    description = [[
Ты тот, кто берёт на себя все косяки личного состава, тот, кто заступится за любого своего подчинённого. Одним словом хороший лидер, но нет, всего лишь подполковник. Ты несёшь тяжкий груз на своих широких плечах. Ты своей головой отвечаешь за всё перед начальством.

• Отвечай своим званием за косяки младшего состава.
• Проводи лекции по военной дисциплине.
• Делай проверки состава.
Защити мир от заразы зоны!

Командует: Капитаном и ниже.
Подчиняется: Полковнику и выше.

    ]],
    weapons = {"tfa_anomaly_knife_combat", "salute"},
    command = 'poddolg',
    spawn_points = {},
    armor = 400,
    health = 115,
    max = 2,
    forceLimit = true,
    salary = 14,
    faction = FACTION_DOLG,
    canDiplomacy = true,
    unlockTime = 175 * 3600, --600
    unlockPrice = 12500,
    spawns = dolg_spawns,
    canCapture = true,
    exoskeleton = true,
    appearance = 
    {
        {mdl = "models/player/stalker_dolg/dolg_exo/dolg_exo.mdl",
          skins       = {0},
           bodygroups = {
                [1] = {0,1,2},
            }
        },
        {mdl = "models/player/stalker_dolg/dolg_noexo/dolg_noexo.mdl",
          skins       = {0},
            },
    },
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_PODDOLG, "Стандартный", 0, {"tfa_anomaly_abakan","tfa_anomaly_fort"})
 rp.AddJobArmory(TEAM_PODDOLG, "Тяжелое", 30000, {"tfa_anomaly_saiga","tfa_anomaly_fort"})


TEAM_POLKDOLG = rp.addTeam('Полковник ДОЛГа', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker_dolg/dolg_seva/dolg_seva.mdl', "models/player/stalker_dolg/dolg_exoseva/dolg_exoseva.mdl"},
    description = [[
Ответственность за жизни личного состава, сохранность склада, состояние базы и осуществление спецопераций лежит на твоих плечах. Слишком много бумажной волокиты, можно подумать, однако не зря тебе выдали тяжёлое вооружение и экзоскелет. Ты - машина смерти.

• Участвуй в сложных военных операциях.
• Помогай генералу во всём.
• Командуй ДОЛГом в отсутствии генерала.
Защити мир от заразы зоны!

Командует: Подполковником и ниже.
Подчиняется: Генералу ДОЛГа.

    ]],
    weapons =  { "health_kit_normal", "tfa_anomaly_knife_combat", "salute"},
    command = 'polkdolg',
    spawn_points = {},
    armor = 500,
    health = 130,
    max = 1,
    forceLimit = true,
    salary = 16,
    faction = FACTION_DOLG,
    canDiplomacy = true,
    unlockTime = 250 * 3600, --1000
    unlockPrice = 20000,
    spawns = dolg_spawns,
    speed = 1.1,
    canCapture = true,
    exoskeleton = true,
appearance = {
    {mdl = {"models/player/stalker_dolg/dolg_seva/dolg_seva.mdl"},
    skins = {0,2},
},
    {mdl = {"models/player/stalker_dolg/dolg_exoseva/dolg_exoseva.mdl"},
    skins = {0,2},
},
},
    slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_POLKDOLG, "Стандартный", 0, {"tfa_anomaly_abakan","tfa_anomaly_hpsa"})
 rp.AddJobArmory(TEAM_POLKDOLG, "Тяжелое", 30000, {"tfa_anomaly_rpk74","tfa_anomaly_hpsa"})


TEAM_GENDOLG = rp.addTeam('Генерал ДОЛГа', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker_dolg/dolg_bulat/dolg_bulat.mdl', 'models/player/stalker_dolg/dolg_bulat_proto/dolg_bulat_proto.mdl'},
    description = [[
Лидер группировки, главный на территории базы и её округи. Тебе часто приходится ходить на переговоры, договариваться о снабжении и составлять стратегии ведения войны. В твоих руках сосредоточена власть личной армией, так что пользуйся ей с умом…

• Меняй дипломатию группировки, налаживай контакт с другими.
• Пользуйся полномочиями с умом.
• Не устрой войну группировок.
Защити мир от заразы зоны!

Командует: Всеми.
Подчиняется: никому.
    ]],
    weapons = {"health_kit_normal", "tfa_anomaly_knife_combat", "salute"},
    command = 'gendolg',
    spawn_points = {},
    armor = 400,
    health = 150,
    max = 1,
    reversed = true,
    salary = 18,
    faction = FACTION_DOLG,
    upgrader = {["officer_support"] = true},
    canDiplomacy = true,
    unlockTime = 335 * 3600, --800
    unlockPrice = 33500,
    spawns = dolg_spawns,
    speed = 1.1,
    canCapture = true,
    disableDisguise = true,
    slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
    
})
 rp.AddJobArmory(TEAM_GENDOLG, "Стандартный", 0, {"tfa_anomaly_ak103","tfa_anomaly_fort"})
 rp.AddJobArmory(TEAM_GENDOLG, "Тяжелое", 30000, {"tfa_anomaly_protecta","tfa_anomaly_fort"})

/*
TEAM_VORONIN = rp.addTeam('Генерал Воронин', {
    color = Color(128, 0, 0),
    model = {'models/player/stalker/compiled 0.34/voronin.mdl'},
    description = [[
Перешёл в глубь Зоны из бара с отрядом ДОЛГа. Ты обжился здесь и стал самым главным в рядах местного ДОЛГа. Ты взял руководство лично на себя, так что не просри группировку. Всё в твоих руках!

• Командуй абсолютно всеми бойцами ДОЛГа.
• Будь примером для остальных лидеров.
• Будь жёстким, но справедливым.
Защити мир от заразы зоны!

Командует: Всеми.
Подчиняется: Никому.
    ]],
    weapons = isNoDonate && {"stalker_abatonfra", "swb_ksvk", "tfa_anomaly_saiga", "m9k_knife", "tfa_anomaly_fort", "salute"} || {"stalker_abatonfra", "swb_ksvk", "swb_eliminator", "swb_deagle", "m9k_knife", "health_kit_best", "salute"},
    command = 'voronin',
    spawn_points = {},
    max = 1,
    armor = isNoDonate && 500 || 600,
    health = isNoDonate && 200 || 250,
    arrivalMessage = true,
    salary = 25,
    reversed = true,
    faction = FACTION_DOLG,
    --unlockTime = 350 * 3600,
    canDiplomacy = true,
    --upgrader = {["officer_support"] = true},
    spawns = dolg_spawns,
    customCheck = function(ply) return ply:HasUpgrade('voronin') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() end,
    canCapture = true,
    disableDisguise = true,
    slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
*/

rp.SetFactionVoices({FACTION_DOLG}, { 
    { 
        label = 'Ну, здорова!', 
        sound = 'dolg/zdorov.wav', 
        text = 'Ну, здорова!',
    },
    { 
        label = 'Вперёд', 
        sound = 'dolg/vper.wav', 
        text = 'Бойцы, вперёд!',
    },
    { 
        label = 'Огонь', 
        sound = 'dolg/ogon.wav', 
        text = 'Огонь!',
    },
    { 
        label = 'Уничтожить', 
        sound = 'dolg/vraga.wav', 
        text = 'Уничтожить врага!',
    },
    { 
        label = 'Вали', 
        sound = 'dolg/vali.wav', 
        text = 'Вали гадов!',
    },
    { 
        label = 'Прикрываю!', 
        sound = {'dolg/prik.wav', 'dolg/prik2.wav'},
        text = 'Прикрываю!',
    },
    { 
        label = 'На готове', 
        sound = 'dolg/gotov.wav', 
        text = 'Всем быть на готове!',
    },
    { 
        label = 'В расход', 
        sound = 'dolg/rashod.wav', 
        text = 'В расход у меня пойдёшь!',
    },
    { 
        label = 'Убери оружие', 
        sound = {'dolg/oruzh.wav', 'dolg/oruzh2.wav'},
        text = 'Убери оружие',
    },
    { 
        label = 'Да пошёл ты', 
        sound = {'dolg/poshl.wav','dolg/poshl2.wav'},
        text = 'Да пошёл ты!',
    },
    { 
        label = 'Достал', 
        sound = 'dolg/dostal.wav', 
        text = 'Всё, достал',
    },
    { 
        label = 'Отдыхаем', 
        sound = 'dolg/otdih.wav', 
        text = 'Всё, отдыхаем',
    },
    { 
        label = 'Смех', 
        sound = 'dolg/smeh.wav', 
        text = '*Смех*',
    },
})

local megafon_sounds = {
    { 
        label = 'Ветераны Чернобыля', 
        sound = 'dolg_mega/dolg_megaf1.wav', 
        text = 'Ветераны Чернобыля, вступайте в ряды ДОЛГа, на нас лежит огромная ответственность, защитить мир, от растущей зоны.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 15,
    }, 
    { 
        label = 'Свободные сталкеры', 
        sound = 'dolg_mega/dolg_megaf2.wav', 
        text = 'Свободные сталкеры, ветераны и охотники, вливайтесь в ряды ДОЛГа, защитить мир от заразы зоны, наша общая цель и задача.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 19,
    }, 
     { 
        label = 'Защити мир', 
        sound = 'dolg_mega/dolg_megaf3.wav', 
        text = 'Сталкер, защити мир от зоны, вступи в ДОЛГ!',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 10,
    }, 
     { 
        label = 'Мир', 
        sound = 'dolg_mega/dolg_megaf4.wav', 
        text = 'Мир со страхом смотрит, на расползающуюся заразу зоны, вступи в ДОЛГ, помоги мирным людям!',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 13,
    }, 
       { 
        label = 'Смертельные аномалии', 
        sound = 'dolg_mega/dolg_megaf5.wav', 
        text = 'Смертельные аномалии, опасные мутанты, анархисты и бандиты, не остановят ДОЛГ победоносный и поступью идущий на помощь мирным гражданам, всей планеты.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 21,
    },
}
    local speed = rp.cfg.RunSpeed
    local team_NumPlayers = team.NumPlayers 
    hook.Add("PlayerLoadout", function(ply) 
    if (ply:GetFaction() == FACTION_DOLGVIP or ply:GetFaction() == FACTION_DOLG) && team_NumPlayers(TEAM_TEXDOLG) > 0 then 
        rp.Notify(ply, NOTIFY_GREEN, rp.Term('TexBoost'))
        ply:GiveArmor(25)   
        ply:GiveAmmo(180, "smg1")
        ply:GiveAmmo(210, "ar2")
        ply:GiveAmmo(60, "Buckshot")                 
        end 
    if (ply:GetFaction() == FACTION_DOLGVIP or ply:GetFaction() == FACTION_DOLG) && team_NumPlayers(TEAM_GENDOLG) > 0 then 
        rp.Notify(ply, NOTIFY_GREEN, rp.Term('LiderDolgBoost')) 
        ply:AddHealth(25) 
        end     
    end)


rp.AddTeamVoices(TEAM_VORONIN, megafon_sounds)
rp.AddTeamVoices(TEAM_GENDOLG, megafon_sounds)
rp.AddTeamVoices(TEAM_POLKDOLG, megafon_sounds)


--rp.AddToRadioChannel(rp.GetFactionTeams(FACTION_DOLG)) 