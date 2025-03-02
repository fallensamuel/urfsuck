local META = rp.meta.inventory or {}
META.__index = META
META.slots = META.slots or {}
META.w = META.w or 4
META.h = META.h or 4
META.vars = META.vars or {}

function META:getID()
	return self.id or 0
end

function META:setSize(w, h)
	self.w = w
	self.h = h
end

function META:__tostring()
	return "inventory["..(self.id or 0).."]"
end

function META:getSize()
	return self.w, self.h
end

-- this is pretty good to debug/develop function to use.
function META:print(printPos)
	for k, v in pairs(self:getItems()) do
		local str = k .. ": " .. v.name

		if (printPos) then
			str = str .. " (" .. v.gridX .. ", " .. v.gridY .. ")"
		end

		print(str)
	end
end

-- find out stacked shit
function META:findError()
	for k, v in pairs(self:getItems()) do
		if (v.width == 1 and v.height == 1) then
			continue
		end

		print("Finding error: " .. v.name )
		print("Item Position: " .. v.gridX, v.gridY )
		local x, y;
		for x = v.gridX, v.gridX + v.width - 1 do
			for y = v.gridY, v.gridY + v.height - 1 do
				local item = self.slots[x][y]
				if (item and item.id != v.id) then
					print("Error Found: ".. item.name)
				end
			end
		end
	end
end

-- For the debug/item creation purpose
function META:printAll()
	print("------------------------")
		print("INVID", self:getID())
		print("INVSIZE", self:getSize())

		if (self.slots) then
			for x = 1, self.w do
				for y = 1, self.h do
					local item = self.slots[x] and self.slots[x][y]
					if (item and item.id) then
						print(item.name .. "(" .. item.id .. ")", x, y)
					end
				end
			end
		end

		print("INVVARS")
		PrintTable(self.vars or {})
	print("------------------------")
end

function META:setOwner(owner, fullUpdate)
	-- if (type(owner) == "Player" and owner:getNetVar("char")) then
	-- 	owner = owner:getNetVar("char")
	-- elseif (type(owner) != "number") then
	-- 	return
	-- end

	if (SERVER) then
		if (fullUpdate) then
			for k, v in ipairs(player.GetAll()) do
				if (v:getNetVar("char") == owner) then
					self:sync(v, true)

					break
				end
			end
		end
		if owner != nil then
			rp._Inventory:Query("UPDATE inventories SET _charID = "..(type(owner) == "Player" and owner:SteamID64() or owner).." WHERE _invID = "..self:getID())
		end
	end

	self.owner = owner
end

function META:canItemFit(x, y, w, h, item2)
	local canFit = true

	local x2 = 0;
	local y2 = 0;
	
	for x2 = 0, w - 1 do
		for y2 = 0, h - 1 do
			local item = (self.slots[x + x2] or {})[y + y2]

			if ((x + x2) > self.w or item) then
				if (item2) then
					if (item and item.id == item2.id) then
						continue
					end
				end

				canFit = false
				break
			end
		end

		if (!canFit) then
			break
		end
	end

	return canFit
end

function META:findEmptySlot(w, h, onlyMain)
	w = w or 1
	h = h or 1

	if (w > self.w or h > self.h) then
		return
	end

	local canFit = false
	
	local x = 0;
	local y = 0;

	for y = 1, self.h - (h - 1) do
		for x = 1, self.w - (w - 1) do
			if (self:canItemFit(x, y, w, h)) then
				return x, y
			end
		end
	end

	if (onlyMain != true) then
		local bags = self:getBags()
		
		if (#bags > 0) then
			for _, invID in ipairs(bags) do
				local bagInv = rp.item.inventories[invID]

				if (bagInv) then
					local x, y = bagInv:findEmptySlot(w, h)

					if (x and y) then
						return x, y, bagInv
					end
				end
			end
		end
	end
end

function META:getItemAt(x, y)
	if (self.slots and self.slots[x]) then
		return self.slots[x][y]
	end
end

function META:remove(id, noReplication, noDelete)
	local x2, y2

	for x = 1, self.w do
		if (self.slots[x]) then
			for y = 1, self.h do
				local item = self.slots[x][y]

				if (item and item.id == id) then
					self.slots[x][y] = nil

					x2 = x2 or x
					y2 = y2 or y
				end
			end
		end
	end

	if (SERVER and !noReplication) then
		local receiver = self:getReceiver()

		if (type(receiver) == "Player" and IsValid(receiver)) then
			netstream.Start(receiver, "invRm", id, self:getID())
		else
			netstream.Start(receiver, "invRm", id, self:getID(), self.owner)
		end

		if (!noDelete) then
			local item = rp.item.instances[id]

			if (item and item.onRemoved) then
				item:onRemoved()
			end
			
			rp._Inventory:Query("DELETE FROM items WHERE _itemID = "..id)
			rp.item.instances[id] = nil
		end
	end

	if CLIENT then
		if self:IsEmpty() and self:getID() ~= LocalPlayer():getInv():getID() and IsValid(rp.LootInventory.Panels.InventoryMenu) and rp.LootInventory.Panels.InventoryMenu.PlayerInventory.invID == self:getID() then
			rp.LootInventory.Panels.InventoryMenu.Remove(rp.LootInventory.Panels.InventoryMenu)
			
			if IsValid(rp.Inventory.Panels.InventoryMenu) then
				rp.Inventory.Panels.InventoryMenu.Remove(rp.Inventory.Panels.InventoryMenu)
			end
		end
	end
	
	return x2, y2
end

function META:getReceiver()
	return type(self.owner) == "Player" and self.owner or player.GetBySteamID64(self.owner)
end

function META:getItemCount(uniqueID, onlyMain)
	local i = 0

	for k, v in pairs(self:getItems(onlyMain)) do
		if (v.uniqueID == uniqueID) then
			i = i + v:getCount()
		end
	end

	return i
end

function META:getItemsByUniqueID(uniqueID, onlyMain)
	local items = {}

	for k, v in pairs(self:getItems(onlyMain)) do
		if (v.uniqueID == uniqueID) then
			table.insert(items, v)
		end
	end

	return items
end

function META:getItemByID(id, onlyMain)
	for k, v in pairs(self:getItems(onlyMain)) do
		if (v.id == id) then
			return v
		end
	end
end

function META:getItemsByID(id, onlyMain)
	local items = {}

	for k, v in pairs(self:getItems(onlyMain)) do
		if (v.id == id) then
			table.insert(items, v)
		end
	end

	return items
end

-- This function may pretty heavy.
function META:getItems(onlyMain)
	local items = {}

	for k, v in pairs(self.slots) do
		for k2, v2 in pairs(v) do
			if (v2 and !items[v2.id]) then
				items[v2.id] = v2

				v2.data = v2.data or {}
				local isBag = v2.data.id
				if (isBag and isBag != self:getID() and onlyMain != true) then
					local bagInv = rp.item.inventories[isBag]

					if (bagInv) then
						local bagItems = bagInv:getItems()

						table.Merge(items, bagItems)
					end
				end
			end
		end
	end

	return items
end

function META:getCountItems()
	local currentItems = 0
	for k,v in pairs(self:getItems()) do
		currentItems = currentItems + v:getCount()
	end
	return currentItems
end

function META:IsEmpty()
	local currentItems = 0
	for k,v in pairs(self.slots) do
		for c,d in pairs(v) do
			currentItems = currentItems + 1
		end
	end
	if currentItems < 1 then
		return true
	else
		return false
	end
end

function META:getBags()
	local invs = {}

	for k, v in pairs(self.slots) do
		for k2, v2 in pairs(v) do
			if (v2.data) then
				local isBag = v2.data.id

				if (!table.HasValue(invs, isBag)) then
					if (isBag and isBag != self:getID()) then
						table.insert(invs, isBag)
					end
				end
			end
		end
	end

	return invs
end

function META:matchData(id, matchData)
	local item = self:getItemByID(id)

	if (item) then
		for dataKey, dataVal in pairs(data) do
			if (itemData[dataKey] != dataVal) then
				return false
			end
		end

		return true
	end
end

function META:hasItem(targetID, data)
	local items = self:getItems()
	
	for k, v in pairs(items) do
		if (v.uniqueID == targetID) then
			if (data) then
				local itemData = v.data

				for dataKey, dataVal in pairs(data) do
					if (itemData[dataKey] != dataVal) then
						return false
					end
				end
			end

			return v
		end
	end

	return false
end

if (SERVER) then
	function META:sendSlot(x, y, item, receiver)
		receiver = receiver or self:getReceiver()
		local sendData = item and item.data and table.Count(item.data) > 0 and item.data or nil

		--if !IsValid(receiver) then return end
		--if (string.lower(type(item)) == 'table') then PrintTable(item); else print(tostring(item)); end

		--print(item, receiver)
		
		if (type(receiver) == "Player" and IsValid(receiver)) then
			netstream.Start(receiver, "invSet", self:getID(), x, y, item and item.uniqueID or nil, item and item.id or nil, nil, sendData, sendData and 1 or nil)
		else
			netstream.Start(receiver, "invSet", self:getID(), x, y, item and item.uniqueID or nil, item and item.id or nil, self.owner, sendData, sendData and 1 or nil)
		end

		if item then
			if (type(receiver) == "table") then
				for k, v in pairs(receiver) do
					item:call("onSendData", v)
				end
			elseif (IsValid(receiver)) then
				item:call("onSendData", receiver)
			end
		end

		self:sync(receiver)
	end

	function META:add(uniqueID, quantity, data, x, y, noReplication, ignoreMaxStack, cback)
		quantity = quantity or 1
				
		if (quantity > 0) then
			local targetInv = self
			local bagInv

			if (type(uniqueID) == "number") then
				local item = rp.item.instances[uniqueID]
				if (item) then
					local itemTable = rp.item.list[item.uniqueID]

					if (!x and !y) then
						if itemTable.stackable || ignoreMaxStack then
							local items = self:getItemsByUniqueID(item.uniqueID)
							for k,v in pairs(items) do
								if v:getCount() < itemTable.maxStack || ignoreMaxStack then
									--[[
									item:addCount(-1)
									v:addCount(1)
									if quantity > 1 then
										self:add(uniqueID, quantity-1, data, nil, nil, noReplication, ignoreMaxStack)
									end
									]]
									
									local add_count = ignoreMaxStack and quantity or math.min(itemTable.maxStack - v:getCount(), quantity)

									--print('Add count', add_count)
									
									v:addCount(add_count)
									quantity = quantity - add_count
									
									if quantity <= 0 then
										return true
									end
								end
							end
						end

						x, y, bagInv = self:findEmptySlot(item.width, item.height)
					end

					if (bagInv) then
						targetInv = bagInv
					end

					if (hook.Run("CanItemBeTransfered", item, rp.item.inventories[0], targetInv) == false) then
						return false, "notAllowed"
					end

					if (x and y) then
						targetInv.slots[x] = targetInv.slots[x] or {}
						targetInv.slots[x][y] = item

						item:setData("count", quantity)
							
						item.gridX = x
						item.gridY = y
						item.invID = targetInv:getID()

						for x2 = 0, item.width - 1 do
							for y2 = 0, item.height - 1 do
								targetInv.slots[x + x2] = targetInv.slots[x + x2] or {}
								targetInv.slots[x + x2][y + y2] = item
							end
						end

						if itemTable.saveData and itemTable.saveData.save then
							item:setData("saveData", itemTable.saveData.save(item.entity))
						end

						if (!noReplication) then
							targetInv:sendSlot(x, y, item)
						end

						if (!self.noSave) then
							rp._Inventory:Query("UPDATE items SET _invID = "..targetInv:getID()..", _x = "..x..", _y = "..y.." WHERE _itemID = "..item.id)
						end

						--[[
						if quantity > 1 then
							self:add(uniqueID, quantity-1, data, nil, nil, noReplication)
						end
						]]--

						return x, y, targetInv:getID()
					else
						return false, "noSpace"
					end
				else
					return false, "invalidIndex"
				end
			else
				local itemTable = rp.item.list[uniqueID]

				if (!itemTable) then
					return false, "invalidItem"
				end

				if (!x and !y) then
					if itemTable.stackable || ignoreMaxStack then
						local items = self:getItemsByUniqueID(itemTable.uniqueID)
						for k,v in pairs(items) do
							if v:getCount() < itemTable.maxStack || ignoreMaxStack then
								--[[
								v:addCount(1)
								if quantity - 1 > 1 then
									self:add(uniqueID, quantity - 1, data, nil, nil, noReplication, ignoreMaxStack, cback)
								elseif cback then
									cback()
								end
								]]
								
								local add_count = ignoreMaxStack and quantity or math.min(itemTable.maxStack - v:getCount(), quantity)
								
								v:addCount(add_count)
								quantity = quantity - add_count
								
								if quantity <= 0 then
									if (!noReplication) then
										targetInv:sendSlot(v.gridX, v.gridY, v)
									end
									
									if cback then
										cback()
									end
									
									return true
								end
							end
						end
					end

					x, y, bagInv = self:findEmptySlot(itemTable.width, itemTable.height)
				end

				if (bagInv) then
					targetInv = bagInv
				end

				-- if (hook.Run("CanItemBeTransfered", itemTable, rp.item.inventories[0], targetInv) == false) then
				-- 	return false, "notAllowed"
				-- end

				if (x and y) then
					targetInv.slots[x] = targetInv.slots[x] or {}
					targetInv.slots[x][y] = item
					
					rp.item.instance(targetInv:getID(), uniqueID, data, x, y, function(item)
						item.gridX = x
						item.gridY = y

						for x2 = 0, item.width - 1 do
							for y2 = 0, item.height - 1 do
								targetInv.slots[x + x2] = targetInv.slots[x + x2] or {}
								targetInv.slots[x + x2][y + y2] = item
							end
						end


						if quantity > 1 then
							targetInv:add(uniqueID, quantity-1, data, nil, nil, noReplication, ignoreMaxStack, cback)
						else
							if (!noReplication) then
								targetInv:sendSlot(x, y, item)
							end
							
							if cback then
								cback()
							end
						end
					end)

					return x, y, targetInv:getID()
				else
					if cback then
						cback(true)
					end
					
					return false, "noSpace"
				end
			end
		else
			return false, "noOwner"
		end
	end

	function META:sync(receiver, fullUpdate)
		local slots = {}

		for x, items in pairs(self.slots) do
			for y, item in pairs(items) do
				if (item.gridX == x and item.gridY == y) then
					--PrintTable(item.data)
					--print(item.uniqueID, item.id)
					slots[#slots + 1] = {item.gridX, item.gridY, item.uniqueID, item.id, item.data --[[, item:getCount() ]] }
				end
			end
		end
		
		netstream.Start(receiver, "inv", slots, self:getID(), self.w, self.h, (receiver == nil or fullUpdate) and self.owner or nil, self.vars or {})

		for k, v in pairs(self:getItems()) do
			v:call("onSendData", receiver)
		end
	end
end

rp.meta.inventory = META

if SERVER then
	-- util.AddNetworkString("rp.AddInventory")
	-- net.Receive("rp.AddInventory",function(len, ply)
	-- 	local entity = net.ReadEntity()
	-- 	local uniqueID = net.ReadString()

	-- 	ply.takedBagID = entity.itemTable:getData("id")
	-- 	entity:Remove()

	-- 	local inventory = rp.item.inventories[ply:getInvID()]
	-- 	inventory:add(uniqueID)
	-- end)
end