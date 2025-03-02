rp.VendorsNPCs = rp.VendorsNPCs or {}
rp.VendorsNPCsWhatSells = rp.VendorsNPCsWhatSells or {}
function rp.AddVendor(name, model, sequence, pos, bodygroups, skin, allowed, notAllowedTerm)
	--print('SPAWN VENDOR', name)
	
	if not pos[game.GetMap()] then
		--MsgN(Color(250, 80, 40), "[#] Ошибка в rp.AddVendor! ", color_white, "Не-указанна позиция спавна npc "..name.." для текущей карты! \n")
		return
	end
	pos = pos[game.GetMap()]

	--print('OK!')
	
	rp.VendorsNPCs[name] = rp.VendorsNPCs[name] or {}
	rp.VendorsNPCs[name].model = model
	rp.VendorsNPCs[name].sequence = sequence
	rp.VendorsNPCs[name].items = rp.VendorsNPCs[name].items or {}
	
	rp.VendorsNPCs[name].allowed = allowed
	rp.VendorsNPCs[name].notAllowedTerm = notAllowedTerm

	rp.VendorsNPCs[name].pos = pos[1]
	rp.VendorsNPCs[name].ang = pos[2]
	
	rp.VendorsNPCs[name].bodygroups = bodygroups
	rp.VendorsNPCs[name].skin = skin

	return rp.VendorsNPCs[name]
end

local tinsert = table.insert;

function rp.AddVendorItem(vendor_name, item_category, item_name, item_uid, item_mdl, price_sell, price_buy, item_max, sell_custom_check, PreSell)
	if price_sell and price_buy and (price_sell > price_buy) then
		MsgC(Color(250, 80, 40), "[#] Ошибка в rp.AddVendorItem! ", color_white, "VendorName="..vendor_name.." ItemName="..item_name.." \n")
		MsgC(color_white, "Какой-то мудило настроил скрипт так, что NPC покупает дороже чем продаёт \n")
		MsgC(Color(250, 80, 40), "sellprice="..price_sell.." > buyprice="..price_buy.." \n")
		return
	end

	--print('Вендору', vendor_name, 'добавлен итем',item_name)
	
	rp.VendorsNPCs[vendor_name] = rp.VendorsNPCs[vendor_name] or {}
	rp.VendorsNPCs[vendor_name].items = rp.VendorsNPCs[vendor_name].items or {}

	rp.VendorsNPCs[vendor_name].items[item_uid] = {
		name = item_name,
		category = item_category,
		mdl = item_mdl,
		sellPrice = price_sell,
		SellCustomCheck = sell_custom_check,
		buyPrice = price_buy,
		max = item_max,
		PreSell = PreSell
	}

	if (price_sell) then
		if (!rp.VendorsNPCsWhatSells[item_uid]) then
			rp.VendorsNPCsWhatSells[item_uid] = {}
		end

		tinsert(rp.VendorsNPCsWhatSells[item_uid], vendor_name)
	end
end

rp.item.icons = rp.item.icons or {}

rp.item.shop.shipments = {}
function rp.AddShipment(tblEnt)
	tblEnt.base = tblEnt.base or (not tblEnt.noBase and "weapons")
	rp.item.createItem(tblEnt)

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon
	end

	local SHIPMENT = {}
	SHIPMENT.name = tblEnt.name
	SHIPMENT.model = tblEnt.model
	SHIPMENT.uniqueID = "box_shop"
	SHIPMENT.price = tblEnt.price
	SHIPMENT.max = tblEnt.max or 0
	
	SHIPMENT.allowed = SHIPMENT.allowed or {}
	tblEnt.allowed = tblEnt.allowed or {}
	for k, v in pairs(tblEnt.allowed) do
		if v and not isbool(v) then
			tblEnt.allowed[v] = true
		end
	end
	SHIPMENT.allowed = tblEnt.allowed

	SHIPMENT.customCheck = tblEnt.customCheck
	SHIPMENT.unlockTime = tblEnt.unlockTime

	SHIPMENT.count = tblEnt.count
	SHIPMENT.content = tblEnt.ent

	table.insert(rp.item.shop.shipments, SHIPMENT)

	if tblEnt.sold_seperately then
		rp.AddWeapon(tblEnt)
	end

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem(vendor_name, tblEnt.category or "shipments", tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0, price_tab.SellCustomCheck, price_tab.PreSell)
		end
	end
end

rp.item.shop.entities = {}
function rp.AddEntity(tblEnt)
	if not tblEnt.onlyEntity then
		rp.item.createItem(tblEnt)
	end

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon
	end
	
	ITEM = {}
	ITEM.name = tblEnt.name
	ITEM.icon_override = tblEnt.icon_override
	ITEM.model = tblEnt.model
	ITEM.uniqueID = tblEnt.ent
--[[
	if tblEnt.onTransfered then
		ITEM.onTransfered = tblEnt.onTransfered
	end
]]--
	ITEM.price = tblEnt.price
	ITEM.max = tblEnt.max or 0
	ITEM.customCheck = tblEnt.customCheck
	ITEM.unlockTime = tblEnt.unlockTime
	
	ITEM.allowed = ITEM.allowed or {}
	tblEnt.allowed = tblEnt.allowed or {}
	for k, v in pairs(tblEnt.allowed) do
		if v and not isbool(v) then
			tblEnt.allowed[v] = true
		end
	end
	ITEM.allowed = tblEnt.allowed

	if tblEnt.onlyEntity then
		ITEM.onlyEntity = true
		ITEM.cmd = tblEnt.cmd
		
		timer.Simple(0, function()
			GAMEMODE:AddEntityCommands(tblEnt)
		end)
	end
	
	if tblEnt.category then
		table.insert(rp.item.shop[tblEnt.category], ITEM)
	else
		table.insert(rp.item.shop.entities, ITEM)
	end

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem(vendor_name, "entities", tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0, price_tab.SellCustomCheck, price_tab.PreSell)
		end
	end
end

function rp.AddDisguise(tblEnt)
	tblEnt.base = 'disguise'
	tblEnt.faction = tblEnt.faction or 1
	
	rp.AddEntity(tblEnt)
end

rp.Drugs = {}
function rp.AddDrug(tblEnt)
	tblEnt.price = tblEnt.price and math.ceil(tblEnt.price * 10) or 0
	tblEnt.base = 'usable'
	
	local tab = {
		Name = tblEnt.name,
		Class = tblEnt.ent,
		Model = tblEnt.model,
		BuyPrice = tblEnt.price
	}

	rp.Drugs[#rp.Drugs + 1] = tab
	rp.Drugs[tblEnt.ent] = tab
	
	rp.AddShipment(tblEnt)
end

rp.item.shop.weapons = {}
function rp.AddWeapon(tblEnt)
	tblEnt.base = tblEnt.base or "weapons"
	rp.item.createItem(tblEnt)

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon
	end

	ITEM = {}
	ITEM.name = tblEnt.name
	ITEM.model = tblEnt.model
	ITEM.uniqueID = tblEnt.ent
	ITEM.onEquipWeapon = tblEnt.onEquipWeapon
	ITEM.max = tblEnt.max or 0
	ITEM.ShopToInventory = true

	ITEM.price = (tblEnt.price_seperately and tblEnt.price_seperately or tblEnt.price)
	ITEM.customCheck = tblEnt.customCheck
	ITEM.unlockTime = tblEnt.unlockTime

	ITEM.allowed = ITEM.allowed or {}
	tblEnt.allowed = tblEnt.allowed or {}
	for k, v in ipairs(tblEnt.allowed) do
		ITEM.allowed[v] = true
	end

	if tblEnt.confiscateReward then
		rp.cfg.ConfiscationWeapons[tblEnt.ent] = tblEnt.confiscateReward
	end

	--print(tblEnt.name)
	--PrintTable(ITEM.allowed)

	table.insert(rp.item.shop.weapons, ITEM)
	rp.AddCopItem(tblEnt.name, tblEnt.price_seperately, tblEnt.model, tblEnt.ent)

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem(vendor_name, "weapons", tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0, price_tab.SellCustomCheck, price_tab.PreSell)
		end
	end
end

rp.item.shop.ammoTypes = {}
function rp.AddAmmoType(tblEnt)
	tblEnt.base = tblEnt.base or "ammo"
	rp.item.createItem(tblEnt)

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon
	end

	ITEM = {}
	ITEM.name = tblEnt.name
	ITEM.model = tblEnt.model
	ITEM.uniqueID = tblEnt.ent
	ITEM.max = tblEnt.max or 0
	ITEM.allowed = tblEnt.allowed

	ITEM.price = tblEnt.price
	ITEM.customCheck = tblEnt.customCheck
	ITEM.unlockTime = tblEnt.unlockTime

	ITEM.ammoType = tblEnt.ammoType
	ITEM.amountGiven = tblEnt.amountGiven

	table.insert(rp.item.shop.ammoTypes, ITEM)
	table.insert(rp.ammoTypes, ITEM)

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem(vendor_name, "ammoTypes", tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0, price_tab.SellCustomCheck, price_tab.PreSell)
			--rp.AddVendorItem(vendor_name, tblEnt.category, tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0)
		end
	end
end

function rp.AddItem(tblEnt)
	rp.item.createItem(tblEnt)

	if tblEnt.icon then
		rp.item.icons[tblEnt.ent] = tblEnt.icon
	end

	if tblEnt.vendor then
		for vendor_name, price_tab in pairs(tblEnt.vendor) do
			rp.AddVendorItem(vendor_name, tblEnt.category, tblEnt.name, tblEnt.ent, tblEnt.model, price_tab.sellPrice, price_tab.buyPrice, tblEnt.max or 0, price_tab.SellCustomCheck, price_tab.PreSell)
		end
	end
end

rp.item.shop.foods = {}
function rp.AddFood(tblEnt)
	tblEnt.healthRestore = tblEnt.healthAmount or 0
	tblEnt.foodRestore = tblEnt.foodAmount or 1
	tblEnt.isDrink = true
	tblEnt.category = "foods"
	tblEnt.noBase = true

	if rp.Foods then
		rp.AddFoodItem(tblEnt.name, tblEnt.model, 1, tblEnt.price, tblEnt.allowed)
	end
	
	rp.AddShipment(tblEnt)
end