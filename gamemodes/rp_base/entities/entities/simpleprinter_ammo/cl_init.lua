include("shared.lua")

surface.CreateFont("rpui.Fonts.AmmoPrinterTitle", {
    font     = "Montserrat",
    extended = true,
    weight 	 = 600,
    size     = 34,
})
surface.CreateFont("rpui.Fonts.AmmoPrinter_AmmotypeTitle", {
    font     = "Montserrat",
    extended = true,
    weight 	 = 535,
    size     = 24,
})

surface.CreateFont("rpui.Fonts.AmmoPrinter_AmmotypePrice", {
    font     = "Montserrat",
    extended = true,
    weight 	 = 500,
    size     = 18,
})

surface.CreateFont( "rpui.Fonts.AmmoPrinter.Small", {
    font     = "Montserrat",
    extended = true,
    weight = 500,
    size     = 14,
})

local math_Clamp = math.Clamp
local math_floor = math.ceil
local math_Approach = math.Approach
local math_sin = math.sin
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'ВЫБОР ПАТРОН' ), 
			tr.Get( 'из' ), 
			tr.Get( 'зарядов' ), 
			tr.Get( 'ЗАКРЫТЬ' ), 
		}
	else
		cached = {
			'ВЫБОР ПАТРОН', 
			'из', 
			'зарядов', 
			'ЗАКРЫТЬ', 
		}
	end

net.Receive("simpleammoprinter_openmenu", function()
	local net_index = net.ReadInt(32)
	local self = ents.GetByIndex(net_index)
	if not IsValid(self) then return end

	local main_pnl = vgui.Create("DPanel")
	main_pnl:SetSize(420, 450)
	main_pnl:Center()
	main_pnl:MakePopup()
	main_pnl.Paint = function(that, w, h)
		if not IsValid(self) then
			that:Remove()
			return
		end

		draw.Blur(that)
	    surface_SetDrawColor(that.UIColors.Shading)
	    surface_DrawRect(0, 0, w, h)

	   	draw_SimpleText(cached[1] .. ":", "rpui.Fonts.AmmoPrinterTitle", 12, 28, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	   	if input.IsKeyDown(KEY_X) and IsValid(that.CloseButton) then
	   		that.CloseButton.DoClick(that.CloseButton)
	   	end

	   	if input.IsKeyDown(KEY_ESCAPE) then
	   		that:Remove()
	   	end
	end
	main_pnl:SetAlpha(0)
	main_pnl:AlphaTo(255, 0.25)

	local frameW, frameH = main_pnl:GetSize();

	main_pnl.UIColors = {
	    Blank 		= Color(0, 0, 0, 0),
	    White 		= Color(255, 255, 255, 255),
	    Black 		= Color(0, 0, 0, 255),
	    Tooltip 	= Color(0, 0, 0, 228),
	    Active 		= Color(255, 255, 255, 255),
	    Background 	= Color(0, 0, 0, 127),
	    Hovered 	= Color(0, 0, 0, 180),
	    Shading 	= Color(0, 12, 24, 74)
	}

	local STYLE_SOLID, STYLE_BLANKSOLID, STYLE_TRANSPARENT_SELECTABLE, STYLE_ERROR = 0, 1, 2, 3;
	main_pnl.GetPaintStyle = function(element, style)
	    style = style or STYLE_SOLID;

	    local baseColor, textColor = Color(0,0,0,0), Color(0,0,0,0);
	    local animspeed            = 768 * FrameTime();

	    if style == STYLE_SOLID then
	        element._grayscale = math_Approach(
	            element._grayscale or 0,
	            (element:IsHovered() and 255 or 0) * (element:GetDisabled() and 0 or 1),
	            animspeed
	        );

	        local invGrayscale = 255 - element._grayscale;
	        baseColor = Color( element._grayscale, element._grayscale, element._grayscale );
	        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_BLANKSOLID then
	        element._grayscale = math_Approach(
	            element._alpha or 0,
	            (element:IsHovered() and 0 or 255),
	            animspeed
	        );

	        element._alpha = math_Approach(
	            element._alpha or 0,
	            (element:IsHovered() and 255 or 0),
	            animspeed
	        );

	        local invGrayscale = 255 - element._grayscale;
	        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
	        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_TRANSPARENT_SELECTABLE then
	        element._grayscale = math_Approach(
	            element._grayscale or 0,
	            (element.Selected and 255 or 0),
	            animspeed
	        );
	        
	        if element.Selected then
	            element._alpha = math_Approach( element._alpha or 0, 255, animspeed );
	        else
	            element._alpha = math_Approach( element._alpha or 0, (element:IsHovered() and 228 or 146), animspeed );
	        end

	        local invGrayscale = 255 - element._grayscale;
	        baseColor = Color( element._grayscale, element._grayscale, element._grayscale, element._alpha );
	        textColor = Color( invGrayscale, invGrayscale, invGrayscale );
	    elseif style == STYLE_ERROR then
	        baseColor = Color( 150 + math_sin(CurTime() * 1.5) * 70, 0, 0 );
	        textColor = main_pnl.UIColors.White;
	    end

	    return baseColor, textColor;
	end

	main_pnl.frameSpacing = 0

	main_pnl.place4ammos = vgui.Create("DPanel", main_pnl)
	main_pnl.place4ammos.Paint = function() end

    main_pnl.ammo_list = vgui.Create("rpui.ScrollPanel", main_pnl.place4ammos)
    main_pnl.ammo_list:Dock(FILL)
    main_pnl.ammo_list:DockMargin(0, 0, main_pnl.frameSpacing, 0)
    main_pnl.ammo_list:SetSpacingY()
    main_pnl.ammo_list.ySpacing = 8
    main_pnl.ammo_list:SetScrollbarMargin(main_pnl.frameSpacing * 0.7)
    main_pnl.ammo_list:InvalidateParent(true)

    main_pnl.ammoinfo = vgui.Create("DPanel", main_pnl)
    main_pnl.ammoinfo:Dock(BOTTOM)
    main_pnl.ammoinfo:SetTall(32)
    main_pnl.ammoinfo.Paint = function(_, w, h)
    	surface_SetDrawColor(main_pnl.UIColors.Background)
	    surface_DrawRect(0, 0, w, h)

		local pr = self:GetIsWorking() and 1 - math_Clamp((self:GetNextPrint() - CurTime()) / self.PrinterSpeed, 0, 1) or 1
		surface_SetDrawColor(main_pnl.UIColors.Hovered)
		surface_DrawRect(0, 0, pr * w, h)

	    draw_SimpleText(self:GetCurAmount().." " .. cached[2] .. " "..self.MaxMoney.." " .. cached[3], "rpui.Fonts.AmmoPrinter_AmmotypeTitle", w/2, h/2, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    for key, ammo_type in pairs(rp.ammoTypes) do
    	local ammo_type_btn = vgui.Create("DButton")
    	ammo_type_btn:SetText("")
        ammo_type_btn:Dock(TOP)
        ammo_type_btn:SetTall(56)
        ammo_type_btn:InvalidateParent(true)
        ammo_type_btn.Paint = function(that, w, h)
        	local baseColor = main_pnl.GetPaintStyle(that, STYLE_TRANSPARENT_SELECTABLE)
        	surface_SetDrawColor(baseColor)
	   		surface_DrawRect(0, 0, w, h)

	   		surface_SetDrawColor(main_pnl.UIColors.Black)
			surface_DrawRect(0, 0, h, h)

	   		draw_SimpleText((ammo_type.name or ""), "rpui.Fonts.AmmoPrinter_AmmotypeTitle", h + 4, h/2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	   		draw_SimpleText(math_floor(ammo_type.price*self.AmmoPriceMult), "rpui.Fonts.AmmoPrinter_AmmotypePrice", w - 8, h - 4, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end
        ammo_type_btn.DoClick = function()
        	surface.PlaySound("ui/buttonclickrelease.wav")

        	if math_floor(ammo_type.price*self.AmmoPriceMult) > self:GetCurAmount() then
        		rp.Notify(NOTIFY_RED, rp.Term('SPP_NotEnoughPatrons'))
        		return
        	end

        	net.Start("simpleammoprinter_getammo")
        		net.WriteInt(net_index, 32)
        		net.WriteInt(key, 32)
        	net.SendToServer()
        end
			

        ammo_type_btn.mdl_ico = vgui.Create("SpawnIcon", ammo_type_btn)
        local sz = ammo_type_btn:GetTall()*0.9
		ammo_type_btn.mdl_ico:SetSize(sz, sz)
		local ps = ammo_type_btn:GetTall()*0.05
		ammo_type_btn.mdl_ico:SetPos(ps, ps)
		ammo_type_btn.mdl_ico:SetModel(ammo_type.model or "models/props_borealis/bluebarrel001.mdl")
		ammo_type_btn.mdl_ico:SetMouseInputEnabled(false)
--[[
		ammo_type_btn.mdl_ico.Think = function(self)
			ammo_type_btn.IsHover = self:IsHovered()
		end
		ammo_type_btn.mdl_ico.DoClick = function(self)
			ammo_type_btn.DoClick(ammo_type_btn)
		end
]]--
		ammo_type_btn.mdl_ico.PaintOver = function() end
		ammo_type_btn.mdl_ico:SetTooltip(ammo_type.name or "")

        main_pnl.ammo_list:AddItem(ammo_type_btn)
    end



    main_pnl.CloseButton = vgui.Create("DButton", main_pnl)
    main_pnl.CloseButton:SetFont("rpui.Fonts.AmmoPrinter.Small")
    main_pnl.CloseButton:SetText(cached[4])
    main_pnl.CloseButton:SizeToContentsY(frameH * 0.03)
    main_pnl.CloseButton:SizeToContentsX(main_pnl.CloseButton:GetTall() + frameW * 0.05)
    main_pnl.CloseButton:SetPos( main_pnl:GetWide() - main_pnl.CloseButton:GetWide() - 6, 16)
    main_pnl.CloseButton.Paint = function( this, w, h )
        local baseColor, textColor = main_pnl.GetPaintStyle(this)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(main_pnl.UIColors.White)
        surface.DrawRect(0, 0, h, h)

        surface.SetDrawColor(Color(0, 0, 0,this._grayscale or 0))
        local p = h*0.1
        surface.DrawLine(h, p, h, h - p)

        draw_SimpleText("✕", "rpui.Fonts.AmmoPrinter.Small", h/2, h/2, main_pnl.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw_SimpleText(this:GetText(), this:GetFont(), w/2 + h/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        
        return true
    end
    main_pnl.CloseButton.DoClick = function(self)
    	if self.Closing then return end
    	self.Closing = true

	    main_pnl:AlphaTo(0, 0.25, 0, function()
	        if IsValid(main_pnl) then main_pnl:Remove() end
	    end)
    end

    main_pnl.place4ammos:SetSize(main_pnl:GetWide() - 24, main_pnl:GetTall() - main_pnl.CloseButton:GetTall() - 6 - 72)
    main_pnl.place4ammos:SetPos(12, main_pnl.CloseButton:GetTall() + 36)
end)