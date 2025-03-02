
NPC.model = "models/player/tnb/citizens/male_09_fix.mdl"
NPC.sequence = 'Sit_Chair'
NPC.Factions = function() return
	{ FACTION_OUTLAWS }
end

function NPC:onEntityCreated(self)
	self:SetBodygroup(1, 3)
end