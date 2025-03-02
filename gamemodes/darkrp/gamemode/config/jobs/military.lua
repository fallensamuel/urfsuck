-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\military.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local empty = {}

local  military_spawns = {
rp_stalker_urfim_v3 = {Vector(-14055, -12021, -4064), Vector(-13864, -12036, -4064), Vector(-13635, -12053, -4064)},
rp_pripyat_urfim = {Vector(5421, -7018, 16), Vector(5472, -6630, 16), Vector(5463, -6980, 16)},
rp_stalker_urfim = {Vector(-11831, -12403, -330), Vector(-11825, -12126, -330), Vector(-11833, -12700, -330)},
rp_st_pripyat_urfim = {Vector(-2053, -7119, 0), Vector(-2276, -7083, 0)}
}
local  militarys_spawns =  {
rp_stalker_urfim_v3 = {Vector(-9902, -14337, -4152), Vector(-9897, -14201, -4152), Vector(-9721, -14204, -4152), Vector(-9727, -14410, -4152)},
rp_pripyat_urfim = {Vector(5421, -7018, 16), Vector(5472, -6630, 16), Vector(5463, -6980, 16)},
rp_stalker_urfim = {Vector(-2347, -12745, -384), Vector(-2398, -13033, -384), Vector(-2196, -13203, -384)},
rp_st_pripyat_urfim = {Vector(-2053, -7119, 0), Vector(-2042, -7125, 0)}
}
local militaryt_spawns = {
rp_stalker_urfim_v3 = {Vector(-13457, -10083, -4080), Vector(-13410, -10260, -4080), Vector(-13717, -10039, -4080)},
rp_stalker_urfim = {Vector(-10205, -11556, -360), Vector(-10213, -11993, -360)}
}

TEAM_RCT = rp.addTeam("Солдат ВСУ", {
	color = Color(0, 72, 255, 255),
	model = "models/player/stalker_soldier/soldier_bandana_0/soldier_bandana_0.mdl",
	description = [[
Призывник Вооруженных сил Украины прибыл на периметр Чернобыльской Зоны Отчуждения для охраны ее от незаконных проникновений. Работай усердно и тогда, может быть, заслужишь себе повышение.

• Чистить картошку - твоё призвание;
• Проверка документов;
• Выполнение приказов;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Сержанту ВСУ и старше.
Командует: Никем.
	]],
	weapons = {"tfa_anomaly_ak74m", 'tfa_anomaly_hpsa', "weapon_stunstick","salute", "pass_vsu"},
	spawns = military_spawns,
	spawn_points = {},
	salary = 7,
	armor = 120,
	command = 'rct',
	faction = FACTION_MILITARY,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	appearance = {
	{mdl = {"models/player/stalker_soldier/soldier_bandana_0/soldier_bandana_0.mdl"},
	bodygroups = {
		[1] = {0},
	},
		},
},
	slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

TEAM_EFREI = rp.addTeam("Сержант ВСУ", {
	color = Color(0, 72, 255, 255),
	model = "models/player/stalker_soldier/soldier_bandana_1/soldier_bandana_1.mdl",
	description = [[
Отслужив некоторое время рядовым тебя повысили за твои заслуги, теперь ты не последний человек в армии.

• Охрана блокпоста;
• Следи за рядовыми;
• Выполнение приказов вышестоящих;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Лейтенанту и старше.
Командует: Солдатами ВСУ.

	]],
	weapons = {"salute", "weapon_stunstick", "pass_vsu"},
	spawns = military_spawns,
	spawn_points = {},
	salary = 8,
    unlockTime = 15*3600,   
    unlockPrice = 1500, --275000  
    armor = 190,
    forceLimit = true,
    max = 5, 
	command = 'efrei',
	faction = FACTION_MILITARY,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
appearance = {
	{mdl = {"models/player/stalker_soldier/soldier_bandana_1/soldier_bandana_1.mdl"},
	bodygroups = {
		[1] = {0},
	},
		},
},
	     slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

 rp.AddJobArmory(TEAM_EFREI, "Стандартный", 0, {"tfa_anomaly_ak74m",'tfa_anomaly_hpsa'})
 rp.AddJobArmory(TEAM_EFREI, "Снайпер", 12000, {'tfa_anomaly_svd', 'tfa_anomaly_hpsa'})
 rp.AddJobArmory(TEAM_EFREI, "Разведчик", 17200, {'tfa_anomaly_l85', "tfa_anomaly_hpsa"})

TEAM_VSU_VENDOR = rp.addTeam("Лейтенант ВСУ", {
	color = Color(0, 72, 255, 255),
	model = "models/player/stalker_soldier/soldier_beret_0/soldier_beret_0.mdl", 
	description = [[
Етижи-пасатижи, да ты никак животик отрастил, солдат! Не зря ты стал прапором... Ты ответственный за склад и все вещи на нём. Поставляй своим коллегам продовольствие, оружие и чистые трусы. Ты, конечно, можешь пиздить со склада всё, что широкой украинской душе и морде только вздумается, но трижды подумай: надо ли тебе терпеть десяток нарядов вне очереди.

• Снабжай ВСУ всем необходимым;
• Не перечь старшим по чину о цене товаров;
• Не жлобись и давай зелени развиться;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Капитану ВСУ и старше.
Командует: Сержантам ВСУ и ниже.
	]],
	weapons = {"salute", "weapon_stunstick", "pass_vsu", "weapon_cuff_elastic"},
	spawns = military_spawns,
	spawn_points = {},
    max= 2,
    forceLimit = true,
	salary = 12,
	command = 'vendor',
	armor = 270,
	faction = FACTION_MILITARY,
	unlockTime = 65 * 3600, --100
	unlockPrice = 4500, --275000
	--exoskeleton = true,
	canCapture = true,
	experience = {
	id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	     slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

 rp.AddJobArmory(TEAM_VSU_VENDOR, "Стандартный", 0, {"tfa_anomaly_val","tfa_anomaly_hpsa"})
 rp.AddJobArmory(TEAM_VSU_VENDOR, "Пулемётчик", 36000, {'tfa_anomaly_rpk', 'tfa_anomaly_knife_combat', "tfa_anomaly_desert_eagle"})

TEAM_CASESPEC1 = rp.addTeam("Разведчик ВСУ", { 
	color = Color(0, 51, 102),
	model = {'models/stalker_soldier/stalker_soldier_5.mdl'},
	description = [[
Ты основная единица разведотряда. Шпионить за вражескими единицами и докладывайте любую информацию штабу.

Задачи:
- Защита стратегических точек;
- Охота на нелегалов;
- Разведывай территории необъятной ЧЗО;

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Капитану ВСУ и старше.
Командует: Никем.
	]], 
	weapons = {"tfa_anomaly_groza_nimble", "tfa_anomaly_sv98", "tfa_anomaly_desert_eagle", "weapon_cuff_elastic", "tfa_anomaly_knife_combat", "pass_vsu"},
	command = "casespecone", 
	salary = 16, 
	armor = 275, 
	max = 1,
	forceLimit = true,
	customCheck = function(ply) return (ply:IsRoot() or rp.PlayerHasAccessToJob('casespecone', ply)) end,
	spawns = military_spawns, 
	faction = FACTION_MILITARY, 
    candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
	speed = 1.10,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
}) 

TEAM_UNIONOFC = rp.addTeam("Капитан ВСУ", {
	color = Color(0, 72, 255, 255),
	model = {'models/player/stalker_soldier/soldier_bulat/soldier_bulat.mdl'},
	description = [[ 
Вершина младшего офицерского состава. Ты ответственен за все вылазки ВСУ, руководишь действиями состава во время вылазок и в свободное время. Тебе доверен сильный комплект брони в связке с достойным оружием, так что не потеряй снаряжение, а то в прошлый раз еле отмазался.

• Руководи коллегами помладше и решай проблемы армии;
• Бумажная волокита - твоё второе имя;
• Следи за выполнением обязанностей твоих подчинённых;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Майору ВСУ и старше.
Командует: Лейтенантам ВСУ и ниже.

	]],
	weapons = {"salute", "weapon_stunstick", "pass_vsu", "weapon_cuff_elastic"},
	spawns = military_spawns,
	spawn_points = {},
	salary = 12,
	command = 'ofc',
	armor = 450,
	faction = FACTION_MILITARY,
	unlockTime = 125 * 3600,
	unlockPrice = 8500, --300000
	max = 2,
	forceLimit = true,
	canCapture = true,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
         slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

 rp.AddJobArmory(TEAM_UNIONOFC, "Стандартный", 0, {"tfa_anomaly_rpd","tfa_anomaly_fort500", 'tfa_anomaly_f1'})
 rp.AddJobArmory(TEAM_UNIONOFC, "Штурмовик", 38400, {'tfa_anomaly_abakan', 'tfa_anomaly_saiga', "tfa_anomaly_beretta", 'tfa_anomaly_f1'})
 rp.AddJobArmory(TEAM_UNIONOFC, "Сапёр", 45000, {'weapon_c4', 'tfa_anomaly_ak105', "tfa_anomaly_desert_eagle", 'tfa_anomaly_f1', "door_ram"})

TEAM_SNIPERMAY = rp.addTeam("Майор ВСУ", {
	color = Color(0, 72, 255, 255),
	model = "models/player/stalker_soldier/soldier_beret_2/soldier_beret_2.mdl", 
	description = [[
Ты начало высшего состава! Тебе вручили сексуальный берет и потрёпанный костюм. Поскольку хорошего вооружения тебе не досталось, ты в основном сидишь в кабинете и раздаёшь приказы, покуривая сигарету... А неплохо было бы, но это лишь сон. Вставай, гоблин, там рядовой капитану морду набил.

• Следи за порядком на базе и КПП;
• Следи за соблюдением устава у личного состава;
• Решай проблемы, которые призывники не в силах решить сами;
• Организуй вылазки и оборону;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Подчиняется: Подполковнику ВСУ и выше.
Командует: Капитанам ВСУ и ниже.

	]],
	weapons = {"salute", "weapon_stunstick", "weapon_cuff_shackles","pass_vsu"},
	spawns = military_spawns,
	spawn_points = {},
	salary = 16,
	command = 'snipermay',
	armor = 450,
	health = 120,
	faction = FACTION_MILITARY,
	unlockTime = 165 * 3600, --150
	unlockPrice = 16500, --400000
	max = 3,
	forceLimit = true,
	canCapture = true,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	     slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

 rp.AddJobArmory(TEAM_SNIPERMAY, "Стандартный", 0, {"tfa_anomaly_aek973","tfa_anomaly_fort500"})
 rp.AddJobArmory(TEAM_SNIPERMAY, "Стрелок", 38400, {'tfa_anomaly_protecta', 'tfa_anomaly_fal', "tfa_anomaly_beretta"})

TEAM_EPU = rp.addTeam("Подполковник ВСУ", {
	color = Color(0, 72, 255, 255),
	model = {'models/player/stalker_soldier/soldier_exo/soldier_exo.mdl'},
	description = [[
Отслужив немало лет на территории ЧЗО, ты стал подполковником, мои поздравления. Отныне ты большая шишка в ВСУ, не опозорь свои войска, как предыдущий подполковник, которого нашли в болоте, пьяного в хлам.

• Устраивай различного рода тренировки для личного состава;
• Руководи офицерским составом;
• Не перетрудись! В зоне всякое бывает...
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Механик-Водитель и ниже.
Подчиняется: Полковнику и старше.

	]],
	weapons = {"tfa_anomaly_hpsa", "tfa_anomaly_ak103","salute","weapon_cuff_elastic","pass_vsu"},
	spawns = military_spawns,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('epu', ply) end,
	spawn_points = {},
	salary = 20,
	command = 'epu',
	max = 2,
	armor = 450, --180
	forceLimit = true,
	health = 150,
	faction = FACTION_MILITARY,
	canDiplomacy = true,
	--unlockTime = 235 * 3600,
	--unlockPrice = 17500, --500000
	canCapture = true,
	exoskeleton = true,
	vip = true,
	experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	appearance = {
	{mdl = {"models/player/stalker_soldier/soldier_exo/soldier_exo.mdl"},
	bodygroups = {
		[1] = {0},
	},
		},
},
})


TEAM_SEC = rp.addTeam("Полковник ВСУ", {
	color = Color(0, 72, 255, 255),
	model = {'models/player/stalker_soldier/soldier_seva/soldier_seva.mdl'},
	description = [[ 
Ты полковник ВСУ. Звание полковника является высшим офицерским званием. Был прислан руководить составом КПП-21 в ЧЗО. Отвечаешь за каждый уголок территории периметра.

• Следи за работоспособностью своего полка;
• Организуй масштабные операции на территории ЧЗО;
• Руководи каждой душой на территории периметра;
• Может устраивать вылазки;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Подполковник и ниже.
Подчиняется: Генерал и старше.
	]],
	weapons = {"tfa_anomaly_colt1911", "tfa_anomaly_ak105","salute","weapon_cuff_elastic","pass_vsu"},
	spawns = military_spawns,
	spawn_points = {},
	salary = 20,
	command = 'sec',
	max = 1,
	admin = 0,
	candemote = true,
	vote = false,
	hasLicense = false,
	upgrader = {["officer_support"] = true},
	armor = 500, --200
	health = 170,
	faction = FACTION_MILITARY,
	canDiplomacy = true,
	unlockTime = 275 * 3600,
	unlockPrice = 27500, --1100000
	canCapture = true,
	exoskeleton = true,
	experience = {
	id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	     slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

TEAM_GENERAL = rp.addTeam("Генерал армии Украины", {
	color = Color(0, 72, 255, 255),
	model = {"models/player/stalker_soldier/soldier_bulat_proto/soldier_bulat_proto.mdl"},
	description = [[ 
Начальник всея блокпоста чернобыльского. Отныне ты владеешь самым высоким чином из доступных. Ты долго шёл к своей цели, но правильно ли ты потратил своё время? Не забудь про свои документы и бланки.

• Устраивай массовые акции по задержанию бандитов и прочих нарушителей Периметра;
• Взимай с торговцев дань за продажу огнестрела;
• Расширяй территории блокпоста;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Может выдавать опыт своим подчиненным.

Командует: Всем составом ВСУ/ВС.
Подчиняется: Никому.

	]],
	weapons = {"salute","tfa_anomaly_svu","tfa_anomaly_colt1911","weapon_cuff_elastic","pass_vsu"},
	command = "General",
	max = 1,
	candemote = true,
	reversed = true,
	expGiveAmount = 100, -- Кол-во выдаваемого опыта;
       expGiveCooldown = 360, -- Кол-во секунд КД;
	vote = false,
	hasLicense = false,
	armor = 550,
	health = 200,
	salary = 23,
	arrivalMessage = true,
	spawns = military_spawns,
	faction = FACTION_MILITARY,
	spawn_points = {},
	canDiplomacy = true,
	unlockTime = 355 * 3600,
	unlockPrice = 35500, --2000000
	canCapture = true,
    disableDisguise = true,
    experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
         slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции 
})

// STALKERS

TEAM_RCT1 = rp.addTeam("Боец ВC", {
	color = Color(255, 69, 0),
	model = "models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl",
	description = [[
Основная масса Военных Сталкеров - составляют бойцы. Ты еще не опытный в этом ремесле, у тебя все еще впереди.

• Участвуй во всех вылазках и спецоперациях;
• Имеешь звание равное капитану;
• Участвуй в патрулях;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Никем.
Подчиняется: Командир ВС/Подполковник и старше.	
	]],
	weapons = {"tfa_anomaly_groza","salute", "tfa_anomaly_hpsa", "tfa_anomaly_knife_combat","pass_vsu", "weapon_cuff_elastic"},
	spawns = militarys_spawns,
	spawn_points = {},
	salary = 12,
	armor = 200,
	max = 4,
	command = 'rct1',
	faction = FACTION_MILITARYS,
	--exoskeleton = true,
unlockExperience = {		
id = "MS",
amount = 500,
},
experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
appearance = {
	{mdl = {"models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl"},
	skins = {9},
	bodygroups = {
		[1] = {0,1,2},
		[2] = {0,1},
	},
},
},
})

TEAM_CPMEDIC1 = rp.addTeam("Разведчик ВС", {
	color = Color(255, 69, 0),
	model = "models/player/stalker_lone/lone_gp5/lone_gp5.mdl",
	description = [[
Ты член разведотряда, тебя используют для проведения глубинных операций. Ты прошёл многие тесты и тяжёлые испытания, чтобы попасть сюда. Ты настоящий мастер разведки и проведения сложных операций.

• Разведывай территории необъятной ЧЗО.
• Докладывай о любом вздохе противника.
• Имеешь звание равное лейтенанту
• Участвуй в патрулях
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Никем.
Подчиняется: Командир ВС/Подполковник и старше.
    ]],
	weapons = {"tfa_anomaly_svd", "tfa_anomaly_colt1911", "tfa_anomaly_f1", "salute", "tfa_anomaly_knife_combat","pass_vsu", "weapon_cuff_elastic"},
	spawns = militarys_spawns,
	spawn_points = {},
	max = 3,
	salary = 13,
	command = 'med1',
	armor = 250,
	faction = FACTION_MILITARYS,
    candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
	--unlockTime = 125 * 3600, --250
	--vip = true,
	--exoskeleton = true,
unlockExperience = {		
id = "MS",
amount = 1250,
},
experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
appearance = {
	{mdl = {"models/player/stalker_lone/lone_gp5/lone_gp5.mdl"},
	skins = {9},
},
    },
})

TEAM_UNIONLEU1 = rp.addTeam("Механик ВC ", {
	color = Color(255, 69, 0),
	model = {'models/player/stalker_lone/lone_old/lone_old.mdl'},
	description = [[
Ты прошаренный боец, который состоит в групировке не первый год, твоя хобби это машины и все что с ними связанно.

• Занимайтесь и ремонтируйте технику;
• Управляйте различной техникой в боевых целях;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Никем.
Подчиняется: Командир ВС/Подполковник и страше.
	]],
	weapons = {"tfa_anomaly_val", "tfa_anomaly_colt1911","salute", "tfa_anomaly_knife_combat","pass_vsu", "weapon_cuff_elastic"},
	spawns = militarys_spawns,
	spawn_points = {},
	max = 1,
	salary = 14,
	command = 'leu1',
	armor = 300,
	faction = FACTION_MILITARYS,
	--unlockTime = 215 * 3600, --300
	--vip = true,
	--speed = 0.9,
    forceLimit = true,
unlockExperience = {		
id = "MS",
amount = 2500,
},
experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
appearance = {
	{mdl = {"models/player/stalker_lone/lone_old/lone_old.mdl"},
	skins = {9},
},
},
})

TEAM_UNIONVERB1 = rp.addTeam("Штурмовик ВC", { 
	color = Color(255, 69, 0), 
	model = "models/player/stalker_lone/lone_bulat_proto/lone_bulat_proto.mdl", 
	description = [[
Вы основная боевая единица Военных Сталкеров. Врывайтесь в самые горячие точки и уничтожайте своих врагов! 

• Участвуй в штурме особо опасных лиц;
• Разноси в пух и прах вражеские укрепления;
• Участвуй в патрулях;

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Никем.
Подчиняется: Командир ВС/Полковник и старше.
	]],
	weapons = {"salute", "tfa_anomaly_rpk74", "tfa_anomaly_fort", "tfa_anomaly_knife_combat","pass_vsu", "weapon_cuff_elastic"},
	spawns = militarys_spawns, 
	spawn_points = {},
	salary = 25,
	max = 2,
	command = 'leuverb1',
	armor = 400, 
	health = 100,
	faction = FACTION_MILITARYS,
	--unlockTime = 375 * 3600, --450
	--vip = true,
	speed = 0.9,
	exoskeleton = true,
	forceLimit = true,
unlockExperience = {		
id = "MS",
amount = 3500,
},
experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
	appearance = {
	{mdl = {"models/player/stalker_lone/lone_bulat_proto/lone_bulat_proto.mdl"},
	skins = {1},
	bodygroups = {
		[1] = {0},
	},
	},
},
})

TEAM_UNIONLEU12 = rp.addTeam("Командир ВC", {
	color = Color(255, 69, 0),
	model = "models/player/stalker_lone/lone_exo/lone_exo.mdl", 
	description = [[
Самый главный из военных сталкеров. Ты добился многого и не просто так... Ты профессионал в своём деле, так что командование доверило тебе отряд ВС. Командуй с умом и неси правосудие!

• Управляй операциями Воен-сталкеров;
• Руководи своим блоком военсталов;
• Помогай генералу в принятии важных для Блокпоста решений;
Не каждому хватит силы духа служить здесь!

Получает опыт мастерства за:
- Продажу артефактов - 15+;
- Поднятие раненого игрока - 20;
- Сдача пленных - 25;
- Сдача конфискованного оружия Дежурному - 35;

Командует: Штурмовик ВС и ниже.
Подчиняется: Полковник и старше.
	]],
	weapons = {"tfa_anomaly_rpd", "tfa_anomaly_fort","salute","tfa_anomaly_knife_combat","pass_vsu", "weapon_cuff_elastic"},
	spawns = militarys_spawns,
	spawn_points = {},
	salary = 21,
	max = 1,
	command = 'leu12',
	armor = 500,
	health = 100,
	upgrader = {["officer_support"] = true, ["officer_supply"] = true},
	disableDisguise = true,
	faction = FACTION_MILITARYS,
	--unlockTime = 265 * 3600, --400
	--vip = true,
	--speed = 1.1,
	exoskeleton = true,
	forceLimit = true,
unlockExperience = {		
id = "MS",
amount = 4500,
},
experience = {
		id = "MS",
			actions = 
			{
   			["revive"] = 20,
   			["healing"] = 20,
   			["sell_vendor"] = {["Дежурный"] = 35}, 
   			["sell_slave"] = 25,
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 100, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["expsistemitem_three"] = 25, ["expsistemitem_two"] = 25, ["expsistemitem_one"] = 25, ["models/props/cs_office/file_box.mdl"] = 35, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25},
    	},
  },
    appearance = {
	{mdl = {"models/player/stalker_lone/lone_exo/lone_exo.mdl"},
	skins = {2},
	bodygroups = {
		[1] = {0},
	},
		},
},
})

rp.SetFactionVoices({FACTION_MILITARY, FACTION_MILITARYS}, { 
	{ 
		label = 'Здаров', 
		sound = 'vsu/meet_hello_1.wav', 
		text = 'Здаров',
	},
	{ 
		label = 'Я слушаю', 
		sound = 'vsu/sluhau.wav', 
		text = 'Я слушаю',
	},  
	{ 
		label = 'К командиру', 
		sound = {'vsu/meet_use_no_talk_leader_1.wav','vsu/meet_use_no_talk_leader_2.wav','vsu/meet_use_no_talk_leader_3'},
		text = 'К командиру',
	},
	{ 
		label = 'Не стой тут', 
		sound = 'vsu/ne_stoi.wav', 
		text = 'Не стой тут, уходи!',
	}, 
	{ 
		label = 'Опять в бой', 
		sound = 'vsu/begin_reply_4.wav', 
		text = 'Опять в бой',
	}, 
	{ 
		label = 'Атаковать!', 
		sound = {'vsu/start_fight_1.wav','vsu/start_fight_2.wav'},
		text = 'Атаковать!',
	},
	{ 
		label = 'Рассредоточится!', 
		sound = {'vsu/attack_ready_1.wav', 'vsu/attack_ready_2.wav', 'vsu/attack_ready_3.wav', },
		text = 'Рассредоточится!',
	}, 
	{
		label = 'Выходим!', 
		sound = 'vsu/attack_begin_2.wav', 
		text = 'Выходим!',
	},
	{ 
		label = 'Бегом!', 
		sound = 'vsu/run_1.wav', 
		text = 'Бегом!',
	}, 
	{ 
		label = 'Шагом!', 
		sound = 'vsu/walk_1.wav', 
		text = 'Шагом!',
	},   
	{ 
		label = 'Убери оружие', 
		sound = {'vsu/meet_hide_weapon_1.wav', 'vsu/meet_hide_weapon_2.wav', 'vsu/meet_hide_weapon_3.wav'},
		text = 'Убери оружие',
	}, 
	{ 
		label = 'Строится!', 
		sound = 'vsu/stroy.wav', 
		text = 'Строится!',
	}, 
	{ 
		label = 'Вольно', 
		sound = 'vsu/volno.wav', 
		text = 'Вольно разойтись',
	}, 
	{ 
		label = 'Не разговаривать!', 
		sound = 'vsu/sneak_1.wav', 
		text = 'Отставить разговоры!',
	}, 
})

local megafon_sounds = {
    { 
        label = 'Вы находитесь', 
        sound = 'vsu_mega/vsu_megaf1.wav', 
        text = 'Внимание, вы находитесь возле охраняемого периметра зоны экологического бедствия, незаконное пересечение периметра, влечёт за собой уголовную ответсвенность.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 21,
    }, 
    { 
        label = 'Любая попытка', 
        sound = 'vsu_mega/vsu_megaf2.wav', 
        text = 'Внимание, любая попытка проникновения на охраняемую территорию, будет присекаться всеми доступными стредствами, патрули имеют право стрелять без предупреждения.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 21,
    }, 
     { 
        label = 'Граждане', 
        sound = 'vsu_mega/vsu_megaf3.wav', 
        text = 'Граждане, зона смертельно опасна, мы защищаем не зону от вас, а вас от зоны, не подвергайте опасности свои жизни, не пытайтесь проникнуть, на охраняемую территорию.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 29,
    }, 
     { 
        label = 'Служба безопасности', 
        sound = 'vsu_mega/vsu_megaf4.wav', 
        text = 'Служба безопасности Украины, призывает к сотрудничеству всех добропорядочных и сознательных граждан, докладывайте нам о всех известных вам случаях сталкерства, только с вашей помощью мы сможем победить это уродливое явление, не давайте возможности мародёрам укрываться за вашими спинами, они несут из зоны радиоактивные, слабо изученные и представляющие большую опасность для жизни и здоровья людей, предметы, не подвергайте опасности свою жизнь и жизни своих близких, ради сомнительной выгоды.',
        broadcast = true,
        radius = 6000 ^ 2,
        soundDuration = 50,
    }, 
}

    local speed = rp.cfg.RunSpeed
	local team_NumPlayers = team.NumPlayers 
	hook.Add("PlayerLoadout", function(ply) 
	if (ply:GetFaction() == FACTION_MILITARY) && team_NumPlayers(TEAM_MEHVOD) > 0 then 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('TexBoost'))
		ply:GiveArmor(25)	
		ply:GiveAmmo(180, "smg1")
		ply:GiveAmmo(210, "ar2")
		ply:GiveAmmo(60, "Buckshot")				 
		end 
	if (ply:GetFaction() == FACTION_MILITARY or ply:GetFaction() == FACTION_MILITARYS) or ply:GetFaction() == FACTION_MILITARYT && team_NumPlayers(TEAM_GENERAL) > 0 then 
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('LiderVsyBoost')) 
		ply:SetRunSpeed(speed * 1.1)
		ply:AddHealth(20)		 
		end		
	end)

rp.AddTeamVoices(TEAM_GENERAL, megafon_sounds)
rp.AddTeamVoices(TEAM_SEC, megafon_sounds)
rp.AddTeamVoices(TEAM_UNIONLEU12, megafon_sounds)

--rp.AddToRadioChannel({TEAM_GENERAL, TEAM_SEC, TEAM_EPU, TEAM_MEHVOD, TEAM_SNIPERMAY, TEAM_UNIONOFC, TEAM_VSU_VENDOR, TEAM_UNIONLEU, TEAM_EFREI, TEAM_RCT}, rp.GetFactionTeams(FACTION_MILITARY))
rp.AddToRadioChannel({TEAM_SUPPORT6, TEAM_SUPPORT4, TEAM_SUPPORT3, TEAM_SUPPORT2, TEAM_SUPPORT1, TEAM_AGENTSBU}, rp.GetFactionTeams(FACTION_MILITARYT))
rp.AddToRadioChannel({TEAM_DEGTEROB, TEAM_LUCKY, TEAM_UNIONLEU12, TEAM_UNIONVERB1, TEAM_CPMEDIC1, TEAM_RCT1}, rp.GetFactionTeams(FACTION_MILITARYS))

local NIG_Experiences = {
    [500]      = 1,
    [1250]   = 2,
    [2500]   = 3,
    [3500]   = 4,
    [4500]   = 5,
};

local NIG_Levels = {
    [1]  = 500,
    [2]  = 1250,
    [3]  = 2500,
    [4]  = 3500,
    [5]  = 4500,
};

rp.Experiences:GetExperienceType( "MS" )
    :SetPrintName( "ВС" )
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
    	:SetLevelRewards( 1, "Профессия: Боец ВС")
    	:SetLevelRewards( 2, "Профессия: Разведчик ВС")
    	:SetLevelRewards( 3, "Профессия: Механик ВС")
   		:SetLevelRewards( 4, "Профессия: Штурмовик ВС")
   		:SetLevelRewards( 5, "Профессия: Командир ВС" )