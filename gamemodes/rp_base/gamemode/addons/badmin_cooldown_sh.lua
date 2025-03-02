local RealTime = RealTime

hook.Add("playerCanRunCommand", function(ply, cmd)
	--print(ply, cmd)
	if (ply.lastCommand or 0) > RealTime() then
	--	print('cool urself!')
		ply.lastCommand = RealTime() + 0.2
		return false, (translates and translates.Get('Не используйте команды так часто!') or 'Не используйте команды так часто!')
	end
	ply.lastCommand = RealTime() + 0.1
end)