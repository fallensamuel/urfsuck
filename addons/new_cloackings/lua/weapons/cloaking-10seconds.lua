AddCSLuaFile()

SWEP.Author                 =   "CrimsonEclipse"
SWEP.PrintName              =   "Cloaking"
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



local function Uncloak(ply)
	ply:SetNWBool("Cloaked1", false)
	ply:SetNWBool("Cloaked2", false)
	
	ply:SetDSP(0)
    ply:DrawShadow(true)
    ply:SetRenderMode(0)
    ply:SetColor(Color(255, 255, 255, 255))
	
    ply:SetNWInt("Cloak_NextToggle", CurTime() + 1)
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

    if ply:GetNWInt("Cloak_NextToggle") <= CurTime() and not ply:GetNWBool("Cloaked1") then
        ply:SetNWBool("Cloaked1", true)
        ply:DrawShadow(false)
        ply:SetRenderMode(4)
		
    elseif ply:GetNWInt("Cloak_NextToggle") and ply:GetNWBool("Cloaked1") then
    	Uncloak(ply)
    end
end

function SWEP:CanSecondaryAttack()	
	return false
end


local getVel, transAmount, plyweap, col, Alpha, AlphaMIN, WepAlpha, is_cloaked
local math_max = math.max
local math_approach = math.Approach
local CurrentTime = CurTime
local CT

local function PlyPostThink(ply) 
	CT = CurrentTime()
	if (ply.CloakPostThinkDelay or 0) > CT then return end
	ply.CloakPostThinkDelay = CT + 0.1
	
    getVel = ply:GetVelocity()
    transAmount = math_max(0, getVel:Length() - 75)
    plyweap = ply:GetActiveWeapon()
    col = ply:GetColor()
    Alpha = math_approach(col.a, transAmount, 500 * FrameTime())

	WepAlpha = transAmount >= 200 and transAmount or 0

    if ply:GetNWFloat("Cloak_Recloaked") == nil then
		ply:SetNWFloat("Cloak_Recloaked", CT)
    end
	
	is_cloaked = ply:GetNWBool("Cloaked1")

	if is_cloaked and ply:Alive() and ply:GetNWFloat("Cloak_Recloaked") <= CT and IsValid(plyweap) then
		--print('Cloaked active 1')
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Color(255, 255, 255, Alpha))
		ply:RemoveAllDecals()
		plyweap:SetRenderMode(RENDERMODE_TRANSALPHA)
		plyweap:SetColor(Color(255, 255, 255, WepAlpha))
	end

	if not ply:GetNWBool("Cloaked2") and not is_cloaked and IsValid(plyweap) then
		--print('!Cloaked deactive 1')
		plyweap:SetRenderMode(0)
		plyweap:SetColor(Color(255, 255, 255, 255))
	end
end


local function PlyEnteredVehicle(ply, veh, seat)
	if ply:GetNWBool("Cloaked1") or ply:GetNWBool("Cloaked2") then
		Uncloak(ply)
	end
end

local function EntTookDamage(ent, dmginfo)
	if ent:IsPlayer() and (ent:GetNWBool("Cloaked1") or ent:GetNWBool("Cloaked2")) then
		ent:SetDSP(0)
    	ent:DrawShadow(true)
    	ent:SetRenderMode(0)
    	ent:SetColor(Color(255, 255, 255, 255))
    	ent:RemoveAllDecals()
        ent:SetNWFloat("Cloak_Recloaked", CurTime() + 3)
    end
end

local function QuietSteps(ply, pos, foot, sound, volume, rf)
    if (ply:GetNWBool("Cloaked1") or ply:GetNWBool("Cloaked2")) and ply:GetNWFloat("Cloak_Recloaked") <= CurTime() then
   		return true
	else
    	return false
 	end
end

local function EntFiredBullets(ent, bullet)
	if (ent:GetNWBool("Cloaked1") or ent:GetNWBool("Cloaked2")) and IsValid(ent) then
		local entweap = ent:GetActiveWeapon()
		
		ent:SetNWFloat("Cloak_Recloaked", CurTime() + (ent:GetNWBool("Cloaked1") and 1 or 5))
		ent:SetColor(Color(255, 255, 255, 255))
		ent:SetDSP(0)
		
		if IsValid(entweap) then
			entweap:SetColor(Color(255, 255, 255, 255))
		end
	end
end

local col, ent, gplytr
local function HidePlayerID()
	if CLIENT then
    	gplytr = util.GetPlayerTrace(LocalPlayer())
    	ent = util.TraceLine(gplytr).Entity
    	col = Color(255, 255, 255, 255)
		
    	if IsValid(ent) then
    		col = ent:GetColor()
    	end

    	if ent:IsPlayer() and IsValid(ent) then
    		if (ent:GetNWBool("Cloaked1") or ent:GetNWBool("Cloaked2")) and col.a <= 170 then
        		return false
        	end
        end
	end
end

local function HidePlayerTarget(_, ent)
    col = Color(255, 255, 255, 255)
    if IsValid(ent) then
    	col = ent:GetColor()
    end
	
    if _ == 'PlayerDisplay' and ent:IsPlayer() and IsValid(ent) then
    	if (ent:GetNWBool("Cloaked1") or ent:GetNWBool("Cloaked2")) and col.a <= 170 then
        	return false
        end
   end
end


local function onDemote(source, demoted, reason)
	if demoted:GetNWBool("Cloaked1") or demoted:GetNWBool("Cloaked2") then
		Uncloak(demoted)
	end
end

local function UncloakOnAccident(ply)
	Uncloak(ply)
end


hook.Add("EntityFireBullets", "CE_BC_ShotsFired1", EntFiredBullets)
hook.Add("EntityTakeDamage", "CE_BC_EntTookDamage1", EntTookDamage)
hook.Add("HUDDrawTargetID", "CE_BC_DrawTargetID1", HidePlayerID)
hook.Add("HUDShouldDraw", "CE_BC_HudDrawTargetID1", HidePlayerTarget)
hook.Add("PlayerFootstep", "CE_BC_SilentSteps1", QuietSteps)
hook.Add("PlayerPostThink", "CE_BC_PlayerPostThink1", PlyPostThink)
hook.Add("PlayerEnteredVehicle", "CE_BC_PlayerEnteredVehicle1", PlyEnteredVehicle)

hook.Add("PlayerDeath", "CE_BC_PlyDeath1" , UncloakOnAccident)
hook.Add("playerAFKDemoted", "CE_BC_PlyAFKDemote1" , UncloakOnAccident)
hook.Add("onPlayerDemoted", "CE_BC_PlyDemote1" , onDemote)
hook.Add("playerArrested", "CE_BC_PlyArrest1" , UncloakOnAccident)
hook.Add("playerStarved", "CE_BC_PlyStarved1" , UncloakOnAccident)
hook.Add("OnPlayerChangedTeam", "CE_BC_PlyChangedJob1" , UncloakOnAccident)
