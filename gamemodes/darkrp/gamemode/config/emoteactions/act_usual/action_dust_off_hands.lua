-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\act_usual\\action_dust_off_hands.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Вытереть Руки";
ACTION.Desc = "";
ACTION.Category = "Эмоции";

ACTION.Sequences = {
	"f_dust_off_hands"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		local seq = self.Sequences[1]
		
		local _, length = ply:LookupSequence(seq)
		local recursive
		
		recursive = function()
			if IsValid(ply) and ply:GetEmoteAction() == 'dust_off_hands' then
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

EmoteActions:RegisterAction( "dust_off_hands", ACTION );