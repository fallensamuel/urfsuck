-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_sitmary_one.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Сесть на землю";
ACTION.Desc = "";


ACTION.Sequences = {
	"canals_mary_preidle"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		
		ply:SetEmoteActionSequences( "canals_mary_preidle", nil, function()
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "sitmaryone", ACTION );