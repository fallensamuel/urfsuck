-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\traders.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  sidor_spawns = {
	rp_stalker_urfim = {Vector(-529, -12730, -358)},
	}
	local  jew_spawns = {
	rp_stalker_urfim = {Vector(-10873, 12863, -225)},
	}
	local  krot_spawns = {
	rp_stalker_urfim = {Vector(-790, -448, 410)},
	}

	local  gavaec_spawns = {
	rp_stalker_urfim = {Vector(-5865, -7159, -152)},
	}

	local empty = {}
	
	local arena_spawns = {
	rp_stalker_urfim = {Vector(-3537, -11003, -1944), Vector(-2281, -10456, -1944), Vector(-2450, -11465, -1944), Vector(-1678, -10422, -1944), Vector(-1708, -11554, -1944), Vector(-1133, -11003, -1944), Vector(-1567, -10467, -1944), Vector(-1742, -11534, -1944), Vector(-3153, -11249, -1944)},
	}

	TEAM_ARENA = rp.addTeam('Участник Арены', { 
	color = Color(204, 204, 204), 
	model = "models/player/stalker_lone/lone_jacket/lone_jacket.mdl", 
	description = [[Ты являешься одним из участников арены.
	Твоя главная задача - победить и выиграть призовой фонд.
	Удачи тебе, сталкер!]],
	weapons = {"tfa_anomaly_knife"},
	command = 'arena', 
	salary = 0, 
	armor = 300, 
	--unlockTime = 1*3600,
	faction = FACTION_CITIZEN,
	spawns = arena_spawns,
	candemote = false,
	CantTakeWeapons = true,
	InventoryBlock = true,  
	disableDisguise = true,  
	CantUseDisguise = true,
	noHunger = true,
	build = false,
	customCheck = function(ply) return SERVER or (ply:Team() == TEAM_ARENA) end,
	})
	
	TEAM_JEW = rp.addTeam("Еврей", {
		color = Color(189, 183, 107),
		model = {
			"models/stalkernb/bandit_male3.mdl"
		},
		description = [[	
		Ты продаешь еду, оружие, аптечки, но мало что можешь предложить опытным Сталкерам.
		Скупай у сталкеров хабар, и перепродавай дороже.
		]],
		weapons = {"tfa_anomaly_toz34", "weapon_art_buyer", 'weapon_wep_buyer'},
		command = "barm2en",
		spawn_points = {},
		max = 1,
		salary = 10,
		admin = 0,
		spawns = jew_spawns,
		faction = FACTION_REFUGEES,
		reversed = true,
		minimapIcon = Material("materials/stalker/icons/barmens_logo.png"),
	})
	
	TEAM_KROT = rp.addTeam("Крот", {
		color = Color(189, 183, 107),
		model = {
			"models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl"
		},
		description = [[	
		Ты продаешь еду, оружие, аптечки, костюмы.
		Скупай у сталкеров хабар, и перепродавай дороже.
		]],
		weapons = {"tfa_anomaly_bm16_full", "weapon_art_buyer", "guitar_stalker", 'weapon_wep_buyer'},
		command = "barmen",
		spawn_points = {},
		max = 1,
		salary = 11,
		admin = 0,
		spawns = krot_spawns,
		faction = FACTION_REFUGEES,
		reversed = true,
		minimapIcon = Material("materials/stalker/icons/barmens_logo.png"),
		unlockPrice = 3000,
		unlockTime = 30*3600,
	appearance = {
	{mdl = {"models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl"},
	skins = {1},
	bodygroups = {
		[1] = {1},
		[2] = {1},
	},
		},
},
})
	
	TEAM_KOLPAK = rp.addTeam("Колпак", {
		color = Color(189, 183, 107),
		model = {
			"models/player/stalker_lone/lone_seva/lone_seva.mdl"
		},
		description = [[	
		Ты продаешь еду, оружие, аптечки, костюмы, медикаменты и снаряжение.
		Скупай у сталкеров хабар, и перепродавай дороже.
		]],
		weapons = {"tfa_anomaly_tt33", "tfa_anomaly_ak74u", "weapon_art_buyer", "guitar_stalker", 'weapon_wep_buyer'},
		command = "bsarm2en",
		spawn_points = {},
		max = 1,
		salary = 15,
		admin = 0,
		reversed = true,
		spawns = sidor_spawns,
		faction = FACTION_REFUGEES,
		minimapIcon = Material("materials/stalker/icons/barmens_logo.png"),
		unlockPrice = 7500,
		unlockTime = 100*3600,
        armor = 100,
    appearance = {
	{mdl = {"models/player/stalker_lone/lone_seva/lone_seva.mdl"},
	skins = {3},
},
},
	})
	TEAM_SHUSTRIY = rp.addTeam("Шустрый", {
		color = Color(189, 183, 107),
		model = {
			"models/player/stalker_lone/lone_novice/lone_novice.mdl"
		},
		description = [[Ты один из самых известных людей в Зоне. 
		Стал известен благодаря тому что можешь достать редкое оружие и снаряжение на заказ, однако не занимаешься "ширпотребом".
		]],
		weapons = {"tfa_anomaly_sig550", "tfa_anomaly_desert_eagle", "guitar_stalker", 'weapon_art_buyer', 'weapon_wep_buyer'},
		command = "shustriy",
		spawn_points = {},
		max = 1,
		armor = 100,
		salary = 19,
		reversed = true,
		spawns = sidor_spawns, 
		customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('shustriy', ply) end,
		admin = 0,
		faction = FACTION_REFUGEES,
		minimapIcon = Material("materials/stalker/icons/weapon_logo.png"),
		--unlockPrice = 15000,
		--unlockTime = 360*3600,
		vip = true,
	appearance = {
	{mdl = {"models/player/stalker_lone/lone_novice/lone_novice.mdl"},
	skins = {7},
},
},
	})
	
	TEAM_GAVAECKEYS = rp.addTeam("Гаваец", {
		color = Color(189, 183, 107),
		model = {
			"models/player/stalker/compiled 0.34/hawaiian.mdl"
		},
		description = [[ Покинув Янов,ты решаешь ходить по зоне и продавать свой товар.
		-Покупай дешевле,продавай дороже.
		-Делись последними слухами со сталкерами.
		]],
		weapons = {"tfa_anomaly_g36", "tfa_anomaly_pmm", "guitar_stalker", "weapon_art_buyer", 'weapon_wep_buyer'},
		command = "gavaec",
		spawn_points = {},
		max = 1,
		arrivalMessage = true,
		armor = 230,
		reversed = true,
		salary = 20,
		spawns = gavaec_spawns, 
		admin = 0,
		faction = FACTION_REFUGEES,
		minimapIcon = Material("materials/stalker/icons/weapon_logo.png"),
		likeReactions = 30,
		unlockTime = 250*3600,
	})
	/*
	TEAM_WOLFKEYS = rp.addTeam('Волк', {
	color = Color(218, 165, 32),
	model = 'models/player/stalker/compiled 0.34/wolf.mdl',
	description = [[ После последней ходки на армейские склады,ты осел в деревне новичков и обучаешь их всему что знаешь,ведь ты считаешь это своим долгом!
	-Помогай новичкам если видишь что им нужна помощь.
	-Давай задания сталкерам.
	-Не бросай товарищей-сталкеров в беде.

	]],
	command = 'wolf',
	weapons = {"swb_akm_orden", "swb_deagle", "stalker_grenade_f1", "swb_spas14"},
	salary = 12,
	max = 1,
	faction = FACTION_REFUGEES,
	reversed = true,
	armor = 350,
	anomaly_resistance = .2,	
	speed = 1.1,
	customCheck = function(ply) return CLIENT or ply:IsRoot() or rp.PlayerHasAccessToJob('wolf', ply) end,
})

TEAM_GARBAGE = rp.addTeam("Барахольщик", {
	color = Color(189, 183, 107),
    model = {'models/stalkertnb/bandit_male40.mdl'},
    description = [[Ты пришёл на территорию ЧЗО с целью заработка, но так как ловля артефактов и охота на мутантов - слишком опасное дело, ты нашёл себе новое призвание. Среди гор мусора в ЧЗО не мало ценностей, которые стоят так-же не малые деньги, именно по этому тебя прозвали "Барахольщиком".
Нашёл, забрал и убежал!
    ]],
    weapons = {"swb_ak74su_mod", "stalker_baretta_dual", "stalker_knife", "guitar_stalker", "m9k_m61_frag"},
    salary = 17,
    command = "garbage",
    spawn_points = {},
    reversed = true,
   	customCheck = function(ply) return CLIENT or (ply:GetAttributeAmount("pro") == 100) or ply:IsRoot() end,
	faction = FACTION_REFUGEES,
    CanConfiscate = true,
    armor = 160,
    max = 1,
	CanSelfRevive = true,
    speed = 1.5,
	stamina = 2,
})

    TEAM_SIDORIVENT = rp.addTeam("Сидорович", {
		color = Color(189, 183, 107),
		model = {
			"models/legends/sidor2.mdl"
		},
		description = [[ Профессия для Глобальных Событий
		Продавай дорого, скупай дешево, кушай курочку..

		БРАТЬ ТОЛЬКО ПО ОДНОРАЗОВОМУ РАЗРЕШЕНИЮ МЕНЕДЖЕРА!
		]],
		weapons = {"m9k_fists", "weapon_art_buyer", "weapon_art_buyer", "weapon_wep_buyer"},
		command = "sidorivent",
		max = 1,
		reversed = true,
		arrivalMessage = true,
		salary = 20,
		faction = FACTION_REFUGEES,
		minimapIcon = Material("materials/stalker/icons/vendor_logo.png"),
		PlayerSpawn = function(pl) pl:GodEnable(true) pl:SetWalkSpeed(60) pl:SetRunSpeed(160) end,
		customCheck = function(ply) return 
			ply:IsRoot()
			or rp.PlayerHasAccessToCustomJob({'sidorivent'}, ply:SteamID64())
			end,
	})

	TEAM_DOG = rp.addTeam('Український Піс', {
		color = Color(189, 183, 107),
		model = 'models/falloutdog/falloutdog.mdl',
		description = [[ Милый хлебушек который ищет нового хозяина
	]],
		weapons = {'weapon_dogswep'},
		PlayerSpawn = function(ply) ply:SetRunSpeed(300) end,
		command = 'dog',
		build = false,
		max = 2,
		salary = 7,
		admin = 0,
		candemote = false,
		hirable = true,
		hirePrice = 500,
		health = 50,
		stamina = 90,
		unlockTime = 5*3600,
		unlockPrice = 300,
		faction = FACTION_REFUGEES,
		disableDisguise = true,
		InventoryBlock = true, 
	})

	TEAM_GHOSTCITIZEN = rp.addTeam('Призрак Сталкера', {
		color = Color(49, 189, 129),
		model = 'models/oso/oso_exo.mdl',
		description = [[ Дух одного из известных Сталкеров, провел так много времени в ЧЗО, что даже после смерти Зона не отпускает его. 
		Ты вынужден бродить и наблюдать за происходящим, изредка давая советы одиноким Сталкерам, попавшим в беду.
	
		Никто не видит тебя и не может заговорить с тобой пока ты не обратишься к нему.
		Запрещено напрямую взаимодействовать с кем-либо, использовать оружие/снаряжение/предметы.
		]],
		command = 'ghostcitizen',
		weapons = {"sh_blinkswep", "weapon_physgun", "gmod_tool"},
		salary = 25,
		faction = FACTION_REFUGEES,
		PlayerSpawn = function(pl) pl:GodEnable(true) end,
		unlockTime = 2500 * 3600,
		unlockPrice = 50000,
		exoskeleton = true,
		spawns = master_spawns, 
		reversed = true,
		build = false,
		speed = 1.1,
		stamina = 1000,
	})


TEAM_STRELOK = rp.addTeam("Стрелок", {
	color = Color(189, 183, 107),
	model = {
		"models/player/stalker/compiled 0.34/streloksunrise.mdl","models/player/stalker/compiled 0.34/coprookiestrelok.mdl"
	},
	description = [[Самый известный сталкер и этим все сказано. 
	Побывавший во всевозможных лабораториях, лично отключивший 
	Выжигатель Мозгов и рагадавший главную тайну Зоны.
	]],
	weapons = {"m9k_machete", "weapon_medkit", "armor_kit", "stalker_grenade_f1", "guitar_stalker"},
	command = "strelok",
	spawn_points = empty,
	max = 1,
	salary = 25,
	armor = 600,
	arrivalMessage = true,
	spawns = master_spawns, 
	health = 250,
	speed = 1.2,
	forceLimit = true,
	faction = FACTION_REFUGEES,
	--unlockTime = 350*3600,
	customCheck = function(ply) return ply:HasUpgrade('strelok')  or rp.PlayerHasAccessToJob('strelok', ply) or ply:IsRank('globalcontributor') or ply:IsRank('platinumcontributor')  or ply:IsRank('goldencontributor')  or ply:IsRank('vip+') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() end,
	appearance = {
		{
			mdl        = "models/player/stalker/compiled 0.34/streloksunrise.mdl",
			skins      = {0,10},
			bodygroups = {
				[1] = nil,
				[2] = {0,1,3,5,6},
				[3] = {0,1,2,3,4},
				[4] = {0,1,2}
			}
		},
		{
			mdl        = "models/player/stalker/compiled 0.34/coprookiestrelok.mdl",
			skins      = {0,1},
			bodygroups = {
				[1] = nil,
				[2] = {0},
				[3] = {0,1,2,3,4},
				[4] = {0,1,2}
			}
		},
	},
})

 rp.AddJobArmory(TEAM_STRELOK, "Начальный", 0, isNoDonate && {'swb_dragunov', 'swb_sg550', 'swb_spas14', 'swb_colt',"detector_bear"} || {'swb_gauss', 'swb_sg550', 'swb_spas14', 'swb_colt',"pass_vsu","detector_bear"})
 rp.AddJobArmory(TEAM_STRELOK, "Обжившийся", 1200000, isNoDonate && {'swb_gauss', 'swb_m4desert', 'swb_spas14', 'swb_deagle',"pass_vsu","detector_veles"} || {'swb_gauss2', "m9k_m79gl", 'swb_f2000', 'swb_sayga_kekler', 'swb_deagle_gold',"pass_vsu","detector_veles"})
*/
/*
TEAM_CROW = rp.addTeam("Ворона", {
	color = Color(35, 42, 52),
	model = {"models/crow.mdl"},
	description = [[Везунчик, специальная профессия!
	]],
	salary = 3,
	spawn_points = empty,
	command = "crow",
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	health = 50,
	customCheck = function(ply) return ply:HasUpgrade('job_crow')  or ply:IsRank('globalcontributor') or ply:IsRank('platinumcontributor')  or ply:IsRank('goldencontributor')  or ply:IsRank('vip+') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() end,
	build = false,
	disableDisguise = true,
	InventoryBlock = true, 
})

TEAM_PIGEON = rp.addTeam("Голубь", {
	color = Color(150, 151, 165),
	model = {"models/pigeon.mdl"},
	description = [[-300
]],
	salary = 3,
	spawn_points = empty,
	command = "pigeon",
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	spawns = birds_spawns,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	customCheck = function(ply) return ply:HasUpgrade('job_pigeon') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() end,
	build = false,
	disableDisguise = true,
	InventoryBlock = true, 
})

	TEAM_PARROT = rp.addTeam("Попугай", {
	color = Color(150, 151, 165),
	model = {"models/tsbb/parrot.mdl"},
	description = [[Птица Попугай
]],
	salary = 7,
	spawn_points = empty,
	command = "parrot",
	reversed = true,
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	spawns = birds_spawns,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	customCheck = function(ply) return (ply:IsRoot() or ply:HasUpgrade('job_parrot') or rp.PlayerHasAccessToJob('parrot', ply)) end,
	build = false,
	disableDisguise = true,
	InventoryBlock = true, 
})

	TEAM_GOAT = rp.addTeam('Коза', {
	color = Color(145, 142, 137),
	model = 'models/goatplayer/goat_player.mdl',
	description = [[Обычная коза, способная больно бодаться и испражняться где попало.

Правила:
- Категорически запрещено ношение и использование оружия;
- Кусать можно только в целях самозащиты или если приказал хозяин;
]],
	weapons = {'weapon_goat'},
	command = 'dongoat',
	max = 3,
	salary = 5,
	admin = 0,
	candemote = false,
	hirable = true,
	hirePrice = 5000,
    disableDisguise = true,
	build = false,
	PlayerSpawn = function(pl)
		pl:SetHealth(200)
	end,
	faction = FACTION_REFUGEES,
	customCheck = function(ply) return ply:HasUpgrade('job_goat') or rp.PlayerHasAccessToCustomJob({'Sponsop donat'}, ply:SteamID64()) end,
	InventoryBlock = true, 
}) 
*/
	--rp.AddDoorGroup('Бар', {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_IOHAN, TEAM_SIDORIVENT,TEAM_GAVAECKEYS})
	--rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_CITIZEN, FACTION_REFUGEES})))
	

	rp.SetTeamVoices(TEAM_DOG, { 
	})

	rp.SetTeamVoices(TEAM_KOLPAK,TEAM_GAVAECKEYS, { 
		{ 
			label = 'Подходи брат', 
			sound = 'torgashi/jup_a6_stalker_barmen_greeting_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Аллоха', 
			sound = 'torgashi/jup_a6_stalker_barmen_greeting_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Ты заглядывай', 
			sound = 'torgashi/jup_a6_stalker_barmen_farewell_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Пакедова', 
			sound = 'torgashi/jup_a6_stalker_barmen_farewell_2.wav', 
			text = '*Диалог*' 
		}
	})
	rp.SetTeamVoices(TEAM_KROT, { 
		{ 
			label = 'Приветствие1', 
			sound = 'torgashi/jup_ashot_trader_meet_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Приветствие2', 
			sound = 'torgashi/jup_ashot_trader_meet_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Приветствие3', 
			sound = 'torgashi/jup_ashot_trader_meet_3.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Прощание1', 
			sound = 'torgashi/jup_ashot_trader_meet_bye_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Прощание2', 
			sound = 'torgashi/jup_ashot_trader_meet_bye_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Прощание3', 
			sound = 'torgashi/jup_ashot_trader_meet_bye_3.wav', 
		}
	})
	rp.SetTeamVoices(TEAM_JEW, { 
		{ 
			label = 'Ну что', 
			sound = 'torgashi/zat_b30_owl_stalker_trader_greeting_1.wav', 
			text = 'Ну что, есть что-то новое?',
		},
		{ 
			label = 'Да чё ты', 
			sound = 'torgashi/zat_b30_owl_stalker_trader_greeting_2.wav', 
			text = 'Да чё ты топчешься, если есть что - выкладывай, нет - проваливай. ',
		},
		{ 
			label = 'Иди иди', 
			sound = 'torgashi/zat_b30_owl_stalker_trader_farewell_1.wav', 
			text = 'Иди иди, нечего тебе тут делать',
		},
		{ 
			label = 'Давай давай', 
			sound = 'torgashi/zat_b30_owl_stalker_trader_farewell_2.wav', 
			text = 'Давай давай, не задерживайся' 
		}
	})
	rp.SetTeamVoices(TEAM_SHUSTRIY, { 
		{ 
			label = 'Привет сталкер', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Здаров', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Привет', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_3.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Товар будет', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_not_ready_1.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Зайди по позже', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_not_ready_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Заказ не готов', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_not_ready_3.wav', 
			text = '*Диалог*',
		},
		/*
		{ 
			label = 'Заказ выполнен', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_ready_1.wav', 
			text = '*Диалог*',
		},
		*/
		{ 
			label = 'Товар у меня', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_ready_2.wav', 
			text = '*Диалог*',
		},
		{ 
			label = 'Забирай товар', 
			sound = 'torgashi/zat_b51_stalker_nimble_greeting_order_ready_3.wav', 
			text = '*Диалог*',
		},
	})
	rp.SetTeamVoices(TEAM_SIDORIVENT, { 
		{ 
		}
	})
	rp.SetTeamVoices(TEAM_GHOSTCITIZEN, { 
		{ 
		}
	})
	--rp.AddToRadioChannel({TEAM_SHUSTRIY, TEAM_SIDORIVENT}, rp.GetFactionTeams(FACTION_CITIZEN, FACTION_REFUGEES))