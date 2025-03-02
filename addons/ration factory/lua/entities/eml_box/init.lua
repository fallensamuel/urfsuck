AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");


function ENT:Initialize()
	self:SetModel('models/props_junk/cardboard_box003a.mdl');
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);

	self:SetNWInt("ration", 0);
	self:SetPos(self:GetPos()+Vector(0, 0, 8));
	
	self:PhysWake()
end;
 
 function ENT:Use(pl)
	if ((self.nextUse or 0) >= CurTime()) then
		return
	end
	if (self:GetNWInt("ration") == 10) then
		rp.Notify(pl, NOTIFY_GREEN, "Коробка заполнена, отнеси её к сборщику!")
		pl:PickupObject(self)
	else
		pl:PickupObject(self)
	end
	self.nextUse = CurTime() + 2
end

function ENT:Think()
	local box = rp.cfg.RationFactory and rp.cfg.RationFactory[game.GetMap()] and rp.cfg.RationFactory[game.GetMap()].FactoryZone
	if box and not self:GetPos():WithinAABox(box[1], box[2]) then
		self:Remove() 
		return 
	end
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_box");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();

	return ent;
end;

function ENT:PhysicsCollide(data, phys)
	if (data.HitEntity:GetClass() == "eml_ration") and (self:GetNWInt("ration")<10) then
			local owner = data.HitEntity.holder
			if !IsValid(owner) then return end
			data.HitEntity:Remove();	
			owner:AddMoney(rp.cfg.FactoryBoxMoney)
			rp.Notify(owner, NOTIFY_GREEN, "Вы получили # за собранный вами рацион.", rp.FormatMoney(rp.cfg.FactoryBoxMoney))
			self:SetNWInt("ration", self:GetNWInt("ration") + 1);
			self:EmitSound("ambient/levels/canals/toxic_slime_sizzle3.wav", 70, 100, 0.2);
	end;
end;

function ENT:OnRemove()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	if !self.posbox then return end
	local box = self.posbox
	timer.Simple(3, function()
		local ent = ents.Create("eml_box")
		ent:SetPos(box[1])
		ent:SetAngles(box[2])
		ent:Spawn()
		ent:Activate()
		ent.posbox = box
	end)
	--self:Remove()
end;