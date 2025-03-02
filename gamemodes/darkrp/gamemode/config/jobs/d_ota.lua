-- Цвета
local ota_osnova_color = Color(58, 95, 205)
local ota_red_color = Color(139, 0, 0)
local ota_king_color = Color(147, 112, 250)

-- Спавны
local stasis_spawn = {
	rp_city17_alyx_urfim = {
		Vector(7425, 223, -64),
		Vector(7346, 223, -64),
		Vector(7194, 223, -64),
		Vector(7100, 223, -64),
		Vector(7425, 144, -64),
		Vector(7346, 144, -64),
		Vector(7194, 144, -64),
		Vector(7100, 144, -64),
	},
}

if SERVER then
    hook.Add("PlayerHasHunger", function(ply)
         if ply:GetJobTable().noHunger == true then return false end
    end)
end

local map = isC18 && 17 or 17

TEAM_STALKER = rp.addTeam("C"..map..".Stalker", { 
	color = ota_osnova_color, 
	model = {"models/player/zelpa/stalker.mdl"}, 
	description = [[
Техник-Слуга сверхчеловеческого патруля альянса.
Своим Лазером восполняет запас брони.

Прямые обязанности:
- Ремонтирование и пополнение запаса брони сотрудников Альянса;

Запрещается:
- Контактировать с гражданскими лицами;
- Самовольно отходить от отряда;

Особенности:
- Покупка раздатчика Брони;
- Покупка Брони;

В подчинении у OfС и выше, CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Средняя;
]], 
	weapons = {"weapon_stalker", "weapon_medkit"}, 
	command = "synth1", 
	armor = 150,
	spawns = stasis_spawn,
	medic = true,
	IsMedic = true,	
	RescueReward = 50,
	RescueFactions = {[FACTION_MPF] = true, [FACTION_HELIX] = true, [FACTION_OTA] = true, [FACTION_CMD] = true, [FACTION_GRID] = true},
	salary = 25, 
	max = 4,
	DmHealthTime = 2.5,
	noHunger = true, 
	forceLimit = true,
	faction = FACTION_OTA,
	PlayerSpawn = function(ply) ply:SetHealth(125) ply:SetMaxHealth(125) end,
	noHunger = true, 
	hpRegen = 2,
	rationCount = 1, 
	reversed = true,
	randomName = true,
	CantUseDisguise = true,
	CantBeMorphed = true,
	CantDeathmechanics = true,
	loyalty = 2,
	noReProgrammer = true,
	stamina = 9999,
})

TEAM_SWORDOWS = rp.addTeam("C"..map..".OTA.SWORD.Soldier", {
	color = ota_osnova_color,
	model = {"models/cultist/hl_a/vannila_combine/combine_soldier.mdl"},
	description = [[
Overwatch Transhuman Arm.SWORD.Soldier

Основная боевая единица сверхчеловеческого штурмового отряда SWORD.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Выполнение заданных командованием протоколов;

Запрещается:
- Покидать нексус без протокола;

В подчинении у CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
Отсутствует;

Лояльность Альянса: Высокая;
]],
	weapons = {"swb_ar2", "swb_shotgun", "weapon_frag", "door_ram", "weapon_taser", "weapon_cuff_elastic"},
	command = "sword_ows",
	spawns = stasis_spawn,
	salary = 30,
	noHunger = true,
	stamina = 9999,
	max = 6,
	armor = 250,
	faction = FACTION_OTA,
	hasLicense = true,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	rationCount = 4,
	forceLimit = true,
	unlockTime = 100 * 3600,
	unlockPrice = 50000,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	CantUseDisguise = true,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/cultist/hl_a/vannila_combine/combine_soldier.mdl",
          skins       = {0,1,2,3},
           bodygroups = {
                [1] = {0},
            			}
        },
    },	
})

TEAM_SWORDOWH = rp.addTeam("C"..map..".OTA.SWORD.Wallhammer", {
	color = ota_osnova_color,
	model = {"models/hlvr/characters/combine/heavy/combine_heavy_hlvr_player.mdl"},
	description = [[
Overwatch Transhuman Arm.SWORD.Wallhammer

Тяжелая боевая единица сверхчеловеческого штурмового отряда SWORD.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Выполнение заданных командованием протоколов;

Запрещается:
- Покидать нексус без протокола;

В подчинении у CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
Отсутствует;

Лояльность Альянса: Высокая;
]],
	weapons = {"swb_ar3", "tfa_heavyshotgun", "weapon_frag", "door_ram", "weapon_taser", "weapon_cuff_elastic"},
	command = "sword_owh",
	spawns = stasis_spawn,
	salary = 35,
	noHunger = true,
	stamina = 9999,
	max = 2,
	forceLimit = true,
	armor = 400,
	PlayerSpawn = function(ply) ply:SetWalkSpeed(150) ply:SetRunSpeed(250) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	unlockTime = 250 * 3600,
	unlockPrice = 125000,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	CantUseDisguise = true,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/hlvr/characters/combine/heavy/combine_heavy_hlvr_player.mdl",
        skins       = {0},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
                [12] = {0},
                [13] = {0},
                [14] = {0},
            			}
        },
    },	
})

TEAM_SWORDSUP = rp.addTeam("C"..map..".OTA.SWORD.Suppresor", {
	color = ota_osnova_color,
	model = {"models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl"},
	description = [[
Overwatch Transhuman Arm.SWORD.Suppresor

Тяжелая боевая единица сверхчеловеческого штурмового отряда SWORD.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Выполнение заданных командованием протоколов;

Запрещается:
- Покидать нексус без протокола;

В подчинении у CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
Отсутствует;

Лояльность Альянса: Высокая;
]],
	weapons = {"tfa_suppressor", "swb_shotgun", "weapon_frag", "door_ram", "weapon_taser", "weapon_cuff_elastic"},
	command = "sword_sup",
	spawns = stasis_spawn,
	salary = 35,
	noHunger = true,
	stamina = 9999,
	max = 2,
	forceLimit = true,
	armor = 400,
	PlayerSpawn = function(ply) ply:SetWalkSpeed(150) ply:SetRunSpeed(250) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	unlockTime = 250 * 3600,
	unlockPrice = 125000,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	CantUseDisguise = true,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl",
        skins       = {0},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
                [12] = {0},
                [13] = {0},
                [14] = {0},
            			}
        },
    },	
})

/*
TEAM_DISIN = rp.addTeam("C"..map..".OTA.Disinsection", {
	color = ota_red_color,
	model = {"models/hlvr/characters/combine/grunt/combine_grunt_hlvr_player.mdl"},
	description = [[
Overwatch Transhuman Arm.Disinsection

Дезинсектор сверхчеловеческого отряда.
Имеет доступ ко всем секторам. 
Может находится в зараженном секторе в одиночку, а также выходить с зоны карантина до Бункера Беженцев.

Прямые обязанности:
- Уничтожение флоры Зен в Городе и Зараженных;
- Выполнение заданных командованием протоколов;

В подчинении у CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Высокая;
]],
	weapons = {"tfa_psmg", "weapon_frag", "door_ram", "weapon_taser", "weapon_cuff_elastic"},
	command = "sword_dis",
	spawns = stasis_spawn,
	salary = 35,
	noHunger = true,
	stamina = 9999,
	max = 2,
	forceLimit = true,
	armor = 250,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetMaxHealth(150) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	unlockTime = 0,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantUseDisguise = true,
	CantDeathmechanics = true,
	noReProgrammer = true,
	unlockTime = 100 * 3600,
	unlockPrice = 75000,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/hlvr/characters/combine/grunt/combine_grunt_hlvr_player.mdl",
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
            			}
        },
    },	
})
*/
TEAM_GUARD = rp.addTeam("C"..map..".OTA.SWORD.Guard", {
	color = ota_red_color,
	model = {"models/ninja/combine/combine_soldier_player.mdl"},
	description = [[
Overwatch Transhuman Arm.SWORD.Guard

Защитная единица сверхчеловеческого штурмового отряда SWORD.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Охрана Важных лиц Альянса;
- Выполнение заданных командованием протоколов;

В подчинении у Администратора Города, CMD, OTA.KING.Ordinal, OTA.KING.Overlord; 
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
АВТОНОМ;

Лояльность Альянса: Высокая;
]],
	weapons = {"swb_ar2", "swb_shotgun", "riot_shield", "weapon_frag", "door_ram", "weapon_taser", "weapon_cuff_elastic"},
	command = "sword_guard",
	spawns = stasis_spawn,
	salary = 40,
	noHunger = true,
	stamina = 9999,
	max = 4,
	forceLimit = true,
	armor = 350,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	minUnlockTime =  50 * 3600,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	CantUseDisguise = true,
	noReProgrammer = true,
	unlockPrice = 50000,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/ninja/combine/combine_soldier_player.mdl",
        	skins       = {1},
            bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
            			}
        },
    },	
})

TEAM_KINGELS = rp.addTeam("C"..map..".OTA.KING.ElS", {
	color = ota_king_color,
	model = {"models/ninja/combine/combine_super_soldier_player.mdl"},
	description = [[
Overwatch Transhuman Arm.KING.Elite Soldier

Элитная боевая единица сверхчеловеческого командного отряда KING.

Старается передвигаться с Marshal'ом.

Имеет доступ ко всем секторам.

Прямые обязанности:
- Выполнение заданных командованием протоколов;

В подчинении SeC, OTA.KING.Overlord и OTA.СMD.Marshal;
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
АВТОНОМ;

Лояльность Альянса: Высокая;
]],
	weapons = {"heavy_shield", "swb_ar3", "swb_shotgun", "swb_357", "weapon_frag", "door_ram", "weapon_taser","weapon_cuff_elastic"},
	command = "king_els",
	spawns = stasis_spawn,
	salary = 45,
	noHunger = true,
	stamina = 9999,
	max = 2,
	armor = 350,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	forceLimit = true,
	unlockTime = 200 * 3600,
	minUnlockTime = 10 * 3600,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	noReProgrammer = true,
	CantUseDisguise = true,
	unlockPrice = 150000,
	loyalty = 3,
})

TEAM_SWORDOWC = rp.addTeam("C"..map..".OTA.KING.Ordinal", {
	color = ota_king_color,
	model = {"models/hlvr/characters/combine_captain/combine_captain_hlvr_player.mdl"},
	description = [[
Overwatch Transhuman Arm.KING.Ordinal

Офицер основного боевого сверхчеловеческого штурмового отряда KING.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Командование основным боевым сверхчеловеческим отрядом;
- Выполнение заданных командованием протоколов;
- Премирование и повышение ОТА;
- Вывод OTA из стазиса;

Особенности:
- Выдача премии сотрудникам ОТА;

В подчинении у SeC, OTA.KING.Overlord и OTA.СMD.Marshal; 
Командует Stalker, OTA.SWORD.Soldier, OTA.SWORD.Wallhammer, OTA.SWORD.Suppresor и OTA.SWORD.Guard;

Доступ к Нексус Надзору:
Полный Доступ;

Протокол при прибытии в Сити-17:
АВТОНОМ;

Лояльность Альянса: Высокая;
]],
	weapons = {"swb_ar3", "swb_shotgun", "swb_357", "weapon_frag", "door_ram", "weapon_taser","weapon_cuff_elastic"},
	command = "sword_owc",
	spawns = stasis_spawn,
	salary = 55,
	noHunger = true,
	stamina = 9999,
	max = 2,
	forceLimit = true,
	armor = 400,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	unlockTime =  300 * 3600,
	noHunger = true,
	reversed = true,
	randomName = true,
	CantDeathmechanics = true,
	CantUseDisguise = true,
	noReProgrammer = true,
	unlockPrice = 175000,
	loyalty = 3,
	appearance = 
	{
        {mdl = "models/hlvr/characters/combine_captain/combine_captain_hlvr_player.mdl",
        	skins       = {0},
           bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
            			}
        },
    },	
})

TEAM_KINGOVL = rp.addTeam("C"..map..".OTA.KING.Overlord", {
	color = ota_king_color,
	model = {"models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl"},
	description = [[
Overwatch Transhuman Arm.KING.Overlord
Командор сверхчеловеческих отделов Альянса.
Имеет доступ ко всем секторам.

Прямые обязанности:
- Командование всеми сверхчеловеческими отделами Альянса;
- Премирование и повышение ОТА;
- Изменения кода положения города, согласно регламенту;
- Надзор за работой Администратора Города;
- Вывод OTA из стазиса;

Особенности:
- Понижать в должности/выдавать премии сотрудникам ОТА;
- Регулирование положения в городе;

В подчинении у OTA.СMD.Marshal;
Командует всеми силами сверхчеловеческих отрядов Альянса, а также Администратором Города;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
]],
	weapons = {"swb_ar3", "swb_shotgun", "swb_357", "weapon_frag", "door_ram", "weapon_taser","weapon_cuff_elastic", "weapon_rpg"},
	command = "king_overlord",
	spawns = stasis_spawn,
	salary = 70,
	noHunger = true,
	stamina = 9999,
	max = 1,
	CanStartLockdown = true,
	armor = 450,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetMaxHealth(200) end,
	faction = FACTION_OTA,
	hasLicense = true,
	rationCount = 4,
	forceLimit = true,
	unlockTime = 400 * 3600,
	noHunger = true,
	reversed = true,
	CantDeathmechanics = true,
	randomName = true,
	CantUseDisguise = true,
	noReProgrammer = true,
	unlockPrice = 200000,
	loyalty = 4,
	appearance = {
        {
        	mdl = "models/cultist/hl_a/combine_suppresor/combine_suppresor.mdl",
        	skins       = {1},
        	bodygroups = {
                [1] = {0},
                [2] = {0},
                [3] = {0},
                [4] = {0},
                [5] = {0},
                [6] = {0},
                [7] = {0},
                [8] = {0},
                [9] = {0},
                [10] = {0},
                [11] = {0},
                [12] = {0},
                [13] = {0},
                [14] = {0},
            }
        },
    },	
})

-- Радио
rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_OTA, FACTION_CMD}, {TEAM_MAYOR1, TEAM_BLACKRIPPER}))

-- Двери
rp.AddDoorGroup('Альянс', rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}, {TEAM_SEC, TEAM_MAYOR1}))
rp.AddDoorGroup('ГСР', rp.GetFactionTeams({FACTION_CWU, FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID}))

-- Премирование, увольнение, повышение
rp.AddRelationships(TEAM_MAR, RANK_LEADER, {FACTION_MPF, FACTION_HELIX, FACTION_CMD, FACTION_GRID, FACTION_OTA})
rp.AddRelationships(TEAM_KINGOVL,  RANK_OFFICER, {FACTION_OTA})
rp.AddRelationships(TEAM_SWORDOWC, RANK_TRAINER, {FACTION_OTA})

--Чат
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_MPF, FACTION_HELIX, FACTION_OTA, FACTION_CMD, FACTION_GRID})))

rp.SetFactionVoices({FACTION_OTA}, {
            {
				label = 'Бунтарь', 
				sound = 'npc/combine_soldier/vo/boomer.wav',
				text = 'Бунтарь!'
			},
			{
				label = 'Чисто', 
				sound = 'npc/combine_soldier/vo/cleaned.wav',
				text = 'Чисто!'
			},
			{
				label = 'Заключение', 
				sound = 'npc/combine_soldier/vo/closing.wav',
				text = 'Заключить!'
			},
			{
				label = 'Контакт', 
				sound = 'npc/combine_soldier/vo/contact.wav',
				text = 'Есть контакт!'
			},
			{
				label = 'Задержать', 
				sound = 'npc/combine_soldier/vo/contained.wav',
				text = 'Задержать!'
			},
			{
				label = 'Повтори', 
				sound = 'npc/combine_soldier/vo/copythat.wav',
				text = 'Повтори!'
			},
			{
				label = 'В укрытие', 
				sound = 'npc/combine_soldier/vo/coverhurt.wav',
				text = 'Всем укрыться!'
			},
			
			{
				label = 'Врываемся', 
				sound = 'npc/combine_soldier/vo/dash.wav',
				text = 'Врываемся!'
			},
			{
				label = 'Подражатель', 
				sound = 'npc/combine_soldier/vo/echo.wav',
				text = 'Подражатель!'
			},
			{
				label = 'Очаровательно', 
				sound = 'npc/combine_soldier/vo/engaging.wav',
				text = 'Очаровательно!'
			},
			{
				label = 'Вспышка', 
				sound = 'npc/combine_soldier/vo/flash.wav',
				text = 'Вспышка!'
			},
			{
				label = 'Чисто', 
				sound = 'npc/combine_soldier/vo/flatline.wav',
				text = 'Можно идти!'
			},
			{
				label = 'Призрак', 
				sound = 'npc/combine_soldier/vo/ghost.wav',
				text = 'Призрак!'
			},
			{
				label = 'Сетка', 
				sound = 'npc/combine_soldier/vo/grid.wav',
				text = 'Тут сетка!'
			},
			{
				label = 'Медик', 
				sound = 'npc/combine_soldier/vo/helix.wav',
				text = 'МЕДИК!'
			},
			{
				label = 'Прибывший', 
				sound = 'npc/combine_soldier/vo/inbound.wav',
				text = 'Ей, прибывший!'
			},
			{
				label = 'Заражение', 
				sound = 'npc/combine_soldier/vo/infected.wav',
				text = 'Он заражен!'
			},
			{
				label = 'Юниты прибывают', 
				sound = 'npc/combine_soldier/vo/unitisinbound.wav',
				text = 'Юниты уже прибывают!'
			},
			{
				label = 'Юнит движется', 
				sound = 'npc/combine_soldier/vo/unitismovingin.wav',
				text = 'Юнит движется вперед!'
			},
			{
				label = 'Осуждение', 
				sound = 'npc/combine_soldier/vo/judge.wav',
				text = 'Осуждение!'
			},
			{
				label = 'Лидер', 
				sound = 'npc/combine_soldier/vo/leader.wav',
				text = 'Лидер!'
			},
			{
				label = 'Нет контакта', 
				sound = 'npc/combine_soldier/vo/lostcontact.wav',
				text = 'Контакт потерян!'
			},
			{
				label = 'Проходи', 
				sound = 'npc/combine_soldier/vo/movein.wav',
				text = 'Проходи!'
			},
			{
				label = 'Бродяга', 
				sound = 'npc/combine_soldier/vo/nomad.wav',
				text = 'Бродяга!'
			},
			{
				label = 'Взрыв', 
				sound = 'nnpc/combine_soldier/vo/outbreak.wav',
				text = 'Взрыв!'
			},
			{
				label = 'Возвращаемся', 
				sound = 'npc/combine_soldier/vo/payback.wav',
				text = 'Возвращаемся!'
			},
			{
				label = 'Фантом', 
				sound = 'npc/combine_soldier/vo/phantom.wav',
				text = 'Фантом!'
			},
			{
				label = 'Преследовать', 
				sound = 'npc/combine_soldier/vo/procecuting.wav',
				text = 'Преследуем его!'
			},
			{
				label = 'Ловушка', 
				sound = 'npc/combine_soldier/vo/quicksand.wav',
				text = 'Это ловушка!'
			},
			{
				label = 'Найти', 
				sound = 'npc/combine_soldier/vo/range.wav',
				text = 'Прочешите здесь все!'
			},
			{
				label = 'Приготовить взрывчатку', 
				sound = 'npc/combine_soldier/vo/readycharges.wav',
				text = 'Приготовить взрывчатку!'
			},
			{
				label = 'Приготовить оружие', 
				sound = 'npc/combine_soldier/vo/readyweapons.wav',
				text = 'Приготовить оружие!'
			},
			
			{
				label = 'Здесь чисто', 
				sound = 'npc/combine_soldier/vo/reportingclear.wav',
				text = 'Докладываю, здесь чисто!'
			},
			{
				label = 'Дикарь', 
				sound = 'npc/combine_soldier/vo/savage.wav',
				text = 'Дикарь!'
			},

			{
				label = 'Сектор не стерилен', 
				sound = 'npc/combine_soldier/vo/confirmsectornotsterile.wav',
				text = 'Сектор не стерилен!'
			},
			{
				label = 'Охрана Сектора', 
				sound = 'npc/combine_soldier/vo/sectorisnotsecure.wav',
				text = 'Сектор под охраной!'
			},
			{
				label = 'Охранять', 
				sound = 'npc/combine_soldier/vo/secure.wav',
				text = 'Охранять!'
			},
			{
				label = 'Опасная Зона', 
				sound = 'npc/combine_soldier/vo/sharpzone.wav',
				text = 'Здесь опасная зона!'
			},
			{
				label = 'Мина', 
				sound = 'npc/combine_soldier/vo/slam.wav',
				text = 'Здесь мина!'
			},
			{
				label = 'Стой', 
				sound = 'npc/combine_soldier/vo/standingby].wav',
				text = 'Стой на месте'
			},
			{
				label = 'Внимательнее', 
				sound = 'npc/combine_soldier/vo/stayalert.wav',
				text = 'Будь внимательнее!'
			},
			{
				label = 'Попал ', 
				sound = 'npc/combine_soldier/vo/striker.wav',
				text = 'Я попал!'
			},
			{
				label = 'Зачищаю', 
				sound = 'npc/combine_soldier/vo/sweepingin.wav',
				text = 'Зачищаю!'
			},
			{
				label = 'Быстрее', 
				sound = 'npc/combine_soldier/vo/swift.wav',
				text = 'Давай быстрее!'
			},
			
			{
				label = 'Займите Позиции', 
				sound = 'npc/combine_soldier/vo/stabilizationteamholding.wav',
				text = 'Группа захвата, займите позиции!'
			},
			{
				label = 'Маскировка', 
				sound = 'npc/combine_soldier/vo/uniform.wav',
				text = 'Это маскировка!'
			},
			{
				label = 'Наблюдаю', 
				sound = 'npc/combine_soldier/vo/visualonexogen.wav',
				text = 'Наблюдаю за обьектом!'
			},
			{
				label = 'Вот и все', 
				sound = 'npc/combine_soldier/vo/thatsitwrapitup.wav',
				text = 'Что ж, вот и все!'
			},
			{
				label = 'Код Меч', 
				sound = 'npc/combine_soldier/vo/sword.wav',
				text = 'Код : Меч!'
			},
			{
				label = 'Код Нова', 
				sound = 'npc/combine_soldier/vo/nova.wav',
				text = 'Код : Нова!'
			},
			{
				label = 'Код Нож', 
				sound = 'npc/combine_soldier/vo/stab.wav',
				text = 'Код : Нож'
			},
			{
				label = 'Код Зачистка', 
				sound = 'npc/combine_soldier/vo/sweeper.wav',
				text = 'Код : Зачистка!'
			},
			{
				label = 'Код Закат', 
				sound = 'npc/combine_soldier/vo/sundown.wav',
				text = 'Код : Закат!'
			},
			{
				label = 'Код Отсечь', 
				sound = 'npc/combine_soldier/vo/slash.wav',
				text = 'Код : Отсечь'
			},
			{
				label = 'Код Тень', 
				sound = 'npc/combine_soldier/vo/shadow.wav',
				text = 'Код : Тень!'
			},
			{
				label = 'Код Жнец', 
				sound = 'npc/combine_soldier/vo/reaper.wav',
				text = 'Код : Жнец!'
			},
			{
				label = 'Код Бритва', 
				sound = 'npc/combine_soldier/vo/razor.wav',
				text = 'Код : Бритва!'
			},
			{
				label = 'Код Булава', 
				sound = 'npc/combine_soldier/vo/mace.wav',
				text = 'Код : Булава!'
			},
			{
				label = 'Код Ураган', 
				sound = 'npc/combine_soldier/vo/hurricane.wav',
				text = 'Код : Ураган!'
			},
			{
				label = 'Код Молот', 
				sound = 'npc/combine_soldier/vo/hammer.wav',
				text = 'Код : Молот!'
			},
			{
				label = 'Код Кинжал', 
				sound = 'npc/combine_soldier/vo/dagger.wav',
				text = 'Код : Кинжал!'
			},
			{
				label = 'Код Антисептик',
				sound = 'npc/combine_soldier/vo/antiseptic.wav',
				text = 'Код : Антисептик!'
			},
			{
				label = 'Код Апекс', 
				sound = 'npc/combine_soldier/vo/apex.wav',
				text = 'Код : Апекс!'
			},
})

