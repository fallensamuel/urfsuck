-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\monolit\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Инквизитор-Монолит"

NPC.icon = "stalker/icons/monolith_logo.png"
NPC.iconDistance = 5000
NPC.Factions = function() return 
	{ FACTION_MONOLITH } 
end

function NPC:onStart(isGoTo) 

	if !isGoTo then
		self:addText([[Идя на вылазку, ты попал под пси-воздействие. Сознание покинуло тебя, и ты услышал зов. -Иди ко мне, ты получишь то, что заслуживаешь!]])
	else  
		self:addText([[-Спрашивай, сын мой. Ответил голос, разносящийся эхом.]])
	end

	self:addOption([[*Выбор профессии* -Дай мне власть над миром!]], function()
		rp.OpenEmployerMenu(FACTION_MONOLITH, nil, rp.cfg.ForceFaction) //Нужно сменить ссылку на выбор профы монолита
		self:close()
	end)

	self:addOption([[-Кто тут? Кто ты? Ты - Монолит?]], function()
		self:addText([[-И да и нет. Мы - есть Монолит, мы те, кто несет его слово в Зоне, мы - пастыри безвольного скота, мы несём слово и волю его, для всех, а те, кто не верят или не чтут его власть будут уничтожены нашей мощью!]])
		self:addGoToStart([[-Монолит? Мы?... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Дурость какая, я просто сплю, да? *Уйти*]])
	end)

	/*

	self:addOption([[-Я... Как мне стать одним и вас?]], function()
		self:addText([[-Ты уже в наших рядах, брат, и чтобы монолит принял тебя, исполни его волю!]])
		self:addOption([[ [Задания] Как скажешь, о великий.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()
	end)

	self:addGoToStart([[-Это просто бред, я обкурился?...[Задать еще вопросы] ]], question_menu) 
	end)

	self:addOption([[-Чего хочет Монолит?]], function()
		self:addText([[Голос, разносящийся эхом в вашем сознании, ответил: -Всего, но ты лишь часть нас, поэтому делай то, что принесет плоды. Воля Монолита -  это наша воля брат!]])
		self:addOption([[ [Задания] Я трепетаю пред его мощью.]], function()
		rp.OpenQuestMenu(NPC_WHITE) // Добавить ссылку на квесты
		self:close()

		self:addGoToStart([[-Я так ослаб...[Задать еще вопросы] ]], question_menu)
		self:addLeave([[-Нет, мне точно надо меньше пить. [Уйти] ]])
	end)

	*/
	self:addOption([[-Какова воля Монолита?]], function()
		self:addText([[Эхо в вашей голове разилось словно колыбель, что напевала ваша мать.
-Пасти стадо, а заблудшим показать истину! Уничтожить врагов Монолита! Распространить его власть над всем миром!]])
		self:addGoToStart([[-Еще, я хочу знать еще... *Задать еще вопросы*]], question_menu)
		self:addLeave([[-Я просто сплю, проснись! *Уйти*]])
	end)
				
end