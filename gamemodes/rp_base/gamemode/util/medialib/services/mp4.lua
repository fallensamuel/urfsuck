local oop = medialib.load("oop")

local Mp4Service = oop.class("Mp4Service", "HTMLService")

local all_patterns = {"^https?://.*%.mp4"}

function Mp4Service:parseUrl(url)
	for _,pattern in pairs(all_patterns) do
		local id = string.match(url, pattern)
		if id then
			return {id = id}
		end
	end
end

function Mp4Service:isValidUrl(url)
	return self:parseUrl(url) ~= nil
end

local player_url = "http://wyozi.github.io/gmod-medialib/mp4.html?id=%s"
function Mp4Service:resolveUrl(url, callback)
	local urlData = self:parseUrl(url)
	local playerUrl = string.format(player_url, urlData.id)

	callback(playerUrl, {start = urlData.start})
end

function Mp4Service:directQuery(url, callback)
	callback(nil, {
		title = url:match("([^/]+)$")
	})
end

medialib.load("media").registerService("mp4", Mp4Service)
