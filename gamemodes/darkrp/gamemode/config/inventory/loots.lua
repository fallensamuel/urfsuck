-- "gamemodes\\darkrp\\gamemode\\config\\inventory\\loots.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local loots = {
	{"rpitem_metal", 75},
	{"rpitem_battery", 10},
	{"rpitem_elecc", 5},
	{"rpitem_fabric", 15},
	{"rpitem_guns_meh", 1},
	{"rpitem_accum", 1},
	{"tfa_anomaly_pp2000", 0.125},
	{"tfa_anomaly_mp5", 0.05},
	{"legend_jeton", 0.1},
}

rp.AddTypeLoot("low_loot", loots, function(ent) ent:SetSkin(0) end)
rp.AddTypeLoot("medium_loot", loots, function(ent) ent:SetSkin(1) end)
rp.AddTypeLoot("super_loot", loots, function(ent) ent:SetSkin(2) end)

rp.AddTypeLoot("started",{
	{"rpitem_fabric", 5},
	{"rpitem_guns_meh", 5},
	{"tfa_anomaly_mp5", 1},
})

rp.AddTypeLoot("monolit_loot",{
	{"rpitem_guns_meh", 25},
	{"tfa_anomaly_desert_eagle", 1},
	{"tfa_anomaly_hk416", 1},
	{"tfa_anomaly_rpd", 0.5},
	{"tfa_anomaly_saiga", 0.1},
	{"tfa_anomaly_protecta", 0.01},
	{"legend_jeton", 0.1},
})

rp.AddTypeLoot("army_loot",{
	{"rpitem_guns_meh", 25},
	{"tfa_anomaly_ak74", 3},
	{"tfa_anomaly_sig550_sniper", 2},
	{"tfa_anomaly_groza_nimble", 1},
	{"tfa_anomaly_svt", 1},
	{"tfa_anomaly_svu", 0.5},
	{"tfa_anomaly_rpd", 0.1},
	{"legend_jeton", 0.1},
})

rp.AddTypeLoot("airdrop_loot",{
	{"rpitem_guns_meh", 25},
	{"rpitem_elecc", 10},
	{"tfa_anomaly_ak74", 4},
	{"tfa_anomaly_sig550_sniper", 4},
	{"tfa_anomaly_lr300", 3},
	{"tfa_anomaly_val", 2},
	{"tfa_anomaly_rpd", 2},	
	{"tfa_anomaly_groza_nimble", 2},
	{"tfa_anomaly_svt", 1},
	{"tfa_anomaly_svu", 1},
	{"tfa_anomaly_svd", 0.5},
    {"rpitem_printerbooster_3", 3},
    {"legend_jeton", 50},
})

rp.AddTypeLoot("shron_loot",{
	--{"weapon_ciga", 10},
	{"ent_medpack", 10},
	--{"item_rpg_round", 10},
	{"tfa_anomaly_ak74", 10},
	{"tfa_anomaly_sig550_sniper", 5},
	{"tfa_anomaly_lr300", 10},
	{"tfa_anomaly_val", 2},
	{"tfa_anomaly_rpd", 2},
	{"tfa_anomaly_desert_eagle", 1},
	{"tfa_anomaly_spas12", 1},
	--{"health_kit_normal", 0.5},
	{"armor_kit", 0.5},
	{"tfa_anomaly_protecta", 0.2},
	{"legend_jeton", 1},
})

rp.AddTypeLoot("pumpkin_loot",{
    {"rpitem_pumpkin", 100},
})

---------------------------------------АВТО-РЕЙДЫ---------------------------------------------------
/*
rp.AddTypeLoot("raidone_loot",{
    {"rpitem_mutant_tushkan", 50},
    {"rpitem_guns_meh", 5},
    {"rpitem_metal", 20},
	{"rpitem_battery", 10},
	{"rpitem_elecc", 5},
	{"rpitem_fabric", 8},
	{"rpitem_accum", 1},
    {"legend_jeton", 1},
})

rp.AddTypeLoot("raidtwo_loot",{
    {"rpitem_mutant_sobaka", 50},
    {"rpitem_guns_meh", 7},
    {"rpitem_metal", 13},
	{"rpitem_battery", 10},
	{"rpitem_elecc", 5},
	{"rpitem_fabric", 8},
	{"rpitem_accum", 4},
    {"legend_jeton", 3},
})

rp.AddTypeLoot("raidtree_loot",{
    {"rpitem_mutant_plot", 50},
    {"rpitem_guns_meh", 10},
    {"rpitem_metal", 10},
	{"rpitem_battery", 5},
	{"rpitem_elecc", 5},
	{"rpitem_fabric", 10},
	{"rpitem_accum", 5},
    {"legend_jeton", 5},
})

rp.AddTypeLoot("raidfour_loot",{
    {"rpitem_mutant_kaban", 50},
    {"rpitem_guns_meh", 5},
    {"rpitem_metal", 5},
	{"rpitem_battery", 5},
	{"rpitem_elecc", 5},
	{"rpitem_fabric", 20},
	{"rpitem_accum", 5},
    {"legend_jeton", 5},
})

rp.AddTypeLoot("raidfive_loot",{
    {"rpitem_mutant_snork", 50},
    {"rpitem_guns_meh", 15},
    {"rpitem_metal", 10},
	{"rpitem_battery", 5},
	{"rpitem_elecc", 10},
	{"rpitem_fabric", 5},
	{"rpitem_accum", 4},
    {"legend_jeton", 7},
})

rp.AddTypeLoot("raidsix_loot",{
    {"rpitem_mutant_krovosos", 50},
    {"rpitem_guns_meh", 20},
    {"rpitem_metal", 5},
	{"rpitem_battery", 5},
	{"rpitem_elecc", 10},
	{"rpitem_fabric", 20},
	{"rpitem_accum", 5},
    {"legend_jeton", 7},
})

rp.AddTypeLoot("raidseven_loot",{
    {"rpitem_mutant_himera", 50},
    {"rpitem_guns_meh", 25},
    {"rpitem_metal", 1},
	{"rpitem_battery", 1},
	{"rpitem_elecc", 1},
	{"rpitem_fabric", 20},
	{"rpitem_accum", 1},
    {"legend_jeton", 10},
})

rp.AddTypeLoot("raidvosem_loot",{
    {"rpitem_mutant_psevdo", 50},
    {"tfa_anomaly_svd", 10},
    {"tfa_anomaly_protecta", 10},
	{"tfa_anomaly_groza_nimble", 10},
	{"tfa_anomaly_rpk", 10},
	{"tfa_anomaly_pkm", 10},
	{"tfa_anomaly_saiga", 10},
    {"legend_jeton", 50},
})

rp.AddTypeLoot("raidstronglav_loot",{
    {"rpitem_mutant_krovosos", 25},
    {"tfa_anomaly_svd", 10},
    {"tfa_anomaly_protecta", 5},
	{"tfa_anomaly_groza_nimble", 10},
	{"tfa_anomaly_rpk", 5},
	{"tfa_anomaly_pkm", 10},
	{"tfa_anomaly_saiga", 10},
    {"legend_jeton", 25},
})*/