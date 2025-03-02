
AddCSLuaFile()

SWEP.PrintName				= "Руки"
SWEP.Author					= "robotboy655 & MaxOfS2D"
SWEP.Purpose			= "Heal people with your primary attack, or yourself with the secondary."

SWEP.Slot					= 0
SWEP.SlotPos				= 0

SWEP.Spawnable				= true

SWEP.ViewModel = Model('')
SWEP.ViewModelFOV = 62
SWEP.WorldModel				= ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"


SWEP.UseHands = true

function SWEP:Initialize()
	self:SetHoldType('normal')
end

if CLIENT then
	function SWEP:PreDrawViewModel()
		return true
	end
else
	SWEP.lastHeld = 0

	function SWEP:Deploy()
		self:GetOwner():DrawWorldModel(false)
	end

	function SWEP:onCanCarry(entity)
		local physicsObject = entity:GetPhysicsObject()

		if (!IsValid(physicsObject)) then
			return false
		end

		if (physicsObject:GetMass() > 100 or !physicsObject:IsMoveable()) then
			return false
		end

		if (IsValid(self.heldEntity)) then
			return false
		end

		return true
	end

	function SWEP:doPickup(entity)
		if (entity:IsPlayerHolding()) then
			return
		end

		self.heldEntity = entity

		timer.Simple(0.2, function()
			if (!IsValid(entity) or entity:IsPlayerHolding() or self.heldEntity != entity) then
				self.heldEntity = nil

				return
			end


			self.Owner:PickupObject(entity)
			entity.holder = self.Owner
			self.Owner:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 3)..".wav", 75)
		end)

		self:SetNextSecondaryFire(CurTime() + .5)
		self:SetNextPrimaryFire(CurTime() + .5)
	end

	function SWEP:Holster( wep )
		return self.lastHeld < CurTime()
	end
end

function SWEP:PrimaryAttack()
	self:SecondaryAttack()
end

function SWEP:SecondaryAttack()

	self:SetNextSecondaryFire(CurTime() + 0.1)
	self:SetNextPrimaryFire(CurTime() + 0.1)

	if (!IsFirstTimePredicted()) then
		return
	end

	local data = {}
		data.start = self.Owner:GetShootPos()
		data.endpos = data.start + self.Owner:GetAimVector()*120
		data.filter = {self, self.Owner}
	local trace = util.TraceLine(data)
	local entity = trace.Entity
	
	if (SERVER and IsValid(entity)) then
		if (IsValid(self.heldEntity) and !self.heldEntity:IsPlayerHolding()) then
			self.heldEntity = nil
		end

		if (!entity:IsPlayer() and !entity:IsNPC() and self:onCanCarry(entity) and !entity:IsVehicle()) then
			local physObj = entity:GetPhysicsObject()
			physObj:Wake()

			self:doPickup(entity)
		end
	end
end


local player = FindMetaTable("Player")
oldPickupObject = oldPickupObject or player.PickupObject
function player:PickupObject(ent)
	if ent:IsPlayerHolding() then return end
	ent.holder = self
	oldPickupObject(self, ent)
end