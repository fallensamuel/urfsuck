ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.PrintName = 'Money Printer'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = 'RP'

ENT.AdminOnly = true

ENT.MaxHP = 100

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 1, 'owning_ent')
	self:NetworkVar('Int', 1, 'Ink')
	self:NetworkVar('Int', 2, 'MaxInk')
	self:NetworkVar('Int', 3, 'HP')
	self:NetworkVar('Int', 4, 'LastPrint')
end