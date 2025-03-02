util.AddNetworkString 'ba.NotifyString'
util.AddNetworkString 'ba.NotifyTerm'

local str_rep = string.Replace;
local function TermToMsg(id, ...)
	local msg = ba.Terms[id];
	if (!msg) then return 'TERM NOT EXISTS' end

	local ind = 1;
	local str = '';

	local t;
	for k = 1, #msg do
		t = msg[k];
		if (t == '#') then
			t = '#' .. ind;
			ind = ind + 1;
		end
		str = str .. t;
	end

	ind = 1;
	local sol;
	for k, v in ipairs({...}) do
		t = type(v);
		sol = v;
		if (t == 'Player') then
			sol = (IsValid(v) and (v:Name() .. '(' .. v:SteamID() .. ')')) or 'Unknown Player';
		elseif (t == 'Entity') then
			sol = (IsValid(v) and (v:GetClass())) or 'Unknown Entity';
		end
		str = str_rep(str, '#' .. ind, sol);
		ind = ind + 1;
	end

	return str
end

function ba.notify(recipients, msg, ...)
	if (!IsValid(recipients)) then
		if (isstring(msg)) then
			print('[BAdmin:Notify] ' .. msg);
			return
		else
			print('[BAdmin:Notify] ' .. TermToMsg(msg, ...));
			return
		end
	end

	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteBit(0)
			ba.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('ba.NotifyTerm')
			net.WriteBit(0)
			ba.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function ba.notify_err(recipients, msg, ...)
	if (!IsValid(recipients)) then
		if (isstring(msg)) then
			print('[BAdmin:Error] ' .. msg);
			return
		else
			print('[BAdmin:Error] ' .. TermToMsg(msg, ...));
			return
		end
	end

	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteBit(1)
			ba.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('ba.NotifyTerm')
			net.WriteBit(1)
			ba.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function ba.notify_all(msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteBit(0)
			ba.WriteMsg(msg, ...)
		net.Broadcast()
	else
		net.Start('ba.NotifyTerm')
			net.WriteBit(0)
			ba.WriteTerm(msg, ...)
		net.Broadcast()
	end
end

function ba.notify_staff(msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteBit(0)
			ba.WriteMsg(msg, ...)
		net.Send(ba.GetStaff())
	else
		net.Start('ba.NotifyTerm')
			net.WriteBit(0)
			ba.WriteTerm(msg, ...)
		net.Send(ba.GetStaff())
	end
end