-- "gamemodes\\darkrp\\gamemode\\config\\emoteactions\\action_laydown.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ACTION = table.Copy( EmoteActions:GetRawAction( "__base" ) );

ACTION.Name = "Прилечь";
ACTION.Desc = "";


ACTION.Sequences = {
	"Canals_Matt_laydown"
}

local _oldOnCall = ACTION.onCall;
function ACTION:onCall( ply )
	if _oldOnCall( self, ply ) then
		local p = ply:GetBonePosition( 0 );

		local tr = util.TraceHull( {
			start  = p,
			endpos = p,
			mask = MASK_SOLID_BRUSHONLY,			
			maxs = Vector(28,28,1),
			mins = -Vector(28,28,36),
		} );

		if tr.HitWorld then
			rp.Notify( ply, NOTIFY_ERROR, rp.Term("EmoteActions.NotEnoughSpace") );
			return false
		else
			return true
		end
	end
end

if SERVER then
	function ACTION:onStart( ply )
		ply:SetEmoteActionState( ACTION_STATE_STARTING );
		ply:SetEmoteActionSequences( "Canals_Matt_laydown", 0);
		ply:SetEmoteActionState( ACTION_STATE_RUNNING );
	end

	function ACTION:onEnd( ply )
		ply:SetEmoteActionState( ACTION_STATE_ENDING );
		ply:DropEmoteAction();
	end
end

EmoteActions:RegisterAction( "laydown", ACTION );