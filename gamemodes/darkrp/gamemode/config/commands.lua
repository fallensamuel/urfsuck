-- "gamemodes\\darkrp\\gamemode\\config\\commands.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local cat = 'Управление'

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

rp.AddMenuCommand(cat, 'Изменить законы', function()
	rp.CloseF4Menu()
	RunConsoleCommand("say", "/laws")
end, function() return LocalPlayer():IsMayor() end)
