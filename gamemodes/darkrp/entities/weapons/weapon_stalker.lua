AddCSLuaFile()


local DRUG = {};
DRUG.Name = "RepairBeam";
DRUG.Duration = 1;

DRUG.NoKarmaLoss = true;

local math = math

function DRUG:DoBeamDamage(pl)
	if pl:IsOnFire() then return end
	
	if pl.repBeamStacks and pl.repBeamStacks < 5 then
		local dmg = DamageInfo()
		dmg:SetDamage(5 * pl.repBeamStacks)
		dmg:SetAttacker(pl)
		pl:TakeDamageInfo(dmg)
	else 
		pl:Ignite(20)
	end
end

function DRUG:DoBeamHeal(pl)
	if pl:Armor() < pl:GetMaxArmor() then
		pl:GiveArmor(math.min(20, pl:GetMaxArmor() - pl:Armor()))
	end
	
	pl:SetHealth(math.min(pl:Health() + 5, pl:GetMaxHealth()))
end

function DRUG:StartHighServer(pl)
	if pl:IsDisguised() then
		pl:UnDisguise()
		pl:Ignite(20)
	end
	
	if pl:GetFaction() == FACTION_CITIZEN then return end
	
	if not pl:IsCombine() then
		pl.StunstickOldWalkSpeed = pl.StunstickOldRunSpeed or pl:GetWalkSpeed();
		pl.StunstickOldRunSpeed = pl.StunstickOldRunSpeed or pl:GetRunSpeed();

		pl:SetWalkSpeed(pl.StunstickOldRunSpeed * 0.5);
		pl:SetRunSpeed(pl.StunstickOldWalkSpeed * 0.5);

		pl.repBeamStacks = 1
		self:DoBeamDamage(pl)
	else
		pl.repBeamStacks = -1
		self:DoBeamHeal(pl)
	end
end

function DRUG:CalculateDuration(pl, stacks)
	return math.min(stacks * 3, 15)
end

function DRUG:AddStack(pl, stacks)
	if not pl.repBeamStacks then return end
	
	if pl.repBeamStacks > 0 then
		pl:SetWalkSpeed(pl:GetRunSpeed() * 0.7);
		pl:SetRunSpeed(pl:GetRunSpeed() * 0.7);
		
		pl.repBeamStacks = math.min(pl.repBeamStacks + 1, 5)
		
		self:DoBeamDamage(pl)
	else 
		self:DoBeamHeal(pl)
	end
end

function DRUG:EndHighServer(pl)
	if (pl.StunstickOldWalkSpeed) then
		pl:SetWalkSpeed(pl.StunstickOldWalkSpeed);
		pl.StunstickOldWalkSpeed = nil;
	end
	
	if (pl.StunstickOldRunSpeed) then
		pl:SetRunSpeed(pl.StunstickOldRunSpeed);
		pl.StunstickOldRunSpeed = nil;
	end
	
	pl.repBeamStacks = nil
end

RegisterDrug(DRUG);


SWEP.PrintName = "Ремонтный Луч"

SWEP.Author = "Anus"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Category = "Half-Life Alyx RP" 

SWEP.Spawnable = true;
SWEP.AdminOnly = true

SWEP.Slot					= 0
SWEP.SlotPos				= 4

SWEP.DrawAmmo				= false


SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"


SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	self.LoopSound = CreateSound(self.Owner, 'npc/stalker/laser_burn.wav')
end

function SWEP:PrimaryAttack()
	self.Firing = true
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	if SERVER then
		self.LoopSound:Play()
		self.LoopSound:ChangeVolume(1, .5)

		self:SetFire(true)
	end
end

local RoarSound = {Sound('npc/stalker/go_alert2.wav'), Sound('npc/stalker/go_alert2a.wav')}

function SWEP:SecondaryAttack()
	if self:GetNextPrimaryFire() > CurTime() || self:GetNextSecondaryFire() > CurTime() then
		return
	end

	self:SetNextPrimaryFire( CurTime() + 3 )
	self:SetNextSecondaryFire( CurTime() + 3 )

	self:EmitSound( table.Random(RoarSound),  75 )
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Fire");
end

local whiteCol = Color(255, 255, 255)

if SERVER then
	SWEP.LastFire = 0

	function SWEP:Think()
		if self.Firing && !self.Owner:KeyDown(IN_ATTACK) or not self:GetOwner():Alive() or self:GetOwner():IsInDeathMechanics() then
			self.Firing = false
			self:SetFire(false)
			self.LoopSound:FadeOut(.5)
		end
		if self:GetFire() && self.LastFire < CurTime() then
			self.LastFire = CurTime() + 0.5
			local ent = self.Owner:GetEyeTrace().Entity
			
			if ent:IsPlayer() then
				ent:AddHigh('RepairBeam')
				
				--[[
				if ent:IsCombine() and ent:Armor() < 120 then
					ent:GiveArmor(20)
				--	ent:EmitSound(table.Random(sounds), )
				elseif not ent:IsCombine() then
					ent:AddHigh('RepairBeam')
				end
				]]
			elseif ent:GetClass() == "ent_textscreen" and not ent.PermaProps then
				ent:SetNoDraw(true)
				ent.StalkerBeamBreak = (ent.StalkerBeamBreak or 0) + 1
				if ent.StalkerBeamBreak >= 5 then
					ent:Remove()
				else
					timer.Simple(0.1, function()
						ent:SetNoDraw(false)
					end)
				end
			end
		end
	end
	return
end

local RoarSound = {Sound('npc/stalker/go_alert2.wav'), Sound('npc/stalker/go_alert2a.wav')}


function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial('engine/occlusionproxy')
end

local laset_mat = Material('cable/redlaser')

function SWEP:ViewModelDrawn()
	if self:GetFire() then
		render.SetMaterial( laset_mat )
		local pos = self.Owner:GetViewModel():GetPos()
		local ang = self.Owner:GetViewModel():GetAngles()
		render.DrawBeam(pos - ang:Up() * 15, self.Owner:GetEyeTrace().HitPos, 7, 0, 12.5, Color(255, 0, 0, 255))
	end
end
local att, pos, ang
local col = Color(255, 0, 0, 255)
function SWEP:DrawWorldModel()
	if self:GetFire() then
		//Draw the laser beam.
		render.SetMaterial( laset_mat )
		att = self.Owner:LookupAttachment("eyes")
		if !att then return end
		att = self.Owner:GetAttachment(self.Owner:LookupAttachment("eyes"))
		if !att then return end
		pos, ang = att.Pos, att.Ang
		render.DrawBeam(pos, self.Owner:GetEyeTrace().HitPos, 10, 0, 12.5, col)
    end
end

function SWEP:OnRemove()
	if SERVER then
		self.LoopSound:Stop()
	end
	if not IsValid(self.Owner) then return end
	local vm = self.Owner:GetViewModel()

	if IsValid(vm) then
		vm:SetMaterial("")
	end
end


function SWEP:Holster()
	self:OnRemove()

	return true
end

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)