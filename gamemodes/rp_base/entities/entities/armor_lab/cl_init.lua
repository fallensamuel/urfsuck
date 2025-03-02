include('shared.lua')

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

local tr = translates
local cached
if tr then
	cached = {
		tr.Get( 'Броня' ), 
		tr.Get( 'Цена' ), 
	}
else
	cached = {
		'Броня', 
		'Цена', 
	}
end

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	local alpha = 500 - dist

	color_white.a = alpha
	color_black.a = alpha

	if dist > 500 then return end

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	
	cam.Start3D2D(pos + ang:Right() * -26 + ang:Up() * 10, ang, 0.05)
		draw.SimpleTextOutlined(cached[1], '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined(cached[2] .. ': ' .. self:Getprice(), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)			
	cam.End3D2D()
end