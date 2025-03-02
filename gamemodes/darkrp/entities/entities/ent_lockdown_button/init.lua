util.AddNetworkString('rp.LockdownMenu')

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_combine/combinebutton.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysWake()

	self.enabled = false

	self.LastUsed = 0

end

local lastUsed = 0
function ENT:Use(pl)
	if lastUsed > CurTime() then return end

	lastUsed = CurTime() + 1

	if nw.GetGlobal('lockdown') then
		GAMEMODE:UnLockdown(pl)
	elseif hook.Run('CanLockdown', pl, true) then
		net.Start('rp.LockdownMenu')
		net.Send(pl)
	end

	self:ResetSequence(1)
end

net.Receive('rp.LockdownMenu', function(len, ply)
	local id = net.ReadUInt(4)
	for k, v in pairs(ents.FindInSphere(ply:GetPos(), 400)) do
		if v:GetClass() == 'ent_lockdown_button' then
			if not hook.Run('CanLockdown', ply) then return end
			GAMEMODE:Lockdown(ply, id)
			lastUsed = 30
			return
		end
	end
end)