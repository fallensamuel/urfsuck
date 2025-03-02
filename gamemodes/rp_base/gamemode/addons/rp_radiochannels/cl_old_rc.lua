
if rp.cfg.DisableContextRedisign then 
	local function radioCanUse()
		return rp.RadioChanels and rp.RadioChanels[LocalPlayer():Team()]
	end

	local function radioSwitch(mode)
		if mode ~= 'Speak' and mode ~= 'Hear' then return end
		
		net.Start('RC_RadioSwitch' .. mode)
		net.SendToServer()
		
		surface.PlaySound("sound/npc/overwatch/radiovoice/off4.wav")
	end


	function rp.IsRadioTransmiting()
		return LocalPlayer():GetNetVar('RC_RadioOnSpeak') or false
	end

	function rp.IsRadioReceiving()
		return LocalPlayer():GetNetVar('RC_RadioOnHear') or false
	end


	----- F4 radio menu -----
	PANEL = {}
	function PANEL:Init()
		local can_speak = rp.IsRadioTransmiting()
		local can_hear  = rp.IsRadioReceiving()
		
		local Hat = ui.Create('DPanel', self)
			Hat:Dock(TOP)
			Hat:DockMargin(15, 15, 15, 15)
			Hat:SetSize(0, 80)
			
		self.RadioBtn1 = ui.Create('DButton', Hat)
			self.RadioBtn1:Dock(LEFT)
			self.RadioBtn1:DockMargin(30, 10, 10, 40)
			self.RadioBtn1:SetSize(200, 0)
			self.RadioBtn1:SetText(can_hear and 'Выключить приём' or 'Включить приём')
			
			self.RadioBtn1.DoClick = function()
				radioSwitch('Hear')
				
				local IsROff = self.RadioBtn1:GetText() == 'Включить приём'
				
				self.RadioBtn1:SetText(IsROff and 'Выключить приём' or 'Включить приём')
				self.RadioInfo1:SetText(IsROff and 'Вы слышите людей в списке' or 'Вы не слышите рацию')
			end
			
		self.RadioBtn2 = ui.Create('DButton', Hat)
			self.RadioBtn2:Dock(RIGHT)
			self.RadioBtn2:DockMargin(10, 10, 30, 40)
			self.RadioBtn2:SetSize(200, 0)
			self.RadioBtn2:SetText(can_speak and 'Выключить передачу' or 'Включить передачу')
			
			self.RadioBtn2.DoClick = function()
				radioSwitch('Speak')
				
				local IsROff = self.RadioBtn2:GetText() == 'Включить передачу'
				
				self.RadioBtn2:SetText(IsROff and 'Выключить передачу' or 'Включить передачу')
				self.RadioInfo2:SetText(IsROff and 'Вас слышат люди в списке' or 'Вас не слышно')
			end
			
			
		self.RadioInfo1 = ui.Create('DLabel', Hat)
			self.RadioInfo1:SetText(can_hear and 'Вы слышите людей в списке' or 'Вы не слышите рацию')
			self.RadioInfo1:SetContentAlignment(2)
			self.RadioInfo1:SetSize(200, 58)
			self.RadioInfo1:SetFont('rp.ui.18')
			
		self.RadioInfo2 = ui.Create('DLabel', Hat)
			self.RadioInfo2:SetText(can_speak and 'Вас слышат люди в списке' or 'Вас не слышно')
			self.RadioInfo2:SetContentAlignment(2)
			self.RadioInfo2:SetSize(200, 58)
			self.RadioInfo2:SetFont('rp.ui.18')
			
			
		self._Body = ui.Create('DPanel', self)
			self._Body:Dock(FILL)
			self._Body:DockMargin(15, 0, 15, 15)
			self._Body:SetSize(0, 50)
			
		self.Body = ui.Create('ui_listview', self._Body)
			self.Body.Paint = function() end
			self.Body:Dock(FILL)
	end

	function PANEL:PerformLayout()
		self.RadioInfo1:SetPos(self.RadioBtn1:GetPos())
		self.RadioInfo2:SetPos(self.RadioBtn2:GetPos())
		
		if #self.Body:GetChildren()[1]:GetChildren() > 0 then return end
		
		local teams = rp.RadioChanels[LocalPlayer():Team()]
		local lab_x = self._Body:GetWide()
		local count = 0
		
		if teams then
			self.TeamLabs = {}
			
			for _, v in ipairs(player.GetAll()) do
				if teams[v:Team()] then
					local TempPl = ui.Create('DPanel', self.Body)
						TempPl:SetSize(lab_x - 10, 60)
						TempPl:SetPos(5, 5 + 65 * count)
						
					local TempImg = ui.Create('ui_avatarbutton', TempPl)
						TempImg:SetPlayer(v)
						TempImg:SetPos(5, 5)
						TempImg:SetSize(50, 50)
					
					local TempName = ui.Create('DLabel', TempPl)
						TempName:SetPos(65, 10)
						TempName:SetText(v:GetName())
						TempName:SetSize(300, 20)
					
					local TempTeam = ui.Create('DLabel', TempPl)
						TempTeam:SetPos(65, 30)
						TempTeam:SetText(team.GetName(v:Team()))
						TempTeam:SetColor(team.GetColor(v:Team()))
						TempTeam:SetSize(300, 20)
						TempTeam:SetFont('rp.ui.18')
					
					local MuteBtn = ui.Create('DImageButton', TempPl)
						MuteBtn:SetImage(v:IsMuted() and 'icon32/muted.png' or 'icon32/unmuted.png')
						MuteBtn:Dock(RIGHT)
						MuteBtn:DockMargin(15, 15, 15, 15)
						MuteBtn:SetSize(35, 35)
						
						MuteBtn.DoClick = function()
							MuteBtn:SetImage(v:IsMuted() and 'icon32/unmuted.png' or 'icon32/muted.png')
							v:SetMuted(v:IsMuted() == false)
						end
					
					count = count + 1
					self.Body:AddItem(TempPl)
				end
			end
		else
			self.RadioList = ui.Create('DLabel', self._Body)
				self.RadioList:SetText('В этом канале никого нет.')
				self.RadioList:SetContentAlignment(5)
				self.RadioList:Dock(FILL)
		end
	end

	--vgui.Register('rp_rclist', PANEL, 'Panel')
	--hook.Add('PopulateF4Tabs', function(tabs)
	--	tabs:AddTab('Рация', ui.Create('rp_rclist'))
	--end)


	----- Channels activate/deactivate sound -----
	local channels = rp.RadioChanels
	hook.Add('PlayerStartVoice', 'rp.RadioStart', function(ply)
		if not IsValid(LocalPlayer()) or not IsValid(ply) then return end
		
		if LocalPlayer():Team() and ply:Team() and channels[LocalPlayer():Team()] and channels[LocalPlayer():Team()][ply:Team()] and ply:GetNetVar('RC_RadioOnSpeak') then
			sound.PlayFile("sound/npc/overwatch/radiovoice/off4.wav", "", function(station ) if ( IsValid( station ) ) then station:Play()  station:SetVolume(0.3) end end)
		end
	end)

	hook.Add('PlayerEndVoice', 'rp.RadioEnd', function(ply)
		if channels[LocalPlayer():Team()] and channels[LocalPlayer():Team()][ply:Team()] and ply:GetNetVar('RC_RadioOnSpeak') then
			sound.PlayFile("sound/weapons/radiooperator/targetacquired.mp3", "", function(station ) if ( IsValid( station ) ) then station:Play()  station:SetVolume(0.3) end end)
		end
	end)


	----- Context menu actions -----
	radiocpanel_fr = radiocpanel_fr or nil

	hook('OnContextMenuOpen', function()
		local isRadio = radioCanUse()
		radiocpanel_fr:SetVisible(isRadio)
		
		if isRadio then
			radiocpanel_fr.B1:SetText((rp.IsRadioReceiving() and 'Выключить' or 'Включить') .. ' приём рации')
			
			radiocpanel_fr.B2:SetDisabled(!rp.RadioSpeakers[LocalPlayer():Team()])
			radiocpanel_fr.B2:SetText((rp.IsRadioTransmiting() and 'Выключить' or 'Включить') .. ' передачу рации')
		end
	end)

	hook('ContextMenuCreated', function(cont)
		radiocpanel_fr = ui.Create('ui_frame', function(self)
			self:SetPos(ScrW() / 2 - 150,  ScrH() - 103 - 5)
			self:SetSize(300, 103)
			self:ShowCloseButton(false)
			self:SetTitle('Рация')
		end, cont)
		
		radiocpanel_fr.B1 = ui.Create('DButton', function(self)
			self:SetPos(5, 33)
			self:SetSize(290, 30)
			self.DoClick = function()
				radioSwitch('Hear')
				self:SetText((self:GetText() == 'Включить приём рации' and 'Выключить' or 'Включить') .. ' приём рации')
			end
		end, radiocpanel_fr)
		
		radiocpanel_fr.B2 = ui.Create('DButton', function(self)
			self:SetPos(5, 68)
			self:SetSize(290, 30)
			self.DoClick = function()
				radioSwitch('Speak')
				self:SetText((self:GetText() == 'Включить передачу рации' and 'Выключить' or 'Включить') .. ' передачу рации')
			end
		end, radiocpanel_fr)
	end)
end