NPC.name = "Незнакомец"
NPC.showName = false

function NPC:onStart(isGoTo)

	self:addText("Иногда мне снится сыыыыыр!")
	surface.PlaySound("vo/npc/male01/question06.wav")

		
		self:addOption("Сыр? Да было бы неплохо... Даже не помню, какой он на вкус.", function()
		self:addText("Иногда мне снится сыыыыыр!")
		surface.PlaySound("vo/npc/male01/question06.wav")
		self:addLeave("Да - да, не трави душу... *Уйти*")
			
			self:addOption("Что? С тобой все в порядке? ", function()
			self:addText("Иногда мне снится сыыыыыр!")
			surface.PlaySound("vo/npc/male01/question06.wav")
			self:addLeave("Эм... я, пожалуй, пойду. *Удалиться*")
				
				self:addOption("Похоже, что ты слишком зациклен на этом чертовом сыре!", function()
				self:addText("Иногда мне снится сыыыыыр!")
				surface.PlaySound("vo/npc/male01/question06.wav")
				self:addLeave("Да ты совсем больной... *Уйти*")
	
			end)
		end)
   end)
end