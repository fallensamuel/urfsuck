include'shared.lua'

function ENT:Draw()
	self:DrawModel()
end
/*
function rp.DisguiseMenu()
	local ent = net.ReadEntity()
	local faction = net.ReadInt(8)

	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
		self:SetTitle('Disguise')
		self:Center()
		self:MakePopup()
	end)

	ui.Create('rp_jobslist', function(self, p)
	    self.DAppearancePanel.ControlPanel.SaveBtn:SetCustomText( translates and translates.Get( 'Замаскироваться' ) or 'Замаскироваться' );

		self:SetPos(5, 25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)

		self.DAppearancePanel.ControlPanel.SaveBtn.DoClick = function()
			net.Start('DisguiseToServer')
			net.WriteEntity(ent)
			net.WriteUInt(self.DAppearancePanel.JobData.team, 9)
			net.SendToServer()
			fr:Close()
		end

		for k, v in pairs(rp.Factions[faction] and rp.Factions[faction].jobsMap or {}) do
			if LocalPlayer():CanTeam(rp.TeamByID(v)) then
				if rp.TeamByID(v).disableDisguise then continue end
				self:AddJob(v)
			end
		end
	end, fr)
end
*/
net.Receive('DisguiseMenu', rp.DisguiseMenu)
/*
function rp.DisguiseMenuF4()
	local faction = LocalPlayer():GetTeamTable().disguise_faction

	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
		self:SetTitle('Disguise')
		self:Center()
		self:MakePopup()
	end)

	ui.Create('rp_jobslist', function(self, p)
	    self.DAppearancePanel.ControlPanel.SaveBtn:SetCustomText( translates and translates.Get( 'Замаскироваться' ) or 'Замаскироваться' );

		self:SetPos(5, 25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)

		self.DAppearancePanel.ControlPanel.SaveBtn.DoClick = function()
			net.Start('PlayerDisguise')
			net.WriteUInt(self.DAppearancePanel.JobData.team, 9)
			net.SendToServer()

			fr:Close()
		end

		for k, v in pairs(rp.Factions[faction] and rp.Factions[faction].jobsMap or {}) do
			if LocalPlayer():CanTeam(rp.TeamByID(v)) then
				if rp.TeamByID(v).disableDisguise then continue end
				self:AddJob(v)
			end
		end
	end, fr)
end
*/