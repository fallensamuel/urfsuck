-- "gamemodes\\rp_base\\entities\\weapons\\weapon_bird\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

include('shared.lua')

function SWEP:ShouldDrawViewModel()
    return false
end

function SWEP:CalcView(ply, pos, ang, fov)
    return pos - Vector(0,0,50)
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end