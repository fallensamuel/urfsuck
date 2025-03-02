
donations.language = {
//	somethingwrong = "Something went wrong, try later.",
	purchase_completed = "Спасибо за покупку! %s добавлены на ваш счёт.",
	permanent = "Куплено навсегда.",
	extend_for = "Истекает через %s, продлить за %sр.",
	purchase_for = "Купить за %sр.",
	duration = "Сроком на %s за %sр.",
	purchase_not_avalible = "Покупка недоступна, подождите пока %s истечёт.",
	purchase_ended = "%s истек."
}

donations.menuKey = KEY_F6

/* DISCOUNT */
donations.discount = 0


/* NOTIFICATION */

type_error = 1
type_generic = 3

notify = function(ply, type, string)
	rp.Notify(ply, type, string)
	//DarkRP.notify(ply, type, duration, string)
end

/* METHODS */

local function sendURL(ply, url)
	net.Start("donations.url")
		net.WriteString(url)
	net.Send(ply)
end

local robokassa = donations.newMethod()
robokassa.name = "Робокасса (КИВИ, Карты, Телефон и пр)"
robokassa.method = "robokassa"
robokassa.proceedPayment = function(self, ply, donation, duration)
	local data = donation:loadData()
	local price = duration && duration.price or donation:priceFunc(ply, data) or donation.price
	--donations.createInvoice(ply, "robokassa", donation, duration, data, price, function(ply, donation, duration, id, price)
	--	sendURL(ply, "https://urf.im/donations/robokassa/index2.php?id="..id)
	--end)
	
	sendURL(ply, 'https://urf.im/page/shop?s=' .. string.Replace(donations.getServerName(), "'", '') .. '&sid=' .. ply:SteamID() .. '&price=' .. price .. '#purchase')
end
donations.addMethod(robokassa)

local skins = donations.newMethod()
skins.name = "Скинами из Dota 2/CS:GO"
skins.method = "skins"
skins.proceedPayment = function(self, ply, donation, duration)
	local data = donation:loadData()
	local price = duration && duration.price or donation:priceFunc(ply, data) or donation.price
	donations.createInvoice(ply, "skinpay", donation, duration, data, price, function(ply, donation, duration, id, price)
		sendURL(ply, "https://urf.im/donations/skins/index.php?orderid="..id.."&userid="..ply:SteamID64())
	end)
end
donations.addMethod(skins)

local donation = donations.new()
donation.name = "points" 
donation.notify = function(self, ply, duration, data) net.Start("donations.purchased") net.Send(ply) notify(ply, type_generic, 'Спасибо за покупку '..data..' кредитов!') end
donation.printName = "Кредиты"
donation.give = function(self, ply, duration, data, id) 
	ply:AddCredits(data, 'auto purchase (' .. os.date("%H:%M:%S - %d/%m/%Y", os.time()) .. ', id ' .. id .. ')') 
	hook.Run('SuccessfulPayment', ply, tonumber(data))
end
donation.buildVGUI = function(self, parent_p) 
end
donation.loadData = function(self) return net.ReadInt(17) end
donation.priceFunc = function(self, ply, data)
	return math.Round(data * (1 - donations.discount))
end
donation.send = function(self, method, duration_id, data)
	net.Start("donations.buy")
		net.WriteString(self.name)
		net.WriteInt(method.id, 8)
		net.WriteInt(data, 17)
	net.SendToServer()
end
donations.add(donation)


local premium = donations.new()
premium.name = "premium" 
premium.notify = function(self, ply, duration, data) net.Start("donations.purchased") net.Send(ply) notify(ply, type_generic, 'Спасибо за подписку!') end
premium.printName = "Подписка"
premium.give = function(self, ply, duration, data, id) 
	hook.Run('SuccessfulSubscription', ply, id, data)
end
premium.buildVGUI = function(self, parent_p) 
end
premium.loadData = function(self) return net.ReadInt(17) end
premium.priceFunc = function(self, ply, data)
	return data --math.Round(data * (1 - donations.discount))
end
premium.send = function(self, method, duration_id, data)
	net.Start("donations.buy")
		net.WriteString(self.name)
		net.WriteInt(method.id, 8)
		net.WriteInt(data, 17)
	net.SendToServer()
end
donations.add(premium)