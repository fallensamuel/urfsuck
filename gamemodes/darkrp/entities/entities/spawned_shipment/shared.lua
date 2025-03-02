-- "gamemodes\\darkrp\\entities\\entities\\spawned_shipment\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_rp'
ENT.PrintName = 'Shipment'
ENT.Author = 'philxyz'
ENT.Spawnable = true
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'contents')
	self:NetworkVar('Int', 1, 'count')
	self:NetworkVar('Entity', 1, 'gunModel')
end

rp.inv.Wl['spawned_shipment'] = 'Shipment'