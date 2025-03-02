net('rp.NotifyString', function()
	notification.AddLegacy(rp.ReadMsg(), net.ReadUInt(2), 4)
end)

net('rp.NotifyTerm', function()
	local term = rp.ReadTerm()
	
	if term then
		notification.AddLegacy(term, net.ReadUInt(2), 4)
	end
end)

function rp.NotifyTerm(type, term, ...)
	rp.Notify(type, rp.GetTerm(term), ...)
end

function rp.Notify(notify_type, msg, ...)
	local replace = {...}
	local count = 0

	if isnumber(msg) then
		msg = rp.Terms[msg]
	end
	
	msg = msg:gsub('#', function()
		count = count + 1
		local v = replace[count]
		local t = type(v)

		if (t == 'Player') then
			if (not IsValid(v)) then return 'Unknown' end

			return v:Name()
		elseif (t == 'Entity') then
			if (not IsValid(v)) then return 'Invalid Entity' end

			return (v.PrintName and v.PrintName or v:GetClass())
		end

		return v
	end)

	notification.AddLegacy(msg, notify_type, 4)
end