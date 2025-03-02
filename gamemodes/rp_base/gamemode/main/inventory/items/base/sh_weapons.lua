-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_weapons.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Weapon"
ITEM.desc = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isWeapon = true
ITEM.weaponCategory = "sidearm"

-- Inventory drawing
if CLIENT then
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

ITEM.BubbleHint = {
	ico = Material("shop/filters/gun.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.5
}

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		local client = item.player
		item:setData("equip", nil, client)

		client.carryWeapons = client.carryWeapons or {}

		local weapon = client.carryWeapons[item.class]

		if (IsValid(weapon)) then
			local just_give_ammo = (weapon:GetSecondaryAmmoType() != -1) and (weapon:GetPrimaryAmmoType() == -1)
			
			if just_give_ammo then
				item:setData("ammo", item.player:GetAmmoCount(weapon:GetSecondaryAmmoType()))
				
			else
				item:setData("ammo", weapon:Clip1())
				item:setData("ammo2", weapon:Clip2())
			end

			client:StripWeapon(item.class)
			client.carryWeapons[item.class] = nil
			client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav", 80)
			
			if weapon.RemovingWeapon and weapon.NeedToRemove then
				timer.Simple(0, function()
					if not item then return end
					
					if IsValid(item.entity) then
						item.entity:Remove()
					end
					
					if item.remove then
						item:remove()
					end
				end)
			end
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = translates and translates.Get("Убрать из рук") or "Убрать из рук",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon -- = item.player.carryWeapons[item.weaponCategory]

		if (!weapon or !IsValid(weapon)) then
			weapon = item.player:GetWeapon(item.class)
		end

		item.player:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav", 80)
		item.player.carryWeapons[item.class] = nil
		
		item:setData("equip", nil, item.player)
		if (IsValid(weapon)) then
			item.player:StripWeapon(item.class);
		end

		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(item.player, weapon)
		end
		
		if weapon.RemovingWeapon and weapon.NeedToRemove then
			local Count = item:getCount();
			
			if (Count == nil or Count == 1) then
				item:remove()
			else
				item:addCount(-1)
				item:setData("equip", false, item.player)
			end
			
			return false
		end
		
		if (IsValid(weapon)) then
			local just_give_ammo = (weapon:GetSecondaryAmmoType() != -1) and (weapon:GetPrimaryAmmoType() == -1)
			
			if just_give_ammo then
				item:setData("ammo", item.player:GetAmmoCount(weapon:GetSecondaryAmmoType()))
				--PrintTable(item)
			else
				item:setData("ammo", weapon:Clip1())
				item:setData("ammo2", weapon:Clip2())
			end
			
		else
			print(Format("Weapon %s does not exist!", item.class))
		end

		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true and item.CanHolster)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = translates and translates.Get("Взять в руки") or 'Взять в руки',
	tip = "equipTip",
	icon = "icon16/tick.png",
	InteractMaterial = "ping_system/take.png",
	onRun = function(item)
		local client = item.player
		local inv = client:getInv()
		
		if not inv then 
			return false 
		end
		
		local items = inv:getItems()

		if client:IsHandcuffed() then
			return false
		end
		
		local x, y, bagInv
		if IsValid(item.entity) then
			if item.entity.TakingItem then
				return false
			end
			
			local itemBase = rp.item.list[item.entity.uniqueID]
			x, y, bagInv = inv:findEmptySlot(itemBase.width, itemBase.height)
			if !x and !y then
				client:Notify(1, translates and translates.Get("Нет места в инвентаре!") or "Нет места в инвентаре!")
				return false
			end
		else
			hook.Run("Inventory::ItemUse", client, item)
		end

		client.carryWeapons = client.carryWeapons or {}

		--for k, v in pairs(items) do
		--	if (v.id != item.id) then
		--		local itemTable = rp.item.instances[v.id]
				
		--		if (!itemTable) then
		--			client:Notify(1, "Повози админа!")

		--			return false
		--		else
					-- if (itemTable.isWeapon and client.carryWeapons[item.weaponCategory] and itemTable:getData("equip")) then
					-- 	client:Notify(1, "Слот для оружия занят!")

					-- 	return false
					-- end
					for k,v in pairs(client:GetWeapons()) do
						if v:GetClass() == item.class then
							client:Notify(1, translates.Get("Такое оружие уже надето!"))
							return false
						end
					end
		--		end
		--	end
		--end
		
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end

		local weapon = client:Give(item.class, true)
		
		--lua_run print(Entity(1):GetActiveWeapon():GetMaxClip1(), Entity(1):GetActiveWeapon():GetMaxClip2())
		--lua_run print(Entity(1):GetActiveWeapon():Clip2())
		--lua_run print(Entity(1):GetActiveWeapon():GetSecondaryAmmoType())
		
		if (IsValid(weapon) and weapon:IsWeapon()) then
			weapon.inv_item_associated = item
			
			client.carryWeapons[item.class] = weapon
			client:SelectWeapon(weapon:GetClass())
			client:SetActiveWeapon(weapon)
			client:EmitSound("physics/cardboard/cardboard_box_impact_bullet1.wav", 80)

			local just_give_ammo = (weapon:GetSecondaryAmmoType() != -1) and (weapon:GetPrimaryAmmoType() == -1)
			
			--print('First ammo', item:getData("ammo"))
			
			--if (weapon:GetPrimaryAmmoType()) then
				if weapon:GetPrimaryAmmoType() != -1 and (client:GetAmmoCount(weapon:GetPrimaryAmmoType()) == weapon:Clip1() and item:getData("ammo", 0) == 0) then
					client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
				end
				
				if weapon:GetSecondaryAmmoType() != -1 and (client:GetAmmoCount(weapon:GetSecondaryAmmoType()) == weapon:Clip2() and item:getData("ammo2", 0) == 0) then
					client:RemoveAmmo(weapon:Clip2(), weapon:GetSecondaryAmmoType())
				end
			--end
			item:setData("equip", true, client)

			if just_give_ammo then
				client:SetAmmo(item:getData("ammo", 0), weapon:GetSecondaryAmmoType())
				--PrintTable(item)
				
			else
				weapon:SetClip1(item:getData("ammo", 0))
				weapon:SetClip2(item:getData("ammo2", 0))
			end
			
			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon, item:getData("ammo"), item:getData("ammo2"))
			end
		else
			print(Format("Weapon %s does not exist!", item.class))
		end

		if x and y then
			item.noDeleteWeapon = true
			
			if IsValid(item.entity) then
				item.entity.TakingItem = true
				item.entity:Remove()
			end
			
			inv:add(item.id, nil, nil, x, y)
		end

		return false
	end,
	onCanRun = function(item)
		local count = item:getCount()
		return --[[count < 2 &&]] !item.player:IsArrested() && !item.player.SupervisorID && !item.player:IsHandcuffed() && ((IsValid(item.entity) && item:getData("equip") != true) || (item:getData("equip") != true && !IsValid(item.entity) && item.invID == item.player:getInvID())) and not (item.player:GetJobTable() and item.player:GetJobTable().CantUseInventorySWEPS)
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

function ITEM:onLoadout()
	if (self:getData("equip")) then
		local client = self.player
		client.carryWeapons = client.carryWeapons or {}

		local weapon = client:Give(self.class, true)

		if (IsValid(weapon)) then
			weapon.inv_item_associated = self
			
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			client:RemoveAmmo(weapon:Clip2(), weapon:GetSecondaryAmmoType())
			
			client.carryWeapons[self.class] = weapon

			local just_give_ammo = (weapon:GetSecondaryAmmoType() != -1) and (weapon:GetPrimaryAmmoType() == -1)
			
			if just_give_ammo then
				client:SetAmmo(self:getData("ammo", 0), weapon:GetSecondaryAmmoType())
				
			else
				weapon:SetClip1(self:getData("ammo", 0))
				weapon:SetClip2(self:getData("ammo2", 0))
			end
		else
			print(Format("Weapon %s does not exist!", self.class))
		end
	end
end

function ITEM:onSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon)) then
		local just_give_ammo = (weapon:GetSecondaryAmmoType() != -1) and (weapon:GetPrimaryAmmoType() == -1)
		
		if just_give_ammo then
			self:setData("ammo", self.player:GetAmmoCount(weapon:GetSecondaryAmmoType()))
			
		else
			self:setData("ammo", weapon:Clip1())
			self:setData("ammo2", weapon:Clip2())
		end
	end
end

HOLSTER_DRAWINFO = {}

-- Called after the item is registered into the item tables.
function ITEM:onRegistered()
	if (self.holsterDrawInfo) then
		HOLSTER_DRAWINFO[self.class] = self.holsterDrawInfo
	end
end

hook.Add("PlayerDeath", "rp.StripEquipWeapon", function(client)
	client.carryWeapons = {}

	local Count;
	local inv = rp.item.getInv(client:getInvID())
	if not inv or not inv.getItems then return end
	
	for k, v in pairs(inv:getItems()) do
		Count = v:getCount();
		if (v.isWeapon and v:getData("equip")) then
			if (Count == nil or Count == 1) then
				v:remove()
			else
				v:addCount(-1)
				v:setData("equip", false, client)
			end
		end
	end
end)

function ITEM:onRemoved()
	--print('self.noDeleteWeapon', self.noDeleteWeapon)
	
	if self.noDeleteWeapon then 
		self.noDeleteWeapon = nil
		return 
	end
	
	local inv = rp.item.inventories[self.invID]
	local receiver = inv.getReceiver and inv:getReceiver()

	--print(receiver)
	
	if (IsValid(receiver) and receiver:IsPlayer()) then
        local weapon = receiver:GetWeapon(self.class)
		
		--print(weapon)

        if (IsValid(weapon)) then
            weapon:Remove()
        end
	end
end

-- Weapon validity check.
if SERVER then
	hook.Add( "PlayerSwitchWeapon", "rp.RemoveNULLEquippedWeapon", function( client, oldWeapon, newWeapon )
		if (oldWeapon == NULL and client.__previousweapon or oldWeapon.RemovingWeapon) and client.getInv then
			local inv = client:getInv();
			local class = oldWeapon == NULL and client.__previousweapon or oldWeapon:GetClass()

			if inv and inv.getItems then
				local Count;
				
				for _, v in pairs( inv:getItems() ) do
					if v.isWeapon and v:getData("equip") and v.class == class then
						Count = v:getCount();
						
						if (Count == nil or Count == 1) then
							v:remove();
						else
							v:addCount(-1)
							v:setData("equip", false, client)
						end
					end
				end
			end
		end

		client.__previousweapon = IsValid( newWeapon ) and newWeapon:GetClass() or nil;
		--print(client, client.__previousweapon)
	end );
end