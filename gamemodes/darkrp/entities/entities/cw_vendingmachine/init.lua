--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local STATE_READY, STATE_WAIT, STATE_ERROR = 1, 2, 3

ENT.defaultStock = 5

ENT.Price = rp.cfg.VendingPopcanPrice

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);

	self.stock = self.defaultStock
	self:SetState(STATE_READY)

	local physObj = self:GetPhysicsObject()
	
	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end;


-- A function to create the entity's water.
function ENT:CreateWater(activator)
	self:GiveStock(-1);
	self:ChangeState(STATE_READY);
	
	local forward = self:GetForward() * 18;
	local right = self:GetRight() * 3;
	local up = self:GetUp() * -24;
	
	timer.Simple(2, function()
		self:EmitSound("buttons/button4.wav");
		--rp.SpawnFood(activator, "Popcan", self:GetPos() + forward + right + up, self:GetAngles());
		rp.FoodSystem.SpawnFood( "urf_foodsystem_food_sodacan", self:GetPos() + forward + right + up, self:GetAngles() );
	end)
end;

function ENT:GetStock()
	return self.stock
end;

function ENT:SetStock(amount)
	self.stock = amount
end;

function ENT:GiveStock(amount)
	self.stock = self.stock + amount
end;

function ENT:Restock()
	self:SetState(STATE_READY);
	self:EmitSound("buttons/button6.wav");
	self:SetStock( self.defaultStock );
end;

function ENT:ChangeState(state, nextState)
	self:SetState(STATE_WAIT)
	timer.Simple(3, function() 
		if state == STATE_ERROR then 
			self:EmitSound("buttons/button2.wav")
		end 
		self:SetState(state) 
		if nextState then timer.Simple(3, function() self:SetState(nextState) end) end 
	end)
end;

function ENT:Use(activator, caller)
	if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
		local curTime = CurTime();
		print(self:GetState() == STATE_WAIT , self:GetStock() , activator:IsCWU())
		if (self:GetState() == STATE_READY) then
			self:EmitSound("buttons/button1.wav", 100, 50)
			if (self:GetStock() == 0 or !activator:CanAfford(self.Price)) then
				self:ChangeState(STATE_ERROR, self:GetStock() == 0 and STATE_WAIT or STATE_READY);
			elseif (!activator.nextVendingMachine or curTime >= activator.nextVendingMachine) then
				self:CreateWater(activator);
				
				activator.nextVendingMachine = curTime + 300;
				
				activator:AddMoney(-self.Price);
			else
				self:ChangeState(STATE_ERROR, self:GetStock() == 0 and STATE_WAIT or STATE_READY);
			end;
		elseif self:GetState() == STATE_WAIT and activator:IsCWU() then
			self:Restock();
		end
	end;
end;

hook('InitPostEntity', function()
	for k, v in pairs(rp.cfg.VendingMachines[game.GetMap()] or {}) do
		local ent = ents.Create('cw_vendingmachine')
		ent:SetPos(v.Pos)
		ent:SetAngles(v.Ang)
		ent:Spawn()
	end
end)