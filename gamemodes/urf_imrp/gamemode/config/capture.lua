rp.cfg.CaptureIncomePerPoint = 10
rp.cfg.CaptureCooldown = 300
rp.cfg.DefaultPointPrice = 0

rp.cfg.CaptureVehicleRespawnDuration = 10

rp.cfg.ConjunctionTimeout = 10

rp.cfg.CaptureFlagSpeed = 50

rp.cfg.CaptureDurationMin = 100
rp.cfg.CaptureDurationMax = 300
rp.cfg.CaptureDurationIncrease = 30



if not rp.cfg.CantCapture then
	rp.cfg.CantCapture = {}
	local teams = {}
		teams = rp.GetFactionTeamsMap({FACTION_CITIZEN, FACTION_OUTLAWS, FACTION_REFUGEES})
	
	for k,v in pairs(rp.teams) do
		if not teams[k] then
			rp.cfg.CantCapture[k] = true
		end
	end
end

local ALLIANCE_ALLIANCE = rp.Capture.AddAlliance {
	name = 'Aliance',
	printName = 'Альянс',
	factions = {
		[FACTION_MPF] = true,
		[FACTION_OTA] = true,
		[FACTION_CMD] = true,
		[FACTION_GRID] = true,
		[FACTION_HELIX] = true,
	},
	flagMaterial = 'https://i.imgur.com/YirsRvm.png'
}

local ALLIANCE_REBELS = rp.Capture.AddAlliance {
	name = 'Rebels',
	printName = 'Повстанцы',
	factions = {
		[FACTION_REBEL] = true,
	},
	flagMaterial = 'https://styles.redditmedia.com/t5_2rgym/styles/communityIcon_mnkjitrq97431.png'
}

local ALLIANCE_ZOMBIE = rp.Capture.AddAlliance {
	name = 'Zombie',
	printName = 'Зомби',
	factions = {
		[FACTION_ZOMBIE] = true,
	},
	flagMaterial = 'https://i.imgur.com/mgQQpqn.png'
}

--Combine
rp.ConjSetInvalid(ALLIANCE_ALLIANCE, CONJ_UNION, {ALLIANCE_REBELS, ALLIANCE_ZOMBIE})
rp.ConjSetInvalid(ALLIANCE_ALLIANCE, CONJ_NEUTRAL, {ALLIANCE_REBELS, ALLIANCE_ZOMBIE})

--Rebels
rp.ConjSetInvalid(ALLIANCE_REBELS, CONJ_UNION, {ALLIANCE_ALLIANCE, ALLIANCE_ZOMBIE})
rp.ConjSetInvalid(ALLIANCE_REBELS, CONJ_NEUTRAL, {ALLIANCE_ALLIANCE, ALLIANCE_ZOMBIE})
--Zombie
rp.ConjSetInvalid(ALLIANCE_ZOMBIE, CONJ_UNION, {ALLIANCE_REBELS, ALLIANCE_ALLIANCE})
rp.ConjSetInvalid(ALLIANCE_ZOMBIE, CONJ_NEUTRAL, {ALLIANCE_REBELS, ALLIANCE_ALLIANCE})


--С17
local POINT_D4 = rp.AddCapturePoint('rp_city17_alyx_urfim', 'd4new')
	:SetPrintName('Сектор D4')
	:SetPos({Vector(3183.203125, 7174.395508, 24), Vector(5081.591309, 7865.951172, 664.200012)})
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(4168, 7408, 24)) 

	POINT_D4:AddBonusBox('models/props_marines/ammocrate01_static.mdl')
		:SetPrintName('Амуниция')
		:SetPos(Vector(4187.881836, 7668.089844, 46.618774), Angle(-0.011, 101.535, -0.009))
		:SetAddMoney(150)
		:SetGiveAmmo("smg1", 120) 
		:SetGiveAmmo("ar2", 60) 
		:SetGiveAmmo("Buckshot", 25)
		:SetGiveArmor(35)

	POINT_D4:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Набор Оружия')
		:SetPos(Vector(4192.170410, 7750.402832, 48.477493), Angle(-0.017, -16.507, 0.009))
		:SetWeaponDefault('swb_pistol','swb_shotgun')

local POINT_D6 = rp.AddCapturePoint('rp_city17_alyx_urfim', 'd6new')
	:SetPrintName('Сектор D6')
	:SetPos({Vector(326.289703, -1561.712891, 24), Vector(1030.361938, -175.531219, 465.749969)})
	:SetWipe(true)
	:SetOwnDoors(true)
	:SetFlagPos(Vector(659, -795, 24)) 

	POINT_D6:AddBonusBox('models/props_marines/ammocrate01_static.mdl')
		:SetPrintName('Амуниция')
		:SetPos(Vector(1035.951294, -604.285461, 46.532883), Angle(0.003, -15.358, -0.002))
		:SetAddMoney(300)
		:SetGiveAmmo("smg1", 120) 
		:SetGiveAmmo("ar2", 60) 
		:SetGiveAmmo("Buckshot", 25)
		:SetGiveArmor(50)

	POINT_D6:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Набор Оружия')
		:SetPos(Vector(856.224731, -574.627930, 48.397217), Angle(0.000, -0.000, 0.000))
		:SetWeaponDefault('swb_357','swb_ar2')


--С17org
local POINT_STREET = rp.AddCapturePoint('rp_city17_alyx_urfim', 'streetcaptnew')
	:SetPrintName('Жилой Район')
	:SetPos({Vector(303.533051, 1759.230469, 128), Vector(1401.735229, 2361.593750, 628.103699)})
	:SetIsOrg(true)
	:SetWipe(true)
	:SetFlagPos(Vector(585, 2196, 176)) 

	POINT_STREET:AddBonusBox('models/items/ammocrate_smg1.mdl')
		:SetPrintName('Набор Оружия')
		:SetPos(Vector(287.576935, 2084.031494, 192.325485), Angle(-0.000, 0.000, 0.000))
		:SetAddMoney(300)
		:SetWeaponDefault('swb_pistol')

hook.Call("CapturePointsLoaded")