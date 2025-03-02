ba.data = ba.data or {}

--
-- Misc
--
function ba.data.GetDB()
	return ba.data._db
end

function ba.data.GetID()
	return (ba.svar.Get('sv_id') or 'NOT_SET')
end

function ba.data.GetUID()
	return ba.data._uid
end


--
-- 	Auth keys
--
local db = ba.data.GetDB()

function ba.data.CreateKey(pl, cback)
	local time = os.time()
	local key = pl:HashID()
	pl:SetBVar('LastKey', key)
	db:query('INSERT INTO ba_keys(`Date`, `Key`) VALUES(' .. time .. ', "' .. key .. '");', cback)
	return key
end

function ba.data.DestroyKey(key, cback)
	db:query('DELETE * FROM ba_keys WHERE `Key`="' .. key .. '";', cback)
end


--
-- Player data
--

local function escapeName(name)
	local new_name = ''
	
	for v in string.gmatch(name, utf8.charpattern) do 
		local cp = utf8.codepoint(v) 
		if cp > 31 and cp < 127 or cp > 1039 and cp < 1104 then 
			new_name = new_name .. v
		end 
	end
	
	return new_name
end

function ba.data.LoadPlayer(pl, cback)
	local steamid 	= (pl:SteamID64() or '0')
	
	--local name 		= utf8.force(pl:Name())
	local name 		= escapeName(pl:Name())

	db:query_ex('SELECT * FROM ba_users WHERE steamid=?', {steamid}, function(_data)
		local d 	= (_data[1]		or {})
		d.lastseen 	= (d.lastseen	or os.time()) --wtf
		d.playtime	= (d.playtime	or 0)

		if IsValid(pl) then
			--print(ply, "ласт логин", os.time() - d.lastseen, "сек назад")
			pl.lastjoin = d.lastseen
			pl.lastseen = d.lastseen
			pl.firstjoin = d.firstjoined or os.time()
			pl.FirstJoin = pl.firstjoin
		end

		pl:SetNetVar('PlayTime', d.playtime)
		pl:SetNetVar('FirstJoined', CurTime())
		pl:SetNetVar("FirstJoinTime", d.firstjoined or os.time())

		if (#_data < 1) then -- you seem to be a new player let's create some data for you.
			db:query_ex('INSERT INTO ba_users(steamid, name, firstjoined, lastseen, playtime) VALUES(?, "?", ?, ?, 0)', {steamid, name, os.time(), os.time()})
			ba.notify_all(ba.Term('PlayerFirstConnect'), pl)
		else
			db:query_ex('UPDATE ba_users SET name="?", lastseen=? WHERE steamid=?;', {name, os.time(), steamid})
			ba.notify_all(ba.Term('PlayerConnect'), pl:Nick(), os.date("%d/%m/%Y" , d.lastseen))
		end

		if not d.firstjoined then -- You joined before we added merged this feature. We'll just pretend that you haven't ever joined!
			db:query_ex('UPDATE ba_users SET firstjoined=? WHERE steamid=?;', {os.time(), steamid})
		end

		db:query_ex('SELECT * FROM ba_ranks'.. (isSerious && '_serious' || '')..' WHERE steamid=?;', {steamid}, function(data)
			local _d		= (data[1] or {})

			_d.expire_rank 	= ba.ranks.Get(tonumber(_d.expire_rank or 1)):GetName()
			_d.expire_time 	= (_d.expire_time or 0)
			_d.rank 		= tonumber(_d.rank or 1)

			pl:SetBVar('expire_rank', _d.expire_rank)
			pl:SetBVar('expire_time', _d.expire_time)

			local rank_id = ba.ranks.Get(_d.rank):GetID()
			if (rank_id ~= 1) then
				pl:SetNetVar('UserGroup', ba.ranks.Get(_d.rank):GetID())
			end

			if (#data < 1) then
				db:query_ex('INSERT INTO ba_ranks'.. (isSerious && '_serious' || '')..'(steamid, rank, expire_rank, expire_time) VALUES("?","?","?","?")', {steamid, 1, 1, 0})
			end

			if _d.expire_time ~= 0 then
				if _d.expire_time < os.time() then
					ba.data.SetRank(pl, _d.expire_rank, _d.expire_rank, 0, hook.Call('playerRankExpire', ba, pl, _d.expire_rank))
				else
					pl:SetNetVar("UsergroupExpire", _d.expire_time)
				end
			end

			if cback then cback(data) end

			pl:SetBVar('DataLoaded', true)

			hook.Call('playerRankLoaded', ba, pl, _d)
			hook.Run("baDataLoaded", pl, _d)
		end)
	end)
end

function ba.data.SetRank(pl, rank, expire_rank, expire_time, cback)
	local steamid 	= ba.InfoTo64(pl)
	local sv_id 	= ba.data.GetID()
	local r 		= (rank 		or 1)
	local exr 		= (expire_rank 	or 'user')
	local ext 		= (expire_time 	or 0)
	local rank_obj 	= ba.ranks.Get(r)
	local rank_ex_obj = ba.ranks.Get(exr)

	local rank_id = rank_obj:GetID()
	local rank_ex_id = rank_ex_obj:GetID()

	db:query_ex('REPLACE INTO ba_ranks'.. (isSerious && '_serious' || '')..'(steamid, rank, expire_rank, expire_time) VALUES("?","?","?","?")', {steamid, rank_id, rank_ex_id, ext}, function(data)
		if ba.IsPlayer(pl) then
			pl:SetBVar('expire_rank', exr)
			pl:SetBVar('expire_time', ext)
			if (rank_id == 1) then
				pl:SetNetVar('UserGroup', nil)
			else
				pl:SetNetVar('UserGroup', rank_id)
			end

			pl:SetNetVar("UsergroupExpire", (ext ~= 0 and ext > os.time()) and ext or 0)
		end
		hook.Call('playerSetRank', ba, pl, r, exr, ext)
		if cback then cback(data) end
	end)
end

function ba.data.UpdatePlayTime(pl)
	if not IsValid(pl) or not pl:GetBVar('DataLoaded') then return end
	db:query('UPDATE ba_users SET lastseen=' .. os.time() .. ', playtime = IF(playtime > ' .. pl:GetPlayTime() .. ', playtime, ' .. pl:GetPlayTime() .. ') WHERE steamid=' .. pl:SteamID64() .. ';')
end

-- Sync queries
function ba.data.GetRank(steamid64)
	local data = db:query_sync('SELECT rank FROM ba_ranks'.. (isSerious && '_serious' || '')..' WHERE steamid=?;', {steamid64, ba.data.GetID()})
	return (data[1] and data[1].rank or 'user')
end

function ba.data.GetName(steamid64)
	local data = db:query_sync('SELECT name FROM ba_users WHERE steamid=?;', {steamid64})
	return (data and data[1] and data[1].name or 'Unknown')
end
/*
function ba.data.CanTarget(targeter_steamid64, target_steamid64)

end