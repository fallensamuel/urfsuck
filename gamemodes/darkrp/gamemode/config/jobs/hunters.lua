-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\hunters.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*local  hunters_spawns = {
rp_stalker_urfim_v3 = {Vector(-7388, -13069, -4134), Vector(-7381, -12932, -4134), Vector(-7374, -12796, -4134)},
rp_stalker_urfim = {Vector(-895, -11048, -384), Vector(-1052, -11048, -384), Vector(-962, -10979, -384)},
}

TEAM_EGER = rp.addTeam('Егерь', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/muravey/io7a_splint.mdl','models/stalkertnb2/sunrise_overwatch.mdl'},
	description = [[Ты костяк всех охотников. Ранее не раз попадался ментам за нерегламентированную охоту, 
	но нашёл себе приют в суровой, но богатой на разную дичь Чернобыльской Зоне Отчуждения. 
	Твой новый девиз "бывших браконьеров не бывает", 
	ведь где как не в Зоне ты сможешь реализовать свои профессиональные качества.

• Сбивайся в группы с другими такими же охотниками как и ты!
• Стреляй местную дичь, изучай повадки и уничтожай гнёзда!
• Предлагай свои услуги охотника разным людям, что заинтересованы в уничтожении мутантов!
• Местная фауна безжалостна — будь осторожен и не оставь свои кишки на ветках, кекс!
Контроль популяции мутантов и обогащение своего кошелька - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
Командуешь: никем.
Подчиняешься: Зверобою.
]],
	weapons = {"swb_ak74", "swb_winchester", "swb_fort_12", "detector_echo", "stalker_knife"},
	command = 'eger',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 250,
	unlockTime = 150 * 3600,
	unlockPrice = 125000,
	armor = 150,
	health = 120,
	speed = 1,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	max = 5,
	forceLimit = true,
	faction = FACTION_1HUNTERS,
})

TEAM_SLEDOPIT = rp.addTeam('Следопыт', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/stalkertnb2/sunrise_blitz.mdl','models/muravey/sunrise_ana.mdl','models/stalkertnb2/sunrise_red.mdl'},
	description = [[Опыт за спиной и пару шрамов напоминают тебе о том кто охотник, а кто жертва. 
	Пройдя со своими товарищами через огонь и воду обвыкся с законом естественного отбора в Зоне. 
	Поднатаскивать новичков в этом деле днём теперь стало твоим хобби, 
	в то время как ночью приходит время для настоящей охоты.

• Обучай желторотых и туристов премудростям охоты!
• Найди товарищей, что готовы прикрыть тебе спину!
• Предлагай свои услуги охотника разным людям, что заинтересованы в уничтожении мутантов!
Контроль популяции мутантов и обогащение своего кошелька - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
Командуешь: никем.
Подчиняешься: Зверобою.
]],
	weapons = {"swb_ak103", "swb_spas14", "swb_colt", "detector_echo", "stalker_knife"},
	command = 'sledopit',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 300,
	unlockTime = 250 * 3600,
	unlockPrice = 175000,
	armor = 250,
	health = 140,
	speed = 1,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	max = 3,
	forceLimit = true,
	faction = FACTION_1HUNTERS,
})

TEAM_RUBIK = rp.addTeam('Рубик', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/stalkertnb2/sunrise_zaku.mdl'},
	description = [[В прошлом хороший торговец на местном мясном рынке.
	Но настало время сокращения кадровых мест и тебе пришлось уйти во все тяжкие.
	Грабанув местный ларёк, тебе пришлось скрыться в ЧЗО.
	Вспомнив старые навыки торговли, подался к местным ребятам охотникам, которые тепло приняли тебя в своих кругах.
	К тому же ты мастерски можешь воровать чужие шмотки.

• Продавай своим и не только парням снарягу, чтобы они могли лучше охотиться.
• Помогай своим соратникам продвигаться выше.
• Обучай мастерству торговли.
Контроль популяции мутантов и обогащение своего кошелька - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
Командуешь: никем.
Подчиняешься: Зверобою.
]],
	weapons = {"swb_ak74_u", "swb_winchester", "swb_baretta_single", "detector_bear", "stalker_knife", "guitar_stalker", "pickpocket"},
	command = 'rubik',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 500,
	unlockTime = 350 * 3600,
	unlockPrice = 250000,
	armor = 150,
	health = 200,
	speed = 1,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	max = 1,
	faction = FACTION_1HUNTERS,
})

TEAM_ZVEROLOV = rp.addTeam('Зверолов', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/stalkertnb/cs3_nss.mdl','models/stalkertnb/rad_wolfie.mdl','models/stalkertnb2/sunrise_mccrae.mdl'},
	description = [[Ты - рассадник слухов и пример для подражания в одном лице. 
	Родом из суровых лесов Тайги. Количество баек про убитых тобой медведей голыми руками давным давно перевалило за сотню. 
	В зоне не место для смельчаков, но ты на своём примере доказал обратное, 
	ведь с таёжными условиями даже ЧЗО придётся побороться!

• Пользуйся своим авторитетом и поднимайся ещё выше!
• Организуй группу верных тебе людей и подготовь сторожку!
• Обезопась тропы как охотников, так и сталкеров!
Контроль популяции мутантов и обогащение своего кошелька - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
Командуешь: Следопыт и ниже.
Подчиняешься: Зверобою.
]],
	weapons = {"swb_ak74su_mod", "swb_uzi", "swb_p99", "detector_veles", "stalker_knife", "swb_spas14"},
	command = 'zverolov',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 600,
	unlockTime = 500 * 3600,
	unlockPrice = 300000,
	armor = 400,
	health = 180,
	speed = 1.15,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	max = 2,
	forceLimit = true,
	faction = FACTION_1HUNTERS,
})

TEAM_LESNIK = rp.addTeam('Лесник', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/legends/lesnik.mdl'},
	description = [[Старый лесник. Единственный выживший местный житель, 
	который отказался эвакуироваться ещё во время перовой аварии на ЧАЭС в 1986 году. 
	Решил присоединиться к группе Зверобоя, тем самым став его помощником.
	Имеешь способность чувствовать аномалии без электронных приборов. 

• Помогай новичкам охотникам осваиваться в Зоне.
• Помогай вольным сталкерам отбиваться от местной заразы Зоны.
• Помогай охотиться на опасных мутантов Зоны со своим багажом опыта.
• Можешь отречься от дел охотников и действовать, как вольный сталкер. 
Контроль популяции мутантов - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
]],
	weapons = {"swb_sten_kekler", "swb_p220", "stalker_knife", "swb_double_long_shotgun"},
	command = 'lesnik',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 400,
	unlockTime = 600 * 3600,
	armor = 350,
	health = 180,
	speed = 1.15,
	likeReactions = 25,
	arrivalMessage = true,
	anomaly_resistance = .75,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	vip = true,
	max = 1,
	faction = FACTION_1HUNTERS,
})

TEAM_ZVEROBOI = rp.addTeam('Зверобой', {
	color = Color(31, 79, 22),
	spawns = hunters_spawns,
	model ={'models/stalkertnb2/rad_mccrae.mdl'},
	description = [[Профессиональный охотник на мутантов.
	Непроивозойдённый авторитет для всех своих подопечных.
	Повидавший на своём пути немало мутантов Зоны.
	Являешься лидером местной группы охотников.

• Давай советы новичкам по охоте на опасных мутантов.
• Выдавай задания обычным сталкерм, которые также хотят стать профессиональным охотником.
• Оберегай своих людей и свою идеологию охотников от нечести Зоны.
Контроль популяции мутантов и обогащение своего кошелька - твоя первоочередная задача.

Это лишь малая часть из твоих ежедневных дел!
Командуешь: Зверолов и ниже.
Подчиняешься: никому.
]],
	weapons = {"swb_ots", "swb_deagle", "detector_veles", "stalker_knife", "swb_ks23m", "health_kit_bad"},
	command = 'zveroboi',
	spawns = hunters_spawns,
	spawn_points = {},
	salary = 800,
	unlockTime = 800 * 3600,
	armor = 550,
	health = 200,
	speed = 1.2,
	reversed = true,
	CantUseDisguise = true,
	disableDisguise=true,
	vip = true,
	max = 1,
	faction = FACTION_1HUNTERS,
})


rp.AddToRadioChannel(rp.GetFactionTeams({FACTION_1HUNTERS}))
rp.AddDoorGroup('Охотники', rp.GetFactionTeams({FACTION_1HUNTERS}))
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_1HUNTERS})))


*/