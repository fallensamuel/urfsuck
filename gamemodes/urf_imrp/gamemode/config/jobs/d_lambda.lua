local lu_spawn = {
	rp_city17_alyx_urfim = {
		Vector(-5222, -648, 80),
		Vector(-5239, -901, 80),
	},
}

local lu_models = {
'models/tnb/citizens/male_20.mdl',}

rp.addTeam("Новобранец LU", {
	color = Color(113, 128, 123),
	model = lu_models,
	description = [[Только вступивший в ряды отряда Lambda Union. 
В будущем Вас бы считали первопроходцем, а здесь - элитным рекрутом спецназа повстанцев.
]],
	weapons = {"swb_smg"},
	salary = 15,
	command = "lu1",
	spawns = lu_spawn,		
	disableDisguise = true,	
	reversed = true,
	faction = FACTION_REBEL,
	unlockTime = 10 * 3600,
	armor = 100,
	rationCount = 1,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Lambda Soldiers") end,
	loyalty = 7,
})

rp.addTeam("Солдат LU", {
	color = Color(113, 128, 123),
	model = {'models/tnb/citizens/male_21.mdl'},
	description = [[Обученный боец отряда всем базовым навыкам. Основная боевая и рабочая сила отряда. 
Вам дозволили командование над новобранцами, и более улучшенную экипировку.
]],
	weapons = {"swb_357",'swb_shotgun'},
	salary = 15,
	command = "lu2",
	spawns = lu_spawn,		
	disableDisguise = true,	
	reversed = true,
	faction = FACTION_REBEL,
		candisguise = true,
		disguise_faction = FACTION_CITIZEN,
	unlockTime = 90 * 3600,
	armor = 200,
	PlayerSpawn = function(ply) ply:SetHealth(125) ply:SetMaxHealth(125)  end,
	rationCount = 1,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Lambda Soldiers") end,
	loyalty = 7,
})