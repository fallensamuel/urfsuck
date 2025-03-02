-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_menus\\betterpopup_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if true then return end

local social_info;
local promo_menu;

net.Receive( "Social::Promocode", function()
	social_info                   = social_info or {};
	social_info[net.ReadString()] = true;
end );

net.Receive( "Social::GetInfo", function()
	social_info = {};
    
	local size = net.ReadUInt( 6 );
	if size > 0 then
		for k = 1, size do
			social_info[net.ReadString()] = true;
		end
	end
end );

local function process_click(social_id, cback)
	if IsValid(promo_menu) then
		promo_menu:Remove()
	end
	
	local h_mult = math.floor(ScrH() * 0.195) / 150
	
	if social_info[social_id] then
		menu = vgui.Create('urf.im/rpui/menus/blank')
		menu:SetSize(400 * h_mult, 180 * h_mult)
		menu:SetPos(ScrW() / 2 - 200 * h_mult, ScrH() / 2 - 90 * h_mult - 160)
		menu:MakePopup()
		promo_menu = menu
		
		menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
		menu.header.SetTitle(menu.header, translates.Get('Перейти к боту'))
		menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
		menu.header.IcoSizeMult = 1.4 + 0
		
		local label = vgui.Create('DLabel', menu)
		label:SetPos(10 * h_mult, 50 * h_mult)
		label:SetText(translates.Get('Перейти к боту можно по следующей ссылке:'))
		label:SetSize(400 * h_mult, 50 * h_mult)
		label:SetContentAlignment(4)
		label:SetFont('rpui.Fonts.Social.ButtonText')
		
		local input = vgui.Create("urf.im/rpui/txtinput", menu)
		input.UID = "StrRequest"
		input:SetPos(10 * h_mult, 100 * h_mult)
		input:SetSize(380 * h_mult, 30 * h_mult)
		input:ApplyDesign()
		input:SetEnabled(false)
		input:SetText(rp.cfg.Social[social_id].link)
		
		local subscribe = vgui.Create("urf.im/rpui/button", menu)
		subscribe.SetSize(subscribe, 380 * h_mult, 30 * h_mult)
		subscribe.SetPos(subscribe, 10 * h_mult, 140 * h_mult)
		subscribe.SetText(subscribe, translates.Get("Скопировать ссылку"))
		subscribe.SetFont(subscribe, "rpui.Fonts.Social.ButtonText") 
		subscribe.Think = function(self_s)
			if self_s.TextChanged and self_s.TextChanged < CurTime() then
				self_s:SetText(translates.Get("Скопировать ссылку"))
				self_s.TextChanged = nil
			end
		end
		subscribe.DoClick = function(self_sc)
			SetClipboardText(rp.cfg.Social[social_id].link)
			
			self_sc.TextChanged = CurTime() + 1
			self_sc:SetText(translates.Get("Скопировано"))
		end
		
		if social_id ~= 'teleg' then
			gui.OpenURL(rp.cfg.Social[social_id].link)
		end
		
	else
		local is_promo = rp.cfg.Social[social_id].is_promo
		
		menu = vgui.Create('urf.im/rpui/menus/blank')
		menu:SetSize(400 * h_mult, (180 + (social_id == 'teleg' and 50 or 0)) * h_mult)
		menu:SetPos(ScrW() / 2 - 200 * h_mult, ScrH() / 2 - 90 * h_mult - 160)
		menu:MakePopup()
		promo_menu = menu
		
		menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
		menu.header.SetTitle(menu.header, translates.Get('Получить бонус'))
		menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
		menu.header.IcoSizeMult = 1.4 + 0
		
		local h_tall = menu.header.GetTall(menu.header)
		
		if social_id ~= 'teleg' then
			gui.OpenURL(rp.cfg.Social[social_id].link)
		end
		
		if cback then
			cback(menu)
		end
		
		local label = vgui.Create('DLabel', menu)
		label:SetPos(10 * h_mult, 50 * h_mult)
		label:SetText(rp.cfg.Social[social_id].bonus_info or translates.Get('Подпишитесь на группу и получите бонусный промокод!'))
		label:SetSize(400 * h_mult, 50 * h_mult)
		label:SetContentAlignment(4)
		label:SetFont('rpui.Fonts.Social.ButtonText')
		
		local input = vgui.Create("urf.im/rpui/txtinput", menu)
		input.UID = "StrRequest"
		input:SetPos(10 * h_mult, 100 * h_mult)
		input:SetSize(300 * h_mult, 30 * h_mult)
		input:ApplyDesign()
		
		local ok = vgui.Create("urf.im/rpui/button", menu)
		ok.SetSize(ok, 80 * h_mult, 30 * h_mult)
		ok.SetPos(ok, 310 * h_mult, 100 * h_mult)
		ok.SetText(ok, translates.Get("Применить"))
		ok.SetFont(ok, "rpui.Fonts.Social.ButtonText") 
		ok.DoClick = function()
			local promo = input:GetValue()
			if not promo or string.len(promo) < 2 then
				return 
			end
			
			promo = utf8.sub(promo, 1, 16)
			
			net.Start('Social::Promocode')
            net.WriteString(social_id)
            net.WriteString(promo)
			net.SendToServer()
			
			menu:Close()
		end
		
		if social_id == 'teleg' then
			--[[
                if BRANCH == "x86-64" then
                    local html = vgui.Create("Chromium")
                    
                    if IsValid(html) then
                        html:OpenURL(rp.cfg.Social[social_id].link)
                        html:SetSize(ScrW(), ScrH())
                        
                        timer.Simple(10, function()
                            if IsValid(html) then html:Remove() end
                        end)
                    end
                end
                ]]
                
                input:SetPos(10 * h_mult, 190 * h_mult)
                ok.SetPos(ok, 310 * h_mult, 190 * h_mult)
                
                local input = vgui.Create("urf.im/rpui/txtinput", menu)
                input.UID = "StrRequest"
                input:SetPos(10 * h_mult, 100 * h_mult)
                input:SetSize(380 * h_mult, 30 * h_mult)
                input:ApplyDesign()
                input:SetEnabled(false)
                input:SetText(rp.cfg.Social[social_id].link)
                
                local subscribe = vgui.Create("urf.im/rpui/button", menu)
                subscribe.SetSize(subscribe, 380 * h_mult, 30 * h_mult)
                subscribe.SetPos(subscribe, 10 * h_mult, 140 * h_mult)
                subscribe.SetText(subscribe, translates.Get("Скопировать ссылку"))
                subscribe.SetFont(subscribe, "rpui.Fonts.Social.ButtonText") 
                subscribe.Think = function(self_s)
                    if self_s.TextChanged and self_s.TextChanged < CurTime() then
                        self_s:SetText(translates.Get("Скопировать ссылку"))
                        self_s.TextChanged = nil
                    end
                end
                subscribe.DoClick = function(self_sc)
                    SetClipboardText(rp.cfg.Social[social_id].link)
                    
                    self_sc.TextChanged = CurTime() + 1
                    self_sc:SetText(translates.Get("Скопировано"))
                end
                
            else
                local subscribe = vgui.Create("urf.im/rpui/button", menu)
                subscribe.SetSize(subscribe, 380 * h_mult, 30 * h_mult)
                subscribe.SetPos(subscribe, 10 * h_mult, 140 * h_mult)
                subscribe.SetText(subscribe, translates.Get("Перейти по ссылке"))
                subscribe.SetFont(subscribe, "rpui.Fonts.Social.ButtonText") 
                subscribe.DoClick = function()
                    gui.OpenURL(rp.cfg.Social[social_id].link)
                end
            end
        end
    end
    
    local function process_steam()
        if IsValid(promo_menu) then
            promo_menu:Remove()
        end
        
        local h_mult = math.floor(ScrH() * 0.195) / 150
        
        if social_info['steam'] then 
            menu = vgui.Create('urf.im/rpui/menus/blank')
            menu:SetSize(400 * h_mult, 180 * h_mult)
            menu:SetPos(ScrW() / 2 - 200 * h_mult, ScrH() / 2 - 90 * h_mult - 160)
            menu:MakePopup()
            promo_menu = menu
            
            menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
            menu.header.SetTitle(menu.header, translates.Get('Перейти к группе'))
            menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
            menu.header.IcoSizeMult = 1.4 + 0
            
            local label = vgui.Create('DLabel', menu)
            label:SetPos(10 * h_mult, 50 * h_mult)
            label:SetText(translates.Get('Перейти к группе можно по следующей ссылке:'))
            label:SetSize(400 * h_mult, 50 * h_mult)
            label:SetContentAlignment(4)
            label:SetFont('rpui.Fonts.Social.ButtonText')
            
            local input = vgui.Create("urf.im/rpui/txtinput", menu)
            input.UID = "StrRequest"
            input:SetPos(10 * h_mult, 100 * h_mult)
            input:SetSize(380 * h_mult, 30 * h_mult)
            input:ApplyDesign()
            input:SetEnabled(false)
            input:SetText(rp.cfg.Social['steam'].link)
            
            local subscribe = vgui.Create("urf.im/rpui/button", menu)
            subscribe.SetSize(subscribe, 380 * h_mult, 30 * h_mult)
            subscribe.SetPos(subscribe, 10 * h_mult, 140 * h_mult)
            subscribe.SetText(subscribe, translates.Get("Скопировать ссылку"))
            subscribe.SetFont(subscribe, "rpui.Fonts.Social.ButtonText") 
            subscribe.Think = function(self_s)
                if self_s.TextChanged and self_s.TextChanged < CurTime() then
                    self_s:SetText(translates.Get("Скопировать ссылку"))
                    self_s.TextChanged = nil
                end
            end
            subscribe.DoClick = function(self_sc)
                SetClipboardText(rp.cfg.Social['steam'].link)
                
                self_sc.TextChanged = CurTime() + 1
                self_sc:SetText(translates.Get("Скопировано"))
            end
            
            gui.OpenURL(rp.cfg.Social['steam'].link)
            
            return 
        end
        
        gui.OpenURL(rp.cfg.Social['steam'].link)
		
        timer.Simple(20, function()
            http.Fetch(rp.cfg.Social.steam.handler .. '&steamid=' .. LocalPlayer():SteamID64(), function(body)
			if body == '0' then
				return rp.Notify(NOTIFY_GENERIC, translates.Get('Вы уже получили бонус за вступление в группу!'))
			end
            
			if body == '1' then
				return rp.Notify(NOTIFY_ERROR, translates.Get('Вы не вступили в нашу группу или ваш профиль Steam приватный!'))
			end
            
			social_info['steam'] = true
            
			net.Start('Social::Steam')
			net.SendToServer()
		end)
	end)
end


local PANEL = {};


PANEL.AvalibleBonuses = {
    "vk",
    "steam",
    "discord",
    -- "teleg",
};


PANEL.CachedColors = {
    ["vk"]      = { Color(74, 118, 168, 45),  Color(74, 118, 168, 255) },
    ["steam"]   = { Color(23, 26, 33, 75),    Color(23, 26, 33, 255) },
    ["discord"] = { Color(114, 137, 218, 45), Color(114, 137, 218, 255) },
    ["teleg"]   = { Color(45, 164, 224, 45),  Color(45, 164, 224, 255) },
};


PANEL.CachedMaterials = {
    ["vk"]         = Material( "bonuses/vk",       "smooth noclamp" ),
    ["steam"]      = Material( "bonuses/steam",    "smooth noclamp" ),
    ["discord"]    = Material( "bonuses/discord",  "smooth noclamp" ),
    ["teleg"]      = Material( "bonuses/telegram", "smooth noclamp" ),

    ["gradient-d"] = Material( "vgui/gradient-d" ),
    ["lock"]       = Material( "rpui/bonus_menu/lock" ),
};


PANEL.ProcessSocial = {
    ["vk"]      = process_click;
    ["steam"]   = process_steam;
    ["discord"] = process_click;
    ["teleg"]   = process_click;
};


function PANEL:Init()
    if not rp.seasonpass then
        self:Remove();
        return
    end
    
    if (rp.seasonpass.CurrentSeason or -1) <= 0 then
        self:Remove();
        return 
    end

    self:SetAlpha( 0 );

    timer.Simple( RealFrameTime(), function()
        if not IsValid( self ) then return end
        self:Initialize( self:GetSize() );

        self:AlphaTo( 255, 0.25 );
    end );
end


function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.BetterPopup.RewardButton", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 1000,
        size     = frameH * 0.05,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.TitleS", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 1000,
        size     = frameW * 0.05,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.TitleSub", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 500,
        size     = frameH * 0.05,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.Preview", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 1000,
        size     = frameH * 0.04,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.PreviewSmall", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 0,
        size     = frameH * 0.0275,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.ButtonText", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = frameH * 0.035,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.SubButtonText", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = frameH * 0.04,
    } );

    surface.CreateFont( "rpui.Fonts.BetterPopup.BlockedText", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = frameH * 0.1,
    } );
end


function PANEL:Initialize( frameW, frameH )
    self:RebuildFonts( frameW, frameH );

    self.innerPadding = frameW * 0.02;

    -- Social bonus:
    if not social_info then
        social_info = {};
        
        net.Start( "Social::GetInfo" );
        net.SendToServer();
    end

    while not self.SelectedSocial do
        local r = self.AvalibleBonuses[ math.random(1,#self.AvalibleBonuses) ];

        if not social_info[r] and rp.cfg.Social[r] then
            self.SelectedSocial = r;
        end
    end

    self.SubButtonHeight = math.Round( frameH * 0.075 );

    self.SocialBonus = vgui.Create( "DButton", self );
    self.SocialBonus:SetPos( self.innerPadding, self.innerPadding );
    self.SocialBonus:SetSize( frameH * 0.4, frameH * 0.55 );
    self.SocialBonus:SetText( "" );
    self.SocialBonus.Paint = function( this, w, h )
        if not self.SelectedSocial then return end

        this._alpha = math.Approach(
            this._alpha or 0,
            (this:IsHovered() and 1 or 0),
            RealFrameTime() * 3
        );
        
        local clr = Color(
            self.CachedColors[self.SelectedSocial][1].r + (self.CachedColors[self.SelectedSocial][2].r - self.CachedColors[self.SelectedSocial][1].r) * this._alpha,
            self.CachedColors[self.SelectedSocial][1].g + (self.CachedColors[self.SelectedSocial][2].g - self.CachedColors[self.SelectedSocial][1].g) * this._alpha,
            self.CachedColors[self.SelectedSocial][1].b + (self.CachedColors[self.SelectedSocial][2].b - self.CachedColors[self.SelectedSocial][1].b) * this._alpha,
            255 * this._alpha
        );

        surface.SetDrawColor( self.CachedColors[self.SelectedSocial][1] )
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( rpui.UIColors.Hovered )
        surface.DrawRect( 0, h - self.SubButtonHeight, w, self.SubButtonHeight );

        surface.SetDrawColor( clr );
        surface.DrawOutlinedRect( 0, 0, w, h );

        surface.SetDrawColor( clr );
        surface.DrawRect( 0, h - self.SubButtonHeight, w, self.SubButtonHeight );

        surface.SetDrawColor( Color(255, 255, 255, 20 + 235 * this._alpha) );
        surface.SetMaterial( self.CachedMaterials[self.SelectedSocial] );
        surface.DrawTexturedRectRotated( w * 0.5, h * 0.5 - self.SubButtonHeight * 0.5, h * 0.35, h * 0.35, 0 );

        draw.SimpleText( rp.cfg.Social[self.SelectedSocial].bonus_text or self.SelectedSocial, "rpui.Fonts.BetterPopup.ButtonText", w * 0.5, h - self.SubButtonHeight * 0.5, Color(255,255,255,50 + 205 * this._alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    end
    self.SocialBonus.DoClick = function( this )
        if not self.SelectedSocial then return end

        self.ProcessSocial[self.SelectedSocial]( self.SelectedSocial );
    end

    -- Season pass:
    local season = rp.seasonpass.GetSeason();

    self.SeasonPass = vgui.Create( "Panel", self );
    self.SeasonPass:SetSize( frameW - self.SocialBonus:GetWide() - self.innerPadding * 3, self.SocialBonus:GetTall() );
    self.SeasonPass:SetPos( self.innerPadding + self.SocialBonus:GetWide() + self.innerPadding, self.innerPadding );

    self.SeasonPass.Preview = vgui.Create( "Panel", self.SeasonPass );
    self.SeasonPass.Preview:Dock( LEFT );
    self.SeasonPass.Preview:SetWide( self.SeasonPass:GetTall() * 0.35 );
    self.SeasonPass.Preview.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.White );
        surface.SetMaterial( season.PremiumHeadBack );
        surface.DrawTexturedRect( 0, 0, w, h * 1.025 );

        draw.SimpleText( utf8.upper(season.pre_name) .. ":", "rpui.Fonts.BetterPopup.Preview", w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
        if not this.wrapped then
            this.wrapped = string.Wrap( "rpui.Fonts.BetterPopup.PreviewSmall", utf8.upper(season.name), w );

            for _, t in pairs( this.wrapped ) do
                t = string.Trim(t);
            end

            surface.SetFont( "rpui.Fonts.BetterPopup.PreviewSmall" );
            local w, h = surface.GetTextSize( "" );
            this.wrappedh = h;
        end

        for k, t in pairs( this.wrapped ) do
            draw.SimpleText( t, "rpui.Fonts.BetterPopup.PreviewSmall", w * 0.5, h * 0.5 + this.wrappedh * (k-1), rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
        end
    end

    self.SeasonPass.Header = vgui.Create( "Panel", self.SeasonPass );
    self.SeasonPass.Header:Dock( TOP );
    self.SeasonPass.Header:DockMargin( self.innerPadding * 0.5, 0, 0, self.innerPadding * 0.5 );
    self.SeasonPass.Header:SetTall( self.SeasonPass:GetTall() * 0.3 );
    self.SeasonPass.Header.Paint = function( this, w, h )
        local _, th = draw.SimpleText( "Награды сезона:", "rpui.Fonts.BetterPopup.TitleSub", 0, h, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

        if not this.titlescaled then
            surface.SetFont( "rpui.Fonts.BetterPopup.TitleS" );
            local pw, ph = surface.GetTextSize( utf8.upper(season.pre_name) .. ": " .. utf8.upper(season.name) );

            surface.CreateFont( "rpui.Fonts.BetterPopup.Title", {
                font     = "Montserrat",
                extended = true,
                weight 	 = 1000,
                size     = ph * math.min( 1, (w * 0.95)/pw ),
            } );

            this.titlescaled = true;
        end

        local tw = draw.SimpleText( utf8.upper(season.pre_name) .. ": ", "rpui.Fonts.BetterPopup.Title", 0, h - th, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
        draw.SimpleText( utf8.upper(season.name), "rpui.Fonts.BetterPopup.Title", tw, h - th, rpui.UIColors.TextGold, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
    end

    self.SeasonPass.Content = vgui.Create( "DButton", self.SeasonPass );
    self.SeasonPass.Content:SetText( "" );
    self.SeasonPass.Content:Dock( FILL );
    self.SeasonPass.Content:DockMargin( self.innerPadding * 0.25, 0, 0, 0 );
    self.SeasonPass.Content:SetTall( self.SeasonPass.Preview:GetWide() );
    self.SeasonPass.Content.Paint = function( this, w, h )
        this._alpha = math.Approach(
            this._alpha or 0,
            (this:IsHovered() and 1 or 0),
            RealFrameTime() * 3
        );

        local s = self.innerPadding * 0.25;
        local iw = math.Round( (w - (s*7)) / 7 ); 
        local iconsize = iw * 0.75;
        for i = 1, 7 do
            local rewards = season.PremiumRewards[i];
            
            local x = (iw+s)*(i-1);

			if season.PremiumTabMat then
                surface.SetDrawColor( rpui.UIColors.White );
				surface.SetMaterial( season.PremiumTabMat );
				surface.DrawTexturedRect( x, 0, iw, h );
            else
                surface.SetDrawColor( rpui.UIColors.Shading );
                surface.DrawRect( x, 0, iw, h );
			end
			
            local clr = season.RewardsData[i].color_premium;
            surface.SetDrawColor( Color(clr.r,clr.g,clr.b,127) );
            surface.SetMaterial( self.CachedMaterials["gradient-d"] );
            surface.DrawTexturedRect( x, 0, iw, h );

            for k, r in ipairs( rewards ) do
                local scaling = (h * (0.25 * (#rewards-1)));
                surface.SetDrawColor( Color(255,255,255,200) );
                surface.SetMaterial( r.icon );
                surface.DrawTexturedRect( x + iw * 0.5 - iconsize * 0.5, (h + scaling) / (#rewards+1) * k - iconsize * 0.5 - scaling * 0.5, iconsize, iconsize );
            end
        end
    end
    self.SeasonPass.Content.PaintOver = function( this, w, h )
        local a = surface.GetAlphaMultiplier();

        surface.SetAlphaMultiplier( this._alpha )
            this.rotAngle = (this.rotAngle or 0) + 100 * RealFrameTime();

            draw.Blur( this );

            surface.SetDrawColor( rpui.UIColors.Hovered );
            surface.DrawRect( 0, 0, w, h );

            if self.tw then
                surface.SetDrawColor( Color(0,200,0) );
                surface.DrawRect( w * 0.5 - self.tw * 0.5, h * 0.5 - self.th * 0.5, self.tw, self.th );

                surface.SetDrawColor( rpui.UIColors.Hovered );
                surface.SetMaterial( self.CachedMaterials["gradient-d"] );
                surface.DrawTexturedRect( w * 0.5 - self.tw * 0.5, h * 0.5 - self.th * 0.5, self.tw, self.th );

                draw.SimpleText( translates.Get("К НАГРАДАМ"), "rpui.Fonts.BetterPopup.RewardButton", w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            else
                self.tw, self.th = draw.SimpleText( translates.Get("К НАГРАДАМ"), "rpui.Fonts.BetterPopup.RewardButton", w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                self.tw, self.th = self.tw * 1.5, self.th * 1.25;
            end
            
            rpui.DrawStencilBorder( this, 0, 0, w, h, 0.02, Color(0,200,0), rpui.UIColors.Hovered, self:GetAlpha() / 255 * this._alpha );
        surface.SetAlphaMultiplier( a );
    end
    self.SeasonPass.Content.DoClick = function( this )
        self:Close(); 
						
        local SeasonpassMenu = vgui.Create( "rpui.Seasonpass" );
        SeasonpassMenu:SetSize( ScrW() * 0.75, ScrH() * 0.75 );
        SeasonpassMenu:Center();
        SeasonpassMenu:MakePopup();
    end

    -- lootboxes:
    if rp.lootbox and rp.lootbox.All then
        for k, v in pairs(rp.lootbox.All) do
            if v.cooldown_time and (not v.price or v.price == 0) then
                self.CachedLB = v;
                break
            end
        end
	end

    self.DailyCase = vgui.Create( "DButton", self );
    self.DailyCase:SetText( "" );
    self.DailyCase:SetSize( frameW - self.innerPadding * 2, frameH - self.SocialBonus:GetTall() - self.innerPadding * 3 );
    self.DailyCase:SetPos( self.innerPadding, frameH - self.DailyCase:GetTall() - self.innerPadding );
    self.DailyCase.Paint = function( this, w, h )
        this._alpha = math.Approach(
            this._alpha or 0,
            (this:IsHovered() and 1 or 0),
            RealFrameTime() * 3
        );

        surface.SetDrawColor( Color(73,81,82,150) );
        surface.DrawRect( 0, 0, w, h );

        if this.Button then h = h - this.Button:GetTall(); end

        surface.SetDrawColor( Color(
            149 * (this.IsAvalible and 1 or 0) * this._alpha,
            173 * (this.IsAvalible and 1 or 0) * this._alpha,
            202 * (this.IsAvalible and 1 or 0) * this._alpha,
            50 + 205 * (this.IsAvalible and 1 or 0.2) * this._alpha
        ) );

        surface.SetMaterial( self.CachedMaterials["gradient-d"] );
        surface.DrawTexturedRect( 0, 0, w, h );

        local time_t;
        local lb_data = self.CachedLB;

        if lb_data.cooldown_time then
			local cds = LocalPlayer():GetNetVar( "LootboxCooldowns" ) or {}
			
			if cds[lb_data.NID] and tonumber( cds[lb_data.NID] ) > os.time() then
				time_t = tonumber( cds[lb_data.NID] ) - os.time();
			end
		end
		
		if lb_data.needed_time and LocalPlayer():GetTodayPlaytime() < lb_data.needed_time and (not time_t or (time_t < lb_data.needed_time - LocalPlayer():GetTodayPlaytime())) then
			time_t = lb_data.needed_time - LocalPlayer():GetTodayPlaytime();
		end

        if (time_t or 0) <= 0 then
            if not this.IsAvalible then
                this.IsAvalible = true;
            end

            if not this.Mdl then
                this.Mdl = vgui.Create( "DModelPanel", this );
                this.Mdl:SetSize( h, h );
                this.Mdl:SetPos( w * 0.5 - this.Mdl:GetWide() * 0.5, (frameH * 0.075) * 0.25 );
                this.Mdl:SetModel( self.CachedLB.model );
                this.Mdl:SetMouseInputEnabled( false );
                this.Mdl.LayoutEntity = function( this, ent )
                    if not IsValid(ent) then return end

                    local mins, maxs = ent:GetModelRenderBounds();
                    ent:SetPos( Vector( 0, 0, -(mins.z+maxs.z) * 0.5 ) );

                    local size = mins:Distance( maxs );

                    this:SetLookAng( Angle(35,CurTime()*2,0) );
                    this:SetCamPos( -this:GetLookAng():Forward() * size );
                end

                self.DailyCase.Button.Text = translates.Get("Забрать");
            end

            draw.SimpleText( translates.Get("Ежедневный кейс доступен!"), "rpui.Fonts.BetterPopup.SubButtonText", w * 0.5, (frameH * 0.075) * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        else
            local size = h * 0.45;

            time_t       = string.FormattedTime( time_t );
            blocked_text = string.format( "%02i:%02i:%02i", time_t.h, time_t.m, time_t.s );
            
            if not this.blockwidth then
                this.tw, this.th = draw.SimpleText( translates.Get("Вы сможете забрать ежедневный кейс через"), "rpui.Fonts.BetterPopup.SubButtonText", w * 0.375, h * 0.37, Color(255, 255, 255, 76 + this._alpha * 0.7), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                this.blockwidth = size + h * 0.05 + this.tw;
            else
                local cx, cy = w * 0.5 - this.blockwidth * 0.5, h * 0.5 - size * 0.5;
                local highlight = Color(255, 255, 255, 76 + this._alpha * 255 * 0.7);

                surface.SetDrawColor( highlight );
                surface.SetMaterial( self.CachedMaterials["lock"] );
                surface.DrawTexturedRect( cx, cy, size, size );

                draw.SimpleText( blocked_text, "rpui.Fonts.BetterPopup.BlockedText", cx + size + h * 0.05, cy + size, highlight, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
                draw.SimpleText( translates.Get("Вы сможете забрать ежедневный кейс через"), "rpui.Fonts.BetterPopup.SubButtonText", cx + size + h * 0.05, cy, highlight, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
            end
        end        
    end
    self.DailyCase.DoClick = function( this )
        if not this.IsAvalible then return end

        LocalPlayer().donateLastCatName = translates.Get( "КЕЙСЫ" );
		RunConsoleCommand( "say", "/upgrades" );

		self:Close();
    end
    
    self.DailyCase.Button = vgui.Create( "DPanel", self.DailyCase );
    self.DailyCase.Button:SetMouseInputEnabled( false );
    self.DailyCase.Button:Dock( BOTTOM );
    self.DailyCase.Button:SetTall( frameH * 0.075 );
    self.DailyCase.Button.Text = translates.Get('Ежедневный Кейс');
    self.DailyCase.Button.Paint = function( this, w, h )
        local p = this:GetParent();

        --Color(73,81,82),
        --Color(92,105,112)

        surface.SetDrawColor( Color(
            73 + 19 * p._alpha,
            81 + 24 * p._alpha,
            82 + 30 * p._alpha
        ) );
        surface.DrawRect( 0, 0, w, h );
        
        draw.SimpleText( this.Text, "rpui.Fonts.BetterPopup.ButtonText", w * 0.5, h * 0.5, Color(255,255,255,50 + 205 * p._alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        if self.DailyCase.IsAvalible then
            rpui.DrawStencilBorder( this, 0, 0, w, h, 0.05, rpui.UIColors.BackgroundGold, rpui.UIColors.Gold, self:GetAlpha() / 255 * p._alpha);
        end
    end

    self.CloseButton = vgui.Create( "DButton", self );
    self.CloseButton:SetFont( "rpui.Fonts.BetterPopup.PreviewSmall" );
    self.CloseButton:SetText( "✕" );
    self.CloseButton:SizeToContentsY( frameH * 0.015 );
    self.CloseButton:SetWide( self.CloseButton:GetTall() );
    self.CloseButton:SetPos( frameW - self.CloseButton:GetWide() - self.innerPadding, self.innerPadding );
    self.CloseButton.DoClick = function() self:Close() end;
    self.CloseButton.Paint = function( this, w, h )
        local baseColor, textColor = self.GetPaintStyle( this );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        draw.SimpleText( "✕", this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    
        return true
    end
end


function PANEL:Close()
    self.Closing = true;

    self:AlphaTo( 0, 0.25, 0, function()
        if IsValid( self ) then self:Remove(); end
    end );
end


function PANEL:Think()
    if not input.IsKeyDown(KEY_F4) then self.CanClose = true; end

    local focus = vgui.GetKeyboardFocus() or self;
    if (input.IsKeyDown(KEY_ESCAPE) or (input.IsKeyDown(KEY_X) and not (focus:GetClassName() == "TextEntry")) or (input.IsKeyDown(KEY_F4) and self.CanClose)) and !self.Closing then
        gui.HideGameUI();
        self:Close();
    end
end


function PANEL:Paint( w, h )
    draw.Blur( self );

    surface.SetDrawColor( self.UIColors.Shading );
    surface.DrawRect( 0, 0, w, h );
end


vgui.Register( "rpui.BetterPopup", PANEL, "Panel" );


--


function rp.ShowBetterPopup()
    if IsValid( BetterPopup ) then BetterPopup:Remove() end

    BetterPopup = vgui.Create( "rpui.BetterPopup", vgui.GetWorldPanel() );
    BetterPopup:SetSize( ScrH() * 0.9, ScrH() * 0.9 * 0.6 );
    BetterPopup:Center();
    BetterPopup:MakePopup();
end

hook.Add( "rpBase.Loaded", "BetterPopup::Register", function()
    rp.RegisterLoginPopup( 1000, rp.ShowBetterPopup );
end );