-- "gamemodes\\rp_base\\gamemode\\main\\player\\seasonpass\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local function redo_fonts()
	local frameH = ScrH()
	
    surface.CreateFont("rpui.Fonts.Seasonpass.Notify", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.027),
    })
end

local function show_custom_notify(line1, line2)
	local season = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()
	if not season then return end
	
	redo_fonts()
	
	local notify_pnl = rp.NotifyVoteClient("", "hire", 15)
	
	notify_pnl.SetTall(notify_pnl, 5)
	notify_pnl._pTall = 5
	notify_pnl.Paint = function(np, np_w, np_h) 
		surface.SetDrawColor(season.PremiumHeadBackColor or Color(255, 255, 255, 255))
		surface.DrawRect(0, 0, np_w, np_h)
	end
	
	notify_pnl.InvalidateParent(notify_pnl)
	
	if not IsValid(notify_pnl.popup) then return end
	
	notify_pnl.popup.Paint = function(npp, npp_w, npp_h) 
		draw.Blur(npp)

		draw.SimpleText(line1, "rpui.Fonts.Seasonpass.Notify", npp_w * 0.5, npp_h * 0.2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(line2, "rpui.Fonts.Seasonpass.Notify", npp_w * 0.5, npp_h * 0.36, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		surface.SetDrawColor(Color(0, 0, 0, 77))
		surface.DrawRect(0, 0, npp_w, npp_h)
	end
	
	notify_pnl.btn.SetVisible(notify_pnl.btn, false)
	notify_pnl.popup.cancel.Remove(notify_pnl.popup.cancel)
	
	local dop_color = season.PremiumHeadBackColor and Color(season.PremiumHeadBackColor.r * 0.7, season.PremiumHeadBackColor.g * 0.7, season.PremiumHeadBackColor.b * 0.7, 255) or Color(255, 255, 255, 255)
	
	notify_pnl.popup.ok.Dock(notify_pnl.popup.ok, BOTTOM)
	notify_pnl.popup.ok.DockMargin(notify_pnl.popup.ok, notify_pnl.GetWide(notify_pnl) * 0.1, 0, notify_pnl.GetWide(notify_pnl) * 0.1, notify_pnl.GetTall(notify_pnl) * 26 * 0.13)
	notify_pnl.popup.ok.SetText(notify_pnl.popup.ok, "")
	notify_pnl.popup.ok.Paint = function(npo, npo_w, npo_h)
		npo.rotAngle = (npo.rotAngle or 0) + 100 * FrameTime()
		local baseColor, textColor = rpui.GetPaintStyle(npo, STYLE_GOLDEN)
		surface.SetDrawColor(Color(0, 0, 0, npo:IsHovered() and 255 or 146))
		surface.DrawRect(0, 0, npo_w, npo_h)
		
		local distsize  = math.sqrt(npo_w * npo_w + npo_h * npo_h)
		local parentalpha = npo.GetParent(npo).GetParent(npo.GetParent(npo)).GetAlpha(npo.GetParent(npo).GetParent(npo.GetParent(npo))) / 255
		local alphamult   = npo._alpha / 255     

		surface.SetAlphaMultiplier(parentalpha * alphamult)
			surface.SetDrawColor(dop_color)
			surface.DrawRect(0, 0, npo_w, npo_h)
			
			surface.SetMaterial(rpui.GradientMat)
			surface.SetDrawColor(season.PremiumHeadBackColor)
			surface.DrawTexturedRectRotated(npo_w * 0.5, npo_h * 0.5, distsize, distsize, (npo.rotAngle or 0))
		surface.SetAlphaMultiplier(1)
		
		draw.SimpleText(translates.Get("К НАГРАДАМ!"), "rpui.Fonts.Seasonpass.Notify" or npo:GetFont(), npo_w * 0.5, npo_h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	notify_pnl.popup.ok.PaintOver = function(npop, npop_w, npop_h)
		rpui.DrawStencilBorder(npop, 0, 0, npop_w, npop_h, 0.04, dop_color, season.PremiumHeadBackColor, 1)
	end
	notify_pnl.popup.ok._DoClick = notify_pnl.popup.ok._DoClick or notify_pnl.popup.ok.DoClick
	notify_pnl.popup.ok.DoClick = function()
		rp.SeasonpassTest = vgui.Create('rpui.Seasonpass')
			rp.SeasonpassTest.SetSize(rp.SeasonpassTest, ScrW() * 0.75, ScrH() * 0.75)
			rp.SeasonpassTest.Center(rp.SeasonpassTest)
			rp.SeasonpassTest.MakePopup(rp.SeasonpassTest)
		
		notify_pnl.popup.ok._DoClick(notify_pnl.popup.ok._DoClick)
	end
	
	timer.Simple(0, function()
		local a = notify_pnl:GetWide()
		local b = notify_pnl:GetTall() * 25
		local c = 0.15
		
		notify_pnl:OnPopupSizeTo(a, b, c)
		notify_pnl.popup.SizeTo(notify_pnl.popup, a, b, c, 0, -1, function()
			notify_pnl:OnPopupSizeToEnd(a, b, c)
		end)
	end)
end

local listen_for_types = {
	['team_played_10_sec'] = true,
	['faction_played_10_sec'] = true,
}

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "Seasonpass::StartFakeTimer", function(data) 
	local season = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()
	if not season or not LocalPlayer():GetNetVar('SeasonpassLevel') then return end
	
	if IsValid(LocalPlayer()) and data.userid == LocalPlayer():UserID() then
		for k, v in pairs(LocalPlayer():SeasonGetQuests() or {}) do
			if not rp.seasonpass.Quests[v] then continue end
			
			local quest_type = rp.seasonpass.QuestsTypesMap[rp.seasonpass.Quests[v].Type or '']
			if not quest_type or not quest_type.ListenCLPlayerSpawn then continue end
			
			rp.seasonpass.QuestUpdateStamps[k] = CurTime()
		end
	end
end)


net.Receive('Seasonpass::ResetQuests', function()
	rp.seasonpass.PlayerQuests[LocalPlayer():SteamID()] = nil
	rp.seasonpass.PlayerQuestsMap[LocalPlayer():SteamID()] = nil
	
	rp.seasonpass.QuestUpdateProgress = {}
	rp.seasonpass.QuestUpdateStamps = {}
	
	if IsValid(rp.seasonpass.HudPanel) then
		rp.seasonpass.HudPanel.Remove(rp.seasonpass.HudPanel)
	end
end)

net.Receive('Seasonpass::BuyLevels', function()
	local is_robo = net.ReadBool()
	
	if is_robo then
		gui.OpenURL("https://shop.urf.im/donations/robokassa/index2.php?id=" .. net.ReadUInt(32))
	
	else
		gui.OpenURL("https://shop.urf.im/seasonpass/levels.php?steamid=" .. LocalPlayer():SteamID64() .. "&mode=" .. net.ReadUInt(32))
	end
end)

net.Receive('Seasonpass::GotPass', function()
	if IsValid(rp.seasonpass.Menu) then
		rp.seasonpass.Menu.OpenThanksMenu(rp.seasonpass.Menu)
	
	else
		show_custom_notify(translates.Get("Глобальный RP ПРОПУСК"), translates.Get("получен!"))
	end
end)

net.Receive('Seasonpass::ResetSeasonpass', function()
	rp.seasonpass.PlayerQuests[LocalPlayer():SteamID()] = nil
	rp.seasonpass.PlayerQuestsMap[LocalPlayer():SteamID()] = nil
	
	rp.seasonpass.QuestUpdateProgress = {}
	rp.seasonpass.QuestUpdateStamps = {}
	
	if IsValid(rp.seasonpass.HudPanel) then
		rp.seasonpass.HudPanel.Remove(rp.seasonpass.HudPanel)
	end
	
	if IsValid(rp.seasonpass.Menu) then
		rp.seasonpass.Menu.Close(rp.seasonpass.Menu)
	end
end)

net.Receive('Seasonpass::GotLevel', function()
	show_custom_notify(translates.Get("Новый уровнь"), translates.Get("SEASON PASS получен"))
	
	timer.Simple(0.5, function()
		if IsValid(rp.seasonpass.Menu) then
			rp.seasonpass.Menu.Remove(rp.seasonpass.Menu)
			
			local SeasonpassMenu = vgui.Create("rpui.Seasonpass")
			SeasonpassMenu.SetSize(SeasonpassMenu, ScrW() * 0.75, ScrH() * 0.75)
			SeasonpassMenu.Center(SeasonpassMenu)
			SeasonpassMenu.MakePopup(SeasonpassMenu)
		end
	end)
end)

net.Receive('Seasonpass::DoneQuest', function()
	show_custom_notify(translates.Get("Задание SEASON PASS выполнено!"), translates.Get("Вы получили %s опыта", net.ReadUInt(16)))
	
	if IsValid(rp.seasonpass.HudPanel) then
		rp.seasonpass.HudPanel.Remove(rp.seasonpass.HudPanel)
	end
end)

hook.Add('OnContextMenuOpen', 'Seasonpass::CheckContextMenu', function()
	local season = LocalPlayer():GetSeason()
	
	if season then
		net.Start("CMenu::Open")
		net.SendToServer()
	end
end)

hook.Add('OnSpawnMenuOpen', 'Seasonpass::CheckQMenu', function()
	local season = LocalPlayer():GetSeason()
	
	if season then
		net.Start("QMenu::Open")
		net.SendToServer()
	end
end)
