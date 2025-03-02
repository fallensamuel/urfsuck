NPC.name = "Гражданин"
NPC.showName = false

function NPC:onStart(isGoTo)


	if LocalPlayer():GetFaction() == FACTION_OTA or LocalPlayer():GetFaction() == FACTION_COMBINE or LocalPlayer():GetFaction() == FACTION_DPF or LocalPlayer():GetFaction() == FACTION_HELIX then
	
		self:addText("*молча смотрит под ноги, стараясь не замечать Вас*")
		self:addLeave("*Оставить бедолагу в покое*")
		
		return
	elseif LocalPlayer():GetFaction() == FACTION_REBEL or LocalPlayer():GetFaction() == FACTION_REFUGEES or LocalPlayer():GetFaction() == FACTION_OVSP then
	
		self:addText("Это конечно не мое дело, но лучше тебе побыстрее убраться отсюда, пока ГОшники не заметили, что у тебя есть оружие!")
		self:addLeave("Пожалуй, ты прав...")

		return
	end



	self:addText("Что уставился? Проваливай!")

	self:addOption("А ты кто такой, что так разговариваешь со мной?!", function()
		
		self:addText("Какая тебе нахрен разница? У меня и без тебя проблем хватает, просто оставь меня...")
		
		self:addOption("Ладно, мужик, что случилось? Может я могу помочь?", function()
			
			self:addText("Нет, просто избавь меня от своего присудствия...")
				
			self:addLeave("Без проблем.")
		end)
   end)
end