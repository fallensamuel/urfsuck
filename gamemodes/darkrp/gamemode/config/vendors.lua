-- "gamemodes\\darkrp\\gamemode\\config\\vendors.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Основные торговцы
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
rp.AddVendor("Гаваец", "models/player/stalker/compiled 0.34/hawaiian.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(-756, -13165, -384),
		Angle(0, 179, 0)
	},
})


rp.AddVendor("Незнакомец", "models/player/stalker_bandit/bandit_cloak/bandit_cloak.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(11868, 9514, 134),
		Angle(0, 91, 0)
	},
})

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Скупщики
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
rp.AddVendor("Профессор Сахаров", "models/nauch2.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(2280, -12111, -120),
		Angle(0, -177, 0)
	},
})

rp.AddVendor("Дежурный", "models/player/stalker_soldier/soldier_bandana_2/soldier_bandana_2.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(-10893, -9206, -384),
		Angle(0, -91, 0)
	},
})
/*
rp.AddVendor("Ученый ЧН", "models/player/stalker_nebo/nebo_novice/nebo_novice.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(11495, 4328, -528),
		Angle(0, -88, 0)
	},
})
*/
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Квестовые торговцы
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

rp.AddVendor("Сталкер Колобок", "models/player/stalker_lone/lone_novice/lone_novice.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(-680, -12038, -384),
		Angle(0, -2, 0),
	},
})

rp.AddVendor("Научный сотрудник", "models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(1808, -12054, -120),
		Angle(0, 0, 0)
	},
})

rp.AddVendor("Мадама", "models/player/stalker_bandit/bandit_guard/bandit_guard.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(-8533, -5795, -30),
		Angle(0, 142, 0)
	},
})

/*rp.AddVendor("Пропавший часовой", "models/npc/stalker_soldier/soldier_beret_0/soldier_beret_0.mdl", "idle_all_01", {
	rp_stalker_urfim_v3 = {
		Vector(3534, -1214, -1008),
		Angle(0, 96, 0)
	},
})*/

/*rp.AddVendor("Ученый Чистого Неба", "models/stalkertnb2/cs1_snood.mdl", "idle_all_01", {
	rp_pripyat_urfim = {
		Vector(11160, 7715, -124),
		Angle(0, 0, 0)
	},
	rp_st_pripyat_urfim = {
		Vector(13403, 2563, 0),
		Angle(0, 180, 0)
	},
	rp_stalker_urfim_v3 = {
		Vector(6764, 1860, -4244),
		Angle(0, 0, 0)
	},
	rp_stalker_urfim = {
		Vector(11495, 4328, -528),
		Angle(0, -88, 0)
	},
})*/
---
rp.AddVendor("Заведующий складом", "models/player/stalker_soldier/soldier_beret_2/soldier_beret_2.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(-9740, -11937, -384),
		Angle(0, -174, 0)
	},
})

rp.AddVendor("Перевозчик продовольствия", "models/player/stalker_lone/lone_old/lone_old.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(1652, 11801, -256),
		Angle(0, 6, 0)
	},
})

rp.AddVendor("Управляющий инвентарем", "models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl", "idle_all_01", {
	rp_stalker_urfim = {
		Vector(1630, -11410, -131),
		Angle(0, -82, 0)
	},
})

--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--Интересные стойки
--————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
--[[
————————————————————
--робят
————————————————————
idle_all_01 - ровная стойка
walk_suitcase - стойка наклонная


————————————————————
--не робят
————————————————————
plazastand1 - стойка облокотившись спиной
plazastand2 - стойка облокотившись спиной
plazastand3 - стойка облокотившись слево
plazastand4 - стойка с корточек

cwalk_all - сидя
arrestpostidle - труп
arrestpreidle - труп
apcarrestidle - к стене

canals_mary_postidle - на коленях
canals_mary_preidle - молится
canals_mary_wave - на коленях зовет 


]]


--[[
Пример конфигурации:

rp.AddVendor("Имя NPC", "Модель NPC", "Секвенция NPC", {
	НАЗВАНИЕ_КАРТЫ = {
		Vector(0, 0, 0), позиция нпс
		Angle(0, 0, 0) угол поворота нпс
	},
	НАЗВАНИЕ_КАРТЫ2 = {
		Vector(0, 0, 0), позиция нпс
		Angle(0, 0, 0) угол поворота нпс
	},
	... и тд.
})




rp.AddVendor("Торговец Витя", "models/Barney.mdl", "lean_back", {
	rp_berlin_urfim = {
		Vector(708, 10595, -447),
		Angle(0, -94, 0)
	}
})


rp.AddItemVendor("Тыквенный Король")
:SetModel("models/zerochain/props_pumpkinnight/zpn_shopnpc.mdl")
:SetPos(-5837, -13585, -4152)
:SetAngles(0, -180, 0)
:SetSequence("wave")
:SetPriceItem("rpitem_pumpkin", 'icons/pump_menu') -- Итем за который можно будет купить другие предметы (uid и иконка)

:AddBuyItem("present_2", 50) 
:AddBuyItem("present_3", 15) 
:AddBuyItem("present_4", 30) 
:AddBuyItem("present_5", 30)  


:SetPriceSmall("Тыкв") -- отобржается в меню
:SetPriceName("Тыкв") -- отобржается в меню
]]--
/*
-- Ивенты
if isNoDonate then
rp.AddItemVendor("Дед Мороз")
:SetModel("models/player/christmas/santa.mdl")
:SetPos(-5833, -13589, -4152)
:SetAngles(0, 180, 0)
:SetSequence("idle_all_01")
:SetPriceItem("ny_item", 'rpui/icons/gift_menu') -- Итем за который можно будет купить другие предметы (uid и иконка)

:AddBuyItem("present_2", 49) 
:AddBuyItem("present_4", 15) 
:AddBuyItem("present_5", 30) 
:AddBuyItem("present_6", 69) 

:SetPriceSmall("Частей Подарков") -- отобржается в меню
:SetPriceName("Частей Подарков") -- отобржается в меню

else

rp.AddItemVendor("Дед Мороз")
:SetModel("models/player/christmas/santa.mdl")
:SetPos(-2800, -10256, 7)
:SetAngles(0, 0, 0)
:SetSequence("idle_all_01")
:SetPriceItem("ny_item", 'rpui/icons/gift_menu') -- Итем за который можно будет купить другие предметы (uid и иконка)

:AddBuyItem("present_2", 49) 
:AddBuyItem("present_4", 15) 
:AddBuyItem("present_5", 30) 
:AddBuyItem("present_6", 69) 

:SetPriceSmall("Частей Подарков") -- отобржается в меню
:SetPriceName("Частей Подарков") -- отобржается в меню

end
*/

-- Cool loot NPS

rp.AddItemVendor("Якорь")
:SetModel("models/player/stalker_bandit/bandit_exoseva/bandit_exoseva.mdl")
:SetPos(-905, -10617, -384)
:SetAngles(0, 139, 0)
:SetSequence("idle_all_01")
:SetPriceItem("legend_jeton", 'raddetect/stalkerrad.png') -- Итем за который можно будет купить другие предметы (uid и иконка)

:AddBuyItem("legendtorg_case", 25) 
:AddBuyItem("tfa_anomaly_vintorez_nimble", 7) 
:AddBuyItem("tfa_anomaly_ak74u_snag", 5) 
:AddBuyItem("tfa_anomaly_m24", 7) 
:AddBuyItem("tfa_anomaly_vepr", 10) 
:AddBuyItem("tfa_anomaly_pkp", 7) 
:AddBuyItem("weapon_slam", 3) 
:AddBuyItem("rpitem_printerbooster_5", 10)


:SetPriceSmall("Жетонов Торговца") -- отобржается в меню
:SetPriceName("Жетонов Торговца") -- отобржается в меню