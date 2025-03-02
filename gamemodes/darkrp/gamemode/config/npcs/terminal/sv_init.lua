NPC.model 	   = "models/hunter/blocks/cube075x075x075.mdl";
NPC.TerminalID = 1;
NPC.Entity     = NULL;

function NPC:onEntityCreated( ent )
	self.Entity = ent;
	ent:SetNoDraw( true );
end

function NPC:FindNewSelf()
	for k, v in pairs(ents.FindByClass("cn_npc")) do
		if v:GetQuest() == self.uniqueID then
			self.Entity = v
			break
		end
	end
end

function NPC:onRequestSupervisor( client )
	if !IsValid(self.Entity) then
		self:FindNewSelf()
	end
	if !IsValid(client) 									then return end
	if client:GetPos():Distance(self.Entity:GetPos()) > 192 then return end

	rp.EnterSupervisorMode( self.TerminalID, client );
end