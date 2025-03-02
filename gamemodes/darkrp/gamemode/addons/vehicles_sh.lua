
local Ctg = "Half-Life 2"

local Veh = {
		Name = "Jeep with Gun",
		Class = "prop_vehicle_jeep_old",
		Category = Ctg,
		Author = "VALVe",
		Information = "The regular old jeep with a gun",
		Model = "models/buggy.mdl",

		VC_Lights = {
			{ Pos = Vector(-14.8, -100, 39.2), Mat = "sprites/glow1.vmt", Alpha = 205, Size = 0.8, DynLight = true, NormalColor = "255 255 255" },
			{ Pos = Vector(-10, 48, 40), Size = 1, GlowSize = 0.8, HeadLightAngle = Angle(5, 95, 0) },
			{ Pos = Vector(10, 48, 40), Size = 1, GlowSize = 0.8, HeadLightAngle = Angle(5, 85, 0) }
		},
		
		VC_ExtraSeats = {
			{ Pos = Vector(20, -37, 19), Ang = Angle(0, 0, 0), EnterRange = 80, ExitPos = Vector(50, -25, 0), ExitAng = Angle(0, 90, 0), Model = "models/nova/jeep_seat.mdl", ModelOffset = Vector(1, -2, 0), Hide = false, DoorSounds = false, RadioControl = true },
		},
		
		VC_Horn = { Sound = "vehicles/vc_horn_light.wav", Pitch = 100, Looping = false }, 

		KeyValues = {
			vehiclescript = "scripts/vehicles/jeep_test.txt",
			EnableGun = 1
		} 
	}
list.Set("Vehicles", "hl2jeepgun", Veh)

local Veh = {
	Name = "Airboat with Gun", 
	Class = "prop_vehicle_airboat",
	Category = Ctg,

	Author = "VALVe",
	Information = "Airboat from Half-Life 2 with a gun",
	Model = "models/airboat.mdl",
	
	KeyValues = {
		vehiclescript = "scripts/vehicles/airboat.txt",
		EnableGun = 1
	}
}
list.Set("Vehicles", "hl2airboatgun", Veh)
