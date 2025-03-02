-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_linestay.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Сесть на землю";
ACTION.Desc = "";


ACTION.Sequences = {
	"LineIdle01","LineIdle02","LineIdle03"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences(table.Random(self.Sequences), 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "linestay", ACTION );