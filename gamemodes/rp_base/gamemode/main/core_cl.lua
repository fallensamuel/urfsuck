-- "gamemodes\\rp_base\\gamemode\\main\\core_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
GM.HandlePlayerSwimming = nil
GM.HandlePlayerNoClipping = nil


if rp.cfg.MaxRenderDistance then
	__renderDistance = __renderDistance or (rp.cfg.MaxRenderDistance * rp.cfg.MaxRenderDistance);
else
	__renderDistance = __renderDistance or 6250000;
end

function SetRenderDistance( distSqr ) __renderDistance = distSqr; end
function GetRenderDistance() return __renderDistance; end

local math_sqrt = math.sqrt
local IsValid = IsValid
local math_Approach, FrameTime = math.Approach, FrameTime
local GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, GESTURE_SLOT_VCD = GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, GESTURE_SLOT_VCD
local hook_Run, hook_Call = hook.Run, hook.Call
local drive_CalcView = drive.CalcView
local player_manager_RunClass = player_manager.RunClass
local math_min = math.min
local math_NormalizeAngle = math.NormalizeAngle

local view = {}
local origin, angles, fov
function GM:CalcView(ply, origin, angles, fov, znear, zfar)

	local Vehicle	= ply:GetVehicle()
	local Weapon	= ply:GetActiveWeapon()

	view.origin		= origin
	view.angles		= angles
	view.fov		= fov
	view.znear		= znear
	view.zfar		= zfar
	view.drawviewer	= false

	--
	-- Let the vehicle override the view and allows the vehicle view to be hooked
	--
	if IsValid(Vehicle) then return hook_Run("CalcVehicleView", Vehicle, ply, view) end

	--
	-- Let drive possibly alter the view
	--
	if drive_CalcView(ply, view) then return view end

	--
	-- Give the player manager a turn at altering the view
	--
	player_manager_RunClass(ply, "CalcView", view)

	-- Give the active weapon a go at changing the viewmodel position
	if IsValid(Weapon) then
		local func = Weapon.CalcView
		if func then
			origin, angles, fov = func(Weapon, ply, origin * 1, angles * 1, fov) -- Note: *1 to copy the object so the child function can't edit it.
			view.origin, view.angles, view.fov = origin or view.origin, angles or view.angles, fov or view.fov
		end
	end

	view.zfar = math_sqrt(GetRenderDistance())
	hook_Call('CalcViewOverride', nil, view)

	return view
end

local ChatGestureWeight_Cache = {}

function GM:GrabEarAnimation(ply)
	if ply:IsPlayingTaunt() then return end

	local sid = ply:SteamID64()
	if not sid then return end
	ChatGestureWeight_Cache[sid] = ChatGestureWeight_Cache[sid] or 0
	
	local bool = ply:IsTyping() or ( ply:IsSpeaking() and ply:GetNetVar("RC_RadioOnSpeak") )
	ChatGestureWeight_Cache[sid] = math_Approach(ChatGestureWeight_Cache[sid], bool and 1 or 0, FrameTime() * 5)

	if ChatGestureWeight_Cache[sid] > 0 then
		ply:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true)
		ply:AnimSetGestureWeight(GESTURE_SLOT_VCD, ChatGestureWeight_Cache[sid])
	end
end

function GM:OnPlayerDisconnected(data)
	local sid = data.networkid
	ChatGestureWeight_Cache[sid] = nil
end

gameevent.Listen("player_disconnect")
hook.Add("player_disconnect", "RP.PlayerDisconnect", function(data)
	GAMEMODE:OnPlayerDisconnected(data)
end)


function GM:MouthMoveAnimation(ply)
--[[
	if not rp.cfg.DisableMouthAnimation and ply:IsSpeaking() then
		local flexes = {
			ply:GetFlexIDByName( "jaw_drop" ),
			ply:GetFlexIDByName( "left_part" ),
			ply:GetFlexIDByName( "right_part" ),
			ply:GetFlexIDByName( "left_mouth_drop" ),
			ply:GetFlexIDByName( "right_mouth_drop" )
		};

		local weight = math.Clamp( ply:VoiceVolume() * 2, 0, 2 );

		for k, v in pairs( flexes ) do
			ply:SetFlexWeight( v, weight )
		end
	end
]]--
end


function GM:UpdateAnimation(ply, velocity, maxSeqGroundSpeed)
	local len      = velocity:Length()
	local movement = 1

	if len > 0.2 then
		movement = len / maxSeqGroundSpeed
	end

	local rate = math_min(movement, 2)
	ply:SetPlaybackRate(rate)

	if ply:InVehicle() then
		local veh = ply:GetVehicle()

		if veh:GetClass() == "prop_vehicle_prisoner_pod" then
			ply:SetPoseParameter( "aim_yaw", math.NormalizeAngle( ply:GetAimVector():Angle().y - veh:GetAngles().y - 90 ) )
		else
			ply:SetPoseParameter( "vehicle_steer", veh:GetPoseParameter("vehicle_steer") * 2 - 1 )
		end
	end

	self:GrabEarAnimation(ply)  --GAMEMODE:GrabEarAnimation(ply)
	--GAMEMODE:MouthMoveAnimation(ply)
end