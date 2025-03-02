-- "gamemodes\\rp_base\\gamemode\\main\\orgs\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('painter_cl.lua')

rp.orgs = rp.orgs or {}
rp.orgs.Banners = rp.orgs.Banners or {}
rp.orgs.Colors 	= rp.orgs.Colors or {}

local fr

hook.Add('InitPostEntity', function()
	timer.Simple(5, function()
		net.Start('rp.orgs.GetColors')
		net.SendToServer()
	end)
end)

net('rp.orgs.GetColors', function()
	for i = 1, net.ReadUInt(16) do
		rp.orgs.Colors[net.ReadString()] = net.ReadColor()
	end
end)

net('rp.orgs.GetColor', function()
	rp.orgs.Colors[net.ReadString()] = net.ReadColor()
end)

net('rp.OrgsMenu', function()
	if IsValid(fr) then fr:Close() end

	local w, h = ScrW() * 0.55, ScrH() * 0.525

	local orgdata 	= LocalPlayer():GetOrgData()
	local rank 		= orgdata.Rank -- TODO: FIX
	local motd 		= orgdata.MoTD
	local perms 	= orgdata.Perms

	local orgmembers 	= {}
	local orgranks 		= {}
	local orgrankref 	= {}

	for i = 1, net.ReadUInt(5) do
		local rankname 		= net.ReadString()
		local weight 		= net.ReadUInt(7)
		local invite 		= net.ReadBool()
		local kick 			= net.ReadBool()
		local rank 			= net.ReadBool() -- TODO: FIX
		local motd 			= net.ReadBool() -- TODO: FIX
		local ccapture 		= net.ReadBool()
		local cdiplomacy 	= net.ReadBool()
		local cstorage      = net.ReadBool()

		orgranks[#orgranks + 1] = {
			Name = rankname,
			Weight = weight,
			Invite = invite,
			Kick = kick,
			Rank = rank,
			MoTD = motd,
			CanCapture = ccapture,
			CanDiplomacy = cdiplomacy,
			CanStorage = cstorage
		}

		orgrankref[rankname] = orgranks[#orgranks]
	end

	table.SortByMember(orgranks, 'Weight')

	for i = 1, net.ReadUInt(9) do
		local steamid 	= net.ReadString()
		local name 		= net.ReadString()
		local rank 		= net.ReadString() -- TODO: FIX

		if (not orgrankref[rank]) then
			print("Glitched member: " .. steamid .. " rank " .. rank .. " doesnt exist! Assuming lowest")
			rank = orgranks[#orgranks].Name
		end

		local weight = orgrankref[rank].Weight

		orgmembers[#orgmembers + 1] = {
			SteamID	= steamid,
			Name 	= name,
			Rank 	= rank,
			Weight 	= weight
		}
	end

	table.SortByMember(orgmembers, 'Weight')

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle(LocalPlayer():GetOrg())
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
	end)

	--------------------------------------------
	-- Left Column: Members
	--------------------------------------------
	fr.colLeft = ui.Create('Panel', function(self)
		self:SetWide(w / 3)
		self:Dock(LEFT)
	end, fr)

	fr.lblMem = ui.Create('DLabel', function(self)
		self:SetText('Участники: ' .. #orgmembers)
		self:SizeToContents()
		self:Dock(TOP)
	end, fr.colLeft)

	fr.listMem = ui.Create('ui_listview', function(self)
		self:Dock(FILL)
	end, fr.colLeft)

	--------------------------------------------
	-- Middle Column: Flag, Ranks
	--------------------------------------------
	fr.colMid = ui.Create('Panel', function(self)
		self:SetWide(128)
		self:DockMargin(5, 0, 5, 0)
		self:Dock(LEFT)
	end, fr)

	fr.lblFlag = ui.Create('DLabel', function(self)
		self:SetText("Логотип")
		self:SizeToContents()
		self:Dock(TOP)
	end, fr.colMid)

	fr.pnlFlag = ui.Create('Button', function(self)
		self:SetText('')
		self:SetTall(128)
		self:Dock(TOP)

		self.Paint = function(s, w, h)
			surface.SetDrawColor(rp.col.Outline)
			surface.DrawOutlinedRect(0, 0, w, h)

			local mat = rp.orgs.GetBanner(LocalPlayer():GetOrg())
			if (mat) then
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0, 0, w, h)
			end

			return true
		end

		self.DoClick = function(s)
			--if LocalPlayer():HasUpgrade('org_prem') then
				rp.orgs.OpenOrgBannerEditor(perms)
			--end
		end
	end, fr.colMid)

	fr.lblRanks = ui.Create('DLabel', function(self)
		self:SetText("Ранг")
		self:SizeToContents()
		self:Dock(TOP)
	end, fr.colMid)

	fr.listRank = ui.Create('ui_listview', function(self)
		self:Dock(FILL)
	end, fr.colMid)

	--------------------------------------------
	-- Right Column: MOTD, Color
	--------------------------------------------
	fr.colRight = ui.Create('Panel', function(self)
		self:Dock(FILL)
	end, fr)

	fr.lblMoTD = ui.Create('DLabel', function(self)
		self:SetText('Новости')
		self:SizeToContents()
		self:Dock(TOP)
	end, fr.colRight)

	fr.txtMoTD = ui.Create('ui_scrollpanel', function(self)
		self:Dock(FILL)
		self:SetPadding(3)

		self.Paint = function(s, w, h)
			surface.SetDrawColor(200, 200, 200)
			surface.DrawRect(0, 0, w, h)
		end
	end, fr.colRight)

	--------------------------------------------
	-- Begin Data Population
	--------------------------------------------
	fr.PopulateMembers = function(tosel)
		fr.listMem:Reset(true)
		local lastRank = ''

		for k, v in ipairs(orgmembers) do
			if (v.Rank ~= lastRank) then
				fr.listMem:AddRow(v.Rank, true)
				lastRank = v.Rank
			end

			local btn = fr.listMem:AddRow(v.Name)
			btn.Player = v

			if (rp.FindPlayer(v.SteamID)) then
				btn.TextColor = LocalPlayer():GetOrgColor()
			end

			-- Context menu
			function btn:OnMousePressed(keyCode)
				if(keyCode == MOUSE_LEFT) then
					self:DoClick()
					return

				elseif(keyCode == MOUSE_RIGHT) then
					local m = ui.DermaMenu(p)

					m:AddOption('Профиль Steam', function()
						gui.OpenURL('https://steamcommunity.com/profiles/' .. v.SteamID)
					end)

					m:AddOption('Копировать SteamID', function()
						SetClipboardText(util.SteamIDFrom64(tostring(v.SteamID)))
					end)

					m:Open()
				end
			end

			if (tosel == v.SteamID) then
				btn:DoClick()
			end
		end
	end

	fr.PopulateMembers()

	fr.ReorderRanks = function()
		local sel = fr.listRank:GetSelected()
		local rank = sel and sel.Rank and sel.Rank.Name or nil -- TODO: FIX
		table.SortByMember(orgranks, 'Weight')

		for k, v in ipairs(orgranks) do
			local k = #orgranks - (k - 1)
			local newWeight = 1 + math.floor(((k - 1) / (#orgranks - 1)) * 99)
			v.Weight = newWeight
		end

		fr.PopulateRanks(rank)
	end

	fr.PopulateRanks = function(tosel)
		fr.listRank:Reset(true)

		for k, v in ipairs(orgranks) do
			local btn = fr.listRank:AddRow(v.Name)
			btn.Rank = v

			if (v.Name == tosel) then
				btn:DoClick()
			end
		end
	end

	fr.PopulateRanks()

	fr.PopulateMoTD = function()
		fr.txtMoTD:Reset(true)
		local motdRows = string.Wrap('rp.ui.22', motd, w - 30 - fr.colLeft:GetWide() - fr.colMid:GetWide())

		for k, v in pairs(motdRows) do
			local lbl = ui.Create('DLabel', function(self) -- TODO: FIX
				self:SetText(v)
				self:SizeToContents()
				self:SetWide(w - 15 - fr.colLeft:GetWide() - fr.colMid:GetWide())
				self:SetTextColor(rp.col.Black)
				fr.txtMoTD:AddItem(self)
			end)
		end
	end

	fr.PopulateMoTD()

	--------------------------------------------
	-- Admin stuff!
	--------------------------------------------
	if (perms.Owner) then
		fr.btnCol = ui.Create('DButton', function(self)
			self:SetText("Изменить цвет")
			self:SetTall(25)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)

			self.Think = function(s)
				s:SetDisabled(IsValid(fr.overMoTD))
			end

			self.DoClick = function(s)
				if (IsValid(fr.colPicker)) then
					local color = fr.colPicker:GetColor()

					if (color ~= LocalPlayer():GetOrgColor()) then
						rp.RunCommand('setorgcolor', color.r, color.g, color.b)
					end

					fr.colPicker:Remove()
					fr.lblMoTD:SetText('Новости')
					s:SetText('Изменить цвет')
				else
					fr.colPicker = ui.Create('DColorMixer', function(col)
						col:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
						col:SetSize(fr.txtMoTD:GetSize())
						col:SetColor(LocalPlayer():GetOrgColor())
						col:SetAlphaBar(false)
						col.OP = col.Paint

						col.Paint = function(s, w, h)
							surface.SetDrawColor(rp.col.Black)
							surface.DrawRect(0, 0, w, h)
							s:OP(w, h)
						end
					end, fr.colRight)

					fr.lblMoTD:SetText('Выбор нового цвета')
					s:SetText("Готово")
				end
			end
		end, fr.colRight)

		fr.btnNewRank = ui.Create('DButton', function(self)
			self:SetText("Новый ранг")
			self:SetTall(25)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)

			self.Think = function(s)
				s:SetDisabled(IsValid(fr.overRankEdit))
			end

			self.DoClick = function(s)
				if (IsValid(fr.overRankNew)) then
					fr.overRankNew:Remove()
					s:SetText("Новый ранг")
				else
					fr.overRankNew = ui.Create('ui_scrollpanel', function(scr)
						scr:SetPos(fr.listRank.x, fr.lblFlag:GetTall() + fr.pnlFlag:GetTall() + fr.lblRanks:GetTall())
						scr:SetSize(fr.listRank:GetSize())

						scr.Paint = function(s, w, h)
							surface.SetDrawColor(200, 200, 200)
							surface.DrawRect(0, 0, w, h)
						end
					end, fr.colMid)

					local txtName = ui.Create('DButton', function(txt)
						txt:SetTall(25)
						txt:SetFont('rp.ui.22')
						txt:SetText('Введите название')
						txt:Dock(TOP)

						txt.DoClick = function(s)
							ui.StringRequest('Название ранга', 'Какого название вы хотите?', '', function(resp)
								s:SetText(resp)
							end)
						end

						fr.overRankNew:AddItem(txt)
					end)

					local btn = vgui.Create('DLabel')
					btn:SetTall(25)
					btn:SetText('  Полномочия')
					btn:SetTextColor(rp.col.Black)
					btn:SizeToContents()
					btn:Dock(TOP)
					fr.overRankNew:AddItem(btn)

					local btnBelow = ui.Create('DButton', function(btn)
						btn:SetText(25)
						btn:SetText(orgranks[1].Name)
						btn.Rank = orgranks[1]
						btn:Dock(TOP)

						btn.DoClick = function(s)
							local m = ui.DermaMenu()

							for k, v in ipairs(orgranks) do
								if (v.Weight == 1) then continue end

								m:AddOption(v.Name, function()
									s:SetText(v.Name)
									s.Rank = v
								end)
							end

							m:Open()
						end

						fr.overRankNew:AddItem(btn)
					end)

					local chkInvite = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Приглашать")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local chkKick = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Выгонять")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local chkRank = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Ред Ранги")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Ред Новости")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local chkCCapt = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Захват точки")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local chkCDipl = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Дипломатия")
						chk:SetTextColor(rp.col.Black)
						chk:Dock(TOP)
						fr.overRankNew:AddItem(chk)
					end)

					local btnSubmit = ui.Create('DButton', function(btn)
						btn:SetTall(25)
						btn:SetText("Готово")
						btn.TextColor = rp.col.Green
						btn:Dock(TOP)

						btn.DoClick = function(s)
							local name = txtName:GetText()
							local weight = btnBelow.Rank.Weight - 1
							local invite = chkInvite:GetChecked()
							local kick = chkKick:GetChecked()
							local canrank = chkRank:GetChecked()
							local motd = chkMOTD:GetChecked()
							local ccapture = chkCCapt:GetChecked()
							local cdiplomacy = chkCDipl:GetChecked()
							rp.RunCommand('orgrank', name, tostring(weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0', ccapture and '1' or '0', cdiplomacy and '1' or '0')

							if (#orgranks < (LocalPlayer():HasUpgrade('org_prem') and 16 or 5)) then
								orgrankref[name] = orgranks[table.insert(orgranks, {
									Name = name,
									Weight = weight,
									Invite = invite,
									Kick = kick,
									Rank = canrank,
									MoTD = motd,
									CanCapture = ccapture,
									CanDiplomacy = cdiplomacy
								})]
							end

							fr.btnNewRank:DoClick()
							fr.ReorderRanks()
						end

						fr.overRankNew:AddItem(btn)
					end)

					txtName:DoClick()
					s:SetText("Отмена")
				end
			end
		end, fr.colMid)

		fr.btnEditRank = ui.Create('DButton', function(self)
			self:SetText("Изменить ранг")
			self:SetTall(25)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)

			self.Think = function(s)
				s:SetDisabled(IsValid(fr.overRankNew) or not fr.listRank:GetSelected())
			end

			self.DoClick = function(s, ignore)
				if (IsValid(fr.overRankEdit)) then
					if (not ignore) then
						local rank = fr.listRank:GetSelected().Rank
						local invite = fr.overRankEdit.chkInvite:GetChecked()
						local kick = fr.overRankEdit.chkKick:GetChecked()
						local canrank = fr.overRankEdit.chkRank:GetChecked()
						local motd = fr.overRankEdit.chkMOTD:GetChecked()
						local ccapture = fr.overRankEdit.chkCCapt:GetChecked()
						local cdiplomacy = fr.overRankEdit.chkCDipl:GetChecked()

						if (invite ~= rank.Invite or kick ~= rank.Kick or canrank ~= rank.Kick or motd ~= rank.MoTD or ccapture ~= rank.CanCapture or cdiplomacy ~= rank.CanDiplomacy) then
							rp.RunCommand('orgrank', rank.Name, tostring(rank.Weight), invite and '1' or '0', kick and '1' or '0', canrank and '1' or '0', motd and '1' or '0', ccapture and '1' or '0', cdiplomacy and '1' or '0')
							rank.Invite = invite
							rank.Kick = kick
							rank.Rank = canrank
							rank.MoTD = motd
							rank.CanCapture = ccapture
							rank.CanDiplomacy = cdiplomacy
						end
					end

					fr.overRankEdit:Remove()
					s:SetText("Изменить ранг")
					fr.lblRanks:SetText('Ranks')
				else
					local rank = fr.listRank:GetSelected().Rank

					fr.overRankEdit = ui.Create('ui_scrollpanel', function(scr)
						scr:SetPos(fr.listRank.x, fr.lblFlag:GetTall() + fr.pnlFlag:GetTall() + fr.lblRanks:GetTall())
						scr:SetSize(fr.listRank:GetSize())

						scr.Paint = function(s, w, h)
							surface.SetDrawColor(200, 200, 200)
							surface.DrawRect(0, 0, w, h)
						end
					end, fr.colMid)

					local btnName = ui.Create('DButton', function(btn)
						btn:SetText('Переименовать')
						btn:SetTall(25)
						btn:Dock(TOP)

						btn.DoClick = function(s)
							ui.StringRequest('Название ранга', 'На что вы хотите смеменить ' .. rank.Name .. '?', '', function(resp)
								if (not orgrankref[resp]) then
									rp.RunCommand('orgrank', rank.Name, resp)
									fr.listRank:GetSelected():SetText(resp)
									fr.lblRanks:SetText('Editing ' .. resp)

									for k, v in ipairs(orgmembers) do
										if (v.Rank == rank.Name) then
											v.Rank = resp
										end
									end

									rank.Name = resp
									fr.PopulateMembers()
									fr.PopulateRanks(resp)
								end
							end)
						end

						fr.overRankEdit:AddItem(btn)
					end)

					ui.Create('DButton', function(btn)
						btn:SetText('Полномочия')
						btn:SetTall(25)
						btn:Dock(TOP)

						btn.DoClick = function(s)
							local m = ui.DermaMenu()

							for k, v in ipairs(orgranks) do
								if (v.Weight == 1 or v.Name == rank.Name) then continue end

								m:AddOption(v.Name, function()
									rp.RunCommand('orgrank', rank.Name, tostring(v.Weight - 1), rank.Invite and '1' or '0', rank.Kick and '1' or '0', rank.Edit and '1' or '0', rank.MoTD and '1' or '0')
									rank.Weight = v.Weight - 1
									fr.ReorderRanks()
								end)
							end

							m:Open()
						end

						fr.overRankEdit:AddItem(btn)

						if (rank.Weight == 1 or rank.Weight == 100) then
							btn:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkInvite = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Приглашать")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.Invite)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkKick = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Выгонять")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.Kick)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkRank = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Ред Ранги")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.Rank)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkMOTD = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Ред Новости")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.MoTD)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkCCapt = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Захват точки")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.CanCapture)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					fr.overRankEdit.chkCDipl = ui.Create('DCheckBoxLabel', function(chk)
						chk:SetText("Дипломатия")
						chk:SetTextColor(rp.col.Black)
						chk:SetChecked(rank.CanDiplomacy)
						fr.overRankEdit:AddItem(chk)

						if (rank.Weight == 100) then
							chk:SetMouseInputEnabled(false)
						end
					end)

					ui.Create('DButton', function(btn)
						btn:SetText('Удалить')
						btn:SetTall(25)

						btn.Think = function(s)
							if (s.CoolDown and SysTime() > s.CoolDown + 2) then
								s:SetText("Удалить")
								s.CoolDown = nil
							end
						end

						btn.DoClick = function(s)
							if (not s.CoolDown) then
								s.CoolDown = SysTime()
								s:SetText("Подтвердите")
							else
								rp.RunCommand('orgrankremove', rank.Name)
								fr.listRank:GetSelected():Remove()
								fr.btnEditRank:DoClick(true)
								orgrankref[rank.Name] = nil
								local nextRank
								local rn = rank.Name

								for k, v in ipairs(orgranks) do
									if (v.Name == rank.Name) then
										nextRank = orgranks[k + 1]
										table.remove(orgranks, k)
										break
									end
								end

								for k, v in ipairs(orgmembers) do
									if (v.Rank == rn) then
										v.Rank = nextRank.Name
									end
								end

								local sel = fr.listMem:GetSelected()
								fr.PopulateMembers(sel and sel.Player.SteamID or nil)
							end
						end

						btn.TextColor = rp.col.Red
						fr.overRankEdit:AddItem(btn)

						if (rank.Weight == 1 or rank.Weight == 100) then
							btn:SetMouseInputEnabled(false)
						end
					end)

					fr.lblRanks:SetText('Editing ' .. rank.Name)
					fr.lblRanks:SizeToContents()
					s:SetText("Назад")
				end
			end
		end, fr.colMid)
	end

	if (perms.MoTD) then
		fr.btnMoTD = ui.Create('DButton', function(self)
			self:SetText("Изменить Новости")
			self:SetTall(25)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)

			self.Think = function(s)
				s:SetDisabled(IsValid(fr.colPicker))
			end

			self.DoClick = function(s)
				if (IsValid(fr.overMoTD)) then
					local newMoTD = fr.overMoTD:GetValue()
					fr.overMoTD:Remove()

					if (newMoTD ~= motd) then
						net.Start('rp.SetOrgMoTD')
						net.WriteString(newMoTD)
						net.SendToServer()
						motd = newMoTD
						fr.PopulateMoTD()
					end

					s:SetText("Изменить Новости")
				else
					fr.overMoTD = ui.Create('DTextEntry', function(txt)
						txt:SetPos(fr.txtMoTD.x, fr.lblMoTD:GetTall())
						txt:SetSize(fr.txtMoTD:GetSize())
						txt:SetMultiline(true)
						txt:SetValue(motd)
						txt:SetFont('rp.ui.22')
						txt:RequestFocus()
					end, fr.colRight)

					s:SetText("Готово")
				end
			end
		end, fr.colRight)
	end

	if (perms.Invite) then
		fr.btnInv = ui.Create('DButton', function(self)
			self:SetText("Пригласить")
			self:SetTall(25)
			self:DockMargin(0, 5, 0, 0)
			self:Dock(BOTTOM)

			self.Think = function(s)
				s:SetDisabled(IsValid(fr.overMem))
			end

			self.DoClick = function(s)
				if (IsValid(fr.overMemInv)) then
					fr.overMemInv:Remove()
					s:SetText("Приглашение")
				else
					fr.overMemInv = ui.Create('ui_listview', function(scr)
						scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
						scr:SetSize(fr.listMem:GetSize())
						local none = true

						for k, v in ipairs(player.GetAll()) do
							if (not v:GetOrg()) then
								local btn = scr:AddRow(v:Name())

								btn.DoClick = function(s)
									rp.RunCommand('orginvite', v:SteamID64())
									s:Remove()
								end

								none = false
							end
						end

						if (none) then
							scr:AddRow('Нет доступных игроков!', true)
						end
					end, fr.colLeft)

					s:SetText("Назад")
				end
			end
		end, fr.colLeft)
	end

	if (perms.Kick) then
		if (perms.Rank) then
			fr.btnEdit = ui.Create('DButton', function(self)
				self:SetText("Редактировать участника")
				self:SetTall(25)
				self:DockMargin(0, 5, 0, 0)
				self:Dock(BOTTOM)

				self.Think = function(s)
					local sel = fr.listMem:GetSelected()

					if (IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight) then
						s:SetDisabled(true)
					else
						s:SetDisabled(false)
					end
				end

				self.DoClick = function(s)
					if (IsValid(fr.overMem)) then
						fr.overMem:Remove()
						s:SetText("Редактировать участника")
					else
						local sel = fr.listMem:GetSelected()

						fr.overMem = ui.Create('ui_scrollpanel', function(scr)
							scr:SetPos(fr.listMem.x, fr.lblMem:GetTall())
							scr:SetSize(fr.listMem:GetSize())

							scr.Paint = function(s, w, h)
								surface.SetDrawColor(200, 200, 200)
								surface.DrawRect(0, 0, w, h)
							end

							scr.lblName = ui.Create('DButton', function(btn)
								btn:SetText(sel.Player.Name)
								btn:SetDisabled(true)
								btn:Dock(TOP)
								scr:AddItem(btn)
							end)

							scr.btnKick = ui.Create('DButton', function(btn)
								btn:SetText("Выгнать")
								btn.TextColor = rp.col.Red
								btn:Dock(TOP)
								scr:AddItem(btn)

								btn.Think = function(s)
									if (s.CoolDown) then
										if (SysTime() > s.CoolDown + 2) then
											s:SetText("Выгнать")
											s.CoolDown = nil
										end
									end
								end

								btn.DoClick = function(s)
									if (not s.CoolDown) then
										s.CoolDown = SysTime()
										s:SetText("Подтвердите")
									else
										rp.RunCommand('orgkick', sel.Player.SteamID)
										if IsValid(fr.btnEdit) then
											fr.btnEdit:DoClick()
										end

										sel:Remove()
									end
								end
							end)

							scr.btnRank = ui.Create('DButton', function(btn)
								btn:SetText("Изменить Ранг")
								btn:SetFont('rp.ui.18')
								scr:AddItem(btn)

								btn.DoClick = function(s)
									local m = ui.DermaMenu()
									local num = 0

									for k, v in ipairs(orgranks) do
										if (v.Weight < perms.Weight and v.Name ~= sel.Player.Rank) then
											num = num + 1

											m:AddOption(v.Name, function()
												rp.RunCommand('orgsetrank', sel.Player.SteamID, v.Name)
												sel.Player.Rank = v.Name
												fr.PopulateMembers(sel.Player.SteamID)
												sel = fr.listMem:GetSelected()
											end)
										end
									end

									if (num >= 1) then
										m:Open()
									else
										m:Remove()
									end
								end
							end)
						end, fr.colLeft)

						s:SetText("Назад")
					end
				end
			end, fr.colLeft)
		else
			fr.btnKick = ui.Create('DButton', function(self)
				self:SetText("Выгнать")
				self:SetTall(25)
				self:DockMargin(0, 5, 0, 0)
				self:Dock(BOTTOM)
				self.TextColor = rp.col.Red

				self.Think = function(s)
					local sel = fr.listMem:GetSelected()

					if (IsValid(fr.overMemInv) or not IsValid(sel) or not sel.Player or sel.Player.SteamID == LocalPlayer():SteamID64() or sel.Player.Weight >= perms.Weight) then
						s:SetDisabled(true)
					else
						s:SetDisabled(false)
					end

					if (s.CoolDown) then
						if (SysTime() > s.CoolDown + 2) then
							s:SetText("Выгнать")
							s.CoolDown = nil
						end
					end
				end

				self.DoClick = function(s)
					if (not s.CoolDown) then
						s.CoolDown = SysTime()
						s:SetText("Подтвердите")
					else
						local sel = fr.listMem:GetSelected()
						rp.RunCommand('orgkick', sel.Player.SteamID)
						sel:Remove()
						s.CoolDown = 0
					end
				end
			end, fr.colLeft)
		end
	end

	fr.btnEdit = ui.Create('DTextEntry', function(self)
		self:SetText("Поиск по SteamID")
		self:SetPlaceholderText("Поиск по SteamID")
		self:SetTall(25)
		self:DockMargin(0, 5, 0, 0)
		self:Dock(BOTTOM)

		self.OnEnter = function(s)
			local children 	= fr.listMem:GetChildren()[1]:GetChildren()
			local steamid 	= util.SteamIDTo64(self:GetValue())

			for _, line in pairs(children) do
				if line.Player and line.Player.SteamID == steamid then
					line.DoClick()
					return
				end
			end
		end
	end, fr.colLeft)

	--------------------------------------------
	-- Patented quit button
	--------------------------------------------
	fr.btnQuit = ui.Create('DButton', function(self)
		self:SetText(perms.Owner and 'Распустить' or 'Покинуть')
		self:SizeToContents()
		self:SetSize(self:GetWide() + 10, fr.btnClose:GetTall())
		self:SetPos(fr.btnClose.x - self:GetWide() + 1, 0)

		self.DoClick = function(s)
			local str = perms.Owner and 'Распутить организацию?' or 'Покинуть организацию?'
			local str2 = perms.Owner and 'Вы уверены что хотите распутить ' .. LocalPlayer():GetOrg() .. '? Напишите DISBAND если вы согласны.' or 'Вы действительно хотите покинуть организацию ' .. LocalPlayer():GetOrg() .. '? Напишите QUIT если да.'

			ui.StringRequest(str, str2, '', function(resp)
				local ismatch = (perms.Owner and resp:lower() == 'disband') or (not perms.Owner and resp:lower() == 'quit')

				if (ismatch) then
					fr:Close()
					rp.RunCommand('quitorg')
				end
			end)
		end
	end, fr)
end)

hook('PopulateF4Tabs', function(frs, fr)
	frs:AddButton('Организации', function()
		fr:Close()

		if (LocalPlayer():GetOrg() == nil) then
			ui.StringRequest('Создать Организацию', 'Хотите создать Организацию, стоимость: ' .. rp.FormatMoney(rp.cfg.OrgCost) .. '?\n Напишите название вашей Организации.', '', function(resp)
				rp.RunCommand('createorg', resp)
			end)
		else
			rp.RunCommand('orgmenu')
		end
	end)
end)


net.Receive('rp.SetOrgBannerDefault', function()
	rp.orgs.OpenOrgBannerEditor(perms)
end)

function rp.orgs.GetBanner(orgName, options)
	if (rp.orgs.Banners[orgName]) then
		if (rp.orgs.Banners[orgName] == 2) then return wmat.Get('OrgBanner.' .. orgName) end
	else
		rp.orgs.LoadBanner(orgName, options)
	end
end

local function url_encode(data)
	local ndata = string.gsub(data, "[^%w _~%.%-]", function(str)
		local nstr = string.format("%X", string.byte(str))
		return "%" .. ((string.len(nstr) == 1) and "0" or "") .. nstr
	end)

	return string.gsub(ndata, " ", "+")
end

function rp.orgs.LoadBanner(orgName, options)
	if not orgName then return end
	wmat.Delete('OrgBanner.' .. orgName)

	http.Fetch(rp.cfg.OrgBannerUrl .. '&org=' .. url_encode(orgName), function(data)
		if not data or string.find(data, 'DOCTYPE HTML') or data == 'https://urf.im/urflogo.png' then
			data = rp.cfg.DefaultOrgBanners[1]
		end

		options = options or {}

		options.URL = data
		options.W = 128
		options.H = 128
		options.Timeout = 60

		wmat.Create('OrgBanner.' .. orgName, options, function(material)
			rp.orgs.Banners[orgName] = 2
		end, function()
			rp.orgs.Banners[orgName] = nil
		end)

	end, function()
		rp.orgs.Banners[orgName] = nil
	end)

	rp.orgs.Banners[orgName] = 1
end

net('rp.OrgBannerInvalidate', function(len)
	local orgName = net.ReadString()
	rp.orgs.Banners[orgName] = nil
end)