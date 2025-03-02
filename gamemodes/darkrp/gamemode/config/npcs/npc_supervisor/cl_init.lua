-- "gamemodes\\darkrp\\gamemode\\config\\npcs\\npc_supervisor\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
NPC.name = "npc_supervisor";

function NPC:onStart( isGoTo )
	if LocalPlayer():Team() == TEAM_SUPERVISOR then
		self:addText( "о дарова братишка" );

		self:addOption( "*Начать работу*", function()
			self:send( "RequestSupervisor" );
			self:close();
		end );
	else
 		self:addText( "чее ебана я тебя не знаю шелупонь" );
	end

	self:addLeave( "*Уйти*" );
end