-- "gamemodes\\rp_base\\gamemode\\addons\\thirdperson_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

cvar.Register'enable_thirdperson':SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Вид от 3го лица')
local cvar_Get = cvar.GetValue
local cvar_Set = cvar.SetValue

local function scopeAiming()
	local wep = LocalPlayer():GetActiveWeapon()

	return IsValid(wep) and wep.SWBWeapon and wep.dt and (wep.dt.State == SWB_AIMING) || wep.IsFAS2Weapon and wep.dt.Status == FAS_STAT_ADS || wep.CW20Weapon && wep.dt.State == CW_AIMING
end

hook('ShouldDrawLocalPlayer', 'ThirdPersonDrawPlayer', function()
	if cvar_Get('enable_thirdperson') && (not LocalPlayer():InVehicle()) && (not scopeAiming()) then return true end
end)

local camOffset = {
	UD = 0, -- Up / Down. Use a positive number for up, negative for right. Default = 0
	RL = 20, -- Right / Left. Use a positive number for right, negative for left. Default = 0
	FB = -84 -- Forward / Backward. Use a positive number for forward ( Not sure why you would do it ), negative for backward. Default = -88
}

local usedOffset
local savedTeam

local angles, origin, trace
local old = vector_origin

local filter = {}

hook.Add("CalcViewOverride", function(view)
	local ply = LocalPlayer()
	if IsValid(ply) then 
		if not usedOffset or savedTeam and savedTeam ~= ply:Team() then
			usedOffset = ply:GetJobTable() and ply:GetJobTable().tpCamOffset or camOffset
			savedTeam = ply:Team()
		end
		
		angles, origin = view.angles, view.origin

		local newview = hook.Run("CalcView.ThirdPersonOverride", ply, origin, angles)
		if newview then
			origin = newview.origin or origin
			angles = newview.angles or angles
		elseif newview == false then
			return
		end

		if cvar_Get('enable_thirdperson') and (not ply:InVehicle()) and (not scopeAiming()) then
			filter = {ply}
			hook.Run("CalcView.ThirdPersonFilter", filter);			

			trace = util.TraceHull({
				start = origin,
				endpos = origin + (angles:Up() * usedOffset.UD) + (angles:Right() * usedOffset.RL) + (angles:Forward() * usedOffset.FB * view.fov / 90),
				filter = filter,
				mins = Vector( -5, -5, -5 ),
				maxs = Vector( 5, 5, 5 ),
			})

			view.origin = trace.HitPos + (angles:Forward() * 16) + trace.HitNormal * 10
			
			view.drawviewer = true
		elseif newview then
			view.origin = origin
		end
	end
end)

function GetThirdPersonTrace()
	return trace
end

--hook.Add("PlayerButtonDown", function(ply, key)
--	if ply ~= LocalPlayer() or key ~= KEY_F2 then return end
--	cvar.SetValue('enable_thirdperson', not cvar_Get('enable_thirdperson'))
--end)

local pressed = false
hook.Add('Tick', 'listen3rdPerson', function()
	if input.IsKeyDown(KEY_F2) then
		if not pressed then
			local tr = LocalPlayer():GetEyeTraceNoCursor()
			local ent = tr.Entity
			if IsValid(ent) and ent:IsDoor() and (tr.HitPos:DistToSqr(LocalPlayer():GetPos()) <= 16384) then
				return
			end
			
			if LocalPlayer().Blocked3dPerson then
				return
			end
			
			pressed = true
			cvar_Set('enable_thirdperson', not cvar_Get('enable_thirdperson'))
		end
	elseif pressed then
		pressed = false
	end
end)

table.insert(rp.cfg.Announcements, translates and translates.Get('Быстро переключать вид от третьего лица можно нажав F2.') or 'Быстро переключать вид от третьего лица можно нажав F2.')
