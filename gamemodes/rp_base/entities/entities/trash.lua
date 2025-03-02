-- "gamemodes\\rp_base\\entities\\entities\\trash.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "Bobby";
ENT.PrintName = "Trash";

local DMG_BURN = DMG_BURN
local MOVETYPE_VPHYSICS = MOVETYPE_VPHYSICS
local SOLID_VPHYSICS = SOLID_VPHYSICS
local SIMPLE_USE = SIMPLE_USE
local SOLID_VPHYSICS = SOLID_VPHYSICS
local COLLISION_GROUP_WORLD = COLLISION_GROUP_WORLD

if SERVER then

	function ENT:Initialize()
		
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		
		self:SetCollisionGroup(COLLISION_GROUP_WORLD);
		
		local phys = self:GetPhysicsObject()

		self:PhysWake()
	end;

	function ENT:Use(pl)
		if ((self.nextUse or 0) >= CurTime()) then
			return
		end
		pl:PickupObject(self)
		self.holder = pl
		self.nextUse = CurTime() + 2
	end

	function ENT:OnTakeDamage(dmg)
		if self.give then return end
		--if dmg:GetDamageType() == DMG_BURN then
			if IsValid(self.holder) && (self.holder:GetFaction() == FACTION_CITIZEN or self.holder:GetFaction() == FACTION_CWU) then
				self.give = true
				self.holder:AddMoney(rp.cfg.TrashDestroyReward)
				self.holder:Notify(NOTIFY_GENERIC, rp.Term('TrashDesyroyReward'))
			end
		--end

		self:Remove()
	end

	local box

	function ENT:OnRemove()
		addTrashToQuery()
	end
	function ENT:Think()
		self:NextThink(CurTime() + 1)
		if !box then box = rp.cfg.GabrageBox[game.GetMap()] end
		if !self:GetPos():WithinAABox(box[1], box[2]) then
			self:Remove()
		end
	end
else
	function ENT:Draw()
		self:DrawModel()
	end
end