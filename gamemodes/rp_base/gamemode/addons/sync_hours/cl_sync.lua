-- "gamemodes\\rp_base\\gamemode\\addons\\sync_hours\\cl_sync.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿table.insert(rp.cfg.Announcements, translates and translates.Get('sync_time') or '50% от вашего максимального игрового времени на любом сервере urf.im будет перенесено и сюда!')

local SetDrawColor, DrawTexturedRect, SetMaterial, SimpleText = surface.SetDrawColor, surface.DrawTexturedRect, surface.SetMaterial, draw.SimpleText

local color = {
	white = Color(255, 255, 255)
}

local Align = {
	Left = TEXT_ALIGN_LEFT,
	Top = TEXT_ALIGN_TOP
}

local function SyncHoursMenu(added_time, server_name)
	local scrScale = ScrH()/1080
	local clockMaterial = Material("rpui/misc/stopwatch.png", "smooth", "noclamp")

	local menu = vgui.Create("urf.im/rpui/menus/blank")

	function menu:PostPerformLayout()
		local wp_wide, wp_tall = menu.workspace:GetSize()

		menu.left = vgui.Create("Panel", menu.workspace)
		menu.left:SetSize(wp_tall, wp_tall)
		menu.left.Paint = function(this, w, h)
			SetDrawColor(color.white)
			SetMaterial(clockMaterial)

			local sz = h*0.65
			local pos = (h - sz) * 0.5
			DrawTexturedRect(pos, pos, sz, sz)
		end

		surface.CreateFont("rpui.SyncHours.1", {
		    font = "Montserrat",
		    extended = true,
		    antialias = true,
		    size = wp_tall * 0.18,
		    weight = 550
		})

		surface.CreateFont("rpui.SyncHours.2", {
		    font = "Montserrat",
		    extended = true,
		    antialias = true,
		    size = wp_tall * 0.11,
		    weight = 500
		})

		surface.CreateFont("rpui.SyncHours.3", {
		    font = "Montserrat",
		    extended = true,
		    antialias = true,
		    size = wp_tall * 0.075,
		    weight = 500
		})

		menu.right = vgui.Create("Panel", menu.workspace)
		menu.right:SetSize(wp_wide-wp_tall, wp_tall)
		menu.right:SetPos(wp_tall, 0)
		menu.right.Paint = function(this, w, h)
			local sz = h*0.65
			local pos = (h - sz) * 0.5

			local _, txt_h = SimpleText(translates and translates.Get("Поздравляем!") or "Поздравляем!", "rpui.SyncHours.1", 0, pos)

			local pos_y = pos + txt_h
			local txt_w, txt_h2 = SimpleText(translates and translates.Get("Вы получили %s час(а) за игру на %s", added_time, server_name) or ("Вы получили " .. added_time .. " час(а) за игру на " .. server_name), "rpui.SyncHours.2", 0, pos_y)

			pos_y = pos_y + txt_h2*(ScrH() > 850 and 1.125 or 1)
			
			SimpleText(translates and translates.Get("50%% от наигранного времени - до %s часов.", rp.cfg.MaxSyncHours or 50) or ("50% от наигранного времени - до " .. (rp.cfg.MaxSyncHours or 50) .. " часов."), "rpui.SyncHours.3", 0, pos_y)
		end

		menu.right.btn = vgui.Create("urf.im/rpui/button", menu.right)
		menu.right.btn:SetSize(menu.right:GetWide() - wp_tall*0.12, wp_tall*0.24)
		menu.right.btn:SetPos(0, wp_tall*0.88 - menu.right.btn:GetTall())
		menu.right.btn:SetText(translates and translates.Get("Отлично!") or "Отлично!")

		surface.CreateFont("rpui.SyncHours.4", {
		    font = "Montserrat",
		    extended = true,
		    antialias = true,
		    size = menu.right.btn:GetTall() * 0.65,
		    weight = 530
		})

		menu.right.btn:SetFont("rpui.SyncHours.4")
		menu.right.btn.DoClick = function()
			menu:Close()
		end
	end

	menu:SetSize(580*scrScale, 240*scrScale)
	menu:Center()
	menu:MakePopup()

	menu.header.SetIcon(menu.header, "rpui/misc/stopwatch.png")
	menu.header.SetTitle(menu.header, translates and translates.Get("УВЕДОМЛЕНИЕ") or "УВЕДОМЛЕНИЕ")
	menu.header.SetFont(menu.header, "rpui.playerselect.title")
	menu.header.IcoSizeMult = 1.5
end

net.Receive('rp.SyncHours', function()
	local added_time = net.ReadUInt(16)
	local server_name = net.ReadString()

	SyncHoursMenu(added_time, server_name)
end)

concommand.Add("synchours_menudebug", function()
	if not LocalPlayer():IsRoot() then return end

	SyncHoursMenu(24, "Stalker RP")
end)