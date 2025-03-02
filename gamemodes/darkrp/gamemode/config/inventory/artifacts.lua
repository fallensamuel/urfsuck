-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\artifacts.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.AddArtifact( {
    name = "Сучья погремушка",
    ent = "art_antiexplosion",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_dummy_dummy.mdl",
    price = 31256,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1785,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1785,
        },
    },
	
	charges = 5,
    modifiers = {
		["movespeed"] = 0.05,
		["jumppower"] = 0.1,
        ["radiation"] = 4,
    },
} );

rp.AddArtifact( {
    name = "Пузырь",
    ent = "art_ballon",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_baloon.mdl",
    price = 25000,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1221,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1221,
        },
    },
	
	charges = 5,
    modifiers = {
        ["radiation"] = -6,
    },
} );

rp.AddArtifact( {
    name = "Кровь камня",
    ent = "art_blood",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_blood.mdl",
    price = 28250,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1580,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1580,
        },
    },
	
	charges = 10,
    modifiers = {
        ["maxhealth"] = 5,
		["damagemult"] = 0.05,
    },
} );

rp.AddArtifact( {
    name = "Компас",
    ent = "art_compass",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_compass.mdl",
    price = 34510,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1945,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1945,
        },
    },

    charges = 1,
    modifiers = {
        ["teleport"] = 1,
    },
} );

rp.AddArtifact( {
    name = "Штурвал",
    ent = "art_control",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_control.mdl",
    price = 35126,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 3300,
        },
        ["Ученый ЧН"] = {
            sellPrice = 3300,
        },
    },
	
	charges = 5,
    modifiers = {
        ["maxhealth"] = 30,
        ["radiation"] = 16,
    },
} );

rp.AddArtifact( {
    name = "Кристалл",
    ent = "art_crystal",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_cristall.mdl",
    price = 26354,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1425,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1425,
        },
    },

    charges = 10,
    modifiers = {
        ["radiation"] = 2,
		["maxhealth"] = 5,
    },
} );

rp.AddArtifact( {
    name = "Каменный Цветок",
    ent = "art_crystalflower",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_cristall_flower.mdl",
    price = 36525,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 2420,
        },
        ["Ученый ЧН"] = {
            sellPrice = 2420,
        },
    },
	
	charges = 5,
    modifiers = {
		["maxhealth"] = 10,
		["damagemult"] = 0.1,
    },
} );

rp.AddArtifact( {
    name = "Сердце Оазиса",
    ent = "art_crystalplant",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_cristall_plant.mdl",
    price = 160000,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 15000,
        },
        ["Ученый ЧН"] = {
            sellPrice = 15000,
        },
    },
	
	charges = 3,
    modifiers = {
		["jumppower"] = 0.12,
		["jumppower"] = 0.12,
		["maxhealth"] = 50,
		["regeneration"] = 3,
		["radiation"] = 16,
    },
} );

rp.AddArtifact( {
    name = "Пустышка",
    ent = "art_dummy",
    model = "models/flaymi/anomaly/dynamics/artefacts/artefact_pustishka.mdl",
    price = 24536,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1200,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1200,
        },
    },
	
	charges = 5,
    modifiers = {
		["movespeed"] = 0.05,
		["radiation"] = 2,
		["jumppower"] = -0.02,
    },
} );

rp.AddArtifact( {
    name = "Батарейка",
    ent = "art_dummybattary",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_dummy_battery.mdl",
    price = 20000,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 950,
        },
        ["Ученый ЧН"] = {
            sellPrice = 950,
        },
    },
	
	charges = 10,
    modifiers = {
		["jumppower"] = 0.05,
		["radiation"] = 1.5,
    },
} );

rp.AddArtifact( {
    name = "Мамины бусы",
    ent = "art_dummyglass",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_dummy_glassbeads.mdl",
    price = 33256,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 2355,
        },
        ["Ученый ЧН"] = {
            sellPrice = 2355,
        },
    },
	
	charges = 5,
    modifiers = {
		["hungerrate"] = 0.4,
		["movespeed"] = -0.02,
    },
} );

rp.AddArtifact( {
    name = "Вспышка",
    ent = "art_electra",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_electra_flash.mdl",
    price = 29865,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1530,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1530,
        },
    },
	
	charges = 10,
    modifiers = {
		["jumppower"] = 0.04,
		["movespeed"] = -0.03,
		
    },
} );

rp.AddArtifact( {
    name = "Светляк",
    ent = "art_electraflash",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_glass.mdl",
    price = 28654,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1460,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1460,
        },
    },
	
	charges = 5,
    modifiers = {
		["maxhealth"] = 10,
		["damagemult"] = 0.025,
		["radiation"] = 3,
    },
} );

rp.AddArtifact( {
    name = "Глаз",
    ent = "art_eye",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_eye.mdl",
    price = 27545,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1253,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1253,
        },
    },
	
	charges = 5,
    modifiers = {
		["regeneration"] = 1.5,
		["radiation"] = 3,
		["hungerrate"] = 0.1,
    },
} );

rp.AddArtifact( {
    name = "Пламя",
    ent = "art_fire",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_fire.mdl",
    price = 30000, 
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1500,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1500,
        },
    },
	
	charges = 5,
    modifiers = {
		["maxhealth"] = 15,
		["movespeed"] = -0.02,
		["radiation"] = 1.5,
    },
} );

rp.AddArtifact( {
    name = "Золотая Рыбка",
    ent = "art_goldfish",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_gold_fish.mdl",
    price = 32546,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 2050,
        },
        ["Ученый ЧН"] = {
            sellPrice = 2050,
        },
    },
	
	charges = 5,
    modifiers = {
		["damagemult"] = -0.1,
		["movespeed"] = -0.1,
		["jumppower"] = -0.1,
    },
} );

rp.AddArtifact( {
    name = "Грави",
    ent = "art_gravi",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_gravi.mdl",
    price = 27456,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1355,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1355,
        },
    },
	
	charges = 5,
    modifiers = {
		["damagemult"] = -0.05,
		["radiation"] = 4,
        ["jumppower"] = 0.1,
    },
} );

rp.AddArtifact( {
    name = "Ледышка",
    ent = "art_ice",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_ice_2.mdl",
    price = 26589,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1300,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1300,
        },
    },
	
	charges = 5,
    modifiers = {
		["jumppower"] = 0.1,
		["radiation"] = 1.5,
		["movespeed"] = -0.03,
    },
} );

rp.AddArtifact( {
    name = "Колобок",
    ent = "art_kolobok",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_fuzz_kolobok.mdl",
    price = 27566,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1155,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1155,
        },
    },
	
	charges = 5,
    modifiers = {
		["regeneration"] = 1,
		["radiation"] = 3,
		["maxhealth"] = 5,
    },
} );

rp.AddArtifact( {
    name = "Медуза",
    ent = "art_medusa",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_medusa.mdl",
    price = 28544,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1625,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1625,
        },
    },
	
	charges = 10,
    modifiers = {
		["radiation"] = -2,
		["hungerrate"] = -0.05,
    },
} );

rp.AddArtifact( {
    name = "Ломоть Мяса",
    ent = "art_mincermeat",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_mincer_meat.mdl",
    price = 29875,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1150,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1150,
        },
    },
	
	charges = 10,
    modifiers = {
		["hungerrate"] = 0.05,
		["movespeed"] = 0.03,
		["radiation"] = 3,
    },
} );

rp.AddArtifact( {
    name = "Ночная Звезда",
    ent = "art_nightstar",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_night_star.mdl",
    price = 27856,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1255,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1255,
        },
    },
	
	charges = 10,
    modifiers = {
		["damagemult"] = -0.01,
		["maxhealth"] = 2,
		["radiation"] = 1,
    },
} );

rp.AddArtifact( {
    name = "Пси-Изолятор",
    ent = "art_psi",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_psi_field.mdl",
    price = 30050,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
	allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 3125,
        },
        ["Ученый ЧН"] = {
            sellPrice = 3125,
        },
    },
	
	charges = 10,
    modifiers = {
		["radiation"] = -8,
		
    },
} );

rp.AddArtifact( {
    name = "Душа",
    ent = "art_soul",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_soul.mdl",
    price = 21000,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 855,
        },
        ["Ученый ЧН"] = {
            sellPrice = 855,
        },
    },
	
	charges = 10,
    modifiers = {
		["regeneration"] = 1,
		["radiation"] = 1,
    },
} );

rp.AddArtifact( {
    name = "Выверт",
    ent = "art_vyvert",
    model = "models/flaymi/anomaly/dynamics/artefacts/af_vyvert.mdl",
    price = 23000,
    count = 1,
    seperate = false,
    pricesep = 1000,
    noship = false,
    allowed = {false},
    vendor = {
        ["Профессор Сахаров"] = {
            sellPrice = 1150,
        },
        ["Ученый ЧН"] = {
            sellPrice = 1150,
        },
    },
	
	charges = 10,
    modifiers = {
		["radiation"] = 1,
		["damagemult"] = -0.05,
    },
} );

