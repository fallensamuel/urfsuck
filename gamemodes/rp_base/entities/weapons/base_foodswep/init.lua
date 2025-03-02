AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

function SWEP:OnRemove()
    local timer_name = "foodswep_"..self:GetClass()..self:EntIndex()
	if timer.Exists(timer_name) then
		timer.Remove(timer_name)
	end
end

util.AddNetworkString("net.newfoodsystem.InterpolateArm")
function rp.BaseFoodSwepArmAnim(swep, twoarms)
	net.Start("net.newfoodsystem.InterpolateArm")
		net.WriteUInt(swep:EntIndex(), 32)
		net.WriteUInt(twoarms and 2 or 1, 2)
	net.Broadcast()
end
function SWEP:StartArmAnimation()
	rp.BaseFoodSwepArmAnim(self)
end

function SWEP:Think()
	if self.FirstDeploy and self.FirstDeploy < CurTime() then
		if not self.NetAlreadyStarted then
			self.NetAlreadyStarted = true
			self:StartArmAnimation()
		end
	else
		self.FirstDeploy = CurTime() + 0.25
	end
end

function SWEP:Deploy()
	self.FirstDeploy = nil
	--print("DEPLOY!", self)

	timer.Simple(0, function()
		self:StartArmAnimation()
	end)

	local timer_name = "foodswep_"..self:GetClass()..self:EntIndex()
	if timer.Exists(timer_name) then return end

	self.PlaySoundsCopy = self.PlaySounds and table.Copy(self.PlaySounds)
	self:DoPlaySound()

	if self.AnimationDuration then
		timer.Create(timer_name, self.AnimationDuration, 1, function()
			if IsValid(self) then
				self:DoEnd()
			end
		end)		
	end
end

function SWEP:DoPlaySound()
	if self.PlaySoundsCopy then
		for k, v in pairs(self.PlaySoundsCopy) do
			local curOwner = self.Owner
			timer.Simple(v.time, function()
				if IsValid(self) and IsValid(self.Owner) and self.Owner == curOwner and self == curOwner:GetActiveWeapon() then
					self:EmitSound(v.sound)
					self:DoPlaySound()
				end
			end)
			self.PlaySoundsCopy[k] = nil
			break
		end
	end
end

function SWEP:DoEnd()
	local ply = self.Owner
	if not IsValid(ply) or not self.FoodEnd or not self == ply:GetActiveWeapon() then self:DoRemove() return end

	if self.FoodEnd.Hunger and ply.AddHunger then
		ply:AddHunger(self.FoodEnd.Hunger)
	end

	if self.FoodEnd.Heal then
		ply:SetHealth(
			math.Clamp(ply:Health() + self.FoodEnd.Heal, 0, ply:GetMaxHealth())
		)
	end

	if self.FoodEnd.Sound then
		ply:EmitSound(self.FoodEnd.Sound)
	end

	if self.FoodEnd.CallBack then
		self.FoodEnd.CallBack(self, ply)
	end

	self:DoRemove()
end

function SWEP:DoRemove()
	timer.Simple(0, function()
		local ply = self.Owner
		if IsValid(ply) and ply:IsPlayer() and IsValid(self) then
			ply:StripWeapon(self:GetClass())
		end
	end)
end

function SWEP:Holster()
	local timer_name = "foodswep_"..self:GetClass()..self:EntIndex()
	if timer.Exists(timer_name) then
		timer.Remove(timer_name)
	end
	return true
end





function PLAYER:SetTempRunSpeedMult(mult, delay)
	if self.OldRunSpeed then
		self:SetRunSpeed(self.OldRunSpeed)
	end

	self.OldRunSpeed = self:GetRunSpeed()
	self:SetRunSpeed(self.OldRunSpeed * mult)

	timer.Create("temprunspeed_"..self:SteamID(), delay or 10, 1, function()
		if IsValid(self) then
			self:SetRunSpeed(self.OldRunSpeed)
			self.OldRunSpeed = nil
		end
	end)
end

hook.Add("PlayerSpawn", "TempRunSpeed.PlayerSpawn", function(ply)
	local t_name = "temprunspeed_"..ply:SteamID()

	if timer.Exists(t_name) then
		timer.Remove(t_name)
	end
end)