local savage_spawn = {
	rp_city17_alyx_urfim = {
		Vector(7129, 187, -64),
		Vector(7423, 161, -64),
	},
}

local spectre_spawns = {
	rp_city17_alyx_urfim = {Vector(2192, 5386, -384),Vector(2168, 5194, -384)},
	}

local rebeldelta_spawns = {
	rp_city17_alyx_urfim = {Vector(-5231, -908, 80),Vector(-5241, -649, 80)},
	}


--Альянс
rp.addTeam("OTA.DELTA.SAVAGE", {
	color = Color(220, 20, 60),
	model = {'models/blagod/mass_effect/pm/alliance/biotic_female_alliance_1.mdl'},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"police_stunstick", "tfa_heavyshotgun",'weapon_hl2pot','door_ram','weapon_cuff_elastic'},
	salary = 15,
	command = "savage",
	spawns = savage_spawn,		
	hasLicense = true,
	reversed = true,
	vip = true,
	disableDisguise = true,
	CantUseDisguise = true,
	max = 2,
	faction = FACTION_OTA,
	armor = 350,
	unlockTime = 200 * 3600,
	rationCount = 1,
	speed = 1.2,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150)  end,
	customCheck = function(ply) return rp.PlayerHasAccessToCustomJob({'OTA.DELTA.SAVAGE'}, ply:SteamID64()) or ply:IsRoot() or (ply:GetOrg() == "Division Delta") end,
	loyalty = 1,
})
--Беженцы
rp.addTeam("Spectre Unit", {
	color = Color(3, 17, 30),
	model = {'models/scp_mtf_russian/mtf_rus_09.mdl'},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"swb_shotgun"},
	salary = 15,
	command = "specunit",
	unlockTime = 90 * 3600,
	spawns = spectre_spawns,		
	reversed = true,
	disableDisguise = true,
			candisguise = true,
			disguise_faction = FACTION_MPF,
	faction = FACTION_REFUGEES,
	armor = 200,
	max = 4,
	rationCount = 1,
	PlayerSpawn = function(ply) ply:SetHealth(140) ply:SetMaxHealth(140)  end,
	customCheck = function(ply) return rp.PlayerHasAccessToCustomJob({'Spectre Unit'}, ply:SteamID64()) or ply:IsRoot() or (ply:GetOrg() == "Division Delta") end,
	loyalty = 7,
})
--Сопротивление
rp.addTeam("REBEL.DELTA.Tenebitur", {
	color = Color(209, 67, 28),
	model = {'models/c13/elite2.mdl'},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"tfa_heavyshotgun",'weapon_hl2pot'},
	salary = 15,
	command = "rebeldelta",
	spawns = rebeldelta_spawns,		
	reversed = true,
	max = 2,
	disableDisguise = true,
	faction = FACTION_REBEL,
	armor = 300,
	unlockTime = 200 * 3600,
	rationCount = 1,
			candisguise = true,
			disguise_faction = FACTION_MPF,
	vip = true,
	PlayerSpawn = function(ply) ply:SetHealth(140) ply:SetMaxHealth(140)  end,
	customCheck = function(ply) return rp.PlayerHasAccessToCustomJob({'REBEL.DELTA.Tenebitur'}, ply:SteamID64()) or ply:IsRoot() or (ply:GetOrg() == "Division Delta") end,
	loyalty = 7,
})