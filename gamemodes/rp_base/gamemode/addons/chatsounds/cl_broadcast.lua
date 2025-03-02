-- "gamemodes\\rp_base\\gamemode\\addons\\chatsounds\\cl_broadcast.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
cvar.Register'broadcast_sound_level':SetDefault(0.7):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', rp.cfg.VolumeSettingName or 'Громкость сообщений Альянса'):AddMetadata('Type', 'number')

net.Receive('rp.DoVoice', function()
	if !IsValid(LocalPlayer()) then return end
	local team = net.ReadUInt(9)
	local id = net.ReadInt(8)

	print( "rp.DoVoice", "recv:", team, id );

	local voice = rp.Voices[team] && rp.Voices[team][id]
	print( voice );

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