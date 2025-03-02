rp.item.list = {}
rp.item.base = rp.item.base or {}
rp.item.instances = rp.item.instances or {}
rp.item.inventories = rp.item.inventories or {
	[0] = {}
}
rp.item.inventoryTypes = rp.item.inventoryTypes or {}
rp.item.inventorySlot = rp.item.inventorySlot or {}
rp.item.recipes = rp.item.recipes or {}
rp.item.loot = rp.item.loot or {}

rp.item.gestures = {
	[1] = ACT_GMOD_GESTURE_ITEM_DROP,
	[2] = ACT_PICKUP_GROUND,
	[3] = ACT_GMOD_GESTURE_ITEM_GIVE,
}

rp.include(GM.FolderName.."/gamemode/main/inventory/meta/item_sh.lua")

-- Declare some supports for logic inventory
local zeroInv = rp.item.inventories[0]
function zeroInv:getID()
	return 0
end

-- WARNING: You have to manually sync the data to client if you're trying to use item in the logical inventory in the vgui.
function zeroInv:add(uniqueID, quantity, data)
	quantity = quantity or 1

	if (quantity > 0) then
		if (!isnumber(uniqueID)) then
			if (quantity > 1) then
				for i = 1, quantity do
					self:add(uniqueID, 1, data)
				end

				return
			end

			local itemTable = rp.item.list[uniqueID]

			if (!itemTable) then
				return false, "invalidItem"
			end

			rp.item.instance(0, uniqueID, data, 1, 1, function(item)
				self[item:getID()] = item
			end)

			return nil, nil, 0
		end
	else
		return false, "notValid"
	end
end

function rp.CreateInventorySlot(id, count)
	rp.item.inventorySlot[id] = count
end

function rp.CountInventorySlot(id)
	return rp.item.inventorySlot[id]
end

function rp.item.instance(index, uniqueID, itemData, x, y, callback)
	if (uniqueID && rp.item.list[uniqueID]) then
		rp.db.insertTable({
			_invID = index,
			_uniqueID = uniqueID,
			_data = itemData,
			_x = x,
			_y = y
		}, function(data, itemID)
			local item = rp.item.new(uniqueID, itemID)

			if (item) then
				item.data = itemData or {}
				item.invID = index

				local mdl = (rp.item.list[uniqueID].randomModel and table.Random(rp.item.list[uniqueID].randomModel) or false)
				if mdl then
					item:setData("model", mdl)
					item.model = mdl
				end

				if (callback) then
					callback(item)
				end

				if (item.onInstanced) then
					item:onInstanced(index, x, y, item)
				end
			end
		end, "items")
	else
		ErrorNoHalt("Attempt to give an invalid item! ("..(uniqueID or "nil")..")\n")
	end
end

function rp.item.registerInv(invType, w, h, isBag)
	rp.item.inventoryTypes[invType] = {w = w, h = h}

	if (isBag) then
		rp.item.inventoryTypes[invType].isBag = invType
	end

	return rp.item.inventoryTypes[invType]
end

function rp.item.newInv(owner, invType, width, height, callback)
	rp.db.insertTable({
		_invType = invType,
		_charID = owner,
		_width = width or 5,
		_height = height or 5
	}, function(data, invID)
		local inventory = rp.item.createInv(width, height, invID)
		if (invType) then
			inventory.vars.isBag = invType
		end

		if (owner) then
			for k, v in ipairs(player.GetAll()) do
				if (v:getID() == owner) then
					inventory:setOwner(owner)
					inventory:sync(v)

					break
				end
			end
		end

		if (callback) then
			callback(inventory)
		end
	end, "inventories")
end

function rp.item.get(identifier)
	return rp.item.base[identifier] or rp.item.list[identifier]
end

function rp.item.getInv(invID)
	return rp.item.inventories[invID]
end

function rp.item.load(path, baseID, isBaseItem)
	local uniqueID = path:match("sh_([_%w]+)%.lua")

	if (uniqueID) then
		uniqueID = (isBaseItem and "base_" or "")..uniqueID
		rp.item.register(uniqueID, baseID, isBaseItem, path)
	else
		if (!path:find(".txt")) then
			ErrorNoHalt("Item at '"..path.."' follows invalid naming convention!\n")
		end
	end
end

local function getDTVars(ent)
    if not ent.GetNetworkVars then return nil end
    local name, value = debug.getupvalue(ent.GetNetworkVars, 1)
    if name ~= "datatable" then
        ErrorNoHalt("Warning: Datatable cannot be stored properly in inventory. Tell a developer!")
    end

    local res = {}

    for k,v in pairs(value) do
        res[k] = v.GetFunc(ent, v.index)
    end

    return res
end

function rp.item.createItem(args)
	local meta = rp.meta.item

	if args.ent then
		if rp.item.list[args.ent] then
			ErrorNoHalt("Предмет " .. args.ent .. " добавляется в конфиг дважды! Удалите один из предметов чтобы избежать конфликтов.\n")
			--debug.Trace()
			
			return rp.item.list[args.ent]
		end

		ITEM = setmetatable({}, meta)
			ITEM.name = args.name
			ITEM.onlyEntity = args.onlyEntity
			ITEM.noUseFunc = args.noUseFunc
			ITEM.model = args.model
			ITEM.icon_override = args.icon_override
			ITEM.icon = args.icon
			ITEM.randomModel = args.randomModel
			ITEM.desc = (args.desc and args.desc or "noDesc")
			ITEM.uniqueID = args.ent
			ITEM.ShopToInventory = args.ShopToInventory
			--ITEM.forceMyClass = args.forceMyClass
			ITEM.moveCallback = args.moveCallback
			ITEM.CanTake = args.CanTake or nil
			ITEM.CanHolster = args.CanHolster != false
			ITEM.DisableNetVarSave = args.DisableNetVarSave or nil
			ITEM.base = (args.base and "base_"..args.base or false)
			ITEM.hooks = args.hooks or {}
			ITEM.max = args.max
			ITEM.CanUse = args.CanUse
			ITEM.postHooks = args.postHooks or {}
			ITEM.notCanGive = args.notCanGive
			ITEM.functions = args.functions or {}
			ITEM.functions.drop = ITEM.functions.drop or {
				name = translates.Get("Выкинуть"),
				tip = "dropTip",
				icon = "icon16/world.png",
				sound = "physics/cardboard/cardboard_box_impact_bullet1.wav",
				onRun = function(item)
					------ ~~ LIMIT : START ~~ ------
					if (IsValid(item.player) and type(item.player) == 'Player') then
						local Count = item.player:GetCount(item.uniqueID); -- + item.player:getInv():getItemCount(item.uniqueID) + 
						local Max = args.max;
						if (!Max or Max == 0) then Max = rp.cfg.DroppedItemsLimit or 5; end
						
						if (Max <= Count) then 
							item.player:Notify(0, translates.Get("Вы достигли максимума!"));
							return false
						end
						
						--print(item.player:GetCount('rp_item'), rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10)
						
						if item.player:GetCount('rp_item') >= (rp.cfg.DroppedItemsLimit and (rp.cfg.DroppedItemsLimit * 2) or 10) then
							item.player:Notify(0, translates.Get("Вы достигли максимума!"));
							return false
						end
					end
					------ ~~ LIMIT : END ~~ ------
					
					if (IsValid(item.player) and item.player:IsPlayer()) then
						rp.item.RunGesture(item.player, ACT_GMOD_GESTURE_ITEM_DROP)
					end
					
					item:transfer()

					return false
				end,
				onCanRun = function(item)
					return (!IsValid(item.entity) and !item.noDrop)
				end,
				--onClientRun = function(item)
				--	if (IsValid(item.player) and type(item.player) == 'Player') then
				--		item.player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_DROP, true);
				--	end
				--end
			}
			ITEM.functions.take = ITEM.functions.take or {
				name = translates.Get("Положить в сумку"),
				tip = "takeTip",
				icon = "icon16/box.png",
				InteractMaterial = "ping_system/take_item.png",--"ping_system/apex/box.png",
				sound = "physics/cardboard/cardboard_box_impact_bullet1.wav",
				onRun = function(item)
					if item.entity.TakingItem then return false end
					
					if item.CanTake then
						if item.CanTake(item, item.player) == false then return false end 
					end
					
					item.entity.TakingItem = true
					
					local status, result = item.player:getInv():add(item.id)
					if not item.DisableNetVarSave then
						local dtvars = getDTVars(item.entity)
						if dtvars then
							item.NetVarData = item.NetVarData or {}
							for k, v in pairs(dtvars) do
								item.NetVarData[k] = v
							end
						end
					end

					--item.player:ChatPrint("helo world!")
					--if item.entity then
					--	item.player:ChatPrint("PN: "..item.entity.PrintName)
					--end

					

					if (!status) then
						item.entity.TakingItem = nil
						return false
					else
						if (item.data) then
							for k, v in pairs(item.data) do
								item:setData(k, v)
							end
						end

						rp.item.RunGesture(item.player, ACT_PICKUP_GROUND)
						
						hook.Run("Inventory.OnItemTake", item)
					end
				end,
				onCanRun = function(item)
					return IsValid(item.entity) and not item.noTake-- and (not item.CanTake or item.CanTake(item, item.player) ~= false)
				end,
				--onClientRun = function(item)
				--	if (IsValid(item.player) and type(item.player) == 'Player') then
				--		item.player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_PICKUP_GROUND, true);
				--	end
				--end
			}
			ITEM.functions.drink = ITEM.functions.drink or {
				name = translates.Get("Употребить"),
				icon = "icon16/cup.png",
				sound = "urf_foodsystem/nom.wav",
				InteractMaterial = "ping_system/eat.png",
				onRun = function(item)
					item.player:SetHealth(item.player:Health() + item.healthRestore)
					item.player:AddHunger(item.foodRestore)
				end,
				onCanRun = function(item)
					return item.isDrink != nil
				end
			}
			ITEM.functions.zdelete = ITEM.functions.zdelete or {
				name = translates.Get("Удалить"),
				tip = "deleteTip",
				icon = "icon16/cancel.png",
				confirm = true,
				onRun = function(item)
					item:remove()
					return false
				end,
				onCanRun = function(item)
					--!IsValid(item.entity) and item.noDrop
					return item.noDrop == true --or IsValid(item.entity)
				end
			}
			ITEM.functions.give = ITEM.functions.give or {
				name = translates.Get("Передать игроку"),
				tip = "giveTip",
				icon = "icon16/arrow_right.png",
				isMulti = true,
				isSelectPlayers = true,
				isRequirePlayersNear = 256,
				onClick = function(ply, targetPly, item)
					local tbl = {
						targetPly = targetPly,
						item = item
					}
					net.Start("rp.GiveItem")
					net.WriteTable(tbl)
					net.SendToServer()
					return false
				end,
				onCanRun = function(item)
					return !IsValid(item.entity) and !item.notCanGive
				end
			}
			ITEM.functions.combine = ITEM.functions.combine or {
				tip = "combineTip",
				icon = "icon16/arrow_right.png",
				onRun = function(item, data)
					local item2 = rp.item.instances[data]

					local getItemCount1 = item:getCount()
					local getItemCount2 = item2:getCount()

					local maxStack = rp.item.list[item2.uniqueID].maxStack or 0

					if getItemCount1 + getItemCount2 > maxStack && maxStack != 0 then return false end

					item2:addCount(getItemCount1, item.player)

					--local was_equipped = item:getData("equip")
					
					--print('equiped', item:getData("equip") or 'false')
					
					item:remove()
					
					--if was_equipped then
					--	item2:setData("equip", true, item.player)
					--end
					
					return false
				end,
				onCanRun = function(item, data)
					return item.stackable == true and rp.item.instances[data]
				end
			}
			ITEM.functions.useEnt = ITEM.functions.useEnt or {
				name = translates.Get("Использовать"),
				tip = "takeTip",
				icon = "icon16/plugin.png",
				InteractMaterial = "ping_system/use.png",--"ping_system/ebutton.png",
				onRun = function(item)
					item.entity:Use(item.player, item.player, USE_ON, 1)
					return false
				end,
				onCanRun = function(item)
					return IsValid(item.entity) && item.entity:GetClass() ~= "rp_item" and not item.noUseFunc
				end
			}
			/*
			ITEM.functions.sell = ITEM.functions.sell or {
				name = translates.Get("Продать"),
				icon = "icon16/money_add.png",
				InteractMaterial = "ping_system/sell_item.png",
				onRun = function()
					return false
				end,
				onClick = function(item)
					rp.WhereICanSellThis(item.uniqueID)
					surface.PlaySound('UI/buttonrollover.wav')
				end,
				onCanRun = function(item)
					return rp.VendorsNPCsWhatSells[item.uniqueID] != nil
				end
			}
			*/

			local oldBase = ITEM.base

			if (ITEM.base) then
				local baseTable = rp.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				end
			end

			if (PLUGIN) then
				ITEM.plugin = PLUGIN.uniqueID
			end

			if (ITEM.base and oldBase != ITEM.base) then
				local baseTable = rp.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				end
			end

			ITEM.width = args.width or 1
			ITEM.height = args.height or 1
			ITEM.category = args.category or "misc"

			ITEM.noTake = args.noTake or nil
			ITEM.noDrop = args.noDrop or nil
			ITEM.stackable = args.stackable or nil
			ITEM.maxStack = args.maxStack or 1
			ITEM.notCanGive = args.notCanGive or nil
			ITEM.onSpawn = args.onSpawn or nil
			ITEM.onInstanced = args.onInstanced or ITEM.onInstanced
			ITEM.saveData = args.saveData or nil

			if args.base == "ammo" then
				ITEM.ammo = args.ammoType or nil
				ITEM.ammoAmount = args.amountGiven or 10
				ITEM.ammoDesc = args.desc or ""
			elseif args.base == "bags" then
				ITEM.invWidth = args.invWidth or nil
				ITEM.invHeight = args.invHeight or nil
				ITEM.notTransfered = args.notTransfered or nil
			elseif args.base == "equipments" then
				ITEM.equipmentCategory = args.equipmentCategory or ""
				ITEM.attributes = args.attributes or {}
			elseif args.base == "weapons" then
				ITEM.weaponCategory = args.weaponCategory or "primary"
				ITEM.onEquipWeapon = args.onEquipWeapon or nil
				ITEM.class = args.ent or "weapon_pistol"
			elseif args.base == "attachment" then
				ITEM.attachment = args.attachment or nil
			elseif args.base == "disguise" then
				ITEM.faction = args.faction or 1
			end

			if args.isDrink then
				ITEM.healthRestore = args.healthRestore or 0
				ITEM.foodRestore = args.foodRestore or 1
				ITEM.isDrink = args.isDrink or nil
			end

			ITEM.itemClass = args.itemClass or ITEM.uniqueID

			if (ITEM.onRegistered) then
				ITEM:onRegistered(ITEM)
			end

			(isBaseItem and rp.item.base or rp.item.list)[ITEM.uniqueID] = ITEM
		return ITEM
	else
		ErrorNoHalt("You tried to register an item without 'ent'!\n")
	end
end

function rp.item.register(uniqueID, baseID, isBaseItem, path, luaGenerated)
	local meta = rp.meta.item

	if (uniqueID) then
		ITEM = (isBaseItem and rp.item.base or rp.item.list)[uniqueID] or setmetatable({}, meta)
			ITEM.desc = "noDesc"
			ITEM.uniqueID = uniqueID
			ITEM.base = baseID
			ITEM.isBase = isBaseItem
			ITEM.hooks = ITEM.hooks or {}
			ITEM.postHooks = ITEM.postHooks or {}
			ITEM.functions = ITEM.functions or {}

			local oldBase = ITEM.base

			if (ITEM.base) then
				local baseTable = rp.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				else
					ErrorNoHalt("Item '"..ITEM.uniqueID.."' has a non-existent base! ("..ITEM.base..")\n")
				end
			end

			if (PLUGIN) then
				ITEM.plugin = PLUGIN.uniqueID
			end

			if (!luaGenerated and path) then
				rp.util.include(path)
			end

			if (ITEM.base and oldBase != ITEM.base) then
				local baseTable = rp.item.base[ITEM.base]

				if (baseTable) then
					for k, v in pairs(baseTable) do
						if (ITEM[k] == nil) then
							ITEM[k] = v
						end

						ITEM.baseTable = baseTable
					end

					local mergeTable = table.Copy(baseTable)
					ITEM = table.Merge(mergeTable, ITEM)
				else
					ErrorNoHalt("Item '"..ITEM.uniqueID.."' has a non-existent base! ("..ITEM.base..")\n")
				end
			end

			ITEM.width = ITEM.width or 1
			ITEM.height = ITEM.height or 1
			ITEM.category = ITEM.category or "misc"

			if (ITEM.onRegistered) then
				ITEM:onRegistered()
			end

			(isBaseItem and rp.item.base or rp.item.list)[ITEM.uniqueID] = ITEM
		if (luaGenerated) then
			return ITEM
		else
			ITEM = nil
		end
	else
		ErrorNoHalt("You tried to register an item without uniqueID!\n")
	end
end

function rp.item.loadFromDir(directory)
	local files, folders

	files = file.Find(directory.."/base/*.lua", "LUA")

	for k, v in ipairs(files) do
		rp.item.load(directory.."/base/"..v, nil, true)
	end

	files, folders = file.Find(directory.."/*", "LUA")

	for k, v in ipairs(folders) do
		if (v == "base") then
			continue
		end

		for k2, v2 in ipairs(file.Find(directory.."/"..v.."/*.lua", "LUA")) do
			rp.item.load(directory.."/"..v .. "/".. v2, "base_"..v)
		end
	end

	for k, v in ipairs(files) do
		rp.item.load(directory.."/"..v)
	end
end

function rp.item.new(uniqueID, id)
	if (rp.item.instances[id] and rp.item.instances[id].uniqueID == uniqueID) then
		return rp.item.instances[id]
	end

	local stockItem = rp.item.list[uniqueID]
	if (stockItem) then
		local item = setmetatable({}, {__index = stockItem})
		item.id = id
		item.data = {}

		rp.item.instances[id] = item

		return item
	else
		ErrorNoHalt("Attempt to index unknown item '"..uniqueID.."'\n")
	end
end

do
	rp.include(GM.FolderName.."/gamemode/main/inventory/meta/inventory_sh.lua")

	function rp.item.setInventoryID(ply, callback)
		rp._Inventory:Query("SELECT _invID FROM inventories WHERE _charID = "..ply:SteamID64().." AND _invType = 'player';", function(inventory)
			ply:SetNWInt("InventoryID",inventory[1]["_invID"])
			
			if callback then
				callback()
			end
		end)
	end

	function rp.item.createInv(w, h, id, slots)
		local inventory = setmetatable({w = w, h = h, id = id, slots = slots or {}, vars = {}}, rp.meta.inventory)
		rp.item.inventories[id] = inventory
		
		return inventory
	end

	local function loadPlayer(ply)
		print(ply:Name(), 'loading inventory...')
		rp.item.setInventoryID(ply, function()
			rp.item.loadInventory(ply, function()
				print(ply:Name(), 'inventory loaded')
				
				hook.Run('PlayerInventoryLoaded', ply)
				
				for k, v in pairs(rp.item.inventories) do
					if v.vars and v.vars.isBag then
						v:sync(ply)
					end
				end
			end)
		end)
	end
	
	if SERVER then 
		hook.Add("PlayerDataLoaded","rp.LoadInventorySystem",function(ply)
			--create inventory if not
			rp._Inventory:Query("SELECT * FROM inventories WHERE _charID = "..ply:SteamID64().." AND _invType = 'player';", function(inventory)
				if not IsValid(ply) then return end
				
				if #inventory < 1 then
					ply.isNewInventory = true
					
					rp._Inventory:Query("INSERT INTO inventories (_charID, _invType, _width, _height) VALUES(?,'player',?,?);", ply:SteamID64(), rp.cfg.InventoryDefault[1], rp.cfg.InventoryDefault[2], function()
						if not IsValid(ply) then return end
						loadPlayer(ply)
						--rp.item.setInventoryID(ply)
						--rp.item.loadInventory(ply)
					end)
				else
					--rp.item.setInventoryID(ply)
					--rp.item.loadInventory(ply)
					loadPlayer(ply)
				end
			end)
			--install inventory player
			--timer.Simple(2,function()
			--	rp.item.setInventoryID(ply)
			--	rp.item.loadInventory(ply)
			--end)
			--load bags inventory
		end)
	end

	function rp.item.loadInventory(ply, callback)
		rp._Inventory:Query("SELECT _invID, _width, _height FROM inventories WHERE _charID =?;", ply:SteamID64(), function(inventory)
			if inventory then
				local createInventory = rp.item.createInv(inventory[1]["_width"], inventory[1]["_height"], inventory[1]["_invID"])
				rp.item.restoreInv(inventory[1]["_invID"], inventory[1]["_width"], inventory[1]["_height"], function()
					if not IsValid(ply) then return end
					
					if ply.isNewInventory then
						local inv = ply:getInv()
						
						if rp.item.loot["started"] then
							for k,v in pairs(rp.GenerateLoot(math.random(3,6), "started")) do
								timer.Simple(k,function()
									inv:add(v.uniqueID)
								end)
							end
						end
						
						if callback then 
							callback()
						end
					elseif callback then 
						callback()
					end
				end, createInventory, ply)
			elseif callback then 
				callback()
			end
		end)
	end

	function rp.item.restoreInv(invID, w, h, callback, inv, ply)
		if (type(invID) != "number" or invID < 0) then
			error("Attempt to restore inventory with an invalid ID!")
		end

		local inventory = inv || rp.item.createInv(w, h, invID)
		if IsValid(ply) then inventory:setOwner(ply) end

		rp._Inventory:Query("SELECT _itemID, _uniqueID, _data, _x, _y FROM items WHERE _invID =?;", invID, function(data)
			local badItemsUniqueID = {}

			if (data) then
				local slots = {}
				local badItems = {}

				for _, item in ipairs(data) do
					local x, y = tonumber(item._x), tonumber(item._y)
					local itemID = tonumber(item._itemID)
					local data = util.JSONToTable(item._data or "[]")

					if (x and y and itemID) then
						if (x <= w and x > 0 and y <= h and y > 0) then
							local item2 = rp.item.new(item._uniqueID, itemID)

							if (item2) then
								item2.data = {}
								if (data) then
									item2.data = data
								end

								item2.gridX = x
								item2.gridY = y
								item2.invID = invID
								item2.uniqueID = item._uniqueID
								item2.model = item2:getModel()

								for x2 = 0, item2.width - 1 do
									for y2 = 0, item2.height - 1 do
										slots[x + x2] = slots[x + x2] or {}
										slots[x + x2][y + y2] = item2
									end
								end

								if (item2.onRestored) then
									item2:onRestored(item2, invID)
								end
							else
								badItemsUniqueID[#badItemsUniqueID + 1] = item._uniqueID
								badItems[#badItems + 1] = itemID
							end
						else
							badItemsUniqueID[#badItemsUniqueID + 1] = item._uniqueID
							badItems[#badItems + 1] = itemID
						end
					end
				end

				inventory.slots = slots
				inventory:sync(ply)

				if (table.Count(badItems) > 0) then
					rp._Inventory:Query("DELETE FROM items WHERE _itemID IN ("..table.concat(badItems, ", ")..")")
				end
			end

			if (callback) then
				callback(inventory, badItemsUniqueID)
			end
		end)
	end

	if (CLIENT) then
		netstream.Hook("item", function(uniqueID, id, data, invID)
			local stockItem = rp.item.list[uniqueID]
			local item = rp.item.new(uniqueID, id)

			item.data = {}
			if (data) then
				item.data = data
			end

			item.invID = invID or 0
		end)

		netstream.Hook("inv", function(slots, id, w, h, owner, vars)
			local character = LocalPlayer()

			--print('inv', id, owner)
			--PrintTable(slots)
			
			if (character) then
				local inventory = rp.item.createInv(w, h, id)
				inventory:setOwner((IsValid(character) and character:getID()) or -1) -- LocalPlayer() doesn't have time to load
				inventory.slots = {}
				inventory.vars = vars

				local x, y
				
				for k, v in ipairs(slots) do
					x, y = v[1], v[2]

					inventory.slots[x] = inventory.slots[x] or {}

					local item = rp.item.new(v[3], v[4])
					
					item.data = {}
					if (v[5]) then
						item.data = v[5]
					end

					item.invID = item.invID or id
					item.gridX = x
					item.gridY = y
					item.uniqueID = v[3]
					inventory.slots[x][y] = item
					--item:setData("count", v[6], false)
					
					--PrintTable(item)
				end

				--character.vars.inv = character.vars.inv or {}

				rp.item.inventories[id] = inventory

				if rp.LootInventory.Panels and rp.LootInventory.Panels.InventoryMenu and rp.LootInventory.Panels.InventoryMenu.PlayerInventory and rp.LootInventory.Panels.InventoryMenu.PlayerInventory.invID == id and not (IsValid(rp.Inventory.Panels.CloseButton) and rp.Inventory.Panels.CloseButton.Closing) then
					local removing_inv
					
					if IsValid(rp.Inventory.Panels.InventoryMenu) then
						removing_inv = rp.Inventory.Panels.InventoryMenu.ToDel
						rp.Inventory.Panels.InventoryMenu.ToDel = true
					end
					
					--print('Delete loot 1')
					
					timer.Simple(0.01, function()
						rp.LootInventory.Panels.InventoryMenu:Remove()
						
						if not removing_inv then
							for k, v in pairs(rp.Inventory.Panels) do
								if IsValid(v) then
									v:Remove()
								end
							end
							
							hook.Run("rp.OpenInventory")
						end
						
						rp.item.CreateInventory(true, inventory, id, (inventory.vars.isBag == 'ent_shop') and {
							name = 'Ваш магазин', 
							disableTakeAll = true,
						} or {})
					end)
					
				elseif IsValid(rp.Inventory.Panels.InventoryMenu) and not rp.Inventory.Panels.InventoryMenu.ToDel and not (IsValid(rp.Inventory.Panels.CloseButton) and rp.Inventory.Panels.CloseButton.Closing) then
					local saved_x, saved_y = rp.Inventory.Panels.InventoryMenu:GetPos()
					rp.Inventory.Panels.InventoryMenu.ToDel = true
					
					--print('Delete inv 1')
					
					timer.Simple(0.01, function()
						for k, v in pairs(rp.Inventory.Panels) do
							if IsValid(v) then
								v:Remove()
							end
						end
						
						hook.Run("rp.OpenInventory")
						
						rp.Inventory.Panels.InventoryMenu:SetPos(saved_x, saved_y)
					end)
				end
				
				if g_ContextMenu:IsVisible() or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) then
					rp.RefreshContextMenu()
				end
				
				-- for k, v in ipairs(character:getInv(true)) do
				-- 	if (v:getID() == id) then
				-- 		character:getInv(true)[k] = inventory
				-- 		rp.item.getInv(LocalPlayer():getInvID()) = inventory

				-- 		return
				-- 	end
				-- end

				--table.insert(character.vars.inv, inventory)
			end
		end)

		netstream.Hook("invData", function(id, key, value)
			local item = rp.item.instances[id]

			if (item) then
				item.data = item.data or {}
				item.data[key] = value

				local panel = item.invID and rp.gui["inv"..item.invID] or IsValid(rp.gui.inv1) and rp.gui.inv1 or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) and rp.Inventory.Panels.InventoryMenu.PlayerInventory

				if (panel and panel.panels) then
					local icon = panel.panels[id]

					if IsValid(icon) then
						icon:SetToolTip(item:getName(), item:getDesc() or "")
					end
				end
			end
		end)

		netstream.Hook("invSet", function(invID, x, y, uniqueID, id, owner, data, a)
			local character = LocalPlayer()
			local inventory = invID and rp.item.inventories[invID]

			if (owner == -1 and not (inventory and inventory.vars and inventory.vars.isBag)) then return end

			if (owner) then
				character = rp.char and rp.char.loaded and rp.char.loaded[owner] or LocalPlayer()
			end
			
			--print('Inv set', invID, uniqueID, owner, inventory.owner)
			
			if (character) then
				if (inventory) then
					if rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) and inventory.owner == character:SteamID64() and LocalPlayer():getInv():getID() ~= invID then 
						return
					end
					
					local item = uniqueID and id and rp.item.new(uniqueID, id) or nil
					item.invID = invID
					
					item.data = {}
					-- Let's just be sure about it kk?
					if (data) then
						item.data = data
					end

					inventory.slots[x] = inventory.slots[x] or {}
					inventory.slots[x][y] = item

					if not (inventory.vars and inventory.vars.isBag) and inventory.owner == character:SteamID64() and (g_ContextMenu:IsVisible() or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu)) then
						rp.RefreshContextMenu()
					end

					local panel = owner == -1 and rp.gui["inv"..invID] or owner ~= -1 and (IsValid(rp.gui.inv1) and rp.gui.inv1 or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) and (rp.Inventory.Panels.InventoryMenu.PlayerInventory.invID == invID) and rp.Inventory.Panels.InventoryMenu.PlayerInventory or rp.LootInventory and IsValid(rp.LootInventory.Panels.InventoryMenu) and (rp.LootInventory.Panels.InventoryMenu.PlayerInventory.invID == invID) and rp.LootInventory.Panels.InventoryMenu.PlayerInventory)

					if (IsValid(panel)) then
						local icon = panel:addIcon(item.model or "models/props_junk/popcan01a.mdl", x, y, item.width, item.height)

						if (IsValid(icon)) then
							icon:SetToolTip(item:getName(), item:getDesc() or "")
							icon.itemID = item.id

							panel.panels[item.id] = icon
						end
					end
				end
			end
		end)

		netstream.Hook("invMv", function(invID, itemID, x, y)
			local inventory = rp.item.inventories[invID]
			local panel = IsValid(rp.gui.inv1) and rp.gui.inv1 or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) and rp.Inventory.Panels.InventoryMenu.PlayerInventory
			
			if (inventory != nil and panel != nil) then
				local icon = panel.panels[itemID]

				if (IsValid(icon)) then
					icon:move({x2 = x, y2 = y}, panel, true)
				end
			end
		end)

		netstream.Hook("invRm", function(id, invID, owner)
			local character = LocalPlayer()

			-- if (owner) then
			-- 	character = rp.char.loaded[owner]
			-- end

			if (character) then
				local inventory = rp.item.inventories[invID]

				if (inventory and inventory:getItems() and inventory:getItems()[id]) then
					inventory:remove(id)

					if not (inventory.vars and inventory.vars.isBag) and inventory.owner == character:SteamID64() and (g_ContextMenu:IsVisible() or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu)) then
						rp.RefreshContextMenu()
					end
					
					
					local panel = rp.gui["inv"..invID] or IsValid(rp.gui.inv1) and rp.gui.inv1 or rp.Inventory and IsValid(rp.Inventory.Panels.InventoryMenu) and (rp.Inventory.Panels.InventoryMenu.PlayerInventory.invID == invID) and rp.Inventory.Panels.InventoryMenu.PlayerInventory or rp.LootInventory and IsValid(rp.LootInventory.Panels.InventoryMenu) and (rp.LootInventory.Panels.InventoryMenu.PlayerInventory.invID == invID) and rp.LootInventory.Panels.InventoryMenu.PlayerInventory
					
					if (IsValid(panel)) then
						local icon = panel.panels[id]

						if (IsValid(icon)) then
							for k, v in ipairs(icon.slots or {}) do
								if (v.item == icon) then
									v.item = nil
								end
							end

							icon:Remove()
						end
					end
				end
			end
		end)
	else
		function rp.item.loadItemByID(itemIndex, recipientFilter)
			local range
			if (type(itemIndex) == "table") then
				range = "("..table.concat(itemIndex, ", ")..")"
			elseif (type(itemIndex) == "number") then
				range = "(".. itemIndex ..")"
			else
				return
			end

			rp._Inventory:Query("SELECT _itemID, _uniqueID, _data FROM items WHERE _itemID IN "..range, function(data)
				if (data) then
					for k, v in ipairs(data) do
						local itemID = tonumber(v._itemID)
						local data = util.JSONToTable(v._data or "[]")
						local uniqueID = v._uniqueID
						local itemTable = rp.item.list[uniqueID]

						if (itemTable and itemID) then
							local item = rp.item.new(uniqueID, itemID)

							item.data = data or {}
							item.invID = 0
						end
					end
				end
			end)
		end

		netstream.Hook("invMv", function(client, oldX, oldY, x, y, invID, newInvID)
			oldX, oldY, x, y, invID = tonumber(oldX), tonumber(oldY), tonumber(x), tonumber(y), tonumber(invID)
			if (!oldX or !oldY or !x or !y or !invID) then return end

			local character = client
			if client:GetJobTable().CantUseInventory then return end

			if (character) then
				local inventory = rp.item.inventories[invID]

				if (!inventory or inventory == nil) then
					inventory:sync(client)
				end

				if ((inventory.owner == -1 or !inventory.owner or (inventory:getReceiver():SteamID64() == character:getID())) or (inventory.onCheckAccess and inventory:onCheckAccess(client))) then
					local item = inventory:getItemAt(oldX, oldY)

					if (item) then
						if (newInvID and invID != newInvID and newInvID != "disagreement") then
							--print(item.notCanGive, tonumber(invID), tonumber(character:getInv():getID()), tonumber(invID) == tonumber(character:getInv():getID()))
							if item.notCanGive and (tonumber(invID) == tonumber(character:getInv():getID())) then return end
							
							local inventory2 = rp.item.inventories[newInvID]
							
							if (inventory2) then
								local result = item:transfer(newInvID, x, y, client)
								
								if isentity(inventory2.owner) and IsValid(inventory2.owner) then
									rp.item.RunGesture(inventory2.owner, ACT_GMOD_GESTURE_ITEM_GIVE)
								end
								
								if result and IsValid(inventory.entity) then
                                    hook.Call('Inventory.OnMoveItem', nil, character, inventory, inventory.entity, item);
                                end
							end

							return
						end

						if (inventory:canItemFit(x, y, item.width, item.height, item)) then
							if item:getCount() > 1 && newInvID && newInvID == "disagreement" then
								if inventory:canItemFit(x, y, item.width, item.height, rp.item.instances[0]) then
									inventory:add(item.uniqueID, 1, {}, x, y)
									item:addCount(-1)
								end
								return
							end

							item.gridX = x
							item.gridY = y

							for x2 = 0, item.width - 1 do
								for y2 = 0, item.height - 1 do
									local oldX = inventory.slots[oldX + x2]

									if (oldX) then
										oldX[oldY + y2] = nil
									end
								end
							end

							for x2 = 0, item.width - 1 do
								for y2 = 0, item.height - 1 do
									inventory.slots[x + x2] = inventory.slots[x + x2] or {}
									inventory.slots[x + x2][y + y2] = item
								end
							end

							local receiver = inventory:getReceiver()

							if (receiver and type(receiver) == "table") then
								for k, v in ipairs(receiver) do
									if (v != client) then
										netstream.Start(v, "invMv", invID, item:getID(), x, y)
									end
								end
							end

							--print('Sync to', client)
							
							if IsValid(client) then
								inventory:sync(client)
							end

							if (!inventory.noSave) then
								rp._Inventory:Query("UPDATE items SET _x = "..x..", _y = "..y.." WHERE _itemID = "..item.id)
							end
						end
					end
				end
			end
		end)

		netstream.Hook("invShopAdd", function(client, oldX, oldY, x, y, invID, newInvID, price, amount)
			if not IsValid(client) or client:GetJobTable().CantUseInventory then return end
			
			price 	= tonumber(price or 50) or 50
			amount 	= tonumber(amount or 1) or 1
			
			local inventoryFrom = rp.item.inventories[invID]
			local inventoryTo = rp.item.inventories[newInvID]
			
			if not inventoryFrom or not inventoryTo then 
				return 
			end
			
			local ownerFrom = isentity(inventoryFrom.owner) and IsValid(inventoryFrom.owner) and inventoryFrom.owner:SteamID64() or inventoryFrom.owner
			local ownerTo = isentity(inventoryTo.owner) and IsValid(inventoryTo.owner) and inventoryTo.owner:SteamID64() or inventoryTo.owner
			
			if ownerFrom == ownerTo and inventoryTo.vars.isBag == 'ent_shop' then
				local item = inventoryFrom:getItemAt(oldX, oldY)
				
				if item then
					local count = item:getCount()
					
					if amount > count then 
						return rp.Notify(client, NOTIFY_ERROR, rp.Term('EntShop::NotEnoughItems'))
					end
					
					inventoryTo:add(item.uniqueID, amount, {price = price}, nil, nil, true, true, function(failed)
						if not failed then
							local new_item = inventoryTo:hasItem(item.uniqueID)
							new_item:setData('price', price)
							
							if amount < count then
								item:addCount(-amount)
							else
								item:remove()
							end
						end
						
						inventoryTo:sync()
					end)
					
					if result then
						rp.item.RunGesture(client, ACT_GMOD_GESTURE_ITEM_GIVE)
					end
				end
			end
		end)
		
		netstream.Hook("invAct", function(client, action, item, invID, data)
			if (!client) then
				return
			end

			if client:GetJobTable().CantUseInventory then return end

			local inventory = rp.item.inventories[invID]

			-- if (type(item) != "Entity") then
			-- 	if (!inventory or !inventory.owner or inventory.owner != character:getID()) then
			-- 		return
			-- 	end
			-- end

			if (hook.Run("CanPlayerInteractItem", client, action, item, data) == false) then
				return
			end

			if (type(item) == "Entity") then
				if (IsValid(item)) then
					local entity = item
					local itemID = item.nutItemID
					item = rp.item.instances[itemID]
					if (!item) then
						return
					end

					item.entity = entity
					item.player = client
				else
					return
				end
			elseif (type(item) == "number") then
				item = rp.item.instances[item]

				if (!item) then
					return
				end

				item.player = client
			end

			if (item.entity) then
				if (item.entity:GetPos():Distance(client:GetPos()) > 96) then
					return
				end
			elseif (inventory and !inventory:getItemByID(item.id)) then
				return
			end

			local callback = item.functions[action]
			local oldInvID = item.invID
			local oldPlayer = item.player
			
			if (callback) then
				if (callback.onCanRun and callback.onCanRun(item, data) == false) then
					item.entity = nil
					item.player = nil

					return
				end

				local entity = item.entity
				local result

				if (item.hooks[action]) then
					result = item.hooks[action](item, data)
				end

				if (result == nil) then
					result = callback.onRun(item, data)
				end

				if (item.postHooks[action]) then
					item.postHooks[action](item, result, data)
				end

				hook.Run("OnPlayerInteractItem", client, action, item, result, data)

				if action == 'combine' then
					local gInventory = rp.item.inventories[oldInvID or -1];
					
					if gInventory and IsValid(gInventory.entity) then
						hook.Call('Inventory.OnCombineItem', nil, oldPlayer, gInventory, gInventory.entity, item);
					end
				end
				
				if (result != false) then
					if (IsValid(entity)) then
						entity.rpIsSafe = true
						entity:Remove()
					else
						if item:getCount() > 1 then
							item:addCount(-1)
						else
							item:remove()
						end
					end
				end

				item.entity = nil
				item.player = nil
			end
		end)

		util.AddNetworkString("rp.ShopBuyItem")
		util.AddNetworkString("rp.GiveItem")
		net.Receive("rp.ShopBuyItem", function(len, ply)
			--local itemShop = net.ReadTable()
			--local itemBase = rp.item.list[itemShop.uniqueID]
			local itemShop = net.ReadString()
			
			local realItemShop
			for k, v in pairs(rp.item.shop) do
				if realItemShop then break end
				
				for k1, v1 in pairs(v) do
					if v1.content then
						--if v1.content == itemShop.content then
						if v1.content == itemShop then
							realItemShop = v1
							break
						end
					--elseif v1.uniqueID == itemShop.uniqueID then
					elseif v1.uniqueID == itemShop then
						realItemShop = v1
						break
					end
				end
			end
			
			--PrintTable(realItemShop)
			
			if not realItemShop then return end
			itemShop = realItemShop

			local itemBase = rp.item.list[itemShop.uniqueID]
			
			if itemShop.allowed and table.Count(itemShop.allowed) > 0 then
				if itemShop.allowed[ply:Team()] ~= true then return end
			end
			
			if itemShop.unlockTime and itemShop.unlockTime > ply:GetPlayTime() then
				return
			end
			
			local discounted_price = ply.GetAttributeAmount and ply:GetAttributeAmount('trader') and math.ceil(itemShop.price * (1 - ply:GetAttributeAmount('trader') / 100)) or itemShop.price

			if ply:GetMoney() < discounted_price then
				return ply:Notify(0, translates.Get("У вас недостаточно денег!"))
			end
			
			local countItem = ply:getInv():getItemCount(itemShop.uniqueID) + ply:GetCount(itemShop.uniqueID)
			if itemShop.max and itemShop.max ~= 0 and itemShop.max <= countItem then
				return ply:Notify(0, translates.Get("Вы достигли максимума!"))
			end
			
			if ((!itemShop.max or itemShop.max == 0) and !itemShop.onlyEntity and ((rp.cfg.BoughtShipmentLimit or 5) <= ply:GetCount(itemShop.uniqueID))) then
				return ply:Notify(0, translates.Get("Вы достигли максимума!"))
			end

			local is_ammo = itemBase and itemBase.ammo
			
			if is_ammo and ply:GetJobTable() and ply:GetJobTable().dontBuyAmmo then
				return ply:Notify(0, translates.Get("Вы не можете покупать патроны!"))
			end
				
			local translate_str = itemShop.ShopToInventory and "Вы купили '%s' за %s, предмет помещён в инвентарь" or "Вы купили '%s' за %s"
			ply:Notify(0, translates.Get(translate_str, itemShop.name, rp.FormatMoney(discounted_price)))
			
			if is_ammo then
				ply:GiveAmmo(itemBase.ammoAmount, itemBase.ammo)
				ply:EmitSound("items/ammo_pickup.wav", 110)
				ply:AddMoney(-discounted_price)
				return
			end
			
			if not itemShop.onlyEntity then
				if itemShop.ShopToInventory then
					local inv = ply:getInv()
					local status, result = inv:add(itemShop.uniqueID)--, count)
			        if status then
			        	timer.Simple(0.25, function()
				             inv:sync(ply, true)
				        end)
			        else
			            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_noplace"))
			            return
			        end
				else
					rp.item.spawn(itemShop.uniqueID, ply, function(item, entity)
						if IsValid(entity) then 
							timer.Simple(1, function()
								itemShop.count = itemShop.count || 1
								if itemShop.count && itemShop.content then
									item:getInv():add(itemShop.content, itemShop.count)
								end
							end)
							entity:GetPhysicsObject():EnableMotion(true)
							entity:GetPhysicsObject():Wake()
							ply:AddCount(itemShop.uniqueID, entity)
						end
					end)
				end
			end

			ply:AddMoney(-discounted_price)
		end)

		net.Receive("rp.GiveItem",function(len, ply)
			local tbl = net.ReadTable()

			if not IsValid(tbl.targetPly) then return end

			local targetPlyInv = tbl.targetPly:getInv()
			local itemBase = rp.item.list[tbl.item.uniqueID]
			local item = rp.item.instances[tbl.item.id]

			local realItemShop
			for k, v in pairs(rp.item.shop) do
				if realItemShop then break end
				
				for k1, v1 in pairs(v) do
					if v1.content then
						if v1.content == tbl.item.content then
							realItemShop = v1
							break
						end
					elseif v1.uniqueID == tbl.item.uniqueID then
						realItemShop = v1
						break
					end
				end
			end

			if targetPlyInv:IsItemLimit(tbl.targetPly, tbl.item.uniqueID, realItemShop and realItemShop.max or 10) then
				return ply:Notify(0, translates.Get("Игрок достиг максимума!"))
			end

			local x, y, bagInv = targetPlyInv:findEmptySlot(itemBase.width, itemBase.height)	
			if !x and !y then return ply:Notify(1, translates.Get("Нет места в инвентаре!")) end

			local count = item:getCount() or 1
			item.data.count = nil
			
			targetPlyInv:add(tbl.item.uniqueID, count, item.data)
			item:remove()

			rp.Notify(tbl.targetPly, NOTIFY_GENERIC, translates.Get("Вам передали '%s'!", itemBase.name))
			rp.Notify(ply, NOTIFY_GENERIC, translates.Get("Вы передали '%s' игроку %s!", itemBase.name, tbl.targetPly:Name()))
		end)
	end

	-- Instances and spawns a given item type.
	function rp.item.spawn(uniqueID, position, callback, angles, data)
		rp.item.instance(0, uniqueID, data or {}, 1, 1, function(item)
			local entity = item:spawn(position, angles)
			item.entity = entity;

			if (callback) then
				callback(item, entity)
			end
		end)
	end
end

rp.item.loadFromDir("rp_base/gamemode/main/inventory/items")
rp.item.loadFromDir(engine.ActiveGamemode() .. "/gamemode/config/items")

if CLIENT then
	net.Receive('rp.inventory.RunGesture', function()
		local ply = net.ReadEntity()
		
		if IsValid(ply) and ply:IsPlayer() and ply:Alive() then
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, rp.item.gestures[net.ReadUInt(3)], true)
		end
	end)
	
	function rp.makeItem(ent)
		if !IsValid(ent) then return end
		ent.getItemID = function()
			return ent:GetNWString("uniqueID")
		end

		ent.getItemTable = function()
			return rp.item.list[ent:getItemID()]
		end

		ent.getData = function(key, default)
			local data = ent:getNetVar("data", {})

			return data[key] or default
		end
	end
else
	util.AddNetworkString("rp.makeItem")
	util.AddNetworkString("rp.inventory.RunGesture")
	-- util.AddNetworkString("rp.LoadInventorySystem")

	local gesture_map
	function rp.item.RunGesture(ply, gesture)
		if not gesture_map then
			gesture_map = {}
			
			for k, v in pairs(rp.item.gestures) do
				gesture_map[v] = k
			end
		end
		
		if gesture_map[gesture] and IsValid(ply) and ply:IsPlayer() and ply:Alive() then
			net.Start('rp.inventory.RunGesture')
				net.WriteEntity(ply)
				net.WriteUInt(gesture_map[gesture], 3)
			net.Broadcast()
		end
	end
	
	function rp.makeItem(ent, id)
		if !ent || !IsValid(ent) then return end

		ent.getItemID = function()
			return ent:getNetVar("id", "")
		end

		ent.getItemTable = function()
			return rp.item.list[ent:getItemID()]
		end

		ent.getData = function(key, default)
			local data = ent:getNetVar("data", {})

			return data[key] or default
		end

		function ent:setItem(itemID)
			local itemTable = rp.item.instances[itemID]

			if (itemTable) then
				local model = itemTable.onGetDropModel and itemTable:onGetDropModel(ent) or itemTable.model

				ent:SetSkin(itemTable.skin or 0)
				if (itemTable.worldModel) then
					ent:SetModel(itemTable.worldModel == true and "models/props_junk/cardboard_box004a.mdl" or itemTable.worldModel)
				else
					ent:SetModel(model)
				end
				ent:SetModel(model)
				ent:PhysicsInit(SOLID_VPHYSICS)
				ent:SetSolid(SOLID_VPHYSICS)
				ent:setNetVar("id", itemTable.uniqueID)
				ent.nutItemID = itemID
				ent.uniqueID = itemTable.uniqueID
				ent.itemTable = itemTable

				ent:SetNWString("uniqueID",itemTable.uniqueID)
				ent:SetNWString("class",itemTable.class)

				if (table.Count(itemTable.data) > 0) then
					ent:setNetVar("data", itemTable.data)
				end

				local physObj = ent:GetPhysicsObject()

				if (!IsValid(physObj)) then
					local min, max = Vector(-8, -8, -8), Vector(8, 8, 8)

					ent:PhysicsInitBox(min, max)
					ent:SetCollisionBounds(min, max)
				end

				-- if (IsValid(physObj)) then
				-- 	physObj:EnableMotion(true)
				-- 	physObj:Wake()
				-- end

				if (itemTable.onEntityCreated) then
					itemTable:onEntityCreated(ent)
				end
			end
		end

		local oldOnRemove = ent.OnRemove
		function ent:OnRemove()
			if oldOnRemove then
				oldOnRemove(self)
			end

			if (!rp.shuttingDown and !ent.nutIsSafe and ent.nutItemID) then
				local itemTable = rp.item.instances[ent.nutItemID]

				if (ent.onbreak) then
					ent:EmitSound("physics/cardboard/cardboard_box_break"..math.random(1, 3)..".wav")
					local position = ent:LocalToWorld(ent:OBBCenter())

					local effect = EffectData()
						effect:SetStart(position)
						effect:SetOrigin(position)
						effect:SetScale(3)
					util.Effect("GlassImpact", effect)

					if (itemTable.onDestoryed) then
						itemTable:onDestoryed(ent)
					end
				end

				if (itemTable) then
					if (itemTable.onRemoved) then
						itemTable:onRemoved()
					end

					--rp._Inventory:Query("DELETE FROM items WHERE _itemID = "..ent.nutItemID)
				end
			end
		end

		ent:setItem(id)
		ent:SetNWBool("isInvItem",true)
	end

	local OnItemCrafted = function(ply, state, uniqueID)
		if not IsValid(ply) then return end

		hook.Call('OnItemCrafted', GAMEMODE, ply, state, uniqueID)
		net.Start("rp.CraftedItem")
			net.WriteInt(state, 8)
		net.Send(ply)
	end

	function rp.CraftItem(ply, name)
		if !IsValid(ply) || !rp.item.recipes[name] then OnItemCrafted(OnItemCrafted, 1) return end
		local inv = ply:getInv()
		local recipe = rp.item.recipes[name]

		local isCan, items = rp.IsCanCraftItem(inv, recipe)
		if isCan then
			local x,y,bagInv = inv:findEmptySlot(recipe.result.width, recipe.result.height, true)
			if x and y then

				timer.Simple(recipe.timeCreation or rp.cfg.DefaultTimeCreation, function()
					if not IsValid(ply) or not inv then return end
					local status, result = inv:add(recipe.result.uniqueID)
					--print(status, result)
					if status == false then
					    rp.Notify(ply, NOTIFY_RED, translates.Get("Нет места в инвентаре!")) -- rp.Term("VendorNpc_fullInv"))
					    OnItemCrafted(ply, 2, recipe.result.uniqueID)
					    return
					end
					
					for k,v in pairs(recipe.items) do
						local count = v.count
						if count > 0  then
							for c,d in pairs(items) do
								if d.uniqueID == v.item.uniqueID then
									if d:getCount() > count then
										local itemCount = d:getCount()
										d:addCount(-count)
										count = count - itemCount
									else
										count = count - d:getCount()
										inv:remove(d.id)
									end
								end
							end
						end
					end
					
					OnItemCrafted(ply, 4, recipe.result.uniqueID)
					--print("Item crafted: " .. recipe.result.uniqueID)
				end)
			else
				rp.Notify(ply, NOTIFY_RED, translates.Get("Нет места в инвентаре!"))
				OnItemCrafted(ply, 3, recipe.result.uniqueID)
				return
			end
		end
	end

	util.AddNetworkString("rp.CraftItem")
	net.Receive("rp.CraftItem",function(len, ply)
		local recipe = net.ReadString()
		rp.CraftItem(ply, recipe)
	end)

	util.AddNetworkString("rp.CraftedItem")
end

function rp.IsCanCraftItem(inv, recipe)
	for k,v in pairs(recipe.instruments) do
		local isFound = false
		for c,d in pairs(inv:getItems()) do
			if d.invID == inv:getID() && d.uniqueID == v.uniqueID then
				isFound = true
			end
		end
		if !isFound then
			return false
		end
	end

	local items = {}
	for k,v in pairs(recipe.items) do
		local count = 0
		for c,d in pairs(inv:getItems()) do
			if d.invID == inv:getID() && d.uniqueID == v.item.uniqueID && count < v.count then
				count = count + d:getCount()
				table.insert(items, d)
			end
		end
		if count < v.count then
			return false
		end
	end

	return true, items
end

rp.item.recipeMaxId = 0
function rp.AddCraftingRecipe(name, result, items, instruments, timeCreation)
	timeCreation = timeCreation or 0.5--rp.cfg.DefaultTimeCreation

	local items2 = {} 
	local instruments2 = {}

	for k,v in pairs(items) do
		if not rp.item.list[k] then return ErrorNoHalt("В рецепте \""..name.."\" не был найден item: "..k.."\n") end
		items2[k] = {
			item = rp.item.list[k],
			count = v
		}
	end

	if instruments then
		for k,v in pairs(instruments) do
			if not rp.item.list[v] then return ErrorNoHalt("В рецепте \""..name.."\" не был найден item: "..v.."\n") end
			instruments2[v] = rp.item.list[v]
		end
	end

	if not rp.item.list[result] then return ErrorNoHalt("В рецепте \""..name.."\" не был найден item: "..result.."\n") end

	rp.item.recipeMaxId = rp.item.recipeMaxId + 1

	rp.item.recipes[name] = {
		id = rp.item.recipeMaxId,
		result = rp.item.list[result], 
		items = items2,
		instruments = instruments2,
		timeCreation = timeCreation
	}
end

function rp.AddTypeLoot(name, items, func)
	local newItems = {}
	for k,v in pairs(items) do
		if not rp.item.list[v[1]] then ErrorNoHalt("В луте \""..name.."\" не был найден item: "..v[1].."\n") continue end
		newItems[v[1]] = {
			item = rp.item.list[v[1]], 
			procent = v[2]
		}
	end

	rp.item.loot[name] = {
		items = newItems,
		func = func
	}
end

function rp.InsertItem2TypeLoot(name, itemid, chance)
	if rp.item.loot[name] and rp.item.list[itemid] then
		rp.item.loot[name]["items"][itemid] = {
            ["procent"] = chance,
            ["item"] = rp.item.list[itemid]
        }
	end
end