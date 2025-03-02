-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\act_usual\\action_confused.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Растерянность";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.Sequences = {
	"f_confused"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		local _, length = ply:LookupSequence('f_confused')
		local recursive
		
		recursive = function()
			if IsValid(ply) and ply:GetEmoteAction() == 'confused' then
				ply:SetEmoteActionSequences("f_confused", length - 0.5, nil, recursive)
				
				net.Start('PlayerAnimReset')
					net.WriteEntity(ply)
				net.Broadcast()
			end
		end
		
		ply:SetEmoteActionSequences("f_confused", length - 0.5, nil, recursive)
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "confused", ACTION );