
local totalbytes, nextquota, onet = 0, 0, onet or {
	SendToServer = net.SendToServer
}

net.SendToServer = function()
	local bytes = net.BytesWritten()
	if !bytes then return end
	totalbytes = totalbytes + bytes
	//if totalbytes > 63488 then
	//	return print("Big massage!")
	//end
	onet.SendToServer()
end

hook.Add("Tick", "_nwnil", function()
	time = CurTime()
	if nextquota < time then return end
	nextquota = time + 10
	totalbytes = 0
end)