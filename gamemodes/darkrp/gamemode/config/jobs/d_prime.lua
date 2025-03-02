local shade_spawn = {
	rp_city17_alyx_urfim = {
		Vector(7129, 187, -64),
		Vector(7423, 161, -64),
	},
}

local regnarek_spawns = {
	rp_city17_alyx_urfim = {Vector(-5231, -908, 80),Vector(-5241, -649, 80)},
	}


--Альянс
rp.addTeam("SHADE.PRIME", {
	color = Color(240, 255, 255),
	model = {'models/niik/pm/pilot_female.mdl'},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"police_stunstick", "tfa_heavyshotgun",'weapon_hl2pot','swb_357','weapon_cuff_elastic','climb_swep'},
	salary = 18,
	command = "shade",
	spawns = shade_spawn,		
	hasLicense = true,
	reversed = true,
	vip = true,
	disableDisguise = true,
	CantUseDisguise = true,
	max = 2,
	faction = FACTION_MPF,
	armor = 300,
	vip = true,
		candisguise = true,
		disguise_faction = FACTION_REBEL,
	unlockTime = 200 * 3600,
	rationCount = 1,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "ECLIPSE.PRIME" && (ply:GetOrgData().Rank == 'OVERLORD.PRIME' or ply:GetOrgData().Rank == "OVERWATCH.PRIME" or ply:GetOrgData().Rank == 'STAFF.PRIME' or ply:GetOrgData().Rank == 'GLOBAL.PRIME' or ply:GetOrgData().Rank == 'ULTIMATE.PRIME' or ply:GetOrgData().Rank == 'UNIVERSAL.PRIME' or ply:GetOrgData().Rank == 'DIMENSION.PRIME' or ply:GetOrgData().Rank == 'SHADE.PRIME')) or rp.PlayerHasAccessToCustomJob({'SHADE.PRIME'}, ply:SteamID64()) end,
	loyalty = 1,
})
--Повстанцы
rp.addTeam("RAGNAROK.PRIME", {
	color = Color(240, 248, 255),
	model = {'models/niik/pm/Capture_Trooper.mdl'},
	description = [[На данный момент описание отсутствует.
]],
	weapons = {"tfa_heavyshotgun",'weapon_hl2pot','swb_357','climb_swep'},
	salary = 18,
	command = "regnarek",
	unlockTime = 200 * 3600,
	spawns = regnarek_spawns,		
	reversed = true,
	vip = true,
	disableDisguise = true,
			candisguise = true,
			disguise_faction = FACTION_MPF,
	faction = FACTION_REBEL,
	armor = 300,
	max = 2,
	rationCount = 1,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "ECLIPSE.PRIME" && (ply:GetOrgData().Rank == 'OVERLORD.PRIME' or ply:GetOrgData().Rank == "OVERWATCH.PRIME" or ply:GetOrgData().Rank == 'STAFF.PRIME' or ply:GetOrgData().Rank == 'GLOBAL.PRIME' or ply:GetOrgData().Rank == 'ULTIMATE.PRIME' or ply:GetOrgData().Rank == 'UNIVERSAL.PRIME' or ply:GetOrgData().Rank == 'DIMENSION.PRIME' or ply:GetOrgData().Rank == 'RAGNAROK.PRIME')) or rp.PlayerHasAccessToCustomJob({'RAGNAROK.PRIME'}, ply:SteamID64()) end,
	loyalty = 7,
})
