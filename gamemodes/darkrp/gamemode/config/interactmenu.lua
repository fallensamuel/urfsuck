-- "gamemodes\\darkrp\\gamemode\\config\\interactmenu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
material_cache = material_cache or {}

local function CahceMaterial(path)
    if material_cache[path] then return material_cache[path] end

    material_cache[path] = Material(path, "smooth", "noclamp")
end

rp.cfg.AdditionalIteractButtons = {
	{
        text = "Показать информацию своего PDA",
        material = Material("ping_system/idcard.png", "smooth noclamp"),
        color = Color(255, 255, 255),
        func = function(ply)
            RunConsoleCommand("showidcard");
        end,
        access = function(self, target) return target:Alive() and not target:IsInDeathMechanics() end
    },
}

rp.cfg.IDCard = {
    statuses = {
        [0] = "Нищий",
        [30000] = "Бедный",
        [140000] = "Средний",
        [800000] = "Выше среднего",
        [2000000] = "Зажиточный",
        [5000000] = "Богат",
        [70000000] = "Очень богат"
    },
    -- "NICK показал документ под номером NUM LOYALITY. Благосостояние: STATUS"
    text = "%s показал информацию своего PDA: %s %s. Благосостояние: %s"
}