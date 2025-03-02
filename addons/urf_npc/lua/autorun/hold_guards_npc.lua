local Category = "Hold Guards"

local NPC = {	Name = "Falkreath - Friend",
				Class = "npc_citizen",
				Model = "models/player/guard_falkreath_npc.mdl",
				Health = "250",
				KeyValues = { citizentype = 4 },
				Category = Category }

list.Set( "NPC", "npc_guard_falkreath_friend", NPC )
