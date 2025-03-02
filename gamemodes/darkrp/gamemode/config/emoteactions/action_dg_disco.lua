-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_dg_disco.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Диско";
ACTION.Desc = "";
ACTION.Category = "Эмоции"


ACTION.Sequences = {
	"f_dg_disco"
}

if SERVER then
    function ACTION:onStart( ply )
        ply:SetEmoteActionSequences( "f_dg_disco", nil, function()
            ply:DropEmoteAction();
        end );
    end

    function ACTION:onEnd( ply )
        ply:SetEmoteActionState( ACTION_STATE_ENDING );
        ply:DropEmoteAction();
    end
end

EmoteActions:RegisterAction( "f_dg_disco", ACTION );