local CurTime = CurTime

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = 'models/hunter/plates/plate2x4.mdl'
ENT.LeftOffset = Vector(-50, 55, 2)
ENT.RightOffset = Vector(50, 55, 2)

ENT.EnableMaterial = 'cyberpunkurfim/neutralshield'
ENT.DisableMaterial = 'sprites/heatwave'
ENT.isForceField = true
ENT.invert = false
ENT.delay = 15

local sound = Sound("ambient/machines/combine_shield_touch_loop1.wav")
local activate = Sound('buttons/combine_button3.wav')
local deactivate = Sound('buttons/combine_button5.wav')

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMaterial('cyberpunkurfim/neutralshield')

	self:SetColor(Color(218, 165, 32))

	self.enabled = self.invert

	self.lastUsed = 0
	self.nextUse = 0


	self.Dummies = {}

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local dummy = ents.Create("prop_dynamic")
	dummy:SetModel('models/props_combine/combine_fence01a.mdl')
	dummy:SafeSetPos(self:LocalToWorld(self.LeftOffset))
	dummy:SetAngles(ang)
	dummy:Spawn()
	dummy:SetParent(self)
	dummy:SetColor(Color(243,218,150))
	dummy.PhysgunDisabled = true
	self:DeleteOnRemove(dummy)
	table.insert(self.Dummies, dummy)

	local dummy = ents.Create("prop_dynamic")
	dummy:SetModel('models/props_combine/combine_fence01b.mdl')
	dummy:SafeSetPos(self:LocalToWorld(self.RightOffset))
	dummy:SetAngles(ang)
	dummy:Spawn()
	dummy:SetParent(self)
	dummy:SetColor(Color(243,218,150))
	dummy.PhysgunDisabled = true
	self:DeleteOnRemove(dummy)
	table.insert(self.Dummies, dummy)

	self:GetPhysicsObject():EnableMotion(false)

	self:SetCustomCollisionCheck(true)
	
	if self.invert then
		self:Disable()
	end
end

function ENT:StartTouch(entity)
	--if (!self.buzzer) then
	--	self.buzzer = CreateSound(entity, sound)
	--	self.buzzer:Play()
	--	self.buzzer:ChangeVolume(0.8, 0)
	--elseif self.enabled then
	--	self.buzzer:ChangeVolume(0.8, 0.5)
	--	self.buzzer:Play()
	--end

	self.entities = (self.entities or 0) + 1
end

function ENT:EndTouch(entity)
	self.entities = math.max((self.entities or 0) - 1, 0)

	--if (self.buzzer and self.entities == 0) then
	--	self.buzzer:FadeOut(0.5)
	--end
end

function ENT:OnRemove()
	--if (self.buzzer) then
	--	self.buzzer:Stop()
	--	self.buzzer = nil
	--end
end


function ENT:Enable()
	for k, v in pairs(self.Dummies) do
		v:SetSkin(0)
	end
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetMaterial(self.EnableMaterial)
	self.enabled = true

	self:EmitSound(activate)
end

function ENT:Disable()
	for k, v in pairs(self.Dummies) do
		v:SetSkin(1)
	end
	self:SetMaterial(self.DisableMaterial)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.enabled = false
	
	--if (self.buzzer) then
	--	self.buzzer:FadeOut(0.5)
	--end

	self:EmitSound(deactivate)
end

function ENT:Think()
	if self.lastUsed && self.lastUsed < CurTime() then
		if self.invert then
			if self.enabled then
				self:Disable()
				self.lastUsed = nil
			end
		elseif !self.enabled then
			self:Enable()
			self.lastUsed = nil
		end
	end

	self:CollisionRulesChanged()
	
	self:NextThink( CurTime() + 5 )
	return true
end

function ENT:Use(activator)
	if (self.nextUse < CurTime()) then
		self.nextUse = CurTime() + 1.5
	else
		return
	end

	self.lastUsed = CurTime() + self.delay

	if (activator:IsCombineOrDisguised() || activator:IsCWU()) then
		if self.enabled then
			self:Disable()
		else
			self:Enable()
		end
	else
		self:EmitSound(activate)
	end
end

hook('InitPostEntity', function()
	for k, v in pairs(rp.cfg.Forcefields && rp.cfg.Forcefields[game.GetMap()] or {}) do
		local ent = ents.Create('combine_forcefield'..((v[1] != 'normal' && v[1]) || ''))
		ent:SafeSetPos(v[2])
		ent:SetAngles(v[3])
		ent:Spawn()
		if v[4] then
			ent.invert = v[4]	
		end
		if v[5] then
			ent.delay = v[5]
		end
	end
end)