include 'shared.lua'

local cam_Start3D2D 			= cam.Start3D2D
local cam_End3D2D 				= cam.End3D2D
local draw_SimpleTextOutlined 	= draw.SimpleTextOutlined
local LocalPlayer 				= LocalPlayer
local CurTime 					= CurTime
local math_ceil 				= math.ceil

local color_white 				= Color(245, 245, 245)
local color_black 				= Color(0, 0, 0)

local STATE_CLOSED = 0
local STATE_OPENED = 1


rp.Capture.ClientBoxes = rp.Capture.ClientBoxes or {}

function ENT:Initialize()
	self.UseTime 		= 0
	self.NextAnimCheck 	= 0
	self.TimeString 	= ''
	
	rp.Capture.ClientBoxes[#rp.Capture.ClientBoxes + 1] = self
	
	self.CurrentState = STATE_CLOSED
end

local next_state
function ENT:CheckAnimation()
	next_state = (self.UseTime > CurTime() or not self:HasAccess(LocalPlayer())) and STATE_CLOSED or STATE_OPENED
	
	if self.CurrentState and LocalPlayer():GetPos():DistToSqr(self:GetPos()) > 1000000 then
		self.CurrentState = nil
	end
	
	if self.CurrentState ~= next_state and LocalPlayer():IsLineOfSightClear(self:GetPos()) then
		self.CurrentState = next_state
		
		self:ResetSequence(next_state == STATE_CLOSED and 'open' or 'close') 
		self:SetBodygroup(1, next_state == STATE_CLOSED and 0 or 1)
	end
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Бонусы территории' ), 
		}
	else
		cached = {
			'Бонусы территории', 
		}
	end

function ENT:Think()
	if IsValid(LocalPlayer()) and CurTime() > self.NextAnimCheck then
		self.NextAnimCheck = CurTime() + 2
		self:CheckAnimation()
	end
	
	self:NextThink(CurTime())
	return true
end

local cur_time
function ENT:GetRemainingTimeFormatted()
	cur_time = math_ceil(self.UseTime - CurTime())
	
	if not self.TimeString or cur_time ~= self.SavedTime then
		self.TimeString	= string.FormattedTime(cur_time, '%02i:%02i')
		self.SavedTime 	= cur_time
	end
	
	return self.TimeString
end

function ENT:Draw()
	self:DrawModel()
end

local pos, name
function ENT:DrawBox()
	pos = self:GetPos()
	
	if pos:DistToSqr(LocalPlayer():GetPos()) > 300000 or not self:HasAccess(LocalPlayer()) then
		return
	end

	name = rp.Capture.Points[self:GetCapturePoint()]
	name = name and name.Boxes[self:GetBoxId()].printName or cached[1] or ''
	
	cam_Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90) , 0.065)
		draw_SimpleTextOutlined(name, '3d2d', 0, -800, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		
		if self.UseTime and self.UseTime > CurTime() then
			draw_SimpleTextOutlined(self:GetRemainingTimeFormatted(), '3d2d', 0, -655, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end
	cam_End3D2D()
end


net.Receive('Capture.Rewards.BoxUse', function()
	local box = net.ReadEntity()
	
	box.UseTime 		= net.ReadFloat()
	box.NextAnimCheck 	= CurTime()
end)
