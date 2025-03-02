local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Облокотиться";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.ChatAliases = {
	"lean", "облокотиться", "прислониться"
}

ACTION.Sequences = {
	"lean_back", "plazaidle1", "plazaidle2"
}

if SERVER then
	function ACTION:onStart( ply )
		local sequences = self:GetAvalibleSequences(ply);

		if table.Count( sequences ) > 0 then
			ply:SetEmoteActionState( ACTION_STATE_STARTING );

			local traceLine = util.TraceLine( {
				start  = ply:EyePos(),
				endpos = ply:EyePos() + (ply:GetAngles():Forward() * -20),
				filter = ply
			} );

			if not traceLine.Hit then
				ply:Notify(NOTIFY_ERROR, "Вы должны позади стены." );
				ply:DropEmoteAction();
				return
			end

			ply:SetEmoteActionState( ACTION_STATE_RUNNING );

			ply:SetEmoteActionSequences( table.Random(sequences), 0 );
		end
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "lean", ACTION );