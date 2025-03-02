rp.Events = rp.Events or {}
rp.EventsRunning = rp.EventsRunning or {}

util.AddNetworkString('EventStartedNetwork');

local count = 0

function rp.RegisterEvent(name, tab)
	name = name:lower()
	local OnStart = tab.OnStart or function() end

	tab.name = name
	
	tab.OnStart = function(...)
		for k, v in pairs(tab.Hooks or {}) do
			hook(k, 'event.' .. name, v)
		end

		local events = nw.GetGlobal('EventsRunning') or {}
		events[name] = true
		nw.SetGlobal('EventsRunning', events)
		OnStart(...)
	end

	local OnEnd = tab.OnEnd or function() end

	tab.OnEnd = function(...)
		for k, v in pairs(tab.Hooks or {}) do
			hook.Remove(k, 'event.' .. name)
		end

		local events = nw.GetGlobal('EventsRunning') or {}
		events[name] = nil
		nw.SetGlobal('EventsRunning', events)
		
		rp.EventsRunning[tab.NiceName] = nil
		count = table.Count(rp.EventsRunning)
		
		OnEnd(...)
	end

	if (not tab.Think) then
		tab.Think = function() end
	end

	rp.Events[name] = tab
	tab.ID = table.Count(rp.Events)
end

function rp.StartEvent(name, seconds)
	local event = rp.Events[name]
	rp.EventsRunning[event.NiceName] = event
	rp.EventsRunning[event.NiceName].EndTime = CurTime() + seconds
	count = table.Count(rp.EventsRunning)
	
	event.OnStart(seconds)

	net.Start('EventStartedNetwork');
		net.WriteBool(true);
		net.WriteUInt(event.ID, 5);
	net.Broadcast();
end

function rp.EndEvent(name, callback)
	local event = rp.Events[name]
	
	if rp.EventsRunning[event.NiceName] then
		event.OnEnd()

		net.Start('EventStartedNetwork');
			net.WriteBool(false);
			net.WriteUInt(event.ID, 5);
		net.Broadcast();
		
		if callback then
			callback()
		end
	end
end

timer.Create('rp.EventsThink', 1, 0, function()
	rp.HostName = rp.HostName or GetHostName()
	local name = rp.HostName
	local c = 0

	for k, v in pairs(rp.EventsRunning) do
		c = c + 1
		v.Think()

		if (v.EndTime <= CurTime()) then
			rp.NotifyAll(NOTIFY_ERROR, rp.Term('EventEnded'), v.NiceName)
			rp.EndEvent(v.name)
		end

		name = name .. ((c == 1) and ' | ' or ', ') .. v.NiceName
	end

	RunConsoleCommand('hostname', name .. ((count >= 1) and ' ' .. translates.Get('Ивент') or ''))
end)

hook.Add("PlayerDataLoaded", "rp.ClientsideEvent", function(ply)
	timer.Simple(5, function()
		for k, v in pairs(rp.EventsRunning) do
			if not v.OnStartClient then continue end
			
			net.Start('EventStartedNetwork')
				net.WriteBool(true);
				net.WriteUInt(v.ID, 5);
			net.Send(ply)
		end
	end)
end)
