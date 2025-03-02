include("shared.lua")

ENT.mins, ENT.maxs = Vector(16,-135,-30), Vector(50, 135, 165)


--function ENT:Draw()
--		self:DrawModel()
--		local mins, maxs = Vector(16,-135,-30), Vector(50, 135, 165)
--		mins:Rotate(self:GetAngles())
--		maxs:Rotate(self:GetAngles())
--		
--		local pos, ang = self:GetPos(), self:GetAngles()
--
--		render.DrawWireframeBox( pos, ang, mins, maxs, Color(100, 255, 200) )
--		render.DrawWireframeBox( pos, Angle(0,0,0), mins, maxs, Color(255, 0, 0) )
--end