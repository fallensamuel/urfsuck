ENT.Base        = "base_entity";
ENT.PrintName	= "ItemVendor NPC"
ENT.Author		= "urf.im Beelzebub"
ENT.Contact		= "beelzebub@incredible-gmod.ru"
ENT.Category  	= "NPC's"
ENT.Spawnable 	= true
ENT.AdminOnly 	= true

ENT.AutomaticFrameAdvance = true
function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "VendorIndex")
end

function ENT:GetObject()
	return rp.VendorItemsNPCS[self:GetVendorIndex()] or {}
end