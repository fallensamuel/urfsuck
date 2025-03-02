-- "gamemodes\\rp_base\\entities\\entities\\vendor_npc\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base        = "base_entity";
ENT.PrintName	= "Vendor NPC"
ENT.Author		= "urf.im Beelzebub"
ENT.Contact		= "beelzebub@incredible-gmod.ru"
ENT.Category  	= "NPC's"
ENT.Spawnable 	= true
ENT.AdminOnly 	= true

ENT.AutomaticFrameAdvance = true
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "VendorName")
end
