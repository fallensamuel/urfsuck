local oop = medialib.load("oop")

local TwitchService = oop.class("TwitchService", "HTMLService")

local all_patterns = {
	"https?://www.twitch.tv/([A-Za-z0-9_%-]+)",
	"https?://twitch.tv/([A-Za-z0-9_%-]+)"
}

function TwitchService:parseUrl(url)
	for _,pattern in pairs(all_patterns) do
		local id = string.match(url, pattern)
		if id then
			return {id = id}
		end
	end
end

function TwitchService:isValidUrl(url)
	return self:parseUrl(url) ~= nil
end

local player_url = "http://wyozi.github.io/gmod-medialib/twitch.html?channel=%s"
function TwitchService:resolveUrl(url, callback)
	local urlData = self:parseUrl(url)
	local playerUrl = string.format(player_url, urlData.id)

	callback(playerUrl, {start = urlData.start})
end

function TwitchService:directQuery(url, callback)
	local urlData = self:parseUrl(url)
	local metaurl = string.format("https://api.twitch.tv/kraken/channels/%s", urlData.id)

	http.Fetch(metaurl, function(result, size)
		if size == 0 then
			callback("http body size = 0")
			return
		end

		local data = {}
		data.id = urlData.id

		local jsontbl = util.JSONToTable(result)

		if jsontbl then
			if jsontbl.error then
				callback(jsontbl.message)
				return
			else
				data.title = jsontbl.display_name .. ": " .. jsontbl.status
			end
		else
			data.title = "ERROR"
		end

		callback(nil, data)
	end, function(err) callback("HTTP: " .. err) end)
end

medialib.load("media").registerService("twitch", TwitchService)
