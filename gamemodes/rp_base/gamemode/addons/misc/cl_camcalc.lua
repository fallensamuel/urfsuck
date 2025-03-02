cvar.Register'camera_calc_enable':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Покачивание камеры')

local cvar_Get = cvar.GetValue
local math_Approach, math_sin, math_cos, input_IsMouseDown, UnPredicted_CurTime, gmod_GetGamemode, Frame_Time, math_Clamp = math.Approach, math.sin, math.cos, input.IsMouseDown, UnPredictedCurTime, gmod.GetGamemode, FrameTime, math.Clamp

hook.Add("CalcView", "IncredibleDZ_CalcView", function(ply, pos, angles, fov)
	if ply:Alive() and cvar_Get('camera_calc_enable') then
		GM = GM or GAMEMODE or gmod_GetGamemode()
		local frameTime = Frame_Time()
		local approachTime = frameTime * 2
		local curTime = UnPredicted_CurTime()

		local info = {
		    speed = 1,
		    yaw = 0.75,
		    roll = 0.1
		}

		if (not GM.HeadbobAngle) then
		    GM.HeadbobAngle = 0
		end

		if (not GM.HeadbobInfo) then
		    GM.HeadbobInfo = info
		end

		local is_noclip = ply:GetMoveType() == MOVETYPE_NOCLIP and not ply:InVehicle()
		local mult = is_noclip and 0.25 or 1

		if LocalPlayer().IsProne and LocalPlayer():IsProne() then
			mult = 25
		end

		if input_IsMouseDown(MOUSE_RIGHT) then
			local act_wep = ply:GetActiveWeapon()
			if IsValid(act_wep) and (act_wep:GetClass() == "cw*" or act_wep.dt and act_wep.dt.State == 2) then
				GM.HeadbobInfo.yaw = 0
			end
		end


		GM.HeadbobInfo.yaw = math_Approach(GM.HeadbobInfo.yaw, info.yaw, approachTime)
		GM.HeadbobInfo.roll = math_Approach(GM.HeadbobInfo.roll, info.roll, approachTime)
		GM.HeadbobInfo.speed = math_Approach(GM.HeadbobInfo.speed, info.speed, approachTime)
		GM.HeadbobAngle = GM.HeadbobAngle + (GM.HeadbobInfo.speed * frameTime)
		local yawAngle = math_sin(GM.HeadbobAngle)
		local rollAngle = math_cos(GM.HeadbobAngle)

		angles.y = angles.y + (yawAngle * GM.HeadbobInfo.yaw)
		angles.r = angles.r + (rollAngle * GM.HeadbobInfo.roll)
		local velocity = ply:GetVelocity()
		local eyeAngles = ply:EyeAngles()

		if (not GM.VelSmooth) then
		    GM.VelSmooth = 0
		end

		if (not GM.WalkTimer) then
		    GM.WalkTimer = 0
		end

		if (not GM.LastStrafeRoll) then
		    GM.LastStrafeRoll = 0
		end

		GM.VelSmooth = math_Clamp(GM.VelSmooth * 0.9 + velocity:Length() * 0.1, 0, 700)
		GM.WalkTimer = GM.WalkTimer + GM.VelSmooth * Frame_Time() * 0.05
		GM.LastStrafeRoll = (GM.LastStrafeRoll * 3) + (eyeAngles:Right():DotProduct(velocity) * 0.0001 * GM.VelSmooth * 0.3)
		GM.LastStrafeRoll = GM.LastStrafeRoll * 0.25
		angles.r = angles.r + GM.LastStrafeRoll*mult

		if (ply:GetGroundEntity() ~= NULL) then
		    angles.p = angles.p + math_cos(GM.WalkTimer * 0.5) * GM.VelSmooth * 0.000002 * GM.VelSmooth
		    angles.r = angles.r + math_sin(GM.WalkTimer) * GM.VelSmooth * 0.000002 * GM.VelSmooth
		    angles.y = angles.y + math_cos(GM.WalkTimer) * GM.VelSmooth * 0.000002 * GM.VelSmooth
		end
	end
end)