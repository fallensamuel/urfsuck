AddCSLuaFile()

ENT.Base = 'base_ai'
ENT.Type = 'ai'
ENT.PrintName = 'Actor'
ENT.AutomaticFrameAdvance = true
ENT.Spawnable = true
ENT.Category = '[urf] NPC'
ENT.AdminOnly	= true
if SERVER then
	function ENT:Initialize()
		self:SetModel('models/Humans/Group01/Male_04.mdl')
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:SetSolid(SOLID_NONE)
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
		self:DropToFloor()
		self:SetMaxYawSpeed(90)
	end
end