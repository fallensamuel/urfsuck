-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\meta\\item_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ITEM = rp.meta.item or {}
ITEM.__index = ITEM
ITEM.name = "Undefined"
ITEM.desc = ITEM.desc or "An item that is undefined."
ITEM.id = ITEM.id or 0
ITEM.uniqueID = "undefined"

function ITEM:__eq(other)
	return self:getID() == other:getID()
end

function ITEM:__tostring()
	return "item["..self.uniqueID.."]["..self.id.."]"
end

function ITEM:getID()
	return self.id
end

function ITEM:getName()
	return (CLIENT and (self.name) or self.name)
end

function ITEM:getDesc()
	if (!self.desc) then return "ERROR" end

	return (self.desc or "noDesc")
end

-- Dev Buddy. You don't have to print the item data with PrintData();
function ITEM:print(detail)
	if (detail == true) then
		print(Format("%s[%s]: >> [%s](%s,%s)", self.uniqueID, self.id, self.owner, self.gridX, self.gridY))
	else
		print(Format("%s[%s]", self.uniqueID, self.id))
	end
end

-- Dev Buddy, You don't have to make another function to print the item Data.
function ITEM:printData()
	self:print(true)
	print("ITEM DATA:")
	for k, v in pairs(self.data) do
		print(Format("[%s] = %s", k, v))
	end
end

function ITEM:call(method, client, entity, ...)
	local oldPlayer, oldEntity = self.player, self.entity

	self.player = client or self.player
	self.entity = entity or self.entity

	if (type(self[method]) == "function") then
		local results = {self[method](self, ...)}

		self.player = nil
		self.entity = nil

		return unpack(results)
	end

	self.player = oldPlayer
	self.entity = oldEntity
end

function ITEM:getOwner()
	local inventory = rp.item.inventories[self.invID]

	if (inventory) then
		return (inventory.getReceiver and inventory:getReceiver())
	end

	local id = self:getID()

	for k, v in ipairs(player.GetAll()) do
		local character = v

		if (character and character:getItemByID(id)) then
			return v
		end
	end
end

if CLIENT then
	net.Receive('inv.SendCount', function()
		local item = rp.item.instances[net.ReadUInt(32)]

		if (item) then
			item.data = item.data or {}
			item.data["count"] = net.ReadUInt(6)

			local panel = item.invID and rp.gui["inv"..item.invID] or rp.gui.inv1

			if (panel and panel.panels) then
				local icon = panel.panels[id]

				if IsValid(icon) then
					icon:SetToolTip(item:getName(), item:getDesc() or "")
				end
			end
		end
	end)
else
	util.AddNetworkString('inv.SendCount')
end

function ITEM:setData(key, value, receivers, noSave, noCheckEntity)
	self.data = self.data or {}
	self.data[key] = value

	if SERVER then
		if !noCheckEntity then
			local ent = self:getEntity()

			if IsValid(ent) then
				local data = ent:getNetVar("data", {})
				data[key] = value

				ent:setNetVar("data", data)
			end
		end

		if (receivers != false) and (receivers or self:getOwner()) then
			if key == "count" then
				net.Start('inv.SendCount')
				net.WriteUInt(self:getID(), 32)
				net.WriteUInt(value, 8)
				net.Send(receivers or self:getOwner())
			else
				netstream.Start(receivers or self:getOwner(), "invData", self:getID(), key, value)
			end
		end

		if (!noSave) then
			if (rp.db) then
				rp.db.updateTable({_data = self.data}, nil, "items", "_itemID = "..self:getID())
			end
		end
	end
end

function ITEM:getData(key, default)
	self.data = self.data or {}

	if (self.data) then
		if (key == true) then
			return self.data
		end

		local value = self.data[key]

		if (value != nil) then
			return value
		elseif (IsValid(self.entity)) then
			local data = self.entity:getNetVar("data", {})
			local value = data[key]

			if (value != nil) then
				return value
			end
		end
	else
		self.data = {}
	end

	if (default != nil) then
		return default
	end

	return
end

function ITEM:getModel()
	local itemBase = rp.item.list[self.uniqueID]

	if not itemBase then
		--print(self.uniqueID, self:getData("model"))
		return self:getData("model") or "models/props_junk/popcan01a.mdl"
	end

	if itemBase.randomModel then
		return self:getData("model")
	else
		return itemBase.model
	end
end

function ITEM:getCount()
	local count = self:getData("count")
	if count == nil then count = 1 end
	return count
end

function ITEM:addCount(i, receivers)
	local count = self:getData("count")
	if count == nil then count = 1 end
	self:setData("count", (count+i), receivers or self.player)
end

function ITEM:hook(name, func)
	if (name) then
		self.hooks[name] = func
	end
end

function ITEM:postHook(name, func)
	if (name) then
		self.postHooks[name] = func
	end
end

function ITEM:remove(sync_ply)
	local inv = rp.item.inventories[self.invID]
	local x2, y2

	if (self.invID > 0 and inv) then
		local failed = false
		for x = self.gridX, self.gridX + (self.width - 1) do
			if (inv.slots[x]) then
				for y = self.gridY, self.gridY + (self.height - 1) do
					local item = inv.slots[x][y]

					if (item and item.id == self.id) then
						inv.slots[x][y] = nil
					else
						failed = true
					end
				end
			end
		end

		if (failed) then
			local items = inv:getItems()

			inv.slots = {}
			for k, v in pairs(items) do
				if (v.invID == inv:getID()) then
					for x = self.gridX, self.gridX + (self.width - 1) do
						inv.slots[x] = inv.slots[x] or {}
						for y = self.gridY, self.gridY + (self.height - 1) do
							inv.slots[x][y] = v.id
						end
					end
				end
			end

			if IsEntity(inv.owner) and IsValid(inv.owner) and inv.owner:IsPlayer() then
				inv:sync(inv.owner, true)
			end

			if IsValid(sync_ply) and sync_ply:IsPlayer() then
				inv:sync(sync_ply, true)
			end

			return false
		end

		timer.Simple(0.25, function()
			if inv then
				if IsEntity(inv.owner) and IsValid(inv.owner) and inv.owner:IsPlayer() then
					inv:sync(inv.owner, true)
				end

				if IsValid(sync_ply) and sync_ply:IsPlayer() then
					inv:sync(sync_ply, true)
				end
			end
		end)
	else
		local inv = rp.item.inventories[self.invID]

		if (inv) then
			rp.item.inventories[self.invID][self.id] = nil
		end
	end

	if (SERVER and !noReplication) then
		local entity = self:getEntity()

		if (IsValid(entity)) then
			entity:Remove()
		end

		local receiver = inv.getReceiver and inv:getReceiver()

		if (self.invID != 0) then
			if (IsValid(receiver) and receiver and inv.owner == receiver:getID()) then
				netstream.Start(receiver, "invRm", self.id, inv:getID())
			else
				netstream.Start(receiver, "invRm", self.id, inv:getID(), inv.owner)
			end
		end

		if (!noDelete) then
			local item = rp.item.instances[self.id]

			if (item and item.onRemoved) then
				item:onRemoved()
			end

			rp._Inventory:Query("DELETE FROM items WHERE _itemID = "..self.id)
			rp.item.instances[self.id] = nil
		end
	end

	return true
end

if (SERVER) then
	function ITEM:getEntity()
		/*local id = self:getID()

		for k, v in ipairs(ents.FindByClass("rp_item")) do
			if (v.nutItemID == id) then
				return v
			end
		end
		*/

		return self.ent
	end
	-- Spawn an item entity based off the item table.
	function ITEM:spawn(position, angles)
		-- Check if the item has been created before.
		local item = self
		if (rp.item.instances[self.id]) then
			local client
			local id = self.id
			-- If the first argument is a player, then we will find a position to drop
			-- the item based off their aim.
			if (type(position) == "Player") then
				client = position
				position = position:getItemDropPos()
			end

			-- Spawn the actual item entity.
			local itemBase = rp.item.list[self.uniqueID]
			local itemClass = "rp_item"

			if itemBase.itemClass and ((not itemBase.base or itemBase.base == 'base_usable') or (itemBase.type and itemBase.type == 'entity')) then
				itemClass = itemBase.itemClass
			end

			--	if (IsValid(client) and itemClass ~= 'rp_item' and client:GetCount(itemClass) >= 3) then
			--		--print('Limit 3', itemClass, client:GetCount(itemClass))
			--		rp.Notify(client, NOTIFY_ERROR, rp.Term('JobLimit'));
			--		return
			--	end

			local entity = ents.Create(itemClass)
			if not IsValid(entity) then
				entity = ents.Create("rp_item")
			end

			if entity.SafeSetPos then
				entity:SafeSetPos(position)
			else
				entity:SetPos(position)
			end
			entity:SetAngles(angles or Angle(0, 0, 0))

			local oldInitialize = entity.Initialize
			function entity:Initialize()
				oldInitialize(self)

				rp.makeItem(self, id)

				if itemBase.saveData and itemBase.saveData.load then
					itemBase.saveData.load(self, item:getData("saveData"))
				end

				if itemBase.onInitialize then
					itemBase.onInitialize(self, client, position)
				end
			end

			if IsValid(client) then
				--print(client, entity)

				client:AddCount("rp_item", entity)

				if itemBase.itemClass then
					client:AddCount(itemBase.itemClass, entity)
				end

			end

			entity:Spawn()

			if itemBase.onSpawn then
				itemBase.onSpawn(entity, client, self)
			end

			if entity.Setowning_ent then
				entity:Setowning_ent(client)
			end
			entity.ItemOwner = client

			if (IsValid(client)) then
				entity.nutSteamID = client:SteamID()
				entity.nutCharID = client:getID()
			end

			local nwdata = item.NetVarData
			if nwdata then
				nwdata.NextPrint = nil
				for net_key, net_val in pairs(nwdata) do
					local nwfunc = entity["Set"..net_key]
					if nwfunc then
						nwfunc(entity, net_val)
					end
				end

				--if nwdata["CurAmount"] and entity.SetCurAmount then entity:SetCurAmount(nwdata["CurAmount"]) end
				--if nwdata["IsBroken"] and entity.SetIsBroken then entity:SetIsBroken(nwdata["IsBroken"]) end
			end

			-- Return the newly created entity.
			return entity
		end
	end

	-- Transfers an item to a specific inventory.
	function ITEM:transfer(invID, x, y, client, noReplication, isLogical, forceStack)
		invID = invID or 0

		if (self.invID == invID) then
			return false, "same inv"
		end

		local inventory = rp.item.inventories[invID]
		local curInv = rp.item.inventories[self.invID or 0]

		if (hook.Run("CanItemBeTransfered", self, curInv, inventory, client or self.player) == false) then
			return false, "notAllowed"
		end

		local authorized = false
		if (curInv and !IsValid(client)) then
			client = (curInv.getReceiver and curInv:getReceiver() or nil)
		end

		if client == nil && self.player && IsValid(self.player) then
			client = self.player
		end

		if (inventory and inventory.onAuthorizeTransfer and inventory:onAuthorizeTransfer(client, curInv, self)) then
			authorized = true
		end

		if (!authorized and self.onCanBeTransfered and self:onCanBeTransfered(curInv, inventory) == false) then
			return false, "notAllowed"
		end

		if IsValid(client) and invID == 0 then
			if client:GetCount('rp_item') >= (rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10) then
				client:Notify(0, translates.Get("Вы достигли максимума!"));
				return false
			end

			local itemBase = rp.item.list[self.uniqueID];
			local itemClass = "rp_item";

			if itemBase.itemClass and ((not itemBase.base or itemBase.base == 'base_usable') or (itemBase.type and itemBase.type == 'entity')) then
				itemClass = itemBase.itemClass;
			end

			if itemClass ~= "rp_item" and client:GetCount(itemClass) >= 3 then
				rp.Notify(client, NOTIFY_ERROR, rp.Term("JobLimit"));
				return false
			end
		end

		local count = self:getCount()

		if (curInv) then
			if (invID and invID > 0 and inventory) then
				local targetInv = inventory
				local bagInv

				if (!x and !y and !forceStack) then
					x, y, bagInv = inventory:findEmptySlot(self.width, self.height)
				end

				if (bagInv) then
					targetInv = bagInv
				end

				if (!x or !y) and !forceStack then
					return false, "noSpace"
				end

				local prevID = self.invID
				local status, result = inventory:add(self.id, count, nil, x, y, noReplication)

				--print('Add item', status, self.id, count)

				if (status) then
					/*
					if IsEntity(client) and IsValid(client) then
						timer.Simple(0.25, function()
							if curInv and IsValid(client) then
								curInv:sync(client, true)
							end
						end)
					end
					*/

					if (self.invID > 0 and prevID != 0) then
						curInv:remove(self.id, false, true)
						self.invID = invID

						if (self.onTransfered) then
							self:onTransfered(curInv, inventory)
						end
						hook.Run("OnItemTransfered", self, curInv, inventory)

						for k,v in pairs(rp.item.instances) do
							if v.data and v.data.id ~= nil and v.data.id == curInv:getID() and v.invID ~= 0 and curInv.vars.isBag and rp.item.list[curInv.vars.isBag].removeIsEmpty and curInv:IsEmpty() then
								v:remove()
								break
							end
							if v.data and v.data.id ~= nil and v.data.id == curInv:getID() and curInv.vars.isBag and rp.item.list[curInv.vars.isBag].removeIsEmpty and curInv:IsEmpty() then
								v:remove()
								break
							end
						end

						return true
					elseif (self.invID > 0 and prevID == 0) then
						local inventory = rp.item.inventories[0]
						inventory[self.id] = nil

						if (self.onTransfered) then
							self:onTransfered(curInv, inventory)
						end
						hook.Run("OnItemTransfered", self, curInv, inventory)

						return true
					end
				else
					return false, result
				end
			elseif (IsValid(client)) then
				if count > 1 then
					self:addCount(-1)
					rp.item.spawn(self.uniqueID, client, function(item, entity)
						if not IsValid(entity) then return end

						if IsValid(entity:GetPhysicsObject()) then
							entity:GetPhysicsObject():EnableMotion(true)
							entity:GetPhysicsObject():Wake()
						end
						hook.Run("Inventory.OnItemDrop", item, client, entity)
					end)
					return true
				end

				self.invID = 0
				curInv:remove(self.id, false, true)
				rp._Inventory:Query("UPDATE items SET _invID = 0 WHERE _itemID = "..self.id)

				if (isLogical != true) then
					local entity = self:spawn(client)

					if not IsValid(entity) then
						return false
					end

					if IsValid(entity:GetPhysicsObject()) then
						entity:GetPhysicsObject():EnableMotion(true)
						entity:GetPhysicsObject():Wake()
					end

					hook.Run("Inventory.OnItemDrop", self, client, entity)
					return entity
				else
					local inventory = rp.item.inventories[0]
					inventory[self:getID()] = self

					if (self.onTransfered) then
						self:onTransfered(curInv, inventory)
					end
					hook.Run("OnItemTransfered", self, curInv, inventory)
					hook.Run("Inventory.OnItemDrop", self, client)
					return true
				end
			else
				return false, "noOwner"
			end
		else
			return false, "invalidInventory"
		end
	end
end

rp.meta.item = ITEM
