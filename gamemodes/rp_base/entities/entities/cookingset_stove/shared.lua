ENT.Type            = 'anim'
ENT.Base            = 'base_gmodentity'

ENT.PrintName		= 'Плита'
ENT.Author			= 'urf.im'
ENT.Contact			= ''
ENT.Purpose			= ''
ENT.Instructions	= ''

ENT.Spawnable       = false
ENT.Category        = '/dev/null'

function ENT:SetupDataTables()
    self:NetworkVar('Int', 0, 'Percentage');
    self:NetworkVar('String', 1, 'Recipe');
end