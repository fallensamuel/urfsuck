
NPC.model = "models/Humans/Group03/Female_06.mdl"
NPC.Factions = function() return
	{ FACTION_REFUGEES, FACTION_REBEL }
end

function NPC:onMolotovExplode(client)
	client:Ignite(5)
end