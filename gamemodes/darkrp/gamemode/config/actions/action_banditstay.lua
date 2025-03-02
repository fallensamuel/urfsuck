local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Бандитская поза";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.Sequences = {
	"d1_t02_Playground_Cit2_Pockets"
}


if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences( "d1_t02_Playground_Cit2_Pockets", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "banditstay", ACTION );