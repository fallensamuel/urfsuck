AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");


function ENT:Initialize()
	self:SetModel('models/props_borealis/door_wheel001a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:PhysWake()


end
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_button");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;


function ENT:Use(pl)

	if ((self.nextUse or 0) >= CurTime()) then
		return
	end


	if IsValid(self.lastComp1) then
        self.lastComp1:Remove()
    end
    if IsValid(self.lastComp2) then
        self.lastComp2:Remove()
    end


	local ent1 = ents.Create("eml_component1")
		ent1:SetPos( self.poscomp1 )
		ent1:Spawn()
	self.lastComp1 = ent1

	local ent2 = ents.Create("eml_component2")
		ent2:SetPos( self.poscomp2 )
		ent2:Spawn()
	self.lastComp2 = ent2


	self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav", 70, 100, 1);
	self.nextUse = CurTime() + 2      
end




function ENT:VisualEffect()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:Remove();
end;
