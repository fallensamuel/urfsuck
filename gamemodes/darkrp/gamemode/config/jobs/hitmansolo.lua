-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\hitmansolo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local  hitmansolo_spawns = {
rp_stalker_urfim_v3 = {Vector(1970, -6006, -3824), Vector(2085, -6005, -3824), Vector(2082, -5824, -3824), Vector(1941, -5828, -3824)},
rp_pripyat_urfim = {Vector(3056, -11127, 32), Vector(3024, -11015, 32), Vector(3444, -10995, 32), Vector(3397, -11114, 32), Vector(3330, -11023, 32)},
rp_stalker_urfim = {Vector(-2145, -7515, 136), Vector(-2246, -7511, 136), Vector(-2183, -7366, 136)},
rp_st_pripyat_urfim = {Vector(-1908, -12562, 8)},
}
TEAM_HITMANS = rp.addTeam("Наёмник Новичок", {
	color = Color(0, 51, 102),
	model = {'models/player/stalker_merc/merc_gear/merc_gear.mdl'},
	description = [[ 
Ты рекрут синдиката наемников, проявляй себя и слушайся приказов старших по званию чтобы взобраться по карьерной лестнице.

В твои задачи входит:
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";
• Может выполнять заказ на ограбление складов;	

Не может брать заказ на помощь в Войне группировок без приказа высокопоставленного наемника.

Подчиняется: Опытный Наемник и Выше.
	]],	
	weapons = {"tfa_anomaly_knife_combat","tfa_anomaly_vz61","tfa_anomaly_mp7"},
	command = "hitmans",
	salary = 10,
	armor = 200,
	hitman = true,
	hirable = true,
	hirePrice = 250,	
	spawns = hitmansolo_spawns,
	faction = FACTION_HITMANSOLO,
	spawn_points = {},
    slavePrice = 100, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 30, -- Время заключения для пленника этой профы / фракции  
    unlockPrice = 1000,
    unlockTime = 10*3600, --50
})

TEAM_HITMANM = rp.addTeam("Опытный Наёмник", {
	color = Color(0, 51, 102),
	model = {
		"models/player/stalker_merc/merc_noexo/merc_noexo.mdl"
	},
	description = [[
Ты опытный член синдиката, который уже проявил себя и заслужил уважение своих товарищей по цеху.

В твои задачи входит:
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Не может брать заказ на помощь в Войне группировок без приказа высокопоставленного наемника.

Командует: Наемник;
Подчиняется: Наёмник Ветеран и Выше.
	]],
	weapons = {"tfa_anomaly_knife_combat","tfa_anomaly_val","tfa_anomaly_vz61","tfa_anomaly_f1"},
	command = "hitmanm",
	salary = 12,
	armor = 250,
	anomaly_resistance = .25,
	unlockPrice = 7500,
    unlockTime = 75*3600, --50
	hitman = true,
	hirable = true,
	hirePrice = 500,
	spawns = hitmansolo_spawns,
	faction = FACTION_HITMANSOLO,
	      candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
	max = 5,
	forceLimit = true,
	spawn_points = {},
    slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
})

TEAM_PREMHULBAN = rp.addTeam("Жульбан", { 
	color = Color(0, 51, 102),
	model = {'models/stalker_merc/stalker_merc_2a_gp5.mdl'},
	description = [[ Вы один из лучших экспертов по аномалиям в своей группировке, а также быстрый как тушканчик, за что и получил свой позывной "Жульбан".
	]], 
	weapons = {"tfa_anomaly_m82", "tfa_anomaly_fn2000", "tfa_anomaly_f1", "tfa_anomaly_beretta", "tfa_anomaly_knife_combat"},
	command = "premhulban", 
	salary = 15, 
	armor = 200, 
	max = 1,
	forceLimit = true,
	customCheck = function(ply) return (ply:IsRoot() or rp.PlayerHasAccessToJob('premhulban', ply)) end,
	--unlockTime = 245*3600, --200
	hitman = true, 
	hirable = true,
		hirePrice = 500,
	anomaly_resistance = .8, 
	spawns = hitmansolo_spawns, 
	faction = FACTION_HITMANSOLO, 
		      candisguise = true,    
      disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
	speed = 1.15,
	slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
   	slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
}) 

TEAM_HITMANM = rp.addTeam("Наёмник Ветеран", {
	color = Color(0, 51, 102),
	model = { 'models/player/stalker_merc/merc_bulat/merc_bulat.mdl'},
	description = [[ 
Ты уже не первый год в этой сфере, за множество выполненных заказов тебя стали называть Ветераном.
Поднимайте боевой дух своих товарищей!

В твои задачи входит:
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";
• Может выполнять заказ на ограбление складов;		

Не может брать заказ на помощь в Войне группировок без приказа высокопоставленного наемника.

Командует: Опытный Наемник и ниже;
Подчиняется: Наёмник Мастер и Выше.
	]],
	weapons = {"tfa_anomaly_knife_combat","tfa_anomaly_vintorez_nimble","tfa_anomaly_spas12","lockpick","hacktool","tfa_anomaly_beretta"},
	command = "hitwmanm",
	salary = 14,
	upgrader = {["officer_support"] = true},
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('hitwmanm', ply) end,
	armor = 300,
	--unlockPrice = 7500,
    --unlockTime = 85*3600,
	hitman = true,
	hirable = true,
		hirePrice = 500,
	spawns = hitmansolo_spawns,
	faction = FACTION_HITMANSOLO,
	candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
	max = 3,
	forceLimit = true,
	spawn_points = {},
	vip = true,
	slavePrice = 300, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 80, -- Время заключения для пленника этой профы / фракции  
})

TEAM_HITMANL = rp.addTeam("Наёмник Мастер", {
	color = Color(0, 51, 102),
	model = {'models/player/stalker_merc/merc_exo/merc_exo.mdl'},
	description = [[ 
Твоя карьера Наемника уже носом касается облаков.
Ты - профессионал, от твоих работ у людей уже дрожат руки, а убийства совершенные тобой остаются на страницах книг.
	
В твои задачи входит:
• Выполнение заказов на помощь в Войне группировок;
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Командует: Наемниками;
	]],
	weapons = {"tfa_anomaly_m82", "tfa_anomaly_knife_combat", "tfa_anomaly_m16","door_ram","tfa_anomaly_beretta"},
	command = "hitmanl",
	salary = 17,
	armor = 400,
	unlockPrice = 22500,
    unlockTime = 225*3600, --150
	hitman = true,
	hirable = true,
		hirePrice = 500,
	spawns = hitmansolo_spawns,
	faction = FACTION_HITMANSOLO,
	candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
	max = 2,
	forceLimit = true,
	spawn_points = {},
	speed = 1.2,
	    slavePrice = 350, -- Награда за сдачу пленника этой профы / фракции
   		slaveJailTime = 95, -- Время заключения для пленника этой профы / фракции  
})
/*
TEAM_HITMANVIP = rp.addTeam("Элитный Наёмник", { 
	color = Color(0, 51, 102),
	model = { 'models/tnb/stalker/male_sunrise_winter.mdl', 'models/stalker_merc/merc_sunrise/merc_sunrise.mdl'},
	description = [[ 
Вы лучший из лучших, Вам доверяют заказы исключительной сложности. 

В твои задачи входит:
• Выполнение заказов на помощь в Войне группировок;
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Командует: Наёмник Мастер и ниже;
Подчиняется: Ара, Тиран и Волкодав.
	]], 
	weapons = isNoDonate && {"swb_m82", "tfa_anomaly_knife_combat", "swb_asvalscoped", "swb_beretta_kekler"} || {"swb_m82", "swb_m16", "stalker_rpg", "swb_beretta_kekler", "tfa_anomaly_knife_combat"},
	command = "hitmanvip", 
	salary = 20, 
	armor = 550, 
	vip = true,
	max = 2,
	forceLimit = true,
	unlockTime = 245*3600, --200
	hitman = true, 
	hirable = true,
		hirePrice = 500,
	spawns = hitmansolo_spawns, 
	faction = FACTION_HITMANSOLO, 
		      candisguise = true,    
      disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
	speed = 1.25,
	appearance = {
		{
			mdl        = "models/tnb/stalker/male_sunrise_winter.mdl",
			skins      = {5},
		},
		{mdl = "models/stalker_merc/merc_sunrise/merc_sunrise.mdl",
          skins       = {0,1},
           bodygroups = {
                [1] = {0,1,2,3,4},
                [2] = {0,1,2},
            }
        },
	},
	 slavePrice = 400, -- Награда за сдачу пленника этой профы / фракции
   	slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
}) 

TEAM_PREMHULBAN = rp.addTeam("Жульбан", { 
	color = Color(0, 51, 102),
	model = {'models/stalker_merc/stalker_merc_2a_gp5.mdl'},
	description = [[ Вы один из лучших экспертов по аномалиям в своей группировке, а также быстрый как тушканчик, за что и получил свой позывной "Жульбан".
	]], 
	weapons = {"swb_m82", "swb_f2000", "swb_rpd", "swb_beretta_kekler", "stalker_knife", "swb_f2000"},
	command = "premhulban", 
	salary = 325, 
	armor = 200, 
	max = 1,
	forceLimit = true,
	customCheck = function(ply) return (ply:IsRoot() or rp.PlayerHasAccessToJob('premhulban', ply)) end,
	--unlockTime = 245*3600, --200
	hitman = true, 
	hirable = true,
		hirePrice = 500,
	anomaly_resistance = .8, 
	spawns = hitmansolo_spawns, 
	faction = FACTION_HITMANSOLO, 
		      candisguise = true,    
      disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
	speed = 1.15,
	slavePrice = 200, -- Награда за сдачу пленника этой профы / фракции
   	slaveJailTime = 60, -- Время заключения для пленника этой профы / фракции  
}) 

TEAM_HITMANDONAT = rp.addTeam("Ара", { 
    color = Color(0, 51, 102),
    model = {"models/stalker_merc/merc_sunrise_proto/merc_sunrise_proto.mdl"}, 
    description = [[ 
Ты Наёмник Легенда, известный на всю Зону информатор и осведомитель, обладаешь широким выбором снаряжения, позволяющим эффективно выполнять любую поставленную задачу. 
Можешь менять свои прозвища и снаряжение,для скрытия личности!

В твои задачи входит:
• Комнадыванием отрядом наемников;
• Выполнение заказов на помощь в Войне группировок;
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Командует: Элитный Наемник и ниже;
Подчиняется: Волкодав.
    ]], 
    weapons = isNoDonate && {"swb_m82", "swb_m249", "swb_spas14", "stalker_knife", "swb_beretta_kekler", "weapon_c4", "stalker_grenade_gd", "weapon_medkit"} || {"swb_gauss", "swb_m249", "swb_sayga_kekler", "swb_beretta_kekler", "stalker_knife", "weapon_c4", "stalker_grenade_gd", "health_kit_normal"},
    command = "hitmandonatik", 
    salary = 21, 
    armor = 500, 
    customCheck = function(ply) return ply:HasUpgrade('job_hitdonatik') or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64()) or ply:IsRoot() or ply:HasPremium() or rp.PlayerHasAccessToJob('hitmandonatik', ply) end,
    health = 200,
   	max = 1,
   	reversed = true,
    hitman = true, 
    hirable = true,
		hirePrice = 500,
    spawns = hitmansolo_spawns, 
	faction = FACTION_HITMANSOLO,  
	spawn_points = {},
	  candisguise = true,    
      disguise_faction = FACTION_CITIZEN, FACTION_DOLG, FACTION_SVOBODA, FACTION_REBEL, FACTION_NEBO, FACTION_MILITARY,
    speed = 1.15,
    appearance = 
    {
        {mdl = "models/stalker_merc/merc_sunrise_proto/merc_sunrise_proto.mdl",
          skins       = {0,1},
           bodygroups = {
                [1] = {0,1,2,3,4},            }
        },
    },
    	slavePrice = 500, -- Награда за сдачу пленника этой профы / фракции
   	slaveJailTime = 160, -- Время заключения для пленника этой профы / фракции  
})

TEAM_TIRAN = rp.addTeam("Наемник \"Тиран\"", { 
    color = Color(0, 51, 102),
    model = {"models/muravey/sunrise_secro.mdl"}, 
    description = [[
Легендарный наемник, прославившийся на всю Зону своими хладнокровными убийствами, совершенные с невиданной жестокостью.
Если кто то хочет устранить своего врага максимально жестоко, он обращается к Тирану.

В твои задачи входит:
• Комнадыванием отрядом наемников;
• Выполнение заказов на помощь в Войне группировок;
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Командует: Элитный Наемник и ниже;
Подчиняется: Волкодав.
    ]], 
    weapons = isNoDonate && {"swb_eliminator", "stalker_knife", "swb_beretta_kekler", "door_ram", "stalker_grenade_gd", "weapon_medkit", "swb_m14"} ||  {"swb_eliminator", "swb_m14", "swb_beretta_kekler", "stalker_knife", "stalker_grenade_gd", "weapon_c4", "health_kit_best"},
    command = "hitmantiran", 
    salary = 22, 
    armor = 600, 
    arrivalMessage = true,
    reversed = true,
   	customCheck = function(ply) return CLIENT or (ply:GetAttributeAmount("perception") == 100) or ply:IsRoot() end,
    health = 200,
    unlockTime = 600 * 3600,
   	max = 1,
    hitman = true,
    hirable = true,
		hirePrice = 500,
    spawns = hitmansolo_spawns, 
	faction = FACTION_HITMANSOLO, 
     candisguise = true,    
     disguise_faction = FACTION_CITIZEN,
	spawn_points = {},
	CustomCheckFailMsg = 'TiranJob',
    speed = 1.20, 
    slavePrice = 450, -- Награда за сдачу пленника этой профы / фракции
   	slaveJailTime = 180, -- Время заключения для пленника этой профы / фракции  
})

TEAM_VOLKODAV = rp.addTeam("Волкодав", {
	color = Color(0, 51, 102),
	model = {'models/dejtriyev/stalker/merc/socmerc_wolfhound.mdl'},
	description = [[ 
Вы полевой командир Наемников, Легенда как для своих так и для обывателей Зоны.

В твои задачи входит:
• Комнадыванием всеми отрядами наемников в зоне;
• Выполнение заказов на помощь в Войне группировок;
• Выполнение заказов на ликвидацию цели;
• Выполнение заказов на сопровождение;
• Выполнение заказов на добычу информации или ценного "Предмета";	
• Может выполнять заказ на ограбление складов;	

Командует: Наемниками;
	]],	
	weapons = isNoDonate && {"swb_eliminator", "stalker_knife", "swb_beretta_kekler", "door_ram", "stalker_grenade_gd", "weapon_medkit", "swb_m82"} || {"swb_eliminator", "stalker_knife", "swb_beretta_kekler", "door_ram", "stalker_grenade_gd", "weapon_medkit", "swb_m82"},
	command = "volkodav",
	salary = 25,
	armor = 550,
	max = 1,
	forceLimit = true,
	hitman = true,
	unlockPrice = 35500,
    unlockTime = 470*3600,
	hirable = true,
    hirePrice = 1000,	
	spawns = hitmansolo_spawns,
	faction = FACTION_HITMANSOLO,
	spawn_points = {},
	candisguise = true,    
    disguise_faction = FACTION_CITIZEN,
    slavePrice = 600, -- Награда за сдачу пленника этой профы / фракции
    slaveJailTime = 180, -- Время заключения для пленника этой профы / фракции  
    appearance = {
		{  
			mdl        = "models/dejtriyev/stalker/merc/socmerc_wolfhound.mdl",
			skins      = {0},
		},
	},
})
*/

rp.SetFactionVoices({FACTION_HITMANSOLO}, { 
	{ 
		label = 'Противник!', 
		sound = {'naimi/protivnik.wav', 'naimi/protivnik2.wav'},
		text = 'Противник!!!',
	},
	{ 
		label = 'Работаем', 
		sound = 'naimi/rabot.wav', 
		text = 'Работаем',
	},
	{ 
		label = 'Бошку снесу', 
		sound = 'naimi/snesu.wav', 
		text = 'Я ему бошку снесу, пусть только высунется',
	},
	{ 
		label = 'Есть!', 
		sound = 'naimi/est.wav', 
		text = 'Есть!',
	},
	{ 
		label = 'Выходи', 
		sound = {'naimi/vihodi.wav', 'naimi/vihodi2.wav', 'naimi/vihodi3.wav'},
		text = 'Выходи!',
	},
	{ 
		label = 'Найти его', 
		sound = 'naimi/naiti.wav', 
		text = 'Нужно найти его и по скорее',
	},
	{ 
		label = 'Хрен', 
		sound = 'naimi/hren.wav', 
		text = 'Хрен тебе',
	},
	{ 
		label = 'Уху ел?!', 
		sound = 'naimi/ti_cho.wav', 
		text = 'Ты чё, уху ел?!',
	},
	{ 
		label = 'Ты ублюдок!', 
		sound = 'naimi/ti_cho_tvor.wav', 
		text = 'Ты ублюдок, ты чё творишь?!',
	},
	{ 
		label = 'Урою', 
		sound = 'naimi/uroyu.wav', 
		text = 'Урою,понял?',
	},
	{ 
		label = 'Разделывают', 
		sound = 'naimi/razdel.wav', 
		text = 'Разделывают нас',
	},
	{ 
		label = 'Допрыгался', 
		sound = 'naimi/doprigalsya.wav', 
		text = 'Допрыгался ты парень',
	},
	{ 
		label = 'Говнюк!', 
		sound = 'naimi/govnuk.wav', 
		text = 'Говнюк!' 
	},
})