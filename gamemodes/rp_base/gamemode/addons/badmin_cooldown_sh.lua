-- "gamemodes\\rp_base\\gamemode\\addons\\badmin_cooldown_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local RealTime = RealTime

hook.Add("playerCanRunCommand", function(ply, cmd, forced)
	if (ply.lastCommand or 0) > RealTime() then
		ply.lastCommand = RealTime() + 0.2
		return false, (translates and translates.Get('Не используйте команды так часто!') or 'Не используйте команды так часто!')
	end

	if not forced then
		ply.lastCommand = RealTime() + 0.1
	end
end)
