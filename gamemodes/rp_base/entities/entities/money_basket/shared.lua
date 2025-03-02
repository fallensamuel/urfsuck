-- "gamemodes\\rp_base\\entities\\entities\\money_basket\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.PrintName = 'Money Basket'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.Category = 'RP'
ENT.MaxHealth = 100

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('Entity', 1, 'owning_ent')
	self:NetworkVar('Float', 0, 'money')
end