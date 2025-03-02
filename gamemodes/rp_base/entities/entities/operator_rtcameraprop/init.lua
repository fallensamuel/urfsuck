AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.RemoveOnJobChange = true

local CAMERA_MODEL = "models/dav0r/camera.mdl"

--[[---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------]]
function ENT:Initialize()
	self:SetModel(CAMERA_MODEL)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	-- Don't collide with the player
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	local phys = self:GetPhysicsObject()

	if (phys:IsValid()) then
		phys:Sleep()
	end

	timer.Simple(0, function()
		self:CPPISetOwner(self.ItemOwner)
	end)
end

--[[---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------]]
function ENT:OnTakeDamage(dmginfo)
	self:TakePhysicsDamage(dmginfo)
end

--[[---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------]]
function ENT:OnRemove()
	-- Pick a random camera to use if this one gets removed
	if (RenderTargetCameraProp ~= self.Entity) then return end
	local Cameras = ents.FindByClass("gmod_rtcameraprop")
	if (#Cameras == 0) then return end
	local CameraIdx = math.random(#Cameras)

	if (CameraIdx == self.Entity) then
		if (#Cameras ~= 0) then return end
		self:OnRemove()
	end

	local Camera = Cameras[CameraIdx]
	UpdateRenderTarget(Camera)
end

function ENT:Use()
	UpdateRenderTarget(self)
end