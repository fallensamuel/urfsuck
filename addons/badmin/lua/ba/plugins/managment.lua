ba.AddTerm('AdminFrozePlayer', '# заморозил #.')
ba.AddTerm('AdminUnfrozePlayer', '# разморозил #.')
ba.AddTerm('AdminUnmutedPlayer', '# снял Затычку с #.')
ba.AddTerm('AdminUnmutedYou', '# снял с тебя Затычку.')
ba.AddTerm('YouAreUnmuted', 'С вас сняли Затычку.')
ba.AddTerm('AdminMutedPlayer', '# Заткнул # на #.')
ba.AddTerm('AdminMutedYou', '# Заткнул тебя на #.')
ba.AddTerm('MuteMissingTime', 'Ошибка: укажите правильное время.')
ba.AddTerm('AdminUnmutedPlayerChat', '# снял Затычку Чата с #.')
ba.AddTerm('AdminUnmutedYouChat', '# снял с тебя Затычку Чата.')
ba.AddTerm('YouAreUnmutedChat', 'Вам вновь доступен чат.')
ba.AddTerm('AdminMutedPlayerChat', '# выдал Затычку Чата # на #.')
ba.AddTerm('AdminMutedYouChat', '# выдал вам Затычку Чата на #.')
ba.AddTerm('AdminUnmutedPlayerVoice', '# снял Затычку Микрофона с #.')
ba.AddTerm('AdminUnmutedYouVoice', '# снял с тебя Затычку Чата.')
ba.AddTerm('YouAreUnmutedVoice', 'Вам доступен микрофон.')
ba.AddTerm('AdminMutedPlayerVoice', '# выдал Затычку Микрофона # на #.')
ba.AddTerm('AdminMutedYouVoice', '# выдал тебе Затычку Микрофона на #.')
ba.AddTerm('AdminIsSpectating', '# находится в режиме Наблюдения!')
ba.AddTerm('SpectateTargInvalid', 'Выберите доступного игрока!')

-------------------------------------------------
-- Freeze
-------------------------------------------------
ba.cmd.Create('Freeze', function(pl, args)
	if not args.target:Alive() then
		args.target:Spawn()
	end
		
	if args.target:InVehicle() then
		args.target:ExitVehicle()
	end

	if not args.target:IsFrozen() then
		args.target:Freeze(true)
		ba.notify_staff(ba.Term('AdminFrozePlayer'), pl, args.target)
	else
		args.target:Freeze(false)
		ba.notify_staff(ba.Term('AdminUnfrozePlayer'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Freezes/Unfreezes your target')
:SetIcon('icon16/lock.png')

-------------------------------------------------
-- Mute
-------------------------------------------------
ba.cmd.Create('Mute', function(pl, args)
	if (not args.time) and args.target:IsChatMuted() or args.target:IsVoiceMuted() then
		args.target:UnChatMute()
		args.target:UnVoiceMute()
		ba.notify_staff(ba.Term('AdminUnmutedPlayer'), pl, args.target)
		ba.notify(args.target, ba.Term('AdminUnmutedYou'), pl)
	elseif args.time and (not args.target:IsChatMuted() or not args.target:IsVoiceMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, ba.Term('YouAreUnmuted'))
		end)
		args.target:VoiceMute(args.time)
		ba.notify_staff(ba.Term('AdminMutedPlayer'), pl, args.target, args.raw.time)
		ba.notify(args.target, ba.Term('AdminMutedYou'), pl, args.raw.time)
	else
		ba.notify_err(pl, ba.Term('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Mutes your targets chat and voice')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Mute Chat
-------------------------------------------------
ba.cmd.Create('MuteChat', function(pl, args)
	if (not args.time) and args.target:IsChatMuted() then
		args.target:UnChatMute()
		ba.notify_staff(ba.Term('AdminUnmutedPlayerChat'), pl, args.target)
		ba.notify(args.target, ba.Term('AdminUnmutedYouChat'), pl)
	elseif args.time and (not args.target:IsChatMuted()) then
		args.target:ChatMute(args.time, function()
			ba.notify(args.target, ba.Term('YouAreUnmutedChat'))
		end)
		ba.notify_staff(ba.Term('AdminMutedPlayerChat'), pl, args.target, args.raw.time)
		ba.notify(args.target, ba.Term('AdminMutedYouChat'), pl, args.raw.time)
	else
		ba.notify_err(pl, ba.Term('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Mutes your targets chat')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Mute Voice
-------------------------------------------------
ba.cmd.Create('MuteVoice', function(pl, args)
	if (not args.time) and args.target:IsVoiceMuted() then
		args.target:UnVoiceMute()
		ba.notify_staff(ba.Term('AdminUnmutedPlayerVoice'), pl, args.target)
		ba.notify(args.target, ba.Term('AdminUnmutedYouVoice'), pl)
	elseif args.time and (not args.target:IsVoiceMuted()) then
		args.target:VoiceMute(args.time, function()
			ba.notify(args.target, ba.Term('YouAreUnmutedVoice'))
		end)
		ba.notify_staff(ba.Term('AdminMutedPlayerVoice'), pl, args.target, args.raw.time)
		ba.notify(args.target, ba.Term('AdminMutedYouVoice'), pl, args.raw.time)
	else
		ba.notify_err(pl, ba.Term('MuteMissingTime'))
	end
end)
:AddParam('player_entity', 'target')
:AddParam('time', 'time', 'optional')
:SetFlag('M')
:SetHelp('Mutes your targets voice')
:SetIcon('icon16/sound.png')

-------------------------------------------------
-- Spectate
-------------------------------------------------
local specPlayers = {}
local handleSpectate;

ba.cmd.Create('Spectate', function(pl, args)
	if not pl:Alive() then
		pl:Spawn()
	end
		
	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	if (args.target ~= nil) and args.target:GetBVar('Spectating') then
		ba.notify_err(pl, ba.Term('AdminIsSpectating'), args.target)
	elseif (args.target ~= nil) then
		if (!pl:GetBVar('Spectating')) then
			pl:SetBVar('PreSpectatePos', pl:GetPos())
			local preSpecWeapons = {}

			for _, wep in ipairs(pl:GetWeapons()) do
				preSpecWeapons[#preSpecWeapons + 1] = wep:GetClass()
			end
			pl:SetBVar('PreSpectateWeapons', preSpecWeapons)

			pl:StripWeapons()
			pl:Flashlight(false)
			pl:Spectate(OBS_MODE_IN_EYE)
			
			pl:SetBVar('Spectating', true)
			pl:SetNetVar('Spectating', true)
			
			specPlayers[#specPlayers + 1] = {pl = pl, targ = args.target}
		else
			local patchedtable = false
			for k, v in ipairs(specPlayers) do
				if (v.pl == pl) then
					v.targ = args.target
					patchedtable = true
					break
				end
			end
			
			if (!patchedtable) then
				ErrorNoHalt("Couldn't find the admin's spectate table. This SHOULD NOT HAPPEN.")
				ba.notify_err(pl, "Something unusual happened. Try again.")
				pl:SetBVar('Spectating', nil)
				return
			end
		end
		
		pl:SpectateEntity(args.target)
	elseif pl:GetBVar('Spectating') then
		pl:SetBVar('Spectating', nil)
	else
		ba.notify_err(pl, ba.Term('SpectateTargInvalid'))
	end
end)
:AddParam('player_entity', 'target', 'optional')
:SetEqualImmunityAccess()
:SetFlag('A')
:SetHelp('Spectates your target/untoggles spectate')
:SetIcon('icon16/eye.png')
:AddAlias('spec')
hook.Add('PlayerDeath', 'UnSpectateAdmin', function(pl)
	if pl:GetBVar('Spectating') then
		pl:SetBVar('Spectating', nil)
	end
end)

if (CLIENT) then
	hook.Add('HUDShouldDraw', 'ba.HUDShouldDraw', function(name, pl)
		if (name == 'PlayerDisplay') and IsValid(pl) and pl:GetNetVar('Spectating') then return false end -- Use this for your gamemode or whatever.
	end)
else
	handleSpectate = function()
		for i=#specPlayers, 1, -1 do
			local v = specPlayers[i]
			if not v.pl:IsValid() or not v.targ:IsValid() or not v.pl:GetBVar('Spectating') then
				table.remove(specPlayers, i)
				if not v.pl:IsValid() then return end

				local pos = util.FindEmptyPos(v.pl:GetBVar('PreSpectatePos'))
				
				v.pl:SetNetVar('Spectating', nil)
				v.pl:SetBVar('Spectating', nil)
				v.pl:UnSpectate()
				v.pl:Spawn()
				
				timer.Simple(0.1, function()
					v.pl:SafeSetPos(pos)

					for _, wep in ipairs(v.pl:GetBVar('PreSpectateWeps') or {}) do
						v.pl:Give(wep)
					end
				end)
				
				continue
			end
			v.pl:SetPos(v.targ:EyePos())
		end
	end
	hook.Add('Think', 'ba.HandleSpectate', handleSpectate)
end

nw.Register 'Spectating'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()