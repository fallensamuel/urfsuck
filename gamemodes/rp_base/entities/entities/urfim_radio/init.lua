AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("urfim_radio")
util.AddNetworkString("urfim_radiokey")

function ENT:Initialize()
	self:SetModel(rp.cfg.RadioModel or "models/props_lab/citizenradio.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self.TakenDamage = 0
end

function ENT:Use(ply)
	net.Start("urfim_radio")
	net.Send(ply)
end

ENT.Actions = {}
local function AddAction(index, callback)
	ENT.Actions[index] = callback
end
net.Receive("urfim_radio", function(len, ply)
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ent.IsUrfRadio then return end

	local act_index = net.ReadUInt(2)
	local act = ent.Actions[act_index]
	if not act then return end

	act(ent)
end)

AddAction(0, function(ent) -- stop
	ent:SetSongID(0)
	ent:SetStartTime(0)
end)

AddAction(1, function(ent) -- Play
	ent:SetSongID(net.ReadUInt(32))
	ent:SetStartTime(CurTime())
end)

function ENT:OnTakeDamage(dmg) -- если кого-то напрягает музыка :)
	if self:GetSongID() == 0 then return end

	self.TakenDamage = self.TakenDamage + dmg:GetDamage()
	if self.TakenDamage >= (rp.cfg.RadioHealth or 220) then
		self.TakenDamage = 0

		self:SetSongID(0)
		self:SetStartTime(0)
	end
end

local SoundCloudApiKeys = {
	sended = {},
	list = {"a281614d7f34dc30b665dfcaa3ed7505", "95f22ed54a5c297b1c41f72d713623ef", "173bf9df509c48cf53b70c83eaf5cbbd", "KFSHpN5xEaAvIZZCrsrDjuFHOcArM91q", "2aca68b7dc8b51ec1b20fda09b59bc9a"}
}

hook.Add("PlayerDataLoaded", "SoundCloudApiKeys", function(ply)
	--print(ply, "Request SoundCloud-client_id")

	if SoundCloudApiKeys.sended[ply:SteamID64()] then -- что-бы пользователь не мог получить множество ключей за несколько попыток.
		if not ply.SendedSCClientID then -- что-бы занова не отсылать уже отправленные данные
			ply.SendedSCClientID = SoundCloudApiKeys.sended[ply:SteamID64()]
			net.Start("urfim_radiokey")
				net.WriteString(ply.SendedSCClientID)
			net.Send(ply)
		end
		return
	end

	local v, k = table.Random(SoundCloudApiKeys.list)
	ply.SendedSCClientID = v
	SoundCloudApiKeys.sended[ply:SteamID64()] = ply.SendedSCClientID

	print("Sending SoundCloud-client_id to", ply, "key-id", k)
	net.Start("urfim_radiokey")
		net.WriteString(ply.SendedSCClientID)
	net.Send(ply)
end)