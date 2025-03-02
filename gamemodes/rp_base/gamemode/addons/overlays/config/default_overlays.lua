-- "gamemodes\\rp_base\\gamemode\\addons\\overlays\\config\\default_overlays.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/* -- Оверлей: ------------------------------------
    <Overlay> rp.overlays.Overlay( name )
        - <String> name: Название оверлея. (SysTime() без названия)
        - Пример:
            rp.overlays.Overlay("ExampleOverlay")
                :AddLayer( rp.overlays.OverlayLayer("ExampleOverlayLayer") ) -- также можно использовать => :AddLayer( "ExampleOverlayLayer" )
                :AddLayer( rp.overlays.OverlayLayer("?")
                    :SetMaterial( "gui/gradient_up" )
                    :SetColor( Color(0,0,0,225) )
                )
                :AddLayer( rp.overlays.OverlayLayer("PostproccessLayer")
                    :SetSharpen( 5, 5 )
                    :SetPulsation( 3, 0.25 )
                )
                :SetFadeIn( 3 )
                :SetFadeOut( 3 )
            :Enable()
        > Возвращает оверлей


    rp.overlays.Overlay:Enable()
        - Включает или обновляет оверлей при вызове.

    rp.overlays.Overlay:Disable()
        - Выключает отображение оверлея.

    rp.overlays.Overlay:Toggle()
        - Включает/выключает оверлей.


    <Overlay> rp.overlays.Overlay:SetWeight( weight )
        - <Number> weight: "вес" оверлея. Оверлеи с большим весом перекрывают оверлеи с меньшим. (>z-index)
        > Возвращает оверлей


    <Overlay> rp.overlays.Overlay:SetFadeIn( time )
        - <Number> time: Задает плавное появление оверлея при включении. (в секундах)
        > Возвращает оверлей

    <Overlay> rp.overlays.Overlay:SetFadeOut( time )
        - <Number> time: Задает плавное появление оверлея при выключение. (в секундах)
        > Возвращает оверлей


    <Overlay> rp.overlays.Overlay:AddLayer( overlayLayer )
        - <OverlayLayer | String> overlayLayer: Добавляет слой к оверлею.
        > Возвращает оверлей
------------------------------------------------ */


/* -- Слой оверлея: -------------------------------
    <OverlayLayer> rp.overlays.OverlayLayer( name )
        - <String> name: Названия слоя оверлея.
        - Пример
            rp.overlays.OverlayLayer("ExampleOverlayLayer")
                :SetMaterial( "gui/gradient_down" ) -- Материал слоя.
                :SetColor( Color(255,0,0) )       -- Красный цвет слоя.
                :SetPulsation( 3, 0.5 );            -- Средняя пульсация.
        > Возвращает слой оверлея


    <OverlayLayer> rp.overlays.OverlayLayer:SetOpacity( value )
        - <Number> value: Задает прозрачность слоя. (от 0 до 1)
        - Прозрачность *ВЛИЯЕТ* на любой постпроцесс, заданный на этом слое!
        - Пример:
            rp.overlays.OverlayLayer():SetOpacity( 0.5 ); -- Слой наполовину прозрачен/не прозрачен :p
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetPulsation( rate, amount )
        - <Number> rate: Задает частоту пульсации слоя.
        - <Number> amount
        - Пульсация *ВЛИЯЕТ* на любой постпроцесс, заданный на этом слое!
        - Пример:
            rp.overlays.OverlayLayer():SetPulsation( 6, 0.5 ); -- Частая пульсация с полной прозрачностью.
        > Возвращает слой оверлея


    <OverlayLayer> rp.overlays.OverlayLayer:SetMaterial( material )    
        - <Material | String> material: Задает материал слоя. (если используется строка - Material() добавляется автоматически)
        - Пример:
            rp.overlays.OverlayLayer():SetMaterial( "gui/gradient" );
            rp.overlays.OverlayLayer():SetMaterial( Material("gui/gradient") );
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetPos( x, y )
        - <Number> x: Положение материала слоя на горизонтальной оси. (от 0 до 1, где 1 - ширина экрана клиента, 0.5 - середина)
        - <Number> y: Положение материала слоя на вертикальной оси. (от 0 до 1, где 1 - высота экрана клиента, 0.5 - середина)
        - Пример:
            rp.overlays.OverlayLayer():SetPos( 0.5, 1 ); -- Материал слоя находится по центру ширины экрана, в низу экрана по высоте
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetScale( w, h )
        - <Number> x: Масштаб материала слоя по горизонтальной оси. (от 0 до 1, где 1 - ширина экрана клиента)
        - <Number> y: Масштаб материала слоя по вертикальной оси. (от 0 до 1, где 1 - высота экрана клиента)
        - Пример:
            rp.overlays.OverlayLayer():SetPos( 0.5, 0.5 ); -- Материал слоя меньше в 2 раза
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetColor( clr )
        - <Color> clr: Задает цвет у материала слоя.
        - Пример:
            rp.overlays.OverlayLayer():SetColor( Color(255,0,0) ); -- Материал слоя станет красным.
        > Возвращает слой оверлея


    <OverlayLayer> rp.overlays.OverlayLayer:SetColorModify( addr, addg, addb, brightness, contrast, color, mulr, mulg, mulb )
        - https://wiki.facepunch.com/gmod/Global.DrawColorModify :: Цветокоррекция.
        - Таблица цветокора:
            local tab = {
                ["$pp_colour_addr"] = 0,
                ["$pp_colour_addg"] = 0,
                ["$pp_colour_addb"] = 0,
                ["$pp_colour_brightness"] = 0,
                ["$pp_colour_contrast"] = 1,
                ["$pp_colour_colour"] = 1,
                ["$pp_colour_mulr"] = 0,
                ["$pp_colour_mulg"] = 0,
                ["$pp_colour_mulb"] = 0
            };
        - Может принимать таблицу или функцию вместо первого аргумента.
        - Функция должна возвращать таблицу, со структурой таблицы цветокора.
        - Примеры:
            rp.overlays.OverlayLayer():SetColorModify( 0, 0, 0, 0, 1, 1, 0, 0, 0 );
            rp.overlays.OverlayLayer():SetColorModify( tab );
            rp.overlays.OverlayLayer():SetColorModify( function( this )
                local tab = {};
                tab["$pp_colour_colour"] = 0.5 + math.sin( CurTime() * 6 );
                return tab;
            end );
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetSharpen( contrast, distance )
        - https://wiki.facepunch.com/gmod/Global.DrawSharpen :: Резкость.
        - Таблица резкости:
            local tab = {
                ["contrast"] = 0,
                ["distance"] = 0
            };
        - Может принимать таблицу или функцию вместо первого аргумента.
        - Функция должна возвращать таблицу, со структурой таблицы резкости.
        - За примером обращайтесь к rp.overlays.OverlayLayer:SetColorModify
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetMotionBlur( addalpha, drawalpha, delay )
        - https://wiki.facepunch.com/gmod/Global.DrawMotionBlur :: Размытие в движении.
        - Таблица размытия:
            local tab = {
                ["addalpha"] = 0,
                ["drawalpha"] = 0,
                ["delay"] = 0
            };
        - Может принимать таблицу или функцию вместо первого аргумента.
        - Функция должна возвращать таблицу, со структурой таблицы размытия.
        - За примером обращайтесь к rp.overlays.OverlayLayer:SetColorModify
        > Возвращает слой оверлея

    <OverlayLayer> rp.overlays.OverlayLayer:SetBloom( darken, multiply, x, y, passes, colormultiply, r, g, b )
        - https://wiki.facepunch.com/gmod/Global.DrawBloon :: Свечение.
        - Таблица свечения:
            local tab = {
                ["darken"] = 0,
                ["multiply"] = 0,
                ["x"] = 0,
                ["y"] = 0,
                ["passes"] = 0,
                ["colormultiply"] = 0,
                ["r"] = 1,
                ["g"] = 1,
                ["b"] = 1
            };
        - Может принимать таблицу или функцию вместо первого аргумента.
        - Функция должна возвращать таблицу, со структурой таблицы свечения.
        - За примером обращайтесь к rp.overlays.OverlayLayer:SetColorModify
        > Возвращает слой оверлея


    <OverlayLayer> rp.overlays.OverlayLayer:SetPaintFunction( f )
        - <Function> f: Кастомная функция отрисовки через луа. (Материал и постпроцесс, заданные на этом же слое, будут отрисовываться)
        - Пример:
            rp.overlays.OverlayLayer():SetPaintFunction( function( this, w, h )
                draw.SimpleText( "Sample Text", "DermaLarge", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end );
        > Возвращает слой оверлея


    <OverlayLayer> rp.overlays.OverlayLayer:OnStart( layer, parent )
        - Функция слоя, которая вызывается, когда оверлей с этим слоем был включен.
        - <OverlayLayer> layer - Сам слой.
        - <Overlay> parent - Оверлей, к которому привязан этот слой.
        - Пример:
            rp.overlays.OverlayLayer().OnStart = function( l, o ) print( l, "(. _.) начинаю отображаться" ); end

    <OverlayLayer> rp.overlays.OverlayLayer:OnUpdate( layer, parent )
        - Функция слоя, которая вызывается, когда оверлей с этим слоем был апдейтнут. (попытка включения оверлея, когда он уже включен)
        - <OverlayLayer> layer - Сам слой.
        - <Overlay> parent - Оверлей, к которому привязан этот слой.

    <OverlayLayer> rp.overlays.OverlayLayer:OnEnd( layer, parent )
        - Функция слоя, которая вызывается, когда оверлей с этим слоем был выключен.
        - <OverlayLayer> layer - Сам слой.
        - <Overlay> parent - Оверлей, к которому привязан этот слой.
------------------------------------------------ */

local trans_health_alpha = 0
local m_approach = math.Approach
local m_max = math.max
local m_min = math.min
local lp


rp.overlays.OverlayLayer( "drug-motionblur-low" )
    :SetMotionBlur( 0.03, 0.5, 0 )

rp.overlays.OverlayLayer( "drug-motionblur-medium" )
    :SetMotionBlur( 0.035, 0.75, 0 )

rp.overlays.OverlayLayer( "drug-motionblur-high" )
    :SetMotionBlur( 0.02, 1, 0 )

rp.overlays.OverlayLayer( "drug-sharpen" )
    :SetSharpen( 1, 2 )

rp.overlays.OverlayLayer( "drug-sharpen-meth" )
    :SetSharpen( 1, 5 )
    :SetPulsation( 3, 0.35 )

rp.overlays.OverlayLayer( "drug-colormod-weed" )
    :SetColorModify( 0, 0.08, 0, -0.25, 1, 1, 0, 0, 0 )
    :SetPulsation( 3, 0.25 )

rp.overlays.OverlayLayer( "drug-colormod-cocaine" )
    :SetColorModify( 0, 0, 0.08, -0.25, 1, 1, 0, 0, 1 )
    :SetPulsation( 6, 0.35 )

rp.overlays.OverlayLayer( "drug-colormod-meth" )
    :SetColorModify( 0, 0, 0, -0.2, 1, 0.3, 0, 0, 0.08 )
    :SetPulsation( 3, 0.35 )

rp.overlays.OverlayLayer( "drug-colormod-spice" )
    :SetColorModify( 0, 0, 0.04, -0.35, 1, 0.8, 0, 0.02, 0 )

rp.overlays.OverlayLayer( "drug-blindness" )
    :SetBloom( function( me )
        me.BloomDarken = (me.BloomDarken or 0) * 0.99;
        return {
            ["darken"] = 1 - me.BloomDarken, ["multiply"] = 1,["x"] = 5, ["y"] = 5, ["passes"] = 1, ["colormultiply"] = 0, ["r"] = 3, ["g"] = 3, ["b"] = 3
        };
    end );
    rp.overlays.OverlayLayer( "drug-blindness" ).OnStart  = function( me ) me.BloomDarken = 5; end
    rp.overlays.OverlayLayer( "drug-blindness" ).OnUpdate = function( me ) me.BloomDarken = 3; end
    rp.overlays.OverlayLayer( "drug-blindness" ).OnEnd    = function( me ) me.BloomDarken = 5; end

rp.overlays.OverlayLayer( "pre-death-layer" )
    :SetMaterial( "overwatch/overlays/lowhealth" )
	:SetPaintFunction( function( this, w, h )
		lp = LocalPlayer()
		
		trans_health_alpha = m_approach( trans_health_alpha, lp:Alive() and ( 
			lp:IsInDeathMechanics() and 
				0.8 or 
				( m_min( m_max( 0.3 - lp:Health() / lp:GetMaxHealth(), 0 ), 1) * 0.8 )
		) or 0, 0.4 )
		
        this:SetOpacity( trans_health_alpha )
    end );
	
	
rp.overlays.Overlay( "drugs-weed" )
    :AddLayer( "drug-motionblur-medium" )
    :AddLayer( "drug-colormod-weed" )
    :SetFadeIn( 1 )
    :SetFadeOut( 1 )

rp.overlays.Overlay( "drugs-cocaine" )
    :AddLayer( "drug-motionblur-medium" )
    :AddLayer( "drug-colormod-cocaine" )
    :AddLayer( "drug-blindness" )
    :SetFadeIn( 1 )
    :SetFadeOut( 1 )

rp.overlays.Overlay( "drugs-alcohol" )
    :AddLayer( "drug-motionblur-high" )
    :SetFadeIn( 3 )
    :SetFadeOut( 3 )

rp.overlays.Overlay( "drugs-meth" )
    :AddLayer( "drug-sharpen-meth" )
    :AddLayer( "drug-colormod-meth" )
    :SetFadeIn( 3 )
    :SetFadeOut( 3 )

rp.overlays.Overlay( "drugs-spice" )
    :AddLayer( "drug-motionblur-low" )
    :AddLayer( "drug-sharpen" )
    :AddLayer( "drug-colormod-spice" )
    :SetFadeIn( 3 )
    :SetFadeOut( 3 )
	
rp.overlays.Overlay( "pre-death" )
    :AddLayer( "pre-death-layer" )
    --:SetFadeIn( 3 )
    --:SetFadeOut( 3 )
	:Enable()