-- "gamemodes\\darkrp\\gamemode\\addons\\autoevents\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.cfg.AutoEvents = rp.cfg.AutoEvents and rp.cfg.AutoEvents[game.GetMap()]

ba.cmd.Create('Auto Event List', function(pl, args)
	if not rp.cfg.AutoEvents or #rp.cfg.AutoEvents == 0 then
		pl:ChatPrint(translates.Get('Нет доступных ивентов для этой карты!'))
		return 
	end
	
	pl:ChatPrint(translates.Get('Доступные ивенты:'))
	
	for k, v in pairs(rp.cfg.AutoEvents) do
		pl:ChatPrint(k .. ': ' .. v.name)
	end
	
	pl:ChatPrint(translates.Get('Введите `/autoeventstart ID`, чтобы начать ивент.'))
end)
:SetFlag('x')
:SetHelp('Shows list of available events')


if not rp.cfg.AutoEvents then return end

rp.autoevents = rp.autoevents or {}

rp.autoevents.GetCurrentEvent = function()
	return rp.cfg.AutoEvents[nw.GetGlobal('AutoEventId') or -1] or {}
end


ba.cmd.Create('Auto Event Start', function(pl, args)
	rp.autoevents.Start(tonumber(args.event_id))
end)
:AddParam('string', 'event_id')
:SetFlag('x')
:SetHelp('Starts auto event')

ba.cmd.Create('Auto Event Stop', function(pl, args)
	rp.autoevents.Stop()
end)
:SetFlag('x')
:SetHelp('Stops auto event')

ba.cmd.Create('Auto Event Show Home', function(pl, args)
	rp.autoevents.ShowServerChangerNPC()
end)
:SetFlag('x')
:SetHelp('Shows server changer NPC')

ba.cmd.Create('Auto Event Hide Home', function(pl, args)
	rp.autoevents.HideServerChangerNPC()
end)
:SetFlag('x')
:SetHelp('Hides server changer NPC')

nw.Register('AutoEventId')
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetGlobal()
	
nw.Register('AutoEventScore')
	:Write(function(tbl)
		net.WriteUInt(table.Count(tbl), 16)

		for k, v in pairs(tbl) do
			net.WriteFloat(v)
		end
	end)
	:Read(function()
		local tbl = {}

		for i = 1, net.ReadUInt(16) do
			tbl[i] = net.ReadFloat()
		end

		return tbl
	end):SetGlobal()

nw.Register('AutoEventCommand')
	:Write(net.WriteUInt, 16)
	:Read(net.ReadUInt, 16)
	:SetPlayer()
