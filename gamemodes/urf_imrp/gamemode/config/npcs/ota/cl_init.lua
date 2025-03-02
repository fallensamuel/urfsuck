NPC.name = "ИСА-03"
NPC.Factions = function() return
	{ FACTION_OTA, FACTION_GUARD, FACTION_DAP }
end

function NPC:onStart(isGoTo)
	
rp.OpenEmployerMenu({FACTION_OTA, FACTION_GUARD, FACTION_DAP})

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end