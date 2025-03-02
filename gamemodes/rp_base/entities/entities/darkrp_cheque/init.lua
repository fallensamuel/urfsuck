AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()

	timer.Simple( rp.cfg.ChequeLifeTime or 300, function()
		if IsValid( self ) then
			local owner  = self:Getowning_ent();
			local amount = self:Getamount() or 0;

			if IsValid( owner ) and math.random() > 0.5 then
				rp.Notify( owner, NOTIFY_GREEN, rp.Term("ChequeTorn") );
				owner:AddMoney( amount );
			end

			self:Remove();
		end
	end );
end

function ENT:Use(activator, caller)
	local owner = self:Getowning_ent()
	local recipient = self:Getrecipient()
	local amount = self:Getamount() or 0

	if (IsValid(activator) and IsValid(recipient)) and activator == recipient then
		local ownername = (IsValid(owner) and owner:Nick()) or "Disconnected player"
		rp.Notify(activator, NOTIFY_GREEN, rp.Term('ChequeFound'), rp.FormatMoney(amount), (IsValid(owner) and owner or 'Disconnected player'))
		activator:AddMoney(amount)

		hook.Call('PlayerPickupRPCheck', GAMEMODE, activator, (IsValid(owner) and owner or {
			NameID = function() return 'Disconnected player' end,
			Name = function() return 'N/A' end,
			SteamID = function() return 'N/A' end
		}), amount, activator:GetMoney())

		self:Remove()
	elseif (IsValid(owner) and IsValid(recipient)) and owner ~= activator then
		rp.Notify(activator, NOTIFY_GENERIC, rp.Term('ChequeMadeTo'), recipient)
	elseif IsValid(owner) and owner == activator then
		rp.Notify(activator, NOTIFY_GREEN, rp.Term('ChequeTorn'))
		owner:AddMoney(self:Getamount()) -- return the money on the cheque to the owner.
		hook.Call('PlayerVoidedRPCheck', GAMEMODE, activator, recipient, amount, activator:GetMoney())
		self:Remove()
	elseif not IsValid(recipient) then
		self:Remove()
	end
end

function ENT:Touch(ent)
	if ent:GetClass() ~= "darkrp_cheque" or self.hasMerged or ent.hasMerged then return end
	if ent:Getowning_ent() ~= self:Getowning_ent() then return end
	if ent:Getrecipient() ~= self:Getrecipient() then return end
	ent.hasMerged = true
	self:Setamount(self:Getamount() + ent:Getamount())
	ent:Remove()
end