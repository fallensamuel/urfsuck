--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/mossman.mdl")
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(true)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_BBOX)

	self.nextUse = 0

	self.receivers = {}

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end

	timer.Simple(1, function()
		if (!IsValid(self)) then
			return
		end

	    local uniqueID = self:GetQuest()
	    local info = uniqueID and cnQuests[uniqueID]

	    if (info and type(info.onEntityCreated) == "function") then
	    	info:onEntityCreated(self)
	    end
	end)
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') and activator:IsPlayer() and self.nextUse < CurTime() then
		self.nextUse = CurTime() + 0.5
		self:Interact(activator)
	end
end

function ENT:Interact(activator)
	if (!self:GetQuest()) then
		return
	end
	
	local info = cnQuests[self:GetQuest()]

	if (info) then
		if (info.customUse) then
			if (!info:customUse(activator, self)) then
				return
			end
		end

		if (!IsValid(activator.cnQuest)) then
			activator.cnQuest = self
		else
			return
		end

		net.Start("npcOpen")
			net.WriteUInt(self:EntIndex(), 14)
		net.Send(activator)
	end
end