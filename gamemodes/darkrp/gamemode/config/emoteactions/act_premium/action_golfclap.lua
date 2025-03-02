-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\act_premium\\action_golfclap.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Аплодисменты";
ACTION.Desc = "";
ACTION.Category = "Премиальные";


ACTION.Sequences = {
	"f_golfclap"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		local seq = self.Sequences[1]
		
		local _, length = ply:LookupSequence(seq)
		local recursive
		
		recursive = function()
			if IsValid(ply) and ply:GetEmoteAction() == 'golfclap' then
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

EmoteActions:RegisterAction( "golfclap", ACTION );