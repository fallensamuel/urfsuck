local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Сдаться";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.ChatAliases = {
	"cower", "surrender", "surr", "сдаться"
}

ACTION.SequenceCheck = {
	"crouch_panicked"
}

ACTION.Sequences = {
	"crouch_panicked",
}

if SERVER then
	function ACTION:onStart( ply )
		local sequences = self:GetAvalibleSequences(ply);

		if table.Count( sequences ) > 0 then
			ply:SetEmoteActionState( ACTION_STATE_STARTING );

			ply:SetEmoteActionSequences( table.Random(sequences), 0, function()
				ply:SetEmoteActionState( ACTION_STATE_RUNNING );
			end );
		end
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "cower", ACTION );