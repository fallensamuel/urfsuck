util.AddNetworkString('EmoteActions.SetupModel')
util.AddNetworkString('PlayerAnimReset')

function EmoteActions.PlayerAnimRun(ply, actID)
	if ply.IsProne and ply:IsProne() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("CandUseAnimWhileProne"))
		return
	end

	if ply.DeathAction or string.sub(actID, 1, 3) == 'dm_' then return end
	
	if rp.shop.EmoteActsMap and rp.shop.EmoteActsMap[actID] and not (ply:HasUpgrade(rp.shop.EmoteActsMap[actID]) or rp.EventIsRunning('DanceEvent') or ply:HasPremium()) then
		return
	end
	
	local rawAction = EmoteActions:GetRawAction(actID);
	if rawAction.Org then
		if rawAction.Org ~= ply:GetOrg() then
			return
		end
	end

	ply:StartEmoteAction( actID );
end

net.Receive( "PlayerAnimRun", function( len, ply )
	local actID = net.ReadString();
	EmoteActions.PlayerAnimRun(ply, actID)
end );

hook.Add( "PostPlayerDeath", "EmoteActions.PostPlayerDeath.ResetEmoteAction", function( ply )
	timer.Simple(0.1, function()
		if IsValid(ply) then
			ply:DropEmoteAction();
		end
	end)
end );
