-- "gamemodes\\darkrp\\entities\\entities\\armor_lab\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Armor lab'
ENT.Author 		= 'aStonedPenguin'
ENT.Spawnable 	= false

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'price')
end