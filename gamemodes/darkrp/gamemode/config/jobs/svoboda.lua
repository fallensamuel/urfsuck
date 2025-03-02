-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\svoboda.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  svoboda_spawns = {
rp_stalker_urfim_v3 = {Vector(5154, -3155, -4088), Vector(5205, -3298, -4088)},
rp_pripyat_urfim = {Vector(205, 5684, 0), Vector(41, 5670, 0), Vector(189, 5749, 0)},
rp_stalker_urfim = {Vector(8785, -583, -128), Vector(8890, -756, -128), Vector(8678, -729, -128)},
rp_st_pripyat_urfim = {Vector(-10944, 3473, -2), Vector(-10954, 3321, -2), Vector(-10960, 3214, -2)},
}
TEAM_NOVSVOB = rp.addTeam('Салага Свободы', {
    color = Color(233, 150, 122),
    model ={'models/player/stalker_freedom/freedom_jacket/freedom_jacket.mdl'},
    description = [[
Только познавший свободную жизнь индивид, который не против накачаться наркотой и пойти в бой. Башню, конечно, ещё не сорвало, но к этому уже близко. Не переборщи с дозой, торч.

• Помогай более опытным членам группировки.
• Не слови передоз кекс.
• Участвуй во всех операциях группировки.
Ты надежда сталкеров, помогай им!

Командует: никем.
Подчиняется: Энтузиасту и выше.  
    ]],
    weapons = {"tfa_anomaly_knife_nr40"},
    command = 'novsvob',
    spawn_points = {},
    salary = 8,
    armor = 100,
    faction = FACTION_SVOBODA,
    spawns = svoboda_spawns,
        slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_NOVSVOB, "Стандартный", 0, {"tfa_anomaly_g36k","tfa_anomaly_beretta"})
 rp.AddJobArmory(TEAM_NOVSVOB, "Тяжелое", 15000, {"tfa_anomaly_spas12","tfa_anomaly_beretta"})

TEAM_OPSVOB = rp.addTeam('Энтузиаст Свободы', {
    color = Color(233, 150, 122),
    model = 'models/player/stalker_freedom/freedom_gp5/freedom_gp5.mdl',
    description = [[
Ты уже давно не пешка, но и до руководства тебе далеко. Тебе доверяют много важной информации. Не забудь, что твоя обязанность - следить за младшими коллегами, чтобы те не снесли партию конопли для продажи.

• Трезвым, и не совсем, умом принимай разумные решения во благо группировки.
• Организуй захваты важных точек.
• Проводи мелкие боевые операции.
Ты надежда сталкеров, помогай им!

Командует: Салагой.
Подчиняется: Бунтарю и выше.
    ]],
    weapons = {"tfa_anomaly_knife_nr40"},
    command = 'opsvob',
    spawn_points = {},
    armor = 260,
    max = 3,
    forceLimit = true,
    salary = 10,
    faction = FACTION_SVOBODA,
    unlockTime = 25 * 3600, --400
    unlockPrice = 2500,
    spawns = svoboda_spawns,
    canCapture = true,
        slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_OPSVOB, "Стандартный", 0, {"tfa_anomaly_l85","tfa_anomaly_colt1911"})
 rp.AddJobArmory(TEAM_OPSVOB, "Тяжелое", 15000, {"tfa_anomaly_spas12","tfa_anomaly_colt1911"})

TEAM_NOVSVOBVIP = rp.addTeam('Бунтарь Свободы', {
    color = Color(233, 150, 122),
    model = {'models/player/stalker_freedom/freedom_guard/freedom_guard.mdl'},
    description = [[ Хоть ты и только вступил в Свободу, имея хороший навык стрельбы, тебе выдали хорошее вооружение.

• Помогай более опытным членам группировки.
• Не слови передоз кекс.
• Участвуй во всех операциях группировки.
Ты надежда сталкеров, помогай им!

Командует: Энтузиастом и ниже.
Подчиняется: Ветерану и выше.  
]],
    weapons = {"tfa_anomaly_knife_nr40", "gmod_camera"},
    command = 'vipnovsvob',
    spawn_points = {},
    salary = 11,
    armor = 350,
    max = 2,
    unlockTime = 65 * 3600, --400
    unlockPrice = 5000,
    forceLimit = true,   
    faction = FACTION_SVOBODA,
    spawns = svoboda_spawns,
    appearance = {
        {mdl = "models/player/stalker_freedom/freedom_guard/freedom_guard.mdl",
          skins       = {0,2},
           bodygroups = {
                [1] = {0,1,2,3,4},
                [2] = {0,1,2},
            }
        },
    },      
        slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_NOVSVOBVIP, "Стандартный", 0, {"tfa_anomaly_l85","tfa_anomaly_colt1911"})
 rp.AddJobArmory(TEAM_NOVSVOBVIP, "Тяжелое", 15000, {"tfa_anomaly_toz194","tfa_anomaly_colt1911"})

/*TEAM_BARSVOB = rp.addTeam('Бармен Вано', {
    color = Color(233, 150, 122),
    model = {'models/vano.mdl'},
    description = [[
После похода в Припять, ты решил начать исследование ЧЗО, но выбрал не НИГ, а Свободу, где у тебя появилось больше возможностей. Тебе понравилось, что тут каждый поможет друг-другу и вовремя подаст бумагу, если закончится. Однако, что-то не задалось в исследованиях и ты стал барменом, хоть с деньгами у тебя всегда были проблемы.

• Барыжь товарами со склада группировки.
• Добивайся общего признания.
• Распоряжайся финансами с умом.
Ты надежда сталкеров, помогай им!

Командует: никем.
Подчиняется: Стражу и выше.
    ]],
    weapons = isNoDonate && {"swb_bizonsilens", "swb_spas14", "swb_p99", "tfa_anomaly_knife_nr40", "weapon_art_buyer", "seig_hail"} || {"tfa_anomaly_l85", "swb_spas14", "swb_p99", "tfa_anomaly_knife_nr40", "weapon_art_buyer", "seig_hail"},
    command = 'barvob',
    spawn_points = {},
    armor = isNoDonate && 250 || 350,
    max = 1,
    reversed = true,
    salary = 12,
    faction = FACTION_SVOBODA,
    unlockTime = 205 * 3600, --500
    spawns = svoboda_spawns,
    unlockPrice = 10000,
        slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})*/

TEAM_VETERSVOB = rp.addTeam('Ветеран Свободы', {
    color = Color(233, 150, 122),
    model = {'models/player/stalker_freedom/freedom_seva/freedom_seva.mdl'},
    description = [[
Один из "офицеров" крокодилового креста. Такого высокого ранга ты добился благодаря боевым и стратегическим навыкам. В свободное время можешь обучить новичков, как правильно крутить косяки и выращивать коноплю.

• Руководи крупными отрядами травокуров.
• Организовывай крупные боевые операции.
• Решай внутренние конфликты группировки.
Ты надежда сталкеров, помогай им!

Командует: Бунтарем и ниже.
Подчиняется: Пионеру и выше.     
    ]],
    weapons = {"tfa_anomaly_hpsa", "tfa_anomaly_knife_nr40"},
    command = 'vetersvob',
    spawn_points = {},
    armor = 400,
    salary = 14,
    health = 115,
    faction = FACTION_SVOBODA,
    unlockTime = 155 * 3600, --600
    unlockPrice = 12000,
    spawns = svoboda_spawns,
    canDiplomacy = true,
    max = 2,
    forceLimit = true,
    canCapture = true,
    exoskeleton = true,
        slavePrice = 350, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции
    appearance = 
    {
        {mdl = "models/player/stalker_freedom/freedom_seva/freedom_seva.mdl",
          skins       = {0},
        },
    },   
})
 rp.AddJobArmory(TEAM_VETERSVOB, "Стандартный", 0, {"tfa_anomaly_l85","tfa_anomaly_hpsa"})
 rp.AddJobArmory(TEAM_VETERSVOB, "Снайперский", 20000, {"tfa_anomaly_svt","tfa_anomaly_hpsa"})

TEAM_MASTSVOB = rp.addTeam('Пионер Свободы', {
    color = Color(233, 150, 122),
    model = {'models/player/stalker_freedom/freedom_exoseva/freedom_exoseva.mdl'},
    description = [[
Заместитель лидера всей нарко-компании, руководитель единорогов и зелёных человечков... Что-то не туда понесло... Помогай лидеру и остальным травокурам и тунеядцам.

• Помогай лидеру во всём.
• Используй свои полномочия в корыстных целях.
• Следи за младшим составом.
Ты надежда сталкеров, помогай им!

Командует: Ветераном и ниже.
Подчиняется: Лидеру.    
    ]],
    weapons = {"tfa_anomaly_knife_nr40", "health_kit_normal"},
    command = 'mastsvob',
    spawn_points = {},
    max = 1,
    forceLimit = true,
    salary = 16,
    faction = FACTION_SVOBODA,
    unlockTime = 250 * 3600, --1000
    unlockPrice = 20000,
    armor = 500,
    health = 120,
    spawns = svoboda_spawns,
    canDiplomacy = true,
    speed = 1.1,
    canCapture = true,
    exoskeleton = true,
        slavePrice = 400, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
    appearance = 
    {
        {mdl = "models/player/stalker_freedom/freedom_exoseva/freedom_exoseva.mdl",
          skins       = {0},
        },
    }, 
})
 rp.AddJobArmory(TEAM_MASTSVOB, "Снайперский", 0, {"tfa_anomaly_wa2000","tfa_anomaly_desert_eagle"})
 rp.AddJobArmory(TEAM_MASTSVOB, "Тяжелый", 30000, {"tfa_anomaly_m249","tfa_anomaly_desert_eagle"})

TEAM_LEADSVOB = rp.addTeam('Лидер Свободы', {
    color = Color(233, 150, 122),
    model = {'models/player/stalker_freedom/freedom_exo/freedom_exo.mdl'},
    description = [[
Самый матёрый  свободный человек из всех.
После объявления лидером Лукаша,ты стал его заместителем и правой рукой,но вся свобода тебя уважает и считает за своего лидера в отсутствии Лукаша.
• Используй свои дипломатические навыки во благо.
• Используй весь резерв для защиты интересов группировки.
• Будь хорошим заместителем.
• Отстаивай интересы группировки и защищай ту самую свободу.
Ты надежда сталкеров, помогай им!

Командует: Пирнером и ниже.
Подчиняется: никому.    
    ]],
    weapons = {"health_kit_normal", "tfa_anomaly_knife_nr40"},
    command = 'chehovsv',
    spawn_points = {},
    max = 1,
    salary = 18,
    armor = 450,
    health = 150,
    faction = FACTION_SVOBODA,
    unlockTime = 335 * 3600, --800
    unlockPrice = 30000,
    spawns = svoboda_spawns,
    upgrader = {["officer_support"] = true},
    reversed = true,
    canDiplomacy = true,
    speed = 1.1,
    canCapture = true,
    disableDisguise = true,
        slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 260, -- Время заключения для пленника этой профы / фракции  
})
 rp.AddJobArmory(TEAM_LEADSVOB, "Стандартный", 0, {"swb_lr300_mod","tfa_anomaly_desert_eagle"})
rp.AddJobArmory(TEAM_LEADSVOB, "Снайперский", 20000, {"tfa_anomaly_wa2000","tfa_anomaly_desert_eagle"})
 rp.AddJobArmory(TEAM_LEADSVOB, "Тяжелый", 15000, {"tfa_anomaly_spas12","tfa_anomaly_desert_eagle"})

/*TEAM_LUKASH = rp.addTeam('Лукаш', {
    color = Color(233, 150, 122),
    model = {'models/player/stalker/compiled 0.34/lukash.mdl'},
    description = [[
Перейдя в глубинку Зоны после миграции с военных складов,за твои заслуги тебя назначил новым лидером лично Чехов!
Тебя слушаются и уважают все, ведь именно под твоим руководством Свобода держала оборону в режиме Нон-стоп. 

• Управляй абсолютно всеми действиями группировки.
• Используй военную мощь Свободы для достижения общей цели.
• Помогай сталкерам найти пристанище свободы.
• Отстаивай интересы свободы.
Ты надежда сталкеров, помогай им!

Командует: всеми.
Подчиняется: никому.
    ]],
    weapons = isNoDonate && {"stalker_svusvob", "swb_tar_kekler", "tfa_anomaly_spas12", "weapon_ciga_pachka", "tfa_anomaly_knife_nr40", "seig_hail"} || {"stalker_svusvob", "swb_aug_kekler", "swb_spas14", "stalker_bulldog", "weapon_ciga_pachka", "tfa_anomaly_knife_nr40", "seig_hail"},
    command = 'lukash',
    spawn_points = {},
    max = 1,
    salary = 25,
    faction = FACTION_SVOBODA,
    --unlockTime = 350 * 3600,
    spawns = svoboda_spawns,
    arrivalMessage = true,
    reversed = true,
    canDiplomacy = true,
    upgrader = {["officer_support"] = true},
    armor = isNoDonate && 500 || 600,
    health = isNoDonate && 200 || 250,
    customCheck = function(ply) return ply:HasUpgrade('lukash') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() or rp.PlayerHasAccessToJob('lukash', ply) end,
    canCapture = true,
    disableDisguise = true,
        slavePrice = 500, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 360, -- Время заключения для пленника этой профы / фракции  
})*/

rp.SetFactionVoices({FACTION_SVOBODA}, { 
    { 
        label = 'Здаров', 
        sound = 'freedom/zdorov.wav', 
        text = 'Здаров',
    },
    { 
        label = 'О какие люди', 
        sound = 'freedom/ludi.wav', 
        text = 'О, какие роскошные люди',
    },
    { 
        label = 'Валите всех!', 
        sound = 'freedom/valite_vseh.wav', 
        text = 'Валите всех!!',
    },
    { 
        label = 'Кончай их!', 
        sound = 'freedom/konch.wav', 
        text = 'Кончай сволочей!',
    },
    { 
        label = 'Противник!', 
        sound = 'freedom/protiv.wav', 
        text = 'Чуваки противник!',
    },
    { 
        label = 'В бой!', 
        sound = {'freedom/vpered.wav','freedom/vpered_2.wav' },
        text = 'В бой!',
    },
    { 
        label = 'Прикрываю!', 
        sound = 'freedom/prikr.wav', 
        text = 'Не боись, прикрываю!',
    },
    { 
        label = 'Утихли', 
        sound = 'freedom/tixo.wav', 
        text = 'Так, утихли',
    },
    { 
        label = 'Ты достал!', 
        sound = 'freedom/men_dostal.wav', 
        text = 'Мэн, ты достал!',
    },
    { 
        label = 'Ты труп!', 
        sound = 'freedom/trup_1.wav',
        text = 'Ты труп!',
    },
    { 
        label = 'Отстань!', 
        sound = {'freedom/otstan_1.wav','freedom/otstan_2.wav','freedom/otstan_3.wav' },
        text = 'Отстань!',
    },
    { 
        label = 'Оружие убери', 
        sound = {'freedom/oruzhi_1.wav','freedom/oruzhi_2.wav'},
        text = 'Оружие убери',
    },
    { 
        label = 'Ахаха', 
        sound = 'freedom/ahaha.wav', 
        text = '*Ржёт*',
    },
    { 
        label = 'Не стреляй!', 
        sound = 'freedom/ne_strel.wav', 
        text = 'Не стреляй!',
    },
    { 
        label = 'Обана', 
        sound = 'freedom/obana.wav', 
        text = 'Обана',
    },
})

local megafon_sounds = {
    { 
        label = 'Крутые', 
        sound = 'freedom_mega/freedom_megaf1.wav', 
        text = 'Крутые и подкрученные перцы, только в свободе вас оценят и примут как родных, никакого обязалова и идеологической пурги, никаких утренних побудок и минимум сухого закона, если ты настоящий сталкер и любишь вольную жизнь среди таких же как сам, вливайся в наши ряды, время вливания, любое, принимаем без перерывов и выходных, ежедневно и еженочно.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 34,
    }, 
    { 
        label = 'Сталкер', 
        sound = 'freedom_mega/freedom_megaf2.wav', 
        text = 'Сталкер, жизнь дарит тебе возможность найти верных товарищей в рядах свободы, только здесь ты найдёшь тех, кто прикроет тебе спину и поделится последним куском хлеба',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 17,
    },  
}
    local speed = rp.cfg.RunSpeed
    local team_NumPlayers = team.NumPlayers 
    hook.Add("PlayerLoadout", function(ply) 
    if (ply:GetFaction() == FACTION_SVOBODAVIP or ply:GetFaction() == FACTION_SVOBODA) && team_NumPlayers(TEAM_TEXRSVOB) > 0 then 
        rp.Notify(ply, NOTIFY_GREEN, rp.Term('TexBoost'))
        ply:GiveArmor(25)   
        ply:GiveAmmo(180, "smg1")
        ply:GiveAmmo(210, "ar2")
        ply:GiveAmmo(60, "Buckshot")                 
        end 
    if (ply:GetFaction() == FACTION_SVOBODAVIP or ply:GetFaction() == FACTION_SVOBODA) && team_NumPlayers(TEAM_LEADSVOB) > 0 then 
        rp.Notify(ply, NOTIFY_GREEN, rp.Term('LiderSvobBoost')) 
        ply:SetRunSpeed(speed * 1.15)        
        ply:AddHealth(15) 
        end     
    end)


rp.AddTeamVoices(TEAM_LUKASH, megafon_sounds)
rp.AddTeamVoices(TEAM_LEADSVOB, megafon_sounds)

--rp.AddToRadioChannel(rp.GetFactionTeams(FACTION_SVOBODA)) 