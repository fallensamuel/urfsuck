--VAPE SWEP \//\ by Swamp Onions - http://steamcommunity.com/id/swamponions/

AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

SWEP.nextJump = 0

local sounds = {
	[1] = { -- crow
		alarm = {'npc/crow/alert2.wav', 'npc/crow/alert3.wav', 'npc/crow/pain1.wav', 'npc/crow/pain2.wav'},
		hop = {'npc/crow/hop1.wav'},
		songs = {'npc/crow/idle1.wav', 'npc/crow/idle2.wav', 'npc/crow/idle3.wav', 'npc/crow/idle4.wav'},
	},
	[2] = { -- pigeon
		alarm = {'ambient/creatures/pigeon_idle4.wav'},
		hop = {'npc/crow/hop1.wav'},
		songs = {'ambient/creatures/pigeon_idle1.wav', 'ambient/creatures/pigeon_idle2.wav', 'ambient/creatures/pigeon_idle3.wav', 'ambient/creatures/pigeon_idle4.wav'},
	},
	[3] = { -- seagull
		alarm = {'ambient/creatures/seagull_idle1.wav', 'ambient/creatures/seagull_idle2.wav', 'ambient/creatures/seagull_idle3.wav'},
		hop = {'npc/crow/hop1.wav'},
		songs = {'ambient/creatures/seagull_pain1.wav', 'ambient/creatures/seagull_pain2.wav', 'ambient/creatures/seagull_pain3.wav'},

	}
}

local birdNum = {
	['models/crow.mdl'] = 1,
	['models/pigeon.mdl'] = 2,
	['models/seagull.mdl'] = 3
}

for bird, v1 in pairs(sounds) do
	for type, v2 in pairs(v1) do
		for k, v3 in pairs(v2) do
			sounds[bird][type][k] = Sound(v3)
		end
	end
end

SWEP.Sound = sounds

function SWEP:Deploy()
	self.Owner:SetWalkSpeed(50)
	self.Owner:SetRunSpeed(200)
	self.Owner:SetGravity(0.3)

	self.Bird = birdNum[self.Owner:GetModel()]
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Holster()
	self.Owner:SetGravity(1)
	return true
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_JUMP) && self.nextJump < CurTime() then
		self.nextJump = CurTime() + 1
		local vec = self.Owner:GetAimVector() * 200
		vec.z = 200
		self.Owner:SetVelocity(vec)
		self.Owner:EmitSound(table.Random(self.Sound[self.Bird].hop), 100, 100, 1)
	end
end


function SWEP:PrimaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
	self:SetNextPrimaryFire(CurTime() + 3)
	self.Owner:EmitSound(table.Random(self.Sound[self.Bird].songs), 100, 100, 1)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1)
	self:SetNextPrimaryFire(CurTime() + 3)
	self.Owner:EmitSound(table.Random(self.Sound[self.Bird].alarm), 100, 100, 1)
end 