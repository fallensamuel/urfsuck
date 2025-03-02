AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Scanner Control Panel"
ENT.Spawnable = true
ENT.AdminOnly	= true
ENT.Category = "Half-Life Alyx RP"
local CurTime = CurTime

if SERVER then
	function ENT:Initialize()
		self:SetModel('models/props_combine/combine_interface001.mdl')
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:GetPhysicsObject():EnableMotion(false)
	end

	print(0)

	local lastUse = 0
	function ENT:Use(ply)
		print(1)
		print(lastUse < CurTime())
		if ply:IsCombine() && lastUse < CurTime() then
			lastUse = CurTime() + 1
			createScanner(ply)
		end
	end
else
	local LocalPlayer = LocalPlayer
	local Color = Color
	local cam = cam
	local draw = draw
	local Angle = Angle
	local Vector = Vector
	local vec = Vector(0,0,30)

	function ENT:Draw()
		self:DrawModel()
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local mypos = LocalPlayer():GetPos()
		local dist = pos:Distance(mypos)
		if dist > 500 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
		-- fancy math says we dont need to draw
		ang:RotateAroundAxis(ang:Forward(), 90)
		local TextAng = ang
		pos = pos + vec
		color_white.a = 500 - dist
		color_black.a = 500 - dist
		TextAng:RotateAroundAxis(TextAng:Right(), math.sin(CurTime() * math.pi) * -45)
		cam.Start3D2D(pos, ang, 0.070)
		draw.SimpleTextOutlined('Панель контроля', '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam.End3D2D()
		ang:RotateAroundAxis(ang:Right(), 180)
		cam.Start3D2D(pos, ang, 0.070)
		draw.SimpleTextOutlined('Панель контроля', '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam.End3D2D()
	end
end