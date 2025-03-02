AddCSLuaFile()
DEFINE_BASECLASS("base_gmodentity")
ENT.Spawnable = true
ENT.PrintName = 'Взять Кирку'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
function ENT:Initialize()
	self:SetModel("models/pickaxe/pickaxe_w.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	self:DrawShadow(false)

	self.lastUse = 0
end


local useSound = Sound('physics/plastic/plastic_box_break1.wav')

function ENT:Use(ply, caller)
	if self.planted then return end
	if self.lastUse > CurTime() then return end

	self.lastUse = CurTime() + 1

	ply:EmitSound(useSound)
	ply:Give('weapon_pickaxe')
end

if SERVER then return end

local ipairs = ipairs
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ents_FindByClass = ents.FindByClass
ENT.Vec = Vector(0, 0, 30)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = Angle(0,0,0)
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist > 350) then return end
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
	cam_Start3D2D(pos + self.Vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(self.PrintName, '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam_Start3D2D(pos + self.Vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(self.PrintName, '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end