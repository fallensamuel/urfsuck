local reap_spawn = {
	rp_city17_alyx_urfim = {
		Vector(-5222, -648, 80),
		Vector(-5239, -901, 80),
	},
}

local reap_models = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',}

rp.addTeam("Агент Reapers", {
	color = Color(255, 0, 0),
	model = reap_models,
	description = [[Агент Сопротивления и криминальная личность
]],
	weapons = {"swb_shotgun"},
	salary = 15,
	command = "reap",
	spawns = reap_spawn,		
	disableDisguise = true,	
	reversed = true,
	faction = FACTION_REBEL,
	unlockTime = 10 * 3600,
	armor = 100,
	rationCount = 1,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Reapers") end,
	loyalty = 7,
	appearance = 
	{
        {mdl = reap_models,
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {3,5,6,8},
                [2] = {0,2,3},
                [3] = {1},
                [4] = {0,1,2,3},
                [5] = {0},
                [6] = {2,4,5},
                [7] = {0,1,2},
                [8] = {1},
            			}
        },
    },
})