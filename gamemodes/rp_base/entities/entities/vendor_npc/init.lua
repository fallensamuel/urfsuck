AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("VendorNpc_OpenMenu")
util.AddNetworkString("VendorNpc_BuyItem")
util.AddNetworkString("VendorNpc_SellItem")



concommand.Add("tp2vendor", function(ply, cmd, args)
    if not ply:IsRoot() then return end
    local index = args[1]
    if not index then
    	rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_err'))
    	return
    end

    index = tonumber(index)
    local ent_s = ents.FindByClass("vendor_npc")

    if not index then
        rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_errind'), #ent_s)
        return
    end

    local ent = ent_s[index]
    if not IsValid(ent) then
    	rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_invind'), index, #ent_s)
    	return
    end

	ply:SetPos(ent:GetPos())
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('Vendor_tele'), ent:GetVendorName())
end)


function ENT:Initialize()
	self:SetModel("models/Barney.mdl")

	--self:SetHullType(HULL_HUMAN)
	--self:SetHullSizeNormal()
	
	--[[
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_BBOX)
	]]
	
	--self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD, CAP_DUCK)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetUseType(SIMPLE_USE) 
	--self:DropToFloor()
end

function ENT:Use(ply)
	if ply.CantUse then return end
	ply.CantUse = true
	timer.Simple(1, function() ply.CantUse = nil end)

    if ply:CantDoAfterNoclip(true) then return end

	if rp.VendorsNPCs[self:GetVendorName()].allowed and not rp.VendorsNPCs[self:GetVendorName()].allowed[ply:Team()] then
		return rp.Notify(ply, NOTIFY_RED, rp.Term(rp.VendorsNPCs[self:GetVendorName()].notAllowedTerm))
	end
	
	net.Start("VendorNpc_OpenMenu")
		net.WriteInt(self:EntIndex(), 32)
		net.WriteBool(true)
	net.Send(ply)
end

--———————————————— N e w   I n v e n t o r y   M e t h o d s ————————————————--

local META = rp.meta.inventory or {}
local table_Count, math_Clamp, pairs_ = table.Count, math.Clamp, pairs

function META:TakeItem(uid, amount, whitelist)
    amount = amount or 1
    local taken = 0

    local items = whitelist or self:getItemsByUniqueID(uid)
    if table_Count(items) < 1 then return 0 end

    local cycles = 0
    while amount > 0 do
        for k, item in pairs_(items) do
            local count = item:getCount()
            local fortake = math_Clamp(count, 0, amount)

            if count > fortake then
                item:addCount(-fortake)
                amount = amount - fortake
                taken = taken + fortake
            else
                item:remove()
                amount = amount - count
                taken = taken + count
            end

            if amount <= 0 then break end
        end

        cycles = cycles + 1
        if cycles >= 10 then break end -- всегда с опаской юзаю while цикл
    end

    return taken
end

function META:GetCountByUID(uid)
    local cnt = 0
    local items = self:getItemsByUniqueID(item_uid)

    for k, item in pairs(items) do
        cnt = cnt + item:getCount() * (item.ammoAmount or 1)
    end

    return cnt
end

function META:IsItemLimit(ply, item_uid, max)
    local itemCount = self:getItemCount(item_uid) + ply:GetCount(item_uid)

    if not max or max == 0 then
        max = rp.cfg.DroppedItemsLimit or 5
    end

    if itemCount >= max then
        return true
    end

    max = rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10
    if ply:GetCount('rp_item') >= max then
        return true
    end
end

--————————————————B a s e - T r a d e - F u n c s——————————————————————————————————
local max_buy_dit = 125*125

function ENT:AnyTradeFunc(ply, uid, count, callback)
	if self:GetPos():DistToSqr(ply:GetPos()) > max_buy_dit then
		rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_far"))
		return
	end

    if ply:GetJobTable().CantUseInventory then return end

    if not uid then return end

	local items_tab = rp.VendorsNPCs[self:GetVendorName()].items
	if not items_tab[uid] then
        rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_noitem'), uid)
        return
    end

	callback(ply, uid, count, items_tab[uid])
end

--————————————————B U Y——————————————————————————————————

net.Receive("VendorNpc_BuyItem", function(len, ply)
    local ent_index = net.ReadInt(32)
    local item_uid = net.ReadString()
    local item_count = net.ReadInt(30)

    item_count = 1

    local self = ents.GetByIndex(ent_index)
    if not IsValid(self) then return end
    if not item_uid or not item_count then return end

    if not self.AnyTradeFunc then return end
    self:AnyTradeFunc(ply, item_uid, item_count, function(ply, uid, count, item_tab)
        if not item_tab.buyPrice then
            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_cantbuy"))
            return
        end

        local inv = ply:getInv()

        if inv:IsItemLimit(ply, item_uid, item_tab.max) then
            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_max"))
            return
        end

        local max = item_tab.max
        if not max or max == 0 then
            max = rp.cfg.DroppedItemsLimit or 5
        end
        count = math.Clamp(count, 0, max)
        if count < 1 then return end

        local price = count * item_tab.buyPrice
        if price < 1 then return end
        if ply:GetMoney() < price then
            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_cantpay"))
            return
        end

        local status, result = inv:add(uid)--, count)
        if status == false then
            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
            return
        end

        rp.Notify(ply, NOTIFY_GREEN, rp.Term("Vendor_bought"), count, item_tab.name, rp.FormatMoney(price))
        ply:AddMoney(-price)
        timer.Simple(0.1, function()
             inv:sync(ply, true)
        end)

        if IsValid(self) then
            self:EmitSound("item_buy.wav")
        end
    end)
end)

--————————————————S E L L————————————————————————————————

net.Receive("VendorNpc_SellItem", function(len, ply)
    local ent_index = net.ReadInt(32)
    local item_uid = net.ReadString()
    local item_count = net.ReadInt(30)

    local self = ents.GetByIndex(ent_index)
    if not IsValid(self) then return end
    if not item_uid or not item_count then return end

    if not self.AnyTradeFunc then return end

    self:AnyTradeFunc(ply, item_uid, item_count, function(ply, uid, count, item_tab)
        if not item_tab.sellPrice then
            return rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_cantsell"))
        end

        count = math.ceil(count)

        local price = count * item_tab.sellPrice
        if price < 1 then return end

        for name, tab in pairs(rp.item.shop) do
            for key, item in pairs(tab) do
                if item["uniqueID"] and item["uniqueID"] == uid then
                    if not item["price"] then continue end
                    if item_tab.sellPrice > item["price"] then
                        rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_cfgerr'), uid)
                        return
                    else
                        break
                    end
                end
            end
        end

		--PrintTable(item_tab)
		
        local cnt = 0
        local inv = ply:getInv()
        local items = inv:getItemsByUniqueID(uid)
		local whitelist = {}
		
        for k, item in pairs(items) do
			--PrintTable(item)
			
			if item_tab.SellCustomCheck and not item_tab.SellCustomCheck(ply, item) then
				--return rp.Notify(ply, NOTIFY_RED, "Этот предмет нельзя продать!") -- rp.Term("VendorNpc_cantSell"))
				continue
			end
			
            cnt = cnt + item:getCount() * (item.ammoAmount or 1)
			table.insert(whitelist, item)
        end
		
		--print('Pizza count', cnt, count)

        if cnt < count then --inv:getItemCount(uid) < count then
            rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_nenough'), item_tab.name)
            return
        end

        --local items = inv:getItemsByUniqueID(uid)
        local sell_count = inv:TakeItem(uid, count, whitelist)

		local old_price = price
        if item_tab.PreSell then
            price = item_tab.PreSell(ply, item_tab, sell_count, price)
        end

		if old_price ~= price then
			local percent = (old_price - price) / old_price
			
			rp.Notify(ply, NOTIFY_GREEN, rp.Term("Vendor_sold_minus"), sell_count, item_tab.name, rp.FormatMoney(price), math.ceil(100 * percent)) -- (zpiz and zpiz.PizzeriaOwnerPrecent or 1)
		else
			rp.Notify(ply, NOTIFY_GREEN, rp.Term("Vendor_sold"), sell_count, item_tab.name, rp.FormatMoney(price))
		end
		
        ply:AddMoney(price)
        timer.Simple(0.1, function()
            inv:sync(ply, true)
        end)

        if IsValid(self) then
            self:EmitSound("item_buy.wav")
        end
    end)
end)