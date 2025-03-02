include'shared.lua'
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

local t = {}
t['models/alakran/marijuana/pot_empty.mdl'] = 0
t['models/alakran/marijuana/pot.mdl'] = 0
t['models/alakran/marijuana/marijuana_stage1.mdl'] = 1
t['models/alakran/marijuana/marijuana_stage2.mdl'] = 2
t['models/alakran/marijuana/marijuana_stage3.mdl'] = 3
t['models/alakran/marijuana/marijuana_stage4.mdl'] = 4
t['models/alakran/marijuana/marijuana_stage5.mdl'] = 5

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Марихуана' ), 
			tr.Get( 'Горшок' ), 
		}
	else
		cached = {
			'Марихуана', 
			'Горшок', 
		}
	end

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	pos.z = (pos.z + 20) + (t[self:GetModel()] or 0)*15
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()
	local dist = pos:Distance(mypos)
	if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
	-- fancy math says we dont need to draw
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	
	cam.Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.045)
		draw.SimpleTextOutlined((self:GetModel() ~='models/alakran/marijuana/pot_empty.mdl' and cached[1] or cached[2]), '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam.End3D2D()
end