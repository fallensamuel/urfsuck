
if rp.cfg.BaseDayNight then
	function rp.SwitchDayNight(f)
		local startNight = f == nil && rp.IsDay() || f
		if startNight then
			ents.FindByName('night_enable')[1]:Fire("Use")

			timer.Create('DayNightSwitch', rp.cfg.NightDuration, 1, rp.SwitchDayNight)
		else
			ents.FindByName('day_enable')[1]:Fire("Use")

			timer.Create('DayNightSwitch', rp.cfg.DayDuration, 1, rp.SwitchDayNight)
		end
	end

	hook.Add("InitPostEntity", function()
		rp.SwitchDayNight(false)
	end)

	hook.Add("OnReloaded", function()
		rp.SwitchDayNight(false)
	end)

	concommand.Add('test_day', function(ply, cmd, args)
		rp.SwitchDayNight(tobool(args[1]))
	end)
end
