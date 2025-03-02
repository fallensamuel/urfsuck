include("shared.lua")

function ENT:Initialize()
end
function ENT:Initialize()
end

function ENT:Draw()
	local name = "Катализатор"
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos+ Ang:Forward() * -3.1 + Ang:Up() * 3.2, Ang, 0.012)
			draw.WordBox(2, -45, -10, name, "3d2d", Color(75, 0, 130), Color(255,255,255,255))
		cam.End3D2D()
	end
end

function ENT:Think()
end


