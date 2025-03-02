ENT.Type = 'anim'
ENT.PrintName = 'Picture'
ENT.Author = 'aStonedPenguin'
ENT.Base = 'base_anim'
ENT.Category = 'RP'
ENT.Spawnable = true

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('String', 1, 'URL')
end