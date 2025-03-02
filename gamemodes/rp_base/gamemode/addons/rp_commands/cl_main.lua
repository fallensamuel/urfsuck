net.Receive('SendAnimToClientNet', function(Length)
    local Animation = net.ReadUInt(12);
    LocalPlayer():AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, Animation, true);
end);

net.Receive("promocode_menu", function()
	local menu = rpui.StringRequest("АКТИВАЦИЯ ПРОМОКОДА", "Введите промокод, если вы его знаете:", "shop/filters/list.png", 1.4, function(self, str)
		RunConsoleCommand("say", "/usepromocode "..str)
	end, function()
		URFNotify("Повторно ввести промокод вы можете написав ", Color(40, 149, 220), "/promo", Color(255, 255, 255), " или нажав ", Color(40, 149, 220), "F4->Донат->Промокод")
	end)

	menu.ok.SetText(menu.ok, translates and translates.Get("Активировать") or "Активировать")
end)