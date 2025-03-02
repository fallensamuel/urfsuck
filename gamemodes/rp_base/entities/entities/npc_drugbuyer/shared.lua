--ENT.Base = 'base_ai'
--ENT.Type = 'ai'
ENT.Base = 'base_entity'
ENT.PrintName = 'Drug Buyer'
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = false
ENT.Category = 'RP NPCs'

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end