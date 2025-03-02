local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "DM:FALL:ANIMATION";
ACTION.Desc = "??";
ACTION.Category = "??";

ACTION.Sequences = {
	'incap_new'
};

function ACTION:onStartCommand(Player, Command)
	local Keys = {IN_JUMP, IN_USE, IN_RELOAD, IN_DUCK, IN_WALK, IN_SPRINT};

	for _, KEY_BITFLAG in pairs(Keys) do
		Command:RemoveKey(KEY_BITFLAG);
	end

	Command:ClearMovement();
end

if SERVER then
	function ACTION:onCall(ply)
		return ply.DeathAction
	end

	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences("incap_new", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );

		ply:SetEmoteActionSequences( "incap_new", nil, nil, function()
			ply:SetEmoteActionState( ACTION_STATE_ENDED );

			ply:DropEmoteAction();
		end );
	end
end

EmoteActions:RegisterAction( "dm_fall", ACTION );