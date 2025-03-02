-- "gamemodes\\darkrp\\entities\\entities\\armor_lab\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

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
	ang:RotateAroundAxis(ang:Right(), -180)
	local TextAng = ang
	TextAng:RotateAroundAxis(TextAng:Right(), math.sin(CurTime() * math.pi) * -10)
	cam.Start3D2D(pos + ang:Right() * -28 + ang:Up() * 1 + ang:Forward() * 1, ang, 0.05)
		draw.SimpleTextOutlined('Броня', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined('Цена: ' .. rp.FormatMoney(self:Getprice()), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)			
	cam.End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam.Start3D2D(pos + ang:Right() * -28 + ang:Up() * 1 + ang:Forward() * -1, ang, 0.05)
		draw.SimpleTextOutlined('Броня', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined('Цена: ' .. rp.FormatMoney(self:Getprice()), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)			
	cam.End3D2D()
end