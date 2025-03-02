-- "gamemodes\\darkrp\\entities\\weapons\\health_kit_bad.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = "Обычная Аптечка"
	SWEP.Slot = 5
	SWEP.SlotPos = 0
	SWEP.Category = "Help Sweps"
	SWEP.Spawnable = true
	SWEP.AdminSpawnable = true
	SWEP.Purpose = ""
	SWEP.Instructions = "Нажмите ЛКМ чтобы вылечить напарника\nНажмите ПКМ чтобы вылечить себя"
end

--[[
SWEP.Primary.ClipSize = 400
SWEP.Primary.DefaultClip = 400
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
]]--

--SWEP.MaxRestore = 400

SWEP.ViewModel = Model("models/flaymi/anomaly/dynamics/devices/dev_aptechka_low.mdl")
SWEP.UseHands = false
SWEP.HoldType = "slam"

SWEP.IronSightsPos = Vector( 4.49, 0.5, -17.371 )
SWEP.IronSightsAng = Vector( -110, 180, 180.5 )

function SWEP:GetViewModelPosition( EyePos, EyeAng )
	local Mul = 1

	local Offset = self.IronSightsPos

	if ( self.IronSightsAng ) then
		EyeAng = EyeAng * 1

		EyeAng:RotateAroundAxis( EyeAng:Right(), 	self.IronSightsAng.x * Mul )
		EyeAng:RotateAroundAxis( EyeAng:Up(), 		self.IronSightsAng.y * Mul )
		EyeAng:RotateAroundAxis( EyeAng:Forward(),	self.IronSightsAng.z * Mul )
	end

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right * Mul
	EyePos = EyePos + Offset.y * Forward * Mul
	EyePos = EyePos + Offset.z * Up * Mul

	return EyePos, EyeAng
end

SWEP.WorldModel = Model("models/flaymi/anomaly/dynamics/devices/dev_aptechka_low.mdl")
if CLIENT then
	local WorldModel = ClientsideModel( SWEP.WorldModel )

	-- Settings...
	WorldModel:SetSkin( 1 )
	WorldModel:SetNoDraw( true )

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if ( IsValid( _Owner ) ) then
			-- Specify a good position
			local offsetVec = Vector( 5, -4, -1.4 )
			local offsetAng = Angle( 0, 0, 190 )

			local boneid = _Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix( boneid )
			if !matrix then return end

			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )

			WorldModel:SetPos( newPos )
			WorldModel:SetAngles( newAng )

			WorldModel:SetupBones()
		else
			WorldModel:SetPos( self:GetPos() )
			WorldModel:SetAngles( self:GetAngles() )
		end

		WorldModel:DrawModel()
	end
end

SWEP.Primary.Delay = 0.1
SWEP.Primary.Sound = Sound('hl1/fvox/boop.wav')

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = {Sound('npc_citizen.armor01'), Sound('npc_citizen.armor02'), Sound('npc_citizen.armor03'), Sound('npc_citizen.armor04'), Sound('npc_citizen.armor05')}
	
	--self.CurRestore = self.MaxRestore
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CLIENT then return end
	self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	local health = (IsValid(ent) and ent:IsPlayer()) and ent:Health()
	local maxhealth = (IsValid(ent) and ent:IsPlayer()) and math.min(ent:GetMaxHealth(), 200)
	if not isnumber(health) or health >= maxhealth or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end
	--self.CurRestore = self.CurRestore - (health > maxhealth - 2 and maxhealth - health or 2)
	ent:SetHealth(health > maxhealth - 5 and maxhealth or health + 5)
	self.Owner:EmitSound(self.Primary.Sound, 125, health)
	
	self:TakePrimaryAmmo( health > maxhealth - 5 and maxhealth - health or 5 )
	
	if self:Clip1() <= 0 then
		self.Owner:StripWeapon(self:GetClass())
		self:Remove()
	end
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	local health = SERVER and self.Owner:Health()
	local maxhealth = SERVER and math.min(self.Owner:GetMaxHealth(), 200)
	if CLIENT or health >= maxhealth then return end
	--self.CurRestore = self.CurRestore - (health > maxhealth - 2 and maxhealth - health or 2)
	self.Owner:SetHealth(health > maxhealth - 5 and maxhealth or health + 5)
	self.Owner:EmitSound(self.Primary.Sound, 125, health)
	
	--self:TakePrimaryAmmo( health > maxhealth - 10 and maxhealth - health or 10 )
	
	--if self:Clip1() <= 0 then
	--	self.Owner:StripWeapon(self:GetClass())
	--	self:Remove()
	--end
end

function SWEP:Reload()
	if not IsValid(self.Owner) or not self:CanReload() then return end
	self:SetNextReload(CurTime() + self._Reload.Delay)
	if CLIENT then return end
	self.Owner:EmitSound(self._Reload.Sound[math.random(1, 5)])
end