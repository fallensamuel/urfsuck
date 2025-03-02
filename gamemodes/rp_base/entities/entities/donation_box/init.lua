AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.RemoveOnJobChange = true

function ENT:Initialize()
	self:SetModel("models/props/CS_militia/footlocker01_open.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	
	if IsValid(self.ItemOwner) then
		self:CPPISetOwner(self.ItemOwner)
	end
end

util.AddNetworkString('rp.OpenDonateWindow')
function ENT:Use(pl)
	if (pl == self:Getowning_ent()) then
		if (self:Getmoney() > 0) then
			rp.Notify(pl, NOTIFY_GREEN, rp.Term('PlayerTookDonationBox'), rp.FormatMoney(self:Getmoney()))
			pl:AddMoney(self:Getmoney())
			self:Setmoney(0)
		end
	else
		net.Start('rp.OpenDonateWindow')
		net.Send(pl)
	end
end

function ENT:Touch(ent)
	if ent:GetClass() ~= "spawned_money" or self.hasMerged or ent.hasMerged or ent.PrinterMoney then return end
	ent.hasMerged = true
	ent:Remove()
	self:Setmoney(self:Getmoney() + ent:Getamount())

	if IsValid(self:Getowning_ent()) then
		rp.Notify(self:Getowning_ent(), NOTIFY_GREEN, rp.Term('PlayerReceivedDonationBox'), rp.FormatMoney(ent:Getamount()))
	end
end

rp.AddCommand('/donate', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if !(args[1] && ent:GetClass() == 'donation_box') then return end
	local money = math.floor(tonumber(args[1]))
	if !(money && pl:CanAfford(money) && money > 0) then return end

	pl:AddMoney(-money)
	ent:Setmoney(ent:Getmoney() + money)
end)