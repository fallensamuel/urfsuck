
if not rp.cfg.DisableContextRedisign then 
	local hear_text1 = translates and translates.Get("Включить приём рации") or "Включить приём рации"
	local hear_text2 = translates and translates.Get("Выключить приём рации") or "Выключить приём рации"
	local speak_text1 = translates and translates.Get("Включить передачу рации") or "Включить передачу рации"
	local speak_text2 = translates and translates.Get("Выключить передачу рации") or "Выключить передачу рации"
	local radio_text = translates and translates.Get("Рация") or "Рация"
	
	local btn_names = {
		Hear = {hear_text1, hear_text2}, 
		Speak = {speak_text1, speak_text2}, 
	}

	local btn_state = {
		Hear = 2, 
		Speak = 1,
	}

	local function radioCanUse()
		return rp.RadioChanels and rp.RadioChanels[LocalPlayer():Team()]
	end

	local function switchName(old, new)
		for k,v in pairs(rp.ContextMenu.Categories[radio_text].Commands) do
			if v.Name == old then
				v.Name = new
				rp.RefreshContextMenu()
			end
		end
	end

	local function radioMixContext(mode)
		local old_name;
		for k, v in pairs((mode and {mode}) or {'Hear', 'Speak'}) do
			old_name = btn_names[v][btn_state[v]]
			btn_state[v] = 3 - btn_state[v]
			switchName(old_name, btn_names[v][btn_state[v]])
		end
	end

	local function radioSwitch(mode)
		if mode ~= 'Speak' and mode ~= 'Hear' then return end
		
		--local old_name = btn_names[mode][btn_state[mode]]
		--btn_state[mode] = 3 - btn_state[mode]
		--
		--switchName(old_name, btn_names[mode][btn_state[mode]])
		
		radioMixContext(mode);
		
		net.Start('RC_RadioSwitch' .. mode)
		net.SendToServer()
		
		surface.PlaySound("sound/npc/overwatch/radiovoice/off4.wav")
	end

	function rp.IsRadioTransmiting()
		return LocalPlayer():GetNetVar('RC_RadioOnSpeak') or false
	end

	function rp.IsRadioReceiving()
		return LocalPlayer():GetNetVar('RC_RadioOnHear') or false
	end

	----- Channels activate/deactivate sound -----
	local channels = rp.RadioChanels
	hook.Add('PlayerStartVoice', 'rp.RadioStart', function(ply)
		if not IsValid(LocalPlayer()) or not IsValid(ply) then return end
		
		if LocalPlayer():Team() and ply:Team() and channels[LocalPlayer():Team()] and channels[LocalPlayer():Team()][ply:Team()] and ply:GetNetVar('RC_RadioOnSpeak') then
			sound.PlayFile("sound/npc/overwatch/radiovoice/off4.wav", "", function(station ) if ( IsValid( station ) ) then station:Play()  station:SetVolume(0.3) end end)
		end
	end)

	hook.Add('PlayerEndVoice', 'rp.RadioEnd', function(ply)
		if channels[LocalPlayer():Team()] and channels[LocalPlayer():Team()][ply:Team()] and ply:GetNetVar('RC_RadioOnSpeak') then
			sound.PlayFile("sound/weapons/radiooperator/targetacquired.mp3", "", function(station ) if ( IsValid( station ) ) then station:Play()  station:SetVolume(0.3) end end)
		end
	end)

	rp.AddContextCommand(radio_text, btn_names['Hear'][btn_state['Hear']], function()
		radioSwitch('Hear')
	end, radioCanUse, 'cmenu/chat')

	rp.AddContextCommand(radio_text, btn_names['Speak'][btn_state['Speak']], function()
		radioSwitch('Speak')
	end, radioCanUse, 'cmenu/chat')

	net.Receive('RC_RadioSync', function(_, ply)
		btn_state = {
			Hear = (rp.IsRadioReceiving() and 1) or 2,
			Speak = (rp.IsRadioTransmiting() and 1) or 2
		};
		radioMixContext();
	end);
end