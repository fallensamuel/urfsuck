AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:DrawShadow(true)
	self:PhysWake()

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	SafeRemoveEntityDelayed(self, 25)
end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_component2");
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
	--rp.Notify(pl, NOTIFY_GENERIC, "Поднеси этот компонент к токенам чтобы получить рацион")
	self.nextUse = CurTime() + 2
end


