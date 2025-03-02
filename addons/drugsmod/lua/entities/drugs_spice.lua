/*
	Drugs System
	Coded by KingofBeast
	Inspired by Durgz, but that's a shitty addon
*/

AddCSLuaFile();


ENT.SeizeReward = 40
ENT.WantReason = 'Drugs'

ENT.Type			= "anim";
ENT.Base			= "drug_base";

ENT.Category		= "Drugs";
ENT.PrintName		= "Spice";
ENT.Author			= "The D3vine";
ENT.Spawnable		= false;
ENT.AdminSpawnable	= true;

ENT.HighLagRisk = false

ENT.Model			= "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl";
ENT.ID				= "Spice";

function ENT:Initialize()
	self:SetModel(self.Model);
	
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS);
		self:SetMoveType(MOVETYPE_VPHYSICS);
		self:SetSolid(SOLID_VPHYSICS);
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);

		self:PhysWake();
		
		self:GetPhysicsObject():SetMass(2);
	end

	self:SetColor(Color(255,242,0))
end

local DRUG = {};
DRUG.Name = "Spice";
DRUG.Duration = 60;

function DRUG:StartHighServer(pl)
	pl:SetDSP(6);
	
	if (math.random(0, 10) == 0) then
		pl:Ignite(5, 0);
		pl:ConCommand("say FFFFFFUUUUUUUUUUUUUUUUUU");
	else
		local hp = pl:Health();
		
		if (hp * 3 / 2 < 500) then
			pl:SetHealth(math.floor(hp + 25));
		else
			pl:SetHealth(hp + 25);
		end

		pl.CocaineOldWalkSpeed = pl.CocaineOldRunSpeed or pl:GetWalkSpeed();
		pl.CocaineOldRunSpeed = pl.CocaineOldRunSpeed or pl:GetRunSpeed();
		
		pl:SetWalkSpeed(pl.CocaineOldRunSpeed * 1.5); 
		pl:SetRunSpeed(pl.CocaineOldRunSpeed * 1.5);
		
		pl:SetGravity(0.2);
		pl:TakeHunger(10)
		
		local sayings = {
			"does any1 hav goldfish!?1 i want goldfish plz thx",
			"My eyes aren't red. What are you talking about?",
			"duuuuuuuuuuudeeeeeeee",
			"hi how do i type in chat i cant figure it out"
		};
		pl:ConCommand("say " .. sayings[math.random(1, #sayings)]);
	end
end

function DRUG:TickServer(pl, stacks, startTime, endTime)
end

function DRUG:EndHighServer(pl)
	pl:SetDSP(1);
	pl:SetGravity(1);
	if (pl.CocaineOldWalkSpeed) then
		pl:SetWalkSpeed(pl.CocaineOldWalkSpeed);
		pl.CocaineOldWalkSpeed = nil;
	end
	
	if (pl.CocaineOldRunSpeed) then
		pl:SetRunSpeed(pl.CocaineOldRunSpeed);
		pl.CocaineOldRunSpeed = nil;
	end
end

function DRUG:StartHighClient(pl)
end

function DRUG:TickClient(pl, stacks, startTime, endTime)
end

function DRUG:EndHighClient(pl)
end

function DRUG:HUDPaint(pl, stacks, startTime, endTime)
end

function DRUG:RenderSSEffects(pl, stacks, startTime, endTime)
	local tab = {};
	tab[ "$pp_colour_addr" ] = 0;
	tab[ "$pp_colour_addg" ] = 0;
	tab[ "$pp_colour_addb" ] = 0;
	tab[ "$pp_colour_mulr" ] = 0;
	tab[ "$pp_colour_mulg" ] = 0;
	tab[ "$pp_colour_mulb" ] = 0;
	
	tab[ "$pp_colour_colour" ] = 0.77;
	tab[ "$pp_colour_brightness" ] = -0.11;
	tab[ "$pp_colour_contrast" ] = 2.62;
	
	DrawMotionBlur(0.03, 0.77, 0);
	DrawColorModify(tab);
end

RegisterDrug(DRUG);