--[[
hook.Add("CalcMainActivity", "simfphysSeatActivityOverride", function(ply)
	if SERVER then return end
	local vehicle = ply:GetVehicle()
	
	if not IsValid( vehicle ) then return end
	
	if not vehicle.vehiclebase and not vehicle.dontcheckmeagainpls then
		local parent = vehicle:GetParent()
		
		if IsValid( parent ) then
		
			if simfphys.IsCar( parent ) then
				vehicle.vehiclebase = parent
				vehicle.unlockmymemes = CurTime() + 0.25
			end
			
			vehicle.dontcheckmeagainpls = true
		end
	end
	
	if vehicle.unlockmymemes then
		if vehicle.unlockmymemes > CurTime() then return end
	end
	
	local vehiclebase = vehicle.vehiclebase or vehicle
	--if not IsValid( vehiclebase ) then return end
	
	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 
	
	local IsDriverSeat = vehiclebase.GetDriverSeat and vehicle == vehiclebase:GetDriverSeat()
	
	ply.CalcIdeal = ACT_HL2MP_SIT
	ply.CalcSeqOverride = IsDriverSeat and ply:LookupSequence( "drive_jeep" ) or -1

	if not IsDriverSeat and ply:GetAllowWeaponsInVehicle() and IsValid( ply:GetActiveWeapon() ) then
		
		local holdtype = ply:GetActiveWeapon():GetHoldType()
		
		if holdtype == "smg" then 
			holdtype = "smg1"
		end

		local seqid = ply:LookupSequence( "sit_" .. holdtype )
		
		if seqid ~= -1 then
			ply.CalcSeqOverride = seqid
		end
	end

	return ply.CalcIdeal, ply.CalcSeqOverride
end)
]]--

hook.Add( "PostGamemodeLoaded", "simfphysCalcMainAct", function()
	rp.RegisterCalcMainActivityFunction( "simfphys", function( ply, vel )
		if SERVER then return end
		local vehicle = ply:GetVehicle()
		
		if not IsValid( vehicle ) then return end
		
		if not vehicle.vehiclebase and not vehicle.dontcheckmeagainpls then
			local parent = vehicle:GetParent()
			
			if IsValid( parent ) then
			
				if simfphys.IsCar( parent ) then
					vehicle.vehiclebase = parent
					vehicle.unlockmymemes = CurTime() + 0.25
				end
				
				vehicle.dontcheckmeagainpls = true
			end
		end
		
		if vehicle.unlockmymemes then
			if vehicle.unlockmymemes > CurTime() then return end
		end
		
		local vehiclebase = vehicle.vehiclebase or vehicle
		--if not IsValid( vehiclebase ) then return end
		
		if ply.m_bWasNoclipping then 
			ply.m_bWasNoclipping = nil 
			ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
			
			if CLIENT then 
				ply:SetIK( true )
			end 
		end 
		
		local IsDriverSeat = vehiclebase.GetDriverSeat and vehicle == vehiclebase:GetDriverSeat()
		
		calcIdeal = ACT_HL2MP_SIT
		calcSeqOverride = IsDriverSeat and ply:LookupSequence( "drive_jeep" ) or -1
	
		if not IsDriverSeat and ply:GetAllowWeaponsInVehicle() and IsValid( ply:GetActiveWeapon() ) then
			
			local holdtype = ply:GetActiveWeapon():GetHoldType()
			
			if holdtype == "smg" then 
				holdtype = "smg1"
			end
	
			local seqid = ply:LookupSequence( "sit_" .. holdtype )
			
			if seqid ~= -1 then
				calcSeqOverride = seqid
			end
		end
	
		return calcIdeal, calcSeqOverride
	end );
end );

hook.Add("UpdateAnimation", "simfphysPoseparameters", function(ply , vel, seq)
	if CLIENT then
		local vehicle = ply:GetVehicle()
		if not IsValid( vehicle ) then return end
		
		if vehicle.unlockmymemes then
			if vehicle.unlockmymemes > CurTime() then return end
		end
		
		local vehiclebase = vehicle.vehiclebase
		if not IsValid( vehiclebase ) then return end
		
		local IsDriverSeat = vehicle == vehiclebase:GetDriverSeat()
		if not IsDriverSeat then return end
		
		local Steer = vehiclebase:GetVehicleSteer()
		
		ply:SetPoseParameter("vehicle_steer",Steer)
		ply:InvalidateBoneCache()
		
		GAMEMODE:GrabEarAnimation( ply ) 
 		GAMEMODE:MouthMoveAnimation( ply ) 
		
		return true
	end
end)
