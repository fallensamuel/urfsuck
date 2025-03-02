if SERVER then
	util.AddNetworkString('rp.Motd')
	rp.AddCommand('/motd', function(pl, text, args)
		net.Start('rp.Motd')
		net.Send(pl)
	end)
else
	net('rp.Motd', function()
		rp.Motd()
	end)
	
	local fr

	function rp.Motd()
		if IsValid(fr) then return end
		
		fr = ui.Create('ui_frame', function(self)
			self:SetTitle(translates and translates.Get('Справочник') or 'Справочник')
			self:SetSize(300,35)
			self:MakePopup()
			self:Center()
			local keydown = false

			function self:Think()
				if input.IsKeyDown(KEY_F1) and keydown then
					self:Close()
				elseif (not input.IsKeyDown(KEY_F1)) then
					keydown = true
				end
			end
		end)

		fr.panel = ui.Create('DPanel', function(panel, p)
			panel:Dock(FILL)
			for k,v in pairs(rp.cfg.MoTD) do
				ui.Create('DButton', function(button)
					button:SetPos(0, (k-1)*24)
					button:SetSize(fr:GetWide()-10, 25)
					button:SetText(v[1])
					button:SetFont('ui.24')
					button:SetTextColor(ui.col.White)
					button.DoClick = function()
						gui.OpenURL(v[2])
					end
				end, panel)
				fr:SetTall(fr:GetTall()+24)
			end
		end, fr)

	end
end