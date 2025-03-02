local deathesc_spawn = {
	rp_city17_alyx_urfim = {
		Vector(2199, 5385, -384),
		Vector(2201, 5188, -384),
	},
}

rp.addTeam("Каратель ЭС", {
	color = Color(178, 12, 15),
	model = {'models/dany/medic_kz/medic_kz.mdl'},
	description = [[Легкий штурмовик Эскадрона Смерти, составляющий основу всей ударной силы группировки.

Подчиняется: Ликвидатор ЭС +
]],
	weapons = {"swb_shotgun",'swb_oicw_v2','climb_swep','weapon_medkit'},
	salary = 15,
	command = "karatel",
	spawns = deathesc_spawn,		
	faction = FACTION_REFUGEES,
	armor = 200,
	unlockTime = 90 * 3600,
	rationCount = 1,
	candisguise = true,
	disableDisguise = true,
	reversed = true,
	forceLimit = true,
	max = 4,
	disguise_faction = FACTION_CITIZEN,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Эскадрон Смерти") end,
	loyalty = 7,
})

rp.addTeam("Завербованный ЭС", {
	color = Color(178, 12, 15),
	model = {'models/niik/pm/smod_operator_01.mdl'},
	description = [[
Новоприбывший в ряды Эскадрона Смерти, не пользующийся уважением у более закаленных бойцов.

Подчиняется: Каратель+
]],
	weapons = {"swb_smg",'climb_swep'},
	salary = 15,
	command = "zaverbovaniiec",
	spawns = deathesc_spawn,		
	faction = FACTION_REFUGEES,
	armor = 100,
	unlockTime = 15 * 3600,
	rationCount = 1,
	disableDisguise = true,
	reversed = true,
	loyalty = 7,
})