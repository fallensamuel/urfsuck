hook('PopulateF4Tabs', function(tabs)
	local tab = ui.Create('ui_panel')
	tab:SetSize(tabs:GetParent():GetWide() - 165, tabs:GetParent():GetTall() - 35)
	tabs:AddTab('Цвета', tab)
	rp.ui.Label('Цвет персонажа', 'rp.ui.20', 5, 5, tab)

	ui.Create('DColorMixer', function(self, p)
		self:SetAlphaBar(false)
		self:SetSize(p:GetWide() / 2 - 7.5, p:GetTall() - 60)
		self:SetPos(5, 25)
		self:SetVector(Vector(GetConVar('cl_playercolor'))) -- changed to GetConVar

		self.ValueChanged = function()
			RunConsoleCommand('cl_playercolor', tostring(self:GetVector()))
			rp.RunCommand('playercolor')
		end
	end, tab)

	rp.ui.Label('Цвет оружия', 'rp.ui.20', tab:GetWide() / 2 + 7.5, 5, tab)

	ui.Create('DColorMixer', function(self, p)
		self:SetAlphaBar(false)
		self:SetSize(p:GetWide() / 2 - 7.5, p:GetTall() - 60)
		self:SetPos(p:GetWide() / 2 + 2.5, 25)
		self:SetVector(Vector(GetConVar('cl_weaponcolor')))

		self.ValueChanged = function()
			RunConsoleCommand('cl_weaponcolor', tostring(self:GetVector()))
			rp.RunCommand('weaponcolor')
		end
	end, tab)

	ui.Create('DButton', function(self, p)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetPos(5, p:GetTall() - 30)
		self:SetText('Выбери сумасшедший цвет для Физгана')

		self.DoClick = function()
			local min = math.Rand(10, 100000000)
			local max = math.Rand(10, 100000000)
			local a = math.Rand(-min, max)
			min = math.Rand(10, 100000000)
			max = math.Rand(10, 100000000)
			local b = math.Rand(-min, max)
			min = math.Rand(10, 100000000)
			max = math.Rand(10, 100000000)
			local c = math.Rand(-min, max)
			RunConsoleCommand('cl_weaponcolor', tostring(Vector(a, b, c)))
			rp.RunCommand('weaponcolor')
		end
	end, tab)
end)