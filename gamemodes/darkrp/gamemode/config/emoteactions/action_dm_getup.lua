-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_dm_getup.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "DM:GETUP:ANIMATION";
ACTION.Desc = "??";
ACTION.Category = "??";

ACTION.Sequences = {
	'wos_l4d_getup_from_pounced'
};

if SERVER then
	function ACTION:onCall(ply)
		return ply.DeathAction
	end

	function ACTION:onStart( ply )
		if (!ply.DeathAction) then return end
		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		ply:SetEmoteActionSequences( "wos_l4d_getup_from_pounced", 0, function()
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "dm_getup", ACTION );