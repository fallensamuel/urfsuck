-- "gamemodes\\rp_base\\gamemode\\main\\hud_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local CurTime = CurTime
local IsValid = IsValid
local ipairs = ipairs
local pairs = pairs
local Color = Color
local DrawColorModify = DrawColorModify
local nw_GetGlobal = nw.GetGlobal
local cvar_Get = cvar.GetValue
local string_Wrap = string.Wrap
local table_Filter = table.Filter
local player_GetAll = player.GetAll
local hook_Call = hook.Call
local rp_FormatMoney = rp.FormatMoney
local math_ceil = math.ceil
local math_sin = math.sin
local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local draw_OutlinedBox = draw.OutlinedBox
local draw_Box = draw.Box
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawLine = surface.DrawLine
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_GetTextSize = surface.GetTextSize
local surface_SetFont = surface.SetFont
local surface_SetMaterial = surface.SetMaterial
local surface_DrawOutlinedRect = surface.DrawOutlinedRect -- TODO: FIX
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local color_white = rp.col.White
local color_black = rp.col.Black
local color_red = rp.col.Red
local color_orange = rp.col.Orange
local color_blue = rp.col.SUP
local color_green = rp.col.Green
local color_purple = rp.col.Purple
local translates = translates
local color_bg = rp.col.Background
local color_outline = table.Copy(rp.col.Outline)

local function mat(texture)
	return Material(texture, 'smooth')
end

local material_org = mat'sup/hud/multiple25.png'
local material_job = mat'sup/hud/office-worker2.png'
local material_health = mat'sup/hud/heart298.png'
local material_armor = mat'sup/hud/shields16.png'
local material_hunger = mat'sup/hud/burger11.png'
local material_karma = mat'sup/hud/taoism.png'
local material_money = mat'sup/hud/wallet33.png'
local material_licence = mat'sup/hud/guns4.png'
local material_lockdown = mat'sup/hud/lock24.png'
local material_mic = mat'sup/hud/speaker100.png'
local sw, sh
local LP

--cvar.Register'enable_lawshud':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение законов в худе')
--cvar.Register'enable_agendahud':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение повестки дня в худе')
--cvar.Register'disable_complicated_playertags':SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Disable complicated player nametag code (повышает FPS)')

local cvcb_notifytop = function( old, new )
	if not rp.NotifyVoteParent then return end

	local status = not (hook.Run('ShouldHideHUD') or not new);
	rp.NotifyVoteParent:SetVisible( status );
end

local cv_notifylegacy = cvar.Register('enable_notify_legacy'):SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение нотификаций (справа)');
local cv_notifytop = cvar.Register('enable_notify_top'):SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение нотификаций (сверху)'):AddCallback( cvcb_notifytop );

local name = 'hidehud_' .. game.GetMap();
cv_hidehud = cvar.Register(name):SetDefault(false):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Отключить интерфейс')

local notify_cvars = {
	["NotifyLegacy"] = cv_notifylegacy,
	["NotifyTop"] = cv_notifytop,
};

hook.Add( "HUDShouldDraw", "rp.hud.DisableNotifies", function( n )
	local cv_method = notify_cvars[n];
	if not cv_method then return end

	if not cv_method:GetValue() then
		return false;
	end
end );

local Talkers = {}

hook('InitPostEntity', 'rp.hud.FindCvar', function()
	cv_hidehud.SupressNotify = nil;
	cv_hidehud:SetValue(false)
	cv_hidehud:AddCallback(function(...) hook.Run('OnHideHUDChanged', ...) end)

	if notification and notification.AddLegacy then
		notification.__AddLegacy = notification.__AddLegacy or notification.AddLegacy
		notification.AddLegacy = function(...)
			if hook.Run('ShouldHideHUD') or (hook.Run('HUDShouldDraw', 'NotifyLegacy') == false) then return end
			return notification.__AddLegacy(...)
		end
	end

	GAMEMODE.__HUDPaint = GAMEMODE.__HUDPaint or GAMEMODE.HUDPaint;
	GAMEMODE.HUDPaint = function(...)
		if hook.Run('ShouldHideHUD') then return end
		return GAMEMODE.__HUDPaint(...)
	end

	local ba_tellall = net.Receivers['ba.tellall']
	if ba_tellall then
		net.Receive('ba.TellAll', function(...)
			if hook.Run('ShouldHideHUD') then return end
			return ba_tellall(...)
		end)
	end

	rp.NotifyVoteParent = rp.NotifyVoteParent or vgui.Create("DPanel");
	rp.NotifyVoteParent:SetPaintBackground( false );

	cvcb_notifytop( true, cv_notifytop:GetValue() );
end)

hook('OnHideHUDChanged', 'rp.hud.WatchCvar', function(old, new)
	if not cv_hidehud then return end

	if new and old ~= new then
		if cv_hidehud.SupressNotify then
			cv_hidehud.SupressNotify = nil
		else
			timer.Simple(0, function() cv_hidehud:SetValue(false) end)

			local popup = vgui.Create("rpui.ScreenPopup")
			popup:SetSize(ScrW(), ScrH())
			popup:SetTitle(translates.Get("Отключение интерфейса"))
			popup:SetDescription(translates.Get("Вы собираетесь отключить интерфейс. Это может привести к ухудшенным удобствам, процессу и удовольствию от игры на сервере.\nДанная настройка сбрасывается при каждом перезаходе на сервер."))
			popup:SetAccentColor(rpui.UIColors.BackgroundGold)
			popup.DoAccept = function() cv_hidehud.SupressNotify = true; cv_hidehud:SetValue(true); end
			popup.DoReject = function() cv_hidehud.SupressNotify = nil; end
			popup:Center()
			popup:MakePopup()
		end
	end

	local status = not new;
	if rp.NotifyVoteParent then
		if status then
			status = hook.Run("HUDShouldDraw", "NotifyTop") ~= false;
		end

		rp.NotifyVoteParent:SetVisible( status );
	end
end)

--if hook.Run('ShouldHideHUD') then return end
hook('ShouldHideHUD', 'rp.hud.ShouldHideHUD', function()
	if cv_hidehud and tobool(cv_hidehud:GetValue()) then
		return true
	end
end)

hook('PlayerStartVoice', 'rp.hud.PlayerStartVoice', function(pl)
	Talkers[pl] = true
end)

hook('PlayerEndVoice', 'rp.hud.PlayerEndVoice', function(pl)
	Talkers[pl] = nil
end)

timer.Simple(1, function()
	Material('voice/icntlk_pl'):SetFloat('$alpha', 0) -- hacky voice bubble fix
end)

-- utils
local ColValues = {}

local function varcol(name, val)
	if ColValues[name] == nil then
		ColValues[name] = {}
		ColValues[name].Old = val
		ColValues[name].Flash = SysTime()

		return color_white
	end

	if ColValues[name].Old ~= val then
		ColValues[name].Flash = SysTime() + 0.2
		ColValues[name].Old = val

		return color_blue
	end

	if ColValues[name].Flash > SysTime() then return color_blue end

	return color_white
end

local color_cache = Color(0, 0, 0, 255)

local function perccol(num)
	num = math.Clamp(num / 100, 0, 1)
	color_cache.r = 255 - (num * 200)
	color_cache.g = (num * 200)
	color_cache.b = 50

	return color_cache
end

local Days = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'}
local MinLen = 5
local HourLen = MinLen * 60
local DayLen = HourLen * 24
local WeekLen = DayLen * 7

local function Time()
	local t = CurTime()
	local WeekStart = t % WeekLen
	local DayStart = WeekStart % DayLen
	local HourStart = DayStart % HourLen
	local Day = math_ceil(WeekStart / DayLen)
	local Hour = math_ceil(DayStart / HourLen)
	local Minute = math_ceil(HourStart / MinLen)
	local PM = ' AM'

	if (Minute == 60) then
		Hour = Hour + 1
		Minute = 0
	end

	if (Hour == 24) then
		Day = Day + 1
		Hour = 0
	end

	if (Day >= 8) or (Day == 0) then
		Day = 1
	end

	if (Minute < 10) then
		Minute = '0' .. Minute
	end

	if (Hour > 11) then
		if (Hour > 12) then
			Hour = Hour - 12
		end

		PM = ' PM'
	elseif (PM == ' AM') and (Hour == 0) then
		Hour = 12
	end

	return (Days[Day] .. ' ' .. Hour .. ':' .. Minute .. PM)
end

-- Draw utils
local function DrawOutlinedText(text, font, x, y, colour, outline, align)
	local w, h = draw_SimpleTextOutlined(text, font, (align and (x - 5) or (x + 5)), y, colour, (align and TEXT_ALIGN_RIGHT or TEXT_ALIGN_LEFT), TEXT_ALIGN_CENTER, 1, outline or color_black)

	return (w + 10)
end

local function DrawCenteredText(text, font, x, y, colour, xalign)
	surface_SetFont(font)
	local w, h = surface_GetTextSize(text)
	x = x - w * 0.5
	y = y + (h * (xalign - 1))
	surface_SetTextPos(x, y)
	surface_SetTextColor(colour)
	surface_DrawText(text)

	return w, h
end -- rodo

--local function DrawCenteredTextOutlined(text, font, x, y, colour, xalign, outlinewidth, outlinecolour)
--	local steps = (outlinewidth * .75)
--
--	if (steps < 1) then
--		steps = 1
--	end
--
--	for _x = -outlinewidth, outlinewidth, steps do
--		for _y = -outlinewidth, outlinewidth, steps do
--			DrawCenteredText(text, font, x + (_x), y + (_y), outlinecolour, xalign)
--		end
--	end
--
--	return DrawCenteredText(text, font, x, y, colour, xalign)
--end

--posw, posh = DrawCenteredTextOutlined(pl:Name(), 'PlayerInfo', pos.x, pos.y, color_white, div + 1, 1, color_black)

local function DrawCenteredTextOutlined(text, font, x, y, colour, xalign, outlinewidth, outlinecolour)
	surface_SetFont( font );
	local tW, tH = surface_GetTextSize( text );

	draw_SimpleTextOutlined( text, font, x, y + tH*xalign, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, outlinewidth, outlinecolour );

	return tW, tH;
end


local function DrawLine(w, h, x, color)
	surface_SetDrawColor(color)
	surface_DrawLine(x + w, x, x + w, x + h)
end

local height = 26
local left_x = 3
local right_x = ScrW() - 3

local function drawlefticon(icon, color_icon, text, color_text)
	surface_SetFont('HudFont')
	surface_SetMaterial(icon)
	surface_SetDrawColor(color_icon)
	surface_DrawTexturedRect(left_x, 3, 20, 20)
	left_x = left_x + 24
	local w = surface_GetTextSize(text)
	surface_SetTextPos(left_x, 2)
	surface_SetTextColor(color_text)
	surface_DrawText(text)
	left_x = left_x + (w + 4)
	surface_SetDrawColor(color_outline)
	surface_DrawLine(left_x, 0, left_x, height - 1)
	left_x = left_x + 4
end

local function drawrightext(text, color)
	local w = surface_GetTextSize(text)
	right_x = right_x - (w + 4)
	surface_SetTextPos(right_x, 2)
	surface_SetTextColor(color.r, color.g, color.b, color.a)
	surface_DrawText(text)
	right_x = right_x - 5
	surface_SetDrawColor(color_outline)
	surface_DrawLine(right_x, 0, right_x, height - 1)
end

-- gm funcs
local NoDraw = {
	CHudHealth = true,
	CHudBattery = true,
	CHudSuitPower = true
}

function GM:HUDShouldDraw(name)
	if NoDraw[name] or ((name == 'CHudDamageIndicator') and (not (IsValid(LP) and LP:Alive()))) then return false end

	return true
end

function GM:HUDDrawTargetID()
	return false
end

function GM:DrawDeathNotice(x, y)
	return false
end

-- Info bar
local function InfoBar()
	left_x = 4
	right_x = sw - 4
	draw_OutlinedBox(0, 0, sw, height, color_bg, color_outline)

	if (LP:GetOrg() ~= nil) then
		drawlefticon(material_org, LP:GetOrgColor(), LP:GetOrg(), LP:GetOrgColor())
	end

	drawlefticon(material_job, LP:GetJobColor(), LP:GetJobName(), LP:GetJobColor())
	drawlefticon(material_health, perccol(LP:Health()), LP:Health() .. '%', varcol('hp', LP:Health()))

	if (LP:Armor() > 0) then
		drawlefticon(material_armor, color_blue, LP:Armor() .. '%', varcol('ar', LP:Armor()))
	end

	drawlefticon(material_hunger, perccol(LP:GetHunger()), LP:GetHunger() .. '%', varcol('h', LP:GetHunger()))
	drawlefticon(material_karma, perccol(LP:GetKarma()), LP:GetKarma(), varcol('k', LP:GetKarma()))
	drawlefticon(material_money, color_green, rp_FormatMoney(LP:GetMoney()) .. '+' .. LP:GetSalary() .. '/hr', varcol('m', LP:GetMoney()))

	if LP:HasLicense() then
		drawlefticon(material_licence, color_green, 'Licensed', color_white)
	end

	surface_SetFont('HudFont')
	surface_SetDrawColor(color_outline)
	local alpha = (math_sin(CurTime()) + 1) / 0.5 * 255
	local w = surface_GetTextSize('SuperiorServers.co')
	right_x = right_x - w
	surface_SetTextPos(right_x, 2)
	surface_SetTextColor(color_blue.r, color_blue.g, color_blue.b, alpha)
	surface_DrawText('Sup')
	surface_SetTextPos(right_x, 2)
	surface_SetTextColor(color_white.r, color_white.g, color_white.b, 255 - alpha)
	surface_DrawText('Sup')
	surface_SetTextColor(color_white.r, color_white.g, color_white.b, color_white.a)
	surface_DrawText('eriorServers.co')
	right_x = right_x - 4
	surface_DrawLine(right_x, 0, right_x, height)
	drawrightext(Time(), varcol('Time', LP:GetKarma()))

	if (IsValid(LP:GetNetVar('Employer'))) then
		drawrightext('Employer: ' .. LP:GetNetVar('Employer'):Name(), LP:GetNetVar('Employer'):GetJobColor())
	end

	if (IsValid(LP:GetNetVar('Employee'))) then
		drawrightext('Employee: ' .. LP:GetNetVar('Employee'):Name(), LP:GetNetVar('Employee'):GetJobColor())
	end

	if (LP:GetDisguiseTime() >= 1) then
		drawrightext('Disguise: ' .. LP:GetDisguiseTime(), color_purple)
	end

	if nw_GetGlobal('mayorGrace') and (nw_GetGlobal('mayorGrace') > CurTime()) then
		drawrightext('Mayor Grace: ' .. math_ceil(nw_GetGlobal('mayorGrace') - CurTime()), color_orange)
	end

	if (LP:GetNLRTime()) then
		drawrightext('NLR: ' .. LP:GetNLRTime(), color_red)

		if LP:InNLRZone() then
			draw_SimpleText('You are in an NLR zone. Please leave!', 'NLRFont', sw * .5, sh * .25, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end

local ban_txt = translates.Get('Вы забанены, ознакомиться с правилами можно нажав F1')
local bantime_txt = translates.Get('Время до разбана:')

rp.BannedHUD = function()
	right_x = sw - 4
	draw_OutlinedBox(0, 0, sw, height, color_bg, color_outline)
	surface_SetFont('HudFont')
	surface_SetDrawColor(color_outline)
	drawrightext(ban_txt, color_white)
	draw_SimpleText(bantime_txt .. ' ' .. LP:UnbanTime() or '?', 'HudFont', 5, 2, color_white)
end

-- Agenda
local saved1, text1
local no_agenda_txt = translates.Get("Повестка дня отсутствует!")
function rp.DrawAgenda(h)
	if (rp.agendas[LP:Team()] ~= nil) then
		local w = (sw * .175)
		local x = 2.5
		h = h or 0

		if (nw_GetGlobal('Agenda;' .. LP:Team()) or no_agenda_txt) ~= saved1 then
			saved1 		= nw_GetGlobal('Agenda;' .. LP:Team()) or no_agenda_txt
			text1		= string_Wrap('HudFont', saved1, w - 6)
		end

		--if not text1 then return end

		draw_OutlinedBox(0, h+5, w, (#text1 * 18) + 10, color_bg, color_outline)

		for k, v in ipairs(text1) do
			draw_SimpleText(v, 'HudFont', x, h + (k * 18), varcol('Agenda', nw_GetGlobal('Agenda' .. LP:Team())), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

-- Laws
local saved2, text2
function rp.DrawLaws()
	local w = (sw * .175)
	local x = 2.5

	if (nw_GetGlobal('TheLaws') or rp.cfg.DefaultLaws) ~= saved2 then
		saved2 		= nw_GetGlobal('TheLaws') or rp.cfg.DefaultLaws
		text2 		= string_Wrap('HudFont', saved2, w - 6)
	end

	if not text2 then return 25 end

	draw_OutlinedBox(x, 25, w, (#text2 * 18) + 5, color_bg, color_outline)

	for k, v in ipairs(text2) do
		draw_SimpleText(v, 'HudFont', x + 2.5, 17 + (k * 18), varcol('TheLaws', nw_GetGlobal('TheLaws')), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	return 25 + (#text2 * 18) + 5
end

-- Hits
local hitsOffset = rp.cfg.HudHitsOffset or 0
local no_hits_txt = translates.Get('Нет заказов!')

function rp.DrawHits()
	if LocalPlayer():IsHitman() then
		local w = (sw * .175)
		local x = 2.5
		local hits = table_Filter(player_GetAll(), function(pl) return pl:HasHit() and (pl ~= LP) end)

		if (#hits >= 1) then
			draw_OutlinedBox(0, 25 + hitsOffset, w, (#hits * 18) + 5, color_bg, color_outline)
			local c = 1

			for k, v in ipairs(hits) do
				if IsValid(v) then
					draw_SimpleText(v:Name(), 'HudFont', x, 17 + hitsOffset + (c * 18), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					local cost = rp_FormatMoney(v:GetHitPrice())
					draw_SimpleText(cost, 'HudFont', (w - 5 - surface_GetTextSize(cost)), 17 + hitsOffset + (c * 18), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					c = c + 1
				end
			end
		else
			draw_OutlinedBox(0, 25 + hitsOffset, w, (#hits * 18) + 23, color_bg, color_outline)
			draw_SimpleText(no_hits_txt, 'HudFont', x, 35 + hitsOffset, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
end

-- Lockdown
local function LockDown()
	if nw_GetGlobal('lockdown') then

		color_outline = CurTime() % 2 < 1 and rp.cfg.Lockdowns[nw_GetGlobal('lockdown')].color or color_white
		surface_SetFont('HudFont')
		local w = surface_GetTextSize(rp.cfg.Lockdowns[nw_GetGlobal('lockdown')].desc) + (24 * 2) + 10
		local x, y = sw * .5 - w * .5, (height - 1)
		draw_OutlinedBox(x, y, w, height, color_bg, color_outline)
		surface_SetMaterial(material_lockdown)
		surface_SetDrawColor(color_outline)
		surface_DrawTexturedRect(x + 3, y + 3, 20, 20)
		surface_SetMaterial(material_lockdown)
		surface_SetDrawColor(color_outline)
		surface_DrawTexturedRect(x + (w - 23), y + 3, 20, 20)
		draw_SimpleText(rp.cfg.Lockdowns[nw_GetGlobal('lockdown')].desc, 'HudFont', sw * .5, y + 2, color_outline, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		return
	end

	color_outline = Color(rp.col.Outline.r, rp.col.Outline.g, rp.col.Outline.b, rp.col.Outline.a)
end

-- Arrested
local function Arrested()
	if LP:IsArrested() then
		local info = LP:GetNetVar('ArrestedInfo')
		draw_SimpleTextOutlined('You\'re arrested for: ' .. info.Reason, 'HudFont2', sw / 2, sh - 50, color_white, 1, 1, 1, color_black)
		draw_SimpleTextOutlined('Time left: ' .. math_ceil(info.Release - CurTime()) .. ' seconds.', 'HudFont2', sw / 2, sh - 20, color_white, 1, 1, 1, color_black)
	elseif LP:IsWanted() then
		draw_SimpleTextOutlined('You\'re wanted for: ' .. LP:GetWantedReason(), 'HudFont2', sw / 2, sh - 20, color_white, 1, 1, 1, color_black)
	end
end

-- Playerinfo
local vec13 = Vector(0, 0, 13)
local vec10 = Vector(0, 0, 10)

local function getHeadPos(pl)
	local Bone = pl:LookupBone('ValveBiped.Bip01_Head1')
	if not Bone then return false end
	local BonePos, _ = pl:GetBonePosition(Bone)
	if not BonePos then return false end
	return BonePos + vec13
end

local emoji
local function get_player_nick_emoji(ply)
	emoji = ply:GetNickEmoji()
	emoji = CHATBOX and CHATBOX.Emoticons and CHATBOX.Emoticons[emoji]

	if emoji then
		if (not ply.LoadedEmojiMaterial or ply.SavedEmoji != emoji.id) and not ply.LoadingEmoji then
			if (emoji.url) then
				local mat = CHATBOX.GetDownloadedImage(emoji.url)
				if mat then
					ply.LoadedEmojiMaterial = mat
				else
					ply.LoadingEmoji = true

					CHATBOX.DownloadImage(
						emoji.url,
						function(mat)
							if IsValid(ply) then
								ply.LoadedEmojiMaterial = mat
								ply.LoadingEmoji = nil
							end
						end
					)
				end
			else
				ply.LoadedEmojiMaterial = Material(emoji.path)
			end
		end

		if ply.LoadedEmojiMaterial then
			ply.SavedEmoji = emoji.id
		end
	end
end

local div, stars
local rept = string.rep
local posw, posh, posw2, posh2, posw3, posh3, posw4, posh4 = 0, 0, 0, 0, 0, 0, 0, 0;

local draw_TextTexture = draw.TextTexture

--[[
local function DrawPlayerInfo(pl, pos)
	pos.y = pos.y - 10
	div = 0

	pos.y = pos.y - 10;

	if LP:GetTeamTable().medic or (LP:Team() == TEAM_ADMIN) then
		draw_SimpleTextOutlined( pl:Health() .. ' HP', 'PlayerInfo', pos.x, pos.y, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	elseif LP:IsHitman() and pl:HasHit() then
		DrawCenteredTextOutlined( 'HIT ' .. rp_FormatMoney(pl:GetHitPrice()), 'PlayerInfo', pos.x, pos.y, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	end

	get_player_nick_emoji( pl );

	if pl:GetJobTable().reversed or (pl:IsDisguised() and pl:GetDisguiseJobTable().reversed) then
		posw, posh = renderTextFunc( pl:GetJobName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		posw2, posh2 = draw_SimpleTextOutlined( pl:GetName(), 'PlayerInfo', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y - posh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
	else
		if pl:GetJobTable().reversed || (pl:IsDisguised() && pl:GetDisguiseJobTable().reversed) then
			if cvar_Get('text_texture_render') then
				posw, posh = draw_TextTexture(pl:GetJobName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			else
				posw, posh = draw_SimpleTextOutlined(pl:GetJobName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			end

			posw2, posh2 = DrawCenteredTextOutlined(pl:Name(), 'PlayerInfo', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y, color_white, div + 1, 1, color_black)

			if pl.LoadedEmojiMaterial then
				surface_SetDrawColor(color_white)
				surface_SetMaterial(pl.LoadedEmojiMaterial)
				surface_DrawTexturedRect(pos.x - (posw * .5) - 12, pos.y - 4, 24, 24)
				posw = posw + 24
			end
		else
			posw2, posh2 = DrawCenteredTextOutlined(pl:Name(), 'PlayerInfoBig', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y, pl:GetJobColor(), div + 1, 1, color_black)

			if cvar_Get('text_texture_render') then
				posw, posh = draw_TextTexture(pl:GetJobName(), 'PlayerInfo', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			else
				posw, posh = draw_SimpleTextOutlined(pl:GetJobName(), 'PlayerInfo', pos.x, pos.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			end

			if pl.LoadedEmojiMaterial then
				surface_SetDrawColor(color_white)
				surface_SetMaterial(pl.LoadedEmojiMaterial)
				surface_DrawTexturedRect(pos.x - (posw2 * .5) - 20, pos.y - 37, 32, 32)
			end
		end

		local org = pl:GetOrg()
		if org then
			if cvar_Get('text_texture_render') then
				draw_TextTexture(org, 'PlayerInfo', pos.x, pos.y - posh, pl:GetOrgColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black, 2592000)
			else
				draw_SimpleTextOutlined(org, 'PlayerInfo', pos.x, pos.y - posh, pl:GetOrgColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
			end
		end

		if Talkers[pl] then
			surface_SetMaterial(material_mic)
			surface_SetDrawColor(color_orange)
			surface_DrawTexturedRect(pos.x - posw2 * 0.5 - 22 - 10, pos.y + posh2 * 0.5 - 11, 22, 22)
		end

		if pl:HasLicense() then
			surface_SetMaterial(material_licence)
			surface_SetDrawColor(color_green)
			surface_DrawTexturedRect(pos.x + posw2 * 0.5 + 10, pos.y + posh2 * 0.5 - 8, 16, 16)
		end
	end

	hook.Run( "PlayerInfoAdditionalHUD", pl, pos );
end
]]--

local function DrawPlayerInfo( pl, pos )
	local renderTextFunc = cvar_Get('text_texture_render') and draw_TextTexture or draw_SimpleTextOutlined;

	pos.y = pos.y - 10;

	if LP:GetTeamTable().medic or (LP:Team() == TEAM_ADMIN) then
		draw_SimpleTextOutlined( pl:Health() .. ' HP', 'PlayerInfo', pos.x, pos.y, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	elseif LP:IsHitman() and pl:HasHit() then
		draw_SimpleTextOutlined( rp_FormatMoney(pl:GetHitPrice()), 'PlayerInfo', pos.x, pos.y, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black );
	end

	get_player_nick_emoji( pl );

	if pl:GetJobTable().reversed or (pl:IsDisguised() and pl:GetDisguiseJobTable().reversed) then
		posw, posh = renderTextFunc( pl:GetJobName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );

		if (not posw) or (not posh) then
			posw, posh = draw_SimpleTextOutlined( pl:GetJobName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		end

		posw2, posh2 = draw_SimpleTextOutlined( pl:GetName(), 'PlayerInfo', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y - posh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
	else
		posw, posh = draw_SimpleTextOutlined( pl:GetName(), 'PlayerInfoBig', pos.x, pos.y, pl:GetJobColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		posw2, posh2 = renderTextFunc( pl:GetJobName(), 'PlayerInfo', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y - posh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );

		if (not posw2) or (not posh2) then
			posw2, posh2 = draw_SimpleTextOutlined( pl:GetJobName(), 'PlayerInfo', pos.x + (pl.LoadedEmojiMaterial and 16 or 0), pos.y - posh, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		end
	end

	local offx, offy = pos.x - posw2 * 0.5, pos.y - posh - posh2 * 0.5;
	if pl.LoadedEmojiMaterial then
		offx = offx - 16;
		surface_SetDrawColor( color_white );
		surface_SetMaterial( pl.LoadedEmojiMaterial );
		surface_DrawTexturedRect( offx, offy - 12, 24, 24 );
	end

	if Talkers[pl] then
		surface_SetMaterial( material_mic );
		surface_SetDrawColor( color_orange );
		surface_DrawTexturedRect( offx - 22 - 8, offy - 11, 22, 22 );
	end

	if pl:HasLicense() then
		surface_SetMaterial( material_licence );
		surface_SetDrawColor( color_green );
		surface_DrawTexturedRect( offx + posw2 + 8 + (pl.LoadedEmojiMaterial and 32 or 0), offy - 8, 16, 16 );
	end

	posw3, posh3 = 0, 0;
	local org = pl:GetOrg();
	if org then
		posw3, posh3 = renderTextFunc( org, 'PlayerInfo', pos.x, pos.y - posh - posh2 - 4, pl:GetOrgColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black, 2592000 );

		if (not posw3) or (not posh3) then
			posw3, posh3 = draw_SimpleTextOutlined( org, 'PlayerInfo', pos.x, pos.y - posh - posh2 - 4, pl:GetOrgColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		end
	end

	if pl:IsWanted() then
		if pl.GetWantedStars then
			stars = pl:GetWantedStars() >= 5 and '' or (' ' .. rept('☆', 5 - pl:GetWantedStars(), ' '));
			posw4, posh4 = draw_SimpleTextOutlined( rept('★', pl:GetWantedStars(), ' ') .. stars, 'PlayerInfo', pos.x, pos.y - posh - posh2 - (posh3 or 0) - 4, CurTime() % 2 < 1 and color_red or color_blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );

			if rp.cfg.ShowWantedReason then
				renderTextFunc( pl:GetWantedReason(), 'PlayerInfo', pos.x, pos.y - posh - posh2 - (posh3 or 0) - posh4 - 4, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
			end
		else
			renderTextFunc( pl:GetWantedReason(), 'PlayerInfo', pos.x, pos.y - posh - posh2 - (posh3 or 0) - 4, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black );
		end
	end

	hook.Run( "PlayerInfoAdditionalHUD", pl, pos );
end

local function BoxIntersects(l1, r1, t1, b1, l2, r2, t2, b2)
	return 	l1 < r2 and
			l2 < r1 and
			t1 < b2 and
			t2 < b1
end

local aabb = {left = -48, right = 48, top = -24, bottom = 24}
local broke
local bl, br, bt, bb
local l, r, t, b
local function RebuildPositions(boxes)
	for k, pos1 in pairs(boxes) do
		bl, br, bt, bb = pos1.x + aabb.left, pos1.x + aabb.right, pos1.y + aabb.top, pos1.y + aabb.bottom

		if broke then
			broke = nil
			RebuildPositions(boxes)
			break
		end

		for kk, pos2 in pairs(boxes) do
			if k == kk then continue end
			l, r, t, b = pos2.x + aabb.left, pos2.x + aabb.right, pos2.y + aabb.top, pos2.y + aabb.bottom

			if BoxIntersects(bl, br, bt, bb, l, r, t, b) then
				broke = true

				if k.FarDistance > kk.FarDistance then
					boxes[k] = nil
					break

				else
					boxes[kk] = nil
					break
				end
			end
		end
	end
end

local PlayerVisibilityAlpha = {};
local aimed_pl, lppos, pa, pb, insight

local plys = {}

local playeraabb_cache = {};
local playervis_cache  = {};

timer.Create("HUD::SortPlayersAround", 0.5, 0, function()
	if not IsValid(LP) then return end

	lppos = LP:GetPos();
	plys = player.GetAll();
	playervis_cache  = {};

	table.sort( plys, function( a, b )
		pa = a:GetPos():DistToSqr( lppos );
		pb = b:GetPos():DistToSqr( lppos );

		a.FarDistance = pa
		b.FarDistance = pb

		return pa < pb
	end );

	i = 0;

	for _, pl in pairs(plys) do
		if i > 5 		   then break end
		if pl.ShouldNoDraw then continue end

		if not IsValid(pl)
			or pl == LP
			or not pl:Alive()
			or hook_Call( "HUDShouldDraw", GAMEMODE, "PlayerDisplay", pl ) == false
		then
			continue
		end

		insight = not pl:IsDormant() and pl:InSight() and pl:InTrace() and (ba and ba["ToggleShowInvisible"] or not pl:GetNoDraw())
		pl.IsCurrentlyVisible = insight;

		if insight then
			playervis_cache[pl]       = true;
			PlayerVisibilityAlpha[pl] = 1;

			i = i + 1;
		end
	end
end)

timer.Create("HUD::AlphaPlayersAround", 0.065, 0, function()
	for pl, v in pairs( PlayerVisibilityAlpha ) do
		if not IsValid(pl) then
			PlayerVisibilityAlpha[pl] = nil;
			continue
		end

		PlayerVisibilityAlpha[pl] = math.Approach( v, playervis_cache[pl] and 1 or 0, 0.1 );
	end
end)

local i, pos
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier

function rp.DrawPlayerDisplay()
	i = 0

	aimed_pl = LocalPlayer():GetEyeTrace().Entity
	aimed_pl = IsValid(aimed_pl) and aimed_pl:IsPlayer() and aimed_pl

	playeraabb_cache = {};

	for _, pl in pairs( plys ) do
		if not IsValid(pl) then continue end

		if PlayerVisibilityAlpha[pl] and PlayerVisibilityAlpha[pl] > 0 then
			playeraabb_cache[pl] = (getHeadPos(pl) or pl:EyePos()):ToScreen();

		else
			PlayerVisibilityAlpha[pl] = nil;
			continue
		end
	end

	RebuildPositions( playeraabb_cache );

	for _, pl in pairs( plys ) do
		if IsValid(pl) and (i <= 5 or pl == aimed_pl) then
			pos = playeraabb_cache[pl]

			if pos then
				surface_SetAlphaMultiplier( PlayerVisibilityAlpha[pl] or 0 );
					DrawPlayerInfo( pl, pos );
				surface_SetAlphaMultiplier( 1 );

				i = i + 1
			end
		end
	end
end

local function EntityDisplay()
	local ent = LP:GetEyeTrace().Entity

	if IsValid(ent) and (ent.TraceInfo ~= nil) and (LP:GetPos():Distance(ent:GetPos()) < 115) then
		draw_SimpleTextOutlined(ent.TraceInfo, 'HudFont2', sw / 2, sh / 2 + 50, color_white, 1, 1, 1, color_black)
	elseif IsValid(ent) and ent:IsPlayer() and ent:IsHirable() and not LP:IsHirable() and (LP:GetPos():Distance(ent:GetPos()) < 115) then
		draw_SimpleTextOutlined(translates.Get("Напишите /hire чтобы нанять %s за %s", ent:Name(), rp_FormatMoney(ent:GetHirePrice())), 'HudFont2', sw / 2, sh / 2 + 50, color_red, 1, 1, 1, color_black)
	elseif ent:IsVehicle() then

	end
end

local respawnTime = false
local time = 0

local you_died_txt = translates.Get('Вы умерли')
local revieve_txt = translates.Get('Нажми любую клавишу, чтобы возродиться')

local function DeathScreen()
	local h = sh * 0.085
	draw_Box(0, 0, sw, h, color_black)
	draw_Box(0, sh - h, sw, h, color_black)
	draw_SimpleTextOutlined(you_died_txt, 'HudFont2', sw * 0.5, h * 0.5, color_white, 1, 1, 1, color_black)

	if isSerious then
		if !respawnTime then
			respawnTime = SysTime() + rp.cfg.RespawnTime
		end
		time = math.ceil(respawnTime - SysTime())
		if time < -10 then
			draw_SimpleTextOutlined(revieve_txt, 'HudFont2', sw * 0.5, sh - h * 0.5, color_white, 1, 1, 1, color_black)
		elseif time <= 0 then
			draw_SimpleTextOutlined('Вы возродитесь в любой момент', 'HudFont2', sw * 0.5, sh - h * 0.5, color_white, 1, 1, 1, color_black)
		else
			draw_SimpleTextOutlined('Вы возродитесь через ' .. time.. ' секунд', 'HudFont2', sw * 0.5, sh - h * 0.5, color_white, 1, 1, 1, color_black)
		end
	else
		draw_SimpleTextOutlined(revieve_txt, 'HudFont2', sw * 0.5, sh - h * 0.5, color_white, 1, 1, 1, color_black)
	end
end

local lawsOffset = 25


local showLaws = false --(rp.cfg.HudShowLaws == nil) or rp.cfg.HudShowLaws
local showAgenda = (rp.cfg.HudShowAgenda == nil) or rp.cfg.HudShowAgenda
local showLockdown = (rp.cfg.HudShowLockdown == nil) or rp.cfg.HudShowLockdown

local DrawAgenda, DrawHits, DrawPlayerDisplay

function GM:HUDPaint()
	sw, sh = ScrW(), ScrH()
	LP = LocalPlayer()
	if not IsValid(LP) then return end

	if (not LP:Alive()) then
		DeathScreen()
	elseif LP:IsBanned() then
		if rp.BannedHUD then
			rp.BannedHUD();
		end

		respawnTime = nil
	else
		respawnTime = nil
		EntityDisplay()

		if not DrawPlayerDisplay then
			DrawPlayerDisplay = rp.DrawPlayerDisplay
		end

		DrawPlayerDisplay()

		if showLaws and cvar_Get('enable_lawshud') && !isWhiteForest then
			lawsOffset = rp.DrawLaws()
		end

		if showAgenda and cvar_Get('enable_agendahud') then
			if not DrawAgenda then
				DrawAgenda = rp.DrawAgenda
			end

			rp.DrawAgenda(lawsOffset or 25)
		end

		if not DrawHits then
			DrawHits = rp.DrawHits
		end

		rp.DrawHits(lawsOffset or 0)

		if showLockdown then
			LockDown()
		end

	//	Arrested()
	//	InfoBar()
	end
end

local modify = {
	['$pp_colour_addr'] = 0,
	['$pp_colour_addg'] = 0,
	['$pp_colour_addb'] = 0,
	['$pp_colour_brightness'] = 0,
	['$pp_colour_contrast'] = 1,
	['$pp_colour_colour'] = 0,
	['$pp_colour_mulr'] = 0.05,
	['$pp_colour_mulg'] = 0.05,
	['$pp_colour_mulb'] = 0.05
}

function GM:RenderScreenspaceEffects()
	if (LocalPlayer():Health() <= 15) then
		DrawColorModify(modify)
	end
end
