-- "gamemodes\\rp_base\\entities\\entities\\use_to_hide\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("sh_init.lua")

function ENT:Draw()
	if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS_TRIGGER then return end
	self:DrawModel()
end
