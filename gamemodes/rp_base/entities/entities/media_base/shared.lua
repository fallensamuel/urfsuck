-- "gamemodes\\rp_base\\entities\\entities\\media_base\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, 'URL')
	self:NetworkVar('String', 1, 'Title')
	self:NetworkVar('Int', 0, 'Start')
	self:NetworkVar('Int', 1, 'Time')
end