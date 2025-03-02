-- "gamemodes\\darkrp\\entities\\weapons\\weapon_art_buyer_x3.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

local IsValid = IsValid

SWEP.PrintName = "Скупщик х3"

SWEP.Author = "Anus"
SWEP.Contact = ""
SWEP.Purpose = "Принимай артефакты и наркотики у сталкеров и получай деньги. Прибыль сталкера увеличивается на 30%. Чтобы принять товар сталкер должен держать его грави ганом."
SWEP.Category = "Other"

SWEP.Spawnable = true;
SWEP.AdminOnly = true
SWEP.AdminOnly		= true

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

	if not ent.itemTable then return end
	if not ent.itemTable.isArtifact then return end

	info = rp.item.artifacts.List[ent.uniqueID];

	if IsValid(owner) && !ent.TakingItem && ent:GetPos():DistToSqr(self.Owner:GetPos()) < 20000 && info && owner != self.Owner then
		ent.TakingItem = true

		self.Owner:AddMoney(info.BuyPrice/2/10)
		owner:AddMoney(info.BuyPrice*3/20)

		rp.Notify(owner, NOTIFY_GREEN, rp.Term('PlayerSoldArtToBartender'), rp.FormatMoney(info.BuyPrice*3/20))
		rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('BartenderPurchasedArtFromPly'), info.BuyPrice/2/10)

		hook.Run( "OnArtifactSold", self.Owner, owner, ent );

		ent:Remove()
	else
		self.Owner:EmitSound( 'dropweapon_6.ogg',  75 )
	end
end

