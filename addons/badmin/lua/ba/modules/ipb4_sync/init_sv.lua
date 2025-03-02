//ba.ipb = ba.ipb or {
//	_db = ptmysql.newdb(ba.data.IP, 'ipb', 'FH2cRNGDHePuNsqE', 'ipb', ba.data.Port)
//}
//
//local db 	= ba.ipb._db 
//local g_ids = { -- I have no idea where group ID's are stored in ipb4
//	['user'] 		= 3,
//	['globaladmin'] = 7,
//	['superadmin'] 	= 20,
//	['admin'] 		= 14,
//	['moderator'] 	= 15,
//	['vip'] 		= 16,
//	['devteam'] 	= 21
//}
//
//function ba.ipb.SetGroup(pl, group, cback)
//	group = g_ids[string.lower(group)]
//	if group then 
//		db:query('UPDATE core_members SET member_group_id=' .. group .. ' WHERE steamid =' .. ba.InfoTo64(pl), cback)
//	end
//end
//
//hook.Add('playerRankLoaded', function(pl, data)
//	if ba.ranks.Get(data.rank) then
//		ba.ipb.SetGroup(pl,ba.ranks.Get(data.rank):GetName())
//	end
//end)
//
//hook.Add('playerSetRank', function(pl, rank, ex_rank, ex_time)
//	if ba.ranks.Get(rank) then
//		ba.ipb.SetGroup(pl,ba.ranks.Get(rank):GetName())
//	end
//end)
//
//hook.Add('playerRankExpire', function(pl, ex_rank)
//	ba.ipb.SetGroup(pl, ex_rank)
//end)