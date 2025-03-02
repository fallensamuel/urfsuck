-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\mutant\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Контролер-Зомбированные"

NPC.icon = "stalker/icons/zombies_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_ZOMBIE } 
end

function NPC:onStart(isGoTo)
    
	if !isGoTo then
		self:addText([[Аккуратно двигаясь около руин, вы чувствуете сильную головную боль, и буквально через мгновение тьма покрывает ваше сознание.]])
	else  
		self:addText([[-Осталось немного, что же ты хочешь узнать?]])
	end

	self:addOption([[*Выбор профессии* -Я готов подчиниться.]], function()
		rp.OpenEmployerMenu(FACTION_ZOMBIE, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы мутантов
		self:close()
	end)

	self:addOption([[-Что? Где я? Что происходит?]], function()
		self:addText([[-Я беру тебя под контроль, твое тело уже покорилось моей воле, но этот маленький островок сознания еще сопротивляется. Еще немного, и ты будешь в моей власти.]])
		self:addGoToStart([[-Нет, НЕТ! Как же так... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Это все сон! Просто сон! *Уйти*]])
	end)

	/*
	self:addOption([[-Я, не понимаю.]], function()
		self:addText([[-Тебе и не нужно понимать, все уже решено за тебя. Ты будешь делать то, что я тебе прикажу, и ты не сможешь противится моей воле, еще немного, и последний оплот твоего сознания падет!
Вы слышите оглушающий гогот тысячи голосов.]])
		self:addOption([[ [Задания] Это невозможно!]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoToStart([[-Как же так? И на этом все?...[Задать еще вопросы] ]], question_menu) 
	end)

	self:addOption([[-Что ты хочешь от меня?]], function()
		self:addText([[С насмешкой множество голосов ответили: -Ты будешь делать то, что я хочу, ведь ты уже мой!]])
		self:addOption([[ [Задания] Мама, помоги мне.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()

		self:addGoToStart([[-Пока я могу еще говорить...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Это просто кошмар! Просто сон! [Уйти] ]])
	end)

	*/

	self:addOption([[-Повелитель, что я должен знать?]], function()
		self:addText([[Эхо голосов насмешливо проговорило:
-Все просто, моя кукла. Рви! Убивай! Потроши всех, кого увидишь! Защити своего господина!]])
		self:addGoToStart([[-Я обречен... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Нет, я на это не подписывался! *Уйти*]])
	end)
					
end