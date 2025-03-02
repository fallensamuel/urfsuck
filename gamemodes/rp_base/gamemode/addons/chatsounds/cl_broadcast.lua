cvar.Register'broadcast_sound_level':SetDefault(0.7):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', rp.cfg.VolumeSettingName or 'Громкость сообщений Альянса'):AddMetadata('Type', 'number')

net.Receive('rp.DoVoice', function()
	if !IsValid(LocalPlayer()) then return end
	local team = net.ReadInt(9)
	local id = net.ReadInt(8)

	local voice = rp.Voices[team] && rp.Voices[team][id]

	if !voice then return end
	
	chat.AddText(rp.teams[team].color, "["..rp.teams[team].name.."] ", voice.text)
	
	if cvar.GetValue'broadcast_sound_level' == 0 then return end

	if !voice.soundPatch then
		voice.soundPatch = CreateSound(LocalPlayer(), voice.sound)
	end
	
	local mult = voice.volmult or 1
	voice.soundPatch:ChangeVolume(cvar.GetValue('broadcast_sound_level') * mult)

	voice.soundPatch:Play()
end)