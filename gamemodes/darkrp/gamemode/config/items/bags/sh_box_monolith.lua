-- "gamemodes\\darkrp\\gamemode\\config\\items\\bags\\sh_box_monolith.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Ящик с вещами Монолита"
ITEM.desc = "Ящик, используемый для хранения вещей монолитовцев."
ITEM.model = "models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl"
ITEM.invWidth = 5
ITEM.invHeight = 5
ITEM.price = 8
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noTake = true
ITEM.notTransfered = true

ITEM.functions.Open.onCanRun = function(item)
    return !item.player:IsMonolit() and IsValid(item.entity) and item:getData("id")
end

ITEM.functions.View.onCanRun = function(item)
    return !item.player:IsMonolit() and !IsValid(item.entity) and item:getData("id")
end
