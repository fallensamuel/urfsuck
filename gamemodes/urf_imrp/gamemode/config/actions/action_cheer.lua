local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Порадоваться";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.ChatAliases = {
	"cheer", "радость", "радоваться", "порадоваться"
}

ACTION.Sequences = {
	"cheer2"
}

ACTION.SequenceCheck = {
	"cheer2"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionSequences( "cheer2", nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "cheer", ACTION );