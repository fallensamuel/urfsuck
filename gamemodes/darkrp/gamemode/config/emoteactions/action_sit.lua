-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_sit.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Сесть";
ACTION.Desc = "??";

ACTION.ChatAliases = {
	"sit", "сесть", "присесть"
}

ACTION.Sequences = {
	"idle_to_sit_ground",
	"sit_ground_to_idle"
}

ACTION.SequenceCheck = {
	"idle_to_sit_ground",
	"sit_ground_to_idle"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		ply:SetEmoteActionSequences( "idle_to_sit_ground", 0, function()
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );

		ply:SetEmoteActionSequences( "sit_ground_to_idle", nil, nil, function()
			ply:SetEmoteActionState( ACTION_STATE_ENDED );

			ply:DropEmoteAction();
		end );
	end
end

EmoteActions:RegisterAction( "sit", ACTION );