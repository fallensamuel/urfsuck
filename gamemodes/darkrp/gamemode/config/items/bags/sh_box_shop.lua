-- "gamemodes\\darkrp\\gamemode\\config\\items\\bags\\sh_box_shop.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Оружейный Ящик"
ITEM.desc = "Оружейный Ящик, ранее используемый для хранения оружия."
ITEM.model = "models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_01.mdl"
ITEM.invWidth = 10
ITEM.invHeight = 10
ITEM.price = 8
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noTake = true
ITEM.notTransfered = true
ITEM.removeIsEmpty = true
ITEM.notCanGive = true
ITEM.noDrop = true
ITEM.onSpawn = function(ent, pl, item)
	timer.Create("BoxShopDelete"..ent:EntIndex(), 180, 1, function()
		if not IsValid(ent) then return end
		ent:Remove()
	end)
end
ITEM.functions.delete = ITEM.functions.delete or {
	name = "Удалить",
	tip = "deleteTip",
	icon = "icon16/cancel.png",
	onRun = function(item)
		item:remove()
		return false
	end,
	onCanRun = function(item)
		return !IsValid(item.entity) and item.noDrop
	end
}