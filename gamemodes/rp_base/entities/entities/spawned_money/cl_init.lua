include("shared.lua")
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()
	local dist = pos:Distance(mypos)
	if dist > 250 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
	-- fancy math says we dont need to draw
	color_white.a = 250 - dist
	color_black.a = 250 - dist
	
	ang:RotateAroundAxis(Vector(0, 0, 1), 90)

	cam.Start3D2D(pos + ang:Up() * 0.2, ang, 0.015)
	draw.SimpleTextOutlined('$' .. tostring(self:Getamount()), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	cam.End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam.Start3D2D(pos + ang:Up() * 0.1, ang, 0.015)
	draw.SimpleTextOutlined('$' .. tostring(self:Getamount()), '3d2d', 0, 0, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_white)
	cam.End3D2D()
end