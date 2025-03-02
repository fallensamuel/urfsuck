include('shared.lua')

function SWEP:CalcView(ply, pos, ang, fov)
    return pos + Vector(0, 0, 30)
end

function SWEP:Think()
	if IsValid(self.Owner) then
		if self.ground != self.Owner:IsOnGround() then
			self.ground = self.Owner:IsOnGround()
			self.Owner:SetBodygroup(1, self.ground && 0 or 1)
		end
	end
end

net.Receive('runGuard.lock', function()
	local wep = LocalPlayer():GetActiveWeapon()
	
	if not wep or wep:GetClass() ~= 'weapon_anlition_guard' then return end
	
	wep.Eye = net.ReadVector()
	
	if wep.Eye == Vector(0, 0, 0) then
		hook.Remove("InputMouseApply", "runGuard.lock")
		hook.Remove("SetupMove", "jumpGuard.lock")
	else
		hook.Add("InputMouseApply", "runGuard.lock", function(cmd, x, y, ang)
			cmd:SetMouseX(0)
			cmd:SetMouseY(0)
			
			cmd:SetViewAngles(ang + Angle(y, -x, 0) / 800)
			
			return true
		end)
		
		hook.Add("SetupMove", "jumpGuard.lock", function(ply, mvd, cmd)
			if ply ~= LocalPlayer() then return end
			
			if mvd:KeyDown(IN_JUMP) then
				mvd:SetButtons(bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP)))
			end
		end)
	end
end)