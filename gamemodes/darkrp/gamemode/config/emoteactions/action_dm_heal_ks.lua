-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_dm_heal_ks.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "DM:HEAL:ANIMATION:KROVOSOS";
ACTION.Desc = "??";
ACTION.Category = "??";

ACTION.Sequences = {
	'sit_eat_0'
};

function ACTION:onStartCommand(Player, Command)
	local Keys = {IN_JUMP, IN_RELOAD, IN_DUCK, IN_WALK, IN_SPRINT};

	for _, KEY_BITFLAG in pairs(Keys) do
		Command:RemoveKey(KEY_BITFLAG);
	end

	Command:ClearMovement();
end

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		ply:SetEmoteActionSequences( "sit_eat_0", 0, function()
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "dm_heal_ks", ACTION );