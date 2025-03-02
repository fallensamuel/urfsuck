-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\ecolog.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  ecolog_spawns = {
rp_stalker_urfim = {Vector(2234, -12246, -98), Vector(2237, -12336, -104), Vector(2249, -12422, -98)},
}

local model_ecolog1 = {    
"models/stalker_ecologist/ecologist_gear/ecologist_gear.mdl",
"models/stalker_ecologist/ecologist_gp5/ecologist_gp5.mdl",
"models/stalker_ecologist/ecologist_guard/ecologist_guard.mdl",
}

TEAM_ECOLOG_MLAD = rp.addTeam('Стажер НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model = {'models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl'},
	description = [[ Ты стажер в составе НИГ в ЧЗО.
	
Выполняй задания руководства научно исследовательской группы, исследуй Зону в составе группы охраны или нанятых сталкеров. 

-Подчиняется главному научному сотруднику и професору; 
-Запрещено покидать бункер без указа ведущего научного сотрудника+; 
-Запрещено покидать бункер без охраны.

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Скупку артефактов - 20;
- Сканирование территорий на наличие радиации - 15;
]],
	weapons = {"tfa_anomaly_mp5", "tfa_anomaly_walter", "weapon_art_buyer", "detector_veles", "health_kit_normal", "pass_vsu", 'weapon_dosimeter'},
	command = 'Ecolog_1',
	salary = 10,
	armor = 135, --25
	faction = FACTION_ECOLOG,
	max = 4,	
	anomaly_resistance = .25,
	spawn_points = {},
appearance = {
	{mdl = {"models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl"},
	skins = {3,4},
},
},
    experience = {
		id = "Ecolog",
			actions = 
			{
		    ["artsold"] = 20,
		    ["broom"] = 15,
   			--["stashing"] = 15,
   			["revive"] = 15, 
   			["healing"] = 15,
   			["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
          slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_ECOLOG_ANOMAL = rp.addTeam('Научный Сотрудник НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model = {'models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl'},
	description = [[ Ты научный сотрудник в составе НИГ в ЧЗО.

Выполняй задания руководства научно исследовательской группы, исследуй Зону в составе группы охраны или нанятых сталкеров. 

-Подчиняется старшему научному сотруднику и професору; 
-Запрещено покидать бункер без указа ведущего научного сотрудника; 
-Разрешено покидать бункер без охраны.

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Сканирование территорий на наличие радиации - 20;
]],
	weapons = {"tfa_anomaly_mp5", "tfa_anomaly_walter", "detector_veles", "health_kit_normal", "pass_vsu", 'weapon_dosimeter', 'weapon_art_buyer'},
	command = 'anomal_1',
	salary = 11,
	armor = 150, --25
	faction = FACTION_ECOLOG,
	max = 3,	
	anomaly_resistance = .65,
	spawn_points = {},
	--stashing = true, 
appearance = {
	{mdl = {"models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl"},
	skins = {5,6,7},
},
},
unlockExperience = {		
id = "Ecolog",
amount = 500,
},
experience = {
		id = "Ecolog",
			actions = 
			{
			["artsold"] = 25,
   			--["stashing"] = 25,
   			["revive"] = 15,
   		    ["broom"] = 20,
   		    ["healing"] = 15,
   			["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
          slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_ECOLOG_NAYCH = rp.addTeam('Ведущий Научный Сотрудник НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model = {'models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl'},
	description = [[ Ты ведущий научный сотрудник в составе НИГ в ЧЗО.
	
Выполняй задания руководства научно исследовательской группы, исследуй Зону в составе группы охраны или нанятых сталкеров. 

-Подчиняется главному научному сотруднику и професору; 
-Разрешено покидать бункер без указа профессора;
-Разрешено покидать бункер без охраны

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Скупку артефактов - 25;
- Схрон ценной документации - 25;
- Сканирование территорий на наличие радиации - 20;
]],
	weapons = {"tfa_anomaly_kiparis", "tfa_anomaly_walter", "weapon_art_buyer", "detector_veles", "health_kit_normal", "pass_vsu", 'weapon_dosimeter'},
	command = 'naych_nig',
	salary = 14,
	armor = 140, --25
	faction = FACTION_ECOLOG,
	max = 3,	
	anomaly_resistance = .5,
	spawn_points = {},
	stashing = true, 
appearance = {
	{mdl = {"models/player/stalker_ecologist/ecologist_suit/ecologist_suit.mdl"},
	skins = {0,1},
},
},
unlockExperience = {		
id = "Ecolog",
amount = 1500,
},
experience = {
		id = "Ecolog",
			actions = 
			{
		     ["artsold"] = 25,
   			["stashing"] = 25,
   			["broom"] = 20,
   			["revive"] = 20,
   			["healing"] = 15,
   		    ["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
       slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

TEAM_ECOLOG_SILI = rp.addTeam('Химик НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model ={'models/player/stalker_ecologist/ecologist_seva/ecologist_seva.mdl'},
	description = [[ Старший сотрудник НИГ, который занимается изучением артефактов и аномалий с целью улучшения стандартных положительных свойств артефактов и нейтрализацию негативных эффектов. 
	
Выходи в экспедиции только в составе хорошо подготовленной группы охраны.

-Выполняет указания Профессора; 
-Разрешено проводить экспедиции в ЧЗО; 
-Может давать указания младшим по званию сотрудникам; 
-Запрещено выходить из бункера без охраны и одного научного сотрудника. 

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Скупку артефактов - 25;
- Сканирование территорий на наличие радиации - 20;
]],
	weapons = {"tfa_anomaly_l85", "weapon_art_buyer", "tfa_anomaly_walter", "health_kit_normal", "detector_veles","pass_vsu", 'weapon_dosimeter'},
	command = 'Sili',
	salary = 20,
	armor = 250,
	stashing = true, 
    AllowWorkbench = "chemical",
	max = 1,
	faction = FACTION_ECOLOG,
	anomaly_resistance = .75,
	spawn_points = {},
unlockExperience = {		
id = "Ecolog",
amount = 2500,
},
experience = {
		id = "Ecolog",
			actions = 
			{
		     ["artsold"] = 25,
		     ["broom"] = 20,
   			["stashing"] = 25,
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
       slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

TEAM_ECOLOG_SHIFR = rp.addTeam('Главный Научный Сотрудник НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model = {'models/player/stalker_ecologist/ecologist_exoseva/ecologist_exoseva.mdl'},
	description = [[ Ты главный научный сотрудник в составе НИГ в ЧЗО.
	
Давайте задания младшим сотрудникам научно исследовательской группы. 

-Подчиняется профессору;
-Разрешено покидать бункер без указа профессора; 
-Разрешено покидать бункер без охраны.

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Схрон ценной документации - 25;
- Сканирование территорий на наличие радиации - 20;
]],
	weapons = {"tfa_anomaly_l85", "tfa_anomaly_walter", "detector_veles", "health_kit_normal", "pass_vsu", 'weapon_dosimeter', "weapon_art_buyer"},
	command = 'shifr_nig',
	salary = 15,
	armor = 225, --25
	faction = FACTION_ECOLOG,
	max = 2,	
	anomaly_resistance = .35,
    candisguise = true,  
    stashing = true,  
    disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
appearance = {
	{mdl = {"models/player/stalker_ecologist/ecologist_exoseva/ecologist_exoseva.mdl"},
	skins = {0},
},
},
unlockExperience = {		
id = "Ecolog",
amount = 3500,
},
experience = {
		id = "Ecolog",
			actions = 
			{
		     ["artsold"] = 25,
		     ["broom"] = 20,
   			["stashing"] = 25,
   			["revive"] = 20,
   			["healing"] = 15,
   			["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
       slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

TEAM_UCHENIY = rp.addTeam('Профессор НИГ', {
	color = Color(0, 186, 15),
	spawns = ecolog_spawns,
	model = {'models/nauch2.mdl'},
	description = [[Ты глава экспедиции НИГ направленной Зону.

Хоть ты и обладаешь почти энциклопедическими знаниями, но слабо владеешь оружием.

Выходи в экспедиции только в составе хорошо подготовленной группы охраны.

Торгуй с местными сталкерами ценным оборудованием, недоступным для них.

Выдавай работенку для сталкеров!

Старайся не вступать в бой, твоя жизнь очень ценна для науки. 
-Разрешено проводить экспедиции в ЧЗО; 
-Запрещено покидать бункер без сопровождения охраны и других сотрудников НИГ.

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 20;
- Скупку артефактов - 25;
- Сканирование территорий на наличие радиации - 25;

]],
	weapons = {"tfa_anomaly_mp5sd", "weapon_art_buyer", "tfa_anomaly_cz75", "health_kit_best", "detector_veles","pass_vsu", 'weapon_dosimeter'},
	command = 'ucheniy',
	salary = 21,
	armor = 150, --100
	arrivalMessage = true,
	max = 1,
	reversed = true,
	--stashing = true, 
	faction = FACTION_ECOLOG,
	anomaly_resistance = .75,
	spawn_points = {},
	canDiplomacy = true,
unlockExperience = {		
id = "Ecolog",
amount = 4500,
},
experience = {
		id = "Ecolog",
			actions = 
			{
			["artsold"] = 25,
   			["revive"] = 20,
   			["broom"] = 25,
   			["healing"] = 20,
   			["sell_vendor"] = {["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
       slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

rp.SetTeamVoices({TEAM_ECOLOG_OHRAN}, { 
	{ 
		label = 'Здравствуй', 
		sound = 'nig/jup_b6_scientist_medic_greeting_1.wav', 
		text = 'Здравствуй',
	},
	{ 
		label = 'Привет', 
		sound = 'nig/jup_b6_scientist_medic_greeting_2.wav', 
		text = 'Привет',
	},
	{ 
		label = 'Удачи тебе', 
		sound = 'nig/jup_b6_scientist_medic_farewell_1.wav', 
		text = 'Удачи тебе',
	},
	{ 
		label = 'Пока', 
		sound = 'nig/jup_b6_scientist_medic_farewell_2.wav', 
		text = 'Пока' 
	}
})
rp.SetTeamVoices({TEAM_ECOLOG_OHRAN_STAR}, { 
	{ 
		label = 'Здравствуй', 
		sound = 'nig/jup_b6_scientist_medic_greeting_1.wav', 
		text = 'Здравствуй',
	},
	{ 
		label = 'Привет', 
		sound = 'nig/jup_b6_scientist_medic_greeting_2.wav', 
		text = 'Привет',
	},
	{ 
		label = 'Удачи тебе', 
		sound = 'nig/jup_b6_scientist_medic_farewell_1.wav', 
		text = 'Удачи тебе',
	},
	{ 
		label = 'Пока', 
		sound = 'nig/jup_b6_scientist_medic_farewell_2.wav', 
		text = 'Пока' 
	}
})
rp.SetTeamVoices(TEAM_ECOLOG_MLAD, { 
	{ 
		label = 'Здравствуйте', 
		sound = 'nig/jup_b6_scientist_biochemist_greeting_1.wav', 
		text = 'Здравствуйте',
	},
	{ 
		label = 'Здравствуйте X2', 
		sound = 'nig/jup_b6_scientist_biochemist_greeting_2.wav', 
		text = 'Здравствуйте здравствуйте',
	},
	{ 
		label = 'До встречи', 
		sound = 'nig/jup_b6_scientist_biochemist_farewell_1.wav', 
		text = 'До встречи',
	},
	{ 
		label = 'Заходите ещё', 
		sound = 'nig/jup_b6_scientist_biochemist_farewell_2.wav', 
		text = 'Заходите ещё' 
	}
})
rp.SetTeamVoices(TEAM_ECOLOG_STAR, { 
	{ 
		label = 'Здравствуйте', 
		sound = 'nig/jup_b6_scientist_biochemist_greeting_1.wav', 
		text = 'Здравствуйте',
	},
	{ 
		label = 'Здравствуйте X2', 
		sound = 'nig/jup_b6_scientist_biochemist_greeting_2.wav', 
		text = 'Здравствуйте здравствуйте',
	},
	{ 
		label = 'До встречи', 
		sound = 'nig/jup_b6_scientist_biochemist_farewell_1.wav', 
		text = 'До встречи',
	},
	{ 
		label = 'Заходите ещё', 
		sound = 'nig/jup_b6_scientist_biochemist_farewell_2.wav', 
		text = 'Заходите ещё' 
	}
})
rp.SetTeamVoices({TEAM_UCHENIY, TEAM_ECOLOG_SILI}, { 
	{ 
		label = 'Подходите', 
		sound = 'nig/jup_b6_scientist_nuclear_physicist_greeting_1.wav', 
		text = 'Ааа, подходите, что у вас?',
	},
	{ 
		label = 'Да да', 
		sound = 'nig/jup_b6_scientist_nuclear_physicist_greeting_2.wav', 
		text = 'Да да, я слушаю ',
	},
	{ 
		label = 'Не задерживаю', 
		sound = 'nig/jup_b6_scientist_nuclear_physicist_farewell_1.wav', 
		text = 'Не смею вас задерживать',
	},
	{ 
		label = 'У вас всё', 
		sound = 'nig/jup_b6_scientist_nuclear_physicist_farewell_2.wav', 
		text = 'Мммм, у вас всё, тогда будьте здоровы' 
	}
})

--rp.AddToRadioChannel(rp.GetFactionTeams(FACTION_ECOLOG))

local NIG_Experiences = {
    [0]      = 1,
    [500]   = 2,
    [1500]   = 3,
    [2500]   = 4,
    [3500]   = 5,
    [4500]   = 6,
};

local NIG_Levels = {
    [1]  = 0,
    [2]  = 500,
    [3]  = 1500,
    [4]  = 2500,
    [5]  = 3500,
    [6]  = 4500,
};

rp.Experiences:GetExperienceType( "Ecolog" )
    :SetPrintName( "НИГ" )
    :SetLevelFormula( function( v, reverse )
        if reverse then
            local keys = table.GetKeys( NIG_Levels );
            table.sort( keys );

            local exp = 0;

            for k, level in ipairs( keys ) do
                if level > v then break end
                exp = NIG_Levels[level];
            end

            return exp;
        end

        --

        local keys = table.GetKeys( NIG_Experiences );
        table.sort( keys );

        local lv = 0;

        for k, experience in ipairs( keys ) do
            if experience > v then break end
            lv = NIG_Experiences[experience];
        end

        return lv;
    end )
    	:SetLevelRewards( 1, "Профессия: Научный Сотрудник НИГ")
    	:SetLevelRewards( 2, "Профессия: Ведущий Научный Сотрудник НИГ")
    	:SetLevelRewards( 3, "Профессия: Химик НИГ")
   		:SetLevelRewards( 4, "Профессия: Главный Научный Сотрудник НИГ")
   		:SetLevelRewards( 5, "Профессия: Проффесор НИГ" )
