include("shared.lua")

surface.CreateFont( "SimplePrinter_SmallFont", {
	font = "EuropaNuovaExtraBold",
	size = 25,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont("SimplePrinter_MedFont", {
	font = "EuropaNuovaExtraBold",
	size = 44,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

rp.client = rp.client or {}
rp.client.printers = rp.client.printers or {}

function ENT:Initialize()
	self.fanAng = 0
	--self.MaxMoneyString = string.Comma(self.MaxMoney)
	
	self.InterfaceOffset = self.InterfaceOffset or 0
	
	self.smCurAmount = 0
	self.smAlpha = 0
	
	table.insert(rp.client.printers, self)
	self.m_bInitialized = true
end

local Pos, Ang

local math_Round = math.Round
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local string_match = string.match
local math_random = math.random
local draw_DrawText = draw.DrawText
local surface_DrawRect = surface.DrawRect
local surface_SetDrawColor = surface.SetDrawColor
local math_Clamp = math.Clamp
local math_Approach = math.Approach
local string_Comma = string.Comma

function ENT:Think()
	if not self.m_bInitialized then
		self:Initialize()
	end
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < 500 then
		if self:GetIsWorking() then
			self.fanAng = self.fanAng + (FrameTime() * 400)
			
			for i = 0 , self:GetBoneCount() - 1 do
				if string.match( self:GetBoneName(i), "fan" ) ~= nil then
					self:ManipulateBoneAngles(i,Angle(self.fanAng,0,0))
				end
			end
		end
	end
end

local pr, tr, ent

function ENT:Draw()
	self:DrawModel()
--[[
	tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	Pos, Ang = self:GetPos(), self:GetAngles()
	
	self.smAlpha = math_Approach(self.smAlpha, tr.Entity == self and 1 or 0, 0.001 / RealFrameTime())
	
	if self.smAlpha > 0 then
		Owner = "Unknown"
		if IsValid(self:Getowning_ent()) then
			Owner = self:Getowning_ent():Name()
		end
		
		self.smCurAmount = math_Round(math_Approach(self.smCurAmount, self:GetCurAmount(), 0.1 / RealFrameTime()))
		pr = self:GetIsWorking() and 1 - math_Clamp((self:GetNextPrint() - CurTime()) / self.PrinterSpeed, 0, 1) or 1
		
		cam_Start3D2D(Pos + Vector(0, 0, self.InterfaceOffset), Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.11)
			draw_DrawText(Owner, "SimplePrinter_MedFont", -84.5, 100, Color(245, 245, 245, 255 * self.smAlpha), TEXT_ALIGN_CENTER)
			
			surface_SetDrawColor(0, 0, 0, 100 * self.smAlpha)
			surface_DrawRect(-170, 150, 340, 40)
			
			surface_SetDrawColor(245, 245, 245, 255 * self.smAlpha)
			surface_DrawRect(-169, 151, pr * 338, 38)
			
			--draw_DrawText(string_Comma(self.smCurMoney) .. ' / ' .. self.MaxMoneyString, "SimplePrinter_SmallFont", 0, 156,  c2, TEXT_ALIGN_CENTER)
			draw_DrawText(string_Comma(self.smCurAmount).." "..(self.ResourceName and self.ResourceName or "???"), "SimplePrinter_SmallFont", 0, 156,  Color(0, 0, 0, 255 * self.smAlpha), TEXT_ALIGN_CENTER)
		cam_End3D2D()
	end
]]--
	Pos = self:GetPos()
	
	if self:GetIsBroken() then
		local gas = ParticleEmitter(Pos)
		gas = gas:Add("particle/smokesprites_000"..math_random(1,9), Pos + Vector(math_random(-10, 10), math_random(-10, 10), 10))
		gas:SetVelocity(Vector(0, 0, 30))
		gas:SetDieTime(math.Rand(0.3,0.7))
		gas:SetStartAlpha(math.Rand(10,60))
		gas:SetEndAlpha(0)
		gas:SetStartSize(math_random(4,7))
		gas:SetEndSize(math.Rand(9,15))
		gas:SetRoll(math.Rand(180,480))
		gas:SetRollDelta(math.Rand(-1,1))
		gas:SetColor(30, 30, 30)
		gas:SetAirResistance(1)
	end
end

local ents_GetAll, Is_Valid, RealFrameTime_, LocalPly = ents.GetAll, IsValid, RealFrameTime, LocalPlayer
local Vector_, Angle_, Color_, CurTime_, TEXT_ALIGN_CENTER_ = Vector, Angle, Color, CurTime, TEXT_ALIGN_CENTER

hook.Add("PreDrawEffects", "SimplePrinters.Draw3D2D", function()
	tr = LocalPly():GetEyeTraceNoCursor()
	
	for i = 1, #(rp.client.printers or {}) do
		ent = rp.client.printers[i]
		
		if not IsValid(ent) then
			table.remove(rp.client.printers, i)
			break
		end
		
		if not ent.smAlpha then continue end

		ent.smAlpha = math_Approach(ent.smAlpha, Is_Valid(tr.Entity) and tr.Entity == ent and 1 or 0, RealFrameTime_() * 4.5)

		if ent.smAlpha < 0 then return end

		Pos = ent:GetPos()

		ent.smCurAmount = math_Round(math_Approach(ent.smCurAmount, (ent:GetCurAmount() or 0), 0.1 / RealFrameTime_()))
		pr = ent:GetIsWorking() and 1 - math_Clamp((ent:GetNextPrint() - CurTime_()) / ent.PrinterSpeed, 0, 1) or 1
		
		cam_Start3D2D(Pos + Vector_(0, 0, ent.InterfaceOffset), Angle_(0, LocalPly():EyeAngles().yaw - 90, 90), 0.11)
			draw_DrawText(Is_Valid(ent:Getowning_ent()) and ent:Getowning_ent():Name() or "Unknown", "SimplePrinter_MedFont", -84.5, 100, Color_(245, 245, 245, 255 * ent.smAlpha), TEXT_ALIGN_CENTER_)
			
			surface_SetDrawColor(0, 0, 0, 100 * ent.smAlpha)
			surface_DrawRect(-170, 150, 340, 40)
			
			surface_SetDrawColor(245, 245, 245, 255 * ent.smAlpha)
			surface_DrawRect(-169, 151, pr * 338, 38)
			
			draw_DrawText(ent.ResourceName == false and rp.FormatMoney(ent.smCurAmount) or (string_Comma(ent.smCurAmount).." "..(ent.ResourceName or "???")), "SimplePrinter_SmallFont", 0, 156,  Color_(0, 0, 0, 255 * ent.smAlpha), TEXT_ALIGN_CENTER_)
		cam_End3D2D()
	end
end)
