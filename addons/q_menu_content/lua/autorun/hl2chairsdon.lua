local function AddVehicle( t, class )
	list.Set( "Vehicles", class, t )
end

local Category = "Chairs Extended"

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

AddVehicle( {
	Name = "Wooden Chair 02",
	Model = "models/nova/chair_wood02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Wooden Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Wood_02" )

AddVehicle( {
	Name = "Crane Chair 01",
	Model = "models/crane/chair_crane01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Crane Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Crane_01" )

AddVehicle( {
	Name = "Controlroom Chair 01",
	Model = "models/seats/controlroom_chair001a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Controlroom Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Controlroom_01" )

AddVehicle( {
	Name = "Armchair 01",
	Model = "models/seats/furniturearmchair001a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "An Armchair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Armchair_01" )

AddVehicle( {
	Name = "Furniture Chair 01",
	Model = "models/seats/furniture_chair01a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Furniture Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Furniture_01" )

AddVehicle( {
	Name = "Furniture Chair 03",
	Model = "models/seats/furniture_chair03a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Furniture Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Furniture_03" )

AddVehicle( {
	Name = "Furniture Couch 02",
	Model = "models/seats/furniture_couch02a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Furniture Couch",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Couch_Furniture_02" )

AddVehicle( {
	Name = "Stool Chair 01",
	Model = "models/seats/chair_stool01a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Stool Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Stool_01" )

AddVehicle( {
	Name = "Furniture Couch 01",
	Model = "models/seats/furniturecouch001a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Furniture Couch",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Couch_Furniture_01" )

AddVehicle( {
	Name = "Furniture Toilet 01",
	Model = "models/seats/furnituretoilet001a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Furniture Toilet",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Toilet_Furniture_01" )

AddVehicle( {
	Name = "Traincar Seat 01",
	Model = "models/seats/traincar_seats001.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Traincar Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Traincar_01" )

AddVehicle( {
	Name = "Hatchback Seat 01",
	Model = "models/seats/seat001a_hatchback.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Hatchback Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Hatchback_01" )

AddVehicle( {
	Name = "Truck Seat 01",
	Model = "models/seats/seat_truck001a.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Truck Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Truck_01" )

AddVehicle( {
	Name = "CS_Office Chair 01",
	Model = "models/seats/chair_office.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "An Office Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office_01" )

AddVehicle( {
	Name = "Bar Stool 01",
	Model = "models/seats/barstool01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Bar Stool",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Stool_Bar_01" )

AddVehicle( {
	Name = "Sofa Chair 01",
	Model = "models/seats/sofa_chair.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Sofa Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Sofa_Chair_01" )

AddVehicle( {
	Name = "Patio Chair 01",
	Model = "models/seats/patio_chair.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Patio Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Patio_01" )

AddVehicle( {
	Name = "Patio Chair 02",
	Model = "models/seats/patio_chair2.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Patio Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Patio_02" )

AddVehicle( {
	Name = "Antique Chair 01",
	Model = "models/seats/chairantique.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Antique Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Antique_01" )

AddVehicle( {
	Name = "Armchair 02",
	Model = "models/seats/armchair.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "Facepunch / Donald",
	Information = "An Armchair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Armchair_02" )

AddVehicle( {
	Name = "Airboat Seat 02",
	Model = "models/seats/airboat_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "An Airboat Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Airboat_02" )

AddVehicle( {
	Name = "Office Chair 02",
	Model = "models/seats/chair_office02.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "An Office Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office_HL2_02" )

AddVehicle( {
	Name = "Office Chair 01",
	Model = "models/seats/chair_office01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "An Office Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Office_HL2_01" )

AddVehicle( {
	Name = "Metal Chair 01",
	Model = "models/seats/chair_plastic01.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Metal Chair",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Chair_Metal_01" )

AddVehicle( {
	Name = "Jalopy Seat 01",
	Model = "models/seats/jalopy_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Jalopy Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Jalopy_01" )

AddVehicle( {
	Name = "Jeep Seat 01",
	Model = "models/seats/jeep_seat.mdl",
	Class = "prop_vehicle_prisoner_pod",
	Category = Category,

	Author = "VALVe / Donald",
	Information = "A Jeep Seat",

	KeyValues = {
		vehiclescript = "scripts/vehicles/prisoner_pod.txt",
		limitview = "0"
	},
	Members = {
		HandleAnimation = HandleRollercoasterAnimation,
	}
}, "Seat_Jeep_01" )