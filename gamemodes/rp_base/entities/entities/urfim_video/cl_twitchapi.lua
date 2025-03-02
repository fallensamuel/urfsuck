-- "gamemodes\\rp_base\\entities\\entities\\urfim_video\\cl_twitchapi.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
Twitch = Twitch or {
    PlayerURL = "https://player.twitch.tv/?channel=%s&html5&parent=localhost", --"https://api.incredible-gmod.ru/twitch/test/twitch.html?channel=",
    MetadataURL = "https://api.twitch.tv/kraken/channels/",
    ApiKey = _Twitch_ApiKey or "",
    Name2IdCache = {},
    MetadataCache = {},
}

if _Twitch_ApiKey then
    Twitch.ApiKey = _Twitch_ApiKey
end
 
net.Receive("urfim_videokey2", function()
    _Twitch_ApiKey = net.ReadString()
    Twitch.ApiKey = _Twitch_ApiKey
end)

function Twitch:Name2Id(name, callback)
    if self.Name2IdCache[name] then
        return callback(self.Name2IdCache[name])
    end

    if (self.LastName2IdRequest or 0) + 5 > CurTime() then
        return
    end
    self.LastName2IdRequest = CurTime()

    http.Fetch("https://api.twitch.tv/kraken/users?login=".. name, function(b)
        local obj = util.JSONToTable(b)
        if not obj then
            return print("malformed response JSON [ID]")
        end

        if not obj.users then
            return print("malformed response JSON [ID]")
        end

		if obj.users[1] and obj.users[1]._id then
			self.Name2IdCache[name] = obj.users[1]._id
			callback(self.Name2IdCache[name])
		end
    end, function()
        print("failed HTTP request [ID]")
    end, {
        Accept = "application/vnd.twitchtv.v5+json",
        ["Client-ID"] = self.ApiKey
    })
end

function Twitch:ProcessMeta(id, callback, channel)
    if self.MetadataCache[id] then
        return callback(self.MetadataCache[id])
    end

    if (self.LastMetaRequest or 0) + 5 > CurTime() then
        return
    end
    self.LastMetaRequest = CurTime()

    http.Fetch(self.MetadataURL .. id, function(b)
        local obj = util.JSONToTable(b)
        if not obj then
            return print("malformed response JSON [META]")
        end

        local metadata = {}
        metadata.title = obj.display_name ..": ".. obj.status
        metadata.status = obj.status
        metadata.nick = obj.display_name
        --metadata.length = 0
        metadata.avatar = obj.logo
        metadata.game = obj.game
        metadata.followers = obj.followers
        metadata.views = obj.views
        metadata.id = id
        metadata.channel = channel

        self.MetadataCache[id] = metadata
        callback(metadata)
    end, function()
        print("failed HTTP request [META]")
    end, {
        Accept = "application/vnd.twitchtv.v5+json",
        ["Client-ID"] = self.ApiKey
    })
end

function Twitch:GetMetaData(name, callback)
    self:Name2Id(name, function(id)
        self:ProcessMeta(id, function(meta)
            callback(meta)
        end, name)
    end)
end

function Twitch:PlayVideo(video_panel, video_id)
    video_panel.PlayingID = video_id

    video_panel:OpenURL( self.PlayerURL:format(video_id) )
end

local patterns = {
    "https?://www.twitch.tv/([A-Za-z0-9_%-]+)",
    "https?://twitch.tv/([A-Za-z0-9_%-]+)"
}

function Twitch:ParseURL(url)
    for _, pattern in pairs(patterns) do
        local id = string.match(url, pattern)
        if id then
            return id
        end
    end
end
