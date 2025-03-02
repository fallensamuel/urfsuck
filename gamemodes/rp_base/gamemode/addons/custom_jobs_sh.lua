-- "gamemodes\\rp_base\\gamemode\\addons\\custom_jobs_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
customJobs = customJobs or {}

local var_cache = {}
var_cache["tostring"] = tostring
var_cache["istable"] = istable
var_cache["pairs"] = pairs
var_cache["util.SteamIDTo64"] = util.SteamIDTo64
var_cache["util.SteamIDFrom64"] = util.SteamIDFrom64

function rp.PlayerHasAccessToCustomJob(key, steamid)
	steamid = var_cache["tostring"](steamid)
	
	if var_cache["istable"](key) then
		for k, v in var_cache["pairs"](key) do
			--print(v)
			if customJobs[v] and customJobs[v][steamid] then return true end
		end
	else
		return customJobs[key] and customJobs[key][steamid] or false
	end
end

local function WorkAddAccess(key, v)
	local steamid = var_cache["tostring"](v)

	local id = var_cache["util.SteamIDTo64"](steamid) ~= "0" and var_cache["util.SteamIDTo64"](steamid) or var_cache["util.SteamIDFrom64"](steamid) ~= "STEAM_0:0:0" and var_cache["util.SteamIDFrom64"](steamid) or steamid
	customJobs[key] = customJobs[key] or {}
	customJobs[key][steamid] = true
	customJobs[key][id] = true
end

function rp.PlayerAddAccessToCustomJob(key, steamids)
	if istable(steamids) then
		for k, v in pairs(steamids) do
			WorkAddAccess(key, v)
		end
	else
		WorkAddAccess(key, steamids)
	end
end

nw.Register("CustomJobsAccess")
:Write(function(tbl)
	net.WriteUInt(table.Count(tbl), 16)

	for k in pairs(tbl) do
		net.WriteUInt(k, 16)
	end
end):Read(function()
	if SERVER then return end

	local sid64, sid = LocalPlayer():SteamID64(), LocalPlayer():SteamID()

	for i = 1, net.ReadUInt(16) do
		local id = net.ReadUInt(16)
		local jtab = rp.teams[id]
		if not (jtab and jtab.command) then continue end
		local uid = jtab.command

		customJobs[uid] = customJobs[uid] or {}

		customJobs[uid][sid64] = true
		customJobs[uid][sid] = true
	end
end)
:SetLocalPlayer()

CustomUnlockTeams = CustomUnlockTeams or {}
function rp.RegisterCustomUnlockTeam(jindex, canAfford, onBuy, priceStrings)
	local jtab = rp.teams[jindex]
	assert(jtab ~= nil, "<1 param> должен быть индексом профессии (вроде TEAM_CITIZEN)")
	assert(jtab.command ~= nil, "<1 param> невалидная профессия! Пропишите command в таблицу профессии!")

	local command = jtab.command

	CustomUnlockTeams[command] = {
		canAfford = canAfford,
		onBuy = function(ply)
			onBuy(ply)
			rp.PlayerAddPermaAccessToCustomJobNetworked(command, ply:SteamID64())
		end,
		priceStrings = priceStrings,
	}

	jtab.customCheck = function(ply)
        return rp.PlayerHasAccessToCustomJob(command, ply:SteamID64())
    end
    jtab.CustomCheckFailMsgVisible = true
    jtab.CustomCheckFailMsg = priceStrings.CustomCheckFailMsg
end

--[[
rp.RegisterCustomUnlockTeam(TEAM_CITIZEN, function(ply)
	return ply:HasPoints(100)
end, function(ply)
	ply:TakePoints(100)
end, {
	cantAfford = "У ВАС НЕДОСТАТОЧНО БАЛЛОВ",
	price = "СТОИМОСТЬ РАЗБЛОКИРОВКИ: 100 БАЛЛОВ"
})
]]--

function PLAYER:TeamCustomUnlocked(key)
	return not CustomUnlockTeams[key] or rp.PlayerHasAccessToCustomJob(key, self:SteamID64())
end

if CLIENT then
	function rp.CustomUnlockTeam(jindex)
		net.Start("rp.CustomUnlockTeam")
			net.WriteUInt(jindex, 16)
		net.SendToServer()
	end
end