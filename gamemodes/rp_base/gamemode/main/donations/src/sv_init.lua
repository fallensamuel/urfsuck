util.AddNetworkString("donations.url")
require( "mysqloo" )

local donate_info = include(engine.ActiveGamemode() .. '/gamemode/donate_db.lua')

--local server_name = "ww2" // должно быть уникально для каждого сервера. не должно меняться в процессе работы
local secret_url = "https://urf.im/donations/secret.php"
local db = mysqloo.connect( "mysql.urf.im", donate_info.user, donate_info.password, "darkrp", 3306)
--local db = mysqloo.connect( "mysql.urf.im", "donations", "8wd0WXoKZsH11qaY", "darkrp", 3306)


--server_name = sql.SQLStr(server_name)

function donations.getServerName()
	return sql.SQLStr(rp.cfg.ServerUID)
end

local queue = {} 

function db:onConnected()
	for k, v in pairs( queue ) do
		query( v[ 1 ], v[ 2 ] )
	end
	queue = {}

	donations.connected()
end

function db:onConnectionFailed( err )

    print( "Connection to database failed!" )
    print( "Error:", err )
end
 
db:connect()

local function query( sql, callback, err_callback )
	local q = db:query( sql )
	if !q then table.insert( queue, { sql, callback } ) db:connect() return end
	
	function q:onSuccess( data )
		if callback then
			callback( data )
		end
	end

	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then

			table.insert( queue, { sql, callback } )
			db:connect()
			return
		end

		print( "Query Errored, error:", err, " sql: ", sql )
		
		if err_callback then
			err_callback()
		end
	end

	q:start()
end

function donations.createInvoice(ply, method, donation, duration, data, price, func)
	local id = os.time()

	query("INSERT INTO donation_invoices(method, id, steamid, name, duration, created, server_name, data, price) VALUES("..sql.SQLStr(method)..", "..sql.SQLStr(id)..", "..sql.SQLStr(ply:SteamID())..", "..sql.SQLStr(donation.name)..", "..sql.SQLStr(duration && duration.id or -1)..", NOW(), "..donations.getServerName()..", "..donation:saveData(data) ..", "..price..")", function()
		if !IsValid(ply) then return end
		func(ply, donation, duration, id, price)
	end)
end

--function secret(invoice_id, price, f)
--	http.Post(secret_url, {id = tostring(invoice_id), price = tostring(price)}, f)
--end

local plyMeta = FindMetaTable("Player")
function plyMeta:setRank(s)
	ULib.ucl.addUser(self:SteamID(), nil, nil, s)
end

function plyMeta:takeDonation(name)
	local donation = type(name) == 'table' && name || donations.get(name)
	donation:take_notify(self)
	donation:take(self)
	self.donations[donation.name] = nil


	self:syncDonations()
	self:saveDonations()
end

function plyMeta:addDonation(name, duration_id, data, method, id)
 
	local donation = donations.get(name)
 
	if data then data = donation:loadSQLData(data) end

	local donatemult_bool2 = not rp or not rp.GetDonateMultiplayerMinimum or rp.GetDonateMultiplayerMinimum() <= 0 or tonumber(data) >= rp.GetDonateMultiplayerMinimum()
	if (rp and rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime(self) >= os.time() and donatemult_bool2) or (self.GetPersonalDonateMultiplayerTime and self:GetPersonalDonateMultiplayerTime() > 0) then
		local isstr = isstring(data)
		if isstr then data = tonumber(data) end

		local global, personal = donatemult_bool2 and rp.GetDonateMultiplayer(self) or 1, self:GetPersonalDonateMultiplayer(self) or 1
		data = data * math.max(global, personal, 1)
		if isstr then data = tostring(data) end
	elseif method == "skinpay" and rp and rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime(self) >= os.time() then
		local isstr = isstring(data)
		if isstr then data = tonumber(data) end
		data = data * (rp and rp.GetSkinsDonateMultiplayer(self) or 1)
		if isstr then data = tostring(data) end
	end
 
	if donation.duration then
		local duration = donation.duration[duration_id].duration == 0 && 0 || os.time() + donation.duration[duration_id].duration
 
		local based = donation.based && self:hasBased(donation.based)
		if based then
			local basedName = based
			based = donations.get(based)
 
			self.donations[name] = nil
			based:take(ply, data)
 
			donation:give(self, duration, data, id)
			donation:notify(self, duration, data)
		elseif self.donations[name] then
			duration = duration != 0 && (self.donations[name] + duration - os.time()) || 0
			donation:take(self, data)
			donation:give(self, duration, data, id)
			donation:notify(self, duration, data)
		else
			donation:give(self, duration, data, id)
			donation:notify(self, duration, data)
		end
 
		self.donations[name] = duration
	else
		donation:notify(self, duration, data)
		donation:give(self, duration, data, id)
	end
 
	self:syncDonations()
	self:saveDonations()
end

function plyMeta:saveDonations(save)
	query("DELETE FROM donation_users WHERE server_name = "..donations.getServerName().." && steamid = "..sql.SQLStr(self:SteamID())..";", function()
		query("INSERT INTO donation_users VALUES("..sql.SQLStr(self:SteamID())..", "..sql.SQLStr(util.TableToJSON(self.donations))..", "..donations.getServerName()..")")
	end)
end

util.AddNetworkString("donations.purchased")
util.AddNetworkString("donations.sync")
function plyMeta:syncDonations()
	net.Start("donations.sync")
		net.WriteTable(self.donations)
	net.Send(self)
end

local function findPlayer(steamid)
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == steamid then return v end
	end
end

function donations.connected()
	query("CREATE TABLE IF NOT EXISTS donation_invoices(id INT NOT NULL PRIMARY KEY, steamid VARCHAR(20), name VARCHAR(20), price INT(10), duration TINYINT(10), method VARCHAR(20), paid BOOL DEFAULT '0', given BOOL DEFAULT '0', created TIMESTAMP, updated_at TIMESTAMP, server_name VARCHAR(20), data TEXT)")
	query("CREATE TABLE IF NOT EXISTS donation_users(steamid VARCHAR(20), data TEXT, server_name VARCHAR(20))")

	local temp_queries = {}
	
	timer.Create("donations.timer", 5, 0, function()
		query("SELECT * FROM donation_invoices WHERE paid = '1' AND given = '0' AND server_name = "..donations.getServerName()..";", function(data)
			for k, v in pairs(data or {}) do
				if temp_queries[v.id] then continue end
				
				local ply = findPlayer(v.steamid)
				if !ply then continue end
				
				ply.donations = ply.donations or {}

				if donations.get(v.name) then
					temp_queries[v.id] = true

					query("UPDATE donation_invoices SET given = '1' WHERE steamid = "..sql.SQLStr(ply:SteamID()).." AND id = "..sql.SQLStr(v.id).." AND server_name = "..donations.getServerName()..";", function(data)
						ply:addDonation(v.name, v.duration, v.data, v.method, v.id)
						temp_queries[v.id] = nil
						
					end, function()
						temp_queries[v.id] = nil
					end)
				end
			end
		end)
	end)
end

util.AddNetworkString("donations.buy")
net.Receive("donations.buy", function(len, ply)
	local donation = donations.get(net.ReadString())
	local method = donations.getMethod(net.ReadInt(8))

	if !(donation && method && donation.active) then return end

	local duration
	if donation.duration && donation.duration[1] then
		local duration_id = net.ReadInt(8)
		duration = donation.duration[duration_id]
		if !duration then return end
		if !duration.active then return end
	end

	method:proceedPayment(ply, donation, duration)	
end)
