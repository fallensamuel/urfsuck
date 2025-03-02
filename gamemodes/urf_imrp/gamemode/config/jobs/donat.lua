
local stasis_spawn = {
	rp_city17_alyx_urfim = {
		Vector(7425, 223, -64),
		Vector(7346, 223, -64),
		Vector(7194, 223, -64),
		Vector(7100, 223, -64),
		Vector(7425, 144, -64),
		Vector(7346, 144, -64),
		Vector(7194, 144, -64),
		Vector(7100, 144, -64),
	},
}

local zmei_spawn = {
	rp_city17_alyx_urfim = {
		Vector(2254, 5392, -384),
	},
}

TEAM_BLACKRIPPER = rp.addTeam("C17.OTA.BLACKRIPPER", {
	color = Color(170, 246, 49),
	model = {'models/player/hl2survivor/combine_engineer_female.mdl'},
	description = [[
OTA.BLACKRIPPER - Особая боевая единица Сверхчеловеческого отдела, предназначенная для выполнения особых задач.

Прямые обязанности:
- Выполнение заданных командованием протоколов;

В подчинении у CMD, OTA.KING.Ordinal, OTA.KING.Overlord;
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
АВТОНОМ;

Лояльность Альянса: Высокая;
]],
	weapons = {"swb_shotgun", "swb_ar2", "swb_bow","door_ram", "weapon_taser",'weapon_cuff_elastic'},
	salary = 15,
	command = "l3452ps",
	spawns = stasis_spawn,
	vip = true,		
	notDisguised = true,
	hasLicense = true,
	reversed = true,
	CantUseDisguise = true,
	faction = FACTION_OTA,
	armor = 200,
	rationCount = 1,
	PlayerSpawn = function(ply) ply:SetRunSpeed(325) ply:SetRunSpeed(325) ply:SetHealth(100) ply:SetMaxHealth(100)  end,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'C17.OTA.BLACKRIPPER'}, ply:SteamID64()) end,
	loyalty = 3
})

rp.addTeam("Цербер", {
	color = Color(128, 128, 128),
	model = {'models/dizcordum/female_rebel.mdl','models/dizcordum/rebel.mdl'},
	description = [[Бывший военный помогающий беженцем и сборам ресурсов, оружия и еды у Альянса.
]],
	salary = 15,
	weapons = {'tfa_heavyshotgun'},
	command = "cerber",
	spawns = zmei_spawn,
	candisguise = true,
	disableDisguise = true,
	disguise_faction = FACTION_MPF,
	faction = FACTION_REFUGEES,
	armor = 250,
	max = 1,
	rationCount = 1,
	customCheck = function(ply) return ply:SteamID() == 'STEAM_0:0:57782812' or ply:IsRoot() end,
	loyalty = 7,
})

rp.addTeam("C17.CMB.RebelHunter", {
	color = Color(0, 0, 0),
	model = {'models/rougepolice/pm_rogues_policce_new.mdl'},
	description = [[Охотник - юнит предназначенный для разведки и скрытных устранений сил Сопротивления. 
Он профессионально владеет любыми видами оружия. Очень хорошо защищен, и в то же время очень подвижен.
]],
	salary = 15,
	weapons = {"door_ram", "weapon_taser",'weapon_cuff_elastic'},
	command = "rebhunter",
	spawns = rebhunter_spawn,
	candisguise = true,
	disableDisguise = true,
	disguise_faction = FACTION_REBEL,
	faction = FACTION_MPF,
	armor = 250,
	max = 1,
	rationCount = 3,
	PlayerSpawn = function(ply)  ply:SetHealth(150) ply:SetMaxHealth(150) end,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'C17.CMB.RebelHunter'}, ply:SteamID64()) end,
	loyalty = 5,
})

TEAM_ZMEY = rp.addTeam("Одинокий Змей", {
	color = Color(0,0,0),
	model = {'models/playermodel/sniperwolf_hx.mdl',"models/player/leet.mdl"},
	description = [[
Змей - юнит дезертировавший из рядов ГО. После дезертирования он погрузился в свободную от Альянса жизнь. 
На основе брони юнита ГО он создал себе новую, индивидуальную защиту, которая не потеряла доступ ко всем базам данных Альянса. 
Змей сам по себе очень умен, и может взломать даже самую сложную защиту Альянса. 
В его тело имеются импланты, которые помогают ему ориентироваться в бою и совершать свои действия намного увереннее.
]],
	weapons = {"tfa_heavyshotgun"},
	salary = 15,
	command = "zmey",
	spawns = zmei_spawn,
	candisguise = true,
	reversed = true,
	faction = FACTION_REFUGEES,
	disableDisguise = true,
	disguise_faction = FACTION_MPF,
	armor = 400,
	rationCount = 1,
	max = 1,
	PlayerSpawn = function(ply) ply:SetRunSpeed(325) ply:SetHealth(200) ply:SetMaxHealth(200)  end,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'Одинокий Змей'}, ply:SteamID64()) end,
	loyalty = 7
})

TEAM_MUDROCK = rp.addTeam("Mudrock", {
	color = Color(0,0,0),
	model = {'models/player/gasmask.mdl'},
	description = [[
Однозначно входит в список самых опасных людей Сити 17. Таинственным образом появился однажды на рейде Эскадрона Смерти. 

Является свободным наемников который связан с ЭС по неизвестным обстоятельствам.
]],
	weapons = {"tfa_heavyshotgun",'climb_swep'},
	salary = 15,
	command = "murock",
	spawns = zmei_spawn,
	reversed = true,
	faction = FACTION_REFUGEES,
	disableDisguise = true,
	armor = 400,
	rationCount = 1,
	max = 1,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) ply:SetHealth(150) ply:SetMaxHealth(150)  end,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'Mudrock'}, ply:SteamID64()) end,
	loyalty = 7
})

TEAM_GONCHAYATMY = rp.addTeam("Гончая Тьмы", {
	color = Color(145, 145,145),
	model = {'models/niik/pm/metro_girl.mdl'},
	description = [[
Частично тронувшаяся умом фанатичная охотница одержимая местью любому из религиозных фанатиков, "отбросов общества" и тех, кто переходит дорогу её сестре. 
Очищение Земли от подонков - цель её жизни, её сестёр и братьев, которые и организовали орден Тьмы. 
Встретившись с Красной Королевой ЭС при очень благоприятных для них обстоятельствах - она сразу заслужила её доверие, а со временем и право на командованием своим отрядом.
]],
	weapons = {"tfa_heavyshotgun",'climb_swep','weapon_c4',''},
	salary = 15,
	command = "murock",
	spawns = zmei_spawn,
	reversed = true,
	faction = FACTION_REFUGEES,
	disableDisguise = true,
			candisguise = true,
			disguise_faction = FACTION_MPF,
	armor = 300,
	rationCount = 1,
	max = 1,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'Гончая Тьмы'}, ply:SteamID64()) end,
	loyalty = 7
})


TEAM_HILDA = rp.addTeam("Хильда Фон Шталь", {
	color = Color(178,12,15),
	model = {'models/cso2/player/ct_helga_player.mdl'},
	description = [[
Госпожа Хильда Фон Шталь или же Красная Королева. Безжалостная и притягательная. Командир Эскадрона Смерти
]],
	weapons = {"tfa_heavyshotgun",'climb_swep','weapon_c4',''},
	salary = 15,
	command = "hilda",
	spawns = zmei_spawn,
	reversed = true,
	faction = FACTION_REFUGEES,
	disableDisguise = true,
			candisguise = true,
			disguise_faction = FACTION_MPF,
	armor = 235,
	rationCount = 1,
	max = 1,
	customCheck = function(ply) return ply:IsRoot() or rp.PlayerHasAccessToCustomJob({'Хильда Фон Шталь'}, ply:SteamID64()) end,
	loyalty = 7
})