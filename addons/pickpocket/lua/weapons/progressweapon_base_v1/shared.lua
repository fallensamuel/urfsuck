/*
	Do not edit the code below unless you know what you are doing
*/
if SERVER then
	AddCSLuaFile("shared.lua")

	util.AddNetworkString("RemovePropgressBar")
	util.AddNetworkString("DrawProgressBar")
end

if CLIENT then
	SWEP.PrintName = "BaseWeapon"
	SWEP.Slot = 1
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Author = "Vend"
SWEP.Instructions = "Base weapon"
SWEP.Category = "DarkRP (Utility)"

SWEP.ViewModelFOV    = 62
SWEP.ViewModelFlip    = false

SWEP.ViewModel        = ""
SWEP.WorldModel        = ""

SWEP.HoldType = "normal"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.CheckTime = 10
SWEP.AllowedClass = "player"
SWEP.SoundDelay = 0.5
SWEP.ModelDraw = false

function net.SendSingleMessage(name, ply)
	if CLIENT then
		net.Start(name)
		net.SendToServer()
	else
		if ply then
			net.Start(name)
			net.Send(ply)
		else
			net.Start(name)
			net.Broadcast()
		end
	end
end

if CLIENT then
	FADE_DELAY = 0.3

	local panelMeta = FindMetaTable("Panel")
	function panelMeta:FadeOut(time, removeOnEnd, callback)
		self:AlphaTo(0, time, 0, function()
			if removeOnEnd then
				if self.OnRemove then
					self:OnRemove()
				end
				self:Remove()
			end
			if callback then
				callback(self)
			end
		end)
	end

	function panelMeta:FadeIn(time, callback)
		self:SetAlpha(0)
		self:AlphaTo(255, time, 0, function()
			if callback then
				callback(self)
			end
		end)
	end

	function DrawOutlinedRoundedRect(width, height, color, x, y)
		x = x or 0
		y = y or 0
		surface.SetDrawColor(color)
		surface.DrawLine(x + 1, y, x + width - 2, y)
		surface.DrawLine(x, y + 1, x, y + height - 2)
		surface.DrawLine(x + width - 1, y + 2, x + width - 1, y + height - 2)
		surface.DrawLine(x + 1, y + height - 1, x + width - 2, y + height -1)
	end

	function DrawRect(x, y, width, height, color)
		surface.SetDrawColor(color.r, color.g, color.b, color.a)
		surface.DrawRect(x, y, width, height)
	end

	/*
		MProgressBar
	*/
	local PANEL = {}

	AccessorFunc(PANEL, "Min", "Min")
	AccessorFunc(PANEL, "Max", "Max")
	AccessorFunc(PANEL, "Value", "Value")
	AccessorFunc(PANEL, "OldValue", "OldValue")
	AccessorFunc(PANEL, "Color", "Color")

	function PANEL:Init()
		self:SetSize(500, 32)
		self:SetMax(100)
		self:SetMin(0)
		self:SetValue(0)
		self:SetColor(Color(10, 10, 10, 210))
	end

	function PANEL:SetValue(value)
		self:SetOldValue(value)

		self.Value = value
	end

	function PANEL:Paint()
		DrawOutlinedRoundedRect(self:GetWide(), self:GetTall(), Color(0, 0, 0, 255))
		DrawRect(1, 1, self:GetWide()-2, self:GetTall()-2, self:GetColor())

		local width = math.min(math.Round(self:GetWide()*(self:GetOldValue()-self:GetMin())/(self:GetMax()-self:GetMin())), self:GetWide())
		local height = self:GetTall()

		DrawOutlinedRoundedRect(width, height, Color(0, 0, 0, 255), 0, (self:GetTall() - height)/2)
		DrawRect(1, (self:GetTall() - height)/2 + 1, width - 2, height - 2, self:GetColor())
	end
	derma.DefineControl( "MProgressBar", "", PANEL)

	local ProgressBar
	net.Receive("DrawProgressBar", function()
		if ProgressBar && ProgressBar:IsValid() then
			ProgressBar:Remove()
		end

		ProgressBar = vgui.Create("MProgressBar")
		ProgressBar:SetMin( 0 )
		ProgressBar:SetMax(net.ReadFloat())
		ProgressBar:Center()
		ProgressBar.lastTime = CurTime()
		ProgressBar.Think = function(self)
			self:SetValue(self:GetValue() + CurTime() - self.lastTime)
			self.lastTime = CurTime()
		end
		ProgressBar:FadeIn(FADE_DELAY)

		LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_FIST_BLOCK, false);
	end)

	net.Receive("RemovePropgressBar", function()
		LocalPlayer():AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD);

		if ProgressBar && ProgressBar:IsValid() then
			if (ProgressBar:GetValue() >= ProgressBar:GetMax() * .99) then
				LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_GIVE, true);
			end

			ProgressBar.Think = function() end
			ProgressBar:FadeOut(FADE_DELAY, true)
		end
	end)
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Deploy()
	if not self.ModelDraw then
		self.Owner:DrawViewModel(false)
		if SERVER then
			self.Owner:DrawWorldModel(false)
		end
	end
end

function SWEP:EntityCheck(ent)
	if not (IsValid(ent) and ent:GetClass() == self.AllowedClass and ent:GetPos():Distance(self.Owner:GetPos()) < 100) then
		return true
	end
	return false
end

function SWEP:GetSounds()
	return "npc/combine_soldier/gear"..math.random(6)..".wav"
end

function SWEP:CalculateTime(ent)
	return self.CheckTime
end

function SWEP:PlaySound()
	self.Owner:EmitSound(self:GetSounds(), 100, 100)
end

function SWEP:PrimaryAttack()
	if CLIENT or self.InProgress then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)

	local trace = self.Owner:GetEyeTrace().Entity
	if self:EntityCheck(trace) then return end

	self.InProgress = true

	if SERVER then
		local time = self:CalculateTime(trace)

		self.EndCheck = CurTime() + time

		net.Start("DrawProgressBar", self.Owner)
			net.WriteFloat(time)
		net.Send(self.Owner)

		timer.Create("WeaponCheckSounds", self.SoundDelay, 0, function()
			self:PlaySound()
		end)
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:Reload()
	self:PrimaryAttack()
end

function SWEP:Holster()
	if SERVER then 
		self.InProgress = false 
		timer.Destroy("WeaponCheckSounds")
		net.SendSingleMessage("RemovePropgressBar", self.Owner)
	end
	return true
end

function SWEP:Done(ent)
end

function SWEP:Succeed()
	self.InProgress = false
	
	local trace = self.Owner:GetEyeTrace().Entity
	if self:EntityCheck(trace) then return end
	
	net.SendSingleMessage("RemovePropgressBar", self.Owner)
	timer.Destroy("WeaponCheckSounds")
	
	self:Done(trace)
end

function SWEP:Fail()
	self.InProgress = false
	timer.Destroy("WeaponCheckSounds")
	net.SendSingleMessage("RemovePropgressBar", self.Owner)
end

function SWEP:Think()
	if self.InProgress and SERVER then
		local trace = self.Owner:GetEyeTrace().Entity
		if self:EntityCheck(trace) then 
			self:Fail()
		elseif self.EndCheck <= CurTime() then
			self:Succeed()
		end
	end
end