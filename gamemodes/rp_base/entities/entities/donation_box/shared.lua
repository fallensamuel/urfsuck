-- "gamemodes\\rp_base\\entities\\entities\\donation_box\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Donation Box'
ENT.Author = ''
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 1, 'owning_ent')
	self:NetworkVar('Float', 0, 'money')
end