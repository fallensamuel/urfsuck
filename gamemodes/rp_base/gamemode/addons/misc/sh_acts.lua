local acts = {'cheer', 'laugh', 'muscle', 'zombie', 'robot', 'dance', 'agree', 'becon', 'disagree', 'salute', 'wave', 'forward', 'pers'}

if (SERVER) then
	util.AddNetworkString('PlayerAct')

	rp.AddCommand("/act", function(pl, text, args)
		if (args[1]) then
			for k, v in ipairs(acts) do
				if (v == args[1]) then
					net.Start('PlayerAct')
					net.WriteUInt(k, 4)
					net.Send(pl)

					return
				end
			end
		end

		net.Start('PlayerAct')
		net.WriteUInt(math.random(#acts), 4)
		net.Send(pl)
	end)
else
	net('PlayerAct', function(len)
		LocalPlayer():ConCommand('act ' .. acts[net.ReadUInt(4)])
	end)
end