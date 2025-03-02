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
local vec = Vector(0, 0, 46)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)


function ENT:Initialize()	

end;

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	cam.Start3D2D(Pos + Ang:Up() * 16.5 + Ang:Forward() * -4 + Ang:Right() * 8, Ang, 0.06)
		draw.WordBox(8, -90, -150, self:GetNWInt("ration").."/10", "3d2d", Color(45, 100, 45, 175), Color(255,255,255,255))
	cam.End3D2D()

end;


