ba.AddTerm('StaffReqSent', 'Жалоба отправлена!')
ba.AddTerm('StaffReqPend', 'У вас уже есть активная Жалоба!')
ba.AddTerm('StaffReqLonger', 'Пожалуйста опишите причину (<10+ букв)!')
ba.AddTerm('AdminTookPlayersRequest', '# ответил на Жалобу #.')
ba.AddTerm('AdminTookYourRequest', '# откликнулся на вашу жалобу и скоро с вами свяжется.')
ba.AddTerm('AdminClosedPlayersRequest', '# отклонил Жалобу #(а)')
ba.AddTerm('AdminClosedYourRequest', '# отклонил вашу Жалобу.')

if (SERVER) then
	util.AddNetworkString 'ba.AdminChat'
	util.AddNetworkString 'ba.AdminChatDelayed'
	util.AddNetworkString 'ba.GetStaffRequest'
	util.AddNetworkString 'ba.PurgeStaffRequests'
	
	function PLAYER:HasStaffRequest()
		return (self:GetBVar('StaffRequest') and (CurTime() - self:GetBVar('StaffRequestTime') < 600))
	end

	hook.Add('PlayerSay', 'ba.AdminChat', function(pl, text)
		if (text[1] == '@') then
			if (hook.Call('PlayerCanUseAdminChat', ba, pl) ~= false) then
				text = text:sub(2):Trim()
				
				if pl:HasStaffRequest() then
					ba.notify_err(pl, ba.Term('StaffReqPend'))
				elseif (not pl:IsAdmin() and text:len() < 10) then
					ba.notify_err(pl, ba.Term('StaffReqLonger'))
				else
					net.Start('ba.AdminChat')
						net.WriteEntity(pl)
						net.WriteString(pl:SteamID())
						net.WriteString(text)
						net.WriteFloat(CurTime())
					net.Send(ba.GetStaff())
					
					if (not pl:IsAdmin()) then
						ba.notify(pl, ba.Term('StaffReqSent'))
						pl:SetBVar('StaffRequest', true)
						pl:SetBVar('StaffRequestReason', text)
						pl:SetBVar('StaffRequestTime', CurTime())
						
						hook.Call("PlayerSitRequestOpened", GAMEMODE, pl, text)
					end
				end
				
				return ''
			end
		end
	end)
	
	hook.Add('playerRankLoaded', 'ba.NetworkRequests', function(pl)
		if pl:IsAdmin() then 
			for k, v in ipairs(player.GetAll()) do
				if v:HasStaffRequest() then
					net.Start('ba.AdminChatDelayed')
						net.WriteUInt(v:EntIndex(), 8)
					net.Send(pl)
				end
			end
		end
	end)
	
	hook.Add('PlayerDisconnected', 'ba.PurgeStaffRequests', function(pl)
		if (pl:HasStaffRequest()) then
			net.Start('ba.PurgeStaffRequests')
				net.WriteString(pl:SteamID())
			net.Send(ba.GetStaff())
		end
	end)
	
	net.Receive('ba.GetStaffRequest', function(len, pl)
		local targ = net.ReadEntity()
		
		if (!IsValid(targ) or !pl:IsAdmin() or !targ:HasStaffRequest()) then return end
		
		net.Start('ba.AdminChat')
			net.WriteEntity(targ)
			net.WriteString(targ:SteamID())
			net.WriteString(targ:GetBVar('StaffRequestReason'))
			net.WriteFloat(targ:GetBVar('StaffRequestTime'))
		net.Send(pl)
	end)
else
	local c1 = cvar.Register('AdminChatSound')
		c1:SetDefault(true)
		c1:AddMetadata('BAMenu', "Включить звуковое оповещение жалоб")
		c1:AddMetadata( "State", "RPMenu" )
		c1:AddMetadata( "Menu", "Включить звуковое оповещение жалоб" );
	local c2 = cvar.Register('AdminChatVis')
		c2:SetDefault(true)
		c2:AddMetadata('BAMenu', "Включить меню жалоб")
		c2:AddMetadata( "State", "RPMenu" )
		c2:AddMetadata( "Menu", "Включить меню жалоб" );
	
	
	local dont_notify_about_menues = false
	local function notify_panel(str, is_admin_chat)
		local fr = ui.Create('ui_frame', function(self)
			self:SetSize(520, 120)
			self:SetTitle(translates and translates.Get("Отключенный интерфейс") or 'Отключенный интерфейс')
			self:MakePopup()
			self:Center()
			self:RequestFocus()
		end)
		
		ui.Create('DLabel', function(self, p) 
			self:SetText(translates and translates.Get("У вас выключено отображение %s.", str) or "У вас выключено отображение " .. str .. ".")
			self:SetFont('ba.ui.24')
			self:SetTextColor(ui.col.Close)
			self:SizeToContents()
			self:SetPos((p:GetWide() - self:GetWide()) / 2, 36)
		end, fr)
		ui.Create('DLabel', function(self, p) 
			self:SetText(translates and translates.Get("Зайдите в настройки, чтобы включить его.") or "Зайдите в настройки, чтобы включить его.")
			self:SetFont('ba.ui.20')
			self:SetTextColor(ui.col.Close)
			self:SizeToContents()
			self:SetPos((p:GetWide() - self:GetWide()) / 2, 58)
		end, fr)

		ui.Create('DButton', function(self, p)
			self:SetText(translates and translates.Get("Ок") or 'Ок')
			self:SetPos(5, 90)
			self:SetSize(p:GetWide()/2 - 7.5, 25)
			function self:DoClick()
				p:Close()
			end
			self.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
		end, fr)
		
		ui.Create('DButton', function(self, p)
			self:SetText(translates and translates.Get("Не напоминать") or 'Не напоминать')
			self:SetPos(p:GetWide()/2 + 2.5, 90)
			self:SetSize(p:GetWide()/2 - 7.5, 25)
			function self:DoClick()
				dont_notify_about_menues = true
				p:Close()
			end
			self.Paint = function(btn, w, h)
				derma.SkinHook('Paint', 'TabButton', btn, w, h)
			end
		end, fr)

--[[
		local pnl = rpui.BoolRequest(translates.Get("Отключенный интерфейс"), translates.Get("У вас выключено отображение %s.", str), "rpui/misc/alarm.png", 1.5, function()
			cvar.SetValue(is_admin_chat and "AdminChatVis" or "dont_show_chat", true)
		end, function()
        	dont_notify_about_menues = true
        end)

        local str2 = translates.Get("Нажмите кнопку слева, чтобы включить его.")

		local colorwhite = Color(255, 255, 255)
		function pnl:PaintOver(w, h)
			draw.SimpleText(self.Title, self.OverInputTitleFont, w*0.5, h*0.45, colorwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(str2, self.OverInputTitleFont, w*0.5, h*0.45, colorwhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		pnl:SetTall(pnl:GetTall()*1.15)
		pnl.ok:SetText(translates.Get("Включить"))
		pnl.cancel:SetText(translates.Get("Не напоминать"))
]]--
	end
	
	gameevent.Listen( "player_spawn" )
	hook.Add( "player_spawn", "notify_about_disabled_menues", function( data ) 
		if IsValid(LocalPlayer()) and not dont_notify_about_menues and data.userid == LocalPlayer():UserID() then
			local cvar1, cvar2 = cvar.GetValue('dont_show_chat'), not cvar.GetValue('AdminChatVis')
			
			if cvar1 or cvar2 then
				hook.Add("PreDrawHUD", "DisableMenuesNotify", function()
				    if vgui.GetKeyboardFocus() or gui.IsGameUIVisible() then return end

				    if cvar1 then
						notify_panel("Чата")
						cvar1 = false
					elseif cvar2 then
						notify_panel("Меню жалоб", true)
						cvar2 = false
					else
						hook.Remove("PreDrawHUD", "DisableMenuesNotify")
					end
				end)
			end
		end
	end )
	
	local color_white = Color(235,235, 235)
	local fr
	local PANEL = {}
	function PANEL:Init()
		local w, h = chat.GetChatBoxSize()
		local x, y = chat.GetChatBoxPos()
		h = h * .75
		y = math.max(y - (h + 5), 15)
		
		--self._oldPaint = self.Paint
		--self.Paint = function(this, w, h)
		--	if cvar.GetValue('AdminChatVis') then
		--		self._oldPaint(this, w, h)
		--	end
		--end
		
		self.w, self.h = w * .5, h
		self.h3 = self.h * 1.5

		self.Requests = {}
		self.Visible = true

		self.btnMaxim:Remove()
		self.btnMinim:Remove()
		self.btnClose:Remove()
		
		self.lblTitle:SetText((translates and translates.Get('Жалобы') or 'Жалобы') .. ':')
		
		self.PlayerList = ui.Create('ui_scrollpanel', self)
		self.PlayerList:SetPadding(-1)

		self:SetSkin('bAdmin')
		self:SetDraggable(true)

		self:SetSize(self.w, self.h)
		self:SetPos(x, y)
	end

	function PANEL:PerformLayout()
		self.lblTitle:SizeToContents()
		self.lblTitle:SetPos(5, 4)

		self.PlayerList:SetPos(5, 32)
		self.PlayerList:SetSize(self.w - 10, self.h - 37)
	end

	function PANEL:ApplySchemeSettings()
		self.lblTitle:SetTextColor(ui.col.Close)
		self.lblTitle:SetFont('ba.ui.22')
	end

	function PANEL:SetStage(state)
		if (state == 1) then
			self:SizeTo(self.w, self.h, 0.175, 0, 0.25, cback)
		elseif (state == 2) then
			self:SizeTo(self.w * 2, self.h, 0.175, 0, 0.25, cback)
		else
			self:SizeTo(self.w * 2, self.h3, 0.175, 0, 0.25)
		end
	end
	
	function PANEL:Think()
		--self:SetVisible(cvar.GetValue('AdminChatVis'))
		--self.Visible = cvar.GetValue('AdminChatVis')
	end

	function PANEL:AddRequest(pl, msg, startTime)
		local pnl = ui.Create('ba_menu_player')
		pnl.SteamID = pl:SteamID()
		pnl:SetPlayer(pl)
		pnl:SetStartTime(startTime)
		pnl.Checkbox.DoClick = function()
			if (self.Player ~= pnl) then
				if (self.Player ~= nil and IsValid(self.Player)) then
					self.Player.Selected = false
				end
				self.Player = pnl
				pnl.Selected = true
				self:SetStage(2)
				self:OpenRequest(pnl.ID)
			else
				self.Player = nil
				pnl.Selected = false
				self:SetStage(1)
			end
			self.ID = pnl.ID
		end
		pnl.OT = pnl.Think
		pnl.Think = function(s)
			if (not self.Requests[s.ID]) or (CurTime() - startTime >= 600) then
				self:RemoveRequest(s.ID)
				return
			end
			
			--pnl:SetVisible(cvar.GetValue('AdminChatVis'))
			
			s:OT()
		end
		--pnl._oldPaint = pnl.Paint
		--pnl.Paint = function(this, w, h)
		--	if cvar.GetValue('AdminChatVis') then
		--		pnl._oldPaint(this, w, h)
		--	end
		--end
		self.PlayerList:AddItem(pnl)
		pnl.ID = #self.Requests + 1
		pnl.Message = msg
		self.Requests[pnl.ID] = pnl
	end

	function PANEL:RemoveRequest(id)
		self.Requests[id]:Remove()
		table.remove(self.Requests, id)
		self.Player = nil
		if (self.ID == id) then
			self:SetStage(1)
		end
		
		for k, v in ipairs(self.Requests) do
			v.ID = k
		end
	end

	function PANEL:OpenRequest(id)
		if IsValid(self.CurRequest) then self.CurRequest:Remove() end

		local pnl = self.Requests[id]
		if not IsValid(pnl) then return end

		self.CurRequest = ui.Create('ui_panel', function(s, p)
			s:SetPos(self.w, 32)
			s:SetSize(self.w - 5, self.h - 37)
		end, self)
		ui.Create('DButton', function(s, p)
			s:SetPos(5, 5)
			s:SetSize(p:GetWide() * .5 - 7.5, 25)
			s:SetText(translates and translates.Get("Ответить") or 'Ответить')
			s.DoClick = function()
				if (IsValid(pnl.Player)) then
					RunConsoleCommand('urf', 'Treq', pnl.Player:SteamID())
				end
			end
		end, self.CurRequest)
		ui.Create('DButton', function(s, p)
			s:SetPos(p:GetWide() * .5 + 2.5, 5)
			s:SetSize(p:GetWide() * .5 - 7.5, 25)
			s:SetText(translates and translates.Get("Закрыть") or 'Закрыть')
			s.DoClick = function()
				if (IsValid(pnl.Player)) then
					RunConsoleCommand('urf', 'Rreq', pnl.Player:SteamID())
				end
			end
		end, self.CurRequest)

		ui.Create('DButton', function(s, p)
			s:SetPos(5, 35)
			s:SetSize(p:GetWide() - 10, 25)
			s:SetText(translates and translates.Get("Копировать SteamID") or 'Копировать SteamID')
			s.DoClick = function()
				SetClipboardText(pnl.Player:SteamID())
				LocalPlayer():ChatPrint((translates and translates.Get("Скопировано") or 'Скопировано') .. '!')
			end
		end, self.CurRequest)

		local l = ba.ui.Label(pnl.Message, self.CurRequest, {font = 'ba.ui.22', color = ui.col.Close, wrap = true})
		l:SetSize(pnl:GetWide() - 10, pnl:GetTall() - 70)
		l:SetPos(5, 65)
	end
	vgui.Register('ba_adminchat', PANEL, 'DFrame')

	local staffRequestQueue = {}
	hook.Add('Think', 'AdminChat.Think', function()
		if IsValid(fr) then
			if not cvar.GetValue('AdminChatVis') then
				fr.Visible = false
				fr:SetVisible(fr.Visible)
				return
			end
			
			if (#fr.Requests <= 0) and fr.Visible then
				fr.Visible = false
				fr:SetVisible(fr.Visible)
			elseif (#fr.Requests > 0) and (not fr.Visible) then
				fr.Visible = true
				fr:SetVisible(fr.Visible)
			end
		end
		
		for k, v in ipairs(staffRequestQueue) do
			local pl
			if (type(v) == 'string') then
				pl = ba.FindPlayer(v)
			else
				pl = ents.GetByIndex(v)
			end
			
			if (IsValid(pl)) then
				net.Start('ba.GetStaffRequest')
					net.WriteEntity(pl)
				net.SendToServer()
			
				table.remove(staffRequestQueue, k)
				
				return
			end
		end
	end)
	
	net.Receive('ba.PurgeStaffRequests', function()
		if (!IsValid(fr)) then return end
		
		local stid = net.ReadString()
		for k, v in ipairs(fr.Requests) do
			if (v.SteamID == stid) then
				fr:RemoveRequest(k)
			end
		end
	end)

	concommand.Add("~suppress_adminchat", function()
		if LocalPlayer():IsRoot() then
			_SupressAdminChat = not _SupressAdminChat
		end
	end)

	net.Receive('ba.AdminChat', function()
		if _SupressAdminChat then return end
		fr = fr or ui.Create('ba_adminchat')
		local pl = net.ReadEntity()
		local stid = net.ReadString()
		if IsValid(pl) then
			if (pl:IsAdmin()) then
				local msg = net.ReadString()
				
				if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end

				if CHATBOX and not ispanel(CHATBOX) then -- В новом чатбоксе это говно не нужно
					chat.AddText(ui.col.SUP, '[' .. (translates and translates.Get("Админ Чат") or "Админ Чат") .. '] ', pl, color_white, ': ', msg)
				else
					chat.AddText(Color(255,100,100), '| ', ui.col.SUP, '[' .. (translates and translates.Get("Админ Чат") or "Админ Чат") .. '] ', pl, color_white, ': ', msg)
				end

				hook.Call("PlayerUseAdminChat", GAMEMODE, pl, msg)
			elseif IsValid(fr) then
				fr:AddRequest(pl, net.ReadString(), net.ReadFloat())

				if (not pl:IsAdmin()) and cvar.GetValue('AdminChatSound') and not rp.cfg.DisableAdminChatSound then
					surface.PlaySound('funmania/req.wav')
				end
			end
		else
			table.insert(staffRequestQueue, stid)
		end
	end)
	
	net.Receive('ba.AdminChatDelayed', function()
		table.insert(staffRequestQueue, net.ReadUInt(8))
	end)
	
	concommand.Add('adr', function(pl, cmd, args)
		fr = fr or ui.Create('ba_adminchat')
		fr:AddRequest(pl, table.concat(args, ' '), CurTime())
	end)
	
	concommand.Add('rer', function(pl, cmd, args)
		fr = fr or ui.Create('ba_adminchat')
		local id = tonumber(args[1] or 0)
		
		if (!fr.Requests[id]) then return end
		
		fr:RemoveRequest(id)
	end)
end

ba.cmd.Create('Treq', function(pl, args)
	if args.target:HasStaffRequest() then
		net.Start 'ba.PurgeStaffRequests'
			net.WriteString(args.target:SteamID())
		net.Send(ba.GetStaff())
		ba.notify_staff(ba.Term('AdminTookPlayersRequest'), pl, args.target)
		ba.notify(args.target, ba.Term('AdminTookYourRequest'), pl)
		
		ba.logAction(pl, args.target, 'admin_request', args.target:GetBVar('StaffRequestReason') or 'unknown')
		
		args.target:SetBVar('StaffRequest', nil)
		args.target:SetBVar('StaffRequestReason', nil)
		args.target:SetBVar('StaffRequestTime', nil)
		
		
		hook.Call("PlayerSitRequestTaken", GAMEMODE, args.target, pl)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Takes an admin request')


ba.cmd.Create('Rreq', function(pl, args)
	if args.target:HasStaffRequest() then
		net.Start 'ba.PurgeStaffRequests'
			net.WriteString(args.target:SteamID())
		net.Send(ba.GetStaff())
		ba.notify_staff(ba.Term('AdminClosedPlayersRequest'), pl, args.target)
		ba.notify(args.target, ba.Term('AdminClosedYourRequest'), pl)
		args.target:SetBVar('StaffRequest', nil)
		args.target:SetBVar('StaffRequestReason', nil)
		args.target:SetBVar('StaffRequestTime', nil)
		
		hook.Call("PlayerSitRequestClosed", GAMEMODE, args.target, pl)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Removes an admin rquest')