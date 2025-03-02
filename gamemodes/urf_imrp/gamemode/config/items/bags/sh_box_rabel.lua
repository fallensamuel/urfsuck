ITEM.name = "Ящик с вещами комбайнов"
ITEM.desc = "Ящик, используемый для хранения вещей комбайнов."
ITEM.model = "models/items/item_beacon_crate.mdl"
ITEM.invWidth = 5
ITEM.invHeight = 5
ITEM.price = 8
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noTake = true
ITEM.notTransfered = true

ITEM.functions.Open.onCanRun = function(item)
    return !item.player:IsRebel() and IsValid(item.entity) and item:getData("id")
end

ITEM.functions.View.onCanRun = function(item)
    return !item.player:IsRebel() and !IsValid(item.entity) and item:getData("id")
end