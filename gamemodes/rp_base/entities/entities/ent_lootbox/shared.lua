-- "gamemodes\\rp_base\\entities\\entities\\ent_lootbox\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Lootbox'
ENT.Author 		= 'urf.im'
ENT.Category 	= 'RP'

ENT.Spawnable 	= true
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true

ENT.TimeToRemove = 15;

function ENT:SetupDataTables()
	self:NetworkVar('Float', 0, 'RouletteLength')
	self:NetworkVar('Float', 1, 'RouletteTime')
	self:NetworkVar('Int', 0, 'Reward')
	self:NetworkVar('String', 0, 'BoxUID')
	self:NetworkVar('Bool', 0, 'Ending')
end
