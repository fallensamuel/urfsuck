-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\clearsky\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Ученый Мидлл-Чистое Небо"

NPC.icon = "stalker/icons/clearsky_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_NEBO } 
end

function NPC:onStart(isGoTo)
   
	if !isGoTo then
		self:addText([[Наконец пробравшись через болота и выбравшись на твердую почву, вы замечаете, что за вами пристально наблюдает мужчина в хорошем защитном костюме.
-Надо же, не утонул в болоте то. Молодец. Ну и зачем ты пожаловал?]])
	else  
		self:addText([[-Да? Что еще ты хочешь узнать? Проговорил мужчина, немного поменяв позу и облокотившись на стену позади себя.]])
	end

	self:addOption([[ [Выбор профессии] -Не утонул, потому что свой, наливай.]], function()
		rp.OpenEmployerMenu(FACTION_NEBO, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы чистого неба
	end)

	self:addOption([[-Кто вы и чем занимаетесь?]], function()
		self:addText([[-Ну что же, раз ты добрался сюда живым, ты имеешь право кое-что знать. Меня Мидлл кличут. Наша группировка называется Чистое Небо и мы, можно сказать, ученые. Да, понимаю, сразу так не скажешь, но в отличии от тех, кто тут работает официально, мы можем позволить себе изучать то, что считаем наиболее важным, а не то, что прикажет правительство. Многие из тех, кто раньше работал на государство, присоединились к нам. А другие люди, которые считают, что наше дело правое, помогают нам в охране и делают другую работу, на которую не способны здешние пытливые умы, к примеру, достают редкие артефакты или приносят редкие части мутантов.]])
		self:addGoToStart([[-Чистое Небо? Тогда вот еще вопрос...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Ох, ошибся адресом, тогда пойду я. Спасибо. [Уйти] ]])
	end)

/*
	self:addOption([[-А как к вам можно попасть?]], function()
		self:addText([[-На самом деле, не то чтобы это было очень сложно, дойдя сюда ты по факту уже показал, что на кое-что способен. Давай так выполнишь мое поручение, а там посмотрим, хорошо?]])
		
	self:addOption([[ [Задания] Ладно, о чем речь?]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoTo([[-Хорошо, но потом, я еще не все узнал...[Задать еще вопросы] ]], question_menu) 
	end)

	self:addOption([[-Мидлл, а нет работы на фриланс?]], function()
		self:addText([[Поправив свой шлем, и скрестив руки на груди, мужчина ответил: -Да, найдется конечно. Все зависит от твоих сил и способностей, но у меня есть пару вариантов. Готов?]])
		
	self:addOption([[ [Задания] Я внимательно слушаю.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
		self:addGoTo([[-Не со всем, можно вот еще...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Пока нет, я приду позже ладно? Удачи. [Уйти] ]])
	end)
*/

	self:addOption([[-Мидлл, расскажи новости последние.]], function()
		self:addText([[Поменяв в очередной раз позу, ученый заговорил:
-Был тут интересный случай. Притащили, значит, разведчики кровососа. Да не простого, а с желтой шкурой. Долго мы в нем ковырялись, пытались разобраться, что могло повлиять на цвет шкуры. В конце концов остановились на трех вариантах. Первое, это спонтанная мутация и это аналог альбинизма. Второе, это приобретенный камуфляж, т.к. место его обитания было в основном желтых оттенков. Третье, кто-то на него помочился, когда он был серьезно ранен, и цвет кожи поменялся, адаптируясь под это. Смех смехом, но и такое могло быть.]])
		self:addGoToStart([[-Забавно и интересно, но вот еще...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Забавно, забавно, но мне пора, я пойду. [Уйти] ]])
	end)
					
end