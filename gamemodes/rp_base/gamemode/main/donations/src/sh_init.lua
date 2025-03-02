-- "gamemodes\\rp_base\\gamemode\\main\\donations\\src\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
donations = {list = {}, methods = {}}

type_error = 1
type_generic = 0
notify = function() end

donations.menuKey = KEY_F6

local meta = FindMetaTable("Player")
function meta:getDonation(name)
	return self.donations && self.donations[name]
end

function meta:hasParent(s)
	for k, v in pairs(self.donations or {}) do
		local d = donations.get(k)
		if d.based && table.HasValue(d.based, s) then
			return k
		end
	end
	return false
end

function meta:hasBased(t)
	for k, v in pairs(self.donations or {}) do
		if table.HasValue(t, k) then
			return k
		end
	end
	return false
end

local base_donation = {}
base_donation.active = true
base_donation.name = "base donation"
base_donation.printName = "Print name"
base_donation.desc = "Description"
base_donation.giveOnce = true
base_donation.price = 0
base_donation.give = function(ply, duration, data) end
base_donation.take_notify = function(self, ply) notify(ply, type_error, 4, string.format(donations.language.purchase_ended, self.printName)) end
base_donation.notify = function(self, ply, duration, data) net.Start("donations.purchased") net.Send(ply) notify(ply, type_error, 4, string.format(donations.language.purchase_completed, self.printName)) end
base_donation.take = function(ply) end
base_donation.category = "Base category"
base_donation.buildVGUI = function(self, parent) return false end
base_donation.loadData = function(self) return nil end
base_donation.priceFunc = function(self, ply, data) return false end
base_donation.saveData = function(self, data) return data && sql.SQLStr(data) or "NULL" end
base_donation.loadSQLData = function(self, data) return data end
base_donation.send = function(self, method, duration_id)
	net.Start("donations.buy")
		net.WriteString(self.name)
		net.WriteInt(method.id, 8)
		if duration_id then
			net.WriteInt(duration_id, 8)
		end
	net.SendToServer()
end

local base_method = {}
base_method.name = "Yandex money"
base_method.onClick = function(self, donation, duration, data)
	donation:send(self, duration && duration.id, data)
end
base_method.proceedPayment = function(ply, donation, duration_id, id)
end

function donations.newMethod()
	return table.Copy(base_method)
end

function donations.addMethod(t)
	t.id = table.insert(donations.methods, t)
end

function donations.add(t)
	local id = table.insert(donations.list, t)
	for k, v in pairs(t.duration or {}) do
		v.id = k
		if v.active == nil then v.active = true end
	end
	return id
end

function donations.new()
	return table.Copy(base_donation)
end

function donations.get(s)
	for k, v in pairs(donations.list) do
		if v.name == s then return v end
	end
end

function donations.getMethod(n)
	return donations.methods[n]
end

function donations.getMethodByName(n)
	for k, v in pairs(donations.methods) do
		if v.method == n then
			return v
		end
	end
end



-- SkinsPay multiplayer:
hook.Add("rpBase.Loaded", "SkinsPlayMult", function()

	nw.Register'SkinsDonateMultiplayer':Write(net.WriteFloat):Read(net.ReadFloat):SetGlobal()  			-- MULT
	nw.Register'SkinsDonateMultiplayerTime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal() -- TIME

	function rp.GetSkinsDonateMultiplayer()
		return nw.GetGlobal('SkinsDonateMultiplayer') or 1
	end

	function rp.GetSkinsDonateMultiplayerTime()
		return nw.GetGlobal('SkinsDonateMultiplayerTime') or 0
	end

	function rp.SetSkinsDonateMultiplayer(mult, time, minimum, save)
		nw.SetGlobal('SkinsDonateMultiplayerTime', time + (save and os.time() or 0))
		nw.SetGlobal('SkinsDonateMultiplayer', mult)

		if SERVER and save then donations.SaveMultiplayer(0, time, mult, 0) end
	end

	ba.cmd.Create("setskinsdonatemultiplayer", function(pl, args)
		if !tonumber(args.multiplier) then return end
		
		local bonus = math.Round(tonumber(args.multiplier) / 100)
		
		if bonus < 0.1 or bonus > 20 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantCreateSkinsDonateMultiplayer'))
			return
		end
		
		local time 	= args.time
		
		ba.logAction(pl, tostring(bonus), 'skinsdonate_multiplayer', tostring(time))
		
		rp.SetSkinsDonateMultiplayer(bonus, time, nil, true)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term("SkinsDonateMultiplayerSuccess"), bonus, ba.str.FormatTime(time))
	end)
	:AddParam('string', 'multiplier')
	:AddParam('time', 'time')
	:SetFlag('*')
	:SetHelp(translates.Get('Устанавливает множитель пополнения скинами'))


	-- Та же херня, только глобальная (работает при любом из методов пополнения)

	nw.Register'DonateMultiplayer':Write(net.WriteFloat):Read(net.ReadFloat):SetGlobal()  			-- MULT
	nw.Register'DonateMultiplayerTime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()  -- TIME
	nw.Register'DonateMultiplayerMinimum':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()

	local TwoDays = 60*60*24*2
	local FourDays = TwoDays*2

	function PLAYER:GetPersonalDonateMultiplayer()
		local first = self:GetNetVar("FirstJoinTime") or os.time()
		first = os.time() - first
		return first >= TwoDays and first <= FourDays and 1.5 or 1
	end

	function PLAYER:GetPersonalDonateMultiplayerTime()
		local first = self:GetNetVar("FirstJoinTime") or os.time()
		first = os.time() - first
		return first >= TwoDays and first <= FourDays and FourDays - first or 0
	end

	function rp.GetDonateMultiplayer(ply)
		local mult = nw.GetGlobal('DonateMultiplayer') or 1
		if not ply then return mult end

		return mult--math.max(mult, ply:GetPersonalDonateMultiplayer())
	end

	function rp.GetDonateMultiplayerTime(ply)
		return nw.GetGlobal('DonateMultiplayerTime') or 0
	end

	function rp.GetDonateMultiplayerMinimum()
		return nw.GetGlobal("DonateMultiplayerMinimum") or 0
	end

	function rp.SetDonateMultiplayer(mult, time, minimum, save)
		nw.SetGlobal('DonateMultiplayerTime', time + (save and os.time() or 0))
		nw.SetGlobal('DonateMultiplayer', mult)

		nw.SetGlobal('DonateMultiplayerMinimum', minimum or 0)

		if SERVER and save then donations.SaveMultiplayer(1, time, mult, minimum) end
	end

	ba.cmd.Create("setdonatemultiplayer", function(pl, args)
		if !tonumber(args.multiplier) then return end
		
		local bonus = math.Round(tonumber(args.multiplier) / 100)
		
		if bonus < 0.1 or bonus > 20 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantCreateDonateMultiplayer'))
			return
		end
		
		local time 	= args.time
		
		ba.logAction(pl, tostring(bonus), 'donate_multiplayer', tostring(time))
		
		rp.SetDonateMultiplayer(bonus, time, tonumber(args.minimum), true)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term("DonateMultiplayerSuccess"), bonus * 100, ba.str.FormatTime(time))
	end)
	:AddParam('string', 'multiplier')
	:AddParam('time', 'time')
	:AddParam('string', 'minimum', "optional")
	:SetFlag('*')
	:SetHelp(translates.Get('Устанавливает множитель пополнения (для любого метода пополнения)'))

end)