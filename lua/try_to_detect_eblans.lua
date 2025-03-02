local DoSqlRequest = function(...)
	rp.syncHours.db:Query(...)
end

hook.Add("CheckPassword", "Try2DetectThatShiet", function(steamid64, ipAddr, svpass, clpass, plyname)
	DoSqlRequest("INSERT INTO `online_log` VALUES("..os.time()..", '"..game.GetIPAddress().."', '"..steamid64..", '"..ipAddr.."';", function() end)
end)

hook.Add("Initialize", "Try2DetectThatShiet", function()
	DoSqlRequest("REPLACE INTO `server_starttime`(`time`, `server_ip`) VALUES("..os.time()..", '"..game.GetIPAddress()"';", function() end)
end)