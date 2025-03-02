-- "gamemodes\\darkrp\\entities\\weapons\\weapon_psevdogiant\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")

function SWEP:CalcView(ply, pos, ang, fov)
    return ply:GetPos() + Vector(0, 0, 50)
end

function SWEP:AdjustMouseSensitivity()
	if self.Owner:GetRunSpeed() == self.pRunSpeed then
		return 0.06
	end
end

function SWEP:OnRemove()
    self:Holster()
end

function SWEP:Holster()
	-- timer.Destroy("PsevdogiantWalk"..self:EntIndex())
	-- timer.Destroy("PsevdogiantRun"..self:EntIndex())
    return true
end

-- function SWEP:SecondaryAttack()
-- 	if self.IsSleep then return end
-- 	if self.Secondaryfire then return end
-- 	self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("stand_kick_0"), 0, true)
-- 	self.Secondaryfire = true
-- 	timer.Simple(self.pSecondaryTime, function()
-- 		self.Secondaryfire = nil
-- 	end)
-- end

-- function SWEP:PrimaryAttack()
-- 	if self.IsSleep then return end
-- 	if self.Primaryfire then return end
-- 	self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("stand_attack_1"), 0, true)
-- 	self.Primaryfire = true
-- 	timer.Simple(self.pPrimaryTime, function()
-- 		self.Primaryfire = nil
-- 	end)
-- end

hook.Add("PlayerBindPress", "PsevdogiantDisableJump", function(ply, bind, pressed)
	if string.find(bind, "+jump") and ply:GetNWBool("IsPsevdogiant") then return true end
	if (string.find(bind, "+moveleft") or string.find(bind, "+moveright") or string.find(bind, "+back")) and ply:GetNWBool("IsPsevdogiant") and ply:GetRunSpeed() == ply:GetActiveWeapon().pRunSpeed then return true end
end)

-- function SWEP:Think()
-- 	if not cvar.GetValue('enable_thirdperson') then
-- 		cvar.SetValue('enable_thirdperson', true)
-- 	end
-- end