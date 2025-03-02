AddCSLuaFile()

local IsValid = IsValid

SWEP.PrintName = "Скупщик"

SWEP.Author = "Anus"
SWEP.Contact = ""
SWEP.Purpose = "Принимай наркотики у игроков и получай деньги. Прибыль игрока увеличивается на 30%. Чтобы принять товар игрок должен держать его в руках."
SWEP.Category = "Other"

SWEP.Spawnable = true;
SWEP.AdminOnly = true

SWEP.UseHands = true

SWEP.Slot					= 0
SWEP.SlotPos				= 4

SWEP.DrawAmmo				= false


SWEP.WorldModel = ""
SWEP.ViewModel = ""


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

local ent, owner, info
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.3)

	if CLIENT then return end

	ent = self.Owner:GetEyeTrace().Entity
	owner = ent.holder
	info = rp.Drugs[ent:GetClass()] or rp.Drugs[ent.weaponclass]
	if IsValid(owner) && ent:GetPos():DistToSqr(self.Owner:GetPos()) < 20000 && info && owner != self.Owner then

		self.Owner:AddMoney(info.BuyPrice/10)
		owner:AddMoney(info.BuyPrice*1.3)

		rp.Notify(owner, NOTIFY_GREEN, rp.Term('PlayerSoldArtToBartender'), rp.FormatMoney(info.BuyPrice*1.3))		
		rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('BartenderPurchasedArtFromPly'), info.BuyPrice/10)

		ent:Remove()
	end
end

