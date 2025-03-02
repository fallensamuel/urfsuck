include("sh_init.lua")

function ENT:Draw()
	if self:GetCollisionGroup() == COLLISION_GROUP_DEBRIS_TRIGGER then return end
	self:DrawModel()
end
