-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\renegati\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Мародер Донжуан-Ренегаты"

NPC.icon = "stalker/icons/renegats_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_RENEGADES } 
end

function NPC:onStart(isGoTo)

	if !isGoTo then
		self:addText([[Подойдя ближе к бандиту, вы сильно удивились его экипировке, которая сильно отличалась от обычной. Мужчина обратил на вас свое внимание.
-Э слыш, ты кто такой? Пулю что ли хочешь получить? Вали от сюда.]])
	else  
		self:addText([[-Мля, не тормози, спрашивай быстрее. Сказал Донжуан, нервно оглядываясь.]])
	end

	self:addOption([[*Выбор профессии* -Донжуан, ты чего, я же свой.]], function()
		rp.OpenEmployerMenu(FACTION_RENEGADES, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы ренегатов
		self:close()
	end)

	self:addOption([[-Ты же не бандит, так? Кто ты?]], function()
		self:addText([[-Ха, ну ты, видимо, тот еще лох. Мародер я, предатель, отброс, мусор. Таких, как я и других предателей называют ренегатами. Нам некуда податься, некуда идти, вот и держимся в месте, а тебе то что? Что-то разнюхиваешь, а?]])
		self:addGoToStart([[-Не совсем, дело в чем... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Нет, я все понял, уже ухожу. *Уйти*]])
	end)
	/*

	self:addOption([[-Понимаешь, я тоже сбежал, как к вам влится?]], function()
		self:addText([[-Не, ну ты в натуре тупой, докажи, что ты не охотник и все дела, не то, чтобы мы все тут братья, скорее, каждый сам по себе.]])
		self:addOption([[ [Задания] И что надо сделать?]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoToStart([[-Ясно, но вот еще...[Задать еще вопросы] ]], question_menu) 
	end)

	self:addOption([[-Донжуан, нет работы?]], function()
		self:addText([[Мужчина нервно сплюнул и ответил:
-Борзый ты, ну да ладно, работа и вправду есть, но ты осилишь ее? Выглядишь, как хлюпик.]])
		
	self:addOption([[ [Задания] Сделаю, что у тебя?]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
		self:addGoToStart([[-За языком следи, вот еще что...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Может ты и прав, пойду я. [Уйти] ]])
	end)

	*/

	self:addOption([[-Новости есть?]], function()
		self:addText([[Мужчина саркастично ответил: -Мля, не поверишь, приперся тут один хлопец и спрашивает такой, Донжуан, у тебя новости есть? Ты что? Реально дебил? Я тебе информ бюро? Отвали.]])
		self:addGoToStart([[-Прости, затупил, знаешь что?... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Ясно, не кипятись. Пошел я. *Уйти*]])
	end)
				
end