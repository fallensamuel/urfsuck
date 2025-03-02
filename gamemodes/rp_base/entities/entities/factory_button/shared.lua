-- "gamemodes\\rp_base\\entities\\entities\\factory_button\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base 			= "base_gmodentity";
ENT.Type 			= "anim"
ENT.PrintName		= "Factory button"
ENT.Category 		= "Urf Factory"

ENT.Spawnable		= true
ENT.AdminOnly		= true

function ENT:SetupDataTables()
	self:NetworkVar('Bool', 0, 'IsBusy')
	self:NetworkVar('Int', 0, 'ButtonID')
	self:NetworkVar('Entity', 0, 'ResultEnt')
end
