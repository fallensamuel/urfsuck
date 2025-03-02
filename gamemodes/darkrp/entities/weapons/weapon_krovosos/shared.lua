-- "gamemodes\\darkrp\\entities\\weapons\\weapon_krovosos\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿AddCSLuaFile()
SWEP.PrintName = 'Bloodsucker'

SWEP.WorldModel = ""
SWEP.ViewModel = ""
--SWEP.Spawnable			= true
SWEP.AdminOnly = true

SWEP.HitDistance = 200

SWEP.jGravity 		= 0.9
SWEP.jJumpPower 	= 300
SWEP.jSpeed	 		= 140
SWEP.jDamage		= 250
SWEP.jHealPerAttack	= 5
SWEP.jPrimaryTime	= 2
SWEP.jSecondaryTime	= 3

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo 			= false
SWEP.DrawCrosshair      = true
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.Sounds = 
{ 
	Attack		= "hgn/stalker/creature/bs/attack_0.mp3"
}

SWEP.IdleTranslate = {};

SWEP.IdleTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]  = ACT_GMOD_GESTURE_RANGE_ZOMBIE;
SWEP.IdleTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL;

SWEP.IdleTranslate[ACT_MP_STAND_IDLE] 				 = ACT_HL2MP_IDLE_ZOMBIE;
--SWEP.IdleTranslate[ACT_MP_CROUCH_IDLE] 			 = ACT_HL2MP_IDLE_ZOMBIE;
SWEP.IdleTranslate[ACT_MP_CROUCH_IDLE]               = ACT_HL2MP_IDLE_CROUCH_ZOMBIE;
SWEP.IdleTranslate[ACT_MP_CROUCHWALK] 				 = ACT_HL2MP_WALK_ZOMBIE_01;
SWEP.IdleTranslate[ACT_MP_WALK] 					 = ACT_HL2MP_WALK_ZOMBIE_01;
SWEP.IdleTranslate[ACT_MP_RUN] 						 = ACT_HL2MP_RUN_ZOMBIE;

--SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
--SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_WALK;
--SWEP.IdleTranslate[ ACT_MP_RUN ]                            = ACT_RUN;
--SWEP.IdleTranslate[ ACT_MP_CROUCH_IDLE ]                    = ACT_WALK;
--SWEP.IdleTranslate[ ACT_MP_CROUCHWALK ]                     = ACT_WALK;
--SWEP.IdleTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]       = ACT_MELEE_ATTACK1;
--SWEP.IdleTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
--SWEP.IdleTranslate[ ACT_MP_RELOAD_STAND ]                   = ACT_RELOAD;
--SWEP.IdleTranslate[ ACT_MP_RELOAD_CROUCH ]                  = ACT_RELOAD;
--SWEP.IdleTranslate[ ACT_MP_JUMP ]                           = ACT_JUMP;
--SWEP.IdleTranslate[ ACT_MP_SWIM_IDLE ]                      = ACT_JUMP;
--SWEP.IdleTranslate[ ACT_MP_SWIM ]                           = ACT_JUMP;
--SWEP.IdleTranslate[ ACT_GMOD_NOCLIP_LAYER]                  = ACT_GLIDE;
--SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;

function SWEP:Initialize()
	self:SetHoldType( "fist" );
end

function SWEP:TranslateActivity( act )
 	return self.IdleTranslate[act] or act;
end



local function Uncloak(ply)
	ply:SetNWBool("Cloaked", false)
	
	ply:SetDSP(0)
    ply:DrawShadow(true)
    ply:SetRenderMode(0)
    ply:SetColor(Color(255, 255, 255, 255))
	
    ply:SetNWInt("Cloak_NextToggle", CurTime() + 1)
end

local ply_speed, getVel, plyweap, transAmount, col, Alpha, AlphaMIN, WepAlpha, is_cloaked
local math_max = math.max
local math_pow = math.pow
local math_approach = math.Approach

local AlphaStand 	= 0
local AlphaCrouch 	= 0
local AlphaWalk 	= 179
local AlphaRun 		= 255

local function PlyPostThink(ply) 
    getVel = ply:GetVelocity():LengthSqr()
    plyweap = ply:GetActiveWeapon()
    col = ply:GetColor()
	
	if not ply.CloakSpeedWalk then
		ply.CloakSpeedWalk = math_pow(ply:GetWalkSpeed(), 2) - 2
		ply.CloakSpeedCrouch = math_pow(ply:GetCrouchedWalkSpeed(), 2) * ply.CloakSpeedWalk - 2
		ply.CloakSpeedRun = math_pow(ply:GetRunSpeed(), 2) - 2
	end
	
	is_cloaked = ply:GetNWBool("Cloaked")
	
	if is_cloaked then
		transAmount = getVel >= ply.CloakSpeedRun and AlphaRun or getVel >= ply.CloakSpeedWalk and AlphaWalk or getVel >= ply.CloakSpeedCrouch and AlphaCrouch or AlphaStand
		Alpha = math_approach(col.a, transAmount, 500 * FrameTime())
		WepAlpha = transAmount >= 100 and transAmount or 0
	end
	
    if ply:GetNWFloat("Cloak_Recloaked") == nil then
		ply:SetNWFloat("Cloak_Recloaked", CurTime())
    end

	if is_cloaked and ply:Alive() and ply:GetNWFloat("Cloak_Recloaked") <= CurTime() and IsValid(plyweap) then
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Color(255, 255, 255, Alpha))
		ply:RemoveAllDecals()
		plyweap:SetRenderMode(RENDERMODE_TRANSALPHA)
		plyweap:SetColor(Color(255, 255, 255, WepAlpha))
	end
	
	if not is_cloaked and IsValid(plyweap) then
		plyweap:SetRenderMode(0)
		plyweap:SetColor(Color(255, 255, 255, 255))
	end
end

local function PlyEnteredVehicle(ply, veh, seat)
	if ply:GetNWBool("Cloaked") then
		Uncloak(ply)
	end
end
 
local function EntTookDamage(ent, dmginfo)
	if ent:IsPlayer() and ent:GetNWBool("Cloaked") then
		ent:SetDSP(0)
    	ent:DrawShadow(true)
    	ent:SetRenderMode(0)
    	ent:SetColor(Color(255, 255, 255, 255))
    	ent:RemoveAllDecals()
        ent:SetNWFloat("Cloak_Recloaked", CurTime() + 3)
    end
end

local function QuietSteps(ply, pos, foot, sound, volume, rf)
    if ply:GetNWBool("Cloaked") and ply:GetNWFloat("Cloak_Recloaked") <= CurTime() then
   		return true
	else
    	return false
 	end
end

local function EntFiredBullets(ent, bullet)
	if ent:GetNWBool("Cloaked") and IsValid(ent) then
		local entweap = ent:GetActiveWeapon()
		
		ent:SetNWFloat("Cloak_Recloaked", CurTime() + 5)
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
    		if ent:GetNWBool("Cloaked") and col.a <= 170 then
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
    	if ent:GetNWBool("Cloaked") and col.a <= 170 then
        	return false
        end
   end
end


local function onDemote(source, demoted, reason)
	if demoted:GetNWBool("Cloaked") then
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