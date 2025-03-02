AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/weapons/2_c4_planted.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:PhysWake()
	local i = 0

	timer.Create(self:EntIndex() .. 'explode', 1, 5, function()
		if (!IsValid(self)) then return end

		i = i + 1
		self:EmitSound("C4.PlantSound")

		if (i == 5) then
			self:Explosion()
		end
	end)
end

local badprops = {
	['models/props_interiors/vendingmachinesoda01a.mdl'] = true,
	['models/props_interiors/vendingmachinesoda01a_door.mdl'] = true
}

local function findents(pos, radius)
	return table.Filter(ents.FindInSphere(pos, radius), function(v) return (v:GetClass() == 'prop_physics' or v:GetClass() == 'prop_physics_multiplayer' or v:IsDoor()) end)
end

function ENT:Explosion()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetRadius(1000)
	effectdata:SetMagnitude(1000)
	util.Effect("HelicopterMegaBomb", effectdata)
	local exploeffect = EffectData()
	exploeffect:SetOrigin(self:GetPos())
	exploeffect:SetStart(self:GetPos())
	util.Effect("Explosion", exploeffect, true, true)
	local shake = ents.Create("env_shake")
	shake:SetOwner(self.ItemOwner)
	shake:SetPos(self:GetPos())
	shake:SetKeyValue("amplitude", "500") -- Power of the shake
	shake:SetKeyValue("radius", "500") -- Radius of the shake
	shake:SetKeyValue("duration", "2.5") -- Time of shake
	shake:SetKeyValue("frequency", "255") -- How har should the screenshake be
	shake:SetKeyValue("spawnflags", "4") -- Spawnflags(In Air)
	shake:Spawn()
	shake:Activate()
	shake:Fire("StartShake", "", 0)
	local push = ents.Create("env_physexplosion")
	push:SetOwner(self.ItemOwner)
	push:SetPos(self:GetPos())
	push:SetKeyValue("magnitude", 100)
	push:SetKeyValue("radius", 500)
	push:SetKeyValue("spawnflags", 2 + 16)
	push:Spawn()
	push:Activate()
	push:Fire("Explode", "", 0)
	push:Fire("Kill", "", .25)
	self:EmitSound(Sound("C4.Explode"))
	util.BlastDamage(self, self.ItemOwner, self:GetPos(), 250, 200)
	local max_rand = 6
	local props, doors = findents(self:GetPos(), 75)

	for k, v in ipairs(props) do
		if IsValid(v) then
			local class = v:GetClass();

			if (class == 'prop_physics' or class == 'prop_physics_multiplayer') then
				if (IsValid(v:CPPIGetOwner())) then
					v:Remove()
--[[
					v:Fade();
					
					timer.Simple(10, function()
						if not IsValid(v) then return end
						v:UnFade();
						
						rp.AutoFreezer.Block(v);
						rp.AutoFreezer.AntiPlayerBlock(v);
					end);
]]--
				end
			elseif v:IsDoor() then
				v:DoorLock(false);
				v:Fire('open', '', .6);
				v:Fire('setanimation', 'open', .6);
			end
		end
	end

	self:Remove()
end