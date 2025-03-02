AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/weapons/w_package.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	self:SetPos(self:GetPos()+Vector(0, 0, 8));
	self:PhysWake()

	SafeRemoveEntityDelayed(self, 25)
end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_ration");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;

function ENT:Think()
	local box = rp.cfg.RationFactory[game.GetMap()].FactoryZone
	if not self:GetPos():WithinAABox(box[1], box[2]) then
		self:Remove() 
		return 
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:Use(pl)
	if ((self.nextUse or 0) >= CurTime()) then
		return
	end
	pl:PickupObject(self)
	--rp.Notify(pl, NOTIFY_GENERIC, "Поднеси рацион к коробке чтобы положить его внутрь")
	self.nextUse = CurTime() + 2
end

function ENT:OnRemove()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:Remove();
end;
