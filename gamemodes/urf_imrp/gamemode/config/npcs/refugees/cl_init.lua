NPC.name = "Бездомный Боб"
NPC.Factions = function() return
	{ FACTION_REFUGEES }
end

function NPC:onStart(isGoTo)

rp.OpenEmployerMenu(FACTION_REFUGEES )

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end