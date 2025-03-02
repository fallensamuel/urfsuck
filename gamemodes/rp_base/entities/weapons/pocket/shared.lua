
DEFINE_BASECLASS('mhs_weapon_base')

SWEP.PrintName 					= 'Сумка'
SWEP.Slot 						= 1
SWEP.SlotPos 					= 1
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= false

SWEP.Author 					= 'Сохранятеся после выхода'
SWEP.Instructions				= 'ЛКМ - Подобрать\n ПКМ - Открыть сумку.'
SWEP.Contact 					= ''
SWEP.Purpose 					= ''

SWEP.ViewModel 					= 'models/weapons/v_hands.mdl'
SWEP.WorldModel					= ''

SWEP.ViewModelFOV 				= 62
SWEP.ViewModelFlip 				= false

SWEP.Spawnable 					= false
SWEP.Category 					= 'RP'
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

SWEP.ViewModel = "models/weapons/c_bugbait.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

function SWEP:SecondaryAttack()
	return
end

function SWEP:Deploy()
	self:SetHoldType("normal")
	self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:OnRemove()
	BaseClass.Holster(self)	
end

function SWEP:Holster()
	self:OnRemove()
	return true
end
