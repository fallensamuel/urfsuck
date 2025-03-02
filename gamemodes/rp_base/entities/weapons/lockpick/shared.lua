-- "gamemodes\\rp_base\\entities\\weapons\\lockpick\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if SERVER then
	AddCSLuaFile("shared.lua")
	util.AddNetworkString("lockpick_time")
end

if CLIENT then
	SWEP.PrintName = "Отмычка"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
SWEP.Instructions = "ЛКМ взломать замок двери"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/sterling/c_enhanced_lockpicks.mdl")
SWEP.WorldModel = Model("models/sterling/enhanced_lockpicks.mdl")
SWEP.Spawnable = true
SWEP.Category = "RP"
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = 0 -- Default number of bullets in a clip
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1 -- Size of a clip
SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""
SWEP.LockPickTime = 15

--SWEP.AdminOnly = true

--[[---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType("slam") --pistol
end

if CLIENT then
	net.Receive("lockpick_time", function(len)
		local wep = net.ReadEntity()
		local time = net.ReadUInt(32)
		wep.LockPickTime = time
		wep.EndPick = CurTime() + time
	end)
end

--[[---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if self.IsLockPicking then return end
	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity
	if SERVER and e.isFadingDoor then return end
	if not IsValid(e) or trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or (not e:IsDoor() and not e:IsVehicle() and not string.find(string.lower(e:GetClass()), "vehicle") or e.isFadingDoor) then return end
	if (e:GetNetVar("DoorData") == false) then return end

	if IsValid(self.Owner) and self.Owner:GetTeamTable().lockpicktime then
		self.LockPickTime = 15 * self.Owner:GetTeamTable().lockpicktime
	else
		self.LockPickTime = 15
	end
	
	if e:DoorIsUpgraded() then
		self.LockPickTime = self.LockPickTime * 2
	end

	hook.Call("PlayerStartLockpicking", nil, self.Owner, e)
	self.IsLockPicking = true
	self.StartPick = CurTime()

	if SERVER then
		net.Start("lockpick_time")
		net.WriteEntity(self)
		net.WriteUInt(self.LockPickTime, 32)
		net.Send(self.Owner)
	end

	self.EndPick = CurTime() + self.LockPickTime
	self:SetHoldType("slam") --pistol

	if SERVER then
		timer.Create("LockPickSounds", 1, self.LockPickTime, function()
			if not IsValid(self) then return end
			local snd = {1, 3, 4}
			self:EmitSound("weapons/357/357_reload" .. tostring(snd[math.random(1, #snd)]) .. ".wav", 50, 100)
		end)
	end

	self:SetVMSequence('picklocking_01');
end

function SWEP:Holster()
	self.IsLockPicking = false

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	return true
end

function SWEP:Succeed()
	self.IsLockPicking = false
	self:SetHoldType("slam") --normal
	local trace = self.Owner:GetEyeTrace()

	if trace.Entity.isFadingDoor and trace.Entity.fadeActivate then
		if not trace.Entity.fadeActive then
			trace.Entity:fadeActivate()

			timer.Simple(5, function()
				if trace.Entity.fadeActive then
					trace.Entity:fadeDeactivate()
				end
			end)
		end
	elseif IsValid(trace.Entity) and trace.Entity.Fire then
		if (trace.Entity.Locked) then
			trace.Entity.PickedAt = CurTime()
		end

		trace.Entity:DoorLock(false)
		trace.Entity:Fire("open", "", .6)
		trace.Entity:Fire("setanimation", "open", .6)
		hook.Call("PlayerFinishLockpicking", nil, self.Owner, trace.Entity)
	end

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	self:SetVMSequence('idle');
end

function SWEP:Fail()
	self.IsLockPicking = false
	self:SetHoldType("slam") --normal

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	self:SetVMSequence('idle');
end

function SWEP:SetVMSequence(Name)
	if (!IsValid(self) or !Name) then return end

	local Owner = self:GetOwner();
	if (!IsValid(Owner)) then return end

	local ViewModel = Owner:GetViewModel();
	if (!IsValid(ViewModel)) then return end

	local Sequence = ViewModel:LookupSequence(Name);
	if (Sequence == -1) then return end

	ViewModel:SendViewModelMatchingSequence(Sequence);
end

function SWEP:Think()
	if self.IsLockPicking then
		local trace = self.Owner:GetEyeTrace()

		if not IsValid(trace.Entity) then
			self:Fail()
		end

		if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or (not trace.Entity:IsDoor() and not trace.Entity:IsVehicle() and not string.find(string.lower(trace.Entity:GetClass()), "vehicle") and not trace.Entity.isFadingDoor) then
			self:Fail()
		end

		if self.EndPick <= CurTime() then
			self:Succeed()
		end
	end
end

if (CLIENT) then
	local WhiteCircle = Material('deathmechanics/circle');
	local GrayCircle = Material('deathmechanics/cline');
	local YellowCircle = Material('deathmechanics/gline');
	local Icon = Material('urfim_hud/icons/weapons/lockpick');

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
		if (!self.IsLockPicking) then return end

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

		MaxTime = self.EndPick - self.StartPick;
		Time = self.EndPick - CurTime();

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
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end
