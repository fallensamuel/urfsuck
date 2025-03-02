AddCSLuaFile()

if( CLIENT ) then
	SWEP.PrintName 			= "Кирка"
	SWEP.Slot 				= 2
	SWEP.SlotPos 			= 1
	SWEP.DrawAmmo 			= false
	SWEP.DrawCrosshair 		= false

	SWEP.HintMaterial 		= Material('mininghint.png')
	SWEP.HintAngle			= 0
	SWEP.HintAngleSpeed		= 2
end

SWEP.FixedThink		 		= 'pickaxe_ft'

SWEP.Category 				= "Root"
SWEP.Contact				= ""
SWEP.Purpose				= "Добывай с её помощью руду и продавай её скупщику"
SWEP.WeaponType				= "2H"

SWEP.ViewModelFOV			= 72
SWEP.ViewModelFlip			= false

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly              = true
  
SWEP.ViewModel    			= "models/pickaxe/pickaxe_v.mdl"
SWEP.WorldModel   			= "models/pickaxe/pickaxe_w.mdl"

SWEP.Primary.Damage			= 2
SWEP.Primary.NumShots		= 0
SWEP.Primary.Delay 			= 0.50
SWEP.Primary.ClipSize		= -1					// Size of a clip
SWEP.Primary.DefaultClip	= -1					// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.NodeFar 				= false
SWEP.BonusRange				= 5

function SWEP:SetupDataTables()
	self:NetworkVar('Entity', 0, 'Node');
	self:NetworkVar('Vector', 0, 'Bonus');
end

function SWEP:Precache()
	util.PrecacheSound("pickaxe/deploy.wav")
	util.PrecacheSound("pickaxe/hitrock.wav")
	util.PrecacheSound("pickaxe/hit.wav")
	util.PrecacheSound("pickaxe/slash.wav")
end

function SWEP:Initialize()
	self:SetWeaponHoldType("melee2")
	self.Hit 		= Sound( "pickaxe/hitrock.wav" )
	self.FleshHit 	= Sound( "pickaxe/hit.wav" )
	self.Slash		= Sound( "pickaxe/slash.wav" )
end

function SWEP:Deploy()
	self.Owner:SetViewOffset( Vector( 0, 0, 62 ) )
	self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )

	if SERVER then self:SetupFixedThink() end
	
	return true
end

function SWEP:OnDrop()
	if IsValid(self.Shield) then self.Shield:Remove() end
end

function SWEP:OnRemove()
	if IsValid(self.Shield) then self.Shield:Remove() end
end

local multiplier
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	local tgt = self.Owner:GetEyeTrace()
	
	timer.Simple(.35, function()
		if !self.Owner then return end
		if (CLIENT) then return end
		if tgt.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
			local Hit = tgt.HitPos;
			tgt = tgt.Entity
			if( tgt:IsPlayer() or tgt:IsNPC() or tgt:GetClass() == "prop_ragdoll" ) then
				self.Owner:EmitSound( self.FleshHit )
			else
				self.Owner:EmitSound( self.Hit )
			end

			multiplier = 1;

			bullet = {}
			bullet.Attacker = self.Owner
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			
			self:FireBullets(bullet) 
			self.Owner:ViewPunch( Angle(7, 0, 0) )
			
			if self.EffectActive != nil then
				self:SpellEffect( self.Owner, tgt )
			end
			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

			if (self:GetBonus() != Vector(0, 0, 0) and IsValid(self)) then
				if (Hit:DistToSqr(self:GetBonus()) < 100) then
					multiplier = 2;
					self:GenerateBonus();
				end
			end
			
			if (IsValid(tgt) and tgt:GetClass():Left(4) == 'node') then
				if tgt != self:GetNode() then
					self:SetNode(tgt);
					self:GenerateBonus();
				end
				
				if self.Owner and self.Owner:GetOrg() and self.Owner:GetOrg() == rp.Capture.Points[2].owner then
					multiplier = multiplier + 1;
				end

				self.Owner:AddMoney(self.Primary.Damage * multiplier * self:GetNode().DamageIncomeMultiplayer * 50);
				rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term((multiplier == 1) and 'MiningIncome' or 'MiningBonus'), self.Primary.Damage * multiplier * self:GetNode().DamageIncomeMultiplayer * 50);
			end
		else
			self.Weapon:EmitSound( self.Slash )
			self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		end
	end)
end

function SWEP:SecondaryAttack()	
end

function SWEP:Holster()
	if self:GetNextPrimaryFire() > CurTime() then return end
	if IsValid(self.Shield) then self.Shield:Remove() end

	return true
end

function SWEP:Remove()
	self.DestroyFixedThink();
end

local math_random = math.random;
function SWEP:GenerateBonus()
	if (!SERVER or !IsValid(self) or !IsValid(self:GetNode())) then return end
	if (self.Try and self.Try > 10) then return end
	self.Try = self.Try or 0;
	
	if self:GetNode().disabled then
		self:SetBonus(Vector(0, 0, 0));
		return
	end
	
	local Owner = self.Owner;
	local Range = self.BonusRange * self.BonusRange
	local EyeAngles = Owner:EyeAngles();

	EyeAngles = EyeAngles + Angle(
		math_random(-Range, Range),
		math_random(-Range, Range),
		0
	);

	local Trace = util.TraceLine({
		start = Owner:EyePos(),
		endpos = Owner:EyePos() + EyeAngles:Forward() * 100,
		filter = function(Entity) if (Entity:GetClass():Left(4) == 'node') then 
			return true 
		end end
	});

	if (!IsValid(Trace.Entity) or Trace.Entity:GetClass():Left(4) != 'node') then
		self:GenerateBonus();
		self.Try = self.Try + 1;
	else
		self:SetBonus(Trace.HitPos);
		self.Try = 0;
	end
end

function DestroyFixedThink(SWEP)
	SWEP:SetNode(nil);
	SWEP:SetBonus(Vector(0, 0, 0));
	timer.Remove(SWEP.FixedThink .. SWEP:EntIndex());
end

function SWEP:SetupFixedThink()
	if timer.Exists(self.FixedThink .. self.EntIndex()) then return end
	if (IsValid(self.Owner)) then
		if CLIENT then
			timer.Create(self.FixedThink .. self.EntIndex(), .05, 0, function()
				if (IsValid(self) and IsValid(self.Owner)) then
					self.HintAngle = self.HintAngle + self.HintAngleSpeed;
					if (self.HintAngle > 360) then self.HintAngle = 0; end

					if (IsValid(self:GetNode())) then
						self.NodeFar = self:GetNode():GetPos():Distance(self.Owner:GetPos()) > 80;
					end
				end
			end);
		else
			timer.Create(self.FixedThink .. self.EntIndex(), .2, 0, function()
				if IsValid(self) and IsValid(self:GetNode()) and self:GetNode().disabled then
					self:SetBonus(Vector(0, 0, 0));
				end
			end);
		end
	elseif (!IsValid(self.Owner)) then
		DestroyFixedThink(self);
	end
end

function SWEP:DrawHUD()
	if (!timer.Exists(self.FixedThink)) then self:SetupFixedThink(); end
	if (!IsValid(self.Owner) or !IsValid(self) or !IsValid(self:GetNode()) or (self:GetBonus() == Vector(0, 0, 0)) or self.NodeFar) then 
		return 
	end

	local Position = self:GetBonus():ToScreen();
	surface.SetDrawColor(255, 255, 255, 180);
	surface.SetMaterial(self.HintMaterial);
	surface.DrawTexturedRectRotated(Position.x - 32, Position.y - 32, 64, 64, self.HintAngle);
end