-- "gamemodes\\rp_base\\entities\\entities\\factory_item\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base 			= "base_gmodentity";
ENT.Type 			= "anim"
ENT.PrintName		= "Factory item"
ENT.Category 		= "Urf Factory"

ENT.IsFactoryItem 	= true

ENT.Spawnable		= true
ENT.AdminOnly		= true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'ComponentUID')
	self:NetworkVar('Int', 1, 'CurMerges')
	self:NetworkVar('Int', 2, 'MaxMerges')
	self:NetworkVar('Entity', 0, 'PickedPlayer')
end
