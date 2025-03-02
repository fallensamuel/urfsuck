-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_threat.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Угроза";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"threat", "угроза", "угрожать"
}

ACTION.Sequences = {
	"plazathreat1",
	"plazathreat2"
}

ACTION.SequenceCheck = {
	"plazathreat1",
	"plazathreat2"
}

ACTION.WeaponCheck = {
	"weapon_stunstick"
}

if SERVER then
	function ACTION:onStart( ply )
		local anim = "plazathreat1";

		if math.random() < 0.5 then anim = "plazathreat2" end

		ply:SetEmoteActionState( ACTION_STATE_RUNNING );

		ply:SetEmoteActionSequences( anim, nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "threat", ACTION );