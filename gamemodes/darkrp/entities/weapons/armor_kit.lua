-- "gamemodes\\darkrp\\entities\\weapons\\armor_kit.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = "Швейный Набор"
	SWEP.Slot = 5
	SWEP.SlotPos = 0
	SWEP.Category = "Help Sweps"
	SWEP.Spawnable = true
	SWEP.AdminSpawnable = true
	SWEP.Purpose = ""
	SWEP.Instructions = "Нажмите ЛКМ чтобы зашить броню напарнику\nНажмите ПКМ чтобы зашить броню себе"
end

--[[
SWEP.Primary.ClipSize = 1000
SWEP.Primary.DefaultClip = 1000
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
]]--

--SWEP.ViewModel = Model("models/sewing_kit_a.mdl")
SWEP.ViewModel = Model("models/flaymi/anomaly/dynamics/repair/toolkit_p.mdl")
SWEP.UseHands = false
SWEP.HoldType = "slam"

SWEP.IronSightsPos = Vector( -3.49, -7.5, -12.371 )
SWEP.IronSightsAng = Vector( -132, 9, 180.5 )

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

--SWEP.WorldModel = Model("models/sewing_kit_a.mdl")
SWEP.WorldModel = Model("models/flaymi/anomaly/dynamics/repair/toolkit_p.mdl")
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
			local offsetAng = Angle( 180, 0, 180 )

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
SWEP.Primary.Sound = Sound('npc/barnacle/neck_snap1.wav')

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = {Sound('npc/barnacle/neck_snap1.wav'), Sound('npc/barnacle/neck_snap2.wav')}
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CLIENT then return end
	self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	local armor = (IsValid(ent) and ent:IsPlayer()) and ent:Armor()
	if not isnumber(armor) or armor >= 200 or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end
	ent:SetArmor(armor + 15)       
	self.Owner:EmitSound(self.Primary.Sound, 125, armor)
	
	--self:TakePrimaryAmmo( 25 )
	
	--if self:Clip1() <= 0 then
	--	self.Owner:StripWeapon(self:GetClass())
	--	self:Remove()
	--end
end

function SWEP:SecondaryAttack() 
	if not IsValid(self.Owner) then return end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	local armor = SERVER and self.Owner:Armor()
	if CLIENT or armor >= 200 then return end
	self.Owner:SetArmor(armor + 15)
	self.Owner:EmitSound(self.Primary.Sound, 125, armor)
	
	--self:TakePrimaryAmmo( 25 )
	
	--if self:Clip1() <= 0 then
	--	self.Owner:StripWeapon(self:GetClass())
	--	self:Remove()
	--end
end

function SWEP:Reload()
	if not IsValid(self.Owner) or not self:CanReload() then return end
	self:SetNextReload(CurTime() + self._Reload.Delay)
	if CLIENT then return end
	self.Owner:EmitSound(self._Reload.Sound[math.random(1, 2)])
end