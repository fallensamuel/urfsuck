-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_social_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if not rp.cfg.Social then return end

cvar.Register'enable_social_ints':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить уведомление о доступных подписках при заходе')

local steam_icon = Material('bonuses/steam', "smooth", "noclamp")
local discord_icon = Material('bonuses/discord', "smooth", "noclamp")
local vk_icon = Material('bonuses/vk', "smooth", "noclamp")
local tg_icon = Material('bonuses/telegram', "smooth", "noclamp")
local tg_chan_icon = Material('bonuses/telegram_vk', "smooth noclamp")
local youtube_icon = Material('bonuses/youtube', "smooth noclamp")
local blocked_icon = Material('rpui/bonus_menu/lock', "smooth", "noclamp")
local case_icon = Material('bubble_hints/lootbox.png', "smooth", "noclamp")
local social_info = social_info or {};

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

function PANEL:SetLootbox(lb_data)
	self.ContentText = translates.Get('Ежедневный Кейс')
	self.Lootbox = lb_data
end

function PANEL:DoClick()
	if self.Lootbox then
		--if not self.Enabled then
			--return
		--end

		LocalPlayer().donateLastCatName = translates.Get('КЕЙСЫ')
		RunConsoleCommand('say', '/upgrades')
		rp.F4MenuPanel:Close()

	elseif self.Bonus then
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

	draw.SimpleText(self.SocialID and (social_info[self.SocialID] and translates.Get('Открыть')) or self.ContentText or translates.Get('бонус'), (self.Bonus or self.Lootbox) and 'rpui.Fonts.Social.SubButtonText' or 'rpui.Fonts.Social.ButtonText', w * .5, h - height_bottom * .5, (self.Bonus or self.Lootbox) and Color(textColor.r, textColor.g, textColor.b, 127 + a * .5) or Color(255, 255, 255, 127 + a * .5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if self.Lootbox then
		local lb_data = self.Lootbox
		local time_t

		self.Enabled = false

		if lb_data.cooldown_time then
			local cds = LocalPlayer():GetNetVar('LootboxCooldowns') or {}

			if cds[lb_data.NID] and tonumber(cds[lb_data.NID]) > os.time() then
				time_t = tonumber(cds[lb_data.NID]) - os.time()
			end
		end

		if lb_data.needed_time and LocalPlayer():GetTodayPlaytime() < lb_data.needed_time and (not time_t or (time_t < lb_data.needed_time - LocalPlayer():GetTodayPlaytime())) then
			time_t = lb_data.needed_time - LocalPlayer():GetTodayPlaytime()
		end

		if not time_t then
			size = 0.35 * w
			self.Enabled = true

			surface.SetDrawColor(255, 255, 255, 76 + a * .7)
			surface.SetMaterial(case_icon)
			surface.DrawTexturedRect(w * .5 - size * .5, (h - height_bottom) * .5 - size * .5, size, size)
		else
			size = 0.4 * w
			time_t = string.FormattedTime(time_t)
			blocked_text = string.format('%02i', time_t.h) .. ':' .. string.format('%02i', time_t.m) .. ':' .. string.format('%02i', time_t.s)

			surface.SetDrawColor(255, 255, 255, 76 + a * .7)
			surface.SetMaterial(blocked_icon)
			surface.DrawTexturedRect(w * .5 - size * .5, (h - height_bottom) * .5 - size * 0.5 - size * 0.25, size, size)

			if not self.WrappedText then
				self.WrappedText = string.Wrap( "rpui.Fonts.Social.SubButtonText", translates.Get("Вы сможете забрать ежедневный кейс через"), w * 0.8 );

				surface.SetFont( "rpui.Fonts.Social.SubButtonText" );
				self.TextHeight = select( 2, surface.GetTextSize(" ") );
			end

			local t_y = size * 0.25;
			for k, text in ipairs( self.WrappedText or {} ) do
				draw.SimpleText( text, "rpui.Fonts.Social.SubButtonText", w * 0.5, (h - height_bottom) * 0.5 + t_y, Color(255, 255, 255, 76 + a * .7), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
				t_y = t_y + (self.TextHeight or 0);
			end

			draw.SimpleText( blocked_text, 'rpui.Fonts.Social.BlockedText', w * 0.5, (h - height_bottom) * 0.5 + t_y, Color(255, 255, 255, 76 + a * .7), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
		end

	elseif self.ContentIcon then
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

local function process_teleg_channel()
	if IsValid(promo_menu) then
		promo_menu:Remove();
	end

	local h_mult = math.floor(ScrH() * 0.195) / 150;

	menu = vgui.Create( "urf.im/rpui/menus/blank" );
	menu:SetSize( 400 * h_mult, 180 * h_mult );
	menu:SetPos( ScrW() * 0.5 - 200 * h_mult, ScrH() * 0.5 - 90 * h_mult - 160 );
	menu:MakePopup();
	promo_menu = menu;

	menu.header:SetIcon( "bubble_hints/gift.png" );
	menu.header:SetTitle( translates.Get("Перейти к каналу") );
	menu.header:SetFont( "rpui.Fonts.Social.Title" );
	menu.header.IcoSizeMult = 1.4 + 0;

	local label = vgui.Create( "DLabel", menu );
	label:SetPos( 10 * h_mult, 50 * h_mult );
	label:SetText( ((rp.cfg.Social["teleg_channel"].bonus_info and (not social_info["teleg_channel"])) and rp.cfg.Social["teleg_channel"].bonus_info .. "\n" or "") .. translates.Get("Перейти к каналу можно по следующей ссылке:") );
	label:SetSize( 400 * h_mult, 50 * h_mult );
	label:SetContentAlignment( 4 );
	label:SetFont( "rpui.Fonts.Social.ButtonText" );

	local input = vgui.Create( "urf.im/rpui/txtinput", menu );
	input.UID = "StrRequest";
	input:SetPos( 10 * h_mult, 100 * h_mult );
	input:SetSize( 380 * h_mult, 30 * h_mult );
	input:ApplyDesign();
	input:SetEnabled( false );
	input:SetText( rp.cfg.Social["teleg_channel"].link );

	local subscribe = vgui.Create( "urf.im/rpui/button", menu );
	subscribe.SetSize( subscribe, 380 * h_mult, 30 * h_mult );
	subscribe.SetPos( subscribe, 10 * h_mult, 140 * h_mult );
	subscribe.SetText( subscribe, translates.Get("Скопировать ссылку") );
	subscribe.SetFont( subscribe, "rpui.Fonts.Social.ButtonText" ) ;
	subscribe.Think = function( self_s )
		if self_s.TextChanged and self_s.TextChanged < CurTime() then
			self_s:SetText( translates.Get("Скопировать ссылку") );
			self_s.TextChanged = nil;
		end
	end
	subscribe.DoClick = function( self_sc )
		SetClipboardText( rp.cfg.Social["teleg_channel"].link );

		self_sc.TextChanged = CurTime() + 1;
		self_sc:SetText( translates.Get("Скопировано") );
	end

	net.Start( "Social::TelegramChannel" );
	net.SendToServer();
end

local function process_youtube( id )
    if not rp.cfg.Social.youtube then return end

    local data = rp.cfg.Social.youtube[id];
    if not data then return end

    if not data.channel_id then return end

    if IsValid(promo_menu) then
		promo_menu:Remove();
	end

    local link = "https://www.youtube.com/channel/" .. data.channel_id;
	local h_mult = math.floor(ScrH() * 0.195) / 150;

	menu = vgui.Create( "urf.im/rpui/menus/blank" );
	menu:SetSize( 400 * h_mult, 180 * h_mult );
	menu:SetPos( ScrW() * 0.5 - 200 * h_mult, ScrH() * 0.5 - 90 * h_mult - 160 );
	menu:MakePopup();
	promo_menu = menu;

	menu.header:SetIcon( "bubble_hints/gift.png" );
	menu.header:SetTitle( translates.Get("Перейти к каналу") );
	menu.header:SetFont( "rpui.Fonts.Social.Title" );
	menu.header.IcoSizeMult = 1.4 + 0;

	local label = vgui.Create( "DLabel", menu );
	label:SetPos( 10 * h_mult, 50 * h_mult );
	label:SetText( ((data.bonus_info and (not social_info["yt-"..data.channel_id])) and data.bonus_info .. "\n" or "") .. translates.Get("Перейти к каналу можно по следующей ссылке:") );
	label:SetSize( 400 * h_mult, 50 * h_mult );
	label:SetContentAlignment( 4 );
	label:SetFont( "rpui.Fonts.Social.ButtonText" );

	local input = vgui.Create( "urf.im/rpui/txtinput", menu );
	input.UID = "StrRequest";
	input:SetPos( 10 * h_mult, 100 * h_mult );
	input:SetSize( 380 * h_mult, 30 * h_mult );
	input:ApplyDesign();
	input:SetEnabled( false );
	input:SetText( link );

	local subscribe = vgui.Create( "urf.im/rpui/button", menu );
	subscribe.SetSize( subscribe, 380 * h_mult, 30 * h_mult );
	subscribe.SetPos( subscribe, 10 * h_mult, 140 * h_mult );
	subscribe.SetText( subscribe, translates.Get("Скопировать ссылку") );
	subscribe.SetFont( subscribe, "rpui.Fonts.Social.ButtonText" ) ;
	subscribe.Think = function( self_s )
		if self_s.TextChanged and self_s.TextChanged < CurTime() then
			self_s:SetText( translates.Get("Скопировать ссылку") );
			self_s.TextChanged = nil;
		end
	end
	subscribe.DoClick = function( self_sc )
		SetClipboardText( link );

		self_sc.TextChanged = CurTime() + 1;
		self_sc:SetText( translates.Get("Скопировано") );
	end

	net.Start( "Social::YouTube" );
        net.WriteUInt( id, 4 );
	net.SendToServer();
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

	local pad = self.frameW * 0.01

	local bb_content = vgui.Create( "DHorizontalScroller", mw_cp );
	self.Contents = bb_content
	--bb_content:SetPos(inner_width - wh_bg2, wh_bg4 + header_tall + pad * 3)
	--bb_content:SetSize(wh_bg2, wh_bg3 * 0.8)
	--bb_content:Dock(FILL);
	bb_content:SetOverlap( -pad * 1.4 );
	bb_content.PerformLayout = function( this12 )
		local w = this12:GetWide();
		local h = this12:GetTall();

		this12.pnlCanvas.SetTall( this12.pnlCanvas, h );

		local x = 0;
		for k, v in pairs( this12.Panels ) do
			if ( !IsValid( v ) ) then continue end
			if ( !v:IsVisible() ) then continue end
			v:SetPos( x, 0 );
			v:SetTall( h );
			if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings(); end
			x = x + v:GetWide() - this12.m_iOverlap;
		end

		this12.pnlCanvas.SetWide( this12.pnlCanvas, x + this12.m_iOverlap );

		if w < this12.pnlCanvas.GetWide(this12.pnlCanvas) then
			this12.OffsetX = math.Clamp( this12.OffsetX, 0, this12.pnlCanvas.GetWide(this12.pnlCanvas) - this12:GetWide() );
		else
			this12.OffsetX = 0;
		end

		this12.pnlCanvas.x = this12.OffsetX * -1;

		local btnSize   = 0.1 * h;
		local btnOffset = 0.2 * (h - btnSize);

		this12.btnLeft.SetSize( this12.btnLeft, btnSize * 1.5, btnSize );
		this12.btnLeft.SetPos( this12.btnLeft, btnOffset, btnOffset * 2.5 );

		this12.btnRight.SetSize( this12.btnRight, btnSize * 1.5, btnSize );
		this12.btnRight.SetPos( this12.btnRight, w - this12.btnRight.GetWide(this12.btnRight) - btnOffset, btnOffset * 2.5 );

		this12.btnLeft.SetVisible( this12.btnLeft, this12.pnlCanvas.x < 0 );
		this12.btnRight.SetVisible( this12.btnRight, this12.pnlCanvas.x + this12.pnlCanvas.GetWide(this12.pnlCanvas) > this12:GetWide() );
	end

	bb_content.btnLeft.Paint = function( this11, w, h )
		local baseColor, textColor = rpui.GetPaintStyle( this11, STYLE_TRANSPARENT_INVERTED );
		surface.SetDrawColor( baseColor );
		surface.DrawRect( 0, 0, w, h );
		draw.SimpleText( "<", "rpui.Fonts.Social.CursorText", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	end

	bb_content.btnRight.Paint = function( this10, w, h )
		local baseColor, textColor = rpui.GetPaintStyle( this10, STYLE_TRANSPARENT_INVERTED );
		surface.SetDrawColor( baseColor );
		surface.DrawRect( 0, 0, w, h );
		draw.SimpleText( ">", "rpui.Fonts.Social.CursorText", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
	end

	-- Daily lootbox:
	if rp.lootbox and rp.lootbox.All then
		if not self.CachedLBAttempted then
			self.CachedLBAttempted = true

			for k, v in pairs(rp.lootbox.All) do
				if v.cooldown_time and (not v.price or v.price == 0) then
					self.CachedLB = v
					break
				end
			end
		end
	end

	if self.CachedLB then
		self.Bonus = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.Bonus:SetColors(Color(0, 0, 0, 55), Color(255, 255, 255, 255))
		-- self.Bonus:SetContentPercent(0.2)
		self.Bonus:SetLootbox(self.CachedLB)
		bb_content:AddPanel( self.Bonus )
	end

	-- Steam
	if rp.cfg.Social and rp.cfg.Social.steam then
		self.SteamButton = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.SteamButton.SetColors(self.SteamButton, Color(0, 0, 0, 75), Color(23, 26, 33, 255))
		self.SteamButton.SetContentIcon(self.SteamButton, steam_icon)
		self.SteamButton.SetContentText(self.SteamButton, rp.cfg.Social and rp.cfg.Social.steam.bonus_text or translates.Get('кредиты'))
		self.SteamButton.SetSocialID(self.SteamButton, 'steam')
		bb_content:AddPanel(self.SteamButton)

		self.SteamButton.DoClick = function()
			process_steam()
		end
	end


	-- Discord
	if rp.cfg.Social.discord then
		self.DiscordButton = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.DiscordButton.SetColors(self.DiscordButton, Color(111, 38, 170, 50), Color(111, 38, 170, 255))
		self.DiscordButton.SetContentIcon(self.DiscordButton, discord_icon)
		self.DiscordButton.SetContentText(self.DiscordButton, rp.cfg.Social and rp.cfg.Social.discord.bonus_text or translates.Get('кредиты'))
		self.DiscordButton.SetSocialID(self.DiscordButton, 'discord')
		bb_content:AddPanel(self.DiscordButton)

		self.DiscordButton.DoClick = function()
			process_click('discord')
		end
	end


	-- VK
	if rp.cfg.Social.vk then
		self.VKButton = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.VKButton.SetColors(self.VKButton, Color(74, 118, 168, 45), Color(74, 118, 168, 255))
		self.VKButton.SetContentIcon(self.VKButton, vk_icon)
		bb_content:AddPanel(self.VKButton)

		if rp.cfg.Social and rp.cfg.Social.vk.bonus_text then
			self.VKButton.SetContentText(self.VKButton, isfunction(rp.cfg.Social.vk.bonus_text) and rp.cfg.Social.vk.bonus_text(LocalPlayer()) or rp.cfg.Social.vk.bonus_text)
		else
			self.VKButton.SetContentText(self.VKButton, translates.Get('кредиты'))
		end

		self.VKButton.SetSocialID(self.VKButton, 'vk')

		self.VKButton.DoClick = function()
			process_click('vk')
		end
	elseif rp.cfg.Social.discord_main then
		self.DiscordMain = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.DiscordMain.SetColors(self.DiscordMain, Color(111, 38, 170, 50), Color(111, 38, 170, 255))
		self.DiscordMain.SetContentIcon(self.DiscordMain, discord_icon)
		bb_content:AddPanel(self.DiscordMain)

		self.DiscordMain.SetContentText(self.DiscordMain, isfunction(rp.cfg.Social.discord_main.bonus_text) and rp.cfg.Social.discord_main.bonus_text(LocalPlayer()) or rp.cfg.Social.discord_main.bonus_text)

		self.DiscordMain.SetSocialID(self.DiscordMain, 'discord_main')

		self.DiscordMain.DoClick = function()
			process_click('discord_main')
		end
	end


	-- Telegram
	if rp.cfg.Social.teleg then
		self.TGButton = vgui.Create('rpui.SocialMenuButton', bb_content)
		self.TGButton.SetColors(self.TGButton, Color(45, 164, 224, 45), Color(45, 164, 224, 255))
		self.TGButton.SetContentIcon(self.TGButton, tg_icon)
		bb_content:AddPanel(self.TGButton)

		if rp.cfg.Social and rp.cfg.Social.teleg.bonus_text then
			self.TGButton.SetContentText(self.TGButton, isfunction(rp.cfg.Social.teleg.bonus_text) and rp.cfg.Social.teleg.bonus_text(LocalPlayer()) or rp.cfg.Social.teleg.bonus_text)
		else
			self.TGButton.SetContentText(self.TGButton, translates.Get('кредиты'))
		end

		self.TGButton.SetSocialID(self.TGButton, 'teleg')

		self.TGButton.DoClick = function()
			process_click('teleg')
		end
	end

	if rp.cfg.Social.teleg_channel then
		self.TGChanButton = vgui.Create( "rpui.SocialMenuButton", bb_content );
		self.TGChanButton:SetColors( Color(255, 153, 0, 45), Color(255, 153, 0, 255) );
		self.TGChanButton:SetContentIcon( tg_chan_icon );
		bb_content:AddPanel( self.TGChanButton );

		local t = rp.cfg.Social.teleg_channel.bonus_text;
		if t then
			self.TGChanButton:SetContentText( isfunction(t) and t(LocalPlayer()) or t );
		else
			self.TGChanButton:SetContentText( "?" );
		end

		self.TGChanButton:SetSocialID( "teleg_channel" );

		self.TGChanButton.DoClick = function()
			process_teleg_channel();
		end
	end

	-- YouTube:
    if rp.cfg.Social.youtube then
        for k, data in ipairs( rp.cfg.Social.youtube ) do
            if not data.channel_id then continue end

            local YoutubeButton = vgui.Create( "rpui.SocialMenuButton", bb_content );
            bb_content:AddPanel( YoutubeButton );

            YoutubeButton:SetSocialID( "yt-" .. data.channel_id );
            YoutubeButton:SetColors( Color(255, 0, 0, 45), Color(255, 0, 0, 255) );
            YoutubeButton:SetContentIcon( youtube_icon );
            YoutubeButton:SetContentText(
                data.bonus_text
                    and (isfunction(data.bonus_text) and data.bonus_text(LocalPlayer()) or data.bonus_text)
                    or "?"
            );

            YoutubeButton.DoClick = function()
                process_youtube( k );
            end

            self["Youtube" .. k .. "Button"] = YoutubeButton;
        end
    end

	-- Bonuses
	--[[
	if not self.CachedLB then
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
	]]--

	self.Referral = vgui.Create( "rpui.ReferralPanel", mw_cp );
end

function PANEL:PerformLayout()
	local frameW = 0.984 * self.ControlPnl.GetWide(self.ControlPnl)
	local frameH = self.ControlPnl.GetTall(self.ControlPnl)

	local spacing = 0.03 * frameW
	local size_w = 0.313 * frameW
	local size_h = 0.60 * frameH
	local size_hl = frameH - spacing * 1 - size_h

	local has_vk = rp.cfg.Social.vk or rp.cfg.Social.discord_main or false

	self.Contents.SetSize(self.Contents, frameW, size_h)

    --[[
	if IsValid(self.SteamButton) then
		self.SteamButton.SetWide(self.SteamButton, size_w * 0.85)
	end

	if IsValid(self.DiscordButton) then
		self.DiscordButton.SetWide(self.DiscordButton, size_w * 0.85)
	end

    local vk_btn = self.VKButton or self.DiscordMain
	if IsValid(vk_btn) then vk_btn.SetWide(vk_btn, size_w * 0.85) end
	if IsValid(self.TGButton) then self.TGButton.SetWide(self.TGButton, size_w * 0.85) end
	if IsValid(self.TGChanButton) then self.TGChanButton.SetWide(self.TGChanButton, size_w * 0.85) end
    ]]--

    if IsValid( self.Contents ) then
        for k, child in ipairs( self.Contents:GetCanvas():GetChildren() ) do
            child:SetWide( size_w * 0.75 );
        end
    end

	if IsValid(self.Bonus) then
		self.Bonus.SetWide(self.Bonus, size_w * 0.85)
	else
		for k = 0, 2 do
			local b = self.Bonuses[k + 1]
			b:SetPos((size_w + spacing) * k, size_h + spacing * 1.5)
			b:SetSize(size_w, size_hl)
		end
	end

	if IsValid( self.Referral ) then
		self.Referral.SetPos(self.Referral, 0, size_h + spacing * 1)
		self.Referral.SetSize(self.Referral, frameW, size_hl)
	end
end

local function rebuild_fonts(frameW, frameH)
    surface.CreateFont("rpui.Fonts.Social.Title", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.025), 25)
    })
    surface.CreateFont("rpui.Fonts.Social.ButtonText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.02), 20)
    })
    surface.CreateFont("rpui.Fonts.Social.CursorText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.0225), 23)
    })
    surface.CreateFont("rpui.Fonts.Social.SubButtonText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.018), 18)
    })
    surface.CreateFont("rpui.Fonts.Social.BlockedText", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameW * 0.026), 26)
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
		bonuses_count = ((rp.cfg.Social.steam and 1 or 0) + (rp.cfg.Social.discord and 1 or 0) + (rp.cfg.Social.teleg and 1 or 0) + ((rp.cfg.Social.vk or rp.cfg.Social.discord_main) and 1 or 0)) - table.Count(social_info or {})
		bonuses_recalculate = CurTime() + 1

		if rp.lootbox and rp.lootbox.All then
			if not this.CachedLBAttempted then
				this.CachedLBAttempted = true

				for k, v in pairs(rp.lootbox.All) do
					if v.cooldown_time and (not v.price or v.price == 0) then
						this.CachedLB = v
						break
					end
				end
			end

			if this.CachedLB then
				local lb_data = this.CachedLB
				local cds = LocalPlayer():GetNetVar('LootboxCooldowns') or {}

				if not (cds[lb_data.NID] and tonumber(cds[lb_data.NID]) > os.time()) and not (lb_data.needed_time and LocalPlayer():GetTodayPlaytime() < lb_data.needed_time) then
					bonuses_count = bonuses_count + 1
				end
			end
		else
			for k, v in pairs(rp.abilities.list) do
				if LocalPlayer().GetPlayTime and v:GetPlayTime(LocalPlayer()) < LocalPlayer():GetPlayTime() and not v:InCooldown(LocalPlayer()) then
					bonuses_count = bonuses_count + 1
				end
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


local function show_popup()
	local show_id = ((not social_info['steam']) and rp.cfg.Social.steam and 'steam') or
					((not social_info['discord']) and rp.cfg.Social.discord and 'discord') or
					((not social_info['vk']) and rp.cfg.Social.vk and 'vk') or
					((not social_info['teleg']) and rp.cfg.Social.teleg and 'teleg') or
					((not social_info['teleg_channel']) and rp.cfg.Social.teleg_channel and 'teleg_channel') or
					((not social_info['discord_main']) and rp.cfg.Social.discord_main and 'discord_main')

	if not show_id or not rp.cfg.Social[show_id] then return end

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
		OffWeGo.SetColors(OffWeGo, show_id == 'steam' and Color(0, 0, 0, 75) or (show_id == 'discord' or show_id == 'discord_main') and Color(111, 38, 170, 50) or Color(74, 118, 168, 45), show_id == 'steam' and Color(23, 26, 33, 255) or (show_id == 'discord' or show_id == 'discord_main') and Color(111, 38, 170, 255) or Color(74, 118, 168, 255))
		OffWeGo.SetContentIcon(OffWeGo, show_id == 'steam' and steam_icon or (show_id == 'discord' or show_id == 'discord_main') and discord_icon or vk_icon)

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
end

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

		rp.RegisterLoginPopup(50, function()
			show_popup()

		end, function()
			return  ((not social_info['steam']) and rp.cfg.Social.steam and 'steam') or
					((not social_info['discord']) and rp.cfg.Social.discord and 'discord') or
					((not social_info['vk']) and rp.cfg.Social.vk and 'vk') or
					((not social_info['teleg']) and rp.cfg.Social.teleg and 'teleg') or
					((not social_info['discord_main']) and rp.cfg.Social.discord_main and 'discord_main')
		end)
	end
end)

net.Receive('Social::Promocode', function()
	social_info = social_info or {}
	social_info[net.ReadString()] = true
end)
