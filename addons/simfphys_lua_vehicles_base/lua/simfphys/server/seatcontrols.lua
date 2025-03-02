util.AddNetworkString( "simfphys_request_seatswitch" )
util.AddNetworkString( "simfphys_mousesteer" )
util.AddNetworkString( "simfphys_blockcontrols" )
	
net.Receive( "simfphys_mousesteer", function( length, ply )
	net.ReadEntity()
	
	local vehicle = IsValid(ply:GetVehicle()) and ply:GetVehicle():GetParent()
	local Steer = net.ReadFloat()
	
	if not IsValid(vehicle) or vehicle:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then 
		simfphys:exploited(ply, 'simfphys_mousesteer')
		return
	end
	
	vehicle.ms_Steer = Steer
end)

net.Receive( "simfphys_blockcontrols", function( length, ply )
	if not IsValid( ply ) then return end
	
	ply.blockcontrols = net.ReadBool()
end)

local function handleseatswitching( length, ply )
	if not IsValid(ply) then return end
	
	net.ReadEntity()
	net.ReadEntity()
	
	local req_seat 	= net.ReadInt(32)
	local vehicle 	= IsValid(ply:GetVehicle()) and ply:GetVehicle():GetParent()
	
	local a = ply:GetVehicle() and ply:GetVehicle():GetClass() or 'nil'
	local b = vehicle and vehicle:GetClass() or 'nil'
	
	if not IsValid(vehicle) or vehicle:GetClass() ~= 'gmod_sent_vehicle_fphysics_base' then 
		--rp.NotifyAll(NOTIFY_GENERIC, (ply:GetVehicle() and ply:GetVehicle():GetClass() or 'nil') .. ' - ' .. (vehicle and vehicle:GetClass() or 'nil'))
		
		
		simfphys:exploited(ply, 'simfphys_request_seatswitch')
		return
	end
	
	ply.NextSeatSwitch = ply.NextSeatSwitch or 0
	
	if ply.NextSeatSwitch < CurTime() then
		ply.NextSeatSwitch = CurTime() + 0.5
		
		if req_seat == 0 then
			if not IsValid( vehicle:GetDriver() ) then
				ply:ExitVehicle()
				
				if IsValid(vehicle.DriverSeat) then
					timer.Simple( 0.05, function()
						if not IsValid(vehicle) then return end
						if not IsValid(ply) then return end
						if IsValid(vehicle:GetDriver()) then return end
						
						ply:EnterVehicle( vehicle.DriverSeat )
						vehicle:EnteringSequence( ply )
						
						ply:SetAllowWeaponsInVehicle( false ) 
						local angles = Angle(0,90,0)
						ply:SetEyeAngles( angles )
					end)
				end
			end
		else
			if not vehicle.pSeat then return end
			
			local seat = vehicle.pSeat[req_seat]
			
			if IsValid(seat) and not IsValid( seat:GetDriver() ) then
				ply:ExitVehicle()
				
				timer.Simple( 0.05, function()
					if not IsValid( vehicle ) then return end
					if not IsValid( ply ) then return end
					if IsValid( seat:GetDriver() ) then return end
					ply:SetAllowWeaponsInVehicle( false ) 
					ply:EnterVehicle( seat )
					local angles = Angle(0,90,0)
					ply:SetEyeAngles( angles )
				end)
			end
		end
	end
end
net.Receive("simfphys_request_seatswitch", handleseatswitching)

hook.Add('PlayerSpawn', 'simfphys_player_allowweapon_default', function(ply)
	ply:SetAllowWeaponsInVehicle( true ) 
end)