ENT.Type 		= 'anim'
ENT.Base 		= 'base_gmodentity'
ENT.PrintName 	= 'Магазин'
ENT.Spawnable 	= true
ENT.AdminOnly 	= true
ENT.Category 	= 'RP'

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 0, 'OwnerPly')
	self:NetworkVar('Int', 0, 'InvID')
	--self:NetworkVar('String', 0, 'URL')
	self:NetworkVar('String', 1, 'Header')
end
