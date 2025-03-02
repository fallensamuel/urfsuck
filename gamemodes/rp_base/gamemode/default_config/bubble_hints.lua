-- "gamemodes\\rp_base\\gamemode\\default_config\\bubble_hints.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
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

rp.cfg.BubbleRadius = rp.cfg.BubbleRadius or 250 -- В каком радиусе буудт рендериться баблы?
rp.cfg.BubbleRended3D2D = rp.cfg.BubbleRended3D2D or false -- 3D2D или HUDPaint :ToScreen?
rp.cfg.BubbleRenderByTrace = rp.cfg.BubbleRenderByTrace or false -- Рендерить баблы рядом с точкой на которую смотрит игрок или рядом с самим игроком?

local CurrentTIme = CurTime
local Vec = Vector

rp.AddBubble("entity", "vendor_npc", {
	ico = Material("bubble_hints/cart.png", "smooth", "noclamp"),
	as_texture = true,
	name = function(ent)
		return ent:GetVendorName()
	end,
	desc = translates.Get("[E] Открыть магазин"),
	offset = Vec(0, 0, 11),
	scale = 0.6,
})

rp.AddBubble("entity", "gifts_npc", {
	ico = Material("bubble_hints/gift.png", "smooth", "noclamp"),
	as_texture = true,
	name = function(ent)
		return ent.PrintName
	end,
	desc = translates.Get("[E] Получить подарок"),
	offset = Vec(0, 0, 10),
	scale = 0.6,
	ico_col = Color(255,102,255),
	title_colr = Color(255,102,255),
})

rp.AddBubble("item", "box_loot", {
	ico = Material("bubble_hints/lootbox.png", "smooth", "noclamp"),
	as_texture = true,
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

rp.PlayerBubbles = {};

rp.PlayerBubbles["medic"] = {
    ico = Material( "bubble_hints/medical.png", "smooth noclamp" ),
    offset = Vector( 0, 0, 15 ),
    scale = 0.5,
	as_texture = true,
    ico_col = function( ply )
        local CT = CurTime()
        if not ply.MedicalColorBlinkT or ply.MedicalColorBlinkT < CT then
            ply.MedicalColorBlinkT = CT + blink_time
            ply.MedicalColorBlink = not ply.MedicalColorBlink
        end

        return BlinkColors[ply.MedicalColorBlink or false]
    end,
    customCheck = function( ply )
        return ply:IsInDeathMechanics() and LocalPlayer():GetJobTable().IsMedic and true or false
    end,
};

rp.PlayerBubbles["emote_shared"] = {
    ico = Material( "ping_system/emotegrab.png", "smooth noclamp" ),
	ico_col = color_white,
    offset = Vector( 0, 0, 15 ),
    scale = 0.25,
	as_texture = true,
    customCheck = function( ply )
		if not ply.GetEmoteAction then return false end
        return EmoteActions:GetRawAction( ply:GetEmoteAction() ).Shared and true or false
    end,
};

local pairs = pairs;

local function rp_PlayerBubbles_GetKey( ply, key )
	for k, v in pairs( rp.PlayerBubbles ) do
		if ply["BUBBLE" .. k] then
			local value = v[key];
			return (TypeID(value) == TYPE_FUNCTION) and value(ply) or value;
		end
	end
end

rp.AddBubble( "entity", "player", {
	customCheck = function( ply )
		if ply == LocalPlayer() then
			return false
		end

		local b = false;

		for k, v in pairs( rp.PlayerBubbles ) do
			if v.customCheck then
				if v.customCheck(ply) == false then
					ply["BUBBLE" .. k] = nil;
					continue
				end
			end

			b, ply["BUBBLE" .. k] = true, true;
		end

		return b
	end,

	offset = Vector( 0, 0, 15 ),

	name = function( ply )
		return rp_PlayerBubbles_GetKey( ply, "name" );
	end,

	desc = function( ply )
		return rp_PlayerBubbles_GetKey( ply, "desc" );
	end,

	ico = function( ply )
		return rp_PlayerBubbles_GetKey( ply, "ico" );
	end,

	ico_col = function( ply )
		return rp_PlayerBubbles_GetKey( ply, "ico_col" );
	end,

	scale = function( ply )
		return rp_PlayerBubbles_GetKey( ply, "scale" );
	end,
} );