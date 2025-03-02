
NPC.model = "models/police.mdl"
NPC.Factions = function() return
	{ FACTION_COMBINE, FACTION_HELIX, FACTION_DPF }
end

function NPC:onWanted3(client)
	client:Wanted("CmR-H?", "Анти-гражданин")
	client:SetHealth("20")
end

function NPC:onWanted(client)
	client:Wanted("CmR-H?", "Анти-гражданин")
end