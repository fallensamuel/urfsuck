AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('DisguiseMenu')
util.AddNetworkString('DisguiseToServer')
ENT.SeizeReward = 25
ENT.WantReason = 'Black Market Item (Disguise)'

function ENT:Initialize()
	self:SetModel('models/props_c17/SuitCase_Passenger_Physics.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()

	self.Faction = 1
end

function ENT:Use(pl)
	if pl:IsBanned() or pl.ZombieInfected then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouCantDisguise'))
		return 
	end

	--if pl:IsCombine() then return end

	if pl:GetJobTable().CantUseDisguise then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouCantDisguise'))
		return 
	end

	if pl:IsDisguised() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('AlreadyDisguised'))

		return
	end

	net.Start('DisguiseMenu')
		net.WriteEntity(self)
		net.WriteInt(self.Faction, 8)
	net.Send(pl)
	pl.ValidDisguiseEnt = self
end

net.Receive('DisguiseToServer', function(len, pl)
	local ent = net.ReadEntity()
	if not IsValid(ent) or ent ~= pl.ValidDisguiseEnt then return end
	
	local t = net.ReadUInt(9)
	
	if not rp.teams[t].faction or ent.Faction ~= rp.teams[t].faction then return end
	
	if pl.ZombieInfected or pl:GetJobTable().CantUseDisguise then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouCantDisguise'))
		return 
	end
	
	if !pl:CanTeam(rp.TeamByID(t)) then return end
	--You've been naughty
	if (pl:Team() == TEAM_ADMIN) then return end
	
	if IsValid(ent) then
		ent:Remove()
		pl:Disguise(t)
		pl.ValidDisguiseEnt = nil
	end
end)

hook.Add('PlayerDeath', function(ply, inf, attacker)
	if ply:IsPlayer() && (ply:IsDisguised() or ply:IsVortDisguised()) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DisguiseWorn'))
		GAMEMODE:PlayerSetModel(ply)
		ply:UnDisguise()
		if target:IsVortDisguised() then
			ply:GetNetVar('VortDisguise', false)
		end
	end
end)


local DisguiseTakeDMG = function(target, dmginfo)
	if not IsValid(target) then return end

	if target:IsPlayer() and (target != dmginfo:GetAttacker()) and (target:IsDisguised() or target:IsVortDisguised()) then
		if target.DisguiseDamage == nil then target.DisguiseDamage = 0 end
		if target.DisguiseDamage >= 50 then
			rp.Notify(target, NOTIFY_ERROR, rp.Term('DisguiseWorn'))
			GAMEMODE:PlayerSetModel(target)
			target:UnDisguise()
			if target:IsVortDisguised() then
				target:GetNetVar('VortDisguise', false)
			end
			target.DisguiseDamage = 0
		else
			target.DisguiseDamage = target.DisguiseDamage + dmginfo:GetDamage()
			if !timer.Exists("DisguiseDamage"..target:SteamID64()) then
				timer.Create("DisguiseDamage"..target:SteamID64(), 20, 1, function()
					if !IsValid(target) then return end
					target.DisguiseDamage = 0
				end)
			end
		end
	end
end

hook.Add('EntityTakeDamage', function(target, dmginfo)
	DisguiseTakeDMG(target, dmginfo)	
	DisguiseTakeDMG(dmginfo:GetAttacker(), dmginfo)	
end)



util.AddNetworkString("rp.VortigontDisguise")
util.AddNetworkString("rp.UnVortigontDisguise")
if !isWhiteForest then
	net.Receive("rp.VortigontDisguise", function(len, ply)
		if not ply:GetTeamTable().vort_disguise then return end
		if ply:IsVortDisguised() or pl.ZombieInfected then return end

		ply:Disguise(TEAM_VORTI)
		ply:GetNetVar('VortDisguise', true)
	end)

	net.Receive("rp.UnVortigontDisguise", function(len, ply)
		if not ply:GetTeamTable().vort_disguise then return end
		if not ply:IsVortDisguised() or pl.ZombieInfected then return end
		ply:UnDisguise()
		ply:GetNetVar('VortDisguise', false)
	end)
end