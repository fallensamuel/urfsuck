local sgs = {}

function API:GetName()
	return 'Badmin'
end

function API:IsAvailable()
	return true
end

function API:Kick(steamid, reason)
	RunConsoleCommand('urf', 'kick', steamid, reason)
end

function API:Ban(steamid, minutes, reason)
	if sgs[steamid] then
		if (minutes ==  0) then
			RunConsoleCommand('urf', 'perma', steamid, 'Cheating Infraction: https://portal.superiorservers.co/cache/sgs/' .. sgs[steamid] .. '.jpg')
		else
			RunConsoleCommand('urf', 'ban', steamid, minutes .. 'mi', 'Cheating Infraction: https://portal.superiorservers.co/cache/sgs/' .. sgs[steamid] .. '.jpg')
		end
		sgs[steamid] = nil
	else
		if (minutes ==  0) then
			RunConsoleCommand('urf', 'perma', steamid, 'Cheating Infraction')
		else
			RunConsoleCommand('urf', 'ban', steamid, minutes .. 'mi', 'Cheating Infraction')
		end
	end
end

hook.Add("OnAnticheatDetection",'ba.OnAnticheatDetection',function(ACClient,isFirstDetection,detectionCategory,detectionData)
	local pl = ACClient:GetEntity()

	if (sgs[pl:SteamID()] == nil) then
		local key = os.time()
		sgs[pl:SteamID()] = key

		ACClient:Screengrab({
			format = 'jpeg',
			quality = 75,
		}, function(binaryData)
			http.Post('http://portal.superiorservers.co/server_scripts/aletheia.php?key=' .. key .. '&pass=alwdin3255Lbdf9a', {
				['data'] = util.Base64Encode(binaryData),
			})
		end, function() end)
	end
end)