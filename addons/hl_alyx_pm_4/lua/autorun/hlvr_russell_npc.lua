local Category = "Half-Life: Alyx"
local NPC = {
		 		Name = "Friendly Russell", 
				Class = "npc_citizen",
				KeyValues = { citizentype = 4 },
				Model = "models/hlvr/characters/russell/npc/russell_citizen.mdl",
				Health = "100",
				Category = Category	
		}
list.Set( "NPC", "npc_friendly_hlvr_russell", NPC )

local Category = "Half-Life: Alyx"
local NPC = {
		 		Name = "Hostile Russell", 
				Class = "npc_combine_s",
				KeyValues = { citizentype = 4 },
				Model = "models/hlvr/characters/russell/npc/russell_combine.mdl",
				Health = "100",
				Category = Category	
		}
list.Set( "NPC", "npc_hostile_hlvr_russell", NPC )