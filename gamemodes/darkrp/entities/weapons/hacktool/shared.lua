-- "gamemodes\\darkrp\\entities\\weapons\\hacktool\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.PrintName = "Взломщик"
SWEP.Author = "Chorbier"
SWEP.Purpose = "Взламывает кейпады и энергополя"

SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/c_hacktool.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_hacktool.mdl" )
SWEP.ViewModelFOV = 50
SWEP.UseHands = true

SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.AdminOnly = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local panelRt, panelMat, vmatrt, vmmat

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsHacking")
    self:NetworkVar("Entity", 0, "HackingEnt")
    self:NetworkVar("Float", 0, "NextUseTime")

    self:NetworkVar("Int", 1, "ErrorId")
    self:NetworkVar("Float", 1, "LastErrorTime")

    self:NetworkVar("Bool", 1, "IsOwnerFailedHack")
end

function SWEP:Holster()
	timer.Stop( "weapon_idle" .. self:EntIndex() )

	if SERVER then self:Fail() end
	return true
end