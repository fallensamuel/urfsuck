function rp.UnlockTeam(iTeam)
	net.Start('rp.UnlockTeam')
		net.WriteInt(iTeam, 10)
	net.SendToServer()
end

function rp.OpenEmployerMenu(f)
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
		self:SetTitle(rp.Factions and rp.Factions[f] and rp.Factions[f].printName or "")
		self:Center()
		self:MakePopup()
	end)

	ui.Create('rp_faction_jobslist', function(self, p)
		self:SetFaction(f)
		self:SetPos(5, 25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)
	end, fr)
end