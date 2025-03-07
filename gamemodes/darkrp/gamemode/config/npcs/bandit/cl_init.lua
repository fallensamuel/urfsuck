-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\bandit\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Прохаванный Язь-Бандиты"

NPC.icon = "models/stalkertnb/bandit_chav1.mdl"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_REBEL } 
end

function NPC:onStart(isGoTo)
	
	if !isGoTo then
		self:addText([[Подойдя ближе к бандиту, последний небрежно осмотрел вас и грубо проговорил: -Это что за цыпа к нам пожаловала?]])
	else  
		self:addText([[-Заманал, ну шо еще? *Ответил грубо бандит*]])
	end

	self:addOption([[ [Выбор профессии] -Э, братан ты ничего не попутал?.]], function()
		rp.OpenEmployerMenu(FACTION_REBEL, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы бандитов
		self:close()
	end)

	self:addOption([[-Как жиза у пацанов?]], function()
		self:addText([[-Да хер ли рассказывать? Рыбеха нынче крупная пошла, все ходют тут, бряцают хабаром как павлины, но бригада то местная не лохи какие-то, берем в оборот всех лохов в округе. Тех, кого наскоком не возьмешь, запоминаем и либо обходим шелупонь, либо эксплуатируем. Есть, конечно, и нормальные пацаны, но в основном вокруг сброд всякий, и эти вот вояки постоянно шманают, ну заманили уже.]])
		
		self:addGoToStart([[-Да ваще братан, но это вот еще...[Задать еще вопросы] ]])
		
		self:addLeave([[-Братан все будет пучком, а я поковылял, бывай. [Уйти] ]])
	end)
	
	/*
	self:addOption([[-Эй , а как к вам в бригаду вписаться?]], function()
	self:addText([[-Как как, раком к верху, работенку надо выполнить и показать, что ты не лох, а нормальный пацан.]])
					  self:addOption([[ [Задания] Ну и че там?]], function()
						   rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
							self:close()
					  end)
	self:addGoTo([[-Воу помедленней братан, это еще не все ...[Задать еще вопросы] ]], question_menu) 
	end)
	//
	self:addOption([[-Слухай, а нет какой работы не пыльной?", function()
	self:addText([[Сделав глубокую затяжку Язь ответил:
					-Для тя то? Ну может и найдется, если труханы не покрасишь в коричневый, ха.]])
					  self:addOption([[ [Задания] Не ломайся, че там есть? ]], function()
						   rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
							self:close()
	self:addGoTo([[Эй, ты не перегибай, но вот еще что...[Задать еще вопросы] ]], question_menu)
	self:addLeave([[Да пошел ты, потом перетрем. [Уйти] ]])   
	end)
	*/
	
	self:addOption([[-Язь, инфа есть?]], function()
		self:addText([[Да во прикинь какой случай. Шли мы тут недавно с пацанами лохов стопить. Видим, идет фраер один с крутым хабаром прямо по дороге, не боится никого. Ну мы c пацанами попрятались, ждем-с значит. Этот все идет, волынами светит, и одна шестерка, мать ее, вылезает с трунькой наперевес и тыкает в лоха, мол, "стой, пристрелю." Ох зря, лох то прошаренный оказался, сразу без слов среагировал и положил пацана. Ну мы и труханули, разбежались кто куда, потом от пахана таких пистонов получили аж, вспоминать не хочу.]])
		
		self:addGoToStart([[Братан, ну не первый и не последний лох...[Задать еще вопросы] ]])
		
		self:addLeave([[Ниче се, борзые лохи пошли, ладно погнал я.[Уйти] ]])
	end)
	//
				
end