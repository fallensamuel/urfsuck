-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\nig\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Профессор Ф.А.Дунков -НИГ"

NPC.icon = "stalker/icons/scientis_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_ECOLOG } 
end

function NPC:onStart(isGoTo)
    
	if !isGoTo then
		self:addText([[Подойдя ко входу в бункер, на вас обратил внимание мужчина в научном костюме. Он неспешно потер ладони друг о друга, и из внешнего динамика скафандра послышался статный голос:
-Чем могу помочь?]])
	else  
		self:addText([[-Хорошо, что-то еще? Ответил профессор, речь которого была искажена помехами динамика.]])
	end

	self:addOption([[*Выбор профессии* -Здравствуйте, профессор! Я вернулся. Приступаю к работе.]], function()
		rp.OpenEmployerMenu(FACTION_ECOLOG, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы ученых
		self:close()
	end)


	self:addOption([[-Профессор, расскажите как тут живется НИГ?]], function()
		self:addText([[Вместо ответа, в начале послышался треск динамика, но вскоре все пришло в норму и послышался обычный голос Дункова:
- До чего делится? В целом я бы сказал мы чувствуем себя так же плохо, как и любые другие люди, что находятся тут. С образцами постоянно какие-то проблемы, специалистов толковых мало. Да и те постоянно гибнут на вылазках. Казалось бы, кому мы что сделали? Но нет, кто-нибудь да найдется, кто попытается нас поймать или прикончить. Мы всего лишь пытаемся изучить это место. Эти аномалии, артефакты, мутанты, да и множество других вещей - все это жизненно необходимо для общего дела, но, увы, мало кто это понимает.]])
		self:addGoToStart([[Я думаю, вы справитесь, и еще хотел... *Задать еще вопросы*]], question_menu)
		self:addLeave([[Не переживайте, все будет хорошо. К сожалению, мне пора. *Уйти*]])
	end)

	/*
	self:addOption([[-Профессор, у вас мало людей, может я смогу помочь?]], function()
		self:addText([[Профессор вновь поменял позу, и спустя несколько секунд помех послышался ответ:
-Хм, ну можно посмотреть на что ты годишься, если же ты и вправду что-то умеешь, твоя помощь нам будет весьма полезной.]])
		self:addOption([[ [Задания] Спасибо, профессор, я вас не подведу.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoToStart([[Профессор, а можно не сейчас? Я хотел узнать ...[Задать еще вопросы] ]], question_menu) 
	end)


	self:addOption([[-Профессор, может быть у вас есть работа для меня?]], function()
		self:addText([[Аккуратно подняв руку и постучав по внешнему динамику, послышался ответ профессора:
- Найдется, у меня есть пара дел которые я бы мог поручить тебе, если ты, конечно, готов.]])
                 
    self:addOption([[ [Задания] Да, разумеется готов.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()

		self:addGoToStart([[Да, готов, но хотел еще спросить?...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[Не совсем, тогда я зайду позже, удачи, профессор. [Уйти] ]])
	end)

	*/

	self:addOption([[-Профессор Дунков, а есть свежая информация об исследованиях Зоны?]], function()
		self:addText([[На этот раз динамик заработал исправно, и профессор проговорил:
-Ну в целом если брать то, что я могу не скрывать, то я расскажу вот о чем. В последнее время частота и сила выбросов увеличилась, думаю, ты и сам заметил. Как мы поняли, эти изменения происходят систематически, как будто кто-то их регулирует. Не знаю, в чем именно причина, но если виноваты те, о ком я думаю, то я бы на твоем месте вглубь Зоны сейчас не ходил, поверь, так будет безопаснее.]])
		self:addGoToStart([[Спасибо, полезная информация, но вот еще что... *Задать еще вопросы*]], question_menu)
		self:addLeave([[Очень интересно. Ладно, я пойду, до скорой встречи. *Уйти*]])
	end)

end
