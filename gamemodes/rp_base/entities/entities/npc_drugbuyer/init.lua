AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('rp.DrugBuyerMenu')

function ENT:Initialize()
	self:SetModel(rp.cfg.DrugBuyerModel or 'models/Humans/Group01/male_03.mdl')
	--self:SetHullType(HULL_HUMAN)
	--self:SetHullSizeNormal()
	--self:SetNPCState(NPC_STATE_SCRIPT)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	--self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	--self:SetMaxYawSpeed(90)
	self:SetTrigger(true)
	
	self:ResetSequence( self:LookupSequence("LineIdle01") );
end

function ENT:AcceptInput(input, activator, caller)
	if (input == 'Use') and activator:IsPlayer() then
		net.Start('rp.DrugBuyerMenu')
		net.Send(activator)
	end
end

function ENT:StartTouch(ent)
	local owner = ent.holder
	if IsValid(ent) and IsValid(owner) && ent:IsPlayerHolding() then
		local info = rp.Drugs[ent:GetClass()] or rp.Drugs[ent.weaponclass]
		if !info then return end
		ent:Remove()
		owner:AddMoney(info.BuyPrice)
		rp.Notify(owner, NOTIFY_GREEN, rp.Term('PlayerSoldDrugs'), info.Name, rp.FormatMoney(info.BuyPrice))
	end
end

--hook.Add('GravGunOnPickedUp', 'rp.drugbuyer.GravGunOnPickedUp', function(pl, ent)
--	local tab = rp.Drugs[ent:GetClass()] or rp.Drugs[ent.weaponclass]
--
--	if tab then
--		ent.DrugOwner = pl
--		ent.DrugInfo = tab
--	end
--end)
--
--hook.Add('GravGunOnDropped', 'rp.drugbuyer.GravGunOnDropped', function(pl, ent)
--	local tab = rp.Drugs[ent:GetClass()] or rp.Drugs[ent.weaponclass]
--
--	if tab then
--		ent.DrugOwner = nil
--		ent.DrugInfo = nil
--	end
--end)

hook('InitPostEntity', function()
	for k, v in pairs(rp.cfg.DrugBuyers[game.GetMap()] or {}) do
		local npc = ents.Create('npc_drugbuyer')
		npc:SetPos(v.Pos)
		npc:SetAngles(v.Ang)
		npc:Spawn()
		
		npc:ResetSequence(npc:LookupSequence("LineIdle01"))
	end
end)