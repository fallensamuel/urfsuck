-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\crafttable.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- ВЕРСТАК

-- Оружие 

rp.CraftTableCategory( translates.Get("Оружие") );

rp.AddToCraftTable("tfa_anomaly_desert_eagle", {
	rp.CraftableItem("rpitem_guns_meh", 2),
	rp.CraftableItem("rpitem_metal", 10),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_mp5", {
	rp.CraftableItem("rpitem_guns_meh", 2),
	rp.CraftableItem("rpitem_metal", 10),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_aks", {
	rp.CraftableItem("rpitem_guns_meh", 3),
	rp.CraftableItem("rpitem_metal", 12),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_ak74", {
	rp.CraftableItem("rpitem_guns_meh", 3),
	rp.CraftableItem("rpitem_metal", 12),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_lr300", {
	rp.CraftableItem("rpitem_guns_meh", 4),
	rp.CraftableItem("rpitem_metal", 14),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_fort500", {
	rp.CraftableItem("rpitem_guns_meh", 4),
	rp.CraftableItem("rpitem_metal", 15),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_spas12", {
	rp.CraftableItem("rpitem_guns_meh", 5),
	rp.CraftableItem("rpitem_metal", 15),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_saiga", {
	rp.CraftableItem("rpitem_guns_meh", 6),
	rp.CraftableItem("rpitem_metal", 20),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_protecta", {
	rp.CraftableItem("rpitem_guns_meh", 7),
	rp.CraftableItem("rpitem_metal", 20),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_rpd", {
	rp.CraftableItem("rpitem_guns_meh", 7),
	rp.CraftableItem("rpitem_metal", 20),
},	Angle(0, 0, -90))

rp.AddToCraftTable("tfa_anomaly_pkm", {
	rp.CraftableItem("rpitem_guns_meh", 7),
	rp.CraftableItem("rpitem_metal", 20),
},	Angle(0, 0, -90))

-- Снаряга 

rp.CraftTableCategory( translates.Get("Снаряжение") );

rp.AddToCraftTable("lockpick", {
	rp.CraftableItem("rpitem_metal", 6),
},	Angle(0, 0, -90))

rp.AddToCraftTable("hacktool", {
	rp.CraftableItem("rpitem_metal", 2),
	rp.CraftableItem("rpitem_battery", 4),
	rp.CraftableItem("rpitem_elecc", 4),
},	Angle(0, 0, -90))

rp.AddToCraftTable("guitar_stalker", {
	rp.CraftableItem("rpitem_metal", 8),
	rp.CraftableItem("rpitem_fabric", 4),
},	Angle(0, 0, -90))

rp.AddToCraftTable("legend_jeton", {
	rp.CraftableItem("rpitem_battery", 5),
	rp.CraftableItem("rpitem_elecc", 5),
	rp.CraftableItem("rpitem_fabric", 5),
	rp.CraftableItem("rpitem_metal", 5),
},	Angle(0, 0, -90))

rp.AddToCraftTable("ent_disguise_band", {
	rp.CraftableItem("rpitem_fabric", 8),
},	Angle(0, 0, -90))

rp.AddToCraftTable("ent_disguise_army", {
	rp.CraftableItem("rpitem_fabric", 12),
},	Angle(0, 0, -90))

rp.AddToCraftTable("ent_cloth8", {
	rp.CraftableItem("rpitem_fabric", 15),
},	Angle(0, 0, -90))

rp.AddToCraftTable("ent_cloth9", {
	rp.CraftableItem("rpitem_metal", 15),
	rp.CraftableItem("rpitem_battery", 5),
	rp.CraftableItem("rpitem_elecc", 5),
	rp.CraftableItem("rpitem_fabric", 10),
},	Angle(0, 0, -90))

-- Техника 

rp.CraftTableCategory( translates.Get("Техника") );

rp.AddToCraftTable("money_printer_fix", {
	rp.CraftableItem("rpitem_metal", 4),
},	Angle(0, 0, -90))

rp.AddToCraftTable("rpitem_accum", {
	rp.CraftableItem("rpitem_metal", 4),
	rp.CraftableItem("rpitem_battery", 4),
    rp.CraftableItem("rpitem_elecc", 4),
},	Angle(0, 0, -90))

rp.AddToCraftTable("rpitem_printerbooster_2", {
	rp.CraftableItem("rpitem_battery", 5),
	rp.CraftableItem("rpitem_elecc", 5),
},	Angle(0, 0, -90))

rp.AddToCraftTable("simpleprint2", {
	rp.CraftableItem("simpleprint1", 1),
	rp.CraftableItem("rpitem_accum", 1),
	rp.CraftableItem("rpitem_battery", 4),
	rp.CraftableItem("rpitem_elecc", 4),
},	Angle(0, 0, -90))

rp.AddToCraftTable("simpleprint3", {
	rp.CraftableItem("simpleprint2", 1),
	rp.CraftableItem("rpitem_accum", 1),
	rp.CraftableItem("rpitem_battery", 6),
	rp.CraftableItem("rpitem_elecc", 8),
},	Angle(0, 0, -90))

rp.AddToCraftTable("simpleprint4", {
	rp.CraftableItem("simpleprint1", 1),
	rp.CraftableItem("rpitem_accum", 1),
	rp.CraftableItem("rpitem_battery", 10),
	rp.CraftableItem("rpitem_elecc", 12),
},	Angle(0, 0, -90))

-- ХИМ ВЕРСТАК

-- Артефакты

rp.CraftTableCategory( translates.Get("Артефакты") );

rp.AddToCraftTable("art_dummy", {
	rp.CraftableItem("art_mincermeat", 2),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_kolobok", {
	rp.CraftableItem("art_soul", 1),
	rp.CraftableItem("art_crystal", 2),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_eye", {
	rp.CraftableItem("art_mincermeat", 1),
	rp.CraftableItem("art_soul", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_gravi", {
	rp.CraftableItem("art_crystal", 2),
	rp.CraftableItem("art_crystalflower", 1),
	rp.CraftableItem("art_nightstar", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_ballon", {
	rp.CraftableItem("art_medusa", 3),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_ice", {
	rp.CraftableItem("art_electra", 3),
	rp.CraftableItem("art_dummybattary", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_electraflash", {
	rp.CraftableItem("art_crystal", 2),
	rp.CraftableItem("art_gravi", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_fire", {
	rp.CraftableItem("art_crystal", 3),
	rp.CraftableItem("art_dummy", 1),
	rp.CraftableItem("art_kolobok", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_dummyglass", {
	rp.CraftableItem("art_mincermeat", 5),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_goldfish", {
	rp.CraftableItem("art_vyvert", 4),
	rp.CraftableItem("art_crystalflower", 2),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_antiexplosion", {
	rp.CraftableItem("art_dummy", 2),
	rp.CraftableItem("art_ice", 2),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_control", {
	rp.CraftableItem("art_fire", 2),
	rp.CraftableItem("art_electraflash", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_psi", {
	rp.CraftableItem("art_medusa", 6),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("art_crystalplant", {
	rp.CraftableItem("art_kolobok", 5),
	rp.CraftableItem("art_goldfish", 1),
	rp.CraftableItem("art_electra", 2),
	rp.CraftableItem("art_mincermeat", 2),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')

rp.AddToCraftTable("ent_psi_anabiotic", {
	rp.CraftableItem("art_psi", 2),
	rp.CraftableItem("art_soul", 1),
	rp.CraftableItem("rpitem_dockx8", 1),
}, Angle(0, 0, -90), nil, nil, nil, 'chemical')