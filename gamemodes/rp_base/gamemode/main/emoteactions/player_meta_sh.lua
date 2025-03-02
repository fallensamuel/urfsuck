-- "gamemodes\\rp_base\\gamemode\\main\\emoteactions\\player_meta_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );


function PLAYER:GetEmoteActionData()
	return EmoteActions.PlayerAnims[ self ] or {};
end

function PLAYER:GetEmoteAction()
	if EmoteActions.PlayerAnims[ self ] then
		return EmoteActions.PlayerAnims[ self ].Action or "";
	end

	return "";
end


function PLAYER:GetEmoteActionSequence()
	if EmoteActions.PlayerAnims[ self ] then
		return EmoteActions.PlayerAnims[ self ].Sequence or -1;
	end

	return -1;
end


function PLAYER:GetEmoteActionState()
	if EmoteActions.PlayerAnims[ self ] then
		return EmoteActions.PlayerAnims[ self ].State or ACTION_STATE_UNDEFINED;
	end

	return ACTION_STATE_UNDEFINED;
end