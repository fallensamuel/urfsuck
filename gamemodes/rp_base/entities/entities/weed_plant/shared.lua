-- "gamemodes\\rp_base\\entities\\entities\\weed_plant\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Growing Weed Plant'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 1, 'owning_ent')
end