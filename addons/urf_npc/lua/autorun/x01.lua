local NPC = {
	Name = "X-01 Power Armor [F]",
	Class = "npc_citizen",
	Model = "models/models/frix/x01/xo1_powerarmor_npc.mdl",
	KeyValues = {citizentype = 4},
	Category = "Fallout 4"
}
list.Set("NPC", "x01_frien", NPC)

NPC = {
	Name = "X-01 Power Armor [H]",
	Class = "npc_combine_s",
	Model = "models/models/frix/x01/xo1_powerarmor_npc.mdl",
	Weapons = { "weapon_smg1", "weapon_ar2" },
	Numgrenades = "4",
	Category = "Fallout 4"
}
list.Set("NPC", "x01_host", NPC)