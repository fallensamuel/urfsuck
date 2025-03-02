include("shared.lua")

function ENT:Initialize()
end
function ENT:Initialize()
end

function ENT:Draw()
	local name = "Биомасса"
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 0)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 200 then
		cam.Start3D2D(Pos + Ang:Forward() * -2.4 + Ang:Up() * 3.4+ Ang:Right() * -1, Ang, 0.013)
			draw.WordBox(2, -27, -30, name, "3d2d", Color(45, 100, 100, 175), Color(255,255,255,255))
		cam.End3D2D()
	end
end

function ENT:Think()
end

