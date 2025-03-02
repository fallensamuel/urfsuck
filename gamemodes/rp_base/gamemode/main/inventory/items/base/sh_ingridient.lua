ITEM.name = "Pizza Ingridient"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Base for ingridient entities"
ITEM.category = "Ingridients"

local CustomUseFunc = function(self, ply)
	if ply:IsBanned() or not IsValid(self) then return end

	local index = zpiz.ingridientnames[self.uniqueID]
	--print(index or "nil")
	if not index then return end
	local ing = zpiz.GetIngridientByIndex(index)
	if not ing then return end

	if ing.EatHunger then
		ply:AddHunger(ing.EatHunger)
	end
	if ing.EatHealth then
		ply:SetHealth( math.Clamp(ply:Health() + ing.EatHealth, 0, ply:GetMaxHealth()) )
	end

	if zpiz.IngridientEatSound then
		ply:EmitSound(zpiz.IngridientEatSound)
	end

	SafeRemoveEntity(self)
end

ITEM.functions.use = { 
	name = translates.Get("Скушать"),
	tip = "useTip",
	icon = "icon16/lightning.png",
	InteractMaterial = "ping_system/eat.png",
	onRun = function(item, asd)
		if IsValid(item.entity) then
			--item.entity:Use(item.player, item.player, USE_ON, 1)
			CustomUseFunc(item.entity, item.player)
			return false
		else
			local ent = item:transfer()
			
			if not isbool(ent) and IsValid(ent) then
				--ent:Use(item.player, item.player, USE_ON, 1)
				CustomUseFunc(item.entity, item.player)
				
			elseif ent then
				local ply = item.player
				local steamid = ply:SteamID()
				hook.Add('Inventory.OnItemDrop', 'Inventory.OnItemDrop.Use' .. steamid, function(item_t, client, entity)
					if IsValid(ply) and ply == client then
						hook.Remove('Inventory.OnItemDrop', 'Inventory.OnItemDrop.Use' .. steamid)
						
						if item_t.uniqueID == item.uniqueID then
							--entity:Use(ply, ply, USE_ON, 1)
							CustomUseFunc(entity, ply)
						end
					end
				end)
			end
			
			return false
		end
	end
}

ITEM["onSpawn"] = function(ent, ply, item)
    zpiz.f.SetOwnerID(ent, ply)
end

ITEM.BubbleHint = {
	ico = Material("shop/filters/food.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 12),
	scale = 0.6
}