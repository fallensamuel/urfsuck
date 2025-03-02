-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_electroshuffle.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Шафл";
ACTION.Desc = "";
ACTION.Category = "Уникальные";


ACTION.Sequences = {
	"wos_fn_electroshuffle"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences("wos_fn_electroshuffle", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "electroshuffle", ACTION );