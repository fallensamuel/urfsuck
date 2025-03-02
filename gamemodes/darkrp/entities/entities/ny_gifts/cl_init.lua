-- "gamemodes\\darkrp\\entities\\entities\\ny_gifts\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("sh_init.lua")

function ENT:Draw()
	self:DrawModel()
	if(self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 500000) then return end
end
