AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("VendorItemNPC")

ENT.IsItemVendor = true

function ENT:Initialize()
	self:SetModel("models/Barney.mdl")	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:SetUseType(SIMPLE_USE) 
end

function ENT:Use(ply)
	if ply.CantUse then return end
	ply.CantUse = true
	timer.Simple(1, function() ply.CantUse = nil end)

    if ply:CantDoAfterNoclip(true) then return end

    local obj = self:GetObject()

	if obj.CustomCheck and not obj.CustomCheck(ply, self) then
		return rp.Notify(ply, NOTIFY_RED, rp.Term(obj.notAllowedTerm or "YouCantTradeNPC"))
	end
	
	net.Start("VendorItemNPC")
		net.WriteInt(self:EntIndex(), 32)
	net.Send(ply)
end

net.Receive("VendorItemNPC", function(len, ply)
    local ent_index = net.ReadInt(32)
    local item_uid = net.ReadString()

    local ent = Entity(ent_index)
    if IsValid(ent) and ent.IsItemVendor then
        ent:BuyItem(item_uid, ply)
    end
end)

local max_buy_dist = 170*170
function ENT:BuyItem(uid, ply)
    if not uid then return end

    local dist = self:GetPos():DistToSqr(ply:GetPos())
    if dist > max_buy_dist then
        rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_far"))
        return
    end

    if ply:GetJobTable().CantUseInventory then return end

    local obj = self:GetObject()
    local itemPrice = obj.Items[uid]
    if not itemPrice then
        rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_noitem'), uid)
        return
    end

    local cnt = 0
    local inv = ply:getInv()
    local items = inv:getItemsByUniqueID(obj.PriceItem)
    local whitelist = {}
    local price_itemtab = rp.item.list[obj.PriceItem] or rp.item.instances[obj.PriceItem]
        
    for k, item in pairs(items) do
        cnt = cnt + item:getCount() * (item.ammoAmount or 1)
        table.insert(whitelist, item)
    end
    
    if cnt < itemPrice then --inv:getItemCount(uid) < count then
        rp.Notify(ply, NOTIFY_RED, rp.Term('Vendor_nenough'), price_itemtab.name or "unknown")
        return
    end

    local status, result = inv:add(uid)--, count)
    if status == false then
        rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
        return
    end

    local sell_count = inv:TakeItem(obj.PriceItem, itemPrice, whitelist)

    rp.Notify(ply, NOTIFY_GREEN, rp.Term("Vendor_bought2"), itemPrice, price_itemtab.name)

    timer.Simple(0.1, function()
        inv:sync(ply, true)
    end)

    if IsValid(self) then
        self:EmitSound("item_buy.wav")
    end
end