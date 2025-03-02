AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = 'Ключи'
	SWEP.Slot = 1
	SWEP.SlotPos = 0
	SWEP.Instructions = 'ЛКП - Закрыть дверь/Постучать \nПКМ - Открыть дверь/Позвонить в дверь\nR - Продать'
end

SWEP.ViewModel = Model('')
SWEP.ViewModelFOV = 62
SWEP.HitDistance = 100

local bell = {
	sound = Sound('ambient/alarms/warningbell1.wav'),
	delay = 10
}

local knock = {
	sound = Sound('physics/wood/wood_crate_impact_hard2.wav'),
	delay = 5
}

local LockDoor

--	function SWEP:PreDrawViewModel(vm)
--		vm:SetMaterial('engine/occlusionproxy')
--	end

function SWEP:Initialize()
	-- self:SetHoldType('melee-combo') wOS holdtype?
	self:SetHoldType('normal');
	self.Primary.Sound = {Sound('npc/metropolice/gear1.wav'), Sound('npc/metropolice/gear2.wav'), Sound('npc/metropolice/gear3.wav'), Sound('npc/metropolice/gear4.wav'), Sound('npc/metropolice/gear5.wav'), Sound('npc/metropolice/gear6.wav')}
	self._Reload.Delay = 2
end

function SWEP:Deploy()
	if !IsFirstTimePredicted() then self:SendWeaponAnim(ACT_VM_DRAW) end
	if SERVER then
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
end

if SERVER then
	LockDoor = function(self, lock)
		local ply = self.Owner
		ply:LagCompensation(true)
		local ent = ply:GetEyeTrace().Entity
		ply:LagCompensation(false)
		if not IsValid(ent) or not ent:IsDoor() or (ent:GetPos():Distance(ply:GetPos()) > self.HitDistance) then return end
		local IsOwner = (ent:DoorOwnedBy(ply) or ent:DoorCoOwnedBy(ply))

		if (not IsOwner) then
			if IsValid(ent:DoorGetOwner()) and ( not ent.NextBell or ent.NextBell <= CurTime() ) then
				rp.Notify(ent:DoorGetOwner(), NOTIFY_GENERIC, rp.Term('PlayerRangDoorbell'))
				ply:EmitSound(bell.sound, 100, 110)
				ent.NextBell = CurTime() + bell.delay
			elseif not ent.NextKnock or ent.NextKnock <= CurTime() then
				ply:EmitSound(knock.sound, 100, math.random(90, 110))
				ent.NextKnock = CurTime() + knock.delay
			end

			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)

			return
		end

		if (ent.PickedAt and ent.PickedAt + 2 > CurTime()) then
			rp.Notify(ply, NOTIFY_GENERIC, rp.Term('KeysCooldown'))

			return
		end

		if ent.lock then return end

		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
		ply:EmitSound(self.Primary.Sound[math.random(1, 6)])
		ent:DoorLock(lock)
		rp.Notify(ply, NOTIFY_GENERIC, lock and rp.Term('DoorLocked') or rp.Term('DoorUnlocked'))
	end
end

function SWEP:DefaultAnim()
	if (!IsValid(self.Owner) or SERVER) then return end

	self.Owner:LagCompensation(true);
	local ent = self.Owner:GetEyeTrace().Entity;
	self.Owner:LagCompensation(false);
	if not IsValid(ent) or not ent:IsDoor() or (ent:GetPos():Distance(self.Owner:GetPos()) > self.HitDistance) then return end
	local IsOwner = (ent:DoorOwnedBy(self.Owner) or ent:DoorCoOwnedBy(self.Owner));

	if (IsOwner) then
		self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true);
	else
		self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		LockDoor(self, true)
	end

	self:DefaultAnim();

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:SecondaryAttack()
	if SERVER then
		LockDoor(self, false)
	end

	self:DefaultAnim();

	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
	if not self:CanReload() then return end

	if SERVER then
		self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
		self.Owner:LagCompensation(false)

		if IsValid(ent) then
			local ownedBy = (ent:DoorOwnedBy(self.Owner) or ent:DoorCoOwnedBy(self.Owner))
			--if not ent:IsDoor() or (ent:DoorIsOwnable() and not ownedBy) or (not ent:DoorIsOwnable() and not ownedBy) or (ent:GetPos():Distance(self.Owner:GetPos()) > self.HitDistance) then return end
			if (!ent:IsDoor()) or (self.Owner:GetPos():DistToSqr(ent:GetPos()) > 13225) then return end
			net.Start('rp.keysMenu')
			net.Send(self.Owner)
		end
	end

	self:SetNextReload(CurTime() + self._Reload.Delay)
end

--	function SWEP:OnRemove()
--		if not IsValid(self.Owner) then return end
--		local vm = self.Owner:GetViewModel()
--	
--		if IsValid(vm) then
--			vm:SetMaterial("")
--		end
--	end

function SWEP:Holster()
	self:OnRemove()

	return true
end