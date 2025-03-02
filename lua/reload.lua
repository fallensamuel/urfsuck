for i = 1, 10 do
	print("SERVER RELOAD AFTER 300 SECS!!!")
end

file.Write("server.restart", "reload!")

timer.Simple(315, function()
	RunConsoleCommand("urf", "reload")
end)