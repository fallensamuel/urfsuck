-- "gamemodes\\rp_base\\entities\\entities\\npc_pimp.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Type = "anim"
ENT.Base = "base_anim"

if CLIENT then
	local ipairs = ipairs
	local CurTime = CurTime
	local LocalPlayer = LocalPlayer
	local math_sin = math.sin
	local math_pi = math.pi
	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local draw_SimpleTextOutlined = draw.SimpleTextOutlined
	local ents_FindByClass = ents.FindByClass
	local vec = Vector(0, 0, 82)
	local color_white = Color(255, 255, 255)
	local color_black = Color(0, 0, 0)

	local tr = translates
	local cached
		if tr then
			cached = {
				tr.Get( 'Ганс' ), 
				tr.Get( 'Алекс' ), 
				tr.Get( 'Валенхаинс' ), 
			}
		else
			cached = {
				'Ганс', 
				'Алекс', 
				'Валенхаинс', 
			}
		end
	
	
	ENT.PrintName = "Механик"
	ENT.AutomaticFrameAdvance = true
	ENT.FaceAngle = angle_zero

	local function Draw(self)
		local pos = self:GetPos()
		local ang = self:GetAngles()
		local dist = pos:Distance(LocalPlayer():GetPos())
		if (dist > 350) then return end
		if !self.RandomName then
			self.RandomName = table.Random(rp.cfg.PimpRandomNames or {cached[1], cached[2], cached[3]})
		end
		local t = self.PrintName..' '..self.RandomName
		color_white.a = 350 - dist
		color_black.a = 350 - dist
		ang:RotateAroundAxis(ang:Forward(), 90)
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
		cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
		draw_SimpleTextOutlined(t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam_End3D2D()
		ang:RotateAroundAxis(ang:Right(), 180)
		cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
		draw_SimpleTextOutlined(t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam_End3D2D()
	end

	hook.Add('PostDrawTranslucentRenderables', function()
		for k, v in ipairs(ents_FindByClass('npc_pimp')) do
			Draw(v)
		end
	end)

	function ENT:GetPlayerColor()
		return Vector(1, 0.5, 0)
	end

	function ENT:StopScene()
		if !self.Scene then return end
		self:ClearPoseParameters()
		self:SetPos(self.BasePos)
		self:SetAngles(self.BaseAng)
		self.BasePos = nil
		self.BaseAng = nil
		self.Scene = nil
		self:ResetSequence("idle_all_02")
		local rh, lh = self:LookupBone("ValveBiped.Bip01_R_Hand"), self:LookupBone("ValveBiped.Bip01_L_Hand")

		self:ManipulateBoneAngles(rh, angle_zero)
		self:ManipulateBoneAngles(lh, angle_zero)
	end

	function ENT:StartScene(pos, ang)
		self.Scene = true
		self.BasePos = self:GetPos()
		self.BaseAng = self:GetAngles()

		self:ResetSequence("idle_dual")
		self:ClearPoseParameters()
		local tr = util.TraceLine({
				start = pos + Vector(0, 0, 100),
				endpos = pos - Vector(0, 0, 300),
				mask = MASK_SOLID_BRUSHONLY
			})

		self:SetPos(tr.HitPos)
		self:SetAngles(ang + Angle(0, 85, 0))
		self:SetPoseParameter("face_pitch", 45)
		self:SetPoseParameter("aim_pitch", 45)
		local rh, lh = self:LookupBone("ValveBiped.Bip01_R_Hand"), self:LookupBone("ValveBiped.Bip01_L_Hand")

		self:ManipulateBoneAngles(rh, Angle(25, 0, -90))
		self:ManipulateBoneAngles(lh, Angle(-30, 0, 90))
	end

	function ENT:Think()
		if self.Scene then
			return
		end

		local att = self:GetAttachment(self:LookupAttachment("eyes"))
		if !att then return end
		local pl = LocalPlayer()
		local pos = att.Pos
		if pl:EyePos():DistToSqr(pos) > 90000 then return end
		local lookat = pl:EyePos()
		local ang = (lookat - pos):Angle() - self:GetAngles()
		ang:Normalize()

		self.FaceAngle = LerpAngle(0.099, self.FaceAngle, ang)
		self.FaceAngle.y = math.Clamp(self.FaceAngle.y, -90, 90)
		self.FaceAngle.p = math.Clamp(self.FaceAngle.p, -90, 90)
		self.FaceAngle.r = math.Clamp(self.FaceAngle.p, -90, 90)
		ang = self.FaceAngle

		self:ClearPoseParameters()
		self:SetPoseParameter("head_yaw", ang.y)
		self:SetPoseParameter("head_pitch", ang.p)

		local ang = ang / 3
		local pos = ang:Forward() * 100
		self:SetEyeTarget(pos)
		self:NextThink(CurTime() + 0.11)
		return true
	end

	function ENT:IsACarNear(pl)
		local t = ents.FindInSphere(self:GetPos(), 250)
		for _, ent in pairs(t) do
			if !simfphys.IsCar(ent) then continue end
			if !PIMP.GetByEntity(ent) then continue end
			if !PIMP.IsCarOwned(ent, pl) then continue end
			return ent
		end
	end

	function ENT:Interract(pl)
		local ent = self:IsACarNear(pl)
		if ent then
			PIMP.DropMenu(ent, self)
		else
			PIMP.DropCallMenu()
		end
	end
end

function ENT:Initialize( ... )
	self:SetModel("models/player/group02/male_04.mdl")
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionBounds(Vector(-20, -20, 0),Vector(20, 20, 80))
	self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
	self:ResetSequence("idle_all_02")

	if CLIENT then
		self:SetupBones()
		self:InvalidateBoneCache()
	else
		self:SetLagCompensated(false)
	end
end
--[[
list.Set("NPC", "npc_pimp", {
	Name = "Механик",
	Class = "npc_pimp",
	Category = "URF"
})]]
