
local function ChangeLaws()
	if not LocalPlayer():IsMayor() then return end

	local Laws = nw.GetGlobal("TheLaws") or rp.cfg.DefaultLaws

	local menu = vgui.Create("urf.im/rpui/menus/blank")
	menu:SetSize(ScrW() * .25, ScrH() * .6)
	menu:Center()
	menu:MakePopup()

	menu.header.SetIcon(menu.header, "diplomacy/allyic64.png")
	menu.header.SetTitle(menu.header, translates and translates.Get("ИЗМЕНЕНИЕ ЗАКОНОВ") or "ИЗМЕНЕНИЕ ЗАКОНОВ")
	menu.header.SetFont(menu.header, "rpui.playerselect.title")
	menu.header.IcoSizeMult = 1.5

	menu.input = vgui.Create("urf.im/rpui/txtinput", menu.workspace)
	menu.input:SetSize(menu:GetWide(), menu:GetTall() - menu.header:GetTall() - 110)
	menu.input:SetMultiline(true)
	menu.input:SetValue(Laws)
	menu.input.OnTextChanged = function(this)
		Laws = this:GetValue()
	end
	menu.input.UID = "LawEditor"
	menu.input.FontScale = 0.08
	menu.input.ApplyDesign(menu.input)

	local y = menu.input:GetTall() + 2

	menu.AddLaw = vgui.Create("urf.im/rpui/button", menu.workspace)
	menu.AddLaw:SetSize(menu:GetWide(), 40)
	menu.AddLaw:SetPos(0, y)
	menu.AddLaw:SetText(translates and translates.Get("Сохранить законы") or "Сохранить законы")
	menu.AddLaw:SetFont("rpui.slidermenu.font")
	menu.AddLaw.DoClick = function(this)
		if string.len(Laws) <= 5 then
			chat.AddText(Color(255, 255, 255), translates and translates.Get("Законы должны быть длинее 5 символов!") or "Законы должны быть длинее 5 символов!")

			return
		end

		if #string.Wrap('HudFont', Laws, 325 - 10) >= 30 then
			chat.AddText(Color(255, 255, 255), translates and translates.Get("Пожалуйста ограничьте ваши законы 30 строками.") or "Пожалуйста ограничьте ваши законы 30 строками.")

			return
		end

		net.Start('rp.SendLaws')
		net.WriteString(string.Trim(Laws))
		net.SendToServer()
	end

	y = y + menu.AddLaw:GetTall()

	menu.ResetLaws = vgui.Create("urf.im/rpui/button", menu.workspace)
	menu.ResetLaws:SetSize(menu:GetWide(), 40)
	menu.ResetLaws:SetPos(0, y)
	menu.ResetLaws:SetText(translates and translates.Get("Сбросить законы") or "Сбросить законы")
	menu.ResetLaws:SetFont("rpui.slidermenu.font")
	menu.ResetLaws.DoClick = function(this)
		LocalPlayer():ConCommand('say /resetlaws')
		menu:Close()
	end
end
concommand.Add('LawEditor', ChangeLaws)