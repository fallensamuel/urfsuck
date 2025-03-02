
-- Компоненты
rp.AddItem({
	name = "Дерево",
	ent = "rpitem_wood", 
	model = "models/fallout/components/wood.mdl", 
	noDrop = false, 
	stackable = true, 
	category = "entities",
	maxStack = 20, 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 4},          
    },
})

rp.AddItem({
	name = "Металлолом",
	ent = "rpitem_metal", 
	model = "models/fallout/components/glass.mdl",  
	noDrop = false, 
	stackable = true, 
	category = "entities",
	maxStack = 15, 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 6},   
        ["Джон - Приемщик"] = {sellPrice = 8},        
    },
})

rp.AddItem({
	name = "Сталь",
	ent = "rpitem_steel", 
	model = "models/fallout/components/ingot.mdl",
	category = "entities",
	noDrop = false, 
	stackable = true, 
	maxStack = 15, 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 24},  
        ["Джон - Приемщик"] = {sellPrice = 29},  
        ["Подмастерье"] = {buyPrice = 30},       
    },
})

rp.AddItem({
	name = "Ткань",
	ent = "rpitem_fabric", 
	model = "models/fallout/components/spool_1.mdl",
	category = "entities",
	noDrop = false, 
	stackable = true, 
	maxStack = 15, 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 8},          
    },
})

rp.AddItem({
	name = "Электролит",
	ent = "rpitem_battery", 
	model = "models/fallout/components/jar.mdl", 
	noDrop = false, 
	stackable = true, 
	maxStack = 15, 
	category = "entities",
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 12},
        ["Джон - Приемщик"] = {sellPrice = 18},          
    },
})

rp.AddItem({
	name = "Фрагмент Чертежа Альянса",
	ent = "rpitem_comb_list", 
	model = "models/props_lab/clipboard.mdl", 
	category = "entities",
	noDrop = false,
	stackable = true, 
	maxStack = 30, 
	vendor = {
        ["Ден - Снабженец"] = {sellPrice = 50},       
    },
})


-- Инструменты
rp.AddItem({
	name = "Набор инструментов",
	ent = "rpitem_toolkit", 
	model = "models/mark2580/gtav/garage_stuff/tool_box_02.mdl", 
	category = "entities",
	noDrop = false,
	stackable = true, 
	maxStack = 10, 
})

rp.AddItem({
	name = "Чертежи Оружия Альянса",
	ent = "rpitem_comb_book", 
	model = "models/props_lab/binderblue.mdl", 
	noDrop = false,
	maxStack = 5,
		vendor = {
    ["Ден - Снабженец"] = {sellPrice = 1500},
    },   
})

-- Для принтеров
rp.AddItem({
	name = "Блок питания",
	ent = "rpitem_core", 
	model = "models/xqm/hydcontrolbox.mdl", 
	noDrop = false, 
	stackable = true, 
	maxStack = 10, 
	category = "entities", 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 96},
        ["Джон - Приемщик"] = {sellPrice = 130},          
    },
})

rp.AddItem({
	name = "Микропроцессор",
	ent = "rpitem_procc", 
	model = "models/maxofs2d/hover_plate.mdl", 
	noDrop = false, 
	stackable = true, 
	maxStack = 10,
	category = "entities", 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 36},          
    },
})

rp.AddItem({
	name = "Аккумулятор",
	ent = "rpitem_accum", 
	model = "models/mark2580/gtav/garage_stuff/bike_battery_01.mdl", 
	noDrop = false, 
	stackable = true, 
	maxStack = 10,
	category = "entities",
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 36},
        ["Джон - Приемщик"] = {sellPrice = 45},          
    }, 
})

-- Для оружия
rp.AddItem({
	name = "Оружейные Механизмы",
	ent = "rpitem_guns_meh", 
	model = "models/illusion/eftcontainers/ammocase.mdl", 
	noDrop = false,
	stackable = true, 
	maxStack = 15, 
	category = "entities", 
	vendor = {
        ["Майк - Скупщик"] = {sellPrice = 55},
        ["Джон - Приемщик"] = {sellPrice = 60},
        ["Подмастерье"] = {buyPrice = 60},
    },
})

rp.AddItem({
	name = "Микропроцессор Альянса",
	ent = "rpitem_comb_procc", 
	model = "models/gibs/shield_scanner_gib4.mdl", 
	noDrop = false,
	stackable = true, 
	maxStack = 30, 
	category = "entities", 
	vendor = {
        ["Ден - Снабженец"] = {sellPrice = 80},            
    }, 
})

rp.AddItem({
	name = "Энергетическая капсула Альянса",
	ent = "rpitem_comb_caps", 
	model = "models/items/combine_rifle_ammo01.mdl", 
	noDrop = false,
	stackable = true, 
	maxStack = 10,
	category = "entities", 
	vendor = {
        ["Ден - Снабженец"] = {sellPrice = 40},          
    },
})

rp.AddItem({
	name = "Маска MpF",
	ent = "rpitem_mpf_mask", 
	model = "models/dpfilms/metropolice/props/generic_gasmask.mdl", 
	noDrop = true, 
	stackable = true, 
	maxStack = 5, 
})

rp.AddItem({
	name = "Форма MpF",
	ent = "rpitem_mpf_clothes", 
	model = "models/tnb/items/shirt_metrocop.mdl", 
	noDrop = true, 
	stackable = true, 
	maxStack = 5, 
})

rp.AddItem({
	name = "Шапка Повстанца",
	ent = "rpitem_rebel_mask", 
	model = "models/tnb/items/beaniewrap.mdl", 
	noDrop = true, 
	stackable = true, 
	maxStack = 5, 
})

rp.AddItem({
	name = "Форма Повстанца",
	ent = "rpitem_rebel_clothes", 
	model = "models/tnb/items/shirt_rebeloverwatch.mdl", 
	noDrop = true, 
	stackable = true, 
	maxStack = 5, 
})

/*
-- Сумки
rp.AddItem({
	name = "Портфель",
	ent = "rpitem_bag1", 
	model = "models/props_c17/briefcase001a.mdl", 
	noDrop = true, 
	base = "bags", 
	invWidth = 2,
	invHeight = 2,
})

rp.AddItem({
	name = "Чемодан",
	ent = "rpitem_bag2", 
	model = "models/props_c17/suitcase001a.mdl", 
	noDrop = true, 
	base = "bags", 
	invWidth = 4,
	invHeight = 2,
})

rp.AddItem({
	name = "Коробка",
	ent = "rpitem_bag3", 
	model = "models/items/largeboxbrounds.mdl", 
	noDrop = true, 
	base = "bags", 
	invWidth = 4,
	invHeight = 4,
})
*/

rp.AddItem({
	name = "Генератор Токенов",
	ent = "simpleprint2", 
	model = "models/urf/bitminer_1.mdl", 
})

rp.AddItem({
	name = "Улучшенный Генератор Токенов",
	ent = "simpleprint3", 
	model = "models/urf/bitminer_3.mdl", 
})

rp.AddItem({
	name = "Секретный Генератор Токенов",
	ent = "simpleprint4", 
	model = "models/urf/bitminer_urf.mdl", 
})

-- Курьерство
rp.AddItem({
	name = "Посылка Бобу в Бар",
	ent = "rpitem_package_one", 
	model = "models/props/de_nuke/crate_extrasmall.mdl", 
	noDrop = true, 
	maxStack = 1,
	width = 1,
    height = 1, 
    max = 2,
    vendor = {
        ["Старший Курьер"] = {buyPrice = 1},   
        ["Весельчак Боб"] = {sellPrice = 100},        
    },
})


rp.AddItem({
	name = "Посылка Якову в D4",
	ent = "models/props/cs_office/file_box.mdl", 
	model = "models/props_junk/cardboard_box001a.mdl", 
	noDrop = true, 
	maxStack = 1,
	width = 1,
    height = 1, 
    max = 2,
    vendor = {
        ["Старший Курьер"] = {buyPrice = 1},   
        ["Скупой Яков"] = {sellPrice = 160},        
    },
})

rp.AddItem({
	name = "Посылка в Нексус",
	ent = "rpitem_package_three", 
	model = "models/props_blackmesa/bms_metalcrate_48x48.mdl", 
	noDrop = true, 
	maxStack = 1,
	width = 2,
    height = 2, 
    max = 1,
    vendor = {
        ["Старший Курьер"] = {buyPrice = 1},   
        ["Секретарь Нексус Надзора"] = {sellPrice = 80},        
    },
})

rp.AddItem({
	name = "Тайная Посылка Дену",
	ent = "rpitem_package_four", 
	model = "models/Items/item_item_crate.mdl", 
	noDrop = true, 
	maxStack = 1,
	width = 2,
    height = 2, 
    max = 2,
    vendor = {
        ["Старший Курьер"] = {buyPrice = 1},   
        ["Ден - Снабженец"] = {sellPrice = 250},        
    },
})

rp.AddEntity({
	name = "Праздничная Тыква",
	ent = "rpitem_pumpkin", 
	icon_override = "icons/pumpkin",
	icon = "icons/pumpkin",
	noDrop = true, 
	notCanGive = true, 
	noUseFunc = true, 
	stackable = true,
	maxStack = 25,
	width = 1,
    height = 1,  
})