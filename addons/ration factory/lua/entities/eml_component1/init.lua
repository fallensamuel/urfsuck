AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_lab/box01a.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	self:SetPos(self:GetPos()+Vector(0, 0, 8));

	self:PhysWake()

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	SafeRemoveEntityDelayed(self, 25)
end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_component1");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;

function ENT:Use(pl)
	if ((self.nextUse or 0) >= CurTime()) then
		return
	end
	pl:PickupObject(self)
	--rp.Notify(pl, NOTIFY_GENERIC, "Поднеси этот компонент к воде чтобы получить рацион")
	self.nextUse = CurTime() + 2
end

function ENT:Think()
	local box = rp.cfg.RationFactory[game.GetMap()].FactoryZone
	if not self:GetPos():WithinAABox(box[1], box[2]) then
		self:Remove() 
		return 
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:PhysicsCollide(data, phys)
	if  (!self.used && data.HitEntity:GetClass() == "eml_component2") then
			self.used = true
			data.HitEntity:Remove();
			local ent = ents.Create('eml_ration')
			ent:SetPos(self:GetPos()+Vector(0, 0, 8))
			ent:Spawn()	
			self:EmitSound("ambient/levels/canals/toxic_slime_gurgle4.wav", 70, 100, 0.2);
			self:Remove();
	end;
end;

function ENT:OnRemove()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:Remove();
end;
