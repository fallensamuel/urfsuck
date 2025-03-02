include("shared.lua")

function ENT:Initialize()
end

surface.CreateFont( "NameFont", {
	font = "Roboto Light", 
	extended = false,
	size = 25,
	weight = 500,
	extended = true
} )

surface.CreateFont( "smalldesc", {
	font = "Roboto Light", 
	extended = false,
	size = 20,
	weight = 500,
	extended = true
} )

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Up(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 0.3, Ang, 0.11)
		draw.WordBox(2, -100, -30, "Рацион", "NameFont", Color(140, 0, 0, 100), Color(255,255,255,255))
		--draw.WordBox(2, -80, 18, "Отнеси его в коробку", "smalldesc", Color(140, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
end

function ENT:Think()
end

