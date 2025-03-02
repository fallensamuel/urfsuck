local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Сексисальто";
ACTION.Desc = "";
ACTION.Category = "Уникальные";


ACTION.Sequences = {
	"wos_fn_flipping_sexy"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences("wos_fn_flipping_sexy", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "sexy", ACTION );