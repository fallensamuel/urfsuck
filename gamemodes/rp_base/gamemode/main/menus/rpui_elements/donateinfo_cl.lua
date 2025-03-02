-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_elements\\donateinfo_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local poly = {{x = 16, y = 16}, {x = 0, y = 16}, {x = 0, y = 0}}
local surface, math, draw, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM, table, os, string = surface, math, draw, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM, table, os, string
local LocalPlayer = LocalPlayer

local scale = ScrH() / 1080
local frameH = 900

local font_n = "rpui.Fonts.DonateInfo_"
local font1, font2 = font_n .."1", font_n .."2"

surface.CreateFont(font1, {
    font = "Montserrat",
    extended = true,
    weight = 600,
    size = frameH * 0.025 * scale,
})

surface.CreateFont(font2, {
    font = "Montserrat",
    extended = true,
    weight = 600,
    size = frameH * 0.020 * scale,
})


local PANEL = {}

function PANEL:Init()
    self:SetText("");

    self:SetWide(1);
    
    self:Update();

    self.ProperlyScaled = false;
end

function PANEL:Update()
    local os_time = os.time()
    local is_sale = rp.GetDiscountTime() >= os_time
    local is_skinsmult = rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() >= os_time
    local is_globalmult = rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() >= os_time
    local Sale = is_sale and table.Copy(nw.GetGlobal('rp.shop.settings')) or {global = 0, duntil = 0};
    local personal_ = LocalPlayer().GetPersonalDiscount and LocalPlayer():GetPersonalDiscount()*100 or 0

    local is_personal_sale
    if personal_ > Sale.global then
        Sale.global = personal_
    end
    if not is_sale and personal_ > 0 then
        is_sale = true
        is_personal_sale = true
    end

    local multplyaer_personal_ = LocalPlayer().GetPersonalDonateMultiplayer and LocalPlayer():GetPersonalDonateMultiplayer() or 0

    local lines_num = 2

    local remain_txt = translates.Get('осталось')
    local sale_txt = is_personal_sale and translates.Get('ПЕРСОНАЛЬНАЯ СКИДКА') or translates.Get('СКИДКА')
    local on_all_txt = translates.Get('НА ВСЁ')

    local tooltip_phrase, tooltip_phrase_args = "", {}

    local line2txt, custom_font_
    if is_sale then
        local allowed_cats = {["Шапки"] = true, ["Время"] = true, ["Профессии"] = true, ["Валюта"] = true}

        local items = {}
        for k, v in pairs(rp.shop.GetTable()) do
            if allowed_cats[v.Cat] then
                table.insert(items, v)
            end
        end

        local item = items[math.random(1, #items)]

        local rub = " ".. translates.Get("РУБ")

		if item and item.Name then
            tooltip_phrase = "Например `%s` сейчас стоит %s вместо %s!"
            tooltip_phrase_args = {item.Name, math.floor(item.Price * (1 - Sale.global/100)) .. rub, item.Price .. rub}
		end
    elseif is_globalmult then
        local mult = (rp.GetDonateMultiplayer and rp.GetDonateMultiplayer() or 0)

        sale_txt = translates.Get('БОНУС')
        on_all_txt = translates.Get('НА ПОПОЛНЕНИЯ')
        Sale = {
            global = 100 * mult
        }

        tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"

        local min = rp.GetDonateMultiplayerMinimum()
        if min > 0 then
            lines_num = 3
            line2txt = translates.Get('при пожертвовании от %s руб', min)
            tooltip_phrase_args = {min + 50, (min + 50) * mult}
        else
            tooltip_phrase_args = {250, 250 * mult}
        end
    elseif is_skinsmult then
        sale_txt = translates.Get('БОНУС')
        on_all_txt = translates.Get('ДОНАТ СКИНАМИ')
        Sale = {
            global = 100 * rp.GetSkinsDonateMultiplayer()
        }

        tooltip_phrase = "Например если вы пожертвуете %s руб скинами, вы получите %s руб на ваш счёт"
        tooltip_phrase_args = {250, 250 * rp.GetSkinsDonateMultiplayer()}
    elseif multplyaer_personal_ > 1 then
        sale_txt = translates.Get('ПЕРСОНАЛЬНЫЙ БОНУС')
        on_all_txt = translates.Get('НА ПОПОЛНЕНИЯ')
        Sale = {
            global = multplyaer_personal_ * 100
        }
        custom_font_ = "rpui.Fonts.ESCMenu.Tooltip_2"

        tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"
        tooltip_phrase_args = {250, 250 * multplyaer_personal_}
    end

    if tooltip_phrase ~= "" then self:SetTooltip(translates.Get(tooltip_phrase, unpack(tooltip_phrase_args))) end

    local selfw, selfh = ScrW() * 0.25, ScrH() * 0.03
    --self:SetSize( selfw, selfh * lines_num );

    self.CustomFont = custom_font_
    self.sale_txt = sale_txt
    self.line2txt = line2txt
    self.on_all_txt = on_all_txt
    self.remain_txt = remain_txt
    self.lines_num = lines_num
    self.Sale = Sale

    self.is_personal_sale, self.is_sale, self.is_globalmult, self.is_skinsmult = is_personal_sale, is_sale, is_globalmult, is_skinsmult

    self.DisabledNow = not is_sale and (not is_skinsmult and not is_globalmult and multplyaer_personal_ <= 1)

    self:SetPos( ScrW() - self:GetWide() - 6, ScrH() - self:GetTall() - 10 );
    --self:SetTall(self.lines_num == 2 and 64 or 86)
end

function PANEL:Paint(w, h)
    if self.DisabledNow then
        if self.ProperlyScaled then self.ProperlyScaled = false; end
        return
    end

    local remain_txt, custom_font_, sale_txt, line2txt, on_all_txt, lines_num, Sale = self.remain_txt, self.custom_font_, self.sale_txt, self.line2txt, self.on_all_txt, self.lines_num, self.Sale
    local is_personal_sale, is_sale, is_globalmult, is_skinsmult = self.is_personal_sale, self.is_sale, self.is_globalmult, self.is_skinsmult

    self.rotAngle = (self.rotAngle or 0) + 100 * FrameTime()
    local baseColor, textColor = rpui.GetPaintStyle(self, STYLE_GOLDEN)
    surface.SetDrawColor(Color(0, 0, 0, 255))
    local distsize = math.sqrt(w * w + h * h)
    local parentalpha = self:GetAlpha() / 255
    local alphamult = self._alpha / 255

    --rpui.ExperimentalStencil(function()
        draw.NoTexture()
        surface.SetDrawColor(rpui.UIColors.White)

        surface.DrawRect(0, 16, w, h)
        --render.SetStencilCompareFunction(STENCIL_EQUAL)
        --render.SetStencilFailOperation(STENCIL_KEEP)
        --surface.SetAlphaMultiplier((IsValid(self.PseudoParent) and self.PseudoParent or self:GetParent()):GetAlpha() / 255)
        surface.SetDrawColor(rpui.UIColors.BackgroundGold)
        surface.DrawRect(0, 0, w, h)
        surface.SetMaterial(rpui.GradientMat)
        surface.SetDrawColor(rpui.UIColors.Gold)
        surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, distsize, distsize, (self.rotAngle or 0))
        local last = is_personal_sale and (LocalPlayer().GetPersonalDiscountTime and LocalPlayer():GetPersonalDiscountTime() or 0) or is_sale and (rp.GetDiscountTime() - os.time()) or (is_globalmult and ((rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() or 0) - os.time()) or is_skinsmult and ((rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() or 0) - os.time()) or (LocalPlayer().GetPersonalDonateMultiplayerTime and LocalPlayer():GetPersonalDonateMultiplayerTime() or 0))
        local tb = string.FormattedTime((last > 0) and last or 0)
        local Out = remain_txt .. ' ' .. string.format("%02i:%02i:%02i", tb['h'], tb['m'], tb['s'])
        local show3lines = lines_num > 2
        local txt = sale_txt .. ' ' .. Sale.global .. '% ' .. on_all_txt


        --surface.SetFont(font1)
        --local _w, _h = surface.GetTextSize(txt)

        local black = rpui.UIColors.Black

        if not self.ProperlyScaled then
            local ts, th = 0, 0;
            local __textw, __texth;
            if show3lines then
                __textw, __texth = draw.SimpleText(txt, font1, w * 0.5, h * 0.575, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                ts = math.max( ts, __textw ); th = th + __texth;
                __textw, __texth = draw.SimpleText(line2txt, font2, w * 0.5, h * 0.65, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                ts = math.max( ts, __textw ); th = th + __texth;
                __textw, __texth = draw.SimpleText(Out, font2, w * 0.5, h * 0.725, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                ts = math.max( ts, __textw ); th = th + __texth;
            else
                __textw, __texth = draw.SimpleText(txt, font1, w * 0.5, h * 0.5, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                ts = math.max( ts, __textw ); th = th + __texth;
                __textw, __texth = draw.SimpleText(line2txt or Out, font2, w * 0.5, h * 0.5, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                ts = math.max( ts, __textw ); th = th + __texth;
            end

            --self:SetSize( math.max(self:GetWide(), ts + th*0.5), math.max(self:GetTall(), th * 1.5) );
            self:SetSize( math.max(self:GetWide(), ts + th*0.5), th * 1.25 );
            self.ProperlyScaled = true;
            self:Update();
        else
            if show3lines then
                draw.SimpleText(txt, font1, w * 0.5, h * 0.575, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(line2txt, font2, w * 0.5, h * 0.65, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(Out, font2, w * 0.5, h * 0.725, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)            
            else
                draw.SimpleText(txt, font1, w * 0.5, h * 0.5, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                draw.SimpleText(line2txt or Out, font2, w * 0.5, h * 0.5, black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            end
        end

        --surface.SetAlphaMultiplier(1)
    --end)
end

--function PANEL:Think()
--  if self.PseudoParent and not IsValid(self.PseudoParent) then
--      self:Remove()
--  end
--end

function PANEL:DoClick()
    LocalPlayer().donateLastCategory = translates.Get( "ИВЕНТЫ" );
    RunConsoleCommand( "say", "/upgrades" );
end

vgui.Register("urf.im/donateinfo", PANEL, "DButton")

hook.Add("OnContextMenuOpen", "DonateInfo", function()
    if IsValid(g_ContextMenu.DonateInfo) then return end

    g_ContextMenu.DonateInfo = g_ContextMenu:Add("urf.im/donateinfo")
    --g_ContextMenu.DonateInfo.X = ScrW() - g_ContextMenu.DonateInfo:GetWide() - 6
    --g_ContextMenu.DonateInfo.Y = ScrH() - g_ContextMenu.DonateInfo:GetTall() - 10
end)

hook.Add("RefreshContextMenu", "DonateInfo", function()
    if IsValid(g_ContextMenu.DonateInfo) then
        g_ContextMenu.DonateInfo:Update()
        --g_ContextMenu.DonateInfo.X = ScrW() - g_ContextMenu.DonateInfo:GetWide() - 6
        --g_ContextMenu.DonateInfo.Y = ScrH() - g_ContextMenu.DonateInfo:GetTall() - 10
    end
end)

hook.Add("SpawnMenuOpen", "DonateInfo", function()
    if IsValid(g_SpawnMenu.DonateInfo) then
        g_SpawnMenu.DonateInfo:Update()
        --g_SpawnMenu.DonateInfo.X = ScrW() - g_SpawnMenu.DonateInfo:GetWide() - 6
        --g_SpawnMenu.DonateInfo.Y = ScrH() - g_SpawnMenu.DonateInfo:GetTall() - 10
        return
    end

    g_SpawnMenu.DonateInfo = g_SpawnMenu:Add("urf.im/donateinfo")
    --g_SpawnMenu.DonateInfo.X = ScrW() - g_SpawnMenu.DonateInfo:GetWide() - 6
    --g_SpawnMenu.DonateInfo.Y = ScrH() - g_SpawnMenu.DonateInfo:GetTall() - 10
    
    g_SpawnMenu.DonateInfo:Update()
end)