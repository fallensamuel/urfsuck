local citizens_color = Color(150, 170, 200)
local citizens_loal = Color(115, 146, 255)

local cit_models = {
'models/teslacloud/citizens/male01.mdl',
'models/teslacloud/citizens/male02.mdl',
'models/teslacloud/citizens/male04.mdl',
'models/teslacloud/citizens/male07.mdl',
'models/teslacloud/citizens/male09.mdl',
'models/teslacloud/citizens/male10.mdl'}

rp.addTeam('C17.Неопознанное лицо', {
	color = citizens_color,
	model = cit_models,
	description = [[Человек, только прибывший в город.
Вы не помните откуда вы и как оказались на вокзале.

Лояльность ГО: Низкая
	]],
	command = 'unknowcitizen',
	salary = 3,
	speed = 0.8,
	faction = FACTION_CITIZEN,
	rationCount = 1,
	loyalty = 1,
	reversed = true,
	canUseHire = true,
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,6},
                [2] = {0},
                [3] = {0},
                [4] = {0},
            			}
        },
    },
})

rp.addTeam('С17.Гражданин', {
	color = citizens_color,
	model = cit_models,
	description = [[Обычный человек, прошедший идентификацию личности и стал полноправным гражданином Альянса.

Лояльность ГО: Низкая]],
	weapons = {},
	command = 'citizen',
	salary = 4,
	speed = 0.8,
	faction = FACTION_CITIZEN,
	rationCount = 1,
	unlockTime = 0.5 * 3600,
	loyalty = 1,
	reversed = true,
	canUseHire = true,
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,6},
                [2] = {0},
                [3] = {0},
                [4] = {0},
            			}
        },
    },	
})

TEAM_GOODCIT = rp.addTeam('С17.Добропорядочный Гражданин', {
	color = citizens_color,
	model = cit_models,
	description = [[Гражданин, не замеченный в совершении преступлений.

Вам положено:
- Получение 1 дополнительного рациона;

Лояльность ГО: Средняя
]],
	weapons = {},
	command = 'goodcitizen',
	salary = 5,
	speed = 0.8,
	faction = FACTION_CITIZEN,
	rationCount = 2,
	unlockTime = 6 * 3600,
	loyalty = 2,
	reversed = true,
	canUseHire = true,
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,6},
                [2] = {0},
                [3] = {0},
                [4] = {0},
            			}
        },
    },	
})

TEAM_DOVER = rp.addTeam('С17.Доверенный Гражданин', {
	color = citizens_color,
	model = cit_models,
	description = [[Гражданин, проживший год в назначеном городе без нарушений, благодаря чему получил статус - доверенный.

Вам положено:
- Получение 1 дополнительного рациона;

Лояльность ГО: Средняя]],
	weapons = {},
	command = 'dovercitizen',
	salary = 6,
	faction = FACTION_CITIZEN,
	rationCount = 2,
	speed = 0.8,
	unlockTime = 50 * 3600,
	loyalty = 2,
	reversed = true,
	canUseHire = true,
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,6},
                [2] = {0},
                [3] = {0},
                [4] = {0},
            			}
        },
    },
})

TEAM_POCHET = rp.addTeam('С17.Почетный гражданин', {
	color = citizens_color,
	model = cit_models,
	description = [[Примерный гражданин, живущий в городе назначения уже не один год, верно служа Альянсу.

Вам положено:
- Получание 2 дополнительных рационов;

Лояльность ГО: Средняя]],
	weapons = {},
	command = 'pochetcitizen',
	salary = 8,
	faction = FACTION_CITIZEN,
	speed = 0.8,
	rationCount = 3,
	unlockTime = 120 * 3600,
	unlockPrice = 5000,
	loyalty = 2,
	reversed = true,
	canUseHire = true,	
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,6},
                [2] = {0},
                [3] = {0},
                [4] = {0},
            			}
        },
    },
})

TEAM_LOYAL = rp.addTeam('С17.Лоялист', {
	color = citizens_loal,
	model = cit_models,
	description = [[Гражданин, доказавший свою полную преданность Альянсу, тем самым удостоился звания Лоялиста.

Лоялисты имеют особые привелегии, такие как:
- Доступ к Холлу Нексус Надзора;
- Получение рациона в любое время;
- Получение 3 дополнительных рациона;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

Лояльность ГО: Высокая]],
	weapons = {},
	command = 'loyalcitizen',
	salary = 11,
	faction = FACTION_CITIZEN,
	rationCount = 4,
	speed = 0.8,
	unlockTime = 350 * 3600,
	unlockPrice = 7500,
	disableDisguise = true,
	canUseHire = true,	
	loyalty = 3,
	reversed = true,
	CantUseDisguise = true,
	appearance = 
	{
        {mdl = cit_models,
          skins       = {0,1,2,3,4},
           bodygroups = {
                [1] = {0,2,3,6},
                [2] = {7,8},
                [3] = {2,3},
                [4] = {0,1,2},
            			}
        },
    },	
})

TEAM_REFERENT = rp.addTeam('С17.Референт Администрации', {
	color = citizens_loal,
	model = {
	'models/teslacloud/cityadmin/male09.mdl',
	'models/teslacloud/cityadmin/male07.mdl',
	'models/teslacloud/cityadmin/male04.mdl',
	'models/teslacloud/cityadmin/male02.mdl',
	'models/teslacloud/cityadmin/male01.mdl',
	'models/teslacloud/cityadmin/female01.mdl',
	'models/teslacloud/cityadmin/female02.mdl',
},
	description = [[Гражданин, приближенный к Администрации Города.

Референты Администрации имеют особые привелегии, такие как:
- Полный доступ к Нексус Надзору, кроме тюремного блока, крыла А и Штаба CMD;
- Получение рациона в любое время;
- Референт Администрации может запросить себе в охрану юнита Гражданской Обороны, звания 05/03.
- Получение 4 дополнительных рациона;

Запрещается:
- Участвовать в действиях против Альянса;
- Помогать Анти Коллаборационистам;

Лояльность ГО: Высокая]],
	command = 'bestcitizen',
	salary = 13,
	faction = FACTION_CITIZEN,
	appearance = 
	{
		{mdl = {
	'models/teslacloud/cityadmin/male09.mdl',
	'models/teslacloud/cityadmin/male07.mdl',
	'models/teslacloud/cityadmin/male04.mdl',
	'models/teslacloud/cityadmin/male02.mdl',
	'models/teslacloud/cityadmin/male01.mdl',
	'models/teslacloud/cityadmin/female01.mdl',
	'models/teslacloud/cityadmin/female02.mdl',
},
	bodygroups = {
			[1] = {1,2,3,4,5,6,7,8},
			[2] = {0,1,2,3,4,5},

			}
		},
	},	
	rationCount = 5,
	speed = 0.8,
	unlockTime = 500 * 3600,
	unlockPrice = 15500,
	canUseHire = true, 
	loyalty = 3,
	disableDisguise = true,	
	reversed = true,
	CantUseDisguise = true,
})

local NotAllowed = {
    [TEAM_GOODCIT]   = true,
    [TEAM_DOVER]     = true,
    [TEAM_POCHET]    = true,
    [TEAM_LOYAL]     = true,
    [TEAM_REFERENT]  = true
}

function PLAYER:CanCapture()
    return not NotAllowed[self:Team()]
end