local tableinsert, pairs, isfunction, IsValid, list_Get, CurTime = table.insert, pairs, isfunction, IsValid, list.Get, CurTime
local ACT_MP_STAND_IDLE, ACT_MP_RUN, ACT_MP_WALK, MOVETYPE_NOCLIP = ACT_MP_STAND_IDLE, ACT_MP_RUN, ACT_MP_WALK, MOVETYPE_NOCLIP
local FL_ANIMDUCKING, ACT_MP_CROUCHWALK, ACT_MP_CROUCH_IDLE, ACT_MP_JUMP, ACT_MP_SWIM = FL_ANIMDUCKING, ACT_MP_CROUCHWALK, ACT_MP_CROUCH_IDLE, ACT_MP_JUMP, ACT_MP_SWIM

local mPly, mEnt, mVeh, mVec, mWep = FindMetaTable("Player"), FindMetaTable("Entity"), FindMetaTable("Vehicle"), FindMetaTable("Vector"), FindMetaTable("Weapon")  -- Жертвуем ООП ради оптимизации
local GetModel, IsOnGround, GetMoveType, GetVelocity, GetClass, IsFlagSet, LookupSequence, WaterLevel, OnGround = mEnt.GetModel, mEnt.IsOnGround, mEnt.GetMoveType, mEnt.GetVelocity, mEnt.GetClass, mEnt.IsFlagSet, mEnt.LookupSequence, mEnt.WaterLevel, mEnt.OnGround
local InVehicle, GetAllowWeaponsInVehicle, GetActiveWeapon, AnimRestartMainSequence = mPly.InVehicle, mPly.GetAllowWeaponsInVehicle, mPly.GetActiveWeapon, mPly.AnimRestartMainSequence
local GetVehicleClass = mVeh.GetVehicleClass
local Length2DSqr = mVec.Length2DSqr
local GetHoldType = mWep.GetHoldType

local GM = GM or GAMEMODE

local len2d, CalcMainAct, cIdeal, cSeq
---------------------------------------------------------------------------------
g_CalcMainActivities = g_CalcMainActivities or {
    Map   = {},
    Funcs = {}
};

rp.RegisterCalcMainActivityFunction = function( id, func )    
    if not g_CalcMainActivities.Funcs[id] then
        tableinsert(g_CalcMainActivities.Map, id);
    end
    g_CalcMainActivities.Funcs[id] = func;
end
---------------------------------------------------------------------------------
function GM:HandlePlayerDucking(ply, velocity)
    if IsFlagSet(ply, FL_ANIMDUCKING) == false then return false end

    len2d = Length2DSqr(velocity);
    if len2d > 0.25 then
        ply.CalcIdeal = ACT_MP_CROUCHWALK
    else
        ply.CalcIdeal = ACT_MP_CROUCH_IDLE
    end

    return true
end

local VehClass2Seq = {
    prop_vehicle_jeep = "drive_jeep",
    prop_vehicle_airboat = "drive_airboat"
}

local smgHack = {smg = true}

local pod_veh = {
	['prop_vehicle_prisoner_pod'] = true,
	['models/vehicles/prisoner_pod_inner.mdl'] = true,
}

function GM:HandlePlayerDriving( ply )
    if InVehicle(ply) == false then return false, false end
    local pVehicle = ply:GetVehicle()
	local drv_pod = false
	
    if not pVehicle.HandleAnimation and pVehicle.GetVehicleClass then
        local c = GetVehicleClass(pVehicle)
        local t = list_Get("Vehicles")[c]
        if t and t.Members and t.Members.HandleAnimation then
            pVehicle.HandleAnimation = t.Members.HandleAnimation
        else
            pVehicle.HandleAnimation = true
        end
    end

    if isfunction(pVehicle.HandleAnimation) then
        local seq = pVehicle:HandleAnimation(ply)
        if seq ~= nil then
            ply.CalcSeqOverride = seq
        end
    end

    if ply.CalcSeqOverride == -1 then -- pVehicle.HandleAnimation did not give us an animation
        local class = GetClass(pVehicle)
		
--[[
        if class == "prop_vehicle_jeep" then
            ply.CalcSeqOverride = LookupSequence(ply, "drive_jeep")
        elseif ( class == "prop_vehicle_airboat" ) then
            ply.CalcSeqOverride = LookupSequence(ply, "drive_airboat")
        elseif class == "prop_vehicle_prisoner_pod" and GetModel(pVehicle) == "models/vehicles/prisoner_pod_inner.mdl" then
            -- HACK!!
            ply.CalcSeqOverride = LookupSequence(ply, "drive_pd")
        else
            ply.CalcSeqOverride = LookupSequence(ply, "sit_rollercoaster")
        end
]]--
		if pod_veh[class] and pod_veh[GetModel(pVehicle)] then
			ply.CalcSeqOverride = LookupSequence(ply, "drive_pd")
			drv_pod = true
			
		else
			ply.CalcSeqOverride = LookupSequence(ply, VehClass2Seq[class] or "sit_rollercoaster")
		end
    end

    local use_anims = ply.CalcSeqOverride == LookupSequence(ply, "sit_rollercoaster") or ply.CalcSeqOverride == LookupSequence(ply, "sit")
    if use_anims and GetAllowWeaponsInVehicle(ply) and IsValid( GetActiveWeapon(ply) ) then
        local holdtype = GetHoldType( GetActiveWeapon(ply) )
        if smgHack[holdtype] then holdtype = "smg1" end

        local seqid = LookupSequence(ply, "sit_"..holdtype)
        if seqid ~= -1 then
            ply.CalcSeqOverride = seqid
        end
    end

    return true, drv_pod
end

function GM:HandlePlayerJumping(ply, velocity)
    if GetMoveType(ply) == MOVETYPE_NOCLIP then
        ply.m_bJumping = false
        return
    end

    -- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
    -- underwater we're alright we airwalking
    if not ply.m_bJumping and not OnGround(ply) and WaterLevel(ply) <= 0 then

        if not ply.m_fGroundTime then
            ply.m_fGroundTime = CurTime()
        elseif CurTime() - ply.m_fGroundTime > 0 and Length2DSqr(velocity) < 0.25 then

            ply.m_bJumping = true
            ply.m_bFirstJumpFrame = false
            ply.m_flJumpStartTime = 0
        end
    end

    if ply.m_bJumping then

        if ply.m_bFirstJumpFrame then
            ply.m_bFirstJumpFrame = false
            AnimRestartMainSequence(ply)

        end
        if WaterLevel(ply) >= 2 or (
            CurTime() - ply.m_flJumpStartTime > 0.2 and OnGround(ply)
        ) then

            ply.m_bJumping = false
            ply.m_fGroundTime = nil
            AnimRestartMainSequence(ply)

        end

        if ply.m_bJumping then
            ply.CalcIdeal = ACT_MP_JUMP
            return true
        end
    end

    return false
end

function GM:HandlePlayerSwimming(ply, velocity)

    if WaterLevel(ply) < 2 or IsOnGround(ply) then
        ply.m_bInSwim = false
        return false
    end

    ply.CalcIdeal = ACT_MP_SWIM
    ply.m_bInSwim = true

    return true
end
---------------------------------------------------------------------------------
local wep
local allowed_weps = {
	keys = true,
	weapon_hands = true,
}

local driving, drv_pod_mode
local temp_calc_ideal, temp_calc_override

function mPly:CalcMainActivity(velocity)
    self.CalcIdeal       = ACT_MP_STAND_IDLE;
    self.CalcSeqOverride = -1;

	driving, drv_pod_mode = GM:HandlePlayerDriving(self)
	
    if GM:HandlePlayerSwimming(self, velocity) 	or
		driving        	or
        GM:HandlePlayerJumping(self, velocity) 	or
        GM:HandlePlayerDucking(self, velocity) 	then
    else
        len2d = Length2DSqr(velocity);
		
        if len2d > 22500 then
			wep = self:GetActiveWeapon()
			
			if self:KeyDown(IN_SPEED) and not (self.IsProne and self:IsProne()) and (not IsValid(wep) or allowed_weps[wep:GetClass()]) and self:GetSequenceActivity(16) > 0 then
				self.CalcIdeal = ACT_HL2MP_RUN_FAST;
				
			else
				self.CalcIdeal = ACT_MP_RUN;
			end
			
        elseif len2d > 0.25 then
            self.CalcIdeal = ACT_MP_WALK;
        end
    end

    self.m_bWasOnGround   = IsOnGround(self);
    self.m_bWasNoclipping = GetMoveType(self) == MOVETYPE_NOCLIP and InVehicle(self) == false;

	if not drv_pod_mode then
		for _, CalcMainActID in pairs(g_CalcMainActivities.Map) do
			CalcMainAct = g_CalcMainActivities.Funcs[CalcMainActID];
			if not CalcMainAct then continue end
			
			cIdeal, cSeq = CalcMainAct(self, velocity, self.CalcIdeal, self.CalcSeqOverride);
			
			self.CalcIdeal       = cIdeal or self.CalcIdeal;
			self.CalcSeqOverride = cSeq   or self.CalcSeqOverride;
		end
	end
	
	temp_calc_ideal, temp_calc_override = hook.Run('CMA_Additional', self, velocity)
	
    return self.CalcIdeal, self.CalcSeqOverride;
end
local CalcMainActivity = mPly.CalcMainActivity

local CLIENT = CLIENT
--------------------------------------------------------------------------------
function GM:CalcMainActivity(ply, velocity)
    if CLIENT then CalcMainActivity(ply, velocity) end
    return ply.CalcIdeal, ply.CalcSeqOverride;
end
--------------------------------------------------------------------------------
if CLIENT then return end

hook.Add("PlayerDataLoaded", "CalcMainActivity", function(ply)
    local t_name = "CalcMainActivity"..ply:EntIndex()

    timer.Create(t_name, 1, 0, function()
        if ply == nil or IsValid(ply) == false then
            timer.Remove(t_name)
            return
        end

        CalcMainActivity(ply, GetVelocity(ply))
    end)
end)

local function SpeedUpTimer(ply)
    if ply == nil or IsValid(ply) == false then return end

    local t_name = "CalcMainActivity"..ply:EntIndex()

    local func = function()
        if ply == nil or IsValid(ply) == false then
            timer.Remove(t_name)
            return
        end

        CalcMainActivity(ply, GetVelocity(ply))
    end

    timer.Adjust(t_name, 0.1, 0, func)
    timer.Simple(1, function()
        if ply ~= nil and IsValid(ply) then
            timer.Adjust(t_name, 1, 0, func)
        end
    end)
end

hook.Add("EntityTakeDamage", "CalcMainActivity", function(vic)
    if IsValid(vic) and vic:IsPlayer() then
        SpeedUpTimer(vic)
    end
end)

hook.Add("DeathMechanics.StartDeath", "CalcMainActivity", function(ply)
    SpeedUpTimer(ply)
end)

hook.Add("OnSitAnywhere", "CalcMainActivity", function(ply)
    SpeedUpTimer(ply)
end)

hook.Add("HandlePlayerDucking", "CalcMainActivity", function(ply)
    SpeedUpTimer(ply)
end)