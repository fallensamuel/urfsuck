
NPC.model = "models/Zombie/Classic_torso.mdl"
NPC.Factions = function() return
	{ FACTION_ZOMBIE }
end

function NPC:onKill(client)
	client:Kill()
end