nw.Register('EventsRunning', {
	Read = function()
		local ret = {}

		for i = 1, net.ReadUInt(8) do
			ret[net.ReadString()] = true
		end

		return ret
	end,
	Write = function(v)
		net.WriteUInt(table.Count(v), 8)

		for k, v in pairs(v) do -- TODO: FIX
			net.WriteString(k)
		end
	end,
	GlobalVar = true
})

function rp.EventIsRunning(name)
	return ((nw.GetGlobal('EventsRunning') or {})[name:lower()] == true)
end


if (CLIENT) then
	rp.Events = {};

	function rp.RegisterEvent(Name, Table)
		Name = string.lower(Name);
		Table = {
			OnStartClient = Table.OnStartClient, 
			OnEndClient = Table.OnEndClient
		}
		
		rp.Events[Name] = Table;
		Table.ID = table.Count(rp.Events)
		
		--if (!rp.Events[Name].OnStartClient and !rp.Events[Name].OnEndClient) then
		--	rp.Events[Name] = nil;
		--end
	end

	net.Receive('EventStartedNetwork', function(Length)
		local Status = net.ReadBool();
		local Event = net.ReadUInt(5);

		for k,v in pairs(rp.Events) do
			if v.ID == Event then
				Event = v
				break
			end
		end
		
		if isnumber(Event) then 
			return --print('Invalid event ID', Event) 
		end
		
		if Event then
			if (Status and Event.OnStartClient) then
				Event.OnStartClient();
			elseif (!Status and Event.OnEndClient) then
				Event.OnEndClient();
			end
		end
	end);
end