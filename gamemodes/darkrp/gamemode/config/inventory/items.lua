-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\items.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-- Компоненты
rp.AddItem({
	name = "Металлолом",
	ent = "rpitem_metal",
	model = "models/props_wasteland/gear02.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 15,
       vendor = {
               ["Гаваец"] = {sellPrice = 35},
               ["Незнакомец"] = {sellPrice = 50},
               ["Мадама"] = {sellPrice = 70}
       },
})

rp.AddItem({
    name = "Ткань",
    ent = "rpitem_fabric",
    model = "models/flaymi/anomaly/dynamics/equipments/quest/materials_wire.mdl",
    noDrop = true,
    stackable = true,
    category = "shipments",
    maxStack = 15,
       vendor = {
               ["Гаваец"] = {sellPrice = 35},
               ["Незнакомец"] = {sellPrice = 55},
               ["Мадама"] = {sellPrice = 82}
       },
})

rp.AddItem({
    name = "Полимер",
    ent = "rpitem_battery",
    model = "models/props_junk/garbage_plasticbottle002a.mdl",
    noDrop = true,
    stackable = true,
    category = "shipments",
    maxStack = 20,
       vendor = {
               ["Гаваец"] = {sellPrice = 50},
               ["Незнакомец"] = {sellPrice = 60},
               ["Мадама"] = {sellPrice = 100}
       },
})

rp.AddItem({
    name = "Электроника",
    ent = "rpitem_elecc",
    model = "models/flaymi/anomaly/dynamics/equipments/quest/materials_textolite.mdl",
    noDrop = true,
    stackable = true,
    category = "shipments",
    maxStack = 20,
       vendor = {
               ["Гаваец"] = {sellPrice = 150},
               ["Незнакомец"] = {sellPrice = 160},
               ["Мадама"] = {sellPrice = 220}
       },
})

/*
rp.AddItem({
	name = "Сталь",
	ent = "rpitem_steel",
	model = "models/mechanics/solid_steel/plank_4.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 15,
       vendor = {
               ["Гаваец"] = {sellPrice = 95},
               ["Незнакомец"] = {sellPrice = 100},
               ["Мадама"] = {sellPrice = 135}
          },
})
*/

/*
rp.AddItem({
	name = "Фрагмент Секретных Чертежей",
	ent = "rpitem_secret_list",
	model = "models/stalker/item/handhelds/files1.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 60},
               ["Незнакомец"] = {sellPrice = 90},
               ["Мадама"] = {sellPrice = 150}
       },
})
*/
/*
-- Инструменты

rp.AddItem({
	name = "Гаечный ключ",
	ent = "rpitem_wrench",
	model = "models/flaymi/anomaly/dynamics/workshop_room/keyga.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
})

rp.AddItem({
	name = "Инструменты для грубой работы",
	ent = "rpitem_blowtorch",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/box_toolkit_1.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 110},
               ["Незнакомец"] = {sellPrice = 135},
               ["Мадама"] = {sellPrice = 175}
       },
})

rp.AddItem({
	name = "Инструменты для тонкой работы",
	ent = "rpitem_toolkit",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/box_toolkit_2.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 115},
               ["Незнакомец"] = {sellPrice = 145},
               ["Мадама"] = {sellPrice = 195}
       },
})

rp.AddItem({
	name = "Секретные Оружейные Чертежи",
	ent = "rpitem_secret_book",
	model = "models/flaymi/anomaly/dynamics/equipments/trade/book3.mdl",
	--noDrop = true,
    category = "shipments",
	maxStack = 1,
       vendor = {
               ["Гаваец"] = {sellPrice = 145},
               ["Незнакомец"] = {sellPrice = 185},
               ["Мадама"] = {sellPrice = 275},
       },
})
*/

/*
-- Для принтеров
rp.AddItem({
	name = "Конденсаторы",
	ent = "rpitem_core",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/box_condensers.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 110},
               ["Незнакомец"] = {sellPrice = 175},
               ["Мадама"] = {sellPrice = 225}
       },
})

rp.AddItem({
	name = "Системные Платы",
	ent = "rpitem_procc",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/materials_textolite.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 110},
               ["Незнакомец"] = {sellPrice = 175},
               ["Мадама"] = {sellPrice = 250},
       },
})
*/
rp.AddItem({
	name = "Аккумулятор",
	ent = "rpitem_accum",
	model = "models/items/car_battery01.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 110},
               ["Незнакомец"] = {sellPrice = 175},
               ["Мадама"] = {sellPrice = 275},
       },
})

-- Для оружия
rp.AddItem({
	name = "Оружейные Механизмы",
	ent = "rpitem_guns_meh",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/box_toolkit_3.mdl",
	--noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
               ["Гаваец"] = {sellPrice = 110},
               ["Незнакомец"] = {sellPrice = 175},
               ["Мадама"] = {sellPrice = 275},
       },
})
/*
rp.AddItem({
	name = "Поврежденная Форма Военного",
	ent = "rpitem_army_desclothes",
	model = "models/flaymi/anomaly/dynamics/outfit/bandit_commander_outfit.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 5,
       vendor = {
               ["Гаваец"] = {sellPrice = 60},
               ["Незнакомец"] = {sellPrice = 90}
       },
})*/
/*
-- Сумки
rp.AddItem({
	name = "Рюкзак",
	ent = "rpitem_bag1",
	model = "models/flaymi/anomaly/dynamics/equipments/sumka1.mdl",
	noDrop = true,
	base = "bags",
    category = "shipments",
	invWidth = 2,
	invHeight = 2,
       vendor = {
               ["Гаваец"] = {sellPrice = 100},
               ["Незнакомец"] = {sellPrice = 200}
       },
})
*/
rp.AddItem({
	name = "Большой Рюкзак",
	ent = "rpitem_bag2",
	model = "models/flaymi/anomaly/dynamics/equipments/sumka5.mdl",
	noDrop = true,
	base = "bags",
	invWidth = 4,
	invHeight = 2,
})

rp.AddItem({
	name = "Металлический Кейс",
	ent = "rpitem_bag3",
	model = "models/instrument.mdl",
	noDrop = true,
	base = "bags",
	invWidth = 4,
	invHeight = 4,
})

/*rp.AddItem({
	name = "Обычный Майнер",
	ent = "simpleprint2",
	model = "models/urf/bitminer_1.mdl",
})

rp.AddItem({
	name = "Улучшенный Майнер",
	ent = "simpleprint3",
	model = "models/urf/bitminer_3.mdl",
})

rp.AddItem({
	name = "Секретный Майнер",
	ent = "simpleprint4",
	model = "models/urf/bitminer_urf.mdl",
})*/

rp.AddItem({
    name = "Аирдроп",
    ent = "rpitem_airdrop",
    model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl",
    noTake = true,
    base = "bags",
    invWidth = 6,
    invHeight = 6,
    onSpawn = function(ent, pl, item)
        timer.Create("AirDropDelete" .. ent:EntIndex(), rp.cfg.AirDropDelete, 1, function()
            if not IsValid(ent) then return end
            ent:Remove()
        end)
    end,
    functions = {
        Open = {
            name = "Осмотреть",
            icon = "icon16/cup.png",
            sound = "items/battery_pickup.wav",
            onRun = function(item)
                local index = item:getData("id")
                netstream.Start(item.player, "rpOpenBag", index)

                --net.Start("rp.OpenInventory")
                --net.Send(item.player)
                return false
            end,
            onCanRun = function(item) return IsValid(item.entity) and item:getData("id") and item.entity:GetNWBool("IsCanOpen") end
        }
    }
})

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Квестовые вещи
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
/*
--—————————————————————
--Части Мутантов
--—————————————————————
rp.AddItem({
	name = "Копыто Кабана",
	ent = "rpitem_mutant_kaban",
	model = "models/flaymi/anomaly/dynamics/equipments/item_boar_leg.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 5,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 75},
       },
})

rp.AddItem({
	name = "Хвост Собаки",
	ent = "rpitem_mutant_sobaka",
	model = "models/flaymi/anomaly/dynamics/equipments/item_dog_tail.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 5,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 100},
       },
})

rp.AddItem({
	name = "Голова Тушканчика",
	ent = "rpitem_mutant_tushkan",
	model = "models/flaymi/anomaly/dynamics/equipments/item_tushkano_head.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 175},
       },
})

rp.AddItem({
	name = "Рука зомби",
	ent = "rpitem_mutant_zombi",
	model = "models/flaymi/anomaly/dynamics/equipments/item_fracture_hand.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 5,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 235},
       },
})

rp.AddItem({
    name = "Коготь Химеры",
    ent = "rpitem_mutant_himera",
    model = "models/flaymi/anomaly/dynamics/equipments/item_chimera_cogot.mdl",
    noDrop = true,
    stackable = true,
    category = "shipments",
    maxStack = 5,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 1000},
       },
})


rp.AddItem({
	name = "Нога Снорка",
	ent = "rpitem_mutant_snork",
	model = "models/flaymi/anomaly/dynamics/equipments/item_snork_leg.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 3,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 300},
       },
})

rp.AddItem({
	name = "Щупальца Кровососа",
	ent = "rpitem_mutant_krovosos",
	model = "models/flaymi/anomaly/dynamics/equipments/item_krovosos_jaw.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 3,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 335},
       },
})


rp.AddItem({
	name = "Глаз Псевдогигант",
	ent = "rpitem_mutant_psevdo",
	model = "models/flaymi/anomaly/dynamics/equipments/poltergeist_glas.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 1,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 2500},
       },
})

rp.AddItem({
    name = "Глаз Плоти",
    ent = "rpitem_mutant_plot",
    model = "models/flaymi/anomaly/dynamics/equipments/item_flesh_eye.mdl",
    noDrop = true,
    stackable = true,
    category = "shipments",
    maxStack = 10,
    max = 40,
       vendor = {
        ["Научный сотрудник"] = {sellPrice = 250},
       },
})

rp.AddItem({
	name = "Ящик c частями мутантов",
	ent = "rpitem_mutantchasti",
	model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 10,
       vendor = {
        ["Неизвестный"] = {sellPrice = 7500},
       },
})
*/
--—————————————————————
--Документы
--—————————————————————
rp.AddItem({
	name = "Фальшивые документы",
	ent = "rpitem_dockfalsh",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_1.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
        ["Мадама"] = {sellPrice = 200},
        ["Ученый ЧН"] = {sellPrice = 180},
        ["Научный сотрудник"] = {sellPrice = 175},
       },
})

rp.AddItem({
	name = "Документы из X18 часть 4",
	ent = "rpitem_dockx18",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_3.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
        ["Неизвестный"] = {buyPrice = 890},
        ["Научный сотрудник"] = {sellPrice = 850},
        ["Сталкер Колобок"] = {sellPrice = 840},
       },
})

rp.AddItem({
	name = "Документы из лаборатории X8",
	ent = "rpitem_dockx8",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_4.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
        ["Неизвестный"] = {buyPrice = 320},
        ["Ученый ЧН"] = {sellPrice = 280},
        ["Научный сотрудник"] = {sellPrice = 300},
       },
})

rp.AddItem({
	name = "Документы из Припяти",
	ent = "rpitem_dockpripat",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_5.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
        ["Неизвестный"] = {buyPrice = 1250},
        ["Ученый ЧН"] = {sellPrice = 1200},
        ["Сталкер Колобок"] = {sellPrice = 1150},
       },
})

rp.AddItem({
	name = "Документы из лаборатории X16",
	ent = "rpitem_dockx16",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_7.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
        ["Неизвестный"] = {buyPrice = 4100},
        ["Ученый ЧН"] = {sellPrice = 3560},
        ["Научный сотрудник"] = {sellPrice = 3600},
        ["Сталкер Колобок"] = {sellPrice = 3900},
       },
})

rp.AddItem({
	name = "Документация по «изделию №62»",
	ent = "rpitem_dockgaus",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_8.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
    max = 1,
	maxStack = 1,
       vendor = {
               ["Научный сотрудник"] = {sellPrice = 900},
               ["Мадама"] = {sellPrice = 800},
       },
})

rp.AddItem({
	name = "Сборник документов",
	ent = "rpitem_sbornikdocks",
	model = "models/flaymi/anomaly/dynamics/equipments/documents_6.mdl",
	noDrop = true,
	stackable = true,
    category = "shipments",
	maxStack = 1,
    max = 1,
       vendor = {
        ["Гаваец"] = {sellPrice = 7050},
       },
})

rp.AddItem({
  name = "Праздничная Тыква",
  ent = "rpitem_pumpkin",
  icon_override = "icons/pumpkin",
  icon = "icons/pumpkin",
  noDrop = true,
  stackable = true,
  maxStack = 25,
  width = 1,
  height = 1,
})

-- Ивенты
rp.AddItem({
    name = "Часть Подарка",
    ent = "ny_item",
    model = "models/gift/christmas_gift.mdl",
    noDrop = true,
    stackable = true,
    notCanGive = true,
    category = "entities",
    maxStack = 30,
    width = 1,
    height = 1,
    vendor = {
    },
})

rp.AddPresent( {
    name = "Новогодний Кейс",
    ent = "present_6",
    model = "models/voidcases/plastic_crate_ny.mdl",
    category = "entities",
    maxStack = 1,
    width = 1,
    height = 1,
    awards = {
        {
            award_type = rp.awards.Types.AWARD_CASE,
            "nyf_case"
        },
    }
})

 -- Курьерство
rp.AddItem({
    name = "Конфискованная контрабанда",
    ent = "rpitem_package_one",
    model = "models/flaymi/anomaly/dynamics/box/box_1c.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Заведующий складом"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Перевозчик продовольствия"] = {sellPrice = 400},
        ["Управляющий инвентарем"] = {sellPrice = 300},
    },
})

rp.AddItem({
    name = "Документы об Иследованиях",
    ent = "rpitem_package_three",
    model = "models/flaymi/anomaly/dynamics/equipments/documents_9.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Управляющий инвентарем"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Кислый"] = {sellPrice = 400},
        ["Заведующий складом"] = {sellPrice = 300},
    },
})

rp.AddItem({
    name = "Гуманитарная помощь",
    ent = "models/props/cs_office/file_box.mdl",
    model = "models/flaymi/anomaly/dynamics/devices/dev_merger.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Перевозчик продовольствия"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Управляющий инвентарем"] = {sellPrice = 400},
        ["Заведующий складом"] = {sellPrice = 400},
    },
})

-- для системы опыта

rp.AddItem({
    name = "Поставка детекторов",
    ent = "expsistemitem_one",
    model = "models/flaymi/anomaly/dynamics/box/box_paper.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Управляющий инвентарем"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Гаваец"] = {sellPrice = 400},
        ["Кислый"] = {sellPrice = 400},
    },
})

rp.AddItem({
    name = "Поставка логистической документации",
    ent = "expsistemitem_two",
    model = "models/flaymi/anomaly/dynamics/equipments/documents_2.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Управляющий инвентарем"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Перевозчик продовольствия"] = {sellPrice = 400},
    },
})

rp.AddItem({
    name = "Поставка лекарственных препаратов",
    ent = "expsistemitem_three",
    model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl",
    noDrop = true,
    maxStack = 1,
    width = 1,
    height = 1,
    max = 2,
    vendor = {
        ["Управляющий инвентарем"] = {
        stockAmount = 1,
        stockCooldown = 60,
        buyPrice = 1},
        ["Дежурный"] = {sellPrice = 400},
    },
})

-- закладки
--[[
rp.AddItem({
  name = "Секретная документация",
  ent = "stashing",
  model = "models/stalker/item/handhelds/files1.mdl",
  desc = "Секретная документация, которую нужно где то спрятать.",
  noDrop = true,
  stackable = true,
  maxStack = 1,
  vendor = {
       ["Профессор Сахаров"] = {buyPrice = 100},
       ["Ученый ЧН"] = {buyPrice = 100},
   },
  --allowed = {TEAM_ECOLOG_SHIFR, TEAM_NEBOR},
})
]]--

-- Легендарный торговец

rp.AddItem({
    name = "Жетон Торговца",
    ent = "legend_jeton",
    model = "models/flaymi/anomaly/dynamics/equipments/dev_money.mdl",
    noDrop = true,
    stackable = true,
    notCanGive = true,
    category = "entities",
    maxStack = 30,
    width = 1,
    height = 1,
    vendor = {
    },
})

rp.AddPresent( {
    name = "Хабар Якоря",
    ent = "legendtorg_case",
    model = "models/flaymi/anomaly/dynamics/equipments/green_box.mdl",
    category = "entities",
    maxStack = 1,
    width = 1,
    height = 1,
    awards = {
        {
            award_type = rp.awards.Types.AWARD_CASE,
            "lxy_case"
        },
    }
})