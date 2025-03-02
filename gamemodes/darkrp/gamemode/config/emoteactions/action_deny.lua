-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_deny.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Отказаться";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"deny", "отказ", "отказаться"
}

ACTION.Sequences = {
	"harassfront2"
}

ACTION.SequenceCheck = {
	"harassfront2"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		
		ply:SetEmoteActionSequences( "harassfront2", nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "deny", ACTION );