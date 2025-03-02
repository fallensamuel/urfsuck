include("shared.lua")

function SWEP:CalcView(ply, pos, ang, fov)
    return pos + ang:Forward()*16 + ang:Up()*20
end

function SWEP:OnRemove()
    self:Holster()
end

function SWEP:Holster()
	timer.Destroy("DogWalk"..self:EntIndex())
	timer.Destroy("DogRun"..self:EntIndex())
	timer.Destroy("DogBoosted"..self:EntIndex())
    return true
end

function SWEP:Deploy()
	timer.Create("DogWalk"..self:EntIndex(), 0.05, 0, function()
		if !IsValid(self) && !IsValid(self.Owner) then return end
		if self.Owner:KeyDown(IN_FORWARD) && !self.Owner:KeyDown(IN_SPEED) then
			self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("walk_all"), 0, false)
		end
	end)
	timer.Create("DogRun"..self:EntIndex(), 0.05, 0, function()
		if !IsValid(self) && !IsValid(self.Owner) then return end
		if self.Owner:KeyDown(IN_SPEED) then
			self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("run_all"), 0, false)
		end
	end)
	timer.Create("DogBoosted"..self:EntIndex(), 0.05, 0, function()
		if !IsValid(self) && !IsValid(self.Owner) && !self.Owner.DogBoosted then return end
		if self.Owner:KeyDown(IN_FORWARD) then
			self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("test_run"), 0, false)
		end
	end)
end

function SWEP:SecondaryAttack()
	if self.Secondaryfire == true then return end
	self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("pound"), 0, true)
	self.Secondaryfire = true
	timer.Simple(self.pSecondaryTime, function()
		self.Secondaryfire = false
	end)
end

function SWEP:PrimaryAttack()
	if self.Primaryfire == true then return end
	self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("throw"), 0, true)
	self.Primaryfire = true
	timer.Simple(self.pPrimatyTime, function()
		self.Primaryfire = false
	end)
end

function SWEP:AdjustMouseSensitivity()
	if self.Owner.DogBoosted then
		return 0.25
	else
		return 1
	end
end