-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\act_usual\\action_peely_blender.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Голововорот";
ACTION.Desc = "";
ACTION.Category = "Эмоции"


ACTION.Sequences = {
	"f_peely_blender"
}

if SERVER then
    function ACTION:onStart( ply )
        ply:SetEmoteActionSequences( "f_peely_blender", nil, function()
            ply:DropEmoteAction();
        end );
    end

    function ACTION:onEnd( ply )
        ply:SetEmoteActionState( ACTION_STATE_ENDING );
        ply:DropEmoteAction();
    end
end

EmoteActions:RegisterAction( "f_peely_blender", ACTION );