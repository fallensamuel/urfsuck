-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\provodniktwo\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Проводник Одиночек"

function NPC:onStart(isGoTo)

	if LocalPlayer():GetFaction() == FACTION_ZOMBIE1 then
	
		self:addText("При виде вас принял боевую готовность...")	
		self:addOption("[Уйти]", function()
			self:close()
		end)

		return
	end

    self:addText("*Перед вами проводник Одиночек*")
    self:addText("Здравствуй, уже 2-ий год зону топчу, могу провести в любую точку. За плату естественно")
    	self:addLeave('[Я передумал]')
    	self:addOption("Я бы хотел пройтись по зоне, есть места куда можешь провести?", function()
    		self:addText("Куда направимся?")
			self:addOption("Проведи к...", function()
    			rp.OpenTeleportMenu({SPAWN_CH, SPAWN_MONOL, SPAWN_BAND, SPAWN_DOLG, SPAWN_RENEG, SPAWN_SVOBOD, SPAWN_GAVAEC, SPAWN_DERNO, SPAWN_JEWUSI})
				self:close()
			end)
		end)

end