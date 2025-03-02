-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_grovejam.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Грув";
ACTION.Desc = "";
ACTION.Category = "Уникальные";


ACTION.Sequences = {
	"wos_fn_groovejam"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences("wos_fn_groovejam", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "groove", ACTION );