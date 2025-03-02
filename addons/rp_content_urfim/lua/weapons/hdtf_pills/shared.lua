if (SERVER) then
	AddCSLuaFile ("shared.lua")
	
	SWEP.Weight = 5
	
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false

	if (!game.SinglePlayer()) then	
		SWEP.Running = 0
	end
end
 
if (CLIENT) then
	SWEP.PrintName = "Обезболивающее"
	
	SWEP.Slot = 4
	SWEP.SlotPos = 5
	
	SWEP.DrawAmmo = true
	
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon = false 
	
	language.Add('hdtf_painkillers', 'HDTF PainKillers')

	if (game.SinglePlayer()) then
		SWEP.Running = 3
	else
		SWEP.Running = 0
	end
end
 
SWEP.Author = "DottierGalaxy50 (With help from the Wiki and content from others)"
SWEP.Contact = "None"
SWEP.Purpose = "Kill"
SWEP.Instructions = "Press ''Attack'' button stupid"
 
SWEP.Category = "Half-Life Alyx RP"
 
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
SWEP.ViewModel  = "models/hunt_down_the_freeman/weapons/v_pills.mdl"
SWEP.WorldModel = "models/hunt_down_the_freeman/weapons/w_pills.mdl"

SWEP.UseHands = false
SWEP.HoldType = "slam"
 
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = 0
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "hdtf_ammo_pills"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "melee"

SWEP.NextPrimaryAttack     = CurTime()
SWEP.NextSecondaryAttack   = CurTime()

SWEP.RunningLoopTimer = CurTime()

SWEP.FirstDraw = 0

 
function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType);
	self:SetHoldType("normal")
    timer.Simple(0.001, function() self.FirstDraw = 1; end)

	self.Uses = 5
	self.Heal = 25
end

function SWEP:Deploy()  
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration());
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration());
	self:NextThink(CurTime() + self:SequenceDuration());
	self:EmitSound(Sound("Weapon_HDTF_PILLS.Deploy"));
	
    if (game.SinglePlayer()) then
    	self.Running = 0;
    end
	
	if (self.FirstDraw == 0) then
		self.FirstDraw = 1;
	end

	if (SERVER) then
		self.Owner:SetAmmo(self.Uses, self.Primary.Ammo);
	end
	
    return true
end

function SWEP:Holster( )
    self.Weapon:StopSound('Weapon_HDTF_PILLS.Single');
	self.Running = 3;

    if (!game.SinglePlayer()) then
    	self.Running = 0;
    end

	return true
end

function SWEP:PrimaryAttack()
	local Owner = self.Owner;

	if (IsValid(Owner) and Owner:Health() < Owner:GetMaxHealth() and self.Uses > 0) then
		if (SERVER) then
			timer.Simple(1.4, function()
				Owner:SetHealth(Owner:Health() + self.Heal);
				if (Owner:Health() > Owner:GetMaxHealth()) then
					Owner:SetHealth(Owner:GetMaxHealth());
				end
			end);
		end
		
		Owner:EmitSound(Sound('Weapon_HDTF_PILLS.Single'));
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
		
		if (self.Uses > 1) then
			timer.Simple(2.3, function()
				self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
				self:EmitSound(Sound('Weapon_HDTF_PILLS.Deploy'));
			end);
		end

		self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.8);
		self.Running = 3;

		self.Uses = self.Uses - 1;
		self.Owner:SetAmmo(self.Uses, self.Primary.Ammo);

	    -- Running after shot
		
		timer.Simple(3, function()
			if (self.Running == 3 && self.Uses > 1) then self.Running = 1;
			elseif (self.Running == 1 and self.Uses > 1) then self.Running = 3; end
			if (SERVER) then
				if (self.Uses <= 0) then
					Owner:StripWeapon('hdtf_pills');
				end
			end
		end);
	end
end

function SWEP:SecondaryAttack()

end

function SWEP:Think()
	local Owner = self.Owner;
	
	-- Start Running

	if (self.Running == 0 and self.Owner:KeyDown(IN_SPEED)) then
		if (Owner:KeyDown(IN_FORWARD) or Owner:KeyDown(IN_BACK) or Owner:KeyDown(IN_MOVERIGHT) or self.Owner:KeyDown(IN_MOVELEFT)) then
			self:StartRunning();
		end
	end
	
	-- Stop Running
	
    if (self.Running == 1 && not( self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT)) and (!self.Owner:KeyDown(IN_SPEED))) then
    	self:StopRunning();
    end
	
    -- Running Animation Loop
	
	if (self.RunningLoopTimer <= CurTime() && self.Running == 1) then
		self.Weapon:SendWeaponAnim(ACT_VM_SPRINT_IDLE);
        self.RunningLoopTimer = CurTime() + 0.8;
	end
end

function SWEP:StartRunning()
    self.RunningLoopTimer = CurTime() + 0.2;
	self.Running = 1;
	self.Weapon:SendWeaponAnim(ACT_VM_SPRINT_ENTER);
end

function SWEP:StopRunning()
    self.Running = 0;
    self.Weapon:SendWeaponAnim(ACT_VM_SPRINT_LEAVE);
end

sound.Add(
{
    name = "Weapon_HDTF_PILLS.Single",
	channel	= CHAN_WEAPON,
	volume = 1.0,
	soundlevel = SNDLVL_GUNFIRE,
    sound = "hunt_down_the_freeman/weapons/painkillers/pills_complete.wav"
})

sound.Add(
{
    name = "Weapon_HDTF_PILLS.Deploy",
	channel	= CHAN_STATIC,
	volume = 1.0,
	soundlevel = SNDLVL_NORM,
    sound = "hunt_down_the_freeman/weapons/painkillers/foley_draw.wav"
})

game.AddAmmoType({
	name = SWEP.Primary.Ammo
});