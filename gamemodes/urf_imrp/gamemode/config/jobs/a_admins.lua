if SERVER then
    hook.Add("PlayerHasHunger", function(ply)
         if ply:GetJobTable().noHunger == true then return false end
    end)
end

local admin_color = Color(138, 43, 226)

TEAM_MOD = rp.addTeam('Модератор', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии. 
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_moderator',
	max = 0,
	salary = 15,
	admin = 1,
	candemote = false,
	stamina = 9999,
	noHunger = true,
	loyalty = 10,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('moderator') or pl:IsRank('moderator*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_ADMIN = rp.addTeam('Администратор', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии. 
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_admin',
	max = 0,
	salary = 20,
	loyalty = 10,
	admin = 1,
	candemote = false,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('admin') or pl:IsRank('admin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_ADMINPLUS = rp.addTeam('Adminplus', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии. 
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_adminplus',
	max = 0,
	salary = 25,
	loyalty = 10,
	admin = 1,
	candemote = false,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('adminplus') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_HEAD_ADMIN = rp.addTeam('Head Admin', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии. 
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_headadmin',
	max = 0,
	salary = 30,
	admin = 1,
	candemote = false,
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('headadmin') or pl:IsRank('headadmin*') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_HELPER = rp.addTeam('Helper', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии. 
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_helper',
	max = 0,
	salary = 35,
	admin = 1,
	candemote = false,
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('helper') or pl:IsRoot() end,
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_SUPER_ADMIN = rp.addTeam('Super Admin', { 
	color = admin_color, 
	model = {
		"models/player/skeleton.mdl"},
	description = [[ 
	Это Нон-РП класс. 
	Данный класс для Администрации сервера. 
	Данный класс имеет отличительный скин. 
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии.  
	]], 
	weapons = {'weapon_keypadchecker'}, 
	command = 'staff_superadmin', 
	max = 0, 
	salary = 40, 
	admin = 1, 
	candemote = false, 
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false, 
	customCheck = function(pl) return pl:IsRank('superadmin') or pl:IsRank('superadmin*') or pl:IsRoot() end, 
	CustomCheckFailMsg = 'JobNeedsAdmin',
	PlayerSpawn = function(pl) pl:GodEnable(true) end, 
	spawns = { 
	rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)}, 
	rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
	rp_c18_urfim = {Vector(1564, -4918, 664),},
	rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)}, 
	}, 
	faction = FACTION_ADMINS, 
})

TEAM_GLOBAL_ADMIN = rp.addTeam('Global Admin', { 
	color = admin_color, 
	model = {
		"models/player/skeleton.mdl"},
	description = [[ 
	Это Нон-РП класс. 
	Данный класс для Администрации сервера. 
	Данный класс имеет отличительный скин. 
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии.  
	]], 
	weapons = {'weapon_keypadchecker'}, 
	command = 'staff_globaladmin', 
	max = 0, 
	salary = 45, 
	admin = 1, 
	candemote = false, 
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false, 
	customCheck = function(pl) return  pl:IsRank('globalcontributor') or pl:IsRank('platinumcontributor') or pl:IsRank('goldencontributor') or pl:IsRank('globaladmin') or pl:IsRank('globaladmin*') or pl:IsRank('executiveleader') or pl:IsRank('executivespecialist') or pl:IsRoot() end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	PlayerSpawn = function(pl) pl:GodEnable(true) end, 
	spawns = { 
	rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)}, 
	rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
	rp_c18_urfim = {Vector(1564, -4918, 664),},
	rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)}, 
	}, 
	faction = FACTION_ADMINS, 
})

TEAM_SPONSOR = rp.addTeam('Знаменитое лицо', {
	color = admin_color,
	model = {'models/kaesar/hlalyx/gman/gman.mdl'},
	description = [[
	Это Нон-РП класс.
	Данный класс для Спонсоров сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_sponsor',
	max = 0,
	salary = 50,
	admin = 1,
	candemote = false,
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRank('globalcontributor') or pl:IsRank('platinumcontributor') or pl:IsRank('goldencontributor') or pl:IsRank('executiveleader') or pl:IsRank('executivespecialist') or pl:IsRoot() end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_MANAGER = rp.addTeam('Staff Leader', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_manager',
	max = 0,
	salary = 55,
	admin = 1,
	candemote = false,
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return  pl:IsRank('staffleader')  or  pl:IsRoot() end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_ROOT = rp.addTeam('Root', {
	color = admin_color,
	model = {
		"models/player/skeleton.mdl"},
	description = [[
	Это Нон-РП класс.
	Данный класс для Администрации сервера.
	Данный класс имеет отличительный скин.
	Если вы хотите быть АФК, смените на безработного.
	Запрещено ставить /job в этой профессии.
	]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_root',
	max = 0,
	salary = 60,
	admin = 1,
	candemote = false,
	loyalty = 10,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return pl:IsRoot() end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	PlayerSpawn = function(pl) pl:GodEnable(true) end,
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})

TEAM_DED_MOROZ = rp.addTeam("Дед Мороз", {
	color = Color(255, 0, 0),
	model = {"models/player/christmas/santa.mdl"},
	description = [[
]],
	salary = 70,
	spawn_points = empty,
	command = "dedmoroz",
	weapons = {},
	faction = FACTION_ADMINS,
	rationCount = 0,
	candemote = false,
	stamina = 9999,
	noHunger = true,
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),}
	},
	customCheck = function(ply) return ply:IsRoot() end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(500) ply:GodEnable(true) end,
	max = 1,
	loyalty = 5
})

TEAM_GADMIN = rp.addTeam('Странствующий Торговец ', {
	color = Color(205, 92, 92),
	model = {'models/teslacloud/citizens/male09.mdl'},
	description = [[Странствующий торговец, никто не знает откуда он прибыл.]],
	weapons = {'weapon_keypadchecker'},
	command = 'staff_g',
	max = 0,
	salary = 70,
	admin = 1,
	candemote = false,
	loyalty = 1,
	stamina = 9999,
	noHunger = true,
	mayorCanSetSary = false,
	customCheck = function(pl) return  pl:IsRank('staffleader') or pl:IsRoot() end,
	CustomCheckFailMsg = 'JobNeedsAdmin',
	spawns = {
		rp_city17_alyx_urfim = {Vector(3107, 4907, 2512)},
		rp_mk_city17_urfim = {Vector(-4642, -580, 11611)},
		rp_c18_urfim = {Vector(1564, -4918, 664),},
		rp_industrial17_urfim = {Vector(-4894, -7308, 12190), Vector(-7623, -7297, 12190)},
	},
	faction = FACTION_ADMINS,
})
/*
rp.addTeam('Святой Джек', {
	color = Color(0, 0, 0),
	model = "models/vinrax/player/jack_player.mdl",
	weapons = {"sh_blinkswep",'weapon_fists'},
	description = [[]],
	command = 'legmoney',
	salary = 1000,
	hpRegen = 900,
	faction = FACTION_ADMINS,
	customCheck = function(pl) return pl:IsRoot() end,
	armor = 10001,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50001) ply:SetHealth(50001) end,
	PlayerDeath = function(ply, weapon, killer)
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('LegKilled'))
		for _, killer in pairs(ents.FindInSphere(ply:GetPos(), 900)) do
			if killer:IsPlayer() then
				killer:AddCredits(15, 'holy jack')
				--rp.NotifyAll(NOTIFY_GENERIC, rp.Term('CreditsReceived'), 15)
			end
		end
		ply:ChangeTeam(rp.GetDefaultTeam(ply), true)
	end,
})
*/