-- Разное
rp.AddDisguise({
  name = "Гражданская одежда",
  ent = "ent_disguise_citizen",
  faction = FACTION_CITIZEN,
  model = "models/props_c17/SuitCase_Passenger_Physics.mdl",
  allowed = {TEAM_GADMIN},
  price = 150,
  count = 1,
  stackable = true,
  maxStack = 1,
  vendor = {
    ["Ден - Снабженец"] = {
      sellPrice = 75,
    },
    ["Дин - Снабженец"] = {
      sellPrice = 75,
    },
    ["Скупой Яков"] = {
      sellPrice = 105,
    },
  }
})

rp.AddDisguise({
  name = "Комплект MPF",
  ent = "ent_disguise_mpf",
  faction = FACTION_MPF,
  model = "models/props_c17/SuitCase001a.mdl",
  allowed = {TEAM_BARNEY, TEAM_GADMIN},
  price = 300,
  count = 1,
  stackable = true,
  maxStack = 1,
  vendor = {
    ["Ден - Снабженец"] = {
      sellPrice = 150,
    },
    ["Дин - Снабженец"] = {
      sellPrice = 150,
    },
    ["Скупой Яков"] = { 
      sellPrice = 225,
    },
    ["Дежурный Альянса"] = {
      sellPrice = 225,
    },
  }
}) 

rp.AddDisguise({
  name = "Комплект Повстанца",
  ent = "ent_disguise_rebel",
  faction = FACTION_REBEL,
  model = "models/props_c17/SuitCase_Passenger_Physics.mdl",
  allowed = {TEAM_GADMIN},
  price = 300,
  count = 1,
  stackable = true,
  maxStack = 1,
  vendor = {
    ["Ден - Снабженец"] = {
      sellPrice = 150,
    },
    ["Дин - Снабженец"] = {
      sellPrice = 150,
    },
    ["Скупой Яков"] = {
      sellPrice = 225,
    },
    ["Дежурный Альянса"] = {
      sellPrice = 225,
    },
  }
})

rp.AddEntity({
  name = "Аптечка",
  ent = "ent_medpack",
  model = "models/items/healthkit.mdl",
  allowed = {TEAM_CWU_MEDIC, TEAM_VORTI, TEAM_CWU_LEADER, TEAM_GADMIN, TEAM_PILOTGRID, TEAM_MAR, TEAM_HELIX03, TEAM_OFCHELIX, TEAM_REBFIVE, TEAM_KLEINER, TEAM_ELI},
  price = 100,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Ден - Снабженец"] = {
      sellPrice = 75,
    },
    ["Дин - Снабженец"] = {
      sellPrice = 75,
    },
    ["Щедрый Абрам"] = {
      buyPrice = 125,
    },
     ["Ден - Снабженец"] = {
      buyPrice = 125,
    },
  }
}) 

rp.AddEntity({
  name = "Броня",
  ent = "armor_piece_full",
  model = "models/props_junk/cardboard_box004a.mdl",
  allowed = {TEAM_CWU_MEDIC, TEAM_VORTI, TEAM_CWU_LEADER, TEAM_GADMIN, TEAM_PILOTGRID, TEAM_MAR, TEAM_REBFIVE, TEAM_KLEINER, TEAM_ELI, TEAM_STALKER},
  price = 50,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 40,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 40,
    },
    ["Дин - Снабженец"] = {
      sellPrice = 40,
    },
    ["Щедрый Абрам"] = {
    buyPrice = 55,
    },
    ["Ден - Снабженец"] = {
    buyPrice = 55,
  }
} 
})

-- Оружие
rp.AddWeapon({
  name = "Отмычка",
  ent = "lockpick",
  model = "models/weapons/w_crowbar.mdl",
  allowed = {TEAM_GADMIN},
  price = 180,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 95,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 95,
    },
    ["Скупой Яков"] = {
      sellPrice = 95,
    },
  }
}) 

rp.AddWeapon({
  name = "Взломщик",
  ent = "keypad_cracker",
  model = "models/weapons/w_c4.mdl",
  allowed = {TEAM_GADMIN},
  price = 250,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 150,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 150,
    },
    ["Скупой Яков"] = {
      sellPrice = 150,
    },
  }
}) 


rp.AddWeapon({
  name = "Pistol",
  ent = "swb_pistol",
  model = "models/weapons/w_pistol.mdl",
  allowed = {TEAM_GADMIN},
  price = 250,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 170,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 170,
    },
    ["Скупой Яков"] = {
      sellPrice = 170,
    },
  }
}) 

rp.AddWeapon({
  name = "357 Magnum",
  ent = "swb_357",
  model = "models/weapons/w_357.mdl",
  allowed = {TEAM_GADMIN},
  price = 500,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 280,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 280,
    },
    ["Скупой Яков"] = {
      sellPrice = 280,
    },
  }
}) 

rp.AddWeapon({
  name = "SMG",
  ent = "swb_smg",
  model = "models/weapons/w_smg1.mdl",
  allowed = {TEAM_GADMIN},
  price = 500,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 280,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 280,
    },
    ["Скупой Яков"] = {
      sellPrice = 280,
    },
  }
}) 

rp.AddWeapon({
  name = "O.I.C.V v.2",
  ent = "swb_oicw_v2",
  model = "models/weapons/tfa_misc/w_oicw.mdl",
  allowed = {TEAM_GADMIN},
  price = 700,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 500,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 500,
    },
    ["Скупой Яков"] = {
      sellPrice = 500,
    },
  }
}) 

rp.AddWeapon({
  name = "AR2",
  ent = "swb_ar2",
  model = "models/weapons/w_irifle.mdl",
  allowed = {TEAM_GADMIN},
  price = 450,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 400,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 400,
    },
    ["Скупой Яков"] = {
      sellPrice = 400,
    },
  }
}) 

rp.AddWeapon({
  name = "SPAS-12",
  ent = "swb_shotgun",
  model = "models/weapons/w_shotgun.mdl",
  allowed = {TEAM_GADMIN},
  price = 800,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 400,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 400,
    },
    ["Скупой Яков"] = {
      sellPrice = 400,
    },
  }
}) 

rp.AddWeapon({
  name = "AR3",
  ent = "swb_ar3",
  model = "models/weapons/w_crifle.mdl",
  allowed = {TEAM_GADMIN},
  price = 800,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 625,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 625,
    },
    ["Скупой Яков"] = {
      sellPrice = 625,
    },
  }
}) 

rp.AddWeapon({
  name = "Stunstick",
  ent = "weapon_stunstick",
  model = "models/weapons/w_stunbaton.mdl",
  allowed = {TEAM_GADMIN},
  price = 200,
  count = 1,
  stackable = true,
  maxStack = 5,
  
}) 

rp.AddWeapon({
  name = "Арбалет",
  ent = "swb_bow",
  model = "models/weapons/w_crossbow.mdl",
  allowed = {TEAM_GADMIN},
  price = 1500,
  count = 1,
  stackable = true,
  maxStack = 5,
  vendor = {
  ["Дежурный Альянса"] = {
      sellPrice = 800,
    },
  ["Ден - Снабженец"] = {
      sellPrice = 800,
    },
  }
}) 


rp.AddWeapon({
  name = "Нож",
  ent = "swb_knife",
  model = "models/weapons/w_knife_t.mdl",
  allowed = {TEAM_GADMIN},
  price = 100,
  count = 1,
  stackable = true,
  maxStack = 5,
  
}) 

rp.AddWeapon({
  name = "Suppressor LMG",
  ent = "tfa_suppressor",
  model = "models/weapons/w_suppressor.mdl",
  allowed = {TEAM_GADMIN},
  price = 5000,
  count = 1,
  stackable = true,
  maxStack = 5,
    vendor = {
    ["Дежурный Альянса"] = {
      sellPrice = 1500,
    },
    ["Ден - Снабженец"] = {
      sellPrice = 1500,
    },
  }
}) 

rp.AddWeapon({
  name = "Heavy Shotgun",
  ent = "tfa_heavyshotgun",
  model = "models/weapons/w_heavyshotgun.mdl",
  allowed = {TEAM_GADMIN},
  price = 2000,
  count = 1,
  stackable = true,
  maxStack = 5,
  
}) 

-- Еда
rp.AddWeapon({
  name = "Хлеб",
  ent = "urf_foodsystem_food_bread",
  model = "models/bioshockinfinite/dread_loaf.mdl",
  allowed = {TEAM_COOK, TEAM_GADMIN, TEAM_KLEINER, TEAM_CWU_LEADER, TEAM_VORTI, TEAM_VORTI_HOBO},
  price = 15,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Алекс"] = {
    sellPrice = 10,
    },
    ["Весельчак Боб"] = {
    buyPrice = 15,
    sellPrice = 10,
    },
  }
}) 

rp.AddWeapon({
  name = "Бобы",
  ent = "urf_foodsystem_food_beans",
  model = "models/bioshockinfinite/rag_of_peanuts.mdl",
  allowed = {TEAM_COOK, TEAM_GADMIN, TEAM_KLEINER, TEAM_CWU_LEADER, TEAM_VORTI, TEAM_VORTI_HOBO},
  price = 25,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Алекс"] = {
      sellPrice = 15,
    },
    ["Весельчак Боб"] = {
      buyPrice = 25,
      sellPrice = 15,
    },
  }
}) 

rp.AddWeapon({
  name = "Пиво",
  ent = "urf_foodsystem_drink_beercan",
  model = "models/props_nunk/popcan01a.mdl",
  allowed = {TEAM_COOK, TEAM_GADMIN, TEAM_KLEINER, TEAM_VORTI, TEAM_CWU_LEADER, TEAM_VORTI_HOBO},
  price = 80,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Весельчак Боб"] = {
    buyPrice = 80,
    sellPrice = 50,
    },
    ["Щедрый Абрам"] = {
      sellPrice = 50,
    },
  }
}) 

rp.AddWeapon({
  name = "Джин",
  ent = "urf_foodsystem_drink_gin",
  model = "models/bioshockinfinite/jin_bottle.mdl",
  allowed = {TEAM_COOK, TEAM_GADMIN, TEAM_KLEINER, TEAM_VORTI, TEAM_CWU_LEADER},
  price = 100,
  count = 1,
  stackable = true,
  maxStack = 20,
  vendor = {
    ["Весельчак Боб"] = {
      buyPrice = 100,
      sellPrice = 75,
    ["Щедрый Абрам"] = {
      sellPrice = 75,
    },
  }
}
}) 

rp.AddWeapon({
  name = "Рацион Стандартный",
  ent = "urf_foodsystem_ration_normal",
  model = "models/weapons/w_packatc.mdl",
  allowed = {TEAM_GADMIN, TEAM_COOK, TEAM_CWU_LEADER},
  price = 50,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Алекс"] = {
      sellPrice = 35,
    },
  }
}) 

rp.AddWeapon({
  name = "Рацион ГСР",
  ent = "urf_foodsystem_ration_cwu",
  model = "models/weapons/w_packatp.mdl",
  allowed = {TEAM_GADMIN, TEAM_COOK, TEAM_CWU_LEADER},
  price = 75,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Алекс"] = {
      sellPrice = 60,
    },
  }
}) 

rp.AddWeapon({
  name = "Рацион Увеличенный ",
  ent = "urf_foodsystem_ration_expanded",
  model = "models/weapons/w_packatl.mdl",
  allowed = {TEAM_GADMIN, TEAM_COOK, TEAM_CWU_LEADER},
  price = 100,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Алекс"] = {
     sellPrice = 75,
  },
  ["Щедрый Абрам"] = {
     sellPrice = 75,
  },
  }
}) 

rp.AddWeapon({
  name = "Рацион ГО",
  ent = "urf_foodsystem_ration_mpf",
  model = "models/weapons/w_packatm.mdl",
  allowed = {TEAM_GADMIN, TEAM_COOK, TEAM_CWU_LEADER},
  price = 150,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Щедрый Абрам"] = {
     sellPrice = 100,
    },
    ["Алекс"] = {
     sellPrice = 100,
    },
  }
}) 

rp.AddWeapon({
  name = "Фомка",
  ent = "weapon_prop_destroy",
  model = "models/weapons/w_crowbar.mdl",
  allowed = {TEAM_GADMIN},
  price = 180,
  count = 1,
  stackable = true,
  maxStack = 10,
  vendor = {
    ["Джон - Приемщик"] = {
      buyPrice = 150,
    },
  }
}) 


-- Наркотики

rp.AddFood({
  name = "Трава",
  ent = "durgz_weed",
  model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
  price = 60,
  allowed = {TEAM_GADMIN},
  count = 1,
  stackable = true,
  maxStack = 50,
  vendor = {
    ["Скупой Яков"] = {
      sellPrice = 50,
    },
    ["Щедрый Абрам"] = {
      sellPrice = 50,
    },
    ["Весельчак Боб"] = {
      sellPrice = 50,
    },
  }
})




