-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\shipments_vendor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Бустеры

rp.AddEntity({
  name = "Нелегальный Бустер",
  ent = "rpitem_printerbooster_1",
  model = "models/2rek/lithium_printers_2/lp2_storage1.mdl",
  rarity = "Нелегальная Сборка",
  desc = "Бустер для майнеров, неизвестного производства. Обладает незаурядными характеристиками:\n Модификатор Ускорения: 20%\n Время Действия: 300 сек\n ВНИМАНИЕ! СПОСОБСТВУЕТ УВЕЛИЧЕНИЮ ВЕРОЯТНОСТИ ВОЗГОРАНИЯ!",
  allowed = {false},
  price = 0,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
        ["Незнакомец"] = {
            buyPrice = 750
        }
  }
})

rp.AddEntity({
  name = "Самодельный Бустер",
  ent = "rpitem_printerbooster_2",
  model = "models/2rek/lithium_printers_2/lp2_storage1.mdl",
  rarity = "Кустарная Сборка",
  desc = "Мусорный бустер для майнеров, кустарного производства. Обладает следующими характеристиками:\n Модификатор Ускорения: 25%\n Время Действия: 450 сек\n ВНИМАНИЕ! СПОСОБСТВУЕТ УВЕЛИЧЕНИЮ ВЕРОЯТНОСТИ ВОЗГОРАНИЯ!",
  allowed = {false},
  price = 0,
  count = 1,
  stackable = true,
  maxStack = 20,
})

rp.AddEntity({
  name = "Военный Бустер",
  ent = "rpitem_printerbooster_4",
  model = "models/2rek/lithium_printers_2/lp2_storage2.mdl",
  rarity = "Сборка ВСУ",
  desc = "Редкий бустер для майнеров, созданный частными учеными Украины. Обладает следующими характеристиками:\n Модификатор Умножения: 300%\n Время Действия: 600 сек\n ВНИМАНИЕ! СПОСОБСТВУЕТ УВЕЛИЧЕНИЮ ВЕРОЯТНОСТИ ВОЗГОРАНИЯ!",
  allowed = {false},
  price = 0,
  count = 1,
  stackable = true,
  maxStack = 20,
})

rp.AddEntity({
  name = "Научный Бустер",
  ent = "rpitem_printerbooster_3",
  model = "models/2rek/lithium_printers_2/lp2_storage2.mdl",
  rarity = "Сборка НИГ",
  desc = "Наиредчайший бустер для майнеров, подпольно созданный умельцами из НИГ, с применением передовых технологий. Обладает следующими характеристиками:\n Модификатор Ускорения: 60%\n Время Действия: 400 сек\n ВНИМАНИЕ! СПОСОБСТВУЕТ УВЕЛИЧЕНИЮ ВЕРОЯТНОСТИ ВОЗГОРАНИЯ!",
  allowed = {false},
  price = 0,
  count = 1,
  stackable = true,
  maxStack = 20,
})

rp.AddEntity({
  name = "Бустер О-сознания",
  ent = "rpitem_printerbooster_5",
  model = "models/2rek/lithium_printers_2/lp2_storage3.mdl",
  rarity = "Сборка О-сознания",
  desc = "Легендарный бустер для майнеров, неизвестно как и где он был создан, но известно одно - что лучше него во всей ЧЗО нету! Обладает следующими характеристиками:\n Модификатор Ускорения: 80%\n Время Действия: 300 сек",
  allowed = {false},
  price = 0,
  count = 1,
  stackable = true,
  maxStack = 20,
})

------------------
--STALKER REWORK--
------------------

-- расходники

rp.AddWeapon({
    name = "Водка",
    ent = "foodswep_vodka",
    model = "models/flaymi/anomaly/dynamics/devices/dev_vodka2.mdl",
    count = 1,
    stackable = true,
    maxStack = 20,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_SHUSTRIY, TEAM_GADEX},
    price = 50,
    vendor = {
        ["Мадама"] = {
            buyPrice = 110,
        },
        ["Гаваец"] = {
            buyPrice = 160,
        },
        ["Сталкер Колобок"] = {
            buyPrice = 160,
        }
         }
})

rp.AddEntity({
    name = "Обычная аптечка",
    ent = "health_kit_bad",
    model = "models/flaymi/anomaly/dynamics/devices/dev_aptechka_low.mdl",
    price = 1800,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GADEX},
    count = 3,
    vendor = {
        ["Гаваец"] = {
            sellPrice = 220,
            buyPrice = 2500
        },
        ["Незнакомец"] = {
            sellPrice = 250,
            buyPrice = 2400
        }
    }
})

rp.AddShipment({
    name = "Армейская аптечка",
    ent = "health_kit_normal",
    model = "models/flaymi/anomaly/dynamics/devices/dev_aptechka_high.mdl",
    price = 6500,
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 1,
    vendor = {
       ["Незнакомец"] = {
            sellPrice = 620,
          buyPrice = 5200
        }
    }
})

rp.AddShipment({
    name = "Научная аптечка",
    ent = "health_kit_best",
    model = "models/flaymi/anomaly/dynamics/devices/dev_aptechka_mid.mdl",
    count = 3,
    maxStack = 3,
    price = 15000,
    stackable = true,
    allowed = {TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_UCHENIY, TEAM_GADEX},
    vendor = {
        ["Незнакомец"] = {
            sellPrice = 1200,
            buyPrice = 13500
        }
    }
})

rp.AddEntity({
    name = "Обезболивающее",
    ent = "ent_anesthetic",
    model = "models/flaymi/anomaly/dynamics/equipments/medical/drug_psy_blockade.mdl",
    count = 5,
    seperate = false,
    noship = false,
    base = 'usable',
    price = 500,
    allowed = {TEAM_JEW, TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_GADEX},
    vendor = {
        ["Гаваец"] = {
            sellPrice = 40,
            buyPrice = 320
        },
        ["Профессор Сахаров"] = {
            buyPrice = 200
        },
        ["Незнакомец"] = {
            sellPrice = 50,
            buyPrice = 260
        }
    }
})

--—————————————————————
--Новая еда
--—————————————————————

rp.AddWeapon({
    name = "Чай",
    ent = "foodswep_tea",
    model = "models/flaymi/anomaly/dynamics/devices/dev_drink_water.mdl",
    count = 1,
    stackable = true,
    maxStack = 20,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_GADEX},
    price = 85,
    vendor = {
        ["Мадама"] = {
            buyPrice = 20,
        },
        ["Гаваец"] = {
            buyPrice = 40,
        }
    }
})

rp.AddWeapon({
    name = "Грибной Суп",
    ent = "foodswep_soup",
    model = "models/flaymi/anomaly/dynamics/devices/dev_conserv.mdl",
    count = 1,
    stackable = true,
    maxStack = 20,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_GADEX},
    price = 40,
    vendor = {
        ["Мадама"] = {
            buyPrice = 65,
        },
        ["Сидорович"] = {
            buyPrice = 135,
        },
        ["Гаваец"] = {
            buyPrice = 110,
        }
    }
})

rp.AddWeapon({
    name = "Жареное Мясо",
    ent = "foodswep_meat",
    model = "models/flaymi/anomaly/dynamics/devices/dev_salmon.mdl",
    count = 1,
    stackable = true,
    maxStack = 20,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_GADEX},
    price = 55,
    vendor = {
        ["Мадама"] = {
            buyPrice = 78,
        },
        ["Сидорович"] = {
            buyPrice = 190,
        },
        ["Гаваец"] = {
            buyPrice = 140,
        },
        ["Кислый"] = {buyPrice = 135}
    }
})

rp.AddWeapon({
    name = "Военные Консервы",
    ent = "foodswep_conserva",
    model = "models/flaymi/anomaly/dynamics/devices/dev_tushonka.mdl",
    count = 1,
    stackable = true,
    maxStack = 20,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_GADEX},
    price = 67,
    vendor = {
        ["Дежурный"] = {
            buyPrice = 90,
        },
        ["Гаваец"] = {
            buyPrice = 150,
        }
    }
})

---------------
-----РАЗНОЕ----
---------------

rp.AddShipment({
    name = "Взломщики",
    ent = "hacktool",
    model = "models/weapons/w_hacktool.mdl",
    count = 5,
    maxStack = 20,
    seperate = false,
    noship = false,
    price = 500,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_GAVAECKEYS, TEAM_GADEX},
    vendor = {
        ["Гаваец"] = {
            sellPrice = 25,
            buyPrice = 260
        },
        ["Дежурный"] = {
            sellPrice = 50,
        },
        ["Незнакомец"] = {
            sellPrice = 35,
            buyPrice = 170
        }
    }
})

rp.AddShipment({
    name = "Отмычки",
    ent = "lockpick",
    model = "models/weapons/w_crowbar.mdl",
    count = 5,
    price = 400,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_GAVAECKEYS, TEAM_GADEX},
    maxStack = 20,
    seperate = false,
    noship = false,
    vendor = {
        ["Гаваец"] = {
            sellPrice = 20,
            buyPrice = 240
        },
        ["Дежурный"] = {
            sellPrice = 50,
        },
        ["Незнакомец"] = {
            sellPrice = 35,
            buyPrice = 150
        }
    }
})

-- Снаряжение
rp.AddShipment({
    name = "Камуфляжная Заря",
    ent = "ent_cloth8",
    model = "models/flaymi/anomaly/dynamics/outfit/svoboda_light_outfit.mdl",
    price = 1500,
    count = 1,
    seperate = false,
    pricesep = 550,
    noship = false,
    stackable = true,
    base = 'usable',
    allowed = {TEAM_GAVAECKEYS, TEAM_SHUSTRIY, TEAM_KOLPAK, TEAM_GADEX},
    maxStack = 3,
    stackable = true,
})

rp.AddShipment({
    name = "Уплотненный Экзоскелет",
    ent = "ent_cloth9",
    model = "models/flaymi/anomaly/dynamics/outfit/bandit_exo_outfit.mdl",
    price = 2300,
    count = 1,
    seperate = false,
    pricesep = 550,
    noship = false,
    stackable = true,
    base = 'usable',
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    maxStack = 3,
    stackable = true,
})

rp.AddEntity({
    name = "Комбинезон Сева",
    ent = "ent_cloth6",
    model = "models/flaymi/anomaly/dynamics/outfit/scientific_outfit.mdl",
    count = 1,
    maxStack = 5,
    seperate = false,
    base = 'usable',
    noship = false,
    stackable = true,
    price = 8000,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_GADEX},
    vendor = {
        ["Профессор Сахаров"] = {
            buyPrice = 10000
        },
        ["Незнакомец"] = {
            sellPrice = 1500,
            buyPrice = 12500
        }
    }
})

rp.AddEntity({
    name = "Экзоскелет",
    ent = "ent_cloth7",
    model = "models/flaymi/anomaly/dynamics/outfit/rn_exo_outfit.mdl",
    count = 1,
    maxStack = 5,
    price = 10000,
    seperate = false,
    base = 'usable',
    stackable = true,
    noship = false,
    allowed = {TEAM_GAVAECKEYS, TEAM_KOLPAK, TEAM_GADEX},
    vendor = {
        ["Гаваец"] = {
            sellPrice = 1200,
            buyPrice = 10800
        },
        ["Незнакомец"] = {
            sellPrice = 1250,
            buyPrice = 10500
        }
    }
})

rp.AddShipment({
    name = "Булат",
    ent = "ent_cloth_orden_heavy",
    model = "models/flaymi/anomaly/dynamics/outfit/specops_outfit.mdl",
    price = 5500,
    count = 1,
    seperate = false,
    pricesep = 550,
    noship = false,
    base = 'usable',
    allowed = {TEAM_KROT, TEAM_SHUSTRIY, TEAM_GADEX},
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "ССП-99 Эколог",
    ent = "ent_cloth10",
    model = "models/flaymi/anomaly/dynamics/outfit/ecolog_outfit_green.mdl",
    price = 5500,
    count = 1,
    seperate = false,
    pricesep = 550,
    noship = false,
    base = 'usable',
    allowed = {TEAM_UCHENIY, TEAM_GADEX},
    maxStack = 5,
    stackable = true,
})



rp.AddEntity({
    name = "Комбинезон Края",
    ent = "ent_cloth5",
    model = "models/flaymi/anomaly/dynamics/outfit/killer_scientific_outfit.mdl",
    count = 1,
    maxStack = 3,
    price = 10000,
    allowed = {TEAM_UCHENIY, TEAM_GAVAECKEYS, TEAM_GADEX},
    seperate = false,
    base = 'usable',
    noship = false,
    vendor = {
        ["Гаваец"] = {
            sellPrice = 650,
            buyPrice = 15375
        },
        ["Незнакомец"] = {
            sellPrice = 700,
            buyPrice = 10505
        }
    }
})


-- Прочее
rp.AddShipment({
    name = "Пропуск в ЧЗО",
    ent = "pass_vsu",
    model = "models/kerry/dea_pass.mdl",
    count = 1,
    maxStack = 1,
    price = 850,
    allowed = {TEAM_SHUSTRIY, TEAM_KOLPAK, TEAM_GENERAL, TEAM_SEC, TEAM_EPU, TEAM_GADEX},
    vendor = {
        ["Гаваец"] = {
            buyPrice = 1250
        },
        ["Незнакомец"] = {
            buyPrice = 790
        }
    }
})

rp.AddShipment({
    name = "Фальшивый Пропуск в ЧЗО",
    ent = "pass_vsu_fake",
    model = "models/kerry/dea_pass.mdl",
    count = 1,
    maxStack = 1,
    price = 250,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_SHUSTRIY,TEAM_GAVAECKEYS},
    vendor = {
        ["Дежурный"] = {
            sellPrice = 150,
        },
        ["Незнакомец"] = {
            buyPrice = 200
        }
    }
})

rp.AddShipment({
    name = "Детектор \"Медведь\"",
    ent = "detector_bear",
    model = "models/kali/miscstuff/stalker/detector_bear.mdl",
    price = 500,
    allowed = {TEAM_KOLPAK, TEAM_JEW, TEAM_KROT},
    vendor = {
        ["Гаваец"] = {
            buyPrice = 750
        },
        ["Незнакомец"] = {
            buyPrice = 500
        }
    }
})

rp.AddShipment({
    name = "Детектор \"Велес\"",
    ent = "detector_veles",
    model = "models/kali/miscstuff/stalker/detector_veles.mdl",
    price = 500,
    allowed = {TEAM_GAVAECKEYS, TEAM_SHUSTRIY, TEAM_GADEX},
    vendor = {
        ["Незнакомец"] = {
            buyPrice = 1200
        },
        ["Профессор Сахаров"] = {
            buyPrice = 850
        }
    }
})

-- Патроны
rp.AddAmmoType({
    name = "Пистолетные патроны",
    ent = "Pistol",
    model = "models/flaymi/anomaly/ammo/ammo_9x18_fmj.mdl",
    ammoType = "Pistol",
    amountGiven = 25,
    price = 25,
    --allowed = {TEAM_EGER, TEAM_BARIGA, TEAM_CLEANER},
    vendor = {
        ["Гаваец"] = {
            buyPrice = 8
        },
        ["Незнакомец"] = {
            buyPrice = 5
        }
    }
})

rp.AddAmmoType({
    name = "Картечь для Дробовика",
    ent = "Buckshot",
    model = "models/flaymi/anomaly/ammo/ammo_12x70_buck.mdl",
    ammoType = "Buckshot",
    amountGiven = 25,
    price = 35,
    vendor = {
        ["Гаваец"] = {
            buyPrice = 18
        },
        ["Незнакомец"] = {
            buyPrice = 10
        }
    }
})

rp.AddAmmoType({
    name = "Патроны для ПП",
    ent = "smg1",
    model = "models/flaymi/anomaly/ammo/ammo_57x28_s190.mdl",
    ammoType = "smg1",
    amountGiven = 90,
    price = 25,
    vendor = {
        ["Гаваец"] = {
            buyPrice = 12
        },
        ["Незнакомец"] = {
            buyPrice = 8
        }
    }
})

rp.AddAmmoType({
    name = "Патроны для Автомата",
    ent = "ar2",
    model = "models/flaymi/anomaly/ammo/ammo_545x39_ap.mdl",
    ammoType = "ar2",
    amountGiven = 60,
    price = 38,
    vendor = {
        ["Гаваец"] = {
            buyPrice = 20
        },
        ["Незнакомец"] = {
            buyPrice = 11
        }
    }
})

rp.AddAmmoType({
    name = "Патроны для Револьвера",
    ent = "357",
    model = "models/flaymi/anomaly/ammo/ammo_357_jhp.mdl",
    ammoType = "357",
    price = 20,
    amountGiven = 12,
    vendor = {
        ["Гаваец"] = {
            buyPrice = 10
        },
        ["Незнакомец"] = {
            buyPrice = 6
        }
    }
})

rp.AddAmmoType({
    name = "Патроны для Снайперки",
    ent = "SniperPenetratedRound",
    model = "models/flaymi/anomaly/ammo/ammo_762x54_7h1.mdl",
    ammoType = "SniperPenetratedRound",
    amountGiven = 10,
    price = 50,
    vendor = {
        ["Гаваец"] = {
            buyPrice = 28
        },
        ["Незнакомец"] = {
            buyPrice = 15
        }
    }
})

-- Ученый
rp.AddItem({
    name = "Водка",
    ent = "antirad_vodka",
    model = "models/flaymi/anomaly/dynamics/decor/butilka_vodka_01.mdl",
     price = 200,
     base = 'usable',
     allowed = {false},
    category = "foods",
    maxStack = 1,
    vendor = {
        ["Гаваец"] = {buyPrice = 90},
        ["Незнакомец"] = {buyPrice = 85}
    },
})

-------------------------------------------------
-------------------ВООРУЖЕНИЕ--------------------
-------------------------------------------------

-------------------ПИСТОЛЕТЫ---------------------

rp.AddShipment({
    name = "Browning Hi-Power",
    ent = "tfa_anomaly_hpsa",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_hpsa_w.mdl",
    price = 250,
    allowed = {TEAM_JEW, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Гаваец"] = {sellPrice = 50,buyPrice = 300},
        ["Незнакомец"] = {sellPrice = 75,buyPrice = 320},
        ["Дежурный"] = {sellPrice = 100},
    },
})

rp.AddShipment({
    name = "Colt 1911",
    ent = "tfa_anomaly_colt1911",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_colt1911_w.mdl",
    price = 250,
    allowed = {TEAM_JEW, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Гаваец"] = {sellPrice = 50,buyPrice = 300},
        ["Незнакомец"] = {sellPrice = 75,buyPrice = 320},
        ["Дежурный"] = {sellPrice = 100},
    },
})

rp.AddShipment({
    name = "Berreta 92F",
    ent = "tfa_anomaly_beretta",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_beretta92fs.mdl",
    price = 300,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 125}
    },
})

rp.AddShipment({
    name = "Desert Eagle",
    ent = "tfa_anomaly_desert_eagle",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_desert_eagle_w.mdl",
    price = 350,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 150}
    },
})

rp.AddShipment({
    name = "CZ-75 Auto",
    ent = "tfa_anomaly_cz75_auto",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_cz75_auto_w.mdl",
    price = 300,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 110}
    },
})

rp.AddShipment({
    name = "FN Five_seveN",
    ent = "tfa_anomaly_fn57",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_fn57_w.mdl",
    price = 300,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
        vendor = {
        ["Дежурный"] = {sellPrice = 120}
    },
})

rp.AddShipment({
    name = "FNX 45 Tactical",
    ent = "tfa_anomaly_fnx45",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_fnx45_w.mdl",
    price = 325,
    allowed = {TEAM_KOLPAK, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 150}
    },
})

rp.AddShipment({
    name = "Glock 19",
    ent = "tfa_anomaly_glock",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_glock_w.mdl",
    price = 265,
    allowed = {TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Незнакомец"] = {sellPrice = 75,buyPrice = 285},
        ["Дежурный"] = {sellPrice = 100}
    },
})

rp.AddShipment({
    name = "TT-33",
    ent = "tfa_anomaly_tt33",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_tt33_w.mdl",
    price = 260,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Гаваец"] = {sellPrice = 50,buyPrice = 265},
        ["Незнакомец"] = {sellPrice = 75,buyPrice = 275},
        ["Дежурный"] = {sellPrice = 100}
    },
})

rp.AddShipment({
    name = "PM",
    ent = "tfa_anomaly_pm",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_pmm_w.mdl",
    price = 275,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Гаваец"] = {sellPrice = 75,buyPrice = 295},
        ["Незнакомец"] = {sellPrice = 100,buyPrice = 285},
        ["Дежурный"] = {sellPrice = 110}
    },
})

------------------------------ППШКИ------------------------------

rp.AddShipment({
    name = "9A-91",
    ent = "tfa_anomaly_9a91",
    model = "models/flaymi/anomaly/weapons/w_models/9a91.mdl",
    price = 500,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 250}
    },
})

rp.AddShipment({
    name = "HK MP7",
    ent = "tfa_anomaly_mp7",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_mp7_w.mdl",
    price = 600,
    allowed = {TEAM_JEW, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 260}
    },
})

rp.AddShipment({
    name = "MP5A3",
    ent = "tfa_anomaly_mp5",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_mp5_w.mdl",
    price = 615,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 260}
    },
})

rp.AddShipment({
    name = "MP5SD6",
    ent = "tfa_anomaly_mp5sd",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_mp5sd_w.mdl",
    price = 625,
    allowed = {TEAM_SHUSTRIY},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 275}
    },
})

rp.AddShipment({
    name = "Scorpion .vz61",
    ent = "tfa_anomaly_vz61",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_vz61_w.mdl",
    price = 525,
    allowed = {TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 252}
    },
})

rp.AddShipment({
    name = "UMP-45",
    ent = "tfa_anomaly_ump45",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_ump45_w.mdl",
    price = 595,
    allowed = {TEAM_KOLPAK, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 235}
    },
})

rp.AddShipment({
    name = "ПП-2000",
    ent = "tfa_anomaly_pp2000",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_pp2000_w.mdl",
    price = 585,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 245}
    },
})

rp.AddShipment({
    name = "ПП-19 Бизон",
    ent = "tfa_anomaly_bizon",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_bizon_w.mdl",
    price = 900,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "FN P90",
    ent = "tfa_anomaly_p90",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_p90_w.mdl",
    price = 1250,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

------------------------------ДРОБОВИКИ------------------------------

rp.AddShipment({
    name = "Форт-500",
    ent = "tfa_anomaly_fort500",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_fort500500_w.mdl",
    price = 1250,
    allowed = {TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 350}
    },
})

rp.AddShipment({
    name = "ТОЗ-66",
    ent = "tfa_anomaly_bm16_full",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_full_w.mdl",
    price = 900,
    allowed = {TEAM_JEW},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 300}
    },
})

rp.AddShipment({
    name = "ТОЗ-34",
    ent = "tfa_anomaly_toz34",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_w.mdl",
    price = 900,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 300}
    },
})

rp.AddShipment({
    name = "Обрез ТОЗ-34",
    ent = "tfa_anomaly_toz34_sawedoff",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_toz34_obrez_w.mdl",
    price = 850,
    allowed = {TEAM_JEW},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 325}
    },
})

rp.AddShipment({
    name = "Сайга-12С",
    ent = "tfa_anomaly_saiga",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_saiga12s_w.mdl",
    price = 3250,
    allowed = {TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "Обрез ТОЗ-66",
    ent = "tfa_anomaly_bm16",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_bm16_w.mdl",
    price = 850,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 325}
    },
})

rp.AddShipment({
    name = "SPAS-12",
    ent = "tfa_anomaly_spas12",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_spas12_w.mdl",
    price = 1450,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 425}
    },
})

rp.AddShipment({
    name = "MP-133",
    ent = "tfa_anomaly_mp133",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_mp133_w.mdl",
    price = 1400,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 400}
    },
})

rp.AddShipment({
    name = "Armsel Protecta",
    ent = "tfa_anomaly_protecta",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_protecta_w.mdl",
    price = 3525,
    allowed = {TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
})

------------------------------СНАЙПЕРКИ------------------------------

rp.AddShipment({
    name = "СВД",
    ent = "tfa_anomaly_svd",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_svd_w.mdl",
    price = 2500,
    allowed = {TEAM_KOLPAK, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 425}
    },
})

rp.AddShipment({
    name = "СВТ-40",
    ent = "tfa_anomaly_svt",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_svt40_w.mdl",
    price = 1560,
    allowed = {TEAM_KROT, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 302}
    },
})

rp.AddShipment({
    name = "Винтовка Мосина",
    ent = "tfa_anomaly_mosin",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_mosin_w.mdl",
    price = 1200,
    allowed = {TEAM_JEW, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 320}
    },
})

rp.AddShipment({
    name = "ОЦ-03 СВУ",
    ent = "tfa_anomaly_svu",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_svu_w.mdl",
    price = 2600,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 325}
    },
})

rp.AddShipment({
    name = "SIG SG550-1 Sniper",
    ent = "tfa_anomaly_sig550_sniper",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_sig550_sniper_w.mdl",
    price = 2750,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 345}
    },
})

------------------------------ТЯЖЕЛОЕ------------------------------

rp.AddShipment({
    name = "ПКМ",
    ent = "tfa_anomaly_pkm",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_pkm_w.mdl",
    price = 3450,
    allowed = {TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "РПК",
    ent = "tfa_anomaly_rpk",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_rpk_w.mdl",
    price = 3550,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "РПД",
    ent = "tfa_anomaly_rpd",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_rpd_w.mdl",
    price = 3645,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

------------------------------АВТОМАТЫ------------------------------

rp.AddShipment({
    name = "FN FAL",
    ent = "tfa_anomaly_fal",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_fal_w.mdl",
    price = 1450,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "FN F2000",
    ent = "tfa_anomaly_fn2000",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_fn2000_nimble_w.mdl",
    price = 1650,
    allowed = {TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "FAMAS F3",
    ent = "tfa_anomaly_famas",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_famas3_w.mdl",
    price = 1350,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "FN SCAR-H",
    ent = "tfa_anomaly_scar",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_scar_w.mdl",
    price = 1250,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "G36",
    ent = "tfa_anomaly_g36",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_g36_w.mdl",
    price = 1300,
    allowed = {TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 300}
    },
})

rp.AddShipment({
    name = "GALIL AR",
    ent = "tfa_anomaly_galil",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_galil_w.mdl",
    price = 1100,
    allowed = {TEAM_JEW},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 290}
    },
})

rp.AddShipment({
    name = "HK416",
    ent = "tfa_anomaly_hk416",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_hk416_w.mdl",
    price = 1450,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 320}
    },
})

rp.AddShipment({
    name = "L85A1",
    ent = "tfa_anomaly_l85",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_l85_w.mdl",
    price = 1375,
    allowed = {TEAM_KOLPAK, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 328}
    },
})

rp.AddShipment({
    name = "LR300 ML",
    ent = "tfa_anomaly_lr300",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_lr300_w.mdl",
    price = 1380,
    allowed = {TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 327}
    },
})

rp.AddShipment({
    name = "Steyr AUG A1",
    ent = "tfa_anomaly_aug_a1",
    model = "models/flaymi/anomaly/weapons/w_models/w_aug_a1.mdl",
    price = 1750,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 400}
    },
})

rp.AddShipment({
    name = "AK101",
    ent = "tfa_anomaly_ak101",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_ak101_w.mdl",
    price = 1475,
    allowed = {TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 355}
    },
})

rp.AddShipment({
    name = "AK74",
    ent = "tfa_anomaly_ak74",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_ak74.mdl",
    price = 1100,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 300}
    },
})

rp.AddShipment({
    name = "AKS",
    ent = "tfa_anomaly_aks",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_aks.mdl",
    price = 1000,
    allowed = {TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 275}
    },
})

rp.AddShipment({
    name = "АС ВАЛ",
    ent = "tfa_anomaly_val",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_val_w.mdl",
    price = 1450,
    allowed = {TEAM_SHUSTRIY, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 365}
    },
})

rp.AddShipment({
    name = "ГРОЗА-1",
    ent = "tfa_anomaly_groza_nimble",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_groza_nimble_w.mdl",
    price = 1650,
    allowed = {TEAM_KOLPAK, TEAM_GADEX},
    count = 1,
    maxStack = 5,
    stackable = true,
    vendor = {
        ["Дежурный"] = {sellPrice = 425}
    },
})

------------------------------ВЗРЫВЧАТКА------------------------------

rp.AddShipment({
    name = "Термитная Граната",
    ent = "tfa_anomaly_gd5",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_gd5_w.mdl",
    price = 3000,
    allowed = {false},
    count = 10,
    maxStack = 5,
    stackable = true,
    onEquipWeapon = function(item, client, weapon)
        weapon:SetClip1(1)
    end,
})

rp.AddShipment({
    name = "Граната Ф1",
    ent = "tfa_anomaly_f1",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_f1_w.mdl",
    price = 1500,
    allowed = {TEAM_JEW, TEAM_SHUSTRIY},
    count = 10,
    maxStack = 5,
    stackable = true,
    onEquipWeapon = function(item, client, weapon)
        weapon:SetClip1(1)
    end,
})


rp.AddShipment({
    name = "Граната РГД-5",
    ent = "tfa_anomaly_rgd5",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_rgd5_w.mdl",
    price = 2500,
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    count = 10,
    maxStack = 5,
    stackable = true,
    onEquipWeapon = function(item, client, weapon)
        weapon:SetClip1(1)
    end,
})

rp.AddShipment({
    name = "SLAM",
    ent = "weapon_slam",
    model = "models/weapons/w_slam.mdl",
    price = 2500,
    allowed = {TEAM_KOLPAK, TEAM_GAVAECKEYS, TEAM_GADEX},
    count = 5,
    maxStack = 3,
    stackable = true,
    onEquipWeapon = function(item, client, weapon, saved_ammo)
        if saved_ammo == nil then
            --client:SetAmmo(3, weapon:GetPrimaryAmmoType());
            client:SetAmmo(3, weapon:GetSecondaryAmmoType());
        end
    end,
})

------------------------------БЛИЖКА------------------------------

rp.AddShipment({
    name = "Штык-нож M9",
    ent = "tfa_anomaly_knife_combat",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_knife_combat_w.mdl",
    price = 400,
    allowed = {TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_GAVAECKEYS},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "Штык-нож 6x4",
    ent = "tfa_anomaly_knife",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_knife_w.mdl",
    price = 200,
    allowed = {TEAM_JEW, TEAM_KROT},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "Охотничий нож",
    ent = "tfa_anomaly_knife_hunting",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_knife_hunting_w.mdl",
    price = 250,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "Охотничий топор",
    ent = "tfa_anomaly_axe3",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_axe2.mdl",
    price = 350,
    allowed = {TEAM_JEW},
    count = 1,
    maxStack = 5,
    stackable = true,
})

----------------------LEGENFARY

rp.AddShipment({
    name = "ПКП Печенег",
    ent = "tfa_anomaly_pkp",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_pkp_w.mdl",
    price = 3525,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "Vepr-12 Молот",
    ent = "tfa_anomaly_vepr",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_vepr_w.mdl",
    price = 3525,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "ВВС Прибой",
    ent = "tfa_anomaly_vintorez_nimble",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_vintorez_nimble_w.mdl",
    price = 3525,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "AKC-74У Коряги",
    ent = "tfa_anomaly_ak74u_snag",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_ak74u_snag_w.mdl",
    price = 3525,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})

rp.AddShipment({
    name = "M24",
    ent = "tfa_anomaly_m24",
    model = "models/flaymi/anomaly/weapons/w_models/wpn_m24_w.mdl",
    price = 3525,
    allowed = {false},
    count = 1,
    maxStack = 5,
    stackable = true,
})