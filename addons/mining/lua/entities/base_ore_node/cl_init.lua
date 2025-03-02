include('shared.lua')
local ipairs = ipairs
local CurTime = CurTime
local EyeAngles = EyeAngles
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local draw_TexturedQuad = draw.TexturedQuad
local ents_FindByClass = ents.FindByClass
ENT.Vec = Vector(0, 0, 30)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

local face = Angle(0, 0, 0)
local texture = {
	texture = surface.GetTextureID('sprites/light_ignorez'),
	color	= Color(255, 220, 60),
	x 	= 0,
	y 	= 0,
	w 	= 32,
	h 	= 32
}

local pos, screenpos, ang, dist
function ENT:Draw()
	self:DrawModel()
	pos = self:GetPos()
	ang = Angle(0,0,0)
	dist = pos:Distance(LocalPlayer():GetPos())
	
	if (dist > 350) then return end
	
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
	cam_Start3D2D(pos + self.Vec + ang:Right() * 1.2, ang, 0.035)
	draw_SimpleTextOutlined(self.PrintName, '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam_Start3D2D(pos + self.Vec + ang:Right() * 1.2, ang, 0.035)
	draw_SimpleTextOutlined(self.PrintName, '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end