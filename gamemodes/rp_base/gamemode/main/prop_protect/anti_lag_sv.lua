require'fps'
if not engine.RealFrameTime then return end
local FPS = engine.RealFrameTime
local LagTime = 0
local FullTick = engine.TickInterval()
local AdjustedTick = FullTick * 1.3
local PropsFroze = false
local nextAction = 0

local function FreezeProps()
    for k, v in ipairs(ents.GetAll()) do
        if IsValid(v) and rp.nodamage[v:GetClass()] then
            if v.NoAutoFreeze then continue end

            local phys = v:GetPhysicsObject()

            if IsValid(phys) then
                phys:EnableMotion(false)
            end

            constraint.RemoveAll(v)
        end
    end
end

local function RemoveHighRisk()
    for k, v in ipairs(ents.GetAll()) do
        if v.HighLagRisk then
            v:Remove()
        end
    end
end

hook('Tick', 'rp.antilag.Tick', function()
    if (AdjustedTick <= FPS()) then
        LagTime = LagTime + FullTick

        if nextAction > SysTime() then return end 

        if (LagTime >= 3) and (not PropsFroze) then
            ba.notify_staff(translates.Get('Сервер немного подвисает, все пропы и энтити были заморожены.'))
            FreezeProps()
            PropsFroze = true
            nextAction = SysTime() + 10
        elseif (LagTime >= 5) then
            ba.notify_staff(translates.Get('Сервер опять подвис и некоторые пропы были удалены а энтити заморожены. Сделайте что-то!'))
            FreezeProps()
            RemoveHighRisk()
            LagTime = 0
            nextAction = SysTime() + 20
        end
    else
        LagTime = 0
        PropsFroze = false
    end
end)