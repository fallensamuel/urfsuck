-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_equipments.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Equipments"
ITEM.desc = "A Equipments."
ITEM.category = "Equipments"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isEquipment = true

if (CLIENT) then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(203,78,221, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		local client = item.player
		item:setData("equip", nil, client)

		client.carryEquipments = client.carryEquipments or {}

		for k,v in pairs(item.attributes) do
			client:ClearAttributeBoosts(v)
		end

		if client.carryEquipments[item.equipmentCategory].count == 1 then
			client.carryEquipments[item.equipmentCategory] = nil
		else
			client.carryEquipments[item.equipmentCategory].count = client.carryEquipments[item.equipmentCategory].count - 1
		end
		client:EmitSound("items/ammo_pickup.wav", 80)
	end
end)

ITEM.functions.EquipUn = {
	name = translates.Get("Снять"),
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		local client = item.player
		client.carryEquipments = client.carryEquipments or {}

		for k,v in pairs(item.attributes) do
			client:ClearAttributeBoosts(v)
		end

		client:EmitSound("items/ammo_pickup.wav", 80)
		if client.carryEquipments[item.equipmentCategory].count == 1 then
			client.carryEquipments[item.equipmentCategory] = nil

			for k,v in pairs(item.attributes) do
				client:ClearAttributeBoosts(v)
			end
		else
			client.carryEquipments[item.equipmentCategory].count = client.carryEquipments[item.equipmentCategory].count - 1

			for k,v in pairs(item.attributes) do
				client:SetAttributeAmount(v, client.carryEquipments[item.equipmentCategory].count)
			end
		end

		item:setData("equip", nil, client)

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = translates.Get("Одеть"),
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local client = item.player
		local inv = client:getInv()
		local items = inv:getItems()

		local x, y, bagInv
		if IsValid(item.entity) then
			x, y, bagInv = inv:findEmptySlot(item.width, item.height)
			if !x and !y then
				return
			end
		end

		client.carryEquipments = client.carryEquipments or {}

		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = rp.item.instances[v.id]
				
				if (!itemTable) then
					--client:Notify(1, "Повози админа!")

					--return false
				else
					if (itemTable.isEquipment and (client.carryEquipments[item.equipmentCategory] and client.carryEquipments[item.equipmentCategory].count and client.carryEquipments[item.equipmentCategory].count >= rp.CountInventorySlot(item.equipmentCategory)) and itemTable:getData("equip")) then
						client:Notify(1, translates.Get("Слот для %s занят! Максимум: %i", item.equipmentCategory, rp.CountInventorySlot(item.equipmentCategory)))

						return false
					end
				end
			end
		end

		if !client.carryEquipments[item.equipmentCategory] then
			client.carryEquipments[item.equipmentCategory] = item
			client.carryEquipments[item.equipmentCategory].count = 1

			for k,v in pairs(item.attributes) do
				client:UpgradeAttribute(v, 1, true)
			end
		else
			client.carryEquipments[item.equipmentCategory].count = client.carryEquipments[item.equipmentCategory].count + 1

			for k,v in pairs(item.attributes) do
				client:UpgradeAttribute(v, 1, true)
				client:SetAttributeAmount(v, client.carryEquipments[item.equipmentCategory].count)
			end
		end

		client:EmitSound("items/ammo_pickup.wav", 80)
		item:setData("equip", true, client)

		if x and y then
			item.entity:Remove()
			inv:add(item.id, nil, nil, x, y)
		end

		return false
	end,
	onCanRun = function(item)
		local count = item:getCount()
		return count < 2 && ((IsValid(item.entity) and true) || (item:getData("equip") != true && !IsValid(item.entity) && item.invID == item.player:getInvID()))
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

function ITEM:onLoadout()
	-- if (self:getData("equip")) then
	-- 	local client = self.player
	-- 	client.carryEquipments = client.carryEquipments or {}
	-- 	client.carryEquipments[self.equipmentCategory] = self
	-- end
end

hook.Add("PlayerDeath", "rp.StripEquipment", function(client)
	client.carryEquipments = {}

	local inv = rp.item.getInv(client:getInvID())
	if not inv or not inv.getItems then return end
	
	for k, v in pairs(inv:getItems()) do
		if (v.isEquipment and v:getData("equip")) then
			for d,c in pairs(v.attributes) do
				client:ClearAttributeBoosts(c)
			end
			v:setData("equip", nil)
		end
	end
end)