local loots = {
	{"rpitem_metal", 50},
	{"rpitem_fabric", 25},
	{"rpitem_battery", 20},
}

local combine_loot = {
	{"rpitem_procc", 15},
	{"rpitem_mpf_mask", 5},
	{"rpitem_mpf_clothes", 5},
	{"rpitem_comb_list", 5},
	{"rpitem_comb_caps", 10},
	{"rpitem_comb_procc", 5},
	{"swb_pistol", 0.35},
	{"swb_smg", 0.1},
	{"swb_357", 0.05},
	{"swb_ar2", 0.01},
}

rp.AddTypeLoot("low_loot", loots, function(ent) ent:SetSkin(0) end)
rp.AddTypeLoot("medium_loot", loots, function(ent) ent:SetSkin(1) end)
rp.AddTypeLoot("super_loot", loots, function(ent) ent:SetSkin(2) end)
rp.AddTypeLoot("combine_loot", combine_loot, function(ent) ent:SetSkin(3) end)

rp.AddTypeLoot("low_food_loot",{
	{"urf_foodsystem_food_bread", 40},
	{"urf_foodsystem_food_beans", 20},
	{"urf_foodsystem_ration_normal", 20},
})

rp.AddTypeLoot("medium_food_loot",{
	{"urf_foodsystem_food_bread", 40},
	{"urf_foodsystem_food_beans", 20},
	{"urf_foodsystem_ration_normal", 20},
	{"urf_foodsystem_ration_expanded", 10},	
})

rp.AddTypeLoot("super_food_loot",{
	{"urf_foodsystem_ration_cwu", 10},
	{"urf_foodsystem_food_bread", 40},
	{"urf_foodsystem_food_beans", 20},
	{"urf_foodsystem_ration_expanded", 10},
	{"urf_foodsystem_ration_mpf", 10},
})

rp.AddTypeLoot("low_guns_rebel_loot",{
	{"swb_pistol", 25},
	{"swb_shotgun", 5},
	{"swb_smg", 5},
})

rp.AddTypeLoot("super_guns_rebel_loot",{
	{"swb_oicw_v2", 10},
	{"swb_pistol", 25},
	{"swb_shotgun", 10},
	{"swb_smg", 15},
	{"swb_bow", 0.1},
})

rp.AddTypeLoot("low_guns_combine_loot",{
    {"swb_357", 15},
	{"swb_shotgun", 5},
	{"swb_smg", 5},
})

rp.AddTypeLoot("super_guns_combine_loot",{
	{"swb_ar3", 10},
	{"swb_ar2", 15},
	{"swb_shotgun", 10},
	{"swb_smg", 25},
	{"tfa_suppressor", 0.001},
})

rp.AddTypeLoot("guns_loot_meh",{
	{"rpitem_guns_meh", 25},
	{"rpitem_metal", 10},
	{"rpitem_steel", 10},
})

rp.AddTypeLoot("rebel_loot",{
	{"rpitem_rebel_mask", 20},
	{"rpitem_rebel_clothes", 20},
	{"swb_pistol", 0.35},
	{"swb_smg", 0.1},
	{"swb_shotgun", 0.05},
	{"swb_oicw_v2", 0.01},
})

rp.AddTypeLoot("armorandheal_loot",{
	{"ent_medpack", 20},
	{"armor_piece_full", 20},
})

rp.AddTypeLoot("heal_loot",{
	{"ent_medpack", 20},
})

rp.AddTypeLoot("armor_loot",{
	{"armor_piece_full", 20},
})

rp.AddTypeLoot("strider_loot",{
    {"swb_ar2", 25},
    {"swb_shotgun", 15},
    {"swb_ar3", 10},
    {"tfa_suppressor", 0.5},
    {"swb_bow", 0.5},
})

rp.AddTypeLoot("pumpkin_loot",{
    {"rpitem_pumpkin", 100},
})