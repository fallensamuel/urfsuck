-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\stalker\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Опытный сталкер Радон -Одиночки"

NPC.icon = "stalker/icons/loners_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_CITIZEN } 
end

function NPC:onStart(isGoTo)

	if !isGoTo then
		self:addText([[Когда вы подошли к сталкеру, тот неспешно сделал последнюю затяжку и ,выкинув окурок, предварительно затушив его о грунт, обратился к вам:
-О, кто к нам пожаловал. Чего хотел?]])
	else  
 		self:addText([[Ну что еще? Произнес Радон уставшим голосом.]])
	end
 
 	self:addOption([[*Выбор профессии* Радон, слышал у тебя новое снаряжение появилось? ]], function()
 		rp.OpenEmployerMenu(FACTION_CITIZEN, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы сталкеров
		self:close()
		end)
 
	self:addOption([[Слушай мужик, я тут недавно, расскажешь что тут к чему?]], function()
		self:addText([[По глазам и жестам сталкера было ясно, что вы не первый, кто задает ему такой вопрос. В прочем это не помешало ему ответить:
-Если в двух словах, все весьма непросто. Множество аномалий поджидающих тебя на каждом углу, монолитовцы свободно двигаются по городу, бандиты могут выскочить из любой подворотни, или просто словишь пулю от снайпера сидящего в доме. Тут есть обширная канализация. но и там не безопасно, много разных людей тут просто пропадают безвести,в общем точно не рай.]])
		self:addGoToStart([[Спасибо за справку, но вот еще... *Задать еще вопросы*]], dialog_menu)
		self:addLeave([[Ясно, что же и на этом спасибо и удачи. *Уйти*]])
		end)


	self:addOption([[Радон, а кто тут кроме сталкеров еще есть?]], function()
		self:addText([[Закурив еще одну сигарету, сталкер ответил:
- Да все те же, но к сожалению искать всех придется самому. В этом городе такие лабиринты, что как бы я тебе не объяснял, один черт не поймешь. Тем не менее, если держатся центральных улиц, то увидеть здания с логотипами группировок не составит труда. Некоторые группировки находятся в зданиях, и их очень трудно найти, но самый простой вариант, это поспрашивать на месте, авось и помогут. ]])
		self:addGoToStart([[Вот это полезная информация, но я хотел... *Задать еще вопросы*]], dialog_menu)
		self:addLeave([[Прекрасно, думаю мне это пригодится. Спасибо и удачи. *Уйти*]])
	end)
	

	self:addOption([[Радон а у тебя нет поручений для меня?]], function()
		self:addText([[Немного задумавшись, сталкер произнес:
Д-а, наверное, ты можешь мне кое в чем помочь. А ты сможешь?]])
		end)
	self:addOption([[ [Задания] Конечно, что там у тебя?.]], function()
		rp.OpenQuestMenu(NPC_UNKNOWN) // Добавить ссылку на квесты
 		self:close()
		self:addGoToStart([[Думаю смогу, но перед этим я хотел о спросить...[Задать еще вопросы] ]], dialog_menu)
		self:addLeave([[А что? Что-то опасное? Если так-то я, наверное, откажусь. [Уйти] ]])
	end)
 	
 
	self:addOption([[Радон, а есть чего интересного из новостей?]], function()
		self:addText([[Задумавшись, мужчина потер подбородок и задумчиво проговорил:
- Есть, слыхал я буд-то в городе есть страшная пространственная аномалия, мол как в нее попадешь, так считай все, пропал ты парень, хотя информатор, вроде как продавал информацию на этот счет, но она явно не дешевая.]])
		self:addGoToStart([[Ого, невероятно, но вот еще что... *Задать еще вопросы*]], dialog_menu)
		self:addLeave([[Вот как? Ну и на этом спасибо, а я уже пойду. *Уйти*]])
	end)
					
end