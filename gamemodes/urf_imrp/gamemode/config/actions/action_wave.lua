local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Помахать";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.ChatAliases = {
	"wave", "приветствовать", "помахать"
}

ACTION.Sequences = {
	"wave",
	"wave_close"
}

ACTION.SequenceCheck = {
	"wave",
	"wave_close"
}

if SERVER then
	function ACTION:onStart( ply )
		local anim = "wave";

		if math.random() < 0.5 then anim = "wave_close" end

		ply:SetEmoteActionSequences( anim, nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "wave", ACTION );