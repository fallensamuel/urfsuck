AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = 'ПОЖИРАТЕЛЬ'
	SWEP.Slot = 1
	SWEP.SlotPos = 0
	SWEP.Instructions = 'ЛКМ - Стать бургером\nПКМ - Стать опять Пожирателем!'
end

SWEP.ViewModel = Model('models/weapons/v_hands.mdl')
SWEP.ViewModelFOV = 62
SWEP.WorldModel = ""
SWEP.Sound = Sound("weapons/ar2/npc_ar2_altfire.wav")

function SWEP:Precache()
	util.PrecacheSound(self.Sound)
end

function SWEP:Initialize()
	self.Owner.IsBurger = false
end

function SWEP:PrimaryAttack()
	if (self.Owner.IsBurger) then return end
	self.Owner.IsBurger = true
	self:Effect()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	if (CLIENT) then return end
	self.PreviousModel = self.Owner:GetModel()
	self.Owner:SetModel('models/food/burger.mdl')
end

function SWEP:SecondaryAttack()
	if (not self.Owner.IsBurger) then return end
	self.Owner.IsBurger = false
	self:Effect()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	if (CLIENT) then return end

	if (self.PreviousModel) then
		self.Owner:SetModel(self.PreviousModel)
	end
end

function SWEP:Holster()
	if (not self.Owner.IsBurger) then return true end
	self.Owner.IsBurger = false
	self:Effect()
	if (CLIENT) then return true end
	self.Owner:SetModel(self.PreviousModel)

	return true
end

function SWEP:Effect()
	local smoke = EffectData()
	smoke:SetOrigin(self.Owner:GetPos())
	util.Effect("effect_burgatron", smoke)
	if (CLIENT) then return end
	self.Owner:EmitSound(self.Sound)
end