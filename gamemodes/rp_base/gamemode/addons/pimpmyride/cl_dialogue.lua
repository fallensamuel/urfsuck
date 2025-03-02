-- "gamemodes\\rp_base\\gamemode\\addons\\pimpmyride\\cl_dialogue.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function __interract(pl, key)
	if key ~= IN_USE then return end
	local tr = pl:GetEyeTrace()
	local ent = tr.Entity
	local f = ent.Interract
	if !f then return end
	local d = (tr.StartPos - tr.HitPos):Length2DSqr()
	if d > 8100 then return end
	f(ent, pl)
end

hook.Add("KeyPress", "__interract", __interract)

local bobvalue = 0

local function __dview(pl, origin, angles, fov, znear, zfar)
	local mtx = URF.TalkingEntity:GetBoneMatrix(URF.LookAtBone)
	local pos, ang = mtx:GetTranslation(), mtx:GetAngles()
	local view = {}
	bobvalue = math.Approach(bobvalue, 1, 0.01)
	local dir = (pos - origin):GetNormalized():Angle()
	view.origin = origin
	view.angles = LerpAngle(bobvalue, angles, dir)
	view.fov = Lerp(bobvalue, fov, 33)
	view.znear = 5
	view.zfar = zfar
	view.drawviewer = false

	return view
end

local function __dhidehud(n)
	return n == "CHudMenu"
end

local function __dhidewpn()
	return Vector(math.huge, math.huge, math.huge), angle_zero 
end