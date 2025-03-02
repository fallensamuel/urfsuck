include("shared.lua");

include("shared.lua")
local ipairs = ipairs
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ents_FindByClass = ents.FindByClass
local vec = Vector(0, 0, 70)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

surface.CreateFont("Comp1", {
	font = "Arial",
	size = 300,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
});

function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = Angle(0, 0, 0)
	ang.yaw = self:GetAngles().yaw
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist > 350) then return end
	color_white.a = 350 - dist
	color_black.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45 )
	cam.Start3D2D(pos + vec + ang:Right() * 29.2, ang, 0.065)
		draw.SimpleTextOutlined( "Инсинератор", "3d2d", -3, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	cam.End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam.Start3D2D(pos + vec + ang:Right() * 29.2, ang, 0.065)
		draw.SimpleTextOutlined( "Инсинератор", "3d2d", -3, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	cam.End3D2D()
end;

