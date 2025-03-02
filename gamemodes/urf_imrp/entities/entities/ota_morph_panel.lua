AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ota Morpher Panel"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	util.AddNetworkString('OtaMorph::OpenPanel')
	
	function ENT:Initialize()
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		
		self:GetPhysicsObject():EnableMotion(false)
		
		timer.Simple(1, function()
			self:SetColor(Color(0, 0, 0, 0))
			self:SetRenderMode(RENDERMODE_NONE)
			self:DrawShadow(false)
		end)
	end
	
	local lastUse = 0
	function ENT:Use(ply)
		if lastUse < CurTime() then
			lastUse = CurTime() + 1
			
			net.Start('OtaMorph::OpenPanel')
			net.Send(ply)
		end
	end
else
	net.Receive('OtaMorph::OpenPanel', function()
		local ScrScale = ScrH()/1080
		
		local menu = vgui.Create("urf.im/rpui/menus/disguise")
		menu:SetSize(400*ScrScale, 800*ScrScale)
		menu:Center()
		menu:MakePopup()
		
		menu.header.SetIcon(menu.header, "shop/filters/list.png")
		menu.header.IcoSizeMult = 1.5
		menu.header.SetTitle(menu.header, "ЧИПИРОВАНИЕ")
		menu.header.SetFont(menu.header, "rpui.disguise.title")
		
		local faction = FACTION_OTA
		
		for k, v in pairs(rp.Factions[faction] and rp.Factions[faction].jobsMap or {}) do
			if rp.TeamByID(v).disableDisguise then continue end
			menu:AddElement(v)
		end
		
		menu._OldJobSelect = menu.JobSelect
		function menu:JobSelect(jobindex, jobname)
			menu:_OldJobSelect(jobindex, jobname)
			menu.SelectedJobIndex = jobindex
			
			if not LocalPlayer():TeamUnlocked(menu.SelectedJob) then
				menu.acceptbtn:SetText('СТОИМОСТЬ: ' .. rp.FormatMoney(menu.SelectedJob.unlockPrice))
				
			elseif not LocalPlayer():CanTeam(menu.SelectedJob) then
				menu.acceptbtn:SetText('ПРОФЕССИЯ НЕДОСТУПНА')
				
				local time_mode1 = menu.SelectedJob.unlockTime and (menu.SelectedJob.unlockTime - LocalPlayer():GetPlayTime()) or false
				local time_mode2 = menu.SelectedJob.minUnlockTime and (menu.SelectedJob.minUnlockTime - LocalPlayer():GetCustomPlayTime(menu.SelectedJob.minUnlockTimeTag)) or false
				
				if time_mode1 and time_mode1 > 0 or time_mode2 and time_mode2 > 0 then
					local time_mode = time_mode1 and (time_mode1 > (time_mode2 or 0))
					
					
					menu.acceptbtn.Think = function()
						local time = time_mode and (menu.SelectedJob.unlockTime - LocalPlayer():GetPlayTime()) or (menu.SelectedJob.minUnlockTime - LocalPlayer():GetCustomPlayTime(menu.SelectedJob.minUnlockTimeTag))
						
						menu.acceptbtn:SetText('ДОСТУПНО ЧЕРЕЗ ' .. ba.str.FormatTime(time))
					end
				end
			else
				menu.acceptbtn:SetText('ВЫБРАТЬ ПРОФЕССИЮ')
			end
			
			menu.acceptbtn.DoClick = function()
				if (IsValid(menu.AcceptItPls)) then return end
				
				if not LocalPlayer():TeamUnlocked(menu.SelectedJob) then
					if not LocalPlayer():CanAfford(menu.SelectedJob.unlockPrice) then
						return rp.Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))
					end
					
					menu.AcceptItPls = ui.Create('urf.im/rpui/menus/blank', function(aci)
						local fsz = {500, 200}
						aci:SetSize(fsz[1], fsz[2])
						aci:Center()
						aci:MakePopup()

						aci.header.SetIcon(aci.header, 'shop/filters/list.png')
						aci.header.SetTitle(aci.header, 'ПОДТВЕРДИТЕ')
						aci.header.SetFont(aci.header, 'rpui.playerselect.title')
						aci.header.IcoSizeMult = 1.5

						fsz = {217, 43}
						local btw, bth = fsz[1], fsz[2]
						fsz = {23, 18}

						local l = ui.Create('DLabel', function(txt, par)
							txt:SetPos(fsz[1], fsz[2])
							txt:SetContentAlignment(5)
							txt:SetFont('rpui.slidermenu.font')
							txt:SetSize(par:GetWide() - txt.x * 2, par:GetTall() * .7)
							
							txt:SetText('Разблокировать за ' .. rp.FormatMoney(menu.SelectedJob.unlockPrice) .. '?')
						end, aci)

						ui.Create('urf.im/rpui/button', function(bt, par)
							bt:SetText('РАЗБЛОКИРОВАТЬ')
							bt:SetPos(l.x, par:GetTall() - l.y - bth)
							bt:SetSize(btw, bth)
							bt:SetFont('rpui.createorg.font')
							bt.DoClick = function()
								rp.UnlockTeam( menu.SelectedJobIndex )
								if (IsValid(aci)) then aci:Close(); end
								
								timer.Simple(1, function()
									if IsValid(menu) and IsValid(menu.header.prev_btn) then
										menu.header.prev_btn.DoClick()
									end
								end)
							end
						end, aci)

						ui.Create('urf.im/rpui/button', function(bt, par)
							bt:SetText('ОТМЕНА')
							bt:SetPos(par:GetWide() - l.x - btw, par:GetTall() - l.y - bth)
							bt:SetSize(btw, bth)
							bt:SetFont('rpui.createorg.font')
							bt.DoClick = function()
								if (IsValid(aci)) then aci:Close(); end
							end
						end, aci)
					end)
				else
					if not LocalPlayer():CanTeam(menu.SelectedJob) then
						return
					end
					
					menu:AcceptClick(menu.SelectedJob, menu.SelectedJobIndex)
				end
			end
		end
		
		function menu:AcceptClick(job, jobindex)
			net.Start('OtaMorph::OpenPanel')
				net.WriteUInt(jobindex, 10)
				
				self.AppearanceID = 0
				
				net.WriteUInt( self.AppearanceID, 6 );
				net.WriteUInt( self.AppearanceSkin or 0, 6 );
				net.WriteFloat( self.AppearanceScale );
				
				local CustomAppearanceUID = self.AppearanceCustom[self.AppearanceModel];
				net.WriteBool( CustomAppearanceUID and true or false );
				net.WriteString( CustomAppearanceUID or "" );
				
				local bgroups = self.AppearanceBodygroups;
				local bgroups_keys  = table.GetKeys(bgroups);
				local bgroups_count = table.Count(bgroups);
				
				net.WriteUInt( bgroups_count, 6 );
				for i = 1, bgroups_count do
					local id = bgroups_keys[i];
					net.WriteUInt( id, 6 );
					net.WriteUInt( istable(bgroups[id]) and bgroups[id][1] or bgroups[id], 6 );
				end
			net.SendToServer();

			self:Close();
		end
	end)
end