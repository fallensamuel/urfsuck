-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\utilities.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local empty = {}
local  utilities_spawns = {
rp_stalker_urfim_v3 = {Vector(-1281, 327, -1280),},
rp_pripyat_urfim = {Vector(9581, 480, 4821)},
rp_stalker_urfim = {Vector(9389, -3, 11264)},
rp_st_pripyat_urfim = {Vector(-2788, -12365, 3648)},
}

TEAM_MOD = rp.addTeam('Модератор', {
	color = Color(51, 128, 255),
	model = 'models/oso.mdl',
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_moderator',
	max = 0,
	salary = 7,
    stamina = 1000,
	admin = 1,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('moderator') or pl:IsRank('moderator*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_ADMIN = rp.addTeam('Администратор', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_admin',
	max = 0,
	salary = 10,
    stamina = 1000,
	admin = 1,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('admin') or pl:IsRank('admin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_ADMINPLUS = rp.addTeam('Администратор+', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_adminplus',
	max = 0,
	salary = 10,
    stamina = 1000,
	admin = 1,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('adminplus') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_HEAD_ADMIN = rp.addTeam('Head Admin', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},

	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_headadmin',
	max = 0,
	salary = 12,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('headadmin') or pl:IsRank('headadmin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_HELPER = rp.addTeam('Helper', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},

	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_helper',
	max = 0,
	salary = 12,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('helper') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_SUPER_ADMIN = rp.addTeam('Super Admin', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_superadmin',
	max = 0,
	salary = 12,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('superadmin') or pl:IsRank('superadmin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_GLOBAL_ADMIN = rp.addTeam('Global Admin', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_global',
	max = 0,
	salary = 15,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return  pl:IsRank('globaladmin') or pl:IsRank('globaladmin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_MANAGER = rp.addTeam('Staff Leader', {
	color = Color(51, 128, 255),
	model = {'models/oso.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_manager',
	max = 0,
	salary = 16,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return  pl:IsRank('manager') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_EX = rp.addTeam('Executive', {
	color = Color(51, 128, 255),
	model = {'models/kemot44/models/mk11/characters/skarlet_kold_war_pm.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Ты крутой чел, спасибо что ты есть.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_executive',
	max = 0,
	salary = 16,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return  pl:IsRank('executiverookie')  or pl:IsRank('executivespecialist')  or  pl:IsRank('executiveleader') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

TEAM_GADEX = rp.addTeam('Странствующий Торговец[NONRP]', {
	color = Color(0, 0, 0),
	model = {'models/legends/senator.mdl', "models/legends/black.mdl", "models/oso.mdl","models/kemot44/models/mk11/characters/skarlet_kold_war_pm.mdl"},
	description = [[
Профа ток для куратора и конса
Запрет товар
	]],
	weapons = {'weapon_keypadchecker',"lockpick", "hacktool"},
	command = 'staff_gadexecutive',
	max = 0,
	salary = 16,
    stamina = 1000,
    max = 1,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	customCheck = function(pl) return  pl:IsRank('executiverookie')  or pl:IsRank('executivespecialist')  or  pl:IsRank('executiveleader') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})
/*
TEAM_DED_MOROZ = rp.addTeam("Дед Мороз", {
	color = Color(255, 0, 0),
	model = "models/player/christmas/santa.mdl",
	description = [[
]],
	salary = 17,
    stamina = 1000,
	spawn_points = empty,
	command = "dedmoroz",
	weapons = {},
	faction = FACTION_ADMINS,
	spawns = utilities_spawns,
	candemote = false,
	customCheck = function(pl) return pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:SetRunSpeed(350) pl:GodEnable(true) end,
	max = 1,
})
*/
TEAM_SPONSOR = rp.addTeam('Гений [NONRP]', {
	color = Color(51, 128, 255),
	model = {'models/player/sanic/kojimap.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Запрещено покидать АдминБазу без включенного инвиза /cloack
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_sponsor',
	max = 0,
	salary = 1,
    stamina = 1000,
	admin = 1,
	medic = true,
	candemote = false,
	mayorCanSetSary = false,
	footstepSound = false,
	customCheck = function(pl) return pl:IsRank('globalcontributor') or pl:IsRank('platinumcontributor')  or pl:IsRank('goldencontributor') or pl:IsRank('maid-diamondcontributor') or pl:IsRank('stalker-diamondcontributor') or pl:IsRank('vip+') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = utilities_spawns,
	faction = FACTION_ADMINS,
})

--rp.AddToRadioChannel({TEAM_HEAD_ADMIN, TEAM_SUPER_ADMIN, TEAM_GLOBAL_ADMIN, TEAM_MANAGER, TEAM_DED_MOROZ, TEAM_SPONSOR}, rp.GetFactionTeams(FACTION_ADMINS))