-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\infobarmen\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Информатор Шишак-Бармены"

NPC.icon = "stalker/icons/info_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_REFUGEES } 
end

function NPC:onStart(isGoTo)

	if !isGoTo then
		self:addText([[Подойдя к мужчине, тот молча на вас уставился, видимо ожидая каких-либо вопросов]])
	else  
		self:addText([[Поправив капюшон, Шишак продолжил смотреть на вас, ожидая следующего вопроса]])
	end

	self:addOption([[*Выбор профессии* -Я хочу переоформить торговую лицензию]], function()
		rp.OpenEmployerMenu(FACTION_REFUGEES, nil, rp.cfg.ForceFaction) self:close()
	end)

	self:addOption([[Напомни, какие у меня права как у торговца?]], function()
		self:addText([[Шишак очень тихо и сухо произнес:
-Платишь деньги за лицензию. Получаешь точку и возможность барыжить. Можешь сменить точку, можешь спонсировать фракции, дело твое. Продавай кому хочешь и что хочешь, ответственность полностью на тебе. Больше мне нечего сказать]])
		self:addGoToStart([[Ясно, а вот еще... *Задать еще вопросы*]], question_menu)
		self:addLeave([[Ясно, благодарю. *Уйти*]])
	end)

	/*
	self:addOption([[Как мне купить лицензию на торговлю?]], function()
		self:addText([[Шишак коротко и сухо ответил: -Платишь, получаешь лицензию. Если покупаешь в первый раз, нужно пройти проверку на доверие, все просто]])
		self:addOption([[ [Задания] Ясно, что за проверка?]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoToStart([[Хорошо, я хотел узнать...[Задать еще вопросы] ]], question_menu) 
	end)

	self:addOption([[Шишак, есть информация на продажу?]], function()
		self:addText([[Мужчина молча кивнул, и тихо проговорил: -Есть, что тебе интересно? ]])
	
	self:addOption(]][Продажа информации] Пожалуй вот что..]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на продажу информации
		self:close()
		self:addGoToStart([[Да, сей час вспомню. Пока узнаю...*Задать еще вопросы*]], question_menu)
		self:addLeave([[Черт, забыл. Ладно позже приду. [Уйти] ]])
	end)
	*/

	self:addOption([[Шишак, есть бесплатная информация?]], function()
		self:addText([[Прокашлявшись, информатор проговорил: -Говорят в логове мутантов есть много хорошего снаряжения, но вот где логово почти никто не знает]])
		self:addGoToStart([[Ясно, вот еще что... *Задать еще вопросы*]], question_menu)
		self:addLeave([[Понятно. Хорошо пойду я, удачи. *Уйти*]])
	end)
			
end
