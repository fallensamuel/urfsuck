-- "gamemodes\\rp_base\\entities\\entities\\ent_picture\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.PrintName = 'Picture'
ENT.Author = 'aStonedPenguin'
ENT.Base = 'base_anim'
ENT.Category = 'RP'
ENT.Spawnable = true

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('String', 1, 'URL')
end