-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\naemniki\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Наемник Чип - Наемники"

NPC.icon = "stalker/icons/merc_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_HITMANSOLO } 
end

function NPC:onStart(isGoTo)
	if !isGoTo then
	self:addText([[Подходя ближе, вы обратили внимание на мужчину в странном комбинезоне, в прочем, спустя мгновение к вам обратились:
-Чего тебе надо? Вали отсюда, пока цел.]])
	else
		self:addText([[-Ну?]])
	end
	/*self:addOption([[-Мужик, не кипишуй. Я же свой.]], function (question_menu)
		if !isGoTo then
			self:addText([[-Какой пароль?]])                

			self:addOption([[-Силет]], function()
				self:addGoTo([[-Неверно]], question_menu)
			end)

			self:addOption([[-Неверно]], function()
				self:addGoTo([[-Неверно]], question_menu)
			end)

			self:addOption([[-Гарда]], function()
				self:addGoTo([[-Неверно]], question_menu)
			end)
		
			self:addOption([[-Гибискус]], function()
				self:addGoTo([[-Неверно]], question_menu)
			end)

 			self:addOption([[-Фаргус]], function(question_menu2)
				if !isGoTo then
					self:addText([[-Верно, что тебе надо?]])
				else  
					self:addText([[-Давай быстрее]])
				end
			end)
		else
			self:addText([[-Нет у меня на тебя времени вали отсюда! Мужчина показательно дернул дулом автомата в вашу сторону]])
			self:addLeave([[-Все, уже ухожу! *Уйти* ]])
		end*/


		self:addOption([[*Выбор профессии* -Чип, полегче, я с информацией.]], function()
		rp.OpenEmployerMenu(FACTION_HITMANSOLO, nil, rp.cfg.ForceFaction)
		self:close()
	end)


	self:addOption([[-Расскажи больше о работе.]], function()
		self:addText([[-Сейчас курс такой: берем заказы, чисто их выполняем. Прилюдно никого не трогаем, на рожон не лезем, если попадёшься - убьют на месте, в прочем, если убежишь, потом никто ничего не докажет.]])
		self:addGoToStart([[-Ясно, еще...*Задать еще вопросы*]])
		self:addLeave([[-Спасибо за справку, я пошел. *Уйти*]])
	end)


	self:addOption([[-Чип, есть новости?]], function()
		self:addText([[Прокашлявшись, мужчина проговорил:
-Конкуренция сейчас большая. Работаем на пределе сил, но пока все не очень радужно, думаю, скоро будут переговоры между разными фракциями наемников, надеюсь, все будет успешно.]])
		self:addGoToStart([[-Вот как, думаю разберетесь... *Задать еще вопросы*]])
		self:addLeave([[-Справитесь, я уверен. Ладно, мне пора. *Уйти*]])
	end)
end