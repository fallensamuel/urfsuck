NPC.name = "Отверженный"
NPC.Factions = function() return
	{ FACTION_BANDITS }
end

function NPC:onStart(isGoTo)

rp.OpenEmployerMenu(FACTION_BANDITS)

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end