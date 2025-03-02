NPC.name = "Сиана Галлес, Сопротивление"
NPC.Factions = function() return
	{ FACTION_REFUGEES, FACTION_REBEL }
end

function NPC:onStart(isGoTo)

rp.OpenEmployerMenu(FACTION_REBEL )

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end