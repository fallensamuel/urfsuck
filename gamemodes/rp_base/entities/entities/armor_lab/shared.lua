ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Armor lab'
ENT.Author 		= 'aStonedPenguin'
ENT.Spawnable 	= false

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'price')
end

rp.AddTerm("ArmorLabZeroMaxArmor", "Вы достигли максимального количества брони!")