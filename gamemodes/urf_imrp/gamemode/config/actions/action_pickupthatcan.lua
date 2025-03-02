local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Подбери банку";
ACTION.Desc = "";
ACTION.Category = "Насмешки";

ACTION.SequenceCheck = {
	"itemhit"
}

ACTION.WeaponCheck = {
	"weapon_stunstick"
}

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionSequences( "itemhit", nil, function()
			sound.Play( "npc/metropolice/vo/pickupthecan1.wav", ply:GetPos() );
			ply:DropEmoteAction();
		end );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "pickupthatcan", ACTION );