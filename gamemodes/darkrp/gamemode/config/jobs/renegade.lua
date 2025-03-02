-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\renegade.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  renegades_spawns = {
rp_stalker_urfim_v3 = {Vector(3738, 6168, -3955), Vector(3759, 6696, -3955),},
rp_pripyat_urfim = {Vector(1444, -4269, 0), Vector(1555, -4126, 0)},
rp_stalker_urfim = {Vector(4313, 7242, -357), Vector(4185, 7274, -357), Vector(4161, 7175, -357)},
rp_st_pripyat_urfim = {Vector(-9401, 13703, 8), Vector(-9642, 13726, 8)},
}
/*
TEAM_RENEGADES2 = rp.addTeam("Отщепенец ЧН", {
    color = Color(100, 117, 109),
    model = {'models/tnb/stalker/male_cs3.mdl', 'models/stalker_nebo/nebo_novice/nebo_novice.mdl'},
    description = [[
Ты покинул Чистое Небо по собственным соображениям, но все еще держишь с ними контакт , а иногда даже работаешь с ними. 

• Твои отношения с другими группировками такие же как у Чистого Неба.
    ]],
    weapons = {"swb_spas14", "swb_ak107","swb_colt1911","stalker_knife"},
    salary = 6,
    command = "Renegades2",
    spawns = renegades_spawns,
    spawn_points = {},
    faction = FACTION_RENEGADES, 
    armor = isNoDonate && 200 || 250,
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
    appearance =
    {
        {mdl = "models/tnb/stalker/male_cs3.mdl",
          skins       = {0},
        },
    },
})

TEAM_RENEGADES1 = rp.addTeam("Мародер", {
    color = Color(100, 117, 109),
    model = {'models/stalkertnb/bandit_zaku3.mdl', 'models/stalker_renegade/renegade_gear/renegade_gear.mdl'},
    description = [[
Ты настолько аморален что даже бандиты изгнали тебя из общака, ты отброс Зоны и тебя ненавидят абсолютно все. 
    
• Бандиты имеют право убивать тебя при встрече,как и ты их. 
• Твои отношения с другими группировками такие же как у Бандитов.
    ]],
    weapons = {"swb_double_long_shotgun", "swb_ak74_u","pickpocket", "stalker_knife"},
    salary = 7,
    command = "Renegades1",
    spawns = renegades_spawns,
    spawn_points = {},
    faction = FACTION_RENEGADES,
    unlockPrice = 40000, --25000
    unlockTime = 15*3600,
    armor = isNoDonate && 250 || 300,
    appearance = 
    {
        {mdl = "models/stalker_renegade/renegade_gear/renegade_gear.mdl",
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2},
            }
        },
    },
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_RENEGADES4 = rp.addTeam("Дезертир", {
    color = Color(100, 117, 109),
    model = {"models/stalkertnb/skat_bees.mdl"},
    description = [[
Доведенный до предела приказами руководства ВСУ ты дезертировал из армии и присоеденился к числу тех в кого раньше стрелял только завидев. 
    
• Твои отношения с другими группировками такие же как у ВСУ.
• Военные имеют право открывать огонь по тебе, ты так же можешь убивать бывших сослуживцев. 
• Экологи имеют право задержать тебя и сдать военным. 
• Военные могут выдавать заказы сталкерам или наемникам на твою поимку или убийство. 
    ]],
    weapons = {"swb_rpd", "swb_scorpion","swb_svd", "stalker_knife", "pass_vsu"},
    salary = 8,
    command = "Renegades4",
    spawns = renegades_spawns,
    spawn_points = {},
    faction = FACTION_RENEGADES,
    unlockPrice = 60000, --80000
    unlockTime = 50*3600, --100
    armor = isNoDonate && 250 || 350,
    exoskeleton = true,
        slavePrice = 900, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_RENEGADES3 = rp.addTeam("Изгнанник Наёмников", {
    color = Color(100, 117, 109),
    model = {'models/stalkertnb/io7a_jagged.mdl', 'models/stalker_merc/merc_novice/merc_novice.mdl', 'models/stalker_merc/merc_seva/merc_seva.mdl'},
    description = [[
Когда то ты убил своего напарника что бы забрать всю награду за убийство, остальные узнали об этом и попытались убить тебя, но ты сбежал. 
    
• Наемники имеют право убить тебя, ты их тоже. 
    ]],
    weapons = {"swb_psg1", "swb_aug_kekler", "swb_beretta_kekler","stalker_knife"},
    salary = 9,
    hitman = true,
    command = "Renegades3",
    spawns = renegades_spawns,
    faction = FACTION_RENEGADES,
    unlockPrice = 80000, --60000
    unlockTime = 90*3600, --50
    armor = isNoDonate && 400 || 450,
        slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции
    appearance = 
    {
        {mdl = "models/stalker_merc/merc_seva/merc_seva.mdl",
            skins       = {2},
        },
        {mdl = "models/stalker_merc/merc_novice/merc_novice.mdl",
            skins       = {1},
        },
    },  
})

TEAM_RENEGADES5 = rp.addTeam("Предатель Свободы", {
    color = Color(100, 117, 109),
    model = {'models/tnb/stalker/male_seva.mdl','models/stalker_freedom/freedom_cloak/freedom_cloak.mdl', 'models/stalker_freedom/freedom_sunrise_proto/freedom_sunrise_proto.mdl'},
    description = [[
Ты бывший артхантер Свободы,ты предал свою группировку выкрав очень ценный артефакт. Хоть ты и смог наварится но ты не учел,что Свобода не прощает предателей. 
    
• Твои отношения с другими группировками такие же как у Свободы.
• Свободовцы имеют право убить тебя так же как и ты их. 
• Из за формы Долг и Военные все еще считают тебя врагом. 
    ]],
    weapons = {"swb_awm", "swb_enfield", "swb_usp", "stalker_knife"},
    salary = 10,
    command = "Renegades5",
    spawns = renegades_spawns,
    spawn_points = {},
    faction = FACTION_RENEGADES,
    unlockPrice = 150000,
    unlockTime = 170*3600, --200
    anomaly_resistance = .30,
    armor = isNoDonate && 300 || 350,
    appearance = 
    {
        {mdl = "models/stalker_freedom/freedom_cloak/freedom_cloak.mdl",
           bodygroups = {
                [1] = {0,1},
                [2] = {0,1},
            }
        },
        {mdl = "models/stalker_freedom/freedom_sunrise_proto/freedom_sunrise_proto.mdl",
            skins       = {1,3},
            bodygroups = {
                [1] = {0,1,2,3,4},
            }
        },
        {mdl = "models/tnb/stalker/male_seva.mdl",
            skins       = {2},
        },
    },
        slavePrice = 500, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_RENEGADES6 = rp.addTeam("Дезертир ДОЛГа", {
    color = Color(100, 117, 109),
    model = {'models/stalkertnb/exo_zaku.mdl', 'models/stalker_dolg/dolg_sunrise_proto/dolg_sunrise_proto.mdl', 'models/stalker_dolg/dolg_cloak/dolg_cloak.mdl'},
    description = [[
Дезертировав из ДОЛГа ты решил вести собственную войну с теми кого считал отбросами, но вскоре и сам стал не лучше их...
    
• Твои отношения с другими группировками такие же как у ДОЛГа.
• Враждебные отношения с твоей старой группировкой.
• Из-за формы Бандиты и Свобода все еще считают тебя врагом.
    ]],
    weapons = {"swb_sayga_kekler", "swb_abaton", "swb_pb", "stalker_knife"},
    salary = 11,
    command = "Renegades6",
    spawns = renegades_spawns,
    spawn_points = {},
    faction = FACTION_RENEGADES,
    unlockPrice = 350000,
    unlockTime = 300*3600, --350
    armor = isNoDonate && 400 || 450,
    speed = 1.1,
    appearance = 
    {
        {mdl = "models/stalker_dolg/dolg_cloak/dolg_cloak.mdl",
            skins       = {0},
            bodygroups = {
                [1] = {0,1},
            }
        },
        {mdl = "models/stalker_dolg/dolg_sunrise_proto/dolg_sunrise_proto.mdl",
            skins       = {1},
            bodygroups = {
                [1] = {0,1,2,3,4},
            }
        },
    },
        slavePrice = 800, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_RENEGADES6 = rp.addTeam("Бежавший сотрудник НИГ", {
    color = Color(100, 117, 109),
    model = "models/stalkertnb2/seva_nss.mdl",
    description = [[
Отработав год в НИГ ты понял что иследования тебе надоели и ушел в Зону торговать Артефактами. 
Иногда ты возвращаешься к своим старым коллегам и предоставляешь им необходимые для иследований образцы.
    ]],
    weapons = {"stalker_knife", "swb_mt9", "swb_taurus"},
    salary = 12,
    command = "Renegades8",
    spawns = renegades_spawns,
    faction = FACTION_RENEGADES,
	AllowWorkbench = 'wrkbnch2',
	max = 1,
    unlockPrice = 450000,
    unlockTime = 400*3600,
    armor = isNoDonate && 200 || 250,
        slavePrice = 600, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
   })

TEAM_RENEGADES7 = rp.addTeam("Неподконтрольный Монолитовец", {
    color = Color(100, 117, 109),
    model = {'models/stalkertnb/exo_thrasos.mdl','models/stalker_monolith/monolith_seva/monolith_seva.mdl'},
    description = [[
Ты мало помнишь о своем прошлом, в отрывках воспоминаний ты видишь что убивал сталкеров и называл их "неверными", сейчас ты обладаешь собственным сознанием, но на долго ли?
    
• Зайдя на базу Монолита ты вновь теряешь контроль над собой и продолжаешь служить Монолиту(Ранг на уровне проповедника) 
• Монолитовцы легко узнают в тебе бывшего брата по служению и под страхом смерти могут отвести тебя на базу
• Не имеешь права убивать никого кроме зомби и считаешься одиночкой (Искл. вернулся под контроль Монолита) 
    ]],
    weapons = {"swb_gauss", "swb_spas14", "swb_g36", "stalker_knife"},
    salary = 13,
    command = "Renegades7",
    spawns = renegades_spawns,
    faction = FACTION_RENEGADES,
    unlockPrice = 1000000,
    unlockTime = 575*3600, --500
    armor = isNoDonate && 400 || 500,
    health = isNoDonate && 150 || 200,
    max = 1,
    appearance = {
        {
            mdl = 'models/stalker_monolith/monolith_seva/monolith_seva.mdl',
        skins = {1,2},    
        },
    },
        slavePrice = 1000, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_STRAYDOC = rp.addTeam("Бродячий Доктор", {
    color = Color(100, 117, 109),
    model = "models/stalkertnb/cs2_adaption.mdl",
    description = [[
Бродячего Доктора сталкера зачастую приравнивают к легендарному Болотному Доктору, так как они схожи по своим целям. Бродячий Доктор непредсказуем, и появляется в тот момент, когда людям действительно нужна помощь. Он всё время таскает при себе кучу медикаментов, благодаря чему многие сталкеры остались живы и не сгинули в ЧЗО.
    
• Помогай всем кто нуждается в помощи.
• Давай задания тем кого ты спас.
• Никогда не атакуй первым!
    ]],
    weapons = {"swb_grand","swb_ak74_u","swb_browning","swb_winchester","health_kit_best","stalker_knife","detector_veles"},
    command = "straydoc",
    salary = 14, 
    armor = isNoDonate && 320 || 370,
    reversed = true,
    health = isNoDonate && 150 || 200,
    --likeReactions = 45,
    max = 1,
    spawns = renegades_spawns,
    faction = FACTION_RENEGADES,
    speed = 1.2, 
    medic = true,
    IsMedic = true, 
    MedicHealTime = 2.2,
    RescueReward = 650,
    DmHealTime = 5,
    RescueFactions = {[FACTION_CITIZEN] = true, [FACTION_RENEGADES] = true},
	anomaly_resistance = .6,
    slavePrice = 1000, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 160, -- Время заключения для пленника этой профы / фракции 
 })
    
TEAM_ZHILA = rp.addTeam("Жила", {
    color = Color(100, 117, 109),
    model = {'models/stalker_renegade/renegade_exoseva/renegade_exoseva.mdl'},
    description = [[ 
Ты мало что помнишь хорошего в жизни,ведь тебя все гнобили и унижали за твою слабость до тех пор пока ты не перестал быть терпилой,взял свой "Ак" и убил всех кто тебя презирал.
Теперь тебя все боятся и уважают,ты считаешься местным паханом у ренегатов,ты способен их собрать воедино и дать отпор тем кто смеет вас унижать.

• Не ходишь в бары один.
• Являешься авторитетом у ренегатов.
• Очень агрессивный по отношению к тем кто презирает новичков и тех кто попал в беду.
• Враждебен к Бандитам и Монолиту.
    ]],
    weapons = {"stalker_knife", "swb_ks23m", "swb_ak107"},
    salary = 15,
    command = "zhila",
    spawns = renegades_spawns,
    arrivalMessage = true,
    faction = FACTION_RENEGADES,
    reversed = true,
    unlockPrice = 1000000,
    unlockTime = 800*3600, --500
    armor = isNoDonate && 500 || 600,
    health = isNoDonate && 200 || 250,
    max = 1,
    speed = 1.1,
        slavePrice = 2000, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 260, -- Время заключения для пленника этой профы / фракции  
    })
*/

/*
    rp.AddDoorGroup('Ренегаты', rp.GetFactionTeams(FACTION_RENEGADES))
    rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_RENEGADES})))
*/