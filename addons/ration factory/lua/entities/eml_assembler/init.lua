AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_washer003.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetPos(self:GetPos()+Vector(0, 0, 8));

end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_assembler");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;


function ENT:StartTouch(ent)
	local owner = ent.holder
	if ent:GetClass() == "eml_box" && ent:GetNWInt('ration') >= 10 and IsValid(owner) then
		ent:Remove()
		owner:AddMoney(rp.cfg.FactoryMoney)
		rp.Notify(owner, NOTIFY_GREEN, "Вы получили # за собранные вами рационы.", rp.FormatMoney(rp.cfg.FactoryMoney))
	end
end
