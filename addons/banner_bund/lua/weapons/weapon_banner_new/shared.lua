SWEP.PrintName 		= "Баннер"
SWEP.Slot 		= 0
SWEP.SlotPos 		= 5
SWEP.DrawAmmo 		= false
SWEP.DrawCrosshair 	= false

SWEP.HoldType		= "melee2"

SWEP.UseHands 		= true

SWEP.Author		= "-"
SWEP.Instructions	= "Да будет бунд! Поменяй картинку на R"
SWEP.Contact		= ""
SWEP.Purpose		= "Banner"
--SWEP.Category 		= "Banners"

SWEP.ViewModelFOV 	= 54
SWEP.ViewModelFlip	= false

SWEP.Spawnable		= true
SWEP.AdminOnly		= false

SWEP.ViewModel     	= Model( "models/weapons/c_banner0.mdl")
SWEP.WorldModel   	= Model( "models/weapons/w_banner0.mdl")

SWEP.Primary.Recoil 	= 0.4
SWEP.Primary.Damage 	= 1
SWEP.Primary.NumShots 	= 1
SWEP.Primary.ClipSize 	= -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic 	= false
SWEP.Primary.Ammo 	= "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.HitDistance = 80

function SWEP:Deploy()
	--self:SetURL('https://pp.vk.me/c625727/v625727756/104e5/K5FpATRXJxw.jpg')
	self:SetHoldType( "melee2" )
end

function SWEP:PrimaryAttack()
	--game.AddDecal( "megaattack", "decals/megaattack" )
	local trace = self.Owner:GetEyeTrace()
	local Pos1 = trace.HitPos + trace.HitNormal
	local Pos2 = trace.HitPos - trace.HitNormal
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 80 then

		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		local bullet = {}
		bullet.Num = self.Primary.NumShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 1
		bullet.Damage = 25
		bullet.Distance = 128
		self.Owner:FireBullets(bullet)
		--util.Decal("megaattack", Pos1, Pos2)
		self:EmitSound("phx/epicmetal_hard".. math.random( 1, 7 ) ..".wav")
		self:SetNextPrimaryFire( CurTime() + 0.5 )
	else
		self:EmitSound(Sound( "WeaponFrag.Throw" ))
		self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		self:SetNextPrimaryFire( CurTime() + 1 )
	end
end

function SWEP:SecondaryAttack()
	self:EmitSound("weapons/banner/yyyy.wav")
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self:SetNextSecondaryFire( CurTime() + 2 )
	self:SetNextPrimaryFire( CurTime() + 2 )
end

function SWEP:SetupDataTables()
	self:NetworkVar('String', 0, 'URLt')
end