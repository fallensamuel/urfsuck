-- "gamemodes\\rp_base\\entities\\entities\\factory_storage\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base 			= "base_gmodentity";
ENT.Type 			= "anim"
ENT.PrintName		= "Factory storage"
ENT.Category 		= "Urf Factory"

ENT.Spawnable		= true
ENT.AdminOnly		= true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'StorageID')
	self:NetworkVar('Int', 1, 'Amount')
end
