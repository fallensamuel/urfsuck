-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\terminal\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "Монолит";

function NPC:onStart( isGoTo )
	if LocalPlayer():Team() == TEAM_SUPERVISOR then
		self:addText( "Приветствую, дитя мое. Ты готов исполнить свое предназначение?" );

		self:addOption( "Да, о великий Монолит! *Слится с Монолитом*", function()
			self:send( "RequestSupervisor" );
			self:close();
		end );
		
		self:addOption( "Какова моя цель, о великий Монолит?", function(terminal_questions, isGoTo)
			self:addText(
				"Сын мой, ты призван мною, дабы помочь братьям своим в искоренении неверных!\n" ..
				"Я дам тебе силы видеть и слышать любого из твоих братьев.\n" ..
				"Помоги им, как сможешь! Кому советом, а кому и ценным даром!\n" ..
				"*Зажмите С для выбора действия*\n" ..
				"*Для переключения камеры нажмите Ctrl.*"
			);
			
			self:addGoToStart( "Я понял тебя, о велкий Монолит!." );
		end );
	else
 		self:addText( "*Монолит никак не реагирует на вас, лучше не трогать его...*" );
	end

	self:addLeave( "*Перестать бепокойть монолит*" );
end