hook.Add("InitPostEntity", "disable_tfa_door_destruction", function()
	RunConsoleCommand("sv_tfa_bullet_doordestruction", "0")
	RunConsoleCommand("sv_tfa_melee_doordestruction", "0")
end)

/*
http.Fetch('http://urf.im/discount.txt', function(body)
	local number = tonumber(body)
	if number && rp.Discount < number then
		rp.Discount = body
	end
end)
*/
