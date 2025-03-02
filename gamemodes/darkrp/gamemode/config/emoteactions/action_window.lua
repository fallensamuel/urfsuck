-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_window.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Выглянуть";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"window", "окно", "выглянуть",
}

ACTION.Sequences = {
	"d1_t03_tenements_look_out_window_idle",
	"d1_t03_lookoutwindow"
}

if SERVER then
	function ACTION:onStart( ply )
		local anim = "d1_t03_tenements_look_out_window_idle";

		if ply:LookupSequence( "d1_t03_tenements_look_out_window_idle" ) == -1 then
			if ply:LookupSequence( "d1_t03_lookoutwindow" ) == -1 then
				ply:DropEmoteAction();
			else
				anim = "d1_t03_lookoutwindow";
			end
		end

		ply:SetEmoteActionState( ACTION_STATE_STARTING );

		local traceLine = util.TraceLine( {
			start  = ply:EyePos(),
			endpos = ply:EyePos() + (ply:GetAngles():Forward() * 18),
			filter = ply
		} );

		if not traceLine.Hit then
			ply:Notify(NOTIFY_ERROR, "Вы должны стоять возле окна." );
			ply:DropEmoteAction();
			return
		end

		ply:SetEmoteActionSequences( anim, 0, function()
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "window", ACTION );