util.AddNetworkString('rp.DoVoice')

local voices = rp.Voices
local t
local RealTime = RealTime

local lastBroadcast = 0
local function DoVoice(pl, cmd)
	if !pl.NextChatSound or pl.NextChatSound <= RealTime() then
		local playerTeam = (pl:DisguiseTeam() or pl:Team())
		t = voices[playerTeam] && voices[playerTeam][cmd] || voices[0][cmd]
		if cmd and t then
			if t.broadcast then
				if lastBroadcast > RealTime() then
					return
				end
				lastBroadcast = RealTime() + (t.soundDuration or 10)
				net.Start('rp.DoVoice')
					net.WriteInt(playerTeam, 9)
					net.WriteInt(cmd, 8)
				net.Broadcast()
			else
				pl:EmitSound(istable(t.sound) && table.Random(t.sound) || t.sound, 80, 100)
				if t.text then
					pl:Say(t.text)
				end

				pl.NextChatSound = RealTime() + 2 + (t.soundDuration or 2)
			end

		end
	end
end

local function broadcast()
	net.Start('rp.DoVoice')
		net.WriteInt((pl:DisguiseTeam() or pl:Team()), 9)
		net.WriteInt(cmd, 8)
	net.Broadcast()
end

net.Receive('rp.DoVoice', function(len,pl)
	local id = net.ReadInt(8)
	DoVoice(pl, id)
end)