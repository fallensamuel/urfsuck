-- "gamemodes\\rp_base\\gamemode\\addons\\sitanywhere\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CurTime = CurTime

local lastAction = 0
local IN_USE = IN_USE
local IN_WALK = IN_WALK
local sum = IN_WALK + IN_USE

hook.Add('CreateMove', 'CreateMoveSeat', function(cmd)
	if lastAction < CurTime() && !LocalPlayer():InVehicle() then
		if cmd:GetButtons() == sum then
			rp.RunCommand('sit')
			lastAction = CurTime() + 0.3
			cmd:ClearButtons()
			cmd:ClearMovement()
		end
	elseif lastAction > CurTime() then
		cmd:RemoveKey(IN_USE)
		cmd:RemoveKey(IN_WALK)
	end
end)
