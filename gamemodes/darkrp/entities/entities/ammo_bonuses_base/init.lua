AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('AmmoBox.Use')

function ENT:Initialize()
	self:SetModel(self.Model or "models/items/ammocrate_smg1.mdl") 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self.PlayersUseTime = {}
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

local math_ceil = math.ceil

function ENT:Use(ply)
	if self:HasAccess(ply) then
		if self.PlayersUseTime[ply] and self.PlayersUseTime[ply] > CurTime() then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math_ceil(self.PlayersUseTime[ply] - CurTime()))
			return
		end
		
		ply:GiveAmmos(3) 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('AmmoGiven'))
		
		self.PlayersUseTime[ply] = CurTime() + self.ReuseTimeout
		
		net.Start('AmmoBox.Use')
			net.WriteEntity(self)
			net.WriteFloat(self.PlayersUseTime[ply])
		net.Send(ply)
		
		--rp.Notify(ply, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.Success'))
	else
		rp.Notify(ply, NOTIFY_ERROR, rp.Term(self.Term or 'CantDoThis'))
	end
end