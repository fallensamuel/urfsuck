-- "gamemodes\\rp_base\\gamemode\\main\\emoteactions\\player_meta_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetAvalibleActions()
	local tab = {}

	for ActionName, ActionData in pairs( EmoteActions.Actions ) do
		local seqTbl = {};

		if ActionData.Sequences then
			for _, seqID in pairs( ActionData.Sequences ) do
				if self:LookupSequence( seqID ) ~= -1 then
					table.insert( seqTbl, seqID );
				end
			end

			if table.Count( seqTbl ) > 0 then
				table.insert( tab, ActionName );
			end
		end
	end

	return tab
end


function PLAYER:RequestEmoteActionInterrupt()
	net.Start("EmoteActions.RequestInterrupt");
	net.SendToServer();
end


function PLAYER:RunEmoteAction( actID )
	if self ~= LocalPlayer() then return end
	
	net.Start( "PlayerAnimRun" )
		net.WriteString( actID );
	net.SendToServer();
end