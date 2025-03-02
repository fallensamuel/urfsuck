local light_table = {
	L_HeadLampPos = Vector(-32.85,147.6,45.07),
	L_HeadLampAng = Angle(15,90,0),
	R_HeadLampPos = Vector(32.85,147.6,45.07),
	R_HeadLampAng = Angle(15,90,0),
	
	Headlight_sprites = { 
		Vector(-32.85,147.6,45.07),
		Vector(32.85,147.6,45.07)
	},
	Headlamp_sprites = { 
		Vector(-32.85,147.6,45.07),
		Vector(32.85,147.6,45.07)
	},
	Rearlight_sprites = {
		Vector(-62.95,-153.98,47.47),
		Vector(62.95,-153.98,47.47)
	},
	Brakelight_sprites = {
		Vector(-54.66,-154.5,47.43),
		Vector(54.66,-154.5,47.43),
		Vector(28.12,-145.85,29.81),
		Vector(-28.12,-145.85,29.81),
	},
	
	Turnsignal_sprites = {
		Left = {
			Vector(-59.3,-153.26,47.1),
			Vector(-62.7,132.59,54.49)
		},
		Right = {
			Vector(59.3,-153.26,47.1),
			Vector(62.7,132.59,54.49)
		},
	},


}
list.Set( "simfphys_lights", "leopard", light_table)

local V = {
	Name = "Rh-120 L55 Leopard 2A7V",
	Model = "models/blu/tanks/leopard2a7.mdl",
	Class = "gmod_sent_vehicle_fphysics_base",
	Category = "Armed Vehicles",
	SpawnOffset = Vector(0,0,60),
	SpawnAngleOffset = 90,

	Members = {
		Mass = 20000,
		AirFriction = 7,
		--Inertia = Vector(14017.5,46543,47984.5),
		Inertia = Vector(80000,20000,100000),
		
		LightsTable = "leopard",
		
		OnSpawn = 
			function(ent)
				ent:SetNWBool( "simfphys_NoRacingHud", true )
				ent:SetNWBool( "simfphys_NoHud", true ) 
			end,
		
		ApplyDamage = function( ent, damage, type ) 
			simfphys.TankApplyDamage(ent, damage, type)
		end,
		
		GibModels = {
			"models/blu/tanks/leopard2a7_gib_1.mdl",
			"models/blu/tanks/leopard2a7_gib_2.mdl",
			"models/blu/tanks/leopard2a7_gib_3.mdl",
			"models/blu/tanks/leopard2a7_gib_4.mdl",
			"models/props_c17/pulleywheels_small01.mdl",
			"models/props_c17/pulleywheels_small01.mdl",
		},
		
		MaxHealth = 10000,
		
		IsArmored = true,
		
		NoWheelGibs = true,
		
		FirstPersonViewPos = Vector(0,-50,50),
		
		FrontWheelRadius = 40,
		RearWheelRadius = 45,
		
		EnginePos = Vector(0,-125.72,69.45),
		
		CustomWheels = true,
		CustomSuspensionTravel = 10,
		
		CustomWheelModel = "models/props_c17/canisterchunk01g.mdl",
		--CustomWheelModel = "models/props_vehicles/apc_tire001.mdl",
		
		CustomWheelPosFL = Vector(-50,122,35),
		CustomWheelPosFR = Vector(50,122,35),
		CustomWheelPosML = Vector(-50,0,37),
		CustomWheelPosMR = Vector(50,0,37),
		CustomWheelPosRL = Vector(-50,-110,37),
		CustomWheelPosRR = Vector(50,-110,37),
		CustomWheelAngleOffset = Angle(0,0,90),
		
		CustomMassCenter = Vector(0,0,8),
		
		CustomSteerAngle = 60,
		
		SeatOffset = Vector(55,25,35),
		SeatPitch = -15,
		SeatYaw = 0,
		
		ModelInfo = {
			WheelColor = Color(0,0,0,0),
		},
			
		ExhaustPositions = {
			{
				pos = Vector(-34.53,-147.48,42.92),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(34.53,-147.48,42.92),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(-34.53,-147.48,42.92),
				ang = Angle(90,-90,0)
			},
			{
				pos = Vector(34.53,-147.48,42.92),
				ang = Angle(90,-90,0)
			},
		},

		
		PassengerSeats = {
			{
				pos = Vector(0,0,40),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(0,0,50),
				ang = Angle(0,0,0)
			},
			{
				pos = Vector(0,0,50),
				ang = Angle(0,0,0)
			}
		},
		
		FrontHeight = 27,
		FrontConstant = 50000,
		FrontDamping = 30000,
		FrontRelativeDamping = 300000,
		
		RearHeight = 27,
		RearConstant = 50000,
		RearDamping = 20000,
		RearRelativeDamping = 20000,
		
		FastSteeringAngle = 20,
		SteeringFadeFastSpeed = 300,
		
		TurnSpeed = 3,
		
		MaxGrip = 1000,
		Efficiency = 1,
		GripOffset = -500,
		BrakePower = 450,
		BulletProofTires = true,
		
		IdleRPM = 600,
		LimitRPM = 3500,
		PeakTorque = 780,
		PowerbandStart = 600,
		PowerbandEnd = 2600,
		Turbocharged = false,
		Supercharged = false,
		DoNotStall = true,
		
		FuelFillPos = Vector(-53.14,-143.23,71.42),
		FuelType = FUELTYPE_DIESEL,
		FuelTankSize = 220,
		
		PowerBias = -0.3,
		
		EngineSoundPreset = 0,
		
		Sound_Idle = "simulated_vehicles/leopard/start.wav",
		Sound_IdlePitch = 1,
		
		Sound_Mid = "simulated_vehicles/leopard/low.wav",
		Sound_MidPitch = 1.3,
		Sound_MidVolume = 1,
		Sound_MidFadeOutRPMpercent = 60,
		Sound_MidFadeOutRate = 0.4,
		
		Sound_High = "simulated_vehicles/leopard/high.wav",
		Sound_HighPitch = 1.2,
		Sound_HighVolume = 1,
		Sound_HighFadeInRPMpercent = 45,
		Sound_HighFadeInRate = 0.2,
		
		Sound_Throttle = "",
		Sound_ThrottlePitch = 0,
		Sound_ThrottleVolume = 0,
		
		snd_horn = "common/null.wav",
		ForceTransmission = 1,
		
		DifferentialGear = 0.4,
		Gears = {-0.06,0,0.06,0.08,0.1,0.12,0.13}
	}
}
list.Set( "simfphys_vehicles", "simfphys_tank_tag", V )