local SitAnyWhere_PlayerCache = {}
local SitAnyWhere_VehCache = {}

local function sit(ply, pos, ang, plyparent)
    if IsValid(plyparent) and IsValid(plyparent.customSeatParent) then return rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotSeatOnEntity')) end

    local vehicle = ents.Create("prop_vehicle_prisoner_pod")
    vehicle:SetAngles(ang)
    vehicle.customSeat = true
    vehicle:SetModel("models/nova/airboat_seat.mdl")
    vehicle:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    vehicle:SetKeyValue("limitview", "0")
    vehicle:Spawn()
    vehicle:Activate()

    if IsValid(plyparent) then
        local jtab = plyparent:GetJobTable()
        local isonbone

        jtab.PlayersCanSeatBone = "Head"
        if jtab.PlayersCanSeatBone then
            local boneid = plyparent:LookupBone(jtab.PlayersCanSeatBone)

            if boneid then
                vehicle:SetPos(plyparent:WorldToLocal(plyparent:GetBonePosition(boneid)))
                isonbone = true
            end
        end

        if not isonbone then
            vehicle:SetPos(jtab.PlayersCanSeatOffset or Vector(0, 0, plyparent:OBBMaxs().z))
        end

        vehicle:SetPos(vehicle:GetPos() + Vector(0, 0, vehicle:OBBMaxs().z))

        vehicle:SetParent(plyparent)
        plyparent.customSeatParent = vehicle

        --vehicle.Think = function()
        --    if IsValid(ply) == false or IsValid(plyparent) == false or ply:InVehicle() == false or plyparent:Alive() == false or ply:Alive() == false then
        --        vehicle:Remove()
        --    end
        --end
        table.insert(SitAnyWhere_VehCache, {
            veh = vehicle,
            plyparent = plyparent,
            ply = ply,
        })
    else
        pos = pos + vehicle:GetUp() * 18 - vehicle:GetForward() * 24
        vehicle:SetPos(pos)
        vehicle.oldpos = ply:GetPos()
    end

    vehicle:SetMoveType(MOVETYPE_PUSH)
    vehicle:GetPhysicsObject():Sleep()
    vehicle:SetCollisionGroup(COLLISION_GROUP_NONE)
    vehicle:SetNotSolid(true)
    vehicle:GetPhysicsObject():Sleep()
    vehicle:GetPhysicsObject():EnableGravity(false)
    vehicle:GetPhysicsObject():EnableMotion(false)
    vehicle:GetPhysicsObject():EnableCollisions(false)
    vehicle:GetPhysicsObject():SetMass(1)
    vehicle:DrawShadow(false)
    vehicle:SetNoDraw(true)
    vehicle.VehicleName = "Airboat Seat"
    vehicle.ClassOverride = "prop_vehicle_prisoner_pod"
    --  ply:SetAllowWeaponsInVehicle(true)
    ply:EnterVehicle(vehicle)
    ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ply.sitanythere_heal = CurTime() + 5
    SitAnyWhere_PlayerCache[ply] = true
    ply.SitAnyWhereVeh = vehicle
end

timer.Create("SitAnyWhere.VehRemover", 1, 0, function()
    for i = 1, #SitAnyWhere_VehCache do
        local data = SitAnyWhere_VehCache[i]
        if IsValid(data.ply) == false or IsValid(data.plyparent) == false or data.ply:InVehicle() == false or data.plyparent:Alive() == false or data.ply:Alive() == false then
            data.veh:Remove()
            data.plyparent.customSeatParent = nil
            table.remove(SitAnyWhere_VehCache, i)
        end
    end
end)

--rp.SitDebug = sit
hook.Add("Think", "SitAnyWhere::Think.HealPlayers", function()
    for ply in pairs(SitAnyWhere_PlayerCache) do
        if not IsValid(ply) then
            SitAnyWhere_PlayerCache[ply] = nil
            continue
        end

        if not ply:InVehicle() then
            SitAnyWhere_PlayerCache[ply] = nil
            continue
        end

        if (ply:Health() < ply:GetMaxHealth()) and (CurTime() > ply.sitanythere_heal) then
            ply:SetHealth(ply:Health() + 1)
            ply.sitanythere_heal = CurTime() + 5
        end
    end
end)

local allowed = {
    prop_physics = true,
    prop_physics_multiplayer = true
}

local vec = Vector(0, 0, .4)

rp.AddCommand("/sit", function(ply)
    if not (ply:Alive() or ply:IsVIP() or (ply.lastUse or 0) > CurTime()) then return end
    ply.lastUse = CurTime() + .3

    local jtab = ply:GetJobTable()
    if jtab.CantSitAnywhere then return end

    local trace = ply:GetEyeTrace()
    if trace.HitPos:DistToSqr(trace.StartPos) > 10000 then return end

    local is_mount = trace.Entity:IsPlayer() and trace.Entity:GetJobTable().PlayersCanSeat

    if not is_mount then
        local trace2 = util.QuickTrace(trace.StartPos, (trace.Normal - vec) * 100, ply)
        if not (trace.HitNormal.z > 0.5 and trace2.HitNormal.z < 0.5 and (trace.HitWorld or allowed[trace.Entity:GetClass()])) then return rp.Notify(ply, NOTIFY_ERROR, rp.Term("CannotSeatOnEntity")) end
    end

    local ang = (is_mount and trace.Entity or ply):GetAngles()
        --local pos = trace.HitPos
        --pos.z = pos.z - 20
        ang.pitch = 0
        ang.roll = 0
        ang.yaw = is_mount and (trace.Entity:EyeAngles().yaw) or (ang.yaw - 270)

        if is_mount then
            if trace.Entity:IsBot() then
                ply:SetEyeAngles(ang)
                sit(ply, trace.HitPos, ang, trace.Entity)
            else
                GAMEMODE.ques:Create(ply:Nick(), "mount|" .. (util.CRC(ply:SteamID() .. trace.Entity:SteamID())), trace.Entity, 10, function(resp)
                    if tobool(resp) then
                        ply:SetEyeAngles(ang)
                        sit(ply, trace.HitPos, ang, trace.Entity)
                    end
                end)
            end
        else
            ply:SetEyeAngles(ang)
            sit(ply, trace.HitPos, ang)
        end
        --ply:SetEyeAngles(ang)
        --sit(ply, trace.HitPos, ang, trace.Entity:IsPlayer() and trace.Entity or nil)
end)

hook.Add("PlayerDisconnected", "Remove_Seat_PlayerDisconnected", function(ply)
    if ply:InVehicle() then
        local veh = ply:GetVehicle()

        if IsValid(veh) and veh.customSeat then
            veh:Remove()
        end
    end
end)

hook.Add("PlayerLeaveVehicle", "Remove_Seat", function(ply, veh)
    if not IsValid(veh) or not veh.customSeat or not veh.oldpos then return end
    ply:Teleport(veh.oldpos)
    veh:Remove()
end)

local DamageInfo = DamageInfo
local DMG_VEHICLE = DMG_VEHICLE
local bit_bor = bit.bor

hook.Add("EntityTakeDamage", "SeatEntityTakeDamage", function(target, dmgInfo)
    if target.customSeat and IsValid(target:GetDriver()) then
        local victim_dmg = DamageInfo()
        victim_dmg:SetAttacker(dmgInfo:GetAttacker())
        victim_dmg:SetDamage(dmgInfo:GetDamage())
        victim_dmg:SetDamageForce(dmgInfo:GetDamageForce())
        victim_dmg:SetDamagePosition(dmgInfo:GetDamagePosition())
        victim_dmg:SetDamageType(bit_bor(dmgInfo:GetDamageType(), DMG_VEHICLE))
        victim_dmg:SetInflictor(dmgInfo:GetInflictor())
        victim_dmg:SetMaxDamage(dmgInfo:GetMaxDamage())
        target:GetDriver():TakeDamageInfo(victim_dmg)
    end
end)