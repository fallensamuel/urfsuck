nw.Register 'JailReason'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()

ba.AddTerm('JailNotSet', 'Место для Алькатраса не используется!')
ba.AddTerm('MissingArgTime', 'Ошибка со оргументом времени!')
ba.AddTerm('MissingArgReason', 'Ошибка с причиной!')
ba.AddTerm('JailTimeRestriction', 'Вы не можете посадить в Алькатрас больше 10 минут!')
ba.AddTerm('AdminJailedPlayer', '# посадил в Алькатрас # на #. Причина: #.')
ba.AddTerm('AdminJailedYou', '# посадил вас в Алькатрас на #. Причина: #.')
ba.AddTerm('AdminUnjailedPlayer', '# выпустил из Алькатрас #.')
ba.AddTerm('AdminUnjailedYou', '# выпустил вас из Алькатрас.')
ba.AddTerm('JailroomSet', 'Место для Алькатрас обозначено.')
ba.AddTerm('PlayerJailReleased', '# вышел из Алькатраса.')
ba.AddTerm('YouJailReleased', 'Вы вышли из Алькатраса.')
ba.AddTerm('JailDisabled', 'Алькатрас отключен, используйте !ban.')

function PLAYER:IsJailed()
	return ((SERVER) and (ba.jailedPlayers[self:SteamID()] ~= nil) or (self:GetNetVar('JailReason') ~= nil))
end

local cmd = ba.cmd.Create('Jail', function(pl, args)
	ba.notify_err(pl, ba.Term('JailDisabled'))
	return

	--if not ba.svar.Get('jailroom') then
	--	ba.notify_err(pl, ba.Term('JailNotSet'))
	--	return
	--end
--
	--if not args.target:IsJailed() then
	--	if (args.time == nil) then
	--		ba.notify_err(pl, ba.Term('MissingArgTime'))
	--		return
	--	end
--
	--	if (args.reason == nil) then
	--		ba.notify_err(pl, ba.Term('MissingArgReason'))
	--		return
	--	end
--
	--	if (args.time > 600) and not pl:HasAccess('G') then
	--		ba.notify_err(pl, ba.Term('JailTimeRestriction'))
	--		return
	--	end
--
	--	ba.jailPlayer(args.target, args.time, args.reason)
	--	ba.notify_staff(ba.Term('AdminJailedPlayer'), pl, args.target, args.raw.time, args.reason)
	--	ba.notify(args.target, ba.Term('AdminJailedYou'), pl, args.raw.time, args.reason)
	--else
	--	ba.unJailPlayer(args.target)
	--	ba.notify_staff(ba.Term('AdminUnjailedPlayer'), pl, args.target)
	--	ba.notify(args.target, ba.Term('AdminUnjailedYou'), pl)
	--end
end)
cmd:AddParam('player_entity', 'target')
cmd:AddParam('time', 'time', 'optional')
cmd:AddParam('string', 'reason', 'optional')
cmd:SetFlag('M')
cmd:SetHelp('Jails/UnJails your target')
cmd:SetIcon('icon16/lock_add.png')

-------------------------------------------------
-- Set Admin Room
-------------------------------------------------
local cmd = ba.cmd.Create('SetJailRoom', function(pl, args)
	ba.svar.Set('jailroom', pon.encode({pl:GetPos()}))
	ba.notify(pl, ba.Term('JailroomSet'))
end)
cmd:SetFlag('*')
cmd:SetHelp('Sets the jailroom to your current position')


if (CLIENT) then
	local color_bg 			= Color(0,0,0,230)
	local color_outline	 	= Color(245,245,245)
	local color_black 		= Color(0,0,0)

	hook.Add('HUDPaint', 'jail.HUDPaint', function()
		if LocalPlayer():IsJailed() then
			draw.OutlinedBox(0, -1, ScrW(), 22, color_bg, color_outline)
			surface.SetFont('HudFont')
			local txt = 'You\'re in timeout for: ' .. LocalPlayer():GetNetVar('JailReason')
			local txtsize = surface.GetTextSize(txt) + 10
			surface.DrawOutlinedRect(0, -1, txtsize, 22)
			draw.SimpleTextOutlined(txt, 'HudFont', txtsize/2, 10, color_outline, 1, 1, 1, color_black)
			return false
		end
	end)
end