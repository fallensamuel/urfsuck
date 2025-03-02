
include('shared.lua')

function SWEP:CalcView(ply, pos, ang, fov)
    return pos - Vector(0,0,50)
end