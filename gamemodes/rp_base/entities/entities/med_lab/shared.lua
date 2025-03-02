ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Medic lab'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'price')
	self:NetworkVar('Entity', 1, 'owning_ent')
end