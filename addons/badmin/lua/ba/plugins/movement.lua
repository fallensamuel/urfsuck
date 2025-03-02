ba.AddTerm('AdminGoneTo', '# телепортировался к #.')
ba.AddTerm('AdminRoomUnset', 'База Админов не назначена!')
ba.AddTerm('AdminGoneToAdminRoom', '# отправился на Базу Админов.')
ba.AddTerm('AdminRoomSet', 'База Админов обозначена.')
ba.AddTerm('AdminReturnedSelf', '# вернул себя в последнюю локацию.')
ba.AddTerm('NoKnownPosition', 'У вас нет последней локации.')
ba.AddTerm('NoKnownPositionPlayer', 'У # нет последней локации!')

-------------------------------------------------
-- Tele
-------------------------------------------------
ba.cmd.Create('Tele', function(pl, args)
	for k, v in ipairs(args.targets) do
		if (not v:Alive()) then
			v:Spawn()
		end

		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:SetBVar('ReturnPos', v:GetPos())

		v:Teleport(util.FindEmptyPos(pl:GetEyeTrace().HitPos))

	end

	ba.notify_staff(translates and translates.Get("# телепортировал к себе %s", ('# '):rep(#args.targets)) or ('# телепортировал к себе ' .. ('# '):rep(#args.targets)), pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets')
:SetFlag('M')
:SetHelp('Teleports your target/s where you are looking')
:SetIcon('icon16/arrow_up.png')
:AddAlias('tp')

-------------------------------------------------
-- Goto
-------------------------------------------------
ba.cmd.Create('Goto', function(pl, args)
	if not pl:Alive() then
		pl:Spawn()
	end
		
	if pl:InVehicle() then
		pl:ExitVehicle()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())

	local pos = util.FindEmptyPos(args.target:GetPos()) 

	pl:Teleport(pos)

	ba.notify_staff(ba.Term('AdminGoneTo'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Brings you to your target')
:SetIcon('icon16/arrow_down.png')

-------------------------------------------------
-- Sit
-------------------------------------------------
ba.cmd.Create('Adminbase', function(pl, args)
	if not pl:Alive() then
		pl:Spawn()
	end

	pl:SetBVar('ReturnPos', pl:GetPos())

	local pos = util.FindEmptyPos(rp.cfg.AdminBase[game.GetMap()])

	pl:Teleport(pos)

	ba.notify_staff(ba.Term('AdminGoneToAdminRoom'), pl)
end)
:SetFlag('M')
:SetHelp('Takes you to the admin room if one exists')

-------------------------------------------------
-- Return
-------------------------------------------------
ba.cmd.Create('Return', function(pl, args)
	if (args.targets == nil) then
		if (pl:GetBVar('ReturnPos') ~= nil) then
			if not pl:Alive() then
				pl:Spawn()
			end
			
			local pos = util.FindEmptyPos(pl:GetBVar('ReturnPos'))
			pl:Teleport(pos)

			pl:SetBVar('ReturnPos', nil)

			ba.notify_staff(ba.Term('AdminReturnedSelf'), pl)
		else
			ba.notify_err(pl, ba.Term('NoKnownPosition'))
		end
		return
	end

	for k, v in ipairs(args.targets) do
		if (v:GetBVar('ReturnPos') == nil) then
			ba.notify_err(pl, ba.Term('NoKnownPositionPlayer'), v)
			return
		end

		if not v:Alive() then
			v:Spawn()
		end
			
		if v:InVehicle() then
			v:ExitVehicle()
		end

		local pos = util.FindEmptyPos(v:GetBVar('ReturnPos'))

		v:Teleport(pos)
		v:SetBVar('ReturnPos', nil)
	end

	ba.notify_staff(translates and translates.Get("# вернул %s в последнюю локацию.", ('# '):rep(#args.targets)) or ('# вернул ' .. ('# '):rep(#args.targets) .. ' в последнюю локацию.'), pl, unpack(args.targets))
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag('M')
:SetHelp('Returns you or your tragets to their last known position')
:SetIcon('icon16/arrow_down.png')

-------------------------------------------------
-- Player physgun
-------------------------------------------------
if (SERVER) then
	hook.Add('PhysgunPickup', 'ba.PhysgunPickup.PlayerPhysgun', function(pl, ent)
		if ((ba.IsPlayer(ent) and pl:HasAccess('a') and ba.ranks.CanTarget(pl, ent) and ba.canAdmin(pl)) or false) then
			ent:SetMoveType(MOVETYPE_NOCLIP)
			ent:SetBVar('PrePhysFrozen', ent:IsFrozen())
			ent:Freeze(true)
			
			pl:SetBVar('HoldingPlayer', ent)
			return true
		end
	end)

	hook.Add('PhysgunDrop', 'ba.PhysgunDrop.PlayerPhysgun', function(pl, ent)
		if ba.IsPlayer(ent) then
			ent:Freeze(ent:GetBVar('PrePhysFrozen'))
			ent:GetBVar('PrePhysFrozen', nil)
			ent:SetMoveType(MOVETYPE_WALK) 
			
			timer.Simple(0.2, function()
				if (!pl:IsValid()) then return end
				
				pl:SetBVar('HoldingPlayer', nil)
			end)
		end
	end)

	hook.Add('KeyRelease', 'ba.KeyRelease.PlayerPhysgun', function(pl, key)
		if IsValid(pl:GetBVar('HoldingPlayer')) and (key == IN_ATTACK2) then
			pl:ConCommand('urf freeze ' ..  pl:GetBVar('HoldingPlayer'):SteamID())
		end
	end)
end

-------------------------------------------------
-- Noclip
-------------------------------------------------
hook.Add('PlayerNoClip', 'ba.PlayerNoClip', function(pl, state)
	if SERVER and pl:HasAccess('a') then
		local bool = ba.canAdmin(pl) and (pl:GetBVar('CanNoclip') ~= false) or false
		if bool then hook.Run("OnPlayerNoclip", pl, state) end
		return bool
	elseif CLIENT then
		if pl:HasAccess('a') and pl:GetBVar('CanNoclip') ~= false then
			local oldMove = pl:GetMoveType()
			timer.Simple(0.1, function()
				if IsValid(pl) then
					local newMove = pl:GetMoveType()
					if (oldMove == MOVETYPE_NOCLIP or newMove == MOVETYPE_NOCLIP) and oldMove ~= newMove then
						hook.Run("OnPlayerNoclip", pl, state)
					end
				end
			end)
		end
		return false
	end
end)

if SERVER then
	hook.Add('OnPlayerNoclip', 'HandleNoclipInvisibility', function(pl, state)
		if state then
			pl.WasNotDrawing = pl:GetNoDraw()
			
			pl:SetNoDraw(true)
			pl:SetRenderMode(RENDERMODE_TRANSALPHA)
			pl:SetMaterial("models/dog/eyeglass")
			pl:SetColor(Color(255, 255, 150))
		else
			if not pl.WasNotDrawing then
				pl:SetNoDraw(false)
				pl:SetMaterial("")
				pl:SetColor(Color(255, 255, 255))
			end
			
			pl.WasNotDrawing = nil
		end
	end)
end
