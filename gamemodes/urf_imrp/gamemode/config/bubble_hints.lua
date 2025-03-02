--[[
	Доступные для конфигурации ключи:
	Тип данных | имя ключа — Описание
	Тип данных function всегда содержит в себе объект entity в аргументах!

	number or function 	 | maxdist 			— Максимальная дистанция отображения бабла (по стандарту 325*325)
	function 			 | customCheck 		— Кастом чек. Сделвайте return false что-бы предотвратить отисовку бабла над данным энтити/предметом.
	vector 				 | localoffset 		— Смешение позиции бабла относительно объекта.
	vector or function	 | offset 			— Смещение позиции бабла.
	number or function 	 | scale 			— Множитель размера бабла. По умолчанию 1. (2 - увеличить в 2 раза, 0.2 - уменьшить в 5 раз и тд)
!	material or function | ico 				— Иконка бабла. Это единственный ОБЪЯЗАТЕЛЬНЫЙ АРГУМЕНТ!
	string or function 	 | name 			— Имя бабла. (Большой текст сверху)
	string or function 	 | desc 			— Описание. (малый текст снизу имени)
	Color or function 	 | ico_col 			— Кастомный цвет бабла. По умолчанию Color(255, 255, 255)
	bool or function	 | ico_rotate 		— Включает вращение иконки. Добавьте true что-бы заставить иконку бабла вращаться 
	number 			 	 | ico_rotate_speed — Множитель скорости вращения иконки. По умлочанию 1. (2 - ускорить вращение в 2 раза)
	Vector or function	 | rotate_offset 	— Смещение позиции вращающейся иконки.
]]--

rp.cfg.BubbleRadius = 250 -- В каком радиусе буудт рендериться баблы?
rp.cfg.BubbleRended3D2D = false -- 3D2D или HUDPaint :ToScreen?
rp.cfg.BubbleRenderByTrace = false -- Рендерить баблы рядом с точкой на которую смотрит игрок или рядом с самим игроком?

local CurrentTIme = CurTime
local Vec = Vector
local rp_ArmoryHeists_GetHeistCfg = rp.ArmoryHeists.GetHeistCfg

local heist_materials = {
	blue = Material("bubble_hints/heist_blue.png", "smooth", "noclamp"),
	red = Material("bubble_hints/heist_red.png", "smooth", "noclamp"),
	white = Material("bubble_hints/heist_white.png", "smooth", "noclamp"),
	--outline = Material("bubble_hints/heist_outline.png", "smooth", "noclamp"),
	refresh = Material("bubble_hints/refresh.png", "smooth", "noclamp")
}

local GetHeistObject = function(ent)
	if ent.heist_obj then return ent.heist_obj end

	local heist_id = ent:GetNWInt("HeistID")
	if not heist_id then return end
	local heist_obj = rp.ArmoryHeists.List[heist_id]
	if not heist_obj then return end

	ent.heist_obj = heist_obj
	return heist_obj
end

rp.AddBubble("item", "box_heist", {
	ico = function(ent)
		local heist_obj = GetHeistObject(ent)
		if not heist_obj then return end
		local CT = CurrentTIme()

		if heist_obj.IsInProgress then
			if (ent.NextIcoChange or 0) < CT then
				ent.NextIcoChange = CT + 1.5

				ent.ActiveHeitsIco = ent.ActiveHeitsIco == heist_materials.blue and heist_materials.red or heist_materials.blue
				return ent.ActiveHeitsIco
			else
				return ent.ActiveHeitsIco or heist_materials.blue
			end
		elseif heist_obj.Timestamp > CT then
			return heist_materials.refresh
		else
			return heist_materials.white
		end
	end,
	name = function(ent)
		local heist_obj = GetHeistObject(ent)
		if not heist_obj then return end

		if heist_obj.IsInProgress then
			return "Ограбление: "..ba.str.FormatTime(heist_obj.Timestamp - CurrentTIme(), true)	
		elseif heist_obj.Timestamp > CurrentTIme() then
			return "Перезарядка: "..ba.str.FormatTime(heist_obj.Timestamp - CurrentTIme(), true)			
		else
			local hcfg = rp_ArmoryHeists_GetHeistCfg(heist_obj.ID)
			return hcfg and hcfg.Name or "Ограбление"
		end
	end,
	desc = function(ent)
		local heist_obj = GetHeistObject(ent)
		if not heist_obj then return end

		if heist_obj.IsInProgress then
			return "Банкомат в процессе ограбления"
		elseif heist_obj.Timestamp > CurrentTIme() then
			return "Подождите что-бы начать ограбление"
		else
			return "Нажмите [E] что-бы начать ограбление"
		end
	end,
	offset = Vec(0, 0, 16),
	ico_rotate = function(ent)
		local heist_obj = GetHeistObject(ent)
		if not heist_obj then return end

		if heist_obj.IsInProgress then
			return false
		elseif heist_obj.Timestamp > CurrentTIme() then
			return true
		else
			return false
		end
	end,
	rotate_offset = function()
		return rp.cfg.BubbleRended3D2D and Vec(-110, 0, 0) or Vec(-55, 0, 0)
	end,
	scale = 0.75
})

rp.AddBubble("entity", "vendor_npc", {
	ico = Material("bubble_hints/cart.png", "smooth", "noclamp"),
	name = function(ent)
		return ent:GetVendorName()
	end,
	desc = "[E] Открыть магазин",
	offset = Vec(0, 0, 11),
	scale = 0.6,
})

rp.AddBubble("entity", "gifts_npc", {
	ico = Material("bubble_hints/gift.png", "smooth", "noclamp"),
	name = function(ent)
		return ent.PrintName
	end,
	desc = "[E] Получить подарок",
	offset = Vec(0, 0, 10),
	scale = 0.6,
	ico_col = Color(255,102,255),
	title_colr = Color(255,102,255),
})

rp.AddBubble("item", "box_loot", {
	ico = Material("bubble_hints/lootbox.png", "smooth", "noclamp"),
	offset = Vec(0, 0, 14)
})

rp.AddBubble("entity", "ammo_bonuses_aliance", {
	ico = Material("filters/ammo.png", "smooth", "noclamp"),
	offset = Vec(0, 0, 14)
})
rp.AddBubble("entity", "ammo_bonuses_rebels", {
	ico = Material("filters/ammo.png", "smooth", "noclamp"),
	offset = Vec(0, 0, 14)
})

--[[
rp.AddBubble("entity", "spawned_shipment", {
	ico = Material("rpui/icons/speed.vtf", "smooth", "noclamp"),
	offset = Vector(0, 0, 14)
})

rp.AddBubble("entity", "cw_vendingmachine", {
	name = "Торговый автомат",
	desc = "Газировка!",
	ico = Material("rpui/icons/speed.vtf", "smooth", "noclamp"),
	offset = Vector(20, 0, 16)
})

rp.AddBubble("entity", "ent_capture_bonuses", {
	name = "Бонус территории",
	desc = "Ништяки для владельцев территории",
	ico = function(ent)
		local ico = "neutic64.png"
		return Material("diplomacy/"..ico, "smooth", "noclamp")
	end,
	offset = Vector(0, 0, 12),
	scale = 0.75,
})

rp.AddBubble("item", "pineapple", {
	name = "Ананас",
	desc = "Вкусняшка",
	ico = Material("shop/filters/food.png", "smooth", "noclamp")
})

rp.AddBubble("item", "chilli", {
	ico = Material("shop/filters/food.png", "smooth", "noclamp"),
	offset = Vector(0, 0, 8),
	scale = 0.5,
	ico_rotate = true,
	ico_rotate_speed = 2
})

rp.AddBubble("entity", "trampoline", {
	name = "Название",
	desc = "Какое-то описание..",
	ico = Material("scoreboard/os/macos.png", "smooth", "noclamp"),
	ico_rotate = true,
	rotate_offset = Vector(-50, 0, 0),
	offset = Vector(0, 0, 18),
	scale = 0.5
})

rp.AddBubble("entity", "sent_ball", {
	name = "Энтити шар",
	desc = "попрыгунчик",
	ico = Material("sprites/sent_ball", "smooth", "noclamp"),
	ico_col = function(self)
		local pos = self:GetPos()
		local lcolor = render.ComputeLighting( pos, Vector( 0, 0, 1 ) )
		local c = self:GetBallColor()

		lcolor.x = c.r * ( math.Clamp( lcolor.x, 0, 1 ) + 0.5 ) * 255
		lcolor.y = c.g * ( math.Clamp( lcolor.y, 0, 1 ) + 0.5 ) * 255
		lcolor.z = c.b * ( math.Clamp( lcolor.z, 0, 1 ) + 0.5 ) * 255

		local size = math.Clamp( self:GetBallSize(), self.MinSize, self.MaxSize )
		return Color( lcolor.x, lcolor.y, lcolor.z, 255 )
	end,
	--ico_rotate = true
	--customCheck = function(ent)
	--	return true
	--end
	--offset = Vector(0, 0, 0)
	--localoffset = Vector(0, 0, 0)
})
]]--

local BlinkColors = {
    [true] = Color(255, 33, 33),
    [false] = Color(33, 175, 255)
}

local blink_time = 1.5

rp.AddBubble("entity", "player", {
    ico = Material("bubble_hints/medical.png", "smooth", "noclamp"),
    offset = Vector(0, 0, 15),
    scale = 0.5,
    ico_col = function(ply)
        local CT = CurTime()
        if not ply.MedicalColorBlinkT or ply.MedicalColorBlinkT < CT then
            ply.MedicalColorBlinkT = CT + blink_time
            ply.MedicalColorBlink = not ply.MedicalColorBlink
        end

        return BlinkColors[ply.MedicalColorBlink or false]
    end,
    customCheck = function(ply)
        return ply:IsInDeathMechanics() and LocalPlayer():GetJobTable().IsMedic
    end,
    PreAdd = function(ply)
        return ply:IsInDeathMechanics() and LocalPlayer():GetJobTable().IsMedic
    end,
    /* ignoreZ = true,
    IgnoreDistanceLimit = function() return true end,
    ShouldMinusY = function() return true end, */
})