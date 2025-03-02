local notify_types = {
	[0] = Color(255,100,100),
	[1] = Color(255,30,30),
}

local GetPref = function()
	return (CHATBOX and CHATBOX.IsNewChatbox) and "[URF] " or '| '
end

net.Receive('ba.NotifyString', function(len)
	--chat.AddText(notify_types[net.ReadBit()], '[SYSTEM] ', unpack(ba.ReadMsg()))
	chat.AddText(notify_types[net.ReadBit()], GetPref(), unpack(ba.ReadMsg()))
end)


net.Receive('ba.NotifyTerm', function(len)
	--chat.AddText(notify_types[net.ReadBit()], '[SYSTEM] ', unpack(ba.ReadTerm()))
	chat.AddText(notify_types[net.ReadBit()], GetPref(), unpack(ba.ReadTerm()))
end)