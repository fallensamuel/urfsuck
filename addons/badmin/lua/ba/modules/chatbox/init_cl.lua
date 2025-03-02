-- Подгрузка модуля отключена! Ищи новый чатбокс в rpbase!

chat.OldAddText = chat.OldAddText or chat.AddText
function chat.AddText(...)
	if IsValid(LocalPlayer()) then 
		CHATBOX_UI = CHATBOX_UI or ba.CreateChatBox()
		CHATBOX_UI:AddMessage({...})
	end
	return chat.OldAddText(...)
end

chat._GetChatBoxSize = chat._GetChatBoxSize or chat.GetChatBoxSize
function chat.GetChatBoxSize()
	if IsValid(CHATBOX_UI) then
		return CHATBOX_UI:GetSize()
	end
	return chat._GetChatBoxSize()
end

chat._GetChatBoxPos = chat._GetChatBoxPos or chat.GetChatBoxPos
function chat.GetChatBoxPos()
	if IsValid(CHATBOX_UI) then
		return CHATBOX_UI:GetPos()
	end
	return chat._GetChatBoxPos()
end

hook.Add('HUDShouldDraw', 'HideDefaultChat', function(name)
	if (name == 'CHudChat') then
		return false
	end
end)

hook.Add('PlayerBindPress', 'OpenChatbox', function(ply, bind, pressed)
	if (!pressed) then return end
	
		CHATBOX_UI = CHATBOX_UI or ba.CreateChatBox()
		CHATBOX_UI.ShowEmotes = true
		
	if (string.find(bind, 'messagemode2')) then
			CHATBOX_UI:Open(true)
		return true
	elseif (string.find(bind, 'messagemode')) then
		CHATBOX_UI:Open(false)
		return true
	end
end)

local function ToggleChat()
	net.Start('ba.ToggleChat')
	net.SendToServer()
end
hook.Add('StartChat', 'ba.chat.StartChat', ToggleChat)
hook.Add('FinishChat', 'ba.chat.FinishChat', ToggleChat)


hook.Add('ChatText', function(plInd, plName, Text, Type)
	if (Type == 'joinleave') then return true end
end)