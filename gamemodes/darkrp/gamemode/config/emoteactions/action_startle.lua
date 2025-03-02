-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_startle.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Оглянуться";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"startle", "обернуться", "оглянуться", "испугаться"
}

ACTION.Sequences = {
	"photo_react_startle"
}

ACTION.SequenceCheck = {
	"photo_react_startle"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionSequences( "photo_react_startle", nil, function()
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "startle", ACTION );