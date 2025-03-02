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


rp.AmmoBoxEnts = rp.AmmoBoxEnts or {}

function ENT:Initialize()
	self.UseTime 		= 0
	self.NextAnimCheck 	= 0
	self.TimeString 	= ''
	
	self.CurrentState = STATE_CLOSED
	
	table.insert(rp.AmmoBoxEnts, self)
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

function ENT:Think()
	if IsValid(LocalPlayer()) and CurTime() > self.NextAnimCheck then
		self.NextAnimCheck = CurTime() + 2
		self:CheckAnimation()
	end
	
	self:SetNextClientThink(CurTime())
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

surface.CreateFont("AmmoBoxFont", {
	font = "EuropaNuovaExtraBold",
	extended = true,
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

/*
local pos, name
function ENT:DrawBox()
	pos = self:GetPos()
	
	if pos:DistToSqr(LocalPlayer():GetPos()) > 300000 then
		return
	end

	name = self.PrintName or 'Патроны'
	
	cam_Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90) , 0.065)
		draw_SimpleTextOutlined(name, 'AmmoBoxFont', 0, -770, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		
		if self.UseTime and self.UseTime > CurTime() then
			draw_SimpleTextOutlined(self:GetRemainingTimeFormatted(), 'AmmoBoxFont', 0, -655, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		end
	cam_End3D2D()
end


local mVec 					   			   = FindMetaTable( "Vector" );
local GetNormalized, DistToSqr, Dot		   = mVec.GetNormalized, mVec.DistToSqr, mVec.Dot;
local lp

hook.Add('PostDrawTranslucentRenderables', 'AmmoBox.DrawText', function()
	if not IsValid(LocalPlayer()) then return end
	
	lp = LocalPlayer():GetPos()
	
	for k,v in pairs(rp.AmmoBoxEnts or {}) do
		if IsValid(v) then
			if not (Dot(EyeVector(), GetNormalized(lp - EyePos())) < 0.5 and DistToSqr(v:GetPos(), lp) <= 3000000) then
				continue
			end
			
			v:DrawBox() 
		else
			table.remove(rp.AmmoBoxEnts, k)
			break
		end
	end
end)
*/

net.Receive('AmmoBox.Use', function()
	local box = net.ReadEntity()
	
	if IsValid(box) then
		box.UseTime 		= net.ReadFloat()
		box.NextAnimCheck 	= CurTime()
	end
end)
