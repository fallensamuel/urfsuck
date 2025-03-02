
DEFINE_BASECLASS 'mhs_weapon_base'

SWEP.Spawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.HoldType = "normal"

if CLIENT then

	SWEP.Slot = 2
	SWEP.PrintName = "Отдать честь"
	SWEP.ShowWorldModel = false
	SWEP.ViewModelFOV = 113

	SWEP.IronSightsPos = Vector(-0, -7, 1.629)
	SWEP.IronSightsAng = Vector(-1, 0, 0)

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 45.555, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 70, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 63.333, -18.889) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -21.112, 0) },
		["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 43.333, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-16.852, 0, -7.593), angle = Angle(21.111, -70, -16.667) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(18.888, 78.888, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 54.444, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 21.111, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 52.222, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(-1, -1, -1), angle = Angle(-2, -2, -2) },
		["ValveBiped.Bip01_L_Finger4"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger41"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.778, 47.777, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -1.111, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(7.777, 43.333, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 47.777, 0) },
		["ValveBiped.Bip01_L_Finger42"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(0, 0, 0), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
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
			local ply = self.Owner
			local bone = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(-25*self.ang,-120*self.ang,-40*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(105*self.ang,-188*self.ang,-85*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(-15*self.ang,20*self.ang,90*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger1")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger3")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger4")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger11")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger31")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger41")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger12")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(-0*self.ang,0*self.ang,0*self.ang) )
			end
			
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger32")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
			end
			local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger42")
			if bone then 
				ply:ManipulateBoneAngles( bone, Angle(0*self.ang,0*self.ang,0*self.ang) )
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
			self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(0, -55*self.ang, 10)
			self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].pos = Vector(0 , -21 +(12*self.ang), -15)
			self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].angle = Angle(100, 100*self.ang, 400)
			self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].pos = Vector(100 , 100*self.ang, 400)
		end

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

local ang_zero = Angle(0,0,0)
function SWEP:Holster()
	BaseClass.Holster(self)
	if !IsValid(self.Owner) then return end

	local ply = self.Owner
	local bone = ply:LookupBone("ValveBiped.Bip01_L_Forearm")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_L_UpperArm")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero )
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger1")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger3")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger4")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger11")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger31")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger41")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger12")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger32")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end
	local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger42")
	if bone then 
		ply:ManipulateBoneAngles( bone, ang_zero)
	end

	self:SetRising(false)

	return true
end


function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Rising")
end

