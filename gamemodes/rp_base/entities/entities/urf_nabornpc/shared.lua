-- "gamemodes\\rp_base\\entities\\entities\\urf_nabornpc\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Nabor Npc'
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, 'NPCNameAndBT')
	self:NetworkVar('String', 1, 'NPCUrl')
	self:NetworkVar('String', 2, 'NPCText1')
	self:NetworkVar('String', 3, 'NPCText2')
end