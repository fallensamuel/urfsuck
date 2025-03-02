
local refugees_spawns = {
	rp_city17_alyx_urfim = {Vector(3741, -1192, 32),Vector(4302, 8335, -48),Vector(2926, 6374, 32)},
	}

local birds_spawns = {
	rp_city17_alyx_urfim = {Vector(3163, 40, 404)},
}

local bynkerd4_spawns = {
	rp_city17_alyx_urfim = {
	Vector(2141, 5402, -384),
	Vector(2141, 5322, -384),
	Vector(2141, 5175, -384),
	Vector(2236, 5402, -384),
	Vector(2236, 5322, -384),
	Vector(2236, 5175, -384)
	},
}

TEAM_GMAN = rp.addTeam('G-Man', {
	color = Color(148, 0, 211),
	model = "models/kaesar/hlalyx/gman/gman.mdl", 
description = [[Ты самая настоящая легенда - ты G-Man.
Ты имеешь право присутствовать везде, где только можно
Ведь никто не знает-кто ты...
 
Правила:
- Вы персонаж, которого не видит никто, но вы видите и можете взаимодействовать с ним, если он начал взаимодействовать с вами. (Аликс/Илай/Барни/Кляйнер/Вортигонты видят G-Man’а);
- Запрещено приказывать людям;
- Вы наблюдатель, вы не можете влиять на РП составляющую;
]],
	command = 'gman',
	weapons = {'g_man_teleport'},
	salary = 30,
	faction = FACTION_REFUGEES,
	rationCount = 6,
	reversed = true,
	disableDisguise = true,
	CantUseDisguise = true,
	loyalty = 4,
	stamina = 9999,
	noHunger = true,
	max = 1,
	PlayerSpawn = function(ply) ply:GodEnable(true) end,
	customCheck = function(ply) return CLIENT or ply:HasPremium() or rp.PlayerHasAccessToJob('g_man_teleport', ply) end,
})

TEAM_HOBO = rp.addTeam('Беженец', {
	color = Color(46, 139, 87),
	model = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
description = [[Беженец из другого города, проживающий в Сити 17 нелегально.]],
	weapons = {'weapon_bugbait', 'weapon_prop_destroy'},
	spawns = bynkerd4_spawns,
	command = 'hobo',
	CantUseDisguise = true,
	canUseHire = true,
	canCapture = true,
	forceLimit = true,
	max = 0,
	salary = 7,
	speed = 0.9,
	armor = 50,
	hobo = true,
	reversed = true,
	faction = FACTION_REFUGEES,
	rationCount = 1,
	loyalty = 7,
	appearance = 
	{
        {mdl = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0,1,2,3,4,5,6,8,9,10},
                [2] = {0,1,2,3},
                [3] = {0,1,2,3,4},
                [4] = {0},
                [5] = {0},
                [6] = {3,4,5,6,7,8,9,10},
                [7] = {0,1,2,3,4},
                [8] = {0,1,2},
            			}
        },
    },
})

rp.cfg.RepressedTeam = TEAM_HOBO

TEAM_DOG = rp.addTeam('Пёс', {
	color = Color(189, 183, 107),
	model = 'models/kaesar/falloutdogs/falloutdog2.mdl',
	description = [[Обычный пес - дворняга. Ищет своего хозяйна.

Правила:
- Кусать можно только в целях самозащиты или если приказал хозяин;
]],
	weapons = {'weapon_dogswep'},
	command = 'dog',
	max = 4,
	salary = 7,
	admin = 0,
	CantUseDisguise = true,
	notDisguised = true,
	candemote = false,
	hirable = true,
	hirePrice = 10,
	reversed = true,
	build = false,
	spawns = refugees_spawns,
	PlayerSpawn = function(pl)
		pl:SetHealth(100)
		pl:SetMaxHealth(100)
	end,
	build = false,
	faction = FACTION_REFUGEES,
		appearance = 
	{
        {mdl = {
'models/kaesar/falloutdogs/falloutdog2.mdl',},
          skins       = {0,1,2},
           bodygroups = {
                [1] = {0,1,2},
                [2] = {0,1},
            			}
        },
    },
})

TEAM_PIGEON = rp.addTeam("Голубь", {
	color = Color(189, 183, 107),
	model = {"models/pigeon.mdl"},
	description = [[-300
]],
	salary = 7,
	spawn_points = empty,
	command = "pigeon",
	reversed = true,
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	spawns = birds_spawns,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	customCheck = function(ply) return ply:HasUpgrade('job_pigeon') or rp.PlayerHasAccessToJob('pigeon', ply) or (not noDonate and rp.PlayerHasAccessToCustomJob({'Sponsop donat'}, ply:SteamID64()))    end,
	build = false,
	disableDisguise = true,
})

TEAM_CROW = rp.addTeam("Ворона", {
	color = Color(189, 183, 107),
	model = {"models/crow.mdl"},
	description = [[-300
]],
	salary = 7,
	spawn_points = empty,
	command = "crow",
	reversed = true,
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	spawns = birds_spawns,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	customCheck = function(ply) return ply:HasUpgrade('job_crow')  or rp.PlayerHasAccessToJob('crow', ply) or (not noDonate and rp.PlayerHasAccessToCustomJob({'Sponsop donat'}, ply:SteamID64()))  end,
	build = false,
	disableDisguise = true,
})

TEAM_SEAGULL = rp.addTeam("Чайка", {
	color = Color(189, 183, 107),
	model = {"models/seagull.mdl"},
	description = [[-300
]],
	salary = 7,
	spawn_points = empty,
	command = "seagull",
	reversed = true,
	weapons = {"weapon_bird"},
	faction = FACTION_REFUGEES,
	spawns = birds_spawns,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	customCheck = function(ply) return ply:HasUpgrade('job_seagull')  or (not noDonate and rp.PlayerHasAccessToCustomJob({'Sponsop donat'}, ply:SteamID64()))  end,
	build = false,
	disableDisguise = true,
})

rp.AddDoorGroup('Беженцы', rp.GetFactionTeams({FACTION_REFUGEES}))

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_REFUGEES})))

rp.SetTeamVoices(TEAM_GMAN, {
	{
		label = 'Пробуждение 1',
		sound = 'vo/gman_misc/gman_riseshine.wav', 
		text = 'Проснитесь и пойте, мистер Фриман, проснитесь и пойте.',  
		soundDuration = 6
	},
	{
		label = 'Пробуждение 2',
		sound = 'vo/gman_misc/gman_02.wav', 
		text = 'Не то, чтобы я хотел сказать, что вы спите на работе;',
		soundDuration = 6 
	},
	{
		label = 'Пробуждение 3',
		sound = 'vo/gman_misc/gman_03.wav', 
		text = 'Нужный человек в нужном месте может перевернуть мир.',
		soundDuration = 6
	},
	{
		label = 'Пробуждение 4',
		sound = 'vo/gman_misc/gman_04.wav', 
		text = 'Так что, проснитесь, Мистер Фриман, проснитесь, вас снова ждут великие дела.',
		soundDuration = 6
	},
	{
		label = 'Время 1',
		sound = 'vo/citadel/gman_exit01.wav', 
		text = 'Время, Доктор Фриман?',
		soundDuration = 6
	},
	{
		label = 'Время 2',
		sound = 'vo/citadel/gman_exit02.wav', 
		text = 'Неужели оно вновь пришло?',
		soundDuration = 6
	},
	{
		label = 'Время 3',
		sound = 'vo/citadel/gman_exit03.wav', 
		text = 'Кажется, что вы только прибыли.',
		soundDuration = 6
	},
	{
		label = 'Время 4',
		sound = 'vo/citadel/gman_exit04.wav', 
		text = 'Вы сделали великие дела в столь короткое время.', 
		soundDuration = 6
	},
	{
		label = 'Время 5',
		sound = 'vo/citadel/gman_exit05.wav', 
		text = 'Собственно, вы настолько хороши, что я получил несколько интересных предложений на ваш счет.',
		soundDuration = 6
	},
	{
		label = 'Время 6',
		sound = 'vo/citadel/gman_exit06.wav', 
		text = 'Чем обманывать вас иллюзией выбора, я сам возьму на себя эту привилегию.', 
		soundDuration = 6
	},
	{
		label = 'Время 7',
		sound = 'vo/citadel/gman_exit07.wav', 
		text = 'Я прошу прощения за то, что кажется вам деспотичным навязыванием своей воли, доктор Фримен.', 
		soundDuration = 6
	},
	{
		label = 'Время 8',
		sound = 'vo/citadel/gman_exit08.wav', 
		text = 'Я не вправе сейчас говорить это.', 
		soundDuration = 6
	},
	{
		label = 'Время 9',
		sound = 'vo/citadel/gman_exit09.wav', 
		text = 'Между тем…', 
		soundDuration = 6
	},
	{
		label = 'Время 10',
		sound = 'vo/citadel/gman_exit10.wav', 
		text = '...Здесь я исчезаю.', 
		soundDuration = 6
	},
})

hook('OnPlayerChangedTeam', function(ply, prevTeam, t)
	if prevTeam == TEAM_GMAN then
		ply:GodEnable(false)
	end
end)