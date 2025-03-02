local bioh_spawn = {
	rp_city17_alyx_urfim = {
		Vector(-5222, -648, 80),
		Vector(-5239, -901, 80),
	},
}

rp.addTeam("Научный Сотрудник Biohazard", {
	color = Color(208, 62, 64),
	model = {
'models/daemon_alyx/players/male_citizen_01.mdl',
'models/daemon_alyx/players/male_citizen_02.mdl',
'models/daemon_alyx/players/male_citizen_03.mdl',},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"swb_shotgun"},
	salary = 15,
	command = "li12ps",
	spawns = bioh_spawn,
	notDisguised = true,
	reversed = true,
	faction = FACTION_REFUGEES,
	armor = 100,
	unlockTime = 10 * 3600,
	rationCount = 1,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Vestniki_Sveta") end,
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