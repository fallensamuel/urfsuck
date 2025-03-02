AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("ghostentity.lua")
AddCSLuaFile("object.lua")
AddCSLuaFile("stool.lua")
AddCSLuaFile("cl_viewscreen.lua")
AddCSLuaFile("stool_cl.lua")
include('shared.lua')
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

--[[---------------------------------------------------------
   Desc: Convenience function to check object limits
-----------------------------------------------------------]]
function SWEP:CheckLimit(str)
	local ply = self.Weapon:GetOwner()

	return ply:CheckLimit(str)
end

--[[---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
-----------------------------------------------------------]]
function SWEP:ShouldDropOnDie()
	return false
end

--[[---------------------------------------------------------
   Name: CC_GMOD_Tool
   Desc: Console Command to switch weapon/toolmode
-----------------------------------------------------------]]

function CC_GMOD_Tool(ply, cmd, args)
	if not args[1] then return end
	ply:ConCommand("gmod_toolmode " .. args[1])

	local activeWep = ply:GetActiveWeapon()
	local isTool = activeWep and IsValid(activeWep) and rp.ToolGunSWEPS_k[activeWep:GetClass()]
	-- Switch weapons
	-- Get the weapon and send a fake deploy command
	local wep, class = GetGmodTool(ply)

	if wep then
		ply:SelectWeapon(class)
		-- Hmmmmm???
		if (not isTool) then
			wep.wheelModel = nil
		end

		-- Holster the old 'tool'
		if (wep.Holster) then
			wep:Holster()
		end

		wep.Mode = args[1]

		-- Deplot the new
		if (wep.Deploy) then
			wep:Deploy()
		end
	end
end

concommand.Add("gmod_tool", CC_GMOD_Tool)