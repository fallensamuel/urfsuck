
nw.Register'TimeMultiplayer':Write(net.WriteFloat):Read(net.ReadFloat):SetLocalPlayer()
nw.Register'TimeMultiplier':Write(net.WriteFloat):Read(net.ReadFloat):SetGlobal()
nw.Register'TimeMultiplierRemain':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()

function PLAYER:GetTimeMultiplayer()
	return self:GetNetVar('TimeMultiplayer') or 0
end

function rp.GetTimeMultiplier()
	return nw.GetGlobal('TimeMultiplier') or 0
end

function rp.GetTimeMultiplierRemain()
	return nw.GetGlobal('TimeMultiplierRemain') or 0
end


ba.AddTerm('NextMultiplayer', translates and translates.Get('Следующий бонус на #% к получению времени через # минут!') or 'Следующий бонус на #% к получению времени через # минут!')


-- Badmin commands
ba.cmd.Create('Time multiplier set', function(pl, args)
	--pl:PrintMessage(HUD_PRINTCONSOLE, "1")
	if !tonumber(args.multiplier) then return end
	
	local bonus = tonumber(args.multiplier) / 100
	
	if bonus < 0.1 or bonus > 20 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantCreateTimeMultiplayer'))
		return
	end
	
	--pl:PrintMessage(HUD_PRINTCONSOLE, "2")
	--bonus = bonus < 0.1 and 0.1 or bonus > 20 and 20 or bonus
	local time 	= args.time
	
	ba.logAction(pl, tostring(bonus), 'time_multiplier', tostring(time))
	
	ba.svar.SetGlobal('time_multiplier_time', time + os.time())
	ba.svar.SetGlobal('time_multiplier', bonus)
	--pl:PrintMessage(HUD_PRINTCONSOLE, "3")
end)
:AddParam('string', 'multiplier')
:AddParam('time', 'time')
:SetFlag('e')
:SetHelp('Sets a global time multiplier')

ba.cmd.Create('Time multiplier reset', function(pl, args)
	ba.svar.SetGlobal('time_multiplier_time', 0)
	ba.svar.SetGlobal('time_multiplier', 0)
	
	ba.logAction(pl, '', 'time_multiplier_reset', '')
end)
:SetFlag('e')
:SetHelp('Removes a global time multiplier')

table.insert(rp.cfg.Announcements, 
	(translates and translates.Get("С %i часов ночи по %i часов утра московского времени получение времени ускоряется на %i", rp.cfg.StartNightTimeMultiplier, rp.cfg.EndNightTimeMultiplier, rp.cfg.NightTimeMultiplier*100) 
	or 
	('С '..rp.cfg.StartNightTimeMultiplier..' часов ночи по '..rp.cfg.EndNightTimeMultiplier..' часов утра московского времени получение времени ускоряется на '..rp.cfg.NightTimeMultiplier*100)) .. '%!'
)
