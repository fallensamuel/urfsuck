include('shared.lua')
local render_SetColorModulation = render.SetColorModulation
local render_SetBlend = render.SetBlend
local render_SuppressEngineLighting = render.SuppressEngineLighting
local render_SetLightingOrigin = render.SetLightingOrigin
local render_SetModelLighting = render.SetModelLighting
local render_SuppressEngineLighting = render.SuppressEngineLighting
local BOX_BOTTOM = BOX_BOTTOM
local IsValid = IsValid
local math = math

local function Draw(self)
end


function ENT:Draw()
	local pos = self:GetPos()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist < 350) then
		render_SuppressEngineLighting(true)
		render_SetLightingOrigin( self:GetPos() )
		render_SetModelLighting(BOX_BOTTOM,2,2,2)
		render_SetColorModulation(0.6, 1, 0.9)
		render_SetBlend(math.random()*0.2+0.9 - dist/500)
			self:DrawModel()
		render_SetBlend(1)
		render_SetColorModulation(1,1,1)
		render_SuppressEngineLighting(false)
	end

	if !IsValid(self.model) then
		self.model = ClientsideModel('models/props_combine/combine_intwallunit.mdl', RENDERGROUP_BOTH) 
		return
	end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)

	pos = pos - ang:Up() * Vector(3,3,3) - Vector(0,0,1)
	
	self.model:SetRenderOrigin(pos)
	self.model:SetRenderAngles(ang)
	self.model:DrawModel()

end

function ENT:OnRemove()
	timer.Remove('npc_scene'..self:EntIndex())
	SafeRemoveEntity(self.model)
end