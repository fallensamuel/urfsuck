ba.steamGroup = {}

ba.steamGroup.handler = 'http://urf.im/api/fnaf/steamgrouphandler.php'
ba.steamGroup.url = 'http://steamcommunity.com/groups/urfimofficial'
ba.steamGroup.vkUrl = 'https://vk.com/fnafcityrp'

function ba.steamGroup.check()
	timer.Simple(20, function()
		http.Fetch(ba.steamGroup.handler..'?steamid=' .. LocalPlayer():SteamID64(), function(body)
			if (body == '1') then
				chat.AddText(translates and translates.Get("Вы не вступили в нашу группу или ваш профиль Steam приватный! Напишите !steam, чтобы попробовать ещё раз.") or 'Вы не вступили в нашу группу или ваш профиль Steam приватный! Напишите !steam, чтобы попробовать ещё раз.')
			elseif (body == '0') then
				RunConsoleCommand('sgr', 'request')
			end
		end)
	end)
end

function ba.steamGroup.checkVK()
	timer.Simple(20, function()
		RunConsoleCommand('sgr', 'vk')
	end)
end

function ba.steamGroup.OpenVKMenu()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 90)
		self:SetTitle(translates and translates.Get("Вступить в нашу группу") or 'Вступить в нашу группу')
		self:MakePopup()
		self:Center()
		self:RequestFocus()
	end)

	ui.Create('DLabel', function(self, p) 
		self:SetText(translates and translates.Get("Вступи в нашу группу ВК и получи %s!", rp.FormatMoney(1000)) or ('Вступи в нашу группу ВК и получи ' .. rp.FormatMoney(1000) .. '!'))
		self:SetFont('ba.ui.24')
		self:SetTextColor(ui.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 32)
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText(translates and translates.Get('Хорошо') or 'Хорошо')
		self:SetPos(5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			gui.OpenURL(ba.steamGroup.vkUrl)
			ba.steamGroup.checkVK()
			p:Close()
		end
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText(translates and translates.Get('Нет, спасибо') or 'Нет, спасибо')
		self:SetPos(p:GetWide()/2 + 2.5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			p:Close()
			RunConsoleCommand('sgr', 'delay')
			chat.AddText(translates and translates.Get("Если передумаешь - напиши %s в чат.", '!vk') or 'Если передумаешь - напиши !vk в чат.')
		end
	end, fr)
end


function ba.steamGroup.OpenMenu()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 90)
		self:SetTitle(translates and translates.Get("Вступить в нашу группу") or 'Вступить в нашу группу')
		self:MakePopup()
		self:Center()
		self:RequestFocus()
	end)

	ui.Create('DLabel', function(self, p) 
		self:SetText(translates and translates.Get("Встпуи в нашу группу и получи 30 кредитов!") or 'Встпуи в нашу группу и получи 30 кредитов!')
		self:SetFont('ba.ui.24')
		self:SetTextColor(ui.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 32)
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText(translates and translates.Get('Хорошо') or 'Хорошо')
		self:SetPos(5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			gui.OpenURL(ba.steamGroup.url)
			ba.steamGroup.check()
			p:Close()
		end
	end, fr)

	ui.Create('DButton', function(self, p)
		self:SetText(translates and translates.Get('Нет, спасибо') or 'Нет, спасибо')
		self:SetPos(p:GetWide()/2 + 2.5, 60)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		function self:DoClick()
			p:Close()
			RunConsoleCommand('sgr', 'delay')
			chat.AddText(translates and translates.Get("Если передумаешь - напиши %s в чат.", '!steam') or 'Если передумаешь - напиши !steam в чат.')
		end
	end, fr)
end

local function Request()
	timer.Simple(35, function()
		http.Fetch(ba.steamGroup.handler..'?steamid=' .. LocalPlayer():SteamID64(), function(body, len, headers, code)
			if (body == '1') then
				ba.steamGroup.OpenMenu()
			elseif (body == '0') then
				RunConsoleCommand('sgr', 'request')
			elseif (body == '3') then
				ba.steamGroup.OpenVKMenu()
			end
		end, Request)
	end)
end

hook.Add('InitPostEntity', function()
	Request()
end)