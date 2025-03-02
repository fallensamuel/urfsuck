
NPC.model = "models/hunter/blocks/cube05x05x05.mdl"
NPC.Factions = function() return
	{ FACTION_OTA, FACTION_GUARD, FACTION_DAP }
end

function NPC:onEntityCreated(self)
	self:SetNoDraw(true)
end

function NPC:onWanted(client)
	client:Wanted("ИСА-03", "Дефект")
end