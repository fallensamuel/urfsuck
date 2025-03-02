
NPC.model = "models/player/tnb/citizens/male_11_fix.mdl"
NPC.Factions = function() return
	{ FACTION_BANDITS }
end

function NPC:onEntityCreated(self)
	self:SetSkin(0)
	self:SetBodygroup(1, 7)
	self:SetBodygroup(2, 6)
	self:SetBodygroup(3, 1)
	self:SetBodygroup(4, 1) 
end