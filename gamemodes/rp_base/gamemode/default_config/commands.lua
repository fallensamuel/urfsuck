-- "gamemodes\\rp_base\\gamemode\\default_config\\commands.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local cat = translates.Get('Деньги')

rp.AddMenuCommand(cat, translates.Get('Передать деньги'), function()
	rp.CloseF4Menu()
	
	rpui.SliderRequestFree(translates.Get('Сколько вы хотите передать?'), "rpui/donatemenu/money", 1.5, (LocalPlayer():GetMoney() > rp.cfg.StartMoney*10) and (rp.cfg.StartMoney*10) or LocalPlayer():GetMoney(), function(val)
		RunConsoleCommand("say", "/give " .. val)
	end)
end)

cat = translates.Get('Действия')

rp.AddMenuCommand(cat, translates.Get('Продать все двери'), 'sellall')

rp.AddMenuCommand(cat, translates.Get('Уволить игрока'), function()
	rpui.PlayerReuqest(translates.Get('Уволить игрока'), "scoreboard/usergroups/ug_1.png", 1, function(ply)
		if not IsValid(ply) then return end
		local plyID = ply:IsBot() and ply:Name() or ply:SteamID()

		rpui.StringRequest(translates.Get('Уволить игрока'), translates.Get('Причина уольнения?'), "shop/filters/list.png", 1.4, function(self, str)
			RunConsoleCommand("say", "/demote "..plyID.." "..str)
		end)
	end)
end, function() return not rp.cfg.Serious and not rp.cfg.NoDemotes end)


cat = 'Roleplay'

rp.AddMenuCommand(cat, translates.Get('Маскироваться'), function()
	rp.DisguiseMenuF4()
end, function() return LocalPlayer():GetTeamTable().candisguise end)

rp.AddMenuCommand(cat, translates.Get('Снять маскировку'), function()
	if LocalPlayer():IsDisguised() then
		net.Start('rp.UnDisguise')
		net.SendToServer()
	end
end, function() return LocalPlayer():IsDisguised() and not LocalPlayer():GetNetVar("DisguiseHeadcrab") end)

rp.AddMenuCommand(cat, translates.Get('Сменить ник'), function()
	rp.CloseF4Menu()
	
	rpui.StringRequest(translates.Get('Смена ника'), translates.Get('Какое имя вы себе хотите?'), "scoreboard/usergroups/admin.png", 1.6, function(self, str)
		RunConsoleCommand("say", "/name "..str)
	end)
end)

rp.AddMenuCommand(cat, translates.Get('Случайное число'), 'roll')
rp.AddMenuCommand(cat, translates.Get('Бросить кубики'), 'dice')
rp.AddMenuCommand(cat, translates.Get('Вытащить карту'), 'cards')
