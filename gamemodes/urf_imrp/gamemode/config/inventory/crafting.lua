rp.cfg.DefaultTimeCreation = 3

-- Крафтинг
rp.AddCraftingRecipe("Генератор Токенов", "simpleprint2", {
	["rpitem_steel"] = 2,
	["rpitem_accum"] = 2,
	["simpleprint1"] = 1,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Улучшенный Генератор Токенов", "simpleprint3", {
	["rpitem_procc"] = 2,
	["rpitem_core"] = 4,
	["simpleprint2"] = 1
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Секретный Генератор Токенов", "simpleprint4", {
	["rpitem_accum"] = 4,
	["rpitem_procc"] = 4,
	["rpitem_core"] = 2,
	["simpleprint3"] = 1
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Ремонтный Набор", "money_printer_fix", {
	["rpitem_metal"] = 4,
}, {"rpitem_toolkit"})

rp.AddCraftingRecipe("Сталь", "rpitem_steel", {
	["rpitem_metal"] = 4
})

rp.AddCraftingRecipe("Микропроцессор", "rpitem_procc", {
	["rpitem_steel"] = 1,
	["rpitem_battery"] = 1
})

rp.AddCraftingRecipe("Блок питания", "rpitem_core", {
	["rpitem_steel"] = 1,
	["rpitem_accum"] = 2
})

rp.AddCraftingRecipe("Аккумулятор", "rpitem_accum", {
	["rpitem_metal"] = 2,
	["rpitem_battery"] = 2
})

rp.AddCraftingRecipe("Чертежи Оружия Альянса", "rpitem_comb_book", {
	["rpitem_comb_list"] = 15
})

rp.AddCraftingRecipe("Комплект Формы Гражданина", "ent_disguise_citizen", {
	["rpitem_fabric"] = 5,
})

rp.AddCraftingRecipe("Комплект Формы MPF", "ent_disguise_mpf", {
	["rpitem_mpf_mask"] = 1,
	["rpitem_mpf_clothes"] = 1,
})

rp.AddCraftingRecipe("Комплект Формы Повстанца", "ent_disguise_rebel", {
	["rpitem_rebel_mask"] = 1,
	["rpitem_rebel_clothes"] = 1,
})