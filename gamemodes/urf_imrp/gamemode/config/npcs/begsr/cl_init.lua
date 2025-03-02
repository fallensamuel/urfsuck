NPC.name = "Гэри Смит, Сбежавщий ГСР"
NPC.Factions = function() return
	{ FACTION_CWU }
end

function NPC:onStart(isGoTo)
rp.OpenEmployerMenu(FACTION_CWU)

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end
end