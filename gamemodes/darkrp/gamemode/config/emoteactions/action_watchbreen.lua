-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_watchbreen.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Геройская Поза";
ACTION.Desc = "";

ACTION.Sequences = {
	"d1_t01_BreakRoom_WatchBreen"
}


if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences( "d1_t01_BreakRoom_WatchBreen", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "watchbreen", ACTION );