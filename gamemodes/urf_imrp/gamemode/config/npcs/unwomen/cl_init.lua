NPC.name = "Незнакомка"
NPC.showName = false

function NPC:onStart(isGoTo)

	if LocalPlayer():GetFaction() == FACTION_OTA or LocalPlayer():GetFaction() == FACTION_COMBINE or LocalPlayer():GetFaction() == FACTION_DPF or LocalPlayer():GetFaction() == FACTION_HELIX then
	
		self:addText("*молча смотрит под ноги, стараясь не замечать Вас*")
		self:addLeave("*Оставить бедолагу в покое*")
		return
	end

	self:addText("Кроме Вас на поезде никого не было?")
	self:playSound("vo/trainyard/cit_fence_onlyones.wav")
		
		self:addOption("Я не заметил. Кого то ищите?", function()
		self:addText("Патруль остановил наш поезд в лесу, и моего мужа увезли на допрос. Они сказали, что он приедет на следующем поезде. Не знаю, когда это было. Хорошо, что они разрешили мне его подождать.")
		self:playSound("vo/trainyard/cit_fence_woods.wav")
		self:addLeave("Простите, я спешу. *Уйти*")
			
			self:addOption("Мне кажется, что вы его уже не дождетесь. Такие редко возвращаются...", function()
			self:addText("Нет, не верю! Не смейте так говорить! Он приедет, я дождусь его!")
			self:addLeave("Поступайте как считаете нужным... *удалиться*")
	

		end)
   end)
end