if not rp.cfg.Social then return end

cvar.Register'enable_social_ints':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить уведомление о доступных подписках при заходе')

local steam_icon = Material('bonuses/steam', "smooth", "noclamp")
local discord_icon = Material('bonuses/discord', "smooth", "noclamp")
local vk_icon = Material('bonuses/vk', "smooth", "noclamp")
local blocked_icon = Material('rpui/bonus_menu/lock', "smooth", "noclamp")
local social_info


local PANEL = {}

function PANEL:Init()
	self:SetText('')
end

function PANEL:SetColors(bg, outline)
	self.BgColor = bg
	self.OutlineColor = outline
end

function PANEL:SetContentText(text)
	self.ContentText = text
end

function PANEL:SetContentPercent(percent)
	self.ContentPercent = percent
end

function PANEL:SetContentIcon(icon)
	self.ContentIcon = icon
end

function PANEL:SetSocialID(social_id)
	self.SocialID = social_id
end

function PANEL:SetBonus(bonus)
	self:SetContentText(bonus and bonus.Name)
	self:SetContentIcon(bonus and bonus.Icon)
	
	self.Bonus = bonus
end

function PANEL:DoClick()
	if self.Bonus then
		if self.Bonus.InCooldown(self.Bonus, LocalPlayer()) or self.Bonus.GetPlayTime(self.Bonus, LocalPlayer()) > LocalPlayer():GetPlayTime() then
			return
		end
		
		net.Start('AbilityUse')
			net.WriteInt(self.Bonus.GetID(self.Bonus), 6)
		net.SendToServer()
	end
end

local size, height_bottom, baseColor, textColor, a, time_left, blocked_text, btx, bty
local function get_derived_color(color, value)
	return Color(color.r * value, color.g * value, color.b * value, 112 + value * 143)
end

function PANEL:Paint(w, h)
	height_bottom = math.floor(h * (self.ContentPercent or .135))
	
	baseColor, textColor = rpui.GetPaintStyle(self, STYLE_BLANKSOLID);
	a = baseColor.a
	
	surface.SetDrawColor(self.BgColor or Color(255, 255, 255, 255))
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(get_derived_color(self.OutlineColor, a / 255))
	surface.DrawRect(0, h - height_bottom, w, height_bottom)
	
	surface.SetDrawColor(self.OutlineColor and Color(self.OutlineColor.r, self.OutlineColor.g, self.OutlineColor.b, a) or Color(0, 0, 0, 255))
	self:DrawOutlinedRect()
	
	draw.SimpleText(self.SocialID and (social_info[self.SocialID] and translates.Get('Получено')) or self.ContentText or translates.Get('бонус'), self.Bonus and 'rpui.Fonts.Social.SubButtonText' or 'rpui.Fonts.Social.ButtonText', w * .5, h - height_bottom * .5, self.Bonus and Color(textColor.r, textColor.g, textColor.b, 127 + a * .5) or Color(255, 255, 255, 127 + a * .5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	if self.ContentIcon then
		size = 0.35 * w
		
		if self.Bonus then
			time_left = self.Bonus.GetPlayTime(self.Bonus) > LocalPlayer():GetPlayTime() and self.Bonus.GetPlayTime(self.Bonus) - LocalPlayer():GetPlayTime() or self.Bonus.InCooldown(self.Bonus, LocalPlayer()) and self.Bonus.GetRemainingCooldown(self.Bonus, LocalPlayer())
			
			if time_left then
				blocked_text = ba.str.FormatTime(time_left)
				
				btx, bty = surface.GetTextSize(blocked_text)
				
				surface.SetDrawColor(255, 255, 255, 76 + a * .7)
				surface.SetMaterial(blocked_icon)
				surface.DrawTexturedRect(w * .5 - size * .6 - 6 - btx / 2, (h - height_bottom) * .5 - size * .3, size * .6, size * .6)
				
				draw.SimpleText(blocked_text, 'rpui.Fonts.Social.BlockedText', w * .5 - btx / 2, (h - height_bottom) * .5, Color(255, 255, 255, 76 + a * .7), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
				return
			end
		end
		
		surface.SetDrawColor(255, 255, 255, 76 + a * .7)
		surface.SetMaterial(self.ContentIcon)
		surface.DrawTexturedRect(w * .5 - size * .5, (h - height_bottom) * .5 - size * .5, size, size)
	end
end

vgui.Register("rpui.SocialMenuButton", PANEL, "DButton")


local PANEL = {}
local promo_menu

local function process_click(social_id, cback)
	if social_info[social_id] then
		return
	else
		if IsValid(promo_menu) then
			promo_menu:Remove()
		end
		
		local is_promo = rp.cfg.Social[social_id].is_promo
		local h_mult = math.floor(ScrH() * 0.195) / 150
		
		menu = vgui.Create('urf.im/rpui/menus/blank')
		menu:SetSize(400 * h_mult, 180 * h_mult)
		menu:SetPos(ScrW() / 2 - 200 * h_mult, ScrH() / 2 - 90 * h_mult - 160)
		menu:MakePopup()
		promo_menu = menu
		
		menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
		menu.header.SetTitle(menu.header, translates.Get('Получить бонус'))
		menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
		menu.header.IcoSizeMult = 1.4 + 0
		
		local h_tall = menu.header.GetTall(menu.header)
		
		gui.OpenURL(rp.cfg.Social[social_id].link)
		
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

local function process_steam()
	if social_info['steam'] then return end
	
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

function PANEL:Init()
	self.Parent = self:GetParent()
    self.frameW, self.frameH = self.Parent.GetSize(self.Parent)
    self.ContentHeight = 0.065 * self.frameH
    self:Dock(FILL)
    self:RebuildFonts(self.frameW, self.frameH)
    
	self.ControlPnl = vgui.Create( "DPanel", self );
	local mw_cp = self.ControlPnl
	mw_cp:Dock( FILL );
	mw_cp:SetPaintBackground( false );
	
	
	-- Steam
	self.SteamButton = vgui.Create('rpui.SocialMenuButton', mw_cp)
	self.SteamButton.SetColors(self.SteamButton, Color(0, 0, 0, 75), Color(23, 26, 33, 255))
	self.SteamButton.SetContentIcon(self.SteamButton, steam_icon)
	self.SteamButton.SetContentText(self.SteamButton, rp.cfg.Social and rp.cfg.Social.steam.bonus_text or translates.Get('кредиты'))
	self.SteamButton.SetSocialID(self.SteamButton, 'steam')
	
	self.SteamButton.DoClick = function()
		process_steam()
	end
	
	
	-- Discord
	self.DiscordButton = vgui.Create('rpui.SocialMenuButton', mw_cp)
	self.DiscordButton.SetColors(self.DiscordButton, Color(111, 38, 170, 50), Color(111, 38, 170, 255))
	self.DiscordButton.SetContentIcon(self.DiscordButton, discord_icon)
	self.DiscordButton.SetContentText(self.DiscordButton, rp.cfg.Social and rp.cfg.Social.discord.bonus_text or translates.Get('кредиты'))
	self.DiscordButton.SetSocialID(self.DiscordButton, 'discord')
	
	self.DiscordButton.DoClick = function()
		process_click('discord')
	end
	
	
	-- VK
	if rp.cfg.Social.vk then
		self.VKButton = vgui.Create('rpui.SocialMenuButton', mw_cp)
		self.VKButton.SetColors(self.VKButton, Color(74, 118, 168, 45), Color(74, 118, 168, 255))
		self.VKButton.SetContentIcon(self.VKButton, vk_icon)
		
		if rp.cfg.Social and rp.cfg.Social.vk.bonus_text then
			self.VKButton.SetContentText(self.VKButton, isfunction(rp.cfg.Social.vk.bonus_text) and rp.cfg.Social.vk.bonus_text(LocalPlayer()) or rp.cfg.Social.vk.bonus_text)
		else
			self.VKButton.SetContentText(self.VKButton, translates.Get('кредиты'))
		end
		
		self.VKButton.SetSocialID(self.VKButton, 'vk')
		
		self.VKButton.DoClick = function()
			process_click('vk')
		end
	end
	
	
	-- Bonuses
	self.Bonuses = {}
	
	for k = 1, 3 do
		local b = vgui.Create('rpui.SocialMenuButton', mw_cp)
		b:SetColors(Color(0, 0, 0, 55), Color(255, 255, 255, 255))
		b:SetContentPercent(0.2)
		b:SetBonus(rp.abilities.list[k])
		
		self.Bonuses[k] = b
	end
	
	if not social_info then
		social_info = {}
		
		net.Start('Social::GetInfo')
		net.SendToServer()
	end
end

function PANEL:PerformLayout()
	local frameW = 0.984 * self.ControlPnl.GetWide(self.ControlPnl)
	local frameH = self.ControlPnl.GetTall(self.ControlPnl)
	
	local spacing = 0.03 * frameW
	local size_w = 0.313 * frameW
	local size_h = 0.65 * frameH
	local size_hl = frameH - spacing * 2 - size_h
	
	local has_vk = rp.cfg.Social.vk or false
	
    local steam_btn = self.SteamButton
	steam_btn:SetPos(has_vk and 0 or (size_w + spacing) / 2, spacing / 2)
	steam_btn:SetSize(size_w, size_h)
	
    local dis_btn = self.DiscordButton
	dis_btn:SetPos((has_vk and 0 or (size_w + spacing) / 2) + size_w + spacing, spacing / 2)
	dis_btn:SetSize(size_w, size_h)
	
    local vk_btn = self.VKButton
	
	if IsValid(vk_btn) then
		vk_btn:SetPos((size_w + spacing) * 2, spacing / 2)
		vk_btn:SetSize(size_w, size_h)
	end
	
	for k = 0, 2 do
		local b = self.Bonuses[k + 1]
		b:SetPos((size_w + spacing) * k, size_h + spacing * 1.5)
		b:SetSize(size_w, size_hl)
	end
end

local function rebuild_fonts(frameW, frameH)
    surface.CreateFont("rpui.Fonts.Social.Title", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.025
    })
    surface.CreateFont("rpui.Fonts.Social.ButtonText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.02
    })
    surface.CreateFont("rpui.Fonts.Social.SubButtonText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.018
    })
    surface.CreateFont("rpui.Fonts.Social.BlockedText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameW * 0.026
    })
end

function PANEL:RebuildFonts(frameW, frameH)
	rebuild_fonts(frameW, frameH)
end

local red_color = Color(250, 24, 77, 255)
local white_color = Color(255, 255, 255, 255)
local bonuses_recalculate
local bonuses_count

PANEL.CustomButtonPaint = function(this, w, h, par) 
	local baseColor, textColor = par.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
	surface.SetDrawColor( baseColor );
	surface.DrawRect( 0, 0, w, h );
	
	if not bonuses_count or bonuses_recalculate < CurTime() then
		bonuses_count = (2 + (rp.cfg.Social.vk and 1 or 0)) - table.Count(social_info or {})
		bonuses_recalculate = CurTime() + 1
		
		for k, v in pairs(rp.abilities.list) do
			if LocalPlayer().GetPlayTime and v:GetPlayTime(LocalPlayer()) < LocalPlayer():GetPlayTime() and not v:InCooldown(LocalPlayer()) then
				bonuses_count = bonuses_count + 1
			end
		end
	end
	
	if bonuses_count > 0 then
		if not this.SavedTextLength then
			surface.SetFont( 'rpui.Fonts.F4Menu.TabButton' )
			this.SavedTextLength = surface.GetTextSize( translates.Get('БОНУСЫ') ) / 2
			this.BoxSize = h / 4.5 * 1
		end
		
		draw.RoundedBox( 3, w / 2 + this.SavedTextLength + this.BoxSize * 0.65 - this.BoxSize, h / 2 - h / 4.5, this.BoxSize, this.BoxSize, red_color )
		draw.SimpleText( '' .. bonuses_count, 'rpui.Fonts.Social.SubButtonText', w / 2 + this.SavedTextLength + this.BoxSize * 0.15, h / 2 - h / 4.5 + this.BoxSize * 0.5, white_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	end
	
	draw.SimpleText( translates.Get('БОНУСЫ'), 'rpui.Fonts.F4Menu.TabButton', w/2 - ((bonuses_count > 0) and (this.BoxSize * 0.65) or 0), h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
end

vgui.Register("rpui.BonusesMenu", PANEL, "Panel")

local soc_getinfo_count = 0
net.Receive('Social::GetInfo', function()
	local size = net.ReadUInt(6)
	social_info = {}
	
	if size > 0 then
		for k = 1, size do
			social_info[net.ReadString()] = true
		end
	end
	
	if not LocalPlayer().SocialsLoaded then
		LocalPlayer().SocialsLoaded = true
		
		if not cvar.GetValue('enable_social_ints') then return end
		
		--timer.Simple(1, function()
			local show_id = ((not social_info['steam']) and 'steam') or 
							((not social_info['discord']) and 'discord') or 
							((not social_info['vk']) and rp.cfg.Social.vk and 'vk')
			
			if not show_id then return end

			rp.RegisterLoginPopup(10 + soc_getinfo_count, function()
				local h_mul = math.floor(ScrH() * 0.195) / 150
				
				rebuild_fonts(ScrW(), ScrH())
				
				local menu = vgui.Create('urf.im/rpui/menus/blank')
				menu:SetSize(175 * h_mul, 300 * h_mul)
				menu:Center()
				menu:MakePopup()
				
				menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
				menu.header.SetTitle(menu.header, translates.Get('Подписка'))
				menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
				menu.header.IcoSizeMult = 1.4 + 0
				
				timer.Simple(0, function()
					if not IsValid(menu) or not IsValid(menu.workspace) then return end
					
					local OffWeGo = vgui.Create('rpui.SocialMenuButton', menu.workspace)
					OffWeGo.SetColors(OffWeGo, show_id == 'steam' and Color(0, 0, 0, 75) or show_id == 'discord' and Color(111, 38, 170, 50) or Color(74, 118, 168, 45), show_id == 'steam' and Color(23, 26, 33, 255) or show_id == 'discord' and Color(111, 38, 170, 255) or Color(74, 118, 168, 255))
					OffWeGo.SetContentIcon(OffWeGo, show_id == 'steam' and steam_icon or show_id == 'discord' and discord_icon or vk_icon)
					
					if rp.cfg.Social and rp.cfg.Social[show_id].bonus_text then
						OffWeGo.SetContentText(OffWeGo, isfunction(rp.cfg.Social[show_id].bonus_text) and rp.cfg.Social[show_id].bonus_text(LocalPlayer()) or rp.cfg.Social[show_id].bonus_text)
					else
						OffWeGo.SetContentText(OffWeGo, translates.Get('кредиты'))
					end
					
					OffWeGo.SetSocialID(OffWeGo, show_id)
					
					OffWeGo:Dock(FILL)
					
					OffWeGo.DoClick = function()
						if show_id == 'steam' then
							process_steam()
						else
							process_click(show_id)
						end
						
						menu:Close()
					end
				end)
			end)

			soc_getinfo_count = soc_getinfo_count + 1
		--end)
	end
end)

net.Receive('Social::Promocode', function()
	social_info = social_info or {}
	social_info[net.ReadString()] = true
end)
