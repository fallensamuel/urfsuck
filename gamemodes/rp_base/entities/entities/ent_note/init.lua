AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('rp.Note.Text')

function ENT:Initialize()
	self:SetModel('models/props_c17/paper01.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self.AutoRemove = CurTime() + math.random(900, 1800)
	self.Text = 'Sample Text'

	timer.Simple(0, function()
		if IsValid(self.ItemOwner) then
			self:CPPISetOwner(self.ItemOwner)
		end
	end)
end

function ENT:Use(pl)
	self:SendWindow(pl)
end

function ENT:OnTakeDamage(damageData)
	self:Remove()
end

function ENT:SendWindow(pl)
	net.Start('rp.Note.Text')
	net.WriteEntity(self)
	net.WriteString(self.Text)
	net.WriteBool(IsValid(self.ItemOwner))
	if IsValid(self.ItemOwner) then
		net.WriteString(self.ItemOwner:Name())
		net.WriteBool(self.ItemOwner == pl)
	end
	net.Send(pl)
end

net.Receive('rp.Note.Text', function(len, pl)
	local ent = net.ReadEntity()
	if (not IsValid(ent) or ent:GetClass() ~= 'ent_note' or ent.ItemOwner ~= pl) then return end
	ent.Text = net.ReadString()
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('NoteUpdated'))
end)