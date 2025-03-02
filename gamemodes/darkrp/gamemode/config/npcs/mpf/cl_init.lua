NPC.name = "CmR-H"
NPC.Factions = function() return
	{ FACTION_COMBINE, FACTION_HELIX, FACTION_DPF }
end

function NPC:onStart(isGoTo)
	
rp.OpenEmployerMenu({FACTION_COMBINE,FACTION_HELIX, FACTION_DPF})

if IsValid(cnPanels.quest) then cnPanels.quest:Remove() end

end