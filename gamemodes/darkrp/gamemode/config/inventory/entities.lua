-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\entities.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- принтеры
local money_printers = {}

local function reachedMoneyPrinterLimit(ply)
	local i = 0
	for k=1, #money_printers do
		i = i + ply:GetCount(money_printers[k]) or 0
		if i >= rp.cfg.MaxPrinters then
			return false, 'MaxMoneyPrinterReached'
		end
	end
	return true
end

local function addPrinter(t)
	money_printers[#money_printers+1] = t.ent
	if SERVER then
		t.customCheck = reachedMoneyPrinterLimit
	end
	t.max = t.max or 1
	t.price = math.floor(t.price * 0.7)
	t.cmd = '/'..t.ent
	t.customCheckFailMsg = rp.Term('MaxMoneyPrinterReached')
	rp.AddEntity(t)
end

rp.AddEntity({
	name = "Ремонтный Набор",
	ent = "money_printer_fix",
	model = "models/props_c17/tools_wrench01a.mdl",
	max = 3,
	cmd = "/buyprintfix"
})

rp.AddEntity({
    name = "Кустарный Принтер",
	ent = "simpleprint1",
	model = "models/urf/bitminer_2.mdl",
    rarity = "Кустарная Сборка",
	price = 100,
	max = 2,
	allowed = rp.GetFactionTeams({FACTION_CITIZEN, FACTION_REFUGEES, FACTION_REBEL}),
	unlockTime = 0,5 * 3600,
    CanTake = function(item, ply)
        if item.entity:GetIsFiring() then
            rp.Notify(ply, NOTIFY_ERROR, translates.Get("Вы не можете взять горящий принтер!"))
            return false
        end
    end,
    DisableNetVarSave = true,
    bubble = {
        IgnoreDistanceLimit = function(ent) return true end,
        ignoreZ             = function(ent) return true end,
        ShouldMinusY        = function(ent) return true end,
        ico_col             = color_white,
        ico                 = function(ent)
            return ent.IconMaterial(ent)
        end,
        customCheck = function(ent)
            if not IsValid(ent) or not ent:GetIsFiring() or ent:Getowning_ent() ~= LocalPlayer() then return false end
        end,
    },
    functions = {
        ["0-extinguish"] = {
            name             = translates.Get("Потушить"),
            tip              = "takeTip",
            icon             = "icon16/heart.png",
            InteractMaterial = "ping_system/extinguisher.png",
            onRun = function(item)
                item.entity:StopFire()
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and item.entity:GetIsFiring()
            end,
        },
        useEnt = {
            name             = translates.Get("Забрать Деньги"),
            tip              = "takeTip",
            icon             = "icon16/plugin.png",
            InteractMaterial = "ping_system/use.png",
            onRun = function(item)
                item.entity:Use(item.player, item.player, USE_ON, 1)
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and not item.noUseFunc and not item.entity:GetIsFiring()
            end,
        },
    },
})

rp.AddEntity({
    name    = "Обычный Майнер",
    ent     = "simpleprint2",
    model   = "models/urf/bitminer_1.mdl",
    rarity = "Сборка Повстанцев",
    allowed = {false},
    price   = 99999,
    max     = 3,
    CanTake = function(item, ply)
        if item.entity:GetIsFiring() then
            rp.Notify(ply, NOTIFY_ERROR, translates.Get("Вы не можете взять горящий принтер!"))
            return false
        end
    end,
    DisableNetVarSave = true,
    bubble = {
        IgnoreDistanceLimit = function(ent) return true end,
        ignoreZ             = function(ent) return true end,
        ShouldMinusY        = function(ent) return true end,
        ico_col             = color_white,
        ico                 = function(ent)
            return ent.IconMaterial(ent)
        end,
        customCheck = function(ent)
            if not IsValid(ent) or not ent:GetIsFiring() or ent:Getowning_ent() ~= LocalPlayer() then return false end
        end,
    },
    functions = {
        ["0-extinguish"] = {
            name             = translates.Get("Потушить"),
            tip              = "takeTip",
            icon             = "icon16/heart.png",
            InteractMaterial = "ping_system/extinguisher.png",
            onRun = function(item)
                item.entity:StopFire()
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and item.entity:GetIsFiring()
            end,
        },
        useEnt = {
            name             = translates.Get("Забрать Деньги"),
            tip              = "takeTip",
            icon             = "icon16/plugin.png",
            InteractMaterial = "ping_system/use.png",
            onRun = function(item)
                item.entity:Use(item.player, item.player, USE_ON, 1)
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and not item.noUseFunc and not item.entity:GetIsFiring()
            end,
        },
    },
})

rp.AddEntity({
    name    = "Улучшенный Майнер",
    ent     = "simpleprint3",
    model   = "models/urf/bitminer_3.mdl",
    rarity = "Сборка Альянса",
    price   = 99999,
    max     = 2,
    allowed = {false},
    CanTake = function(item, ply)
        if item.entity:GetIsFiring() then
            rp.Notify(ply, NOTIFY_ERROR, translates.Get("Вы не можете взять горящий принтер!"))
            return false
        end
    end,
    DisableNetVarSave = true,
    bubble = {
        IgnoreDistanceLimit = function(ent) return true end,
        ignoreZ             = function(ent) return true end,
        ShouldMinusY        = function(ent) return true end,
        ico_col             = color_white,
        ico                 = function(ent)
            return ent.IconMaterial(ent)
        end,
        customCheck = function(ent)
            if not IsValid(ent) or not ent:GetIsFiring() or ent:Getowning_ent() ~= LocalPlayer() then return false end
        end,
    },
    functions = {
        ["0-extinguish"] = {
            name             = translates.Get("Потушить"),
            tip              = "takeTip",
            icon             = "icon16/heart.png",
            InteractMaterial = "ping_system/extinguisher.png",
            onRun = function(item)
                item.entity:StopFire()
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and item.entity:GetIsFiring()
            end,
        },
        useEnt = {
            name             = translates.Get("Забрать Деньги"),
            tip              = "takeTip",
            icon             = "icon16/plugin.png",
            InteractMaterial = "ping_system/use.png",
            onRun = function(item)
                item.entity:Use(item.player, item.player, USE_ON, 1)
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and not item.noUseFunc and not item.entity:GetIsFiring()
            end,
        },
    },
})

rp.AddEntity({
    name    = "Секретный Майнер",
    ent     = "simpleprint4",
    model   = "models/urf/bitminer_urf.mdl",
    price   = 99999,
    max     = 1,
    allowed = {false},
    CanTake = function(item, ply)
        if item.entity:GetIsFiring() then
            rp.Notify(ply, NOTIFY_ERROR, translates.Get("Вы не можете взять горящий принтер!"))
            return false
        end
    end,
    DisableNetVarSave = true,
    bubble = {
        IgnoreDistanceLimit = function(ent) return true end,
        ignoreZ             = function(ent) return true end,
        ShouldMinusY        = function(ent) return true end,
        ico_col             = color_white,
        ico                 = function(ent)
            return ent.IconMaterial(ent)
        end,
        customCheck = function(ent)
            if not IsValid(ent) or not ent:GetIsFiring() or ent:Getowning_ent() ~= LocalPlayer() then return false end
        end,
    },
    functions = {
        ["0-extinguish"] = {
            name             = translates.Get("Потушить"),
            tip              = "takeTip",
            icon             = "icon16/heart.png",
            InteractMaterial = "ping_system/extinguisher.png",
            onRun = function(item)
                item.entity:StopFire()
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and item.entity:GetIsFiring()
            end,
        },
        useEnt = {
            name             = translates.Get("Забрать Деньги"),
            tip              = "takeTip",
            icon             = "icon16/plugin.png",
            InteractMaterial = "ping_system/use.png",
            onRun = function(item)
                item.entity:Use(item.player, item.player, USE_ON, 1)
                return false
            end,
            onCanRun = function(item)
                return IsValid(item.entity) and item.entity:GetClass() ~= "rp_item" and not item.noUseFunc and not item.entity:GetIsFiring()
            end,
        },
    },
})

-----------------------
/*rp.AddEntity({
    ent = 'simpleprinter_ammo',
    max = 1,
    allowed = {false},
    name = 'Ящик с боеприпасами',
    model = 'models/z-o-m-b-i-e/st/cover/st_cover_wood_box_01.mdl',
})*/

rp.AddEntity({
	name = "Картина",
	ent = "ent_picture",
	model = "models/hunter/plates/plate1x1.mdl",
	price = 100,
	max = 2,
	cmd = "/buypic",
	noTake = true,
	allowed = {false},
})

rp.AddEntity({
	name = "Флаг",
	ent = "flag",
	model = "models/props_c17/signpole001.mdl",
	price = 700,
	max = 1,
	cmd = "/buyflag",
	noTake = true,
	allowed = {false},
})

-- DJ
rp.AddEntity({
	name = "Радио",
	ent = "media_radio",
	model = "models/props_lab/citizenradio.mdl",
	price = 200,
	max = 1,
	cmd = "/buyradiotime",
	noTake = true,
    allowed = {false},
	unlockTime = 60 * 3600
})

-- Notes
rp.AddEntity({
	name = "Записка",
	ent = "ent_note",
	model = "models/flaymi/anomaly/dynamics/equipments/quest/notes_letter_2.mdl",
	price = 50,
	max = 2,
	cmd = "/note",
	noTake = true,
	onSpawn = function(ent, pl)
		if (IsValid(pl.LastNote)) then
			pl.LastNote:Remove()
		end

		pl.LastNote = ent
		rp.Notify(pl, NOTIFY_GREEN, rp.Term("USENote"))
	end
})

hook.Call("rp.AddEntities", GAMEMODE)

-- Наркотики
/*
rp.AddDrug({
	name = "Трава",
	ent = "durgz_weed",
	model = "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl",
	price = 50,
	allowed = {TEAM_GADEX},
    maxStack = 15,
    stackable = true,
})

rp.AddEntity({
	name = "Спайс",
	ent = "drugs_spice",
	model = "models/stalker/item/medical/antibotic.mdl",
	price = 150,
	allowed = {TEAM_GADEX},
    maxStack = 15,
    stackable = true,
})

rp.AddEntity({
	name = "Кокаин",
	ent = "durgz_cocaine",
	model = "models/stalker/item/medical/rad_pills.mdl",
	price = 300,
	allowed = {TEAM_GADEX},
	maxStack = 15,
    stackable = true,
})
*/

------------------
--STALKER REWORK--
------------------

-- Маскировка

rp.AddEntity({
    name = "Одежда Бандита",
    ent = "ent_disguise_band",
    model = "models/flaymi/anomaly/dynamics/outfit/banditmerc_outfit.mdl",
    price = 500,
    max = 1,
    cmd = "/maskband",
    noTake = true,
    allowed = {TEAM_BRIGADIR, TEAM_SULTAN},
    base = 'disguise',
    faction = FACTION_REBEL,
    onSpawn = function(ent, pl)
        ent.Faction = FACTION_REBEL
    end
})

rp.AddEntity({
    name = "Комплект Формы Военного",
    ent = "ent_disguise_army",
    model = "models/flaymi/anomaly/dynamics/outfit/army_outfit.mdl",
    price = 500,
    max = 1,
    cmd = "/maskmil",
    noTake = true,
    allowed = {TEAM_SEC, TEAM_EPU},
    base = 'disguise',
    faction = FACTION_MILITARY,
    onSpawn = function(ent, pl)
        ent.Faction = FACTION_MILITARY
    end
})

rp.AddEntity({
    name = "Форма Свободовца",
    ent = "ent_disguise_free",
    model = "models/flaymi/anomaly/dynamics/outfit/freedom_rookie_outfit.mdl",
    price = 500,
    max = 1,
    cmd = "/masksvob",
    noTake = true,
    allowed = {TEAM_OPSVOB, TEAM_BSVOB},
    base = 'disguise',
    faction = FACTION_SVOBODA,
    onSpawn = function(ent, pl)
        ent.Faction = FACTION_SVOBODA
    end
})

rp.AddEntity({
    name = "Форма ДОЛГа",
    ent = "ent_disguise_duty",
    model = "models/flaymi/anomaly/dynamics/outfit/dolg_outfit.mdl",
    price = 500,
    max = 1,
    cmd = "/maskdolg",
    noTake = true,
    allowed = {TEAM_STLTDOLG, TEAM_CAPDOLG},
    base = 'disguise',
    faction = FACTION_DOLG,
    onSpawn = function(ent, pl)
        ent.Faction = FACTION_DOLG
    end
})

-- Расходники

rp.AddEntity({
  name = "Пси-Блокада",
  ent = "ent_psi_anabiotic",
  base = "usable",
  model = "models/flaymi/anomaly/dynamics/equipments/medical/drug_anabiotic.mdl",
  allowed = {TEAM_UCHENIY},
  price = 4500,
  count = 1,
  stackable = true,
  maxStack = 3,
})

rp.AddShipment({
    name = "Швейный набор",
    ent = "armor_kit",
    model = "models/flaymi/anomaly/dynamics/repair/toolkit_p.mdl",
    price = 10000,
    allowed = {TEAM_GAVAECKEYS},
    count = 3,
    maxStack = 3,
    stackable = true,
})

rp.AddEntity({
    name = "Раздатчик Брони",
    ent = "armor_lab",
    model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl",
    price = 350,
    max = 1,
    cmd = "/buyarmorlab",
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_VSU_VENDOR, TEAM_UCHENIY, TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    noTake = true
})

rp.AddEntity({
    name = "Раздатчик Здоровья",
    ent = "med_lab",
    model = "models/flaymi/anomaly/dynamics/equipments/medical/item_aptechka.mdl",
    price = 145,
    max = 1,
    cmd = "/buymedlab",
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_VSU_VENDOR, TEAM_UCHENIY, TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    noTake = true
})

rp.AddShipment({
    name = "Аптечка",
    ent = "ent_medpack",
    model = "models/flaymi/anomaly/dynamics/equipments/medical/item_aptechka.mdl",
    price = 350,
    count = 10,
    maxStack = 20,
    seperate = false,
    pricesep = 550,
    noship = false,
    base = 'usable',
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_VSU_VENDOR, TEAM_UCHENIY, TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
})

rp.AddEntity({
     name = "Анти-радиционные таблетки",
     ent = "antirad_pills",
     model = "models/flaymi/anomaly/dynamics/devices/dev_antirad.mdl",
     price = 100,
     count = 5,
     base = 'usable',
     maxStack = 5,
     stackable = true,
     allowed = {TEAM_UCHENIY},
 })


rp.AddShipment({
    name = "Броня",
    ent = "armor_piece_full",
    model = "models/flaymi/anomaly/dynamics/equipments/trade/parts.mdl",
    price = 150,
    count = 10,
    maxStack = 20,
    stackable = true,
    seperate = false,
    pricesep = 750,
    noship = false,
    base = 'usable',
    allowed = {TEAM_KROT, TEAM_KOLPAK, TEAM_VSU_VENDOR, TEAM_UCHENIY, TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
})

---- ЕДА

rp.AddShipment({
    name = "Балтика 7",
    ent = "durgz_alcohol",
    model = "models/flaymi/anomaly/dynamics/devices/dev_beer.mdl",
    price = 500,
    count = 12,
    maxStack = 6,
    stackable = true,
    seperate = false,
    pricesep = 500,
    noship = false,
    base = 'usable',
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK},
})

rp.AddShipment({
    name = "Сигареты",
    ent = "models/flaymi/anomaly/dynamics/devices/dev_cigarettes_lucky.mdl",
    model = "models/boxopencigshib.mdl",
    price = 500,
    count = 12,
    maxStack = 40,
    stackable = true,
    seperate = false,
    pricesep = 300,
    noship = false,
    base = 'usable',
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
})

rp.AddFood({
    name = "Минеральная вода",
    ent = "booster",
    model = "models/flaymi/anomaly/dynamics/devices/dev_mineral_water.mdl",
    count = 10,
    price = 20,
    stackable = true,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    foodAmount = 10,
    healthAmount = 0,
    maxStack = 10,
    stackable = true,
})

rp.AddFood({
    name = "Хлеб",
    ent = "bread",
    model = "models/flaymi/anomaly/dynamics/devices/dev_bred.mdl",
    count = 10,
    price = 40,
    stackable = true,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    foodAmount = 20,
    healthAmount = 0,
    stackable = true,
    maxStack = 10,
    stackable = true,
})

rp.AddFood({
    name = "Колбаса",
    ent = "colbasa",
    model = "models/flaymi/anomaly/dynamics/devices/dev_kolbasa.mdl",
    count = 10,
    price = 40,
    stackable = true,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    foodAmount = 20,
    healthAmount = 0,
    stackable = true,
    maxStack = 10,
    stackable = true,
})
/*
rp.AddEntity({
    name = "Микроволновка",
    ent = "microwave",
    model = "models/props_c17/furniturestove001a.mdl",
    price = 200,
    max = 4,
    cmd = "/buymicrowave",
    allowed = {false},
    noTake = true
})
*/

-- Патроны
/*
rp.AddEntity({
    name = "Ракета",
    ent = "item_rpg_round",
    model = "models/weapons/w_stalker_rocket.mdl",
    price = 5000,
    max = 3,
    cmd = "/buyrocket2",
    noTake = false,
    allowed = {TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_ORDENI, TEAM_SIDORIVENT, TEAM_SHAIMANTORG, TEAM_SUN2, TEAM_INFA2, TEAM_JEW, TEAM_DOLGMORGAN},
    width = 2,
    height = 2,
})

rp.AddEntity({
    name = "Гранатометный патрон",
    ent = "m9k_ammo_40mm_single",
    model = "models/weapons/w_stalker_rg6_grenade.mdl",
    price = 3000,
    max = 5,
    cmd = "/buygran2",
    noTake = false,
    allowed = {TEAM_KOLPAK, TEAM_SHUSTRIY, TEAM_ORDENI, TEAM_SIDORIVENT, TEAM_SHAIMANTORG, TEAM_SUN2, TEAM_JEW, TEAM_DOLGMORGAN},
    height = 2,
})
*/
rp.AddShipment({
    name = "Сигареты Беломорканал",
    ent = "weapon_ciga_pachka_cheap",
    model = "models/mordeciga/mordes/pachkacig.mdl",
    price = 550,
    allowed = {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_GAVAECKEYS},
    count = 5,
    maxStack = 40,
    stackable = true,
})

rp.AddShipment({
    name = "Гитара",
    ent = "guitar_stalker",
    model = "models/custom/guitar/m_d_45.mdl",
    price = 1500,
    allowed = {TEAM_GAVAECKEYS},
    count = 5,
    maxStack = 5,
    stackable = true,
})

