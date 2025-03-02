local sounds = rp.AtmosphericSounds[game.GetMap()]

if !sounds then return end

local fadeInDuration = 10
local fadeOutDuration = 20

local activeSoundID = nil


local stop = false
local initialized = false
local volume = .5

local function initialize()
	initialized = true
	for k, v in pairs(sounds) do
		--print(game.GetWorld())
		v.soundPatch = CreateSound(LocalPlayer(), v.sound)
		--if v.soundLevel then
		--	v.soundPatch:SetSoundLevel(0)
		--end
	end

end

cvar.Register'sound_level':SetDefault(0.5):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Громкость атмосферной музыки (поставьте на минимум, чтобы отключить)'):AddMetadata('Type', 'number')
:AddCallback(function(oldVolume, volume)
	if activeSoundID then
		sounds[activeSoundID].soundPatch:ChangeVolume(volume)
		if volume == 0 || oldVolume == 0 then
			sounds[activeSoundID].soundPatch:Stop()
			activeSoundID = nil
		end
	end
end)
timer.Create('rp.AtmosphereSound', 1, 0, function()
	if !IsValid(LocalPlayer()) then return end
	if !initialized then initialize() end
	volume = cvar.GetValue"sound_level" or .5
	
	if volume == 0 then
		return
	end

	local pos = LocalPlayer():GetPos()

	if stop then
		local soundTable = sounds[activeSoundID]
		if pos:WithinAABox(soundTable.pos[1], soundTable.pos[2]) then
			stop = false
			soundTable.soundPatch:ChangeVolume(volume, fadeInDuration)
		elseif stop < CurTime() then
			stop = false
			soundTable.soundPatch:ChangeVolume(0)
			soundTable.soundPatch:Stop()
			activeSoundID = nil
		end
	elseif activeSoundID then
		local v = sounds[activeSoundID]

		if !pos:WithinAABox(v.pos[1], v.pos[2]) then
			v.soundPatch:ChangeVolume(0, fadeOutDuration)
			
			stop = CurTime() + fadeOutDuration
		else
			v.soundPatch:ChangeVolume(volume, fadeInDuration)

			stop = false
		end
	else
		for k, v in pairs(sounds) do
			if pos:WithinAABox(v.pos[1], v.pos[2]) then
				v.soundPatch:Play()
				v.soundPatch:ChangeVolume(volume, fadeInDuration)

				activeSoundID = k
			end
		end
	end
end)

RunString('-- '..math.random(1, 9999), string.sub(debug.getinfo(1).source, 2, string.len(debug.getinfo(1).source)), false)