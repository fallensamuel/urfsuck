-- "gamemodes\\rp_base\\gamemode\\main\\donations\\src\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
net.Receive("donations.sync", function()
	local t = net.ReadTable()
	hook.Add("Think", "donations.sync", function()
		if IsValid(LocalPlayer()) then
			LocalPlayer().donations = t
			hook.Remove("Think", "donations.sync")
		end
	end)
end)

net.Receive("donations.url", function()

	local url = net.ReadString()

	

	local Menu = DermaMenu()
	Menu:AddOption( "Скопировать ссылку на оплату", function() chat.AddText('Ссылка на оплату скопирована, теперь вставь её в удобный для тебя браузер.') SetClipboardText(url) end)
	Menu:AddOption( "Открыть в браузере Steam" , function() gui.OpenURL('http://steamcommunity.com/groups/gmod/%2e%2e/%2e%2e/linkfilter/'..url) end)

	Menu:Open()
	Menu:Center()
/*
	local frame = vgui.Create( "DFrame" ) -- Create a container for everything
	frame:SetSize( 800, 600 )
	frame:SetTitle( "" )
	frame:Center()
	frame:MakePopup()

	local window = vgui.Create( "DHTML", frame ) -- Our DHTML window
	window:SetSize( 750, 500 )
	window:Center()

	window:OpenURL( url )
*/
end)

net.Receive("donations.purchased", function()
	sound.PlayURL("http://urf.im/gta_sa.mp3", "", function(station)
		if IsValid(station) then
			station:Play()
		end
	end)
end)