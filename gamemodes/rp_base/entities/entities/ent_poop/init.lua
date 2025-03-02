AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------]]
function ENT:Initialize()
	//self:SetModel("models/Gibs/HGIBS_spine.mdl")

	self:SetModel(math.random(1,20) == 19 && table.Random({'models/poo/curlywtfpoo.mdl', 'models/poo/wtfpoo.mdl'}) or table.Random({'models/poo/bpoo.mdl','models/poo/curlybpoo.mdl','models/poo/curlygpoo.mdl','models/poo/curlypoo.mdl','models/poo/poo.mdl'}))
	
	//self:SetColor(Color(102, 51, 0))
	//self:SetMaterial("models/props_pipes/pipeset_metal")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysWake()
end

--[[---------------------------------------------------------
   Name: ENT:Use()
---------------------------------------------------------]]
function ENT:Use(activator, caller)
	if activator:IsBanned() then return end

	/*
	if math.random(1, 4) == 2 then
		rp.Notify(caller, NOTIFY_ERROR, rp.Term('YouGotAIDS'))
		activator:EmitSound("vo/sandwicheat09.wav", 100, 100)
		self:Remove()
		GiveSTD(caller)

		return
	end

	if caller:Health() <= 10 then
		caller:Kill()
	else
		caller:SetHealth(caller:Health() - 10)
	end

	caller:AddHunger(5)
	*/
	
	activator:EmitSound("vo/sandwicheat09.wav", 100, 100)
	self:Remove()
end