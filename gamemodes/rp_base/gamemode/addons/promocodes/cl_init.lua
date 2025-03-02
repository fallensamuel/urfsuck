-- "gamemodes\\rp_base\\gamemode\\addons\\promocodes\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add("CreditsMenuOpened", function(fr)
	fr.Promocode = fr.Promocode or ui.Create("DButton", function(self)
		self:SetText(translates and translates.Get("Промокод") or "Промокод")

		self.DoClick = function(s)
			ui.StringRequest(translates and translates.Get("Промокод") or "Промокод", translates and translates.Get("Введите промокод") or 'Введите промокод', '', function(a)
				rp.RunCommand('usepromocode', a)
				fr:Close()
			end)
		end
		
		--self:SetBackgroundColor(Color(0,200,0, 150))
		self:SizeToContents()
		self:SetSize(self:GetWide() + 10, fr.btnClose:GetTall())
		self:SetPos(fr.SkinPurchaseBtn.x - self:GetWide() + 1, 0)
	end, fr)
end)