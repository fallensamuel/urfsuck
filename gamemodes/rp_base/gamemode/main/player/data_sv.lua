rp.data = rp.data or {}
local db = rp._Stats

util.AddNetworkString('rp.PlayerDataLoaded')

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

hook.Add("InitPostEntity", "rp.InitSqlTables", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `custom_toolguns` (`SteamID` bigint(20) NOT NULL, `Active` int(1) NOT NULL, `Class` varchar(32) CHARACTER SET utf8 NOT NULL, PRIMARY KEY (`SteamID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `custom_physguns` (`SteamID` bigint(20) NOT NULL, `Active` int(1) NOT NULL, `Class` varchar(32) CHARACTER SET utf8 NOT NULL, PRIMARY KEY (`SteamID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
end)


function rp.data.LoadPlayer(pl, cback)
	db:Query('SELECT * FROM player_data WHERE SteamID=' .. pl:SteamID64() .. ';', function(_data)
		local data = _data[1] or {}

		if IsValid(pl) then
			local name = escapeName(pl:SteamName())
			
			if (#_data <= 0) then
				db:Query('INSERT INTO player_data(SteamID, Name, Money, Karma, Pocket, Unlocked) VALUES(?, ?, ?, ?, ?, ?);', pl:SteamID64(), name, rp.cfg.StartMoney, rp.cfg.StartKarma, '{}', '{}')
				
				if rp.syncHours and rp.syncHours.db and rp.syncHours.db.Query then
					rp.syncHours.db:Query('SELECT name FROM player_names WHERE steamid=' .. pl:SteamID64() .. ';', function(__data)
						if __data and __data[1] then
							pl:SetRPName(__data[1].name, true)
						else
							pl:SetRPName(rp.names.Random(), true)
						end
					end)
				else
					pl:SetRPName(rp.names.Random(), true)
				end
			end

			if data.Name and (data.Name ~= name) then
				pl:SetNetVar('Name', data.Name)
			end

			db:Query('SELECT * FROM player_hats WHERE SteamID=' .. pl:SteamID64() .. ';', function(data)
				nw.WaitForPlayer(pl, function()
					local HatData = {}

					for k, v in ipairs(data) do
						HatData[k] = v.Model

						if (tonumber(v.Active) == 1) then
							pl:SetHat(v.Model)
						end
					end

					pl:SetNetVar('HatData', HatData)
				end)
			end)

			db:Query('SELECT * FROM custom_toolguns WHERE SteamID=' .. pl:SteamID64() .. ';', function(data)
				nw.WaitForPlayer(pl, function()
					local ToolgunData = {}

					for k, v in ipairs(data) do
						ToolgunData[k] = v.Class

						if (tonumber(v.Active) == 1) then
							pl:SetCustomToolgun(v.Class)
						end
					end

					pl:SetNetVar("ToolgunData", ToolgunData)
				end)
			end)

			db:Query('SELECT * FROM custom_physguns WHERE SteamID=' .. pl:SteamID64() .. ';', function(data)
				nw.WaitForPlayer(pl, function()
					for k, v in ipairs(data or {}) do
						if (tonumber(v.Active) == 1) then
							pl:SetCustomPhysgun(v.Class)
							break
						end
					end
				end)
			end)
			
			nw.WaitForPlayer(pl, function()
				pl:SetNetVar('Money', data.Money or rp.cfg.StartMoney)
				pl:SetNetVar('Karma', data.Karma or rp.cfg.StartKarma)

				local succ, tbl = pcall(pon.decode, data.Unlocked)

				if (not istable(tbl)) then
					pl:SetNetVar('JobUnlocks', {})
				else
					pl:SetNetVar('JobUnlocks', tbl)
				end

				local succ, tbl = pcall(pon.decode, data.Pocket)

				if (not istable(tbl)) then
					rp.inv.Data[pl:SteamID64()] = {}
				else
					rp.inv.Data[pl:SteamID64()] = tbl
				end
				
				for k, v in pairs(rp.inv.Data[pl:SteamID64()]) do
					if v.contents then
						if !rp.shipments[v.contents] then
							rp.inv.Data[pl:SteamID64()][k] = nil
						end
					end
				end

				pl:SetNetVar('Karma', data.Karma or rp.cfg.StartKarma)
				pl:SetVar('lastpayday', CurTime() + 180, false, false)
				pl:SendInv()
				pl:SetVar('DataLoaded', true)
				hook.Call('PlayerDataLoaded', GAMEMODE, pl, data)
				
				net.Start('rp.PlayerDataLoaded')
				net.Send(pl)
			end)

			if cback then
				cback(data)
			end
		end
	end)
end

function GM:PlayerAuthed(pl)
	rp.data.LoadPlayer(pl)
end

function rp.data.SetName(pl, name, cback)
	db:Query('UPDATE player_data SET Name=? WHERE SteamID=' .. pl:SteamID64() .. ';', name, function(data)
		if rp.syncHours and rp.syncHours.db and rp.syncHours.db.Query then
			rp.syncHours.db:Query('REPLACE INTO player_names SET name=?, steamid=' .. pl:SteamID64() .. ';', name, function()
				pl:SetNetVar('Name', name)

				if cback then
					cback(data)
				end
			end)
		end
	end)
end

function rp.data.GetNameCount(name, cback)
	db:Query('SELECT COUNT(*) as `count` FROM player_data WHERE Name=?;', name, function(data)
		if cback then
			cback(tonumber(data[1].count) > 0)
		end
	end)
end

function rp.data.SetMoney(pl, amount, cback)
	db:Query('UPDATE player_data SET Money=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
end

hook.Add("CheckValidMoneyTransfer", "CheckAmount", function(pl1, pl2, amount, cback)
	rp._Stats:Query('SELECT COALESCE(SUM(`value`), 0) AS `Money` FROM `ba_logs` WHERE `action` = "money_trans" AND `value` > 0 AND `initiator` = ' .. pl1:SteamID64() .. ' AND `target` = ' .. pl2:SteamID64() .. ' AND DATE(`time`) = CURDATE();', function(data)
		local amt = data and data[1] and data[1].Money or 0
		local max_amt = rp.cfg.StartMoney * 50
		
		if amt + amount > max_amt then
			if max_amt == amt then
				cback(false, rp.Term('CantTransferMoreMoney'))
				
			else
				cback(false, rp.Term('CanTransferOnlyMoney'), rp.FormatMoney(max_amt - amt))
			end
			
		else
			cback(true)
		end
	end)
end)

function rp.data.PayPlayer(pl1, pl2, amount)
	if not IsValid(pl1) or not IsValid(pl2) then return end
	
	hook.Run("CheckValidMoneyTransfer", pl1, pl2, amount, function(result)
		if result == false then return end
		
		ba.logAction(pl1, pl2, 'money_trans', '' .. amount)
		
		pl1:TakeMoney(amount)
		pl2:AddMoney(amount)
	end)
end

function rp.data.SetKarma(pl, amount, cback)
	if (pl:GetKarma() ~= amount) then
		db:Query('UPDATE player_data SET Karma=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
	end
end

function rp.data.SetPocket(steamid64, data, cback)
	db:Query('UPDATE player_data SET Pocket=? WHERE SteamID=' .. steamid64 .. ';', data, cback)
end

function ba.data.SetHat(pl, mdl, cback)
	local steamid = pl:SteamID64()

	db:Query('UPDATE player_hats Set Active=0 WHERE SteamID=' .. steamid .. ';', function()
		if (mdl ~= nil) then
			db:Query('REPLACE INTO player_hats(SteamID, Model, Active) VALUES(?, ?, 1);', steamid, mdl, function()
				if IsValid(pl) then
					pl:SetHat(mdl)
				end

				if cback then
					cback()
				end
			end) -- We assume you own it
		else
			if IsValid(pl) then
				pl:SetHat(nil)
			end

			if cback then
				cback()
			end
		end
	end)
end

function ba.data.SetCustomToolgun(ply, class, cback)
	local sid = ply:SteamID64()

	db:Query("UPDATE custom_toolguns Set Active=0 WHERE SteamID="..sid..";", function()
		if (class ~= nil) then
			db:Query('REPLACE INTO custom_toolguns(SteamID, Class, Active) VALUES(?, ?, 1);', sid, class, function()
				if IsValid(ply) then
					ply:SetCustomToolgun(class)
				end

				if cback then
					cback()
				end
			end)
		else
			if IsValid(ply) then
				ply:SetCustomToolgun(nil)
			end

			if cback then
				cback()
			end
		end
	end)
end

function ba.data.SetCustomPhysgun(ply, class, cback)
	local sid = ply:SteamID64()
	
	db:Query("UPDATE custom_physguns Set Active=0 WHERE SteamID="..sid..";", function()
		if (class ~= nil and class ~= 'nil') then
			db:Query('REPLACE INTO custom_physguns(SteamID, Class, Active) VALUES(?, ?, 1);', sid, class, function()
				if IsValid(ply) then
					ply:SetCustomPhysgun(class)
				end

				if cback then
					cback()
				end
			end)
		else
			if IsValid(ply) then
				ply:SetCustomPhysgun()
			end

			if cback then
				cback()
			end
		end
	end)
end

function rp.data.IsLoaded(pl)
	if IsValid(pl) and (pl:GetVar('DataLoaded') ~= true) then
		file.Append('data_load_err.txt', os.date() .. '\n' .. pl:Name() .. '\n' .. pl:SteamID() .. '\n' .. pl:SteamID64() .. '\n' .. debug.traceback() .. '\n\n')
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('DataNotLoaded'))

		return false
	end

	return true
end

hook('InitPostEntity', 'data.InitPostEntity', function()
	db:Query('UPDATE player_data SET Money=' .. rp.cfg.StartMoney .. ' WHERE Money <' .. rp.cfg.StartMoney / 2)
end)

--
--	Meta
--
local math = math

function PLAYER:AddMoney(amount)
	if not rp.data.IsLoaded(self) then return end
	local total = self:GetMoney() + math.floor(amount)
	rp.data.SetMoney(self, total)
	self:SetNetVar('Money', total)
end

function PLAYER:TakeMoney(amount)
	self:AddMoney(-math.abs(amount))
end

function PLAYER:AddKarma(amount, cback)
	if not rp.data.IsLoaded(self) then return end
	local add = hook.Call('PlayerGainKarma', GAMEMODE, self)
	if (add == false) then return add end

	if cback then
		cback(amount)
	end

	local total = math.Clamp(self:GetKarma() + math.floor(amount), 0, 100)
	rp.data.SetKarma(self, total)
	self:SetNetVar('Karma', total)
end

function PLAYER:TakeKarma(amount)
	self:AddKarma(-math.abs(amount))
end

function PLAYER:AddPlayTime(amount)
	self:SetNetVar('PlayTime', self:GetNetVar('PlayTime') + amount)
	ba.data.UpdatePlayTime(self)
end

function PLAYER:GiveArmor(amt)
	self:SetArmor(math.min(self:Armor() + amt, rp.cfg.MaxArmor))
end

function PLAYER:GiveHealth(amt)
	self:SetHealth(math.min(self:Health() + amt, rp.cfg.MaxHealth))
end

function PLAYER:AddMaxHealth(amt)
	self:SetMaxHealth(math.min(self:GetMaxHealth() + amt, rp.cfg.MaxHealth))
	self:GiveHealth(amt)
end