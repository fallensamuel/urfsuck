
local cat = 'Деньги'

rp.AddMenuCommand(cat, 'Передать деньги', function()
	ui.StringRequest('Количество', 'Сколько вы хотите передать?', '', function(a)
		rp.RunCommand('give', tostring(a))
	end)
end)

rp.AddMenuCommand(cat, 'Бросить деньги', function()
	ui.StringRequest('Количество', 'Сколько вы хотите бросить?', '', function(a)
		rp.RunCommand('dropmoney', tostring(a))
	end)
end)

rp.AddMenuCommand(cat, 'Выписать чек', function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest('Чек', 'Сколько вы хотите выписать?', '', function(a)
			if IsValid(v) then
				rp.RunCommand('cheque', v:SteamID(), a)
			end
		end)
	end)
end)

cat = 'Действия'
--rp.AddMenuCommand(cat, 'Полечиться $500', 'buyhealth')
rp.AddMenuCommand(cat, 'Продать все двери', 'sellall')
rp.AddMenuCommand(cat, 'Выбросить текущее оружие', 'drop')
/*
rp.AddMenuCommand(cat, 'Заказать убийство', function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest('Заказать убийство', 'Сколько вы хотите отдать за убийство (' .. rp.FormatMoney(rp.cfg.HitMinCost) .. ' - ' .. rp.FormatMoney(rp.cfg.HitMaxCost) .. ')?', '', function(a)
			if IsValid(v) then
				rp.RunCommand('hit', v:SteamID(), a)
			end
		end)
	end)
end)
*/
rp.AddMenuCommand(cat, 'Уволить игрока', function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest('Уволить игрока', 'Причина уольнения?', '', function(a)
			if IsValid(v) then
				rp.RunCommand('demote', v:SteamID(), a)
			end
		end)
	end)
end)
/*
rp.AddMenuCommand(cat, 'Нанять рабочего (Смотря на игрока)', 'hire')
rp.AddMenuCommand(cat, 'Уволить рабочего', function()
rp.AddMenuCommand(cat, 'Уволиться', 'quitjob')


	ui.PlayerReuqest(table.Filter(player.GetAll(), function(v) return (v:GetNetVar('Employer') == LocalPlayer()) end), function(v)
		rp.RunCommand('fire', v:SteamID())
	end)
end)
*/
cat = 'Roleplay'

rp.AddMenuCommand(cat, 'Маскироваться', function()
	rp.DisguiseMenuF4()
end, function() return LocalPlayer():GetTeamTable().candisguise end)

rp.AddMenuCommand(cat, 'Снять маскировку', function()
	if LocalPlayer():IsDisguised() then
		net.Start('rp.UnDisguise')
		net.SendToServer()
	end
end, function() return LocalPlayer():IsDisguised() end)

if !isWhiteForest then
	rp.AddMenuCommand(cat, 'Надеть кандалы', function()
		if not LocalPlayer():IsVortDisguised() then
			net.Start('rp.VortigontDisguise')
			net.SendToServer()
		end
	end, function() return LocalPlayer():GetTeamTable().vort_disguise and not LocalPlayer():IsVortDisguised() end)

	rp.AddMenuCommand(cat, 'Снять кандалы', function()
		if LocalPlayer():IsVortDisguised() then
			net.Start('rp.UnVortigontDisguise')
			net.SendToServer()
		end
	end, function() return LocalPlayer():IsVortDisguised() end)
end
 

/*
rp.AddMenuCommand(cat, 'Изменить название работы', function()
	ui.StringRequest('Название работы', 'Какое название работы вы хотите?', '', function(a)
		rp.RunCommand('job', a)
	end)
end)
*/
rp.AddMenuCommand(cat, 'Сменить ник', function()
	ui.StringRequest('Смена ника', 'Какое имя вы себе хотите?', '', function(a)
		rp.RunCommand('name', a)
	end)
end)

rp.AddMenuCommand(cat, 'Получить случайное имя', 'randomname')
rp.AddMenuCommand(cat, 'Случайное число', 'roll')
rp.AddMenuCommand(cat, 'Бросить кубики', 'dice')
rp.AddMenuCommand(cat, 'Вытащить карту', 'cards')

cat = 'Правопорядок'

rp.AddMenuCommand(cat, 'Подать в розыск', function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest('Розыск', 'Причина розыска?', '', function(a)
			if IsValid(v) then
				rp.RunCommand('want', v:SteamID(), a)
			end
		end)
	end)
end)

rp.AddMenuCommand(cat, 'Снять розыск', function()
	local wantedplayers = table.Filter(player.GetAll(), function(v) return v:IsWanted() end)

	ui.PlayerReuqest(wantedplayers, function(v)
		rp.RunCommand('unwant', v:SteamID())
	end)
end)

rp.AddMenuCommand(cat, 'Ордер', function()
	ui.PlayerReuqest(function(v)
		ui.StringRequest('Ордер', 'Причина для ордера?', '', function(a)
			if IsValid(v) then
				rp.RunCommand('warrant', v:SteamID(), a)
			end
		end)
	end)
end)

cat = 'Сектор'

--rp.AddMenuCommand(cat, 'Комендантский час', function()
--	if nw.GetGlobal('lockdown') then
--		rp.RunCommand('unlockdown')
--		return
--	end
--	
--	local fr = ui.Create('ui_frame', function(self, p)
--		self:SetTitle("Комендантский час")
--		self:SetSize(.2, .3)
--		self:Center()
--		self:MakePopup()
--	end, cont)
--
--	local scroll = ui.Create('ui_scrollpanel', function(self)
--		self:DockMargin(0, 3, 0, 0)
--		self:Dock(FILL)
--	end, fr)
--
--	for k, v in pairs(rp.cfg.Lockdowns) do
--		ui.Create('DButton', function(self)
--			self:SetSize(90, 30)
--			self:SetText(v.name)
--			self.DoClick = function() fr:Close() rp.RunCommand('lockdown', k) end
--			scroll:AddItem(self)
--		end)
--	end
--
--	fr:Focus()
--end)

--rp.AddMenuCommand(cat, 'Начать лоттерею', function()
--	ui.StringRequest('Лоттерея', 'Цена билета на лоттерею?', '', function(a)
--		rp.RunCommand('lottery', tostring(a))
--	end)
--end)

rp.AddMenuCommand(cat, 'Изменить законы', 'laws')
cat = 'Управление'

rp.AddMenuCommand(cat, 'Редактировать повестку дня', function()
	local agenda = (nw.GetGlobal('Agenda;' .. LocalPlayer():Team()) or '')

	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(ScrW() * .2, ScrH() * .3)
		self:Center()
		self:SetTitle('Редактировать повестку дня')
		self:MakePopup()
	end)

	local x, y = fr:GetDockPos()

	local e = ui.Create('DTextEntry', function(self, p)
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 35)
		self:SetMultiline(true)
		self:SetValue(agenda)

		self.OnTextChanged = function()
			agenda = self:GetValue()
		end
	end, fr)

	e = ui.Create('DButton', function(self, p)
		x, y = e:GetPos()
		y = y + e:GetTall() + 5
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetText('Готово')

		self.DoClick = function()
			if string.len(agenda) <= 5 then
				LocalPlayer():ChatPrint('Минимум 5 символов!')

				return
			end

			rp.RunCommand('agenda', agenda)
		end
	end, fr)
end, function() return LocalPlayer():IsAgendaManager() end) -- TODO MAKE LAWS AND AGENDA EDITOR CONTROLS, CONTROLS CONTROLS CONTROLS THX
