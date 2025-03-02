NPC.name = "Гэри Смит, ГСР"
NPC.Factions = function() return
	{ FACTION_CWU }
end

function NPC:onStart(isGoTo)
    
rp.OpenEmployerMenu(FACTION_CWU)

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end