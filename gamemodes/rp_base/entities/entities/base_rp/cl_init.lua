-- "gamemodes\\rp_base\\entities\\entities\\base_rp\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.include_sh'shared.lua'

function ENT:Draw()
	self:DrawModel()

	if self.Draw3D2D and self:InSight() then
		self:Draw3D2D()
	end
end