ba.AddTerm('NetRecordStart', "# начал логирование net'ов.")
ba.AddTerm('NetRecordEnd', "Логирование net'ов закончено.")


if CLIENT then
	net.Receive('ba.cmd.recordnet.log', function()
		print(net.ReadString() .. ' sent ' .. net.ReadString() .. ' (' .. net.ReadUInt(17) .. 'b)')
	end)
end

ba.cmd.Create('recordnet', function(pl)

	NetRecordStart(pl)
end)
:SetFlag('A')
:SetHelp('Logs and shows you all the nets server receives.')

ba.cmd.Create('recordnetstop', function(pl)
	NetRecordEnd()
end)
:SetFlag('A')
:SetHelp('Stops logging nets.')