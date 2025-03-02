-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_stashing.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction("__base") );

ACTION.Name      = "STASHING:LOOP";
ACTION.Desc      = "??";
ACTION.Category  = "??";
ACTION.Sequences = { "pickup" };

function ACTION:onStartCommand( ply, cmd )
	local keys = { IN_JUMP, IN_USE, IN_RELOAD, IN_DUCK, IN_WALK, IN_SPRINT };

	for _, KEY_BITFLAG in pairs( keys ) do
		cmd:RemoveKey( KEY_BITFLAG );
	end

	cmd:ClearMovement();
end

if SERVER then
	function ACTION:onCall( ply )
        if not rp.Stashing then return false; end
		return rp.Stashing:IsActiveChallenge( ply );
	end

	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences( "pickup", 0 );
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );

		ply:SetEmoteActionSequences( "pickup", nil, nil, function()
			ply:SetEmoteActionState( ACTION_STATE_ENDED );
		end );
	end
end

EmoteActions:RegisterAction( "stashing_loop", ACTION );