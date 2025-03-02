ITEM.name = "Ящик с вещами комбайнов"
ITEM.desc = "Ящик, используемый для хранения вещей комбайнов."
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.invWidth = 5
ITEM.invHeight = 5
ITEM.price = 8
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noTake = true
ITEM.notTransfered = true

ITEM.functions.Open.onCanRun = function(item)
    return !item.player:IsCombine() and IsValid(item.entity) and item:getData("id")
end

ITEM.functions.View.onCanRun = function(item)
    return !item.player:IsCombine() and !IsValid(item.entity) and item:getData("id")
end
