AddCSLuaFile()


local random = math.random

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Stash"
ENT.Spawnable = true

if SERVER then
	ENT.respawnTime = 0
	
	local function spawnStash(index)
		local t = rp.cfg.Stashes[game.GetMap()][index]

		local ent = ents.Create('ent_stash')
		ent:SetPos(t.pos)
		ent:SetModel(t.mdl)
		ent:SetAngles(t.ang)
		ent:Spawn()
		ent.index = index
		ent.respawnTime = math.random(t.respawn[1], t.respawn[2])
	end

	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self:GetPhysicsObject():EnableMotion(false)

		self:PrecacheGibs()
	end

	function ENT:Use()
		if self.used then return end

		self.used = true
		
		local t = table.Random(rp.cfg.StashContent)
		local min, max = t[3], math.random() * t[4]

		for i=min, min + max do
			local ent = ents.Create('spawned_weapon')
			ent:SafeSetPos(self:GetPos() + Vector(0,0, min * 10))
			ent.weaponclass = t[2]
			ent:SetModel(t[1])
			ent:Spawn()
		end

		self:GibBreakServer(Vector(0,0,0))

		self:Remove()

		local index = self.index
		if !self.index then return end
		timer.Simple(self.respawnTime, function()
			spawnStash(index)
		end)
	end

	hook.Add("InitPostEntity", function()
		if !rp.cfg.Stashes[game.GetMap()] then return end
		for k, v in pairs(rp.cfg.Stashes[game.GetMap()]) do
			spawnStash(k)
		end
	end)
else
	local ipairs = ipairs
	local CurTime = CurTime
	local LocalPlayer = LocalPlayer
	local math_sin = math.sin
	local math_pi = math.pi
	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local draw_SimpleTextOutlined = draw.SimpleTextOutlined
	local ents_FindByClass = ents.FindByClass
	local vec = Vector(0, 0, 30)
	local color_white = Color(255, 248, 63)
	local color_black = Color(0, 0, 0)

	function ENT:Draw()
		self:DrawModel()

		local pos = self:GetPos()
		local ang = self:GetAngles()
		local dist = pos:Distance(LocalPlayer():GetPos())
		if (dist > 350) then return end
		local t = 'Схрон'
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

end