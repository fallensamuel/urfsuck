-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_breachdoor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name     = "Выбивание двери";
ACTION.Desc     = "??";
ACTION.Category = "??";

ACTION.Sequences = {
	"tomatothrow",
};

ACTION.SequenceCheck = {
	"tomatothrow",
};

ACTION.Sounds = {
	"physics/wood/wood_crate_impact_hard1.wav",
	"physics/wood/wood_crate_impact_hard2.wav",
	"physics/wood/wood_crate_impact_hard3.wav",
	"physics/wood/wood_crate_impact_hard4.wav",
	"physics/wood/wood_crate_impact_hard5.wav",
	"physics/wood/wood_crate_impact_soft1.wav",
	"physics/wood/wood_crate_impact_soft2.wav",
	"physics/wood/wood_crate_impact_soft3.wav",
};

if SERVER then
	function ACTION:onCall( ply )
		--if ply.IsBreachingDoor then
			ply.__iEmoteBreachingHealth = ply:Health();
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );
			return true
		--end

		--return false
	end

	function ACTION:onStart( ply )
		ply:SetEmoteActionSequences( "tomatothrow", nil, function()
			ply:EmitSound(
				self.Sounds[math.random(1,#self.Sounds)],
				100,
				math.random( 90, 110 )
			);

			ply:SetEmoteActionSequences( "photo_react_startle", 0.01, nil, function() -- bruh
				self:onStart( ply );
			end );
		end );
	end

	function ACTION:onRun( ply )
		if ply:Health() < ply.__iEmoteBreachingHealth then
			self:onEnd( ply );
		end
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply.__iEmoteBreachingHealth = nil;
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "__breachdoor", ACTION );