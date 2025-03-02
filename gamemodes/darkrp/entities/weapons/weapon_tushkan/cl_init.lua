-- "gamemodes\\darkrp\\entities\\weapons\\weapon_tushkan\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

local cfg = tushkan.cfg
local cfgEnums = tushkan.cfgEnums
local kickCD, sprintCD = cfg[ cfgEnums.CD_KICK ], cfg[ cfgEnums.CD_SPRINT ]

local keys_names = {
    '[ЛКМ]',
    '[ПКМ]',
    '[CTRL]',
}

local abilityIcons = {
    Material('materials/tushkan/spell_1.png', 'smooth'),
    Material('materials/tushkan/spell_2.png', 'smooth'),
    Material('materials/tushkan/spell_3.png', 'smooth'),
}

local abilityCDs = {
    kickCD,
    sprintCD,
}

local abilityFilters = {
    -- Удар
    function(self, ply)
        if not IsValid(ply) then return false end

        return true
    end,

    -- Бросок
    function(self, ply)
        if not IsValid(ply) then return false end

        return true
    end,

    -- Сон
    function(self, ply)
        if not IsValid(ply) then return false end

        return true
    end,
}

local abilityNextTimes = {
    'GetNextPrimaryFire',
    'GetNextSecondaryFire',
}

local font = 'Trebuchet24'
local color_white = Color(255, 255, 255)
local w, h = 75, 75
local iconW, iconH = w*0.8, h*0.8

local function drawBox(x, y, width, height, no_filled)
    surface.SetDrawColor(22, 22, 22, 255)
    
    surface.DrawRect(x, y, 2, height)
    surface.DrawRect(x + width - 2, y, 2, height)
    surface.DrawRect(x, y, width, 2)
    surface.DrawRect(x, y + height - 2, width, 2)
    
    if not no_filled then
        surface.SetDrawColor(39, 41, 38, 218)
        surface.DrawRect(x + 2, y + 2, width - 4, height - 4)
    end
end

local function drawIcon(self, lp, abil, x, y, bActive)
    drawBox(x, y, w, h)

    surface.SetFont(font)
    local tw = surface.GetTextSize(keys_names[abil])

    surface.SetTextPos(x + ( w*0.5 - tw*0.5 ), y + h + 10)
    surface.SetTextColor(color_white)
    surface.DrawText(keys_names[abil])

    local cdFunc = self[ abilityNextTimes[abil] ]
    local cd, time

    if cdFunc then
        cd = cdFunc(self)
        time = abilityCDs[abil]
    end

    local iconX, iconY = x + (w*0.5 - iconW*0.5), y + (h*0.5 - iconH*0.5)

    if not bActive and ( not cd or cd <= CurTime() ) then
        surface.SetDrawColor(0, 0, 0, 220)
        surface.SetMaterial( abilityIcons[abil] )
        surface.DrawTexturedRect(iconX, iconY, iconW, iconH)

        return
    else
        if cd and cd > CurTime() then
            local m = (cd - CurTime()) / time

            render.SetScissorRect( iconX, iconY, iconX + iconW, iconY + (m * iconH), true )
                surface.SetDrawColor(0, 0, 0, 220)
                surface.SetMaterial( abilityIcons[abil] )
                surface.DrawTexturedRect(iconX, iconY, iconW, iconH)
            render.SetScissorRect( 0, 0, 0, 0, false )

            render.SetScissorRect( iconX, iconY + iconH, iconX + iconH, iconY + (m * iconH), true )
                surface.SetDrawColor(255, 255, 255, 220)
                surface.SetMaterial( abilityIcons[abil] )
                surface.DrawTexturedRect(iconX, iconY, iconW, iconH)
            render.SetScissorRect( 0, 0, 0, 0, false )
        else
            surface.SetDrawColor(255, 255, 255, 220)
            surface.SetMaterial( abilityIcons[abil] )
            surface.DrawTexturedRect(iconX, iconY, iconW, iconH)
        end
    end
end

function SWEP:DrawHUD()
    local x, y = ScrW()*0.5 - w*0.5, ScrH() - h - 60

    local lp = LocalPlayer()

    drawIcon(self, lp, 1, x - ( w + 2*25 ), y, abilityFilters[1](self, lp))
    drawIcon(self, lp, 2, x, y, abilityFilters[2](self, lp))
    drawIcon(self, lp, 3, x + ( w + 2*25 ), y, abilityFilters[3](self, lp))
end

hook.Add('CalcView', 'tushkan', function(ply, origin, ang, fov)
    local lp = LocalPlayer()
    local weap = lp:GetActiveWeapon()
    if not weap.IsTushkan or not IsValid(weap) then return end

    local origin = ply:GetPos() + Vector(0, 0, 65)

    local targetpos = origin - ang:Forward() * 120 + ang:Up() * 10

    local tr = util.TraceHull({
        start = origin,
        endpos = targetpos,
        filter = ply,
        mask = MASK_SHOT_HULL,
        mins = Vector(-10, -10, -10),
        maxs = Vector(10, 10, 10)
    })

    if tr.Hit then
        targetpos = tr.HitPos + (ply:GetShootPos() - tr.HitPos):GetNormal() * 10
    end

    return {
        origin = targetpos,
        angles = ang,
        fov = fov,
        drawviewer = true,
    }
end)