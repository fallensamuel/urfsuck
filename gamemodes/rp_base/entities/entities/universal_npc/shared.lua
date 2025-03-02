ENT.Base            = "vendor_npc"
ENT.PrintName		= "Universal NPC"
ENT.Author			= "urf.im Beelzebub"
ENT.Contact			= "beelzebub@incredible-gmod.ru"
ENT.Category        = "NPC's"
ENT.Spawnable       = true
ENT.AdminOnly 		= true

ENT.AutomaticFrameAdvance = true
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "UniversalIndex")
end

function ENT:GetObject()
	return rp.UniversalNPCs[ self:GetUniversalIndex() ] or {}
end

function ENT:GetVendorName()
	return self:GetObject().Vendor
end