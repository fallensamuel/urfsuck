AddCSLuaFile()

SWEP.Author                 =   "CrimsonEclipse"
SWEP.PrintName              =   "Active Cloaking"
SWEP.Base                   =   "weapon_base"
SWEP.Instructions           =   [[Left-Click: Toggle Cloak
Right-Click: N/A]]
SWEP.Category = "Root"
SWEP.Spawnable              =   true
SWEP.AdminOnly 				= 	true

SWEP.ViewModelFlip          =   false
SWEP.UseHands               =   false
SWEP.ViewModel              =   "models/weapons/v_hands.mdl"
SWEP.WorldModel             =   ""
SWEP.HoldType               =   "normal"

SWEP.AutoSwitchTo           =   false
SWEP.AutoSwithFrom          =   false
SWEP.Slot                   =   4
SWEP.SlotPos                =   0

SWEP.DrawAmmo               =   false
SWEP.DrawCrosshair          =   false
SWEP.m_WeaponDeploySpeed 	= 	100
SWEP.OnRemove = onDeathDropRemove
SWEP.OnDrop = onDeathDropRemove

SWEP.Primary.ClipSize       =   0
SWEP.Primary.DefaultClip    =   0
SWEP.Primary.Ammo           =   "rpg"
SWEP.Primary.Automatic      =   false
 
SWEP.Secondary.ClipSize     =   -1
SWEP.Secondary.DefaultClip  =   -1
SWEP.Secondary.Ammo         =   "none"
SWEP.Secondary.Automatic    =   false

local CloakOverlay
if CLIENT then
	CloakOverlay = surface.GetTextureID("camo/camo_overlay.vmt")
end

local CamoActivate 		= Sound("camo/camo_on.wav")
local CamoDeactivate 	= Sound("camo/camo_off.wav")

local AlphaStand 	= 0
local AlphaCrouch 	= 0
local AlphaWalk 	= 179
local AlphaRun 		= 255



local function Uncloak(ply)
	ply:SetNWBool("Cloaked1", false)
	ply:SetNWBool("Cloaked2", false)
	
	ply:SetDSP(0)
    ply:DrawShadow(true)
    ply:SetRenderMode(0)
    ply:SetColor(Color(255, 255, 255, 255))
	
    ply:SetNWInt("Cloak_NextToggle", CurTime() + 1)
	
	if CLIENT then
		surface.PlaySound(CamoDeactivate)
	end
end


function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end
 
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end

function SWEP:Equip()
	local ply = self.Owner
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
    local plypos =  ply:GetPos()

	if ply:GetNWInt("Cloak_NextToggle") == nil then
		ply:SetNWInt("Cloak_NextToggle", CurTime())
	end

    if ply:GetNWInt("Cloak_NextToggle") <= CurTime() and not ply:GetNWBool("Cloaked2") then
        ply:SetNWBool("Cloaked2", true)
        ply:DrawShadow(false)
        ply:SetRenderMode(4)
		
		if CLIENT then
			surface.PlaySound(CamoActivate)
		end
    elseif ply:GetNWInt("Cloak_NextToggle") and ply:GetNWBool("Cloaked2") then
    	Uncloak(ply)
    end
end

function SWEP:CanSecondaryAttack()	
	return false
end


local ply_speed, getVel, plyweap, transAmount, col, Alpha, AlphaMIN, WepAlpha, is_cloaked
local math_max = math.max
local math_pow = math.pow
local math_approach = math.Approach
local CurrentTime = CurTime
local CT

local function PlyPostThink(ply) 
	CT = CurrentTime()
	if (ply.CloakPostThinkDelay or 0) > CT then return end
	ply.CloakPostThinkDelay = CT + 0.1
	
    getVel = ply:GetVelocity():LengthSqr()
    plyweap = ply:GetActiveWeapon()
    col = ply:GetColor()
	
	if not ply.CloakSpeedWalk then
		ply.CloakSpeedWalk = math_pow(ply:GetWalkSpeed(), 2) - 2
		ply.CloakSpeedCrouch = math_pow(ply:GetCrouchedWalkSpeed(), 2) * ply.CloakSpeedWalk - 2
		ply.CloakSpeedRun = math_pow(ply:GetRunSpeed(), 2) - 2
	end
	
	is_cloaked = ply:GetNWBool("Cloaked2")
	
	if is_cloaked then
		transAmount = getVel >= ply.CloakSpeedRun and AlphaRun or getVel >= ply.CloakSpeedWalk and AlphaWalk or getVel >= ply.CloakSpeedCrouch and AlphaCrouch or AlphaStand
		Alpha = math_approach(col.a, transAmount, 500 * FrameTime())
		WepAlpha = transAmount >= 100 and transAmount or 0
	end
	
    if ply:GetNWFloat("Cloak_Recloaked") == nil then
		ply:SetNWFloat("Cloak_Recloaked", CT)
    end

	if is_cloaked and ply:Alive() and ply:GetNWFloat("Cloak_Recloaked") <= CT and IsValid(plyweap) then
		--print('Cloaked active 2')
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Color(255, 255, 255, Alpha))
		ply:RemoveAllDecals()
		plyweap:SetRenderMode(RENDERMODE_TRANSALPHA)
		plyweap:SetColor(Color(255, 255, 255, WepAlpha))
	end
	
	if not ply:GetNWBool("Cloaked1") and not is_cloaked and IsValid(plyweap) then
		--print('!Cloaked deactive 2')
		plyweap:SetRenderMode(0)
		plyweap:SetColor(Color(255, 255, 255, 255))
	end
end

local ply
local function DrawCloakOverlay()
	ply = LocalPlayer()
	if ply:GetNWBool("Cloaked2") and ply:GetNWFloat("Cloak_Recloaked") <= CurTime() then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(CloakOverlay)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end


if CLIENT then
	local colorMofify = {
		["$pp_colour_addr"] 		= 0,
		["$pp_colour_addg"] 		= 0,
		["$pp_colour_addb"] 		= 0,
		["$pp_colour_brightness"] 	= 0,
		["$pp_colour_contrast"] 	= 1,
		["$pp_colour_colour"] 		= 0,
		["$pp_colour_mulr"] 		= 0,
		["$pp_colour_mulg"] 		= 0,
		["$pp_colour_mulb"] 		= 0
	}

	local percent
	local function DrawCamoEffects()
		if LocalPlayer():GetNWBool("Cloaked2") and LocalPlayer():GetNWFloat("Cloak_Recloaked") <= CurTime() then
			percent = LocalPlayer():GetColor().a / 255
			
			colorMofify["$pp_colour_colour"] = percent
			DrawColorModify(colorMofify)
			
			DrawMotionBlur(0.1 + percent * 0.9, 0.5, 0.01)
			DrawToyTown(2,ScrH()/2)
		end
	end
	
	hook.Add("RenderScreenspaceEffects", "CE_BC_ShowCamoEffectsCloak", DrawCamoEffects)
	hook.Add("HUDPaint", "CE_BC_DrawEffects11", DrawCloakOverlay)
end

hook.Add("PlayerPostThink", "CE_BC_PlayerPostThink11", PlyPostThink)
