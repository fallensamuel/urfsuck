include('shared.lua')

function SWEP:CalcView(ply, pos, ang, fov)
    return pos - Vector(0, 0, 40)
end

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end