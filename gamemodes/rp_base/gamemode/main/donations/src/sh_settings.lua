-- "gamemodes\\rp_base\\gamemode\\main\\donations\\src\\sh_settings.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

donations.language = {
//	somethingwrong = translates.Get("Something went wrong, try later."),
//	purchase_completed = translates.Get("Спасибо за покупку! %s добавлены на ваш счёт."),
//	permanent = translates.Get("Куплено навсегда."),
//	extend_for = translates.Get("Истекает через %s, продлить за %sр."),
//	purchase_for = translates.Get("Купить за %sр."),
//	duration = translates.Get("Сроком на %s за %sр."),
//	purchase_not_avalible = translates.Get("Покупка недоступна, подождите пока %s истечёт."),
//	purchase_ended = translates.Get("%s истек.")
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

local xsolla = donations.newMethod();
xsolla.name = "Xsolla";
xsolla.method = "xsolla";
xsolla.proceedPayment = function( self, ply, donation, duration )
	local data = donation:loadData();
	local price = duration and duration.price or donation:priceFunc(ply, data) or donation.price;

	local server_name = string.Replace(donations.getServerName(), "'", "");
	sendURL( ply, string.format("https://bot.urf.im/api/xsolla/checkout.php?s=%s&sid=%s&value=%s", server_name, ply:SteamID(), price) );
end
donations.addMethod( xsolla );

local tebex = donations.newMethod();
tebex.name = "Tebex";
tebex.method = "tebex";
tebex.proceedPayment = function( self, ply, donation, duration )
	sendURL( ply, "https://urfimfr.tebex.io/" );
end
donations.addMethod( tebex );

local robokassa = donations.newMethod()
robokassa.name = "Робокасса (КИВИ, Карты, Телефон и пр)"
robokassa.method = "robokassa"
robokassa.proceedPayment = function(self, ply, donation, duration)
	local data = donation:loadData()
	local price = duration && duration.price or donation:priceFunc(ply, data) or donation.price
	--donations.createInvoice(ply, "robokassa", donation, duration, data, price, function(ply, donation, duration, id, price)
	--	sendURL(ply, "https://urf.im/donations/robokassa/index2.php?id="..id)
	--end)
	
	sendURL(ply, 'https://shop.urf.im/?s=' .. string.Replace(donations.getServerName(), "'", '') .. '&sid=' .. ply:SteamID() .. '&price=' .. price .. '#purchase')
end
donations.addMethod(robokassa)

local paypal = donations.newMethod()
paypal.name = "PAYPAL"
paypal.method = "paypal"
paypal.proceedPayment = function(self, ply, donation, duration)
	local data = donation:loadData()
    local price = duration && duration.price or donation:priceFunc(ply, data) or donation.price
    
    donations.createInvoice(ply, "paypal", donation, duration, data, price, function(ply, donation, duration, id, price)
        --local hex = secret(id, price, function(hex)
            --sendURL(ply, "https://urf.im/paypal/?steamid="..ply:SteamID().."&a="..data)
        --end)        
        
		sendURL(ply, "http://urfim.fr/paypal/?id=" .. id .. "&steamid=" .. ply:SteamID() .. "&a=" .. data)
    end)
end
donations.addMethod(paypal)


local skins = donations.newMethod()
skins.name = translates.Get("Скинами из Dota 2/CS:GO")
skins.method = "skins"
skins.proceedPayment = function(self, ply, donation, duration)
	local data = donation:loadData()
	local price = duration && duration.price or donation:priceFunc(ply, data) or donation.price
	
	--[[
	donations.createInvoice(ply, "skinpay", donation, duration, data, price, function(ply, donation, duration, id, price)
		sendURL(ply, "https://shop.urf.im/donations/skins/index.php?orderid="..id.."&userid="..ply:SteamID64())
	end)
	]]--
	
	donations.createInvoice( ply, "skinpay", donation, duration, data, price, function( ply, donation, duration, id, price )
		sendURL( ply, "https://bot.urf.im/api/skins"
			.. "?invoiceid=" .. id
			.. "&steamid=" .. ply:SteamID64()
			.. (rp.cfg.IsFrance and "&france=1" or "")
		);
	end );
end
donations.addMethod(skins)

local donation = donations.new()
donation.name = "points" 
donation.notify = function(self, ply, duration, data) net.Start("donations.purchased") net.Send(ply) notify(ply, type_generic, translates.Get('Спасибо за покупку %s кредитов!', data)) end
donation.printName = translates.Get("Кредиты")
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
premium.notify = function(self, ply, duration, data) net.Start("donations.purchased") net.Send(ply) notify(ply, type_generic, translates.Get('Спасибо за подписку!')) end
premium.printName = translates.Get("Подписка")
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


local spass = donations.new()
spass.name = "spass" 
spass.notify = function(self, ply, duration, data) 
	net.Start("donations.purchased") 
	net.Send(ply) 
	
	notify(ply, type_generic, translates.Get('Спасибо за покупку!'))
end
spass.printName = "Season Pass"
spass.give = function(self, ply, duration, data, id) 
	hook.Run('Seasonpass::Payment', ply)
end
spass.buildVGUI = function(self, parent_p) 
end
spass.loadData = function(self) return net.ReadInt(17) end
spass.priceFunc = function(self, ply, data)
	return data --math.Round(data * (1 - donations.discount))
end
spass.send = function(self, method, duration_id, data)
	net.Start("donations.buy")
		net.WriteString(self.name)
		net.WriteInt(method.id, 8)
		net.WriteInt(data, 17)
	net.SendToServer()
end
donations.add(spass)

local spass_level = donations.new()
spass_level.name = "spass_level" 
spass_level.notify = function(self, ply, duration, data) 
	net.Start("donations.purchased") 
	net.Send(ply) 
	
	notify(ply, type_generic, translates.Get('Спасибо за покупку!'))
end
spass_level.printName = "Season Pass Levels"
spass_level.give = function(self, ply, duration, data, id) 
	hook.Run('Seasonpass::LevelsPayment', ply, data)
end
spass_level.buildVGUI = function(self, parent_p) 
end
spass_level.loadData = function(self) return net.ReadInt(17) end
spass_level.priceFunc = function(self, ply, data)
	return data --math.Round(data * (1 - donations.discount))
end
spass_level.send = function(self, method, duration_id, data)
	net.Start("donations.buy")
		net.WriteString(self.name)
		net.WriteInt(method.id, 8)
		net.WriteInt(data, 17)
	net.SendToServer()
end
donations.add(spass_level)


local vkbot_case  = donations.new();
vkbot_case.name   = "vkbot_case";
vkbot_case.notify = function( self, ply, duration, data )
	local case = rp.lootbox.Map[data];
	if not case then return end
	
	notify( ply, type_generic, string.format("Спасибо за покупку %s через наше сообщество вк!", case.name and '"'..case.name..'"' or "кейса") );
end
vkbot_case.printName = "[VK] Кейсы";
vkbot_case.give = function(self, ply, duration, data, id)
	local case = rp.lootbox.Map[data];
	if not case then return end
	
	rp.lootbox.Give( ply, data );
end
donations.add( vkbot_case );