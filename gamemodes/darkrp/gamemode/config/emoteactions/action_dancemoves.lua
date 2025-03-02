-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_dancemoves.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Время Тёрка";
ACTION.Desc = "";
ACTION.Category = "Уникальные";


ACTION.Sequences = {
	"wos_fn_dancemoves"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences("wos_fn_dancemoves", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "dancemoves", ACTION );