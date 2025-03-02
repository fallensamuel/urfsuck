-- "gamemodes\\darkrp\\entities\\entities\\cw_vendingmachine\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ENT.Type = "anim";
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AdminOnly = true

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'State')
end;