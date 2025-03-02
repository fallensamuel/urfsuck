local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Показать на пол";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.Sequences = {
	"mapcircle"
}


if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionSequences( "mapcircle", nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "circle", ACTION );