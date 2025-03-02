NPC.name = "Собака"
function NPC:onStart(isGoTo)

	if !isGoTo then
		self:addText("Перед вами довольно крупная собака светло-жёлтого цвета. Чем-то по породе она напоминает корги, только, переростка.")
	end 

	self:addOption("Ты меня понимаешь?", function()
		
		self:addText("Гав гав!")
		
		self:addOption("Очень рад, что ты откровенен насчёт этого. А как тебя звать?", function()
				
			self:addText("Гав гав!")
				
			self:addOption("Очень приятно Тузик, а я ".. LocalPlayer():GetName(), function()
					
				self:addText("Гав гав!")
				
				self:addOption("Да-да, знаю. Тоже так думаю. Кстати, могу я задать тебе пару вопросов?", function(question_dog, isGoTo)
					
					if isGoTo then
						self:addText("Гав гав!")
					end

					self:addOption("Что ты знаешь об Альянсе?", function()
						
						self:addText("Гав гав! Рр-р-р...")
							
							self:addLeave('Я пожалуй пойду.')
							self:addGoTo("Хм... Очень интересно. Эх, вот если бы у меня была строчка в диалоге с \"НПС сопротивления\" рассказать обо всём этом. Но всё ровно спасибо!",question_dog)
						end)
						self:addOption("Как вступить в ГО?", function()
							
							self:addText("Гав гав! Гав-гав-гав!")
							
							self:addLeave('Я пожалуй пойду.') 
							self:addGoTo("Спасибо за совет. Обязательно попробую, как будет время. Это точно поможет мне пройти прямо без очереди!",question_dog)
						end)
						self:addOption("Как мне попасть в Д6?", function()
							
							self:addText("Гав гав..")
							
							self:addLeave('Я пожалуй пойду.')
							self:addGoTo("Хм... Ты прав, я же сейчас в нём и нахожусь.",question_dog) 
						end)
					end)
				end)
			end)

	end)



		self:addOption("Гав-гав!", function()
			
			self:addText("Гав гав!")
			
			self:addOption("Гав-гав.", function()
				
				self:addText("Гав гав!")
				
				self:addOption(" Гав-гав.", function()
					
					self:addText("Гав гав!")
						
						self:addGoToStart("Вы ощущаете, что провели довольно длительную дискуссию запаха анусов друг-друга. В следующий раз вы договорились обсудить цвет говна.")
					
					end)
				end)
			end)


	self:addLeave('Пока.')
end