player_manager.AddValidModel("HL_a_combine_vanilla", "models/cultist/hl_a/vannila_combine/combine_soldier.mdl")
player_manager.AddValidHands("HL_a_combine_vanilla", "models/cultist/hl_a/vannila_combine/combine_soldier_hands.mdl", 0, 00000000)


local Category = "HL:Alyx"
 
local NPC = {   Name = "Combine Vanilla", 
                Class = "npc_combine_s",
                Model = "models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl",
                Health = "100", 
                Weapons = { "weapon_ar2" }, 
                Category = Category }
                               
list.Set( "NPC", "npc_hla_combine_vannila", NPC )

