-- "gamemodes\\rp_base\\gamemode\\addons\\awards\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

net.Receive('Awards::UpdateChatEmojis', function()
	if IsValid(_CHATBOX_EMOTICONS) then
		_CHATBOX_EMOTICONS:Remove()
	end
end)
