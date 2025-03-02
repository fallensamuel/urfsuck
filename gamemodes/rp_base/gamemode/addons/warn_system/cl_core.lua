net.Receive("WarnSystem", function()
	local sid = net.ReadString()

	local menu
	menu = rpui.SliderRequest(translates.Get("На сколько часов баним?"), "scoreboard/usergroups/admin.png", 1.6, function(val)
		menu:Remove()
		rpui.StringRequest(translates.Get("ПРИЧИНА БАНА"), translates.Get("Введите причину бана:"), "scoreboard/usergroups/admin.png", 1.6, function(self, str)
			RunConsoleCommand("urf", "warnban", sid, math.Clamp(val, 1, 24).."h", str)
		end)
	end)
	menu.slider.MaxValue = 24
	menu.slider:SetPseudoKnobPos(4)
	menu:SetInputVal(4)
end)