-- "gamemodes\\rp_base\\entities\\weapons\\keypad_cracker\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

if (SERVER) then
	util.AddNetworkString("KeypadCracker_Hold")
	util.AddNetworkString("KeypadCracker_Sparks")
end

if (CLIENT) then
	SWEP.PrintName = "Взломщик"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Instructions = "ЛКМ для взлома"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")
SWEP.Spawnable = false
SWEP.AnimPrefix = "python"
SWEP.Sound = Sound("weapons/deagle/deagle-1.wav")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
SWEP.KeyCrackTime = 30
SWEP.KeyCrackSound = Sound("buttons/blip2.wav")
SWEP.IdleStance = "slam"

function SWEP:Initialize()
	self:SetHoldType(self.IdleStance)

	if (SERVER) then
		net.Start("KeypadCracker_Hold")
		net.WriteEntity(self)
		net.WriteBit(true)
		net.Broadcast()
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.4)

	if IsValid(self.Owner) and self.Owner:GetTeamTable().keypadcracktime then
		self.KeyCrackTime = 30 * self.Owner:GetTeamTable().keypadcracktime
	else
		self.KeyCrackTime = 30
	end

	if (self.IsCracking or not IsValid(self.Owner)) then return end
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	self.DoorLockpicking = ent

	if (IsValid(ent) and tr.HitPos:Distance(self.Owner:GetShootPos()) <= 50 and (ent:GetClass() == "keypad" or ent:GetClass() == "urf_keypad" or ent:GetClass() == "urf_keypad_advanced" or ent:GetClass() == "keypad_wire" or ent.isForceField)) then
		self.IsCracking = true
		self.StartCrack = CurTime()
		self.EndCrack = CurTime() + self.KeyCrackTime
		self:SetHoldType("pistol") -- TODO: Send as networked message for other clients to receive

		if (SERVER) then
			net.Start("KeypadCracker_Hold")
			net.WriteEntity(self)
			net.WriteBit(true)
			net.Broadcast()

			timer.Create("KeyCrackSounds: " .. self:EntIndex(), 1, self.KeyCrackTime, function()
				if (IsValid(self) and self.IsCracking) then
					self:EmitSound(self.KeyCrackSound, 50, 100)
				end
			end)
		end

		hook.Call('PlayerStartKeypadCrack', nil, self.Owner, tr.Entity)
	end
end

function SWEP:Holster()
	self.IsCracking = false

	if (SERVER) then
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	end

	return true
end

function SWEP:Reload()
	return true
end

function SWEP:Succeed()
	self.IsCracking = false
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	self:SetHoldType(self.IdleStance)

	if SERVER and IsValid(ent) and tr.HitPos:Distance(self.Owner:GetShootPos()) <= 50 then
		if (ent:GetClass() == "keypad" or ent:GetClass() == "urf_keypad" or ent:GetClass() == "urf_keypad_advanced" or ent:GetClass() == "keypad_wire") then
			ent:Process(true)
			net.Start("KeypadCracker_Hold")
			net.WriteEntity(self)
			net.WriteBit(true)
			net.Broadcast()
			net.Start("KeypadCracker_Sparks")
			net.WriteEntity(ent)
			net.Broadcast()
			hook.Call('PlayerFinishKeypadCrack', nil, self.Owner, ent)
		elseif ent.isForceField then
			ent.lastUsed = CurTime() + 15
			ent:Disable()
			hook.Call('PlayerFinishForcefieldCrack', nil, self.Owner, ent)
		end
	end

	if (SERVER) then
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	end
end

function SWEP:Fail()
	self.IsCracking = false
	self:SetHoldType(self.IdleStance)

	if (SERVER) then
		net.Start("KeypadCracker_Hold")
		net.WriteEntity(self)
		net.WriteBit(true)
		net.Broadcast()
		timer.Destroy("KeyCrackSounds: " .. self:EntIndex())
	end
end

function SWEP:Think()
	if (not self.StartCrack) then
		self.StartCrack = 0
		self.EndCrack = 0
	end

	if (self.IsCracking and IsValid(self.Owner)) then
		local tr = self.Owner:GetEyeTrace()

		if SERVER then
			local status = ((CurTime() - self.StartCrack)/(self.EndCrack - self.StartCrack))*100
			if status > 50 && (math.random(1,100) == 1 || status < 90) && !self.DoorLockpicking:GetNetVar("IsAlarming") then
				if rp.cfg.DoorsSignaling and rp.cfg.DoorsSignaling[self.DoorLockpicking:GetClass()] then
					self.DoorLockpicking:SetNetVar("IsAlarming",true)
					if timer.Exists("IsAlarming"..self:EntIndex()) then timer.Destroy("IsAlarming"..self:EntIndex()) end
					if timer.Exists("AlarmSound"..self:EntIndex()) then timer.Destroy("AlarmSound"..self:EntIndex()) end
					timer.Create("IsAlarming"..self:EntIndex(),30,1,function()
						if !IsValid(self) && !IsValid(self.DoorLockpicking) then return end
						timer.Destroy("AlarmSound"..self:EntIndex())
						self.DoorLockpicking:SetNetVar("IsAlarming",false)
					end)
					timer.Create("AlarmSound"..self:EntIndex(),2,0,function()
						if !IsValid(self) then return end
						self:EmitSound("ambient/alarms/klaxon1.wav")
					end)
				end
			end
		end

		if (not IsValid(tr.Entity) or tr.HitPos:Distance(self.Owner:GetShootPos()) > 50 or (tr.Entity:GetClass() ~= "keypad" and tr.Entity:GetClass() ~= "urf_keypad" and tr.Entity:GetClass() ~= "urf_keypad_advanced" and tr.Entity:GetClass() ~= "keypad_wire" and !tr.Entity:GetClass():find('forcefield'))) then
			self:Fail()
		elseif (self.EndCrack <= CurTime()) then
			self:Succeed()
		end
	else
		self.StartCrack = 0
		self.EndCrack = 0
	end

	self:NextThink(CurTime())

	return true
end

if (CLIENT) then
	local WhiteCircle = Material('deathmechanics/circle');
	local GrayCircle = Material('deathmechanics/cline');
	local YellowCircle = Material('deathmechanics/gline');
	local Icon = Material('urfim_hud/icons/weapons/keypad_cracker');

	local Width, Height, Poly;
	local Diameter, Radius, Radian;
	local StartX, StartY, CenterX, CenterY;
	local Time, MaxTime;

	local Rad, Sin, Cos = math.rad, math.sin, math.cos;
	local GetScrW, GetScrH = ScrW, ScrH;
	local Floor = math.floor;

	local SetStencilCompareFunction = render.SetStencilCompareFunction;
	local SetStencilFailOperation = render.SetStencilFailOperation;
	local ExperimentalStencil = rpui.ExperimentalStencil;
	local DrawTexturedRect = surface.DrawTexturedRect;
	local SetDrawColor = surface.SetDrawColor;
	local SetMaterial = surface.SetMaterial;
	local NoTexture = draw.NoTexture;
	local DrawPoly = surface.DrawPoly;

	function SWEP:DrawHUD()
		if (!self.IsCracking) then return end

		if (not self.StartCrack) then
			self.StartCrack = CurTime();
			self.EndCrack = CurTime() + self.KeyCrackTime;
		end

		Width, Height = GetScrW(), GetScrH();

		Diameter = Height * .1;
		Radius = Diameter * .5;
		Radian = Rad(0);

		StartX = (Width - Diameter) * .5;
		StartY = (Height - Diameter) * .5;
		CenterX = StartX + Radius;
		CenterY = StartY + Radius;

		Poly = {};

		Poly[#Poly + 1] = {x = StartX + Radius, y = StartY + Radius};
		Poly[#Poly + 1] = {x = CenterX - Sin(Radian) * Radius, y = CenterY - Cos(Radian) * Radius};

		MaxTime = self.EndCrack - self.StartCrack;
		Time = self.EndCrack - CurTime();

		for Segment = 0, Floor(90 * Time / MaxTime) do
			Radian = Rad((Segment / 90) * -360);
			Poly[#Poly + 1] = {x = CenterX - Sin(Radian) * Radius, y = CenterY - Cos(Radian) * Radius};
		end

		SetDrawColor(255, 255, 255);

		SetMaterial(WhiteCircle);
		DrawTexturedRect(StartX + 5, StartY + 5, Diameter - 10, Diameter - 10);

		SetMaterial(GrayCircle);
		DrawTexturedRect(StartX + 3, StartY + 3, Diameter - 6, Diameter - 6);

		NoTexture();

		ExperimentalStencil(function()
			DrawPoly(Poly);

			SetStencilCompareFunction(STENCIL_NOTEQUAL);
			SetStencilFailOperation(STENCIL_KEEP);

			SetMaterial(YellowCircle);
			DrawTexturedRect(StartX + 3, StartY + 3, Diameter - 6, Diameter - 6);
		end);

		Width = Radius * .5;

		SetMaterial(Icon);
		DrawTexturedRect(CenterX - Width, CenterY - Width, Radius, Radius);
	end

	SWEP.DownAngle = Angle(-10, 0, 0)
	SWEP.LowerPercent = 1
	SWEP.SwayScale = 0

	function SWEP:GetViewModelPosition(pos, ang)
		if (self.IsCracking) then
			local delta = FrameTime() * 3.5
			self.LowerPercent = math.Clamp(self.LowerPercent - delta, 0, 1)
		else
			local delta = FrameTime() * 5
			self.LowerPercent = math.Clamp(self.LowerPercent + delta, 0, 1)
		end

		ang:RotateAroundAxis(ang:Forward(), self.DownAngle.p * self.LowerPercent)
		ang:RotateAroundAxis(ang:Right(), self.DownAngle.p * self.LowerPercent)

		return self.BaseClass.GetViewModelPosition(self, pos, ang)
	end

	net.Receive("KeypadCracker_Hold", function()
		local ent = net.ReadEntity()
		local state = (net.ReadBit() == 1)

		if (IsValid(ent) and ent:IsWeapon() and ent:GetClass() == "keypad_cracker" and (not game.SinglePlayer()) and ent.SetHoldType) then
			if (not state) then
				ent:SetHoldType(ent.IdleStance)
				ent.IsCracking = false
			else
				ent:SetHoldType("pistol")
				ent.IsCracking = true
			end
		end
	end)

	net.Receive("KeypadCracker_Sparks", function()
		local ent = net.ReadEntity()

		if (IsValid(ent)) then
			local vPoint = ent:GetPos()
			local effect = EffectData()
			effect:SetStart(vPoint)
			effect:SetOrigin(vPoint)
			effect:SetEntity(ent)
			effect:SetScale(2)
			util.Effect("cball_bounce", effect)
			ent:EmitSound("buttons/combine_button7.wav", 100, 100)
		end
	end)
end