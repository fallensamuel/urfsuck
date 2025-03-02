local db = rp._Stats
local col = Color(255, 150, 0)
local white = Color(255, 255, 255)

timer.Create('rp.GlobalChat', 1, 0, function()
	if (!rp.cfg.EnableGlobalChat) then
		timer.Remove('rp.GlobalChat')
		return
	end
	if not info or not info.ChatPrefix or info.Dev then return end

	db:Query('SELECT * FROM global_chat WHERE Server !="' .. info.ChatPrefix .. '";', function(data)
		if data and data[1] then
			for k, v in ipairs(data) do
				rp.GlobalChat(CHAT_CROSSSERVER, col, '[' .. v.Server .. ']', pcolor.DecodeRGB(v.Color), v.Name, white, ': ' .. v.Message)
			end

			db:Query('DELETE FROM global_chat WHERE Server != "' .. info.ChatPrefix .. '";')
		end
	end)
end)

local curStep = 1

function automatedAnnouncement()
	local msg = rp.cfg.Announcements[curStep]
	if (not msg) then return end
	msg = msg:gsub("{(.+)}", function(s) return info[s] or s end)
	rp.GlobalChat(CHAT_NONE, col, msg)
	curStep = curStep + 1

	if (not rp.cfg.Announcements[curStep]) then
		curStep = 1
	end
end

timer.Create('OtherServerAdvert', rp.cfg.AnnouncementDelay, 0, automatedAnnouncement)

if (rp.cfg.EnableGlobalChat) then
	rp.AddCommand('/gc', function(pl, text, args)
		if not info or not info.ChatPrefix then return end
		
		if (string.len(text) <= 1) then
			pl:Notify(NOTIFY_ERROR, rp.Term('GCMessageLimit'))
		else
			rp.GlobalChat(CHAT_CROSSSERVER, col, '[' .. info.ChatPrefix .. '] ', pl:GetJobColor(), pl:Name(), white, ': ' .. text)
			db:Query('INSERT INTO global_chat VALUES("' .. info.ChatPrefix .. '", ' .. pcolor.EncodeRGB(pl:GetJobColor()) .. ', ?, ?);', pl:Name(), text)
		end
	end)

	if info and info.AltChatPrefix then
		rp.AddCommand('/' .. string.lower(info.AltChatPrefix), function(pl, text, args)
			pl:SendLua([[LocalPlayer():ConCommand('connect ]] .. info.AltServerIP .. [[')]])
		end)
	end
end