/*
local V = {
	Name = "Bicycle/truppenfahrrad",
	Model = "models/truppenfahrrad.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "William's WW2 Vehicles",

	Members = {
		Mass = 1700,
		MaxHealth = 300,
		
		        OnDestroyed = function(ent)
            local gib = ent.Gib
            if !IsValid(gib) then return end
gib:Remove()
end,
		
		LightsTable = "",
		
		FrontWheelRadius = 20,
		RearWheelRadius = 20,

		SeatOffset = Vector(-50,0,45),
		SeatPitch = 40,
		SeatYaw = 90,
		
   PassengerSeats = {
			{
			pos = Vector(-32,0,28),
			ang = Angle(0,-90,0)
			},	
			
		},

		FrontHeight = 2,
		FrontConstant = 30000,
		FrontDamping = 4800,
		FrontRelativeDamping = 2800,
		
		RearHeight = 2,
		RearConstant = 30000,
		RearDamping = 4900,
		RearRelativeDamping = 2900,
		
		FastSteeringAngle = 10,
		SteeringFadeFastSpeed = 535,
		
		TurnSpeed = 8,
		
		MaxGrip = 65,
		Efficiency = 1,
		GripOffset = 0,
		BrakePower = 40,
		BulletProofTires = true,
		
		IdleRPM = 3500,
		LimitRPM = 5000,
		PeakTorque = 50,
		PowerbandStart = 1500,
		PowerbandEnd = 2500,
		
		FuelFillPos = Vector(17.64,-14.55,30.06),
		FuelType = FUELTYPE_PETROL,
		FuelTankSize = 65,
		
		PowerBias = 0.5,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "",
		Sound_IdleVolume = 3,
		Sound_IdlePitch = .7,
		
		Sound_Mid = "/bicycle.wav",
		Sound_MidPitch = 1,
		Sound_MidVolume = .5,
		Sound_MidFadeInRPMpercent = 200,
		Sound_MidFadeInRate = .5,   
		Sound_MidFadeOutRPMpercent = 100,		
		Sound_MidFadeOutRate = 1,                    
		
		Sound_High = "",
		Sound_HighPitch = 1,
		Sound_HighVolume = 1,
		Sound_HighFadeInRPMpercent = 100,
		Sound_HighFadeInRate = 1,
		
		Sound_Throttle = "",		
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "/ringring.wav",	
		
		ForceTransmission = 1,
		
		DifferentialGear = 0.53,
		Gears = {-0.12,0,0.1}
	}
}
list.Set( "simfphys_vehicles", "truppenfahrrad", V )
*/