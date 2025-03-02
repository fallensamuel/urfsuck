rp.Voices = {}

rp.Voices[0] = rp.cfg.DefaultVoices

function rp.SetFactionVoices(faction, voices)
	for k, v in pairs(rp.GetFactionTeams(faction)) do
		rp.Voices[v] = voices
	end
end

function rp.SetTeamVoices(team, voices)
	for k, v in pairs(istable(team) and team or {team}) do
		rp.Voices[v] = voices
	end
end

function rp.AddTeamVoices(team, voices)
	for k, v in pairs(istable(team) and team or {team}) do
		if !rp.Voices[v] then
			rp.Voices[v] = rp.Voices[0] and table.Copy(rp.Voices[0]) or {}
		else
			rp.Voices[v] = table.Copy(rp.Voices[v])
		end
		for k1, v1 in pairs(voices) do
			table.insert(rp.Voices[v], v1)
		end
	end
end

--if SERVER then
--	hook('ConfigLoaded', 'loadVoices', function()
--		for _, v in pairs(rp.Voices) do
--			for _, soundTable in pairs(v) do
--				soundTable.duration = (SoundDuration(soundTable.sound) or 0) + 2 
--			end
--		end
--	end)
--end

