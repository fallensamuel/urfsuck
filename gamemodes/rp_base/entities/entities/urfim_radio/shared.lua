ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName		= "Radio"
ENT.Author			= "urf.im & Beelzebub"
ENT.Contact			= "urf.im/page/legal"
ENT.Category        = "Media"
ENT.Spawnable       = true
ENT.IsUrfRadio 		= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "SongID")
	self:NetworkVar("Int", 1, "StartTime")
end