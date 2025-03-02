-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_pickupthatcan.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Подбери банку";
ACTION.Desc = "";

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