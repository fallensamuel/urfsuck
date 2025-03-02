player_manager.AddValidModel("HL_a_combine_suppresor", "models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl")
player_manager.AddValidHands("HL_a_combine_suppresor", "models/cultist/hl_a/combine_suppresor/combine_suppresor_hands.mdl", 0, 00000000)


local Category = "HL:Alyx"
 
local NPC = {   Name = "Combine Suppresor", 
				Class = "npc_combine_s",
                Model = "models/cultist/hl_a/combine_suppresor/npc/combine_suppresor.mdl",
                Health = "500", 
                Category = Category }
                               
list.Set( "NPC", "npc_hla_combine_sup", NPC )

