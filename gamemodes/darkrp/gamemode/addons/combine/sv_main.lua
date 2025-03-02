local map = game.GetMap() == "rp_c18_urfim"
local stupid_door = {
	[571] = true,
	[578] = true,
}

util.AddNetworkString('rp.CombineOpenDoor')
net.Receive('rp.CombineOpenDoor', function(len, ply)
	local ent = ply:GetEyeTrace().Entity
	if !(ent:GetClass() == 'func_door' && ply:CanLockUnlock(ent)) then return end
	
	ent:Fire('open', '')
	ent:Fire('setanimation', 'open')

	if map && stupid_door[ent:MapCreationID()] then
		timer.Simple(3, function()
			ent:Fire('close', '')
			ent:Fire('setanimation', 'close')
		end)
	end
end)


hook('playerDisguised', function(ply, prev, team)
	local t = rp.TeamByID(team)
	if t.faction == FACTION_COMBINE then
		ply:Give('nut_stunstick')
	end
end)