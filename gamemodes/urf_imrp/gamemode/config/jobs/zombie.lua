local zombie_color = Color(255, 64, 64)

local zombie_spawns = {
	rp_city17_alyx_urfim = {
	Vector(3867, 10811, -384),
	Vector(4116, 10323, -385),
	Vector(4070, 9454, -384),
	Vector(5282, 10654, -352),
	Vector(5949, 10362, -352),
	Vector(3422, 10818, -365),
},
}

local empty = {}

if SERVER then
    hook.Add("PlayerHasHunger", function(ply)
         if ply:GetJobTable().noHunger == true then return false end
    end)
end
/*
TEAM_HEDCRAB = rp.addTeam("Хедкраб", {
	color = zombie_color,
	model = {"models/headcrabclassic.mdl"},
	description = [[ Хед краб, самое низкое существо среди мутантов, но они могут опасны.
]],
	salary = 3,
	Gravity = 0.7,
	JumpPower = 100,
	WalkSpeed = 100,
	RunSpeed = 150,
	PrimaryDamage = 40,
	reversed = true,
	PrimaryTime = 2.5,
	hpRegen = 1,
	spawns = zombie_spawns,
	spawn_points = empty,
	command = "lamar",
	weapons = {"weapon_headcrab"},
	faction = FACTION_ZOMBIE,
	PlayerSpawn = function(ply) ply:SetMaxHealth(65) ply:SetHealth(65) end,
	build = false,
	headcrab = true,
	noHunger = true,
})

TEAM_POISUON = rp.addTeam("Ядовитый хедкраб", {
	color = zombie_color,
	model = {"models/headcrab.mdl"},
	description = [[ Опасный ядовитый хедкраб, его яд опасен для любого существа
]],
	salary = 3,
	Gravity = 0.7,
	JumpPower = 100,
	WalkSpeed = 100,
	RunSpeed = 150,
	PrimaryDamage = 60,
	reversed = true,
	PrimaryTime = 2.5,
	hpRegen = 1,
	spawns = zombie_spawns,
	max = 2,
	spawn_points = empty,
	command = "poisuon",
	weapons = {"weapon_poison_headcrab"},
	faction = FACTION_ZOMBIE,
	vip = true,
	PlayerSpawn = function(ply) ply:SetMaxHealth(75) ply:SetHealth(75) end,
	build = false,
	headcrab = true,
})

TEAM_HEDCRAB = rp.addTeam("Быстрый хедкраб", {
	color = zombie_color,
	model = {"models/headcrab.mdl"},
	description = [[ Самый быстрый из хедкрабов, его удары менее опысны, но они намного быстрее обычных хедкрабов.
]],
	salary = 3,
	Gravity = 0.7,
	JumpPower = 100,
	WalkSpeed = 200,
	RunSpeed = 250,
	PrimaryDamage = 30,
	reversed = true,
	PrimaryTime = 1.5,
	hpRegen = 1,
	max = 4,
	spawns = zombie_spawns,
	spawn_points = empty,
	command = "fasthed",
	weapons = {"weapon_fastheadcrab"},
	faction = FACTION_ZOMBIE,
	PlayerSpawn = function(ply) ply:SetMaxHealth(50) ply:SetHealth(50) end,
	build = false,
	headcrab = true,
	noHunger = true,
})
*/
TEAM_WEAK_ZOMBIE = rp.addTeam("Зомби", {
	color = zombie_color,
	model = {'models/hlvr/human/corpse/corpse_worker_1_player.mdl'},
	description = [[Бедняга, заражённый зомби инфекцией. 

Медленно дивигается, слабо бьёт.

Разрешено действовать в пределах D6-D3 в одиночку.
Разрешено действовать в любых секторах вместе с Манипулятором.
]],
	--unlockPrice = 50000,
	--unlockTime = 60 * 3600,
	salary = 3,
	spawn_points = empty,
	punchMin = 40,
	punchMax = 60,
	critMin = 45,
	critMax = 125,
	stamina = 3,
	command = "zombie",
	weapons = {"weapon_zombie_fists", "weapon_throw"},
	PlayerSpawn = function(ply) ply:SetWalkSpeed(75) ply:SetMaxHealth(150) ply:SetHealth(150) end,
	spawns = zombie_spawns,
	faction = FACTION_ZOMBIE,
	reversed = true,
	rationCount = 0,
	noHunger = true,
	build = false,
	loyalty = 7,
	monster = true,
	hpRegen = 3,
    eatHp = 20,
    CantUseDisguise = true,
})

TEAM_FAST_ZOMBIE = rp.addTeam("Быстрый Зомби", {
	color = zombie_color,
	model = {'models/hlvr/human/corpse/zombie/zombie_common_1_player.mdl'},
	description = [[Бедняга, заражённый зомби инфекцией.

Очень быстро дивигается, сильно бьёт.

Разрешено действовать в пределах D6-D3 в одиночку.
Разрешено действовать в любых секторах вместе с Манипулятором.
]],
	--unlockPrice = 50000,
	--unlockTime = 60 * 3600,
	salary = 5,
	spawn_points = empty,
	punchMin = 55,
	punchMax = 75,
	critMin = 80,
	critMax = 130,
	stamina = 3,
	max = 2,
	command = "fast_zombie",
	weapons = {"weapon_zombie_fists", "climb_swep", "weapon_throw_fast"},
	PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(400) ply:SetMaxHealth(200) ply:SetHealth(200) end,
	spawns = zombie_spawns,
	faction = FACTION_ZOMBIE,
	rationCount = 0,
	noHunger = true,
	unlockTime = 25*3600,
	forceLimit = true,
	reversed = true,
	build = false,
	hpRegen = 3,
	loyalty = 7,
	monster = true,
    eatHp = 50,
    CantUseDisguise = true,
})

TEAM_COMBINE_ZOMBIE = rp.addTeam("Зомби Толстяк", {
	color = zombie_color,
	model = {'models/hlvr/human/corpse/corpse_worker_1_player.mdl'},
	description = [[Зомбированный, обладающий повышенной живучестью и силой.

Обычно дивигается, сильно бьёт.

Разрешено действовать в пределах D6-D3 в одиночку.
Разрешено действовать в любых секторах вместе с Манипулятором.
]],
	salary = 7,
	spawn_points = empty,
    punchMin = 100,
	punchMax = 120,
	critMin = 140,
	critMax = 200,
	stamina = 5,
	max = 2,
	command = "zombine",
	weapons = {"weapon_zombie_fists","climb_swep", "weapon_throw_toxic"},
	PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(330) ply:SetMaxHealth(250) ply:SetHealth(250) end,
	spawns = zombie_spawns,
	armor = 300,
	faction = FACTION_ZOMBIE,
	rationCount = 0,
	noHunger = true,
	unlockTime = 60*3600,
	build = false,
	hpRegen = 3,
	canCapture = true,
	forceLimit = true,
	reversed = true,
	loyalty = 7,
	monster = true,
    eatHp = 100,
    CantUseDisguise = true,
	appearance =
	{
        {mdl = {
	'models/hlvr/human/corpse/corpse_worker_1_player.mdl',
		},
          skins       = {0},
           bodygroups = {
           		[2] = {1},
            			}
        },
    },
})

TEAM_ZOMBI_COMB = rp.addTeam("Зомбкрут", {
	color = zombie_color,
	model = {'models/auditor/kemoi/custom/combine2019/combine_zombie_pm.mdl'},
	description = [[Мертвое тело юнита MpF, зараженное вирусом, и полностью подчиненное хедкрабу на его голове.
Зомбкрут - особый вид зомби, сохранивший способность применять огнестрельное оружие на рефлексном уровне.

Особенности:
- Имеет огнестрельное оружие;
- Мощные атаки руками;
- Замедляет противника ударами рук;

Разрешено действовать в пределах D6-D3 в одиночку.
Разрешено действовать в любых секторах вместе с Манипулятором.
]],
	salary = 15,
	spawn_points = empty,
	punchMin = 70,
	punchMax = 100,
	critMin = 100,
	critMax = 120,
	stamina = 3,
	command = "zombirct",
	weapons = {"weapon_zombie_fists", "climb_swep", "weapon_frag", "swb_smg"},
	PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(300) ply:SetMaxHealth(150) ply:SetHealth(150) end,
	spawns = zombie_spawns,
	armor = 100,
	faction = FACTION_ZOMBIE,
	hpRegen = 3,
	rationCount = 0,
	noHunger = true,
	unlockTime = 75*3600,
	forceLimit = true,
	reversed = true,
	build = false,
	max = 3,
	loyalty = 7,
	canCapture = true,
	vip = true,
	monster = true,
    eatHp = 100,
    CantUseDisguise = true,
})

TEAM_ZOMBIEBOSS = rp.addTeam("Манипулятор", {
		color = zombie_color,
		model = {'models/hlvr/zombie/blind/zombie_blind_player.mdl'},
		description = [[Координирует действиями зомби.

	Быстро дивигается, неплохо бьёт, бронирован.

	Разрешено действовать в пределах D6-D3 в одиночку.
	Разрешено организовывать рейд в паре или группе.
	]],
		salary = 20,
		spawn_points = empty,
	    punchMin = 55,
		punchMax = 75,
		critMin = 80,
		critMax = 130,
		stamina = 5,
		command = "zombie_leader",
		weapons = {"weapon_zombie_fists", "weapon_frag", "climb_swep", "weapon_throw_toxic"},
		max = 1,
		PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(330) ply:SetMaxHealth(250) ply:SetHealth(250) end,
		spawns = zombie_spawns,
		armor = 500,
		faction = FACTION_ZOMBIE,
		rationCount = 0,
		noHunger = true,
		unlockTime = 200*3600,
		forceLimit = true,
		reversed = true,
		hpRegen = 3,
		build = false,
		canCapture = true,
		loyalty = 7,
		monster = true,
   	 	eatHp = 100,
   	 	CantUseDisguise = true,
	})
	
	/*
TEAM_TESTAUTOCODE = rp.addTeam("Профессия по промокоду", {
		color = zombie_color,
		model ={'models/hlvr/zombie/blind/zombie_blind_player.mdl'},
		description = [[Доступна после использования промокода test_promo2]],
		salary = 20,
		spawn_points = empty,
	    punchMin = 55,
		punchMax = 75,
		critMin = 80,
		critMax = 130,
		stamina = 5,
		reversed = true,
		command = "testpromojob",
		weapons = {"weapon_zombie_fists", "weapon_frag", "climb_swep", "weapon_throw_toxic", "weapon_biohazardball"},
		max = 1,
		PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(330) end,
		spawns = zombie_spawns,
		armor = 300,
		faction = FACTION_ZOMBIE,
		rationCount = 0,
		noHunger = true,
		unlockTime = 0*3600,
		hpRegen = 3,
		whitelisted = true,
		customCheck = function(ply) return CLIENT or rp.PlayerHasAccessToJob('testpromojob', ply) end,
		CustomCheckFailMsg = 'TestPromoDenied', 
		canCapture = true,
		loyalty = 7,
	})
	*/

TEAM_BANNED = rp.addTeam('Зомби', {
	color = zombie_color,
	model = {'models/hlvr/human/corpse/zombie/zombie_common_2_player.mdl'},
	description = [[
	Вас забанили!
	]],
	weapons = {"weapon_torso"},
	PlayerSpawn = function(ply) ply:SetMaxHealth(30) ply:SetWalkSpeed(80) ply:SetRunSpeed(80) end,
	command = 'banned124',
	punchMin = 3,
	punchMax = 5,
	critMin = 10,
	critMax = 15,
	reversed = true,
	max = 0,
	salary = 0,
	admin = 0,
	hasLicense = false,
	candemote = false,
	build = false,
	CantUseDisguise = true,
	spawns = zombie_spawns,
	customCheck = function(pl) return pl:IsBanned() end,
	CustomCheckFailMsg = 'JobNeedsBanned'
})

rp.SetFactionVoices({FACTION_ZOMBIE}, {
            {
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle1.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle2.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle3.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle4.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle5.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle6.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle7.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle8.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle9.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle10.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle11.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle12.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle13.wav',
				text = '*стонит*'
			},
			{
				label = 'Стонать', 
				sound = 'npc/zombie/zombie_voice_idle14.wav',
				text = '*стонит*'
			},
			{
				label = 'Рычать', 
				sound = 'npc/zombie/zombie_alert1.wav',
				text = '*рычит*'
			},
			{
				label = 'Рычать', 
				sound = 'npc/zombie/zombie_alert2.wav',
				text = '*рычит*'
			},
			{
				label = 'Рычать', 
				sound = 'npc/zombie/zombie_alert3.wav',
				text = '*рычит*'
			},
})

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_ZOMBIE})))