local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Полулёжа";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.Sequences = {
	"injured1"
}


if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences( "injured1", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "sitbutnotsit", ACTION );