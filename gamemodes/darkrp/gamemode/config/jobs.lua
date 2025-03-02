-- "gamemodes\\darkrp\\gamemode\\config\\jobs.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local empty = {}
local  master_spawns = {
rp_stalker_urfim_v3 = {Vector(-6281, -14144, -4408), Vector(-6596, -2351, -3832), Vector(-6256, -2305, -3832), Vector(-6325, -2506, -3832), Vector(-15069, 10510, -4098), Vector(-14932, 10431, -4098), Vector(-15103, 9907, -4098), Vector(-1783, 11907, -3776), Vector(-1664, 11815, -3776), Vector(-1764, 11630, -3776), Vector(-1611, 11452, -3776), Vector(-1763, 11309, -3776), Vector(-1617, 11157, -3776), Vector(-1766, 11003, -3776), Vector(-1601, 10939, -3776), Vector(-1607, 10758, -3776), Vector(-1726, 10763, -3776)},
}

TEAM_CITIZEN = rp.addTeam('Прибывший', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_jacket/lone_jacket.mdl",
	description = [[
Ты сталкер, который только что проник в Зону Отчуждения и ищет себе первую работу. Пришел сюда за заработком или славой, но что тебя на самом деле ждет тут, никто не знает...

• Зеленый, тебя и сталкером трудно назвать;
• Пытайся выжить в тяжелых условях зоны;
• Лучше найди себе товарища поопытней чем ты, иначе быстро погибнешь;
• Остерегайся аномалий и мутантов желающих твоей смерти;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	command = 'unknowcitizen',
	salary = 7,
    armor = 25,
	faction = FACTION_CITIZEN,
appearance = {
	{mdl = {"models/player/stalker_lone/lone_jacket/lone_jacket.mdl"},
	skins = {0,1,2,3,5,6,7},
	bodygroups = {
		[1] = {0,1},
	},
		},
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})

rp.addTeam('Желторотый', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl",
	description = [[
Ты ощутил на себе когти мутантов и уже успел достать не первый свой артефакт. Вот и твоё первое оружие старый, добрый ПМ, теперь не придется убегать от заблудшей слепой собаки. Но будь аккуратнее...

• Отныне, на тебе точно сосредоточенно внимание окружающих тебя сталкеров;
• Работу стали предлагать чаще и выгоднее;
• Будь осторожней в зоне, для тебя, стало еще опасней;
• Оружие это хорошо, чисти и заботься о нем, оно не раз спасет тебе жизнь;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	weapons = {"tfa_anomaly_knife", "tfa_anomaly_pm"},
	command = 'goodcitizen',
	salary = 9,
	faction = FACTION_CITIZEN,
	--unlockTime = 6 * 3600, --20
	--unlockPrice = 850,
	armor = 50,
appearance = {
	{mdl = {"models/player/stalker_lone/lone_sunrise/lone_sunrise.mdl"},
	skins = {0,3,5,6,7,8,9},
	bodygroups = {
		[1] = {0,1,2,3},
		[2] = {0,1,2},
	},
		},
},
unlockExperience = {		
id = "cityz",
amount = 500,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})

rp.addTeam('Бывалый Сталкер', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_old/lone_old.mdl",
	description = [[
Ты привык к жизни в зоне, больше тебя нельзя назвать зеленью, но твоя экипировка несмотря на новенький Обрез ТОЗ-66 и PMm оставляет желать лучшего. Бармены уже стали доверять тебе более сложные и хорошо оплачиваемые задания.

• Теперь и ты можешь взять себе отмычку в дорогу, обучить его жизни или наоборот;
• Самое время выбрать путь, которым ты пойдешь по Зоне;
• Организуй первый свой отряд, собрав верных друзей;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	weapons = {"tfa_anomaly_knife", "tfa_anomaly_pm", "tfa_anomaly_bm16"},
	command = 'dovercitizen',
	salary = 11,
	faction = FACTION_CITIZEN,
	--unlockTime = 56 * 3600,
	--unlockPrice = 15000,
	armor = 70,
unlockExperience = {		
id = "cityz",
amount = 1000,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})


TEAM_STALKERPROF = rp.addTeam('Сталкер Профессионал', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_gp5/lone_gp5.mdl",
	description = [[
Торговцы доверяют тебе важнейшие задания, а почти каждая группа желает видеть у себя. Хороший ствол и огромный опыт за спиной, вот что олицетворяет тебя.

• Задания становятся все опасней, но не для тебя;
• Организуй первый поход в цент зоны со своим отрядом;
• Заработай целое состояние, чтобы вернуться домой;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	weapons = {"tfa_anomaly_knife_hunting", "tfa_anomaly_pm", "tfa_anomaly_kiparis"},
	command = 'loyalcitizen',
	salary = 14,
	faction = FACTION_CITIZEN,
	--unlockTime = 366 * 3600,
	--unlockPrice = 200000,
	armor = 160,
	anomaly_resistance = .2,
unlockExperience = {		
id = "cityz",
amount = 2000,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})

TEAM_STALKERVET = rp.addTeam('Сталкер Ветеран', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_noexo/lone_noexo.mdl",
	description = [[
Приобретенный "Тяжелый бронекостюм" не раз спас тебе жизнь, но с каждым днем по тебе все меньше стреляют, ты стал настоящим ветеранам зоны. Голоса в голове - хрень какая то...

• У тебя появились связи по всей зоне;
• Знаешь почти каждый уголок этого опасного мира;
• Давай советы, поручения и задания сталкерам;
• Бандиты обходят тебя стороной, не стоит их бояться;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	command = 'bestcitizen',
	weapons = {"tfa_anomaly_knife_hunting", "tfa_anomaly_pm", "tfa_anomaly_aks"},
	salary = 16,
	faction = FACTION_CITIZEN,
	--unlockTime = 526 * 3600,
	--unlockPrice = 450000,
	armor = 200,
	exoskeleton = true,
	--spawns = master_spawns, 
	anomaly_resistance = .1,
unlockExperience = {		
id = "cityz",
amount = 4000,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})

TEAM_STALKERMAS = rp.addTeam('Сталкер Мастер', {
	color = Color(218, 165, 32),
	model = "models/player/stalker_lone/lone_exoseva/lone_exoseva.mdl",
	description = [[
Наконец-то пришел твой заказ -экзоскелет, теперь людям по тебе стрельнуть смелости не хватит, но нужно остерегаться тушканов, они не пощадят твою покупку, сам знаешь. Голоса, голоса!

• Ты практически достиг уровня легенд, постарайся достигнуть этого уровня;
• Собираешься проникнуть в одну из лаб или пойти на штурм монолита, чтобы стать настоящей легендой зоны;
• Собери отряд настоящих мастеров и покажите своим врагам мощь, которую вы приобрели за эти года;

Это лишь малость забот сталкерской жизни!

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	command = 'wowcitizen',
	weapons = {"tfa_anomaly_knife_hunting", "tfa_anomaly_pm", "tfa_anomaly_groza_nimble"},
	salary = 18,
	faction = FACTION_CITIZEN,
	--unlockTime = 856 * 3600,
	--unlockPrice = 755000,
	--spawns = master_spawns, 
	anomaly_resistance = .1,
	armor = 300,
	speed = 1.1,
	exoskeleton = true,
unlockExperience = {		
id = "cityz",
amount = 7500,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})


TEAM_STALKERLEG = rp.addTeam('Сталкер Легенда', {
	color = Color(218, 165, 32),
	model = {"models/player/stalker_lone/lone_sunrise_proto/lone_sunrise_proto.mdl"},
	description = [[
По тебе слагают неповторимые легенды, которым не каждый верит, но большая их часть правда. Помнишь ли кем ты был раньше? Неважно, теперь Зона твой дом.

• Ты лучший из лучших, тебя боятся все бандиты;
• Знаешь зону, как свои пять пальцев;
• Один из самых влиятельных людей зоны;
• Можешь достать любую вещь в зоне, благодаря своим огромным связям и заработаным финансам;

Зона есть ты, а ты есть зона! Отсюда нет выхода...

Получает опыт мастерства за:
- Продажу артефактов - 50+;
- Поднятие раненого игрока - 15;
- Продажу хлама - 10+;
- Продажу частей мутантов - 15+;
	]],
	command = 'wowcitizeng',
	weapons = {"tfa_anomaly_knife_hunting", "tfa_anomaly_pm", "tfa_anomaly_val"},
	salary = 20,
	faction = FACTION_CITIZEN,
	--unlockTime = 1100 * 3600,
	--spawns = master_spawns, 
	--unlockPrice = 1200000,
	armor = 500,
	anomaly_resistance = .2,
	speed = 1.1,
unlockExperience = {		
id = "cityz",
amount = 10000,
},
experience = {
		id = "cityz",
			actions = 
			{
   			["revive"] = 15,
   			["sell_vendor"] = {["Ученый ЧН"] = 50, ["Профессор Сахаров"] = 50}, 
   			["sell_item"] = {["art_antiexplosion"] = 15, ["art_compass"] = 15, ["art_control"] = 15, ["art_crystalplant"] = 50, ["art_dummyglass"] = 15, ["art_fire"] = 10, ["art_goldfish"] = 15, ["art_psi"] = 25, ["models/props/cs_office/file_box.mdl"] = 25, ["rpitem_package_three"] = 25, ["rpitem_package_one"] = 25, ["rpitem_mutantchasti"] = 25, ["rpitem_mutant_psevdo"] = 75, ["rpitem_mutant_krovosos"] = 15, ["rpitem_mutant_snork"] = 15, ["rpitem_mutant_zombi"] = 15, ["rpitem_mutant_tushkan"] = 15, ["rpitem_mutant_sobaka"] = 15, ["rpitem_mutant_kaban"] = 15, ["rpitem_metal"] = 10, ["rpitem_steel"] = 25, ["rpitem_fabric"] = 15, ["rpitem_battery"] = 25, ["rpitem_secret_list"] = 45, ["rpitem_guns_meh"] = 20, ["rpitem_army_desclothes"] = 20, ["rpitem_bag1"] = 20, ["rpitem_sbornikdocks"] = 45, ["rpitem_army_desclothes"] = 20, ["rpitem_mutant_himera"] = 20, ["rpitem_mutant_plot"] = 20},
    	},
  },
})

rp.SetFactionVoices({FACTION_CITIZEN}, {
{
label = 'Привет брат',
sound = 'stalker/priv.wav',
text = 'Привет брат'
},
{
label = 'Я их вижу!',
sound = 'stalker/vizhu.wav',
text = 'Вот, вот, я их вижу!'
},
{
label = 'Враг!',
sound = {'stalker/vrag1.wav', 'stalker/vrag2.wav'},
text = 'Враг!'
},
{
label = 'Вали их!',
sound = 'stalker/vpered.wav',
text = 'Вперёд, вали их!'
},
{
label = 'Убьём!',
sound = {'stalker/ubyem1.wav', 'stalker/ubyem2.wav'},
text = 'Убьём!'
},
{
label = 'Бей их!',
sound = {'stalker/vinosi1.wav', 'stalker/vinosi2.wav'},
text = 'Бей их!'
},
{
label = 'Ты труп!',
sound = {'stalker/ti_trup1.wav', 'stalker/ti_trup2.wav'},
text = 'Ты труп!'
},
{
label = 'Оружие убери',
sound = {'stalker/oruzhie1.wav', 'stalker/oruzhie2.wav'},
text = 'Оружие убери'
},
{
label = 'Прикрываю',
sound = {'stalker/prikro1.wav', 'stalker/prikro2.wav'} ,
text = 'Прикрываю!'
},
{
label = 'Дерьмо!',
sound = 'stalker/dermo.wav',
text = 'Дерьмо!'
},
{
label = 'Смех',
sound = 'stalker/ahaha.wav',
text = '*Ржёт*'
},
{
label = 'Отвали',
sound = {'stalker/otvali1.wav', 'stalker/otvali2.wav'},
text = 'Отвали'
},
{
label = 'Не стреляй!',
sound = 'stalker/ne_strel.wav',
text = 'Не стреляй!'
},
{
label = 'Отбой',
sound = 'stalker/otboi.wav',
text = 'Всё мужики, отбой'
},
{
label = 'Аптечку!',
sound = {'all/aptechka_1.wav', 'all/aptechka_2.wav' },
text = 'Аптечку!'
},
{
label = 'Помогите!',
sound = {'all/help_1.wav', 'all/help_2.wav', 'all/help_3.wav', 'all/help_4.wav' },
text = 'Помогите!'
}
})

local CITYZ_Experiences = {
    [0]      = 1,
    [500]   = 2,
    [1000]   = 3,
    [2000]   = 4,
    [4000]   = 5,
    [7500]   = 6,
    [10000]   = 7,
    [12500]   = 8,
    [15000]   = 9,
};

local CITYZ_Levels = {
    [1]  = 0,
    [2]  = 500,
    [3]  = 1000,
    [4]  = 2000,
    [5]  = 4000,
    [6]  = 7500,
    [7]  = 10000,
    [8]  = 12500,
    [9]  = 15000,
};

rp.Experiences:GetExperienceType( "cityz" )
    :SetPrintName( "Одиночки" )
    :SetLevelFormula( function( v, reverse )
        if reverse then
            local keys = table.GetKeys( CITYZ_Levels );
            table.sort( keys );

            local exp = 0;

            for k, level in ipairs( keys ) do
                if level > v then break end
                exp = CITYZ_Levels[level];
            end

            return exp;
        end

        --

        local keys = table.GetKeys( CITYZ_Experiences );
        table.sort( keys );

        local lv = 0;

        for k, experience in ipairs( keys ) do
            if experience > v then break end
            lv = CITYZ_Experiences[experience];
        end

        return lv;
    end )
    	:SetLevelRewards( 1, "Профессия: Сталкер Новичек"  )
    	:SetLevelRewards( 2, "Профессия: Желторотый" )
    	:SetLevelRewards( 3, "Профессия: Бывалый Сталкер" )
   		:SetLevelRewards( 4, "Профессия: Опытный Сталкер" )
   		:SetLevelRewards( 5, "Профессия: Салкер Профессионал" )
   		:SetLevelRewards( 6, "Профессия: Сталкер Ветеран" )
   		:SetLevelRewards( 7, "Профессия: Сталкер Мастер" )
   		:SetLevelRewards( 8, "Профессия: Сталкер Легенда" )

