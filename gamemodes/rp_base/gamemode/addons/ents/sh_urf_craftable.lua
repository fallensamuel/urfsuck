local function CraftTimeFormula(recipe) -- формула времени крафта.
	local out = 1

	for k, v in pairs(recipe) do
		out = out + v.count*5 * (v.timemult or 1)
	end

	return out
end

rp.CraftTableItems = {}
rp.CraftTableItemsIndexes = {}

function rp.AddToCraftTable(result, recipe, customAng, customCheck, customCraftTime, PosOffset) -- функция для добавления предметов в верстак
	if rp.CraftTableItemsIndexes[result] then
		rp.CraftTableItems[ rp.CraftTableItemsIndexes[result] ] = nil
		rp.CraftTableItemsIndexes[result] = nil	
	end

	local result_tab = rp.item.list[result]
	if not result_tab then
		print("Ошибка urf_craftable! Не удалось создать рецепт с результатом `"..(result or "nil").."`. Предмет не существует!")
		return
	end

	local params = {}
	params["printname"] 	= result_tab.name
	params["model"] 		= result_tab.model
	params["result"] 		= result
	params["recipe"] 		= recipe
	params["customAng"] 	= customAng
	params["crafttime"] 	= customCraftTime or CraftTimeFormula(recipe)
	params["customCheck"] 	= customCheck -- args: ply, selfent
	params["MaterialPath"]  = rp.item.icons[result]
	params["PosOffset"] 	= PosOffset

	local index = table.insert(rp.CraftTableItems, params)
	rp.CraftTableItems[index]["index"] = index
	rp.CraftTableItemsIndexes[result] = index
end

function rp.CraftableItem(uid, count, timemult) -- быстрый и более красивый форматинг
	return {
		["uid"] 		= uid,
		["mdl"] 		= (rp.item.list[uid] or {}).model or "models/props_junk/popcan01a.mdl",
		["count"] 		= count or 1,
		["timemult"] 	= timemult
	}
end
--[[
rp.AddToCraftTable("swb_colt1911", {
	rp.CraftableItem("simpleprint3", 2)
}, Angle(90, 90, 0))

rp.AddToCraftTable("simpleprint2", {
	rp.CraftableItem("pineapple", 2),
	rp.CraftableItem("gmod_camera"),
}, nil, function(ply, selfent)
	return ply:IsRoot()
end)
]]--