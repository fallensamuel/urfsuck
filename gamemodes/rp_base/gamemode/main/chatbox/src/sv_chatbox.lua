util.AddNetworkString("CHATBOX.Typing")

net.Receive("CHATBOX.Typing", function(len, ply)
	ply:SetNetVar("IsTyping", net.ReadBool())
end)

--rp.AddCommand("/fr", function(ply, text, args)
--	local f = ply:GetFaction()
--
--	rp.Chat(CHAT_FRACTION, table.Filter(player.GetHumans(), function(v) return v:GetFaction() == f end), ply, text)
--end)

rp.AddCommand("/gr", function(ply, text, args)
	rp.groupChat(ply, text)
end)

rp.AddCommand("/group", function(ply, text, args)
	rp.groupChat(ply, text)
end)