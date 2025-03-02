include('shared.lua')

local zeroVec, zeroAng = Vector(0,0,0), Angle(0,0,0)

function SWEP:WorldModelRenderOffset()
    return zeroVec, zeroAng
end

function SWEP:DrawWorldModel()
    local owner = self.Owner

    if IsValid(owner) then
        local b = owner:LookupBone("ValveBiped.Bip01_R_Hand")
        if not b then return end
        local m = owner:GetBoneMatrix(b)
        if not m then return end
        local offsetVec, offsetAng = self:WorldModelRenderOffset()
        local newPos, newAng = LocalToWorld(offsetVec, offsetAng, m:GetTranslation(), m:GetAngles())
        self:SetRenderOrigin(newPos)
        self:SetRenderAngles(newAng)
        self:SetupBones()
    else
        self:SetRenderOrigin(self:GetPos())
        self:SetRenderAngles(self:GetAngles())
    end

    self:DrawModel()
end

function SWEP:CustomAmmoDisplay()
    self.AmmoDisplay             = self.AmmoDisplay or {}
    self.AmmoDisplay.Draw        = false -- true
    self.AmmoDisplay.PrimaryClip = self:Clip1()

    return self.AmmoDisplay
end


local InterpolateArm = function(ply, mult, twoarms)
    if not IsValid(ply) then return end
    local b1 = ply:LookupBone("ValveBiped.Bip01_R_Upperarm")
    local b2 = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
    if not b1 or not b2 then return end

    local a1, a2 = Angle(20 * mult, -62 * mult, 10 * mult), Angle(-5 * mult, -10 * mult, 0) 

    ply:ManipulateBoneAngles(b1, a1)
    ply:ManipulateBoneAngles(b2, a2)

    if twoarms then
        local b1 = ply:LookupBone("ValveBiped.Bip01_L_Upperarm")
        local b2 = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
        if not b1 or not b2 then return end
        ply:ManipulateBoneAngles(b1, a1)
    ply:ManipulateBoneAngles(b2, a2)
    end
end

net.Receive("net.newfoodsystem.InterpolateArm", function()
    local wep = net.ReadUInt(32)

    if not wep then return end

    wep = ents.GetByIndex(wep)

    if not IsValid(wep) then return end

    local two_arms = net.ReadUInt(2) or 1
    two_arms = two_arms == 2

    local ply = wep.Owner or wep:GetOwner()
    local time = wep.AnimationDuration

    if not IsValid(ply) or not ply:IsPlayer() then return end

   -- print(wep, "OK!")

    ply.FoodArmAnim_StartTime = CurTime()
    ply.FoodArmAnim_Length = time or 2

    local timer_name = "foodswep_armanim" .. ply:SteamID64()

    if timer.Exists(timer_name) then
        timer.Remove(timer_name)
    end

    timer.Create(timer_name, 0, 0, function()
        if not IsValid(ply) or not IsValid(wep) then
            timer.Remove(timer_name)
            InterpolateArm(ply, 0, two_arms)
            return
        end

        if CurTime() > ply.FoodArmAnim_StartTime + ply.FoodArmAnim_Length then
            timer.Remove(timer_name)
            InterpolateArm(ply, 0, two_arms)
            return
        end

        if ply:GetActiveWeapon() ~= wep and ply.FoodArmAnim_StartTime + 1 > CurTime() then
            timer.Remove(timer_name)
            InterpolateArm(ply, 0, two_arms)
            return
        end

        local d = (CurTime() - ply.FoodArmAnim_StartTime) / ply.FoodArmAnim_Length
        InterpolateArm(ply, math.min(math.sin(math.pi * d) * 2, 1), two_arms)
    end)
end)