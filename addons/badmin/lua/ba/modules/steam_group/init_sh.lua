

ba.cmd.Create('Steam')
:RunOnClient(function(args)
	ba.steamGroup.OpenMenu()
end)
:SetHelp('Opens our steam group')



ba.cmd.Create('vk')
:RunOnClient(function(args)
	ba.steamGroup.OpenVKMenu()
end)
:SetHelp('Opens our vk group')