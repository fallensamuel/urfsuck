local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Бездействовать";
ACTION.Desc = "";

ACTION.ChatAliases = {
	"idle", "бездействие", "бездействовать", "безд", "бд"
}

ACTION.Sequences = {
	"lineidle01", "lineidle02", "lineidle03"
}
--
--ACTION.WeaponCheck = {
--	"weapon_fists",
--	"weapon_hands",
--	"weapon_keys"
--}

ACTION.WepSwitchAllowed = false;

if SERVER then
	function ACTION:onStart( ply )
		local sequences = self:GetAvalibleSequences(ply);

		if table.Count( sequences ) > 0 then
			ply:SetEmoteActionState( ACTION_STATE_RUNNING );

			ply:SetEmoteActionSequences( table.Random(sequences), 0 );
		end
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "idle", ACTION );