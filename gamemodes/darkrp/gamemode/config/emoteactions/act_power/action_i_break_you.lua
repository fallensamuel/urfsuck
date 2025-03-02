-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\act_power\\action_i_break_you.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Я тебя сломаю!";
ACTION.Desc = "";
ACTION.Category = "Боевые";


ACTION.Sequences = {
	"f_i_break_you"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		local seq = self.Sequences[1]
		
		local _, length = ply:LookupSequence(seq)
		local recursive
		
		recursive = function()
			if IsValid(ply) and ply:GetEmoteAction() == 'i_break_you' then
				ply:SetEmoteActionSequences(seq, length - 0.5, nil, recursive)
				
				net.Start('PlayerAnimReset')
					net.WriteEntity(ply)
				net.Broadcast()
			end
		end
		
		ply:SetEmoteActionSequences(seq, length - 0.5, nil, recursive)
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "i_break_you", ACTION );