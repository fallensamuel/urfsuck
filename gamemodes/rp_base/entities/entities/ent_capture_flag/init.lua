AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('Capture.FlagUse')

function ENT:Initialize()
	self:SetModel("models/props_rp/flagpole.mdl") 
	self:SetUseType(SIMPLE_USE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	
	timer.Simple(1, function()
		if not IsValid(self) then return print('ERROR! Invalid capture flag') end
		
		local trace = util.QuickTrace(self:GetPos(), Vector(0, 0, -1000), self)
		self:SetPos(trace.HitPos)
	end)
	
	self:ResetSequence('idle_middle')
	
	self:SetCapturePoint(1)
	self:SetFlagMaterial('models/shiny')
end

function ENT:Use(ply)
	local point = rp.Capture.Points[self:GetCapturePoint()]
	
	if point.isOrg and not ply:CanCapture() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('Capture.WrongJob')) 
		return
	end
	
	if 	not point or 
		point.isWar or 
		point.isOrg and ply:GetOrg() and point.owner == ply:GetOrg() or 
		not point.isOrg and point.owner == ply:GetAlliance() then return end
	
	net.Start('Capture.FlagUse')
		net.WriteUInt(self:GetCapturePoint(), 7)
	net.Send(ply)
end
