-- "gamemodes\\rp_base\\entities\\weapons\\inventory\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Инвентарь"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.SelectorCategory		= translates.Get("РОЛЕПЛЕЙ")
SWEP.WeaponSelectorIcon		= 10

-- Variables that are used on both client and server
SWEP.Instructions = "ПКМ открыть инвентарь"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.Spawnable = true
SWEP.Category = "RP"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.AdminOnly = true
--[[---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType("normal")
end
--[[---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:Holster()
	return true
end

if CLIENT then
	function SWEP:SecondaryAttack()
		self:SetNextSecondaryFire(CurTime() + 1)

		hook.Run("rp.OpenInventory")
		return 
	end

	function SWEP:DrawHUD()
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(ScrW()/2, ScrH()/2 -3, 2, 8)
		surface.DrawRect(ScrW()/2 - 3, ScrH()/2, 8, 2)
	end
end

function SWEP:PrimaryAttack() end