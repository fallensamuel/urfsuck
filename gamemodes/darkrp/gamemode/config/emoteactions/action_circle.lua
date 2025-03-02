-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_circle.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Показать на пол";
ACTION.Desc = "";


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