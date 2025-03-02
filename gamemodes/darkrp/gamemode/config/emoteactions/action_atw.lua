-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_atw.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Руки на стену";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"atw"
}

ACTION.Sequences = {
	"apcarrestidle",
}

ACTION.SequenceCheck = {
	"apcarrestidle",
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		local traceLine = util.TraceLine( {
			start  = ply:EyePos(),
			endpos = ply:EyePos() + (ply:GetAngles():Forward() * 18),
			filter = ply
		} );

		if not traceLine.Hit then
			ply:Notify(NOTIFY_ERROR, "Вы должны смотреть на стену." );
			ply:DropEmoteAction();
			return
		end

		--if math.random() < 0.5 then ..???? chto
			ply.__emoteaction_lastpos = ply:GetPos();

			ply:SetPos(ply:GetPos() + (ply:GetAngles():Forward() * -24));
			ply:SetEmoteActionSequences( "apcarrestidle", 0 );
		--end

		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onRun( ply )
		if ply.__emoteaction_lastpos then
			if ply.__emoteaction_lastpos:Distance( ply:GetPos() ) > 64 then
				ply.__emoteaction_lastpos = ply:GetPos();
			end
		end
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );

		ply:SetPos( ply.__emoteaction_lastpos );

		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "atw", ACTION );