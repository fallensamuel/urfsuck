ITEM.name = "Оружейный Ящик"
ITEM.desc = "Оружейный Ящик, ранее используемый для хранения оружия."
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.invWidth = 10
ITEM.invHeight = 10
ITEM.price = 8
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noTake = true
ITEM.notTransfered = true
ITEM.onSpawn = function(ent, pl, item)
	timer.Create("BoxShopDelete"..ent:EntIndex(), 180, 1, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)
end