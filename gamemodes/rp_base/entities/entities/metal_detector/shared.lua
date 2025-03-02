-- "gamemodes\\rp_base\\entities\\entities\\metal_detector\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Metal Detector'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.Category = 'RP'
ENT.MaxHealth = 150

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Mode')
end