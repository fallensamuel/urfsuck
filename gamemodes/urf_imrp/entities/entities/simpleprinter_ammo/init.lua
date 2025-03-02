AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("simpleammoprinter_openmenu")
util.AddNetworkString("simpleammoprinter_getammo")

function ENT:UseFunc(ply)
	net.Start("simpleammoprinter_openmenu")
		net.WriteInt(self:EntIndex(), 32)
	net.Send(ply)
end

function ENT:GivePrintedAmmo(ply, ammo_type_key)
	local ammo_type = rp.ammoTypes[ammo_type_key]
	if not ammo_type then return end

	local ammo_price = math.ceil(ammo_type.price*self.AmmoPriceMult)

	if ammo_price > self:GetCurAmount() then
		rp.Notify(ply, NOTIFY_RED, rp.Term("SPP_NotEnoughPatrons"))
		return
	end

	ply:GiveAmmo(ammo_type.amountGiven, ammo_type.ammoType)
	self:SetCurAmount(self:GetCurAmount() - ammo_price)

	if not self:GetIsWorking() and self:GetCurAmount() < self.MaxMoney then
		self:SetIsWorking(true)
		self:SetNextPrint(self.PrinterSpeed + CurTime())
		
		timer.Simple(self.PrinterSpeed, function() if IsValid(self) then self:Work() end end)
		self:StartSound()
	end	
end

net.Receive("simpleammoprinter_getammo", function(len, ply)
	local net_index = net.ReadInt(32)
	local net_key = net.ReadInt(32)

	local ent = ents.GetByIndex(net_index)
	if not IsValid(ent) then return end
	if ent:GetClass() ~= "simpleprinter_ammo" then return end

	if ply:GetPos():Distance(ent:GetPos()) > 150 then rp.Notify(ply, NOTIFY_RED, rp.Term("SPP_TooFar")) return end

	if ent.GivePrintedAmmo then
		ent:GivePrintedAmmo(ply, net_key)
	end
end)