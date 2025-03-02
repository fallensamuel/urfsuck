-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\items\\base\\sh_usable.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Usable base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Base for usable entities"
ITEM.category = "Artefacts"

ITEM.functions.use = { 
	name = translates.Get("Использовать"),
	tip = "useTip",
	icon = "icon16/plugin.png",
	InteractMaterial = "ping_system/use.png", 
	onRun = function(item, asd)
		if item.CanUse then
			if item.CanUse(item, item.entity, item.player) == false then return false end
		end

		if IsValid(item.entity) then
			item.entity:Use(item.player, item.player, USE_ON, 1)
			return false
		else
			hook.Run("Inventory::ItemUse", item.player, item)
			
			local ent = item:transfer()
			
			local ply = item.player
			
			if not isbool(ent) and IsValid(ent) then
				timer.Simple(0.1, function()
					local ent = IsValid(ent) and ent or IsValid(item.entity) and item.entity
					
					if ent and IsValid(ply) then
						ent:Use(ply, ply, USE_ON, 1)
					end
				end)
			elseif ent then
				local steamid = ply:SteamID()
				hook.Add('Inventory.OnItemDrop', 'Inventory.OnItemDrop.Use' .. steamid, function(item_t, client, entity)
					if IsValid(ply) and ply == client then
						hook.Remove('Inventory.OnItemDrop', 'Inventory.OnItemDrop.Use' .. steamid)
						
						if item_t.uniqueID == item.uniqueID then
							entity:Use(ply, ply, USE_ON, 1)
						end
					end
				end)
			end
			
			return false
		end
	end,
	onCanRun = function(item)
		return not IsValid(item.entity) and not item.noUseFunc
	end
}
