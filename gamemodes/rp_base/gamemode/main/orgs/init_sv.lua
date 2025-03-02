rp.orgs = rp.orgs or {}
rp.orgs.cached = rp.orgs.cached or {}
rp.orgs.Colors = rp.orgs.Colors or {}

util.AddNetworkString('rp.OrgsMenu')
util.AddNetworkString('rp.SetOrgMoTD')
util.AddNetworkString('rp.OrgBannerReceived')
util.AddNetworkString('rp.OrgBannerInvalidate')
util.AddNetworkString('rp.SetOrgBanner')
util.AddNetworkString('rp.SetOrgBannerDefault')
util.AddNetworkString('rp.orgs.GetColors')
util.AddNetworkString('rp.orgs.GetColor')

local db = rp._Stats

local LogActions = {
	Create = 1, -- y
	Remove = 2, -- y
	Invite = 3, -- хз, пока думаю юзлесс.
	Join = 4, -- y
	Kick = 5, -- y
	Quit = 6, -- y
	SetMoTD = 7, -- y
	SetColor = 8, -- y
	SetRank = 9, -- y
	SetBanner = 10, -- y
}

local DebugNames = {} for k, v in pairs(LogActions) do DebugNames[v] = k end

hook.Add("InitPostEntity", "InitOrgsLog", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `orgs_log` (`ActID` int(4) NOT NULL, `Org` TEXT CHARACTER SET utf8 NOT NULL, `Actor` bigint(20) NOT NULL, `Data` TEXT CHARACTER SET utf8 NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
end)

local baseLogQuery = "INSERT INTO `orgs_log`(`ActID`, `Org`, `Actor`, `Data`) VALUES(%s, %q, %s, %q);"
local function DoLog(id, who, org, data)
	data = data or ""
	db:Query(baseLogQuery:format(id, org, who, data))

	--print("Action: ".. DebugNames[id], "Who: ".. who, "Org: ".. org, "Data: ".. data)
end

local baseLogCMDQuery = "SELECT * FROM `orgs_log` WHERE `Org` = %q LIMIT %s;"
concommand.Add("~getorglog", function(ply, cmd, args)
	if IsValid(ply) or not args[1] then return end
	db:Query(baseLogCMDQuery:format(args[1], args[2] or 20), function(data)
		for i, info in pairs(data or {}) do
			data[i]["ActID"] = DebugNames[ data[i]["ActID"] ] or data[i]["ActID"]
		end

		PrintTable(data or {})
	end)
end)

-- Creation & Modification
function rp.orgs.Exists(name, cback)
	db:Query('SELECT COUNT("Name") FROM orgs WHERE Name=?;', name, function(count)
		cback(count[1]['COUNT("Name")'] and tonumber(count[1]['COUNT("Name")']) > 0)
	end)
end

local function sendColor(name)
	timer.Simple(0.3, function()
		local v = rp.orgs.Colors[name] or Color(255, 255, 255, 255)
		
		net.Start('rp.orgs.GetColor')
			net.WriteString(name)
			net.WriteColor(Color(math.floor(v.r or 0), math.floor(v.g or 0), math.floor(v.b or 0), math.floor(v.a or 255)))
		net.Broadcast()
	end)
end

function rp.orgs.Create(steamid, name, color, callback)
	rp.orgs.Colors[name] = color
	sendColor(name)
	
	db:Query('INSERT INTO orgs(Owner, Name, Color, MoTD) VALUES(?, ?, ?, ?);', steamid, name, pcolor.ToHex(color), 'Welcome to ' .. name .. '!', function()
		db:Query('INSERT INTO org_rank(Org, RankName, Weight, Invite, Kick, Rank, MoTD, CanCapture, CanDiplomacy) VALUES(?, ?, ?, ?, ?, ?, ?, 1, 1),(?, ?, ?, ?, ?, ?, ?, 0, 0);', name, 'Owner', 100, 1, 1, 1, 1, name, 'Member', 1, 0, 0, 0, 0, function()
			rp.orgs.cached[name] = {
				Members = {},
				Ranks = {
					Owner = {
						Org = name,
						RankName = 'Owner',
						Weight = 100,
						Invite = true,
						Kick = true,
						Rank = true,
						MoTD = true, 
						CanCapture = true, 
						CanDiplomacy = true
					},
					Members = {
						Org = name,
						RankName = 'Member',
						Weight = 1,
						Invite = false,
						Kick = false,
						Rank = false,
						MoTD = false, 
						CanCapture = false, 
						CanDiplomacy = false
					}
				}
			}

			rp.orgs.Join(steamid, name, 'Owner', callback)
		end)
	end)
end

function rp.orgs.Remove(name, callback)
	db:Query('DELETE FROM orgs WHERE Name=?;', name, function()
		db:Query('DELETE FROM org_player WHERE Org=?;', name, function()
			db:Query('DELETE FROM org_rank WHERE Org=?;', name, function()
				db:Query('DELETE FROM org_banner WHERE Org=?;', name, function()
					for k, v in ipairs(rp.orgs.GetOnlineMembers(name)) do
						v:SetOrg(nil, nil)
						v:SetOrgData(nil)
						rp.Notify(v, NOTIFY_ERROR, rp.Term('OrgDisbanded'), name)
					end

					rp.orgs.cached[name] = nil

					if callback then
						callback()
					end
				end)
			end)
		end)
	end)
end

function rp.orgs.Quit(steamid, callback)
	db:Query('DELETE FROM org_player WHERE SteamID=?;', steamid, callback)
end

function rp.orgs.SetMoTD(org, motd, callback)
	db:Query('UPDATE orgs SET MoTD=? WHERE Name=?', motd, org, function()
		for k, v in ipairs(rp.orgs.GetOnlineMembers(org)) do
			local dat = v:GetOrgData()
			dat.MoTD = motd
			v:SetOrgData(dat)
		end

		if callback then
			callback()
		end
	end) -- this line was not playing nice
end

function rp.orgs.SetColor(org, color, callback)
	db:Query('UPDATE orgs SET Color=? WHERE Name=?', pcolor.ToHex(color), org, function()
		rp.orgs.Colors[org] = color
		sendColor(org)
		
		for k, v in ipairs(rp.orgs.GetOnlineMembers(org)) do
			v:SetOrg(org, color)
		end

		if callback then
			callback()
		end
	end)
end

-- Members
function PLAYER:SetOrg(name, color)
	self:SetNetVar('Org', name)
	self:SetNetVar('OrgColor', color)

	hook.Call("PlayerOrgChanged", nil, self)
end

function rp.orgs.Join(steamid, org, rank, callback)
	rp.orgs.cached[org].Members[steamid] = {
		SteamID = steamid,
		Org = org,
		Rank = rank
	}

	DoLog(LogActions.Join, steamid, org, rank)
	db:Query('INSERT INTO org_player(SteamID, Org, Rank) VALUES(?, ?, ?);', steamid, org, rank, callback)
end

function rp.orgs.Kick(steamid, callback)
	local pl = rp.FindPlayer(steamid)

	if (pl) then
		steamid = pl:SteamID64()
	end

	db:Query('DELETE FROM org_player WHERE SteamID=?;', steamid, function()
		if IsValid(pl) then
			rp.Notify(rp.orgs.GetOnlineMembers(pl:GetOrg()), NOTIFY_ERROR, rp.Term('OrgPlayerKicked'), pl, pl:GetOrg())
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgPlayerYoureKicked'), pl:GetOrg())
			pl:SetOrg(nil, nil)
			pl:SetOrgData(nil)
		end

		if callback then
			callback()
		end
	end)
end

function rp.orgs.GetMembers(org, callback)
	db:Query("SELECT * FROM org_rank WHERE Org=? ORDER BY Weight DESC;", org, function(ranks)
		db:Query('SELECT org_player.SteamID, org_player.Rank, player_data.Name FROM org_player LEFT JOIN player_data ON org_player.SteamID = player_data.SteamID WHERE org_player.Org = ?;', org, function(members)
			rp.orgs.cached[org] = {
				Ranks = {},
				Members = {},
				RanksOrdered = ranks
			}

			for k, v in ipairs(ranks) do
				rp.orgs.cached[org].Ranks[v.RankName] = v
			end

			for k, v in ipairs(members) do
				rp.orgs.cached[org].Members[v.SteamID] = v
			end

			if (callback) then
				callback(members, ranks)
			end
		end)
	end)
end

function rp.orgs.GetMemberCount(name, cback)
	db:Query('SELECT COUNT("Name") FROM org_player WHERE Org=?;', name, function(count)
		cback(count[1]['COUNT("Name")'] and tonumber(count[1]['COUNT("Name")']) or 0)
	end)
end

-- Ranks
function PLAYER:SetOrgData(d)
	self:SetNetVar('OrgData', d)
end

function rp.orgs.RecalculateWeights(org, ranks)
	table.SortByMember(ranks, 'Weight', true)
	local mems = rp.orgs.GetOnlineMembers(org)

	for k, v in ipairs(ranks) do
		local newWeight = 1 + math.floor(((k - 1) / (#ranks - 1)) * 99)

		if (newWeight ~= v.Weight) then
			for _, pl in pairs(mems) do
				local od = pl:GetOrgData()

				if (od.Rank == v.RankName) then
					od.Weight = v.Weight
					pl:SetOrgData(od)
				end
			end

			db:Query('UPDATE org_rank SET Weight=? WHERE Org=? AND RankName=?', newWeight, org, v.RankName)
		end

		rp.orgs.cached[org].Ranks[v.RankName].Weight = newWeight
	end
end

function rp.orgs.CanTarget(pl, targID, check_org)
	if (not pl:GetOrg()) then return false end
	if (pl:SteamID64() == targID) then return false end
	if (#tostring(targID) ~= 17) then return false end

	if (not rp.orgs.cached[pl:GetOrg()]) then
		rp.orgs.GetMembers(pl:GetOrg())
	end

	if check_org and not rp.orgs.cached[pl:GetOrg()].Members[targID] then
		return false
	end
	
	local targrank = rp.orgs.cached[pl:GetOrg()].Ranks[rp.orgs.cached[pl:GetOrg()].Members[targID].Rank] or rp.orgs.cached[pl:GetOrg()].RanksOrdered[#rp.orgs.cached[pl:GetOrg()].RanksOrdered]
	if (pl:GetOrgData().Perms.Weight <= targrank.Weight) then return false end

	return true
end

-- Load data
local function SetOrg(pl, d)
	pl:SetOrg(d.Name, pcolor.FromHex(d.Color))
	local r = d.OrgData

	pl:SetOrgData({
		Rank = d.Rank or r.Perms.RankName,
		MoTD = d.MoTD,
		Perms = {
			Weight = r.Perms.Weight,
			Owner = (r.Perms.Weight == 100),
			Invite = r.Perms.Invite,
			Kick = r.Perms.Kick,
			Rank = r.Perms.Rank,
			MoTD = r.Perms.MoTD,
			CanCapture = r.Perms.CanCapture, 
			CanDiplomacy = r.Perms.CanDiplomacy
		}
	})
end

hook('PlayerAuthed', 'rp.orgs.PlayerAuthed', function(pl)
	--concommand.Add('or', function(pl)
	local steamid = pl:SteamID64()

	db:Query('SELECT * FROM org_player LEFT JOIN orgs ON org_player.Org = orgs.Name WHERE org_player.SteamID=' .. steamid .. ';', function(data)
		local d = data[1]

		if d then
			d.OrgData = {}

			db:Query('SELECT * FROM org_rank WHERE Org = "' .. d.Org .. '" AND RankName = "' .. d.Rank .. '";', function(data)
				local _d = data[1]

				if _d then
					d.OrgData.Perms = _d
					SetOrg(pl, d)
				end
			end)
		end
	end)
end)

local function findBadCharacter(name)
	local allowed = {
		['1'] = true, ['2'] = true, ['3'] = true, ['4'] = true, ['5'] = true, ['6'] = true, ['7'] = true, ['8'] = true, ['9'] = true, ['0'] = true,
		[' '] = true, ['('] = true, [')'] = true, ['['] = true, [']'] = true, ['!'] = true, ['@'] = true, ['#'] = true, ['$'] = true, ['%'] = true, ['^'] = true, ['&'] = true, ['*'] = true, ['-'] = true, ['_'] = true, ['='] = true, ['+'] = true, ['|'] = true, ['\\'] = true,['.'] = true,
		['a'] = true, ['b'] = true, ['c'] = true, ['d'] = true, ['e'] = true, ['f'] = true, ['g'] = true, ['h'] = true, ['i'] = true, ['j'] = true, ['k'] = true, ['l'] = true, ['m'] = true, ['n'] = true, ['o'] = true, ['p'] = true, ['q'] = true, ['r'] = true, ['s'] = true, ['t'] = true, ['u'] = true, ['v'] = true, ['w'] = true, ['x'] = true, ['y'] = true, ['z'] = true, 
		['а'] = true, ['б'] = true, ['в'] = true, ['г'] = true, ['д'] = true, ['е'] = true, ['ё'] = true, ['ж'] = true, ['з'] = true, ['и'] = true, ['й'] = true, ['к'] = true, ['л'] = true, ['м'] = true, ['н'] = true, ['о'] = true, ['п'] = true, ['р'] = true, ['с'] = true, ['т'] = true, ['у'] = true, ['ф'] = true, ['х'] = true, ['ц'] = true, ['ч'] = true, ['ш'] = true, ['щ'] = true, ['ъ'] = true, ['ы'] = true, ['ь'] = true, ['э'] = true, ['ю'] = true, ['я'] = true
	};

	for k in string.gmatch(name, utf8.charpattern) do
		if !allowed[utf8.lower(k)] then
			return k
		end
	end
	
	return false
end

-- Commands
rp.AddCommand('/createorg', function(pl, text, args)
	local name = string.Trim(args[1] or '')

	if (pl:GetOrg() ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgMustLeaveFirst'))

		return
	end
	
	if (utf8.len(name) < 2) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgNameShort'))

		return
	end
	
	if (utf8.len(name) > 20) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgNameLong'))

		return
	end
	
	local badChar = findBadCharacter(name)
	if badChar then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RPNameUnallowed'), badChar)

		return
	end

	rp.orgs.Exists(name, function(exists)
		if (not IsValid(pl)) then return end

		if (exists) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgNameTaken'))

			return
		end
	
		if not pl:CanAfford(rp.cfg.OrgCost) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgCannotAfford'))

			return
		end
		
		local color = VectorRand(110, 255)
		color = Color(color.x, color.y, color.z, 255)
		
		local start = SysTime()

		rp.orgs.Create(pl:SteamID64(), name, color, function()
			pl:TakeMoney(rp.cfg.OrgCost)
			pl:SetOrg(name, color)
			local orgdata = rp.orgs.BaseData['Owner']
			orgdata.MoTD = 'Welcome to ' .. name .. '!'
			pl:SetOrgData(orgdata)
			rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgCreated'))

			DoLog(LogActions.Create, pl:SteamID64(), name)
			
			--net.Start('rp.SetOrgBannerDefault')
			--net.Send(pl)
		end)
	end)
end)

net('rp.SetOrgMoTD', function(len, pl)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.MoTD then return end
	local motd = net.ReadString()

	DoLog(LogActions.SetMoTD, pl:SteamID64(), pl:GetOrg())
	rp.orgs.SetMoTD(pl:GetOrg(), motd, function()
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgMOTDChanged'))
	end)
end)

rp.AddCommand('/setorgcolor', function(pl, text, args)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Owner then return end
	local color = Color(tonumber(args[1] or 255), tonumber(args[2] or 255), tonumber(args[3] or 255))

	DoLog(LogActions.SetColor, pl:SteamID64(), pl:GetOrg())
	rp.orgs.SetColor(pl:GetOrg(), color, function()
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgColorChanged'))
	end)
end)

rp.AddCommand('/orgmenu', function(pl, text, args)
	if not pl:GetOrg() then return end

	rp.orgs.GetMembers(pl:GetOrg(), function(members, ranks)
		net.Start('rp.OrgsMenu')
		local rankref = {}
		net.WriteUInt(#ranks, 5)

		for k, v in ipairs(ranks) do
			net.WriteString(v.RankName)
			net.WriteUInt(v.Weight, 7)
			net.WriteBool(v.Invite)
			net.WriteBool(v.Kick)
			net.WriteBool(v.Rank)
			net.WriteBool(v.MoTD)
			net.WriteBool(v.CanCapture)
			net.WriteBool(v.CanDiplomacy)
			rankref[v.RankName] = v.RankName
		end

		net.WriteUInt(#members, 9)

		for k, v in ipairs(members) do
			net.WriteString(v.SteamID)
			net.WriteString(v.Name or translates.Get('Неизвестный'))
			net.WriteString(rankref[v.Rank] or ranks[#ranks].Rank) -- fix for players being a rank that doesnt exist
		end

		net.Send(pl)
	end)
end)

rp.AddCommand('/quitorg', function(pl, text, args)
	if not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms then return end

	local _org = pl:GetOrg()

	if (not rp.orgs.cached[_org]) then
		rp.orgs.GetMembers(_org)
	end

	if (pl:GetOrgData().Rank == "Stuck") and (not pl:IsRoot()) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgYouAreStuck'))

		return
	end

	local steamid = pl:SteamID64()

	-- EASTER EGGS
	if pl:GetOrgData().Perms.Owner then
		DoLog(LogActions.Remove, steamid, _org)
		rp.orgs.Remove(_org)
	else
		rp.orgs.Quit(steamid, function()
			rp.orgs.cached[_org].Members[steamid] = nil
			rp.Notify(rp.orgs.GetOnlineMembers(_org), NOTIFY_ERROR, rp.Term('OrgPlayerQuit'), pl, pl:GetOrg())
			pl:SetOrg(nil, nil)
			pl:SetOrgData(nil)

			DoLog(LogActions.Quit, steamid, _org)
		end)
	end
end)

rp.AddCommand('/orgkick', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Kick or pl:GetOrgData().Perms.Kick == 0 or not rp.orgs.CanTarget(pl, args[1]) then return end

	local sid = args[1]
	local target = rp.FindPlayer(sid)
	DoLog(LogActions.Kick, pl:SteamID64(), pl:GetOrg(), (IsValid(target) and target:SteamID64() or args[1]))

	rp.orgs.cached[pl:GetOrg()].Members[args[1]] = nil
	rp.orgs.Kick(args[1])
end)

rp.AddCommand('/orginvite', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Invite or pl:GetOrgData().Perms.Invite == 0 then return end
	local targ = rp.FindPlayer(args[1])
	if (targ:GetOrg()) then return end

	if (not rp.orgs.cached[pl:GetOrg()]) then
		rp.orgs.GetMembers(pl:GetOrg())
	end

	local org = pl:GetOrg()

	rp.orgs.GetMemberCount(org, function(count)
		if (not IsValid(pl)) then return end
		local lim = rp.cfg.CustomOrgSlots[pl:SteamID()] or rp.cfg.CustomOrgSlots[pl:GetOrg()] || (pl:HasUpgrade('org_prem') and 500 or 50)

		if (count >= lim) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgMemberLimit'), lim)

			return
		end

		if not IsValid(targ) then return end

		rp.Notify(pl, NOTIFY_GREEN, rp.Term("OrgMemberInvite"), targ:Name())
		GAMEMODE.ques:Create(org.."?", "orginvite|"..( util.CRC(pl:SteamID() .. targ:SteamID()) ), targ, 60, function(resp)
			if (tobool(resp) == true) then
				db:Query("SELECT * FROM org_rank WHERE Org=? AND Weight=1;", pl:GetOrg(), function(data)
					rp.orgs.Join(targ:SteamID64(), org, data[1].RankName, function()
						targ:SetOrg(org, pl:GetOrgColor())

						local orgdata = {
							Rank = data[1].RankName,
							MoTD = pl:GetOrgData().MoTD,
							Perms = {
								Weight = data[1].Weight,
								Owner = (data[1].Weight == 100),
								Invite = data[1].Invite,
								Kick = data[1].Kick,
								Rank = data[1].Rank,
								MoTD = data[1].MoTD, 
								CanCapture = data[1].CanCapture, 
								CanDiplomacy = data[1].CanDiplomacy
							}
						}

						targ:SetOrgData(orgdata)

						rp.orgs.cached[pl:GetOrg()].Members[targ:SteamID64()] = {
							SteamID = targ:SteamID64(),
							Org = org,
							Rank = data[1].RankName
						}

						rp.Notify(rp.orgs.GetOnlineMembers(targ:GetOrg()), NOTIFY_GREEN, rp.Term('OrgMemberJoined'), targ, targ:GetOrg())
					end)
				end)
			else
				rp.Notify(pl, NOTIFY_ERROR, rp.Term("OrgMemberInviteDismiss"), targ:Name())
			end
		end)
	end)
end)

rp.AddCommand('/orgsetrank', function(pl, text, args)
	if not args[1] or not pl:GetOrg() or not pl:GetOrgData() or not pl:GetOrgData().Perms or not pl:GetOrgData().Perms.Rank or pl:GetOrgData().Perms.Rank == 0 or not rp.orgs.CanTarget(pl, args[1]) then return end
	local rankName = args[2]
	local cache = rp.orgs.cached[pl:GetOrg()].Ranks
	if (not cache[rankName] or pl:GetOrgData().Perms.Weight <= cache[rankName].Weight) then return end

	db:Query('SELECT * FROM org_rank WHERE Org=?', pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				db:Query("UPDATE org_player SET Rank=? WHERE SteamID=?;", rankName, args[1])
				local targ = rp.FindPlayer(args[1])

				if (targ) then
					local od = targ:GetOrgData()

					targ:SetOrgData({
						Rank = v.RankName,
						MoTD = od.MoTD,
						Perms = {
							Weight = v.Weight,
							Owner = (v.Weight == 100),
							Invite = v.Invite,
							Kick = v.Kick,
							Rank = v.Rank,
							MoTD = v.MoTD,
							CanCapture = v.CanCapture, 
							CanDiplomacy = v.CanDiplomacy
						}
					})

					rp.Notify(targ, NOTIFY_GENERIC, rp.Term('OrgYourRank'), pl, rankName)
					rp.Notify(pl, NOTIFY_GENERIC, rp.Term('OrgSetRank'), targ, rankName)
				else
					rp.Notify(pl, NOTIFY_GENERIC, rp.Term('OrgSetRank'), args[1], rankName)
				end

				rp.orgs.cached[pl:GetOrg()].Members[args[1]].Rank = rankName

				DoLog(LogActions.SetRank, pl:SteamID64(), pl:GetOrg(), (IsValid(targ) and targ:SteamID64() or args[1]) ..">".. rankName)

				return
			end
		end

		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgUnknownRank'), rankName)
	end)
end)

rp.AddCommand('/orgrank', function(pl, text, args)
	local perms = pl:GetOrg() and pl:GetOrgData() and pl:GetOrgData().Perms
	if (not args[1] or not perms or not perms.Owner or perms.Owner == 0) then return end

	if (not rp.orgs.cached[pl:GetOrg()]) then
		rp.orgs.GetMembers(pl:GetOrg())
	end

	local rankName = args[1]
	local newName
	local weight
	local invite
	local kick
	local rank
	local motd
	local ccapture
	local cdiplomacy

	local badChar = findBadCharacter(rankName)
	if badChar then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RPNameUnallowed'), badChar)
		
		return
	end

	if (args[7]) then
		weight = tonumber(args[2])
		invite = args[3]
		kick = args[4]
		rank = args[5]
		motd = args[6]
		ccapture = args[7]
		cdiplomacy = args[8]
	else
		newName = args[2]
	end

	db:Query('SELECT * FROM org_rank WHERE Org=?', pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				if (newName) then
					db:Query("UPDATE org_rank SET RankName=? WHERE Org=? AND RankName=?", newName, pl:GetOrg(), rankName, function()
						db:Query("UPDATE org_player SET Rank=? WHERE Org=? AND Rank=?;", newName, pl:GetOrg(), rankName)
						rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgRankRename'), rankName, newName)

						for k, v in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
							if (v:GetOrgData().Rank == rankName) then
								local orgData = v:GetOrgData()
								orgData.Rank = newName
								v:SetOrgData(orgData)
							end
						end

						for k, v in pairs(rp.orgs.cached[pl:GetOrg()].Members) do
							if (v.Rank == rankName) then
								v.Rank = newName
							end
						end

						rp.orgs.cached[pl:GetOrg()].Ranks[newName] = rp.orgs.cached[pl:GetOrg()].Ranks[rankName]
						rp.orgs.cached[pl:GetOrg()].Ranks[newName].RankName = newName
						rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = nil
					end)

					return
				end

				if (weight ~= v.Weight) then
					if (v.Weight == 100 or v.Weight == 1) then
						rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgReorderLimit'))

						return
					end

					v.Weight = weight
					rp.orgs.RecalculateWeights(pl:GetOrg(), ranks)

					return
				end

				db:Query("UPDATE org_rank SET Invite=?, Kick=?, Rank=?, MoTD=?, CanCapture=?, CanDiplomacy=? WHERE Org=? AND RankName=?;", invite, kick, rank, motd, ccapture, cdiplomacy, pl:GetOrg(), rankName, function()
					rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgRankUpdated'), rankName)

					for k, v in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
						if (v:GetOrgData().Rank == rankName) then
							v:SetOrgData({
								Rank = rankName,
								MoTD = v:GetOrgData().MoTD,
								Perms = {
									Weight = weight,
									Owner = (weight == 100),
									Invite = tobool(invite),
									Kick = tobool(kick),
									Rank = tobool(rank),
									MoTD = tobool(motd), 
									CanCapture = tobool(ccapture), 
									CanDiplomacy = tobool(cdiplomacy)
								}
							})
						end
					end

					local cache = rp.orgs.cached[pl:GetOrg()].Ranks[rankName]
					cache.Invite = tobool(invite)
					cache.Kick = tobool(kick)
					cache.Rank = tobool(rank)
					cache.MoTD = tobool(motd)
					cache.CanCapture = tobool(ccapture)
					cache.CanDiplomacy = tobool(cdiplomacy)
				end)

				return
			end
		end

		--rp.Notify(pl, NOTIFY_ERROR, '2'))
		
		-- Insert time!
		local lim = rp.cfg.CustomOrgRanksCount[pl:SteamID()] or rp.cfg.CustomOrgRanksCount[pl:GetOrg()] || (pl:HasUpgrade('org_prem') and 16 or 5)

		if (#ranks >= lim) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgMaxRanks'))

			return
		end

		--rp.Notify(pl, NOTIFY_ERROR, '3'))
		
		db:Query("INSERT INTO org_rank(Org, RankName, Weight, Invite, Kick, Rank, MoTD, CanCapture, CanDiplomacy) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);", pl:GetOrg(), rankName, weight, invite, kick, rank, motd, ccapture, cdiplomacy, function()
			rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = ranks[table.insert(ranks, {
				Org = pl:GetOrg(),
				RankName = rankName,
				Weight = weight,
				Invite = tobool(invite),
				Kick = tobool(kick),
				Rank = tobool(rank),
				MoTD = tobool(motd), 
				CanCapture = tobool(ccapture), 
				CanDiplomacy = tobool(cdiplomacy)
			})]

			rp.orgs.RecalculateWeights(pl:GetOrg(), ranks)
			rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgRankCreated'), rankName)
		end)
	end)
end)

rp.AddCommand('/orgrankremove', function(pl, text, args)
	local perms = pl:GetOrg() and pl:GetOrgData() and pl:GetOrgData().Perms
	if (not args[1] or not perms or not perms.Owner or perms.Owner == 0) then return end

	if (not rp.orgs.cached[pl:GetOrg()]) then
		rp.orgs.GetMembers(pl:GetOrg())
	end

	local rankName = args[1]

	db:Query("SELECT * FROM org_rank WHERE Org=? ORDER BY Weight DESC", pl:GetOrg(), function(ranks)
		for k, v in ipairs(ranks) do
			if (v.RankName == rankName) then
				if (k == 1 or k == #ranks) then
					rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgDeleteLimit'))

					return
				end

				local nextRank = ranks[k + 1]
				db:Query("UPDATE org_player SET Rank=? WHERE Org=? AND Rank=?", nextRank.RankName, pl:GetOrg(), rankName)
				db:Query("DELETE FROM org_rank WHERE Org=? AND RankName=?", pl:GetOrg(), rankName)

				for _, pl in ipairs(rp.orgs.GetOnlineMembers(pl:GetOrg())) do
					local od = pl:GetOrgData()

					if (od.Rank == rankName) then
						od = {
							Rank = nextRank.RankName,
							MoTD = od.MoTD,
							Perms = {
								Weight = nextRank.Weight,
								Owner = (nextRank.Weight == 100),
								Invite = nextRank.Invite,
								Kick = nextRank.Kick,
								Rank = nextRank.Rank,
								MoTD = nextRank.MoTD, 
								CanCapture = nextRank.CanCapture, 
								CanDiplomacy = nextRank.CanDiplomacy
							}
						}

						pl:SetOrgData(od)
					end
				end

				for _, mem in pairs(rp.orgs.cached[pl:GetOrg()].Members) do
					if (mem.Rank == rankName) then
						mem.Rank = nextRank.Name
					end
				end

				rp.orgs.cached[pl:GetOrg()].Ranks[rankName] = nil
				rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgRankDelete'), rankName)

				return
			end
		end

		rp.Notify(pl, NOTIFY_ERROR, rp.Term('OrgUnknownRank'), rankName)
	end)
end)

local function OrgChat(pl, text, args)
	if (pl:GetOrg() == nil) then return end
	rp.Chat(CHAT_ORG, rp.orgs.GetOnlineMembers(pl:GetOrg()), pl:GetOrgColor(), '[ORG] ', pl, table.concat(args, ' '))
end

rp.AddCommand('/org', OrgChat)
rp.AddCommand('/o', OrgChat)


local function updateOrgBanner(pl, data)
	data = data or rp.cfg.DefaultOrgBanners[math.random(#rp.cfg.DefaultOrgBanners)]
	
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('OrgBannerUpdated'))

	db:Query('REPLACE INTO org_banner (Org, Time, Data) VALUES(?, ?, ?);', pl:GetOrg(), os.time(), data, function()
		net.Start('rp.OrgBannerInvalidate')
		net.WriteString(pl:GetOrg())
		net.Broadcast()
	end)

	DoLog(LogActions.SetBanner, pl:SteamID64(), pl:GetOrg(), data)
end

net('rp.SetOrgBanner', function(len, pl)
	if (not pl:GetOrg() or not pl:GetOrgData().Perms.Owner or pl:GetOrgData().Perms.Owner == 0) then return end
	if (not pl:HasUpgrade('org_prem')) then return end

	local nw_str = net.ReadString()
	--print(nstr)
	updateOrgBanner(pl, nw_str)
end)

net('rp.SetOrgBannerDefault', function(len, pl)
	if (not pl:GetOrg() or not pl:GetOrgData().Perms.Owner or pl:GetOrgData().Perms.Owner == 0) then return end

	local nw_uint = net.ReadUInt(8)
	--print(nw_uint, rp.cfg.DefaultOrgBanners[nw_uint])
	updateOrgBanner(pl, rp.cfg.DefaultOrgBanners[nw_uint])
end)


hook('InitPostEntity', 'rp.orgs.GetColors', function()
	db:Query('SELECT `Color`,`Name` FROM `orgs`;', function(data)
		if #data < 1 then return end
		
		for k, v in pairs(data) do
			rp.orgs.Colors[v.Name] = pcolor.FromHex(v.Color)
		end
	end)
end)

local already_sent_org_colors = {}
net('rp.orgs.GetColors', function(_, ply)
	if already_sent_org_colors[ply] then return end
	
	already_sent_org_colors[ply] = true
	
	net.Start('rp.orgs.GetColors')
		net.WriteUInt(table.Count(rp.orgs.Colors), 16)
		
		for k, v in pairs(rp.orgs.Colors) do
			net.WriteString(k)
			net.WriteColor(Color(math.floor(v.r or 0), math.floor(v.g or 0), math.floor(v.b or 0), math.floor(v.a or 255)))
		end
	net.Send(ply)
end)

hook.Add('PlayerDisconnected', 'rp.orgs.ClearOrgColorSent', function(ply)
	already_sent_org_colors[ply] = nil
end)