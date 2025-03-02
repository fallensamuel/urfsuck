-- "gamemodes\\rp_base\\entities\\entities\\urfim_video\\cl_youtubeapi.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local function ISO8601ToTime(dur)
    local a = {}

    for part in string.gmatch(dur, "%d+") do
        table.insert(a, part)
    end

    if dur:find("M") and not (dur:find("H") or dur:find("S")) then
        a = {0, a[1], 0}
    end

    if dur:find("H") and not dur:find("M") then
        a = {a[1], 0, a[2]}
    end

    if dur:find("H") and not (dur:find("M") or dur:find("S")) then
        a = {a[1], 0, 0}
    end

    dur = 0

    if #a == 3 then
        dur = dur + tonumber(a[1]) * 3600
        dur = dur + tonumber(a[2]) * 60
        dur = dur + tonumber(a[3])
    end

    if #a == 2 then
        dur = dur + tonumber(a[1]) * 60
        dur = dur + tonumber(a[2])
    end

    if #a == 1 then
        dur = dur + tonumber(a[1])
    end

    return dur
end

local function LookupTable(tab, ...)
    local out = tab

    for k, v in pairs({...}) do
        if out[v] then
            out = out[v]
        else
            return
        end
    end

    return out
end

local urlencode, urldecode = string.URLEncode, string.URLDecode;

local function parseurl(s)
    local params = {}

    for k, v in s:gmatch('([^&=?]-)=([^&=?]+)') do
        params[k] = urldecode(v)
    end

    return params
end

Youtube = Youtube or {
    PlayerURL = "http://www.youtube.com/embed/",
    VP9PlayerURL = "http://www.youtube.com/embed/",
    MetadataURL = "https://www.googleapis.com/youtube/v3/videos?id=%s&key=%s&type=video&part=contentDetails,snippet,status&videoEmbeddable=true&videoSyndicated=true",
    ApiKey = _YT_ApiKey or "",
    ResultsCache = {},
    HelperCache = {},
    MetadataCache = {},
    V9Cache = {},
    Processing = {},
    LastDebug = "",
}

Youtube.IsChromium = BRANCH == "x86-64"

Youtube.Debug = false 
Youtube.AntiSrach = false 

if _YT_ApiKey then
    Youtube.ApiKey = _YT_ApiKey
end

net.Receive("urfim_videokey", function()
    _YT_ApiKey = net.ReadString()
    Youtube.ApiKey = _YT_ApiKey
end)

local col1 = Color(210, 45, 45)
local col2 = Color(225, 225, 225)

function Youtube:DoDebug(str)
    if not self.Debug or (self.AntiSrach and self.LastDebug == str) then return end

    self.LastDebug = str
    MsgC(col1, "[YoutubeAPI DEBUG] ", col2, str, "\n")
end

function Youtube:Search(query, nextpage_token, CallbackVideo, CallbackNextPage, OnSuccess)
    local url = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=15&order=relevance&q="
    if query then
        url = url .. urlencode(query)
    end
    if nextpage_token then
        url = url .."&pageToken=".. nextpage_token
    end

    local _cahce = self.ResultsCache[query or ""]
    if _cahce then
        self:DoDebug("Returning Cached Data from Search API!")
        
        OnSuccess()

        for i, video in pairs(_cahce.videos) do
            CallbackVideo(video)
        end

        CallbackNextPage(_cahce.nextPage, nextpage_token)
        return
    end

    if (self.LastRequest or 0) + 5 > CurTime() then
        timer.Create("YoutubeDataAPIQuenue", 5, 1, function()
            self:Search(query, nextpage_token, CallbackVideo, CallbackNextPage, OnSuccess)
        end)
        return
    end
    self.LastRequest = CurTime()

    url = url .."&key=".. self.ApiKey

    self:DoDebug("Fetching Search API!")

    http.Fetch(url, function(result)
        if not result or #result < 1 then return end
        local tab = util.JSONToTable(result)
        if not tab or not tab.items then print("ERROR", tab, result) return end

        self.ResultsCache[query or ""] = {
            nextPage = tab.nextPageToken,
            videos = {}
        }
        local link = self.ResultsCache[query or ""].videos

        OnSuccess()

        for i, vid in pairs(tab.items) do
            local video = {}
            video.id = vid.id.videoId
            video.title = vid.snippet.title
            video.thumbnail = vid.snippet.thumbnails.default.url
            video.author = vid.snippet.channelTitle
            video.publishTime = vid.snippet.publishTime

            table.insert(link, video)
            CallbackVideo(video)
        end

        CallbackNextPage(tab.nextPageToken, nextpage_token)
    end, print)
end

function Youtube:SearchHelper(query, callback)
    if #query < 1 then return end

    query = string.Trim(query, " ")

    if self.HelperCache[query] then
        self:DoDebug("Returning Cached Data from SearchHelper API!")

        for k, v in pairs(self.HelperCache[query]) do
            if k > 10 then return end
            callback(v)
        end
        return
    end

    self:DoDebug("Fetching SearchHelper API!")

    local url = "https://clients1.google.com/complete/search?client=youtube&hl=ru&gl=ru&gs_rn=64&gs_ri=youtube&ds=yt&cp=11&gs_id=1e&callback=google.sbox.p50&ie=utf8&oe=utf8&gs_gbg=J845T10nS&q=".. urlencode(query)
    http.Fetch(url, function(result)
        if not result or #result < 1 then return end
        result = result:sub(36)
        result = result:sub(1, #result - 1)
        local tab = util.JSONToTable(result)
        if not tab or not tab[2] then print(result) return end

        self.HelperCache[query] = {}

        for k, v in pairs(tab[2]) do
            if not v or not v[1] then continue end

            local callbacks = table.insert(self.HelperCache[query], v[1])

            if callbacks < 10 then 
                callback(v[1])
            end
        end
    end, print)
end

function Youtube:GetMetaData(video_id)
    if self.MetadataCache[video_id] then
        self:DoDebug("Returning Cached Data from MetaData API!")
        return self.MetadataCache[video_id]
    end

    if (self.LastMetaRequest or 0) + 5 > CurTime() then
        return
    end
    self.LastMetaRequest = CurTime()

    self:DoDebug("Fetching MetaData API!")

    http.Fetch(self.MetadataURL.format(self.MetadataURL, video_id, self.ApiKey), function(response)
        local result = util.JSONToTable(response)
        if not result or not result.items or not result.items[1] then print("ERROR YT-MetaData", response) return end

        if result.error then
            print("Failed to load YT-Video MetaData. ERROR:")
            if istable(result.error) then PrintTable(result.error) else print(result.error) end
            return
        end

        local reuslts = LookupTable(result, "pageInfo", "totalResults")
        if not reuslts or reuslts < 1 then
            print("Failed to load YT-Video MetaData. Requested video wasn't found")
            return
        end

        result = result.items[1]
        local snippet = result.snippet

        if not result.status or not result.status.embeddable then
            print("Failed to load YT-Video MetaData. Requested video was embed disabled")
            return
        end

        local metadata = {}
        metadata.title = snippet.title
        metadata.length = 0
        if snippet.liveBroadcastContent == "none" then
            metadata.length = math.max(1, ISO8601ToTime(LookupTable(result, "contentDetails", "duration")) )
        end
        metadata.thumbnail = LookupTable(snippet, "thumbnails", "medium", "url")

        self.MetadataCache[video_id] = metadata
    end, function(code)
        print("Failed to load YouTube Video MetaData ["..tostring(code).."]")
    end)
end

local required_formats = {["video/webm"] = true, ["audio/webm"] = true}
function Youtube:GetVP9(video_id, callback)
    print(video_id)
    if self.V9Cache[video_id] then
        self:DoDebug("Returning Cached Data from GetVP9 API!")
        return callback(self.V9Cache[video_id])
    end

    self:DoDebug("Fetching Data from GetVP9 API!")
    http.Fetch("http://youtube.com/get_video_info?video_id="..video_id, function(response)
        local info = parseurl(response)
        if info.status == nil or info.status ~= "ok" or info.player_response == nil then return end

        local player_response = util.JSONToTable(info.player_response)
        if player_response == nil then return end

        if player_response.streamingData == nil then
            self:DoDebug("ERROR Fetning GetVP9 API! player_response:")
            if self.Debug then
                PrintTable(player_response)
            end
            return
        end

        local adaptiveFormats = player_response.streamingData.adaptiveFormats

        local videos = {}
        local videos_byquality = {}
        local sounds = {}
        
        for i, media in pairs(adaptiveFormats) do
            local format = string.Split(media.mimeType, ";")[1]
            if required_formats[format] == nil then continue end

            (format == "video/webm" and videos or sounds)[media.bitrate] = media.url
            if format == "video/webm" then
                videos_byquality[ string.match(media.qualityLabel, "%d[%d]*") ] = media.url
            end
        end

        local result = {
            video = (videos_byquality[480] or videos_byquality[720] or videos_byquality[360] or videos[math.max( unpack(table.GetKeys(videos)) )]),
            audio = sounds[math.max( unpack(table.GetKeys(sounds)) )], 
        }

        self:DoDebug("Caching Fetched Data from GetVP9 API!")
        self.V9Cache[video_id] = result
        callback(result)
    end)
end

function Youtube:PlayVideo(video_panel, video_id, timing)
    video_panel.PlayingID = video_id

    local url = self.PlayerURL .. video_id .. "?autoplay=1&enablejsapi=1"
    if timing then
        url = url .."&timed=1&start=".. timing
    end

    video_panel:OpenURL(url)
end
