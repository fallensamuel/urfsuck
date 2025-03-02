NPC.name = "Изгой"
NPC.Factions = function() return
	{ FACTION_OUTLAWS }
end

function NPC:onStart(isGoTo)

rp.OpenEmployerMenu(FACTION_OUTLAWS)

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end


end