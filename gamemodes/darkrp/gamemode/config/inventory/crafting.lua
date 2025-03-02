-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\crafting.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*	rp.cfg.DefaultTimeCreation = 3

-- Крафтинг
rp.AddCraftingRecipe("Обычный Майнер", "simpleprint2", {
	["rpitem_steel"] = 1,
	["rpitem_accum"] = 1,
	["simpleprint1"] = 1,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Улучшенный Майнер", "simpleprint3", {
	["rpitem_procc"] = 1,
	["rpitem_core"] = 2,
	["simpleprint2"] = 1
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Секретный Майнер", "simpleprint4", {
	["rpitem_accum"] = 2,
	["rpitem_procc"] = 2,
	["rpitem_core"] = 1,
	["simpleprint3"] = 1
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Самодельный Бустер", "rpitem_printerbooster_2", {
	["rpitem_accum"] = 1,
	["rpitem_procc"] = 1,
	["rpitem_core"] = 1,
}, {"rpitem_wrench"})

rp.AddCraftingRecipe("Жетон Торговца", "legend_jeton", {
	["rpitem_steel"] = 10,
	["rpitem_core"] = 5,
	["rpitem_battery"] = 10,
    ["rpitem_accum"] = 5,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Ремонтный Набор", "money_printer_fix", {
	["rpitem_metal"] = 4,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Сталь", "rpitem_steel", {
	["rpitem_metal"] = 4
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Системные Платы", "rpitem_procc", {
	["rpitem_metal"] = 3,
	["rpitem_battery"] = 1
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Гаечный ключ", "rpitem_wrench", {
	["rpitem_metal"] = 4
}, false, 5)

rp.AddCraftingRecipe("Конденсаторы", "rpitem_core", {
	["rpitem_metal"] = 1,
	["rpitem_accum"] = 2
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Аккумулятор", "rpitem_accum", {
	["rpitem_steel"] = 2,
	["rpitem_battery"] = 2
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Инструменты для грубой работы", "rpitem_blowtorch", {
	["rpitem_battery"] = 1,
	["rpitem_metal"] = 1
}, {"rpitem_wrench"})

rp.AddCraftingRecipe("Инструменты для тонкой работы", "rpitem_toolkit", {
	["rpitem_wrench"] = 1,
	["rpitem_blowtorch"] = 1,
	["rpitem_metal"] = 1
})

rp.AddCraftingRecipe("Секретные Оружейные Чертежи", "rpitem_secret_book", {
	["rpitem_secret_list"] = 15
})

rp.AddCraftingRecipe("Форма Бандита", "ent_disguise_band", {
	["rpitem_fabric"] = 8,
})

rp.AddCraftingRecipe("Комплект Формы Военного", "ent_disguise_army", {
	["rpitem_army_desclothes"] = 1,
	["rpitem_fabric"] = 8,
})

rp.AddCraftingRecipe("Камуфляжная Заря", "ent_cloth8", {
	["rpitem_fabric"] = 15,
} , {"rpitem_toolkit"})

rp.AddCraftingRecipe("Уплотненный Экзоскелет", "ent_cloth9", {
	["rpitem_fabric"] = 10,
	["rpitem_steel"] = 10,
	["rpitem_metal"] = 15,
} , {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Отмычка", "lockpick", {
	["rpitem_steel"] = 2,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Взломщик", "hacktool", {
	["rpitem_steel"] = 2,
	["rpitem_procc"] = 1,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Гитара", "guitar_stalker", {
	["rpitem_steel"] = 2,
	["rpitem_fabric"] = 2,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("MP5", "tfa_anomaly_mp5", {
	["rpitem_steel"] = 4,
	["rpitem_guns_meh"] = 3,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Desert Eagle", "tfa_anomaly_desert_eagle", {
	["rpitem_steel"] = 5,
	["rpitem_guns_meh"] = 4,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("Форт-500", "tfa_anomaly_fort500", {
	["rpitem_steel"] = 7,
	["rpitem_guns_meh"] = 3,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("АК-74", "tfa_anomaly_ak74", {
	["rpitem_steel"] = 6,
	["rpitem_guns_meh"] = 4,
}, {"rpitem_blowtorch"})

rp.AddCraftingRecipe("АКS", "tfa_anomaly_aks", {
	["rpitem_steel"] = 8,
	["rpitem_guns_meh"] = 6,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("LR-300", "tfa_anomaly_lr300", {
	["rpitem_steel"] = 8,
	["rpitem_guns_meh"] = 5,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("РПД", "tfa_anomaly_rpd", {
	["rpitem_steel"] = 8,
	["rpitem_guns_meh"] = 6,
}, {"rpitem_secret_book"})

rp.AddCraftingRecipe("ПКМ", "tfa_anomaly_pkm", {
	["rpitem_steel"] = 15,
	["rpitem_guns_meh"] = 12,
}, {"rpitem_secret_book"})

rp.AddCraftingRecipe("SPAS-12", "tfa_anomaly_spas12", {
	["rpitem_steel"] = 7,
	["rpitem_guns_meh"] = 6,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Saiga-12", "tfa_anomaly_saiga", {
	["rpitem_steel"] = 12,
	["rpitem_guns_meh"] = 9,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Armsel Protecta", "tfa_anomaly_protecta", {
	["rpitem_steel"] = 15,
	["rpitem_guns_meh"] = 10,
	["rpitem_metal"] = 5,
}, {"rpitem_toolkit"})

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Квестовые вещи
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

rp.AddCraftingRecipe("Ящик c частями мутантов", "rpitem_mutantchasti", {
	["rpitem_mutant_zombi"] = 5,	
	["rpitem_mutant_snork"] = 3,	
	["rpitem_mutant_krovosos"] = 3,				
})

rp.AddCraftingRecipe("Сборник документов", "rpitem_sbornikdocks", {
	["rpitem_dockx18"] = 1,
	["rpitem_dockx8"] = 1,
	["rpitem_dockpripat"] = 1,	
	["rpitem_dockx16"] = 1,		
	["rpitem_dockgaus"] = 1,		
})*/