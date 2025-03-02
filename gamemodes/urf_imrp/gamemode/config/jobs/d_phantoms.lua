local phantom_spawns = {
	rp_city17_alyx_urfim = {
		Vector(6860, 759, -64),
		Vector(6860, 693, -64),
		Vector(6860, 635, -64),
		Vector(6860, 571, -64),
		Vector(6911, 759, -64),
		Vector(6911, 693, -64),
		Vector(6911, 635, -64),
		Vector(6911, 571, -64),
		Vector(6986, 759, -64),
		Vector(6986, 693, -64),
		Vector(6986, 635, -64),
		Vector(6986, 571, -64),
	},
}

local phantom_models = {
'models/rrp/metropolice/pm/jmetropolicepm.mdl',}

rp.addTeam("С17.MPF.Phantom", {
	color = Color(238, 221, 130),
	model = phantom_models,
	description = [[Сотрудник, лояльный к идеям Альянса, которого перевели в подразделение Phantom благодаря множественным заслугам во время службы. 
Обучен в проводить допросы среди граждан и сотрудников ГСР на профессиональном уровне, для выявления признаком тунеядства и нарушения законов города, а так же обучен к ведению боевых действий в разных секторах. 

Имеет право командывать ГСР и Гражданами в меру должностных обязанностей.
]],
	weapons = {"swb_ar2","swb_357",'police_stunstick'},
	salary = 15,
	command = "phantomd1",
	spawns = phantom_spawns,		
	disableDisguise = true,
	randomName = true,	
	reversed = true,
	disableDisguise = true,
	faction = FACTION_MPF,
	unlockTime = 100 * 3600,
	armor = 200,
	max = 4,
	rationCount = 6,
	customCheck = function(ply) return ply:IsRoot() or (ply:GetOrg() == "Union Right") end,
	loyalty = 3,
})