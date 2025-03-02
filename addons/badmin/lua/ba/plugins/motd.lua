ba.AddTerm('MOTDSet', 'The MoTD has been set to "#".')

----------------------------------------------------------------
-- MoTD                                                       --
----------------------------------------------------------------
if (SERVER) then
	ba.svar.Create('motd', nil, true)

	--resource.AddFile('resource/fonts/Michroma.ttf')
elseif (CLIENT) then
	cvar.Register('ba_openmotd')
		:SetDefault(true)
		:AddMetadata('Menu', 'Отображать MoTD при входе на сервер')

	function ba.OpenMoTD()
		local motd_url = ba.svar.Get('motd')
		if not motd_url then return end

		local w, h = ScrW() * .9, ScrH() * .9

		local fr = ui.Create('urf.im/rpui/menus/blank', function(self)
			self:SetTitle(translates and translates.Get("Добро Пожаловать!") or 'Добро Пожаловать!')
			self:SetSize(w, h)
			self:MakePopup()
			self:Center()
		end)

		local tabList = ui.Create('ui_tablist', function(self, p)
			self:DockToFrame()
		end, fr)

		local tab = ui.Create('ui_panel')
		tabList:AddTab(translates and translates.Get("Правила") or 'Правила', tab, true)
		ui.Create('HTML', function(self, p)
			self:SetPos(1, 1)
			self:SetSize(p:GetWide() - 1, p:GetTall() - 1)
			self:OpenURL(motd_url)
		end, tab)

		local tab = ui.Create('ui_panel')
		tabList:AddTab(translates and translates.Get("Группа ВК") or 'Группа ВК', tab)
		ui.Create('HTML', function(self, p)
			self:SetPos(1, 1)
			self:SetSize(p:GetWide() - 1, p:GetTall() - 1)
			self:OpenURL('https://vk.com/stalkerrp')
		end, tab)

		tabList:AddButton(translates and translates.Get("Группа Steam") or 'Группа Steam', function()
			fr:Close()
			gui.OpenURL('http://steamcommunity.com/groups/urfimofficial')
		end)

		tabList:AddButton(translates and translates.Get("Контент") or 'Контент', function()
			fr:Close()
			gui.OpenURL('https://steamcommunity.com/sharedfiles/filedetails/?id=1569141045')
		end)

		if rp then
			tabList:AddButton(translates and translates.Get("Донат") or 'Донат', function()
				fr:Close()
				rp.RunCommand('upgrades')
			end)
		end

		tabList:AddButton(translates and translates.Get("Закрыть") or 'Закрыть', function()
			fr:Close()
		end)
	end
end

-------------------------------------------------
-- MoTD
-------------------------------------------------
ba.cmd.Create('MoTD')
:RunOnClient(function(args)
	rp.Motd()
end)
:SetHelp('Open server rules')
:AddAlias('rules')

-------------------------------------------------
-- SetMoTD
-------------------------------------------------
ba.cmd.Create('SetMoTD', function(pl, args)
	ba.svar.Set('motd', args.url)
	ba.notify(pl, ba.Term('MOTDSet'), args.url)
end)
:AddParam('string', 'url')
:SetFlag('*')
:SetHelp('Sets the MoTD URL for the server')
