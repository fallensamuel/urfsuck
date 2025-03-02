-- "gamemodes\\darkrp\\entities\\weapons\\weapon_hunter\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿include('shared.lua')

function SWEP:CalcView(ply, pos, ang, fov)
    return pos - Vector(0, 0, 15)
end

function SWEP:Think()
	if IsValid(self.Owner) then
		if self.ground != self.Owner:IsOnGround() then
			self.ground = self.Owner:IsOnGround()
			self.Owner:SetBodygroup(1, self.ground && 0 or 1)
		end
	end
end

net.Receive('runHunter.lock', function()
	local wep = LocalPlayer():GetActiveWeapon()
	
	if not wep or wep:GetClass() ~= 'weapon_hunter' then return end
	
	wep.Eye = net.ReadVector()
	
	if wep.Eye == Vector(0, 0, 0) then
		hook.Remove("InputMouseApply", "runHunter.lock")
		hook.Remove("SetupMove", "jumpHunter.lock")
	else
		hook.Add("InputMouseApply", "runHunter.lock", function(cmd, x, y, ang)
			cmd:SetMouseX(0)
			cmd:SetMouseY(0)
			
			cmd:SetViewAngles(ang + Angle(y, -x, 0) / 800)
			
			return true
		end)
		
		hook.Add("SetupMove", "jumpHunter.lock", function(ply, mvd, cmd)
			if ply ~= LocalPlayer() then return end
			
			if mvd:KeyDown(IN_JUMP) then
				mvd:SetButtons(bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP)))
			end
		end)
	end
end)

function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end