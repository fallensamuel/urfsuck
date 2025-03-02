NPC.name = "Зомби"
NPC.Factions = function() return
	{ FACTION_ZOMBIE }
end

function NPC:onStart(isGoTo)

rp.OpenEmployerMenu(FACTION_ZOMBIE )

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end