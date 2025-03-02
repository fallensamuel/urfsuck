
DEFINE_BASECLASS 'mhs_weapon_base'

SWEP.Spawnable = true

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.HoldType = "normal"

if CLIENT then

	SWEP.Slot = 2
	SWEP.PrintName = "Зиг хайль"
	SWEP.ShowWorldModel = false


	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 85.318, 0) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.699, 0) },
		["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, -30, -30), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(45, 0, -65) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(15, 0, -3), angle = Angle(0, -45, 2) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.104, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10.404, 35.375, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 6.243, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.565, 41.618, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-30, 0, 0), angle = Angle(0, 180, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -43.7, 0) }
	}
	SWEP.time = 0
	SWEP.ang = 0
	local delta
	function SWEP:DrawWorldModel()
		delta = CurTime() - self.time
		BaseClass.DrawWorldModel(self)
		if self:GetRising() then
			self.ang = math.min(self.ang + delta, 1)
		else
			self.ang = math.max(self.ang - delta, 0)
		end
		if IsValid(self.Owner) then
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(45*self.ang,-135*self.ang,-45*self.ang) )
			end
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(0,0,-45*self.ang) )
			end
		end
		self.time = CurTime()
	end

	function SWEP:UpdateBonePositions(vm)
		BaseClass.UpdateBonePositions(self, vm)

		delta = CurTime() - self.time
		if self:GetRising() then
			self.ang = math.min(self.ang + delta, 1)
		else
			self.ang = math.max(self.ang - delta, 0)
		end

		if IsValid(self.Owner) then
			self.ViewModelBoneMods["ValveBiped.Bip01_R_Forearm"].angle = Angle(0, 45*self.ang, 0)
			self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(0, -45*self.ang, 2)
			self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].pos = Vector(0 , -15 +(15*self.ang), -3)
		end
		//self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(swingang/4, 0, 0)

		self.time = CurTime()
	end
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK) then
		self:SetRising(true)
	else
		self:SetRising(false)
	end
end

SWEP.OnRemove = SWEP.Holster

function SWEP:Holster()
	BaseClass.Holster(self)
	if !IsValid(self.Owner) then return end
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if bone then 
		self.Owner:ManipulateBoneAngles( bone, Angle(0,0,0) )
	end
	local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
	if bone then 
		self.Owner:ManipulateBoneAngles( bone, Angle(0,0,0) )
	end

	self:SetRising(false)

	return true
end


function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Rising")
end

