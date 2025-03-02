-- "gamemodes\\rp_base\\entities\\entities\\urfim_video\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")
include("cl_menu.lua")
include("cl_youtubeapi.lua")
include("cl_twitchapi.lua")

local DontShowMessages = true
local white_col = Color(255, 255, 255)
local white_col_d = Color(100, 100, 100)
local bg_col = Color(255, 255, 255, 15.3)
local dark = Color(0, 0, 0, 200)
local cvar_volume = GetConVar( "volume" );

local function DrawShadowText(txt, font, x, y, r, b)
    surface.SetFont(font)
    local w, h = surface.GetTextSize(txt)

    surface.SetDrawColor(dark)
    surface.DrawRect(x - 4 - (r and w or 0), y - 4 - (b and h or 0), w + 8, h + 8)

    return draw.SimpleText(txt, font, x, y, whitecol, r and TEXT_ALIGN_RIGHT or TEXT_ALIGN_LEFT, b and TEXT_ALIGN_BOTTOM or TEXT_ALIGN_TOP) 
end

surface.CreateFont("urfim.videoplayer.metatitle", {
    font     = "Montserrat",
    extended = true,
    size     = 32 * 0.8,
})

surface.CreateFont("urfim.videoplayer.playtime", {
    font     = "Montserrat",
    extended = true,
    size     = 18 * 0.8,
})


function ENT:Draw()
    self:DrawModel()
    self.LastDraw = CurTime()
end


function ENT:CreateVideoPanel(w, h)
    local pnl = vgui.Create("DHTML")
    pnl:SetSize(w or 820, h or 485)
    pnl:SetPaintedManually(true)

    local oldcm = pnl._OldCM or pnl.ConsoleMessage
    pnl._OldCM = oldcm
    pnl.ConsoleMessage = function(me, msg)
        if msg and DontShowMessages then 
            if string.find(msg, "XMLHttpRequest", nil, true) then return
            elseif string.find(msg, "Unsafe JavaScript attempt to access", nil, true) then return
            elseif string.find(msg, "Unable to post message to", nil, true) then return
            elseif string.find(msg, "ran insecure content from", nil, true) then return
            elseif string.find(msg, "Mixed Content:", nil, true) then return
            elseif string.find(msg, "A cookie associated with a cross-site", nil, true) then return end
        end

        return oldcm(me, msg)
    end
    pnl:AddFunction("console", "warn", function(param)
        if DontShowMessages then return end 
        pnl:ConsoleMessage(param)
    end)

    pnl.GetPlaying = function(me)
        return me.PlayingID or ""
    end
    pnl.SetPlaying = function(me, video_obj, yt)
        local obj = yt and Youtube or Twitch
        obj.PlayVideo(obj, me, video_obj.id)
    end

    local setVol = [[
        var ytplayer = document.getElementById("movie_player");
        var twplayer = document.getElementsByTagName("video")[0];

        if (ytplayer) {
            ytplayer.setVolume(%s);
        } else if (twplayer) {
            twplayer.volume = %s;
        }
    ]];
    local syncTime = [[
        var ytplayer = document.getElementById('movie_player');
        if (ytplayer && (%s - ytplayer.getCurrentTime()) > 1) {
            ytplayer.seekTo(%s);
        }
    ]];
    pnl.Imitate3DSound = function(me)
        if not system.HasFocus() then
            me:RunJavascript(setVol:format(0, 0))
            return
        end

        local dist = self:GetPos():DistToSqr(LocalPlayer():GetPos())
        local mult = LocalPlayer():CanSeeEnt(self) and 0.5 or 1 
        local v = math.Clamp( (100 - dist * 0.0005 * mult) * cvar_volume:GetFloat(), 0, 100 );
        
        if IsValid(self.ScreenPanel) and v <= 0 then
            self.ScreenPanel:Remove();
            return
        end

        me:RunJavascript( setVol:format(v, v / 100) )
    end
    pnl.SyncTime = function(me, time)
        me:RunJavascript( syncTime:format( time, time ) );
    end

    pnl.Think = function(me)
        if not IsValid(self) then
            me:Remove()
            return
        end

        if me:GetPlaying() == "" then return end

        me:Imitate3DSound()
    end

    return pnl
end

function ENT:GetVideoPanel(w, h)
    if not IsValid(self.ScreenPanel) then
        self.ScreenPanel = self:CreateVideoPanel(w, h)
    end

    return self.ScreenPanel
end

ENT.DrawModules = {}

local term1 = translates.Get("Смените версию игры на Chromium")
local term2 = translates.Get("нажмите [E] чтобы узнать как")
local red_col = Color(225, 35, 35)

function ENT.DrawModules.Awesomium(w, h, hover)
    if not Youtube.IsChromium then
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(term1, "urfim.videoplayer.metatitle", w*0.5, h*0.5, white_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(term2, "urfim.videoplayer.metatitle", w*0.5, h*0.5, white_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        return true
    end
end

function ENT.DrawModules.Play(self, video, w, h)
    local pnl = self:GetVideoPanel(w, h)

    if pnl:GetPlaying() ~= video.id then
        pnl:SetPlaying(video, self:GetService() == 0)
    end

    surface.SetDrawColor(33, 35, 36, 255) 
    surface.DrawRect(0, 0, w, h)

    pnl:SyncTime(video.time)
    pnl:PaintManual()
end

function ENT.DrawModules.Idle(self, w, h, hovered)
    if IsValid(self.ScreenPanel) then
        self.ScreenPanel.Remove(self.ScreenPanel)
    end

    surface.SetDrawColor(33, 35, 36, 255)
    surface.DrawRect(0, 0, w, h)

    if self.YTBranding then
        local c = hovered and 175 or 225
        surface.SetDrawColor(c, c, c, 255)
        surface.SetMaterial(self.YTBranding)

        local size = 0.3 * h
        local size_2 = 0.5 * size
        surface.DrawTexturedRect(w*0.5 - size_2, h*0.5 - size_2, size, size)
    end
end

local press_E = translates.Get("Нажмите E чтобы запустить видео")
function ENT.DrawModules.Interact(self, video, w, h, drawVideo)
    if drawVideo then
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 25)
        surface.DrawRect(0, h - 10, w, 10)
        surface.SetDrawColor(255, 255, 255, 100)
        surface.DrawRect(0, h - 10, w * video.precent, 10)

        if video.meta.title then
            DrawShadowText(video.meta.title, "urfim.videoplayer.metatitle", 10, 10)
        end

        local len = video.meta.length or 0
        DrawShadowText(ba.str.FormatTime(len * video.precent, true).." / "..ba.str.FormatTime(len, true), "urfim.videoplayer.playtime", 10, h - 18, false, true)

        if video.whostart then
            local _w, _h = DrawShadowText(video.whostart, "urfim.videoplayer.playtime", w - 10, 10, true)
            local _w, _h2 = DrawShadowText(Youtube.IsChromium and "chromium" or "awesomium", "urfim.videoplayer.playtime", w - 10, 18 + _h, true)
            DrawShadowText("youtube", "urfim.videoplayer.playtime", w - 10, 26 + _h + _h2, true)
        else
            local _w, _h = DrawShadowText(Youtube.IsChromium and "chromium" or "awesomium", "urfim.videoplayer.playtime", w - 10, 10, true)
            DrawShadowText("youtube", "urfim.videoplayer.playtime", w - 10, 18 + _h, true)
        end
    else
        draw.SimpleText(press_E, "urfim.videoplayer.metatitle", w*0.5, h*0.9, white_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function ENT.DrawModules.PlayTwitch(self, video, w, h, drawVideo)
    local pnl = self:GetVideoPanel(w, h)

    if pnl:GetPlaying() ~= video.id then
        pnl:SetPlaying(video)
    end

    surface.SetDrawColor(33, 35, 36, 255) 
    surface.DrawRect(0, 0, w, h)

    pnl:PaintManual()
end
function ENT.DrawModules.InteractTwitch(self, video, w, h, drawVideo)
    if drawVideo then
        surface.SetDrawColor(0, 0, 0, 50)
        surface.DrawRect(0, 0, w, h)

        local ypos = 10

        if video.meta.nick then
            DrawShadowText(video.meta.nick, "urfim.videoplayer.metatitle", 10, ypos)
            ypos = ypos + 33
        end

        if video.meta.status then
            local txt = video.meta.status
            if utf8.len(txt) > 68 then
                txt = txt:sub(1, 68) .."..."
            end
            DrawShadowText(txt, "urfim.videoplayer.metatitle", 10, ypos)
            ypos = ypos + 33
        end

        if video.whostart then
            local _w, _h = DrawShadowText(video.whostart, "urfim.videoplayer.playtime", w - 10, 10, true)
            local _w, _h2 = DrawShadowText(Youtube.IsChromium and "chromium" or "awesomium", "urfim.videoplayer.playtime", w - 10, 18 + _h, true)
            DrawShadowText("twitch", "urfim.videoplayer.playtime", w - 10, 26 + _h + _h2, true)
        else
            local _w, _h = DrawShadowText(Youtube.IsChromium and "chromium" or "awesomium", "urfim.videoplayer.playtime", w - 10, 10, true)
            DrawShadowText("twitch", "urfim.videoplayer.playtime", w - 10, 18 + _h, true)
        end
    else
        draw.SimpleText(press_E, "urfim.videoplayer.metatitle", w*0.5, h*0.9, white_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

local enableDebug = false
local nextDebug = 0

function ENT:__DrawScreen(w, h)
    local CT = CurTime()

    local youtube = self:GetService() == 0

    local ProcessTwitchMeta = youtube and function(id, c)
        c(id == "" and {} or Youtube:GetMetaData(id))
    end or function(id, c)
        Twitch:GetMetaData(id, c)
    end

    ProcessTwitchMeta(self:GetVideoID(), function(meta)

        local video = {}
        video.id    = self:GetVideoID()
        video.youtube = youtube
        video.start = self:GetStartTime()
        video.time  = video.start > 0 and CT - video.start or 0
        video.meta  = meta or {}
        if video.meta.length then
            video.precent = video.time / video.meta.length
        else
            video.precent = 0
        end
        video.whostart = self:GetWhoStart()

        if enableDebug and nextDebug <= CurTime() then
            nextDebug = CurTime() + 1
            PrintTable(video)
        end

        local drawVideo = video.id ~= "" and video.start ~= 0
        if drawVideo and youtube and (not video.meta.length or video.time > video.meta.length) then 
            drawVideo = false
        end

        local hover = self == LocalPlayer():GetEyeTrace().Entity

        if self.DrawModules.Awesomium(w, h, hover) then return end

        if drawVideo then
            if youtube then
                self.DrawModules.Play(self, video, w, h, hover)
            else
                self.DrawModules.PlayTwitch(self, video, w, h, hover)
            end
        else
            self.DrawModules.Idle(self, w, h, hover)
        end

        if hover then
            if youtube then
                self.DrawModules.Interact(self, video, w, h, drawVideo)
            else
                self.DrawModules.InteractTwitch(self, video, w, h, drawVideo)
            end
        end
    end)
end

local angles = Angle(0, 90, 90)
function ENT:DrawScreen()
    local maxs = self:OBBMaxs()
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Right(), angles.p)
    ang:RotateAroundAxis(ang:Up(), angles.y)
    ang:RotateAroundAxis(ang:Forward(), angles.r)

    cam.Start3D2D(self:LocalToWorld(Vector(maxs.x - 0.5, -maxs.y + 1.5, maxs.z -2)), ang, 0.07)
        self:__DrawScreen(820, 485)
    cam.End3D2D()
end

local GetIco = function(url, callback)
    local mat = wmat.Get(url)
    if mat then callback(mat) end

    wmat.Create(url, {
        URL = url,
        W = 64,
        H = 64
    }, function(mat)
        callback(mat)
    end, function() end)
end

function ENT:Initialize()
    GetIco("https://i.imgur.com/OYM5vgZ.png", function(mat)
        if IsValid(self) then
            self.YTBranding = mat
            Youtube.Branding = mat
            self.YTBranding.SetInt(self.YTBranding, "$flags", bit.bor(self.YTBranding.GetInt(self.YTBranding, "$flags"), 32768)) 
        end
    end)

    GetIco("https://i.imgur.com/1CI4BSV.png", function(mat)
        Twitch.Branding = mat
    end)

    local hook_name = "urf.im/video/"..self:EntIndex()
    hook.Add("PostDrawOpaqueRenderables", hook_name, function( bDrawingDepth, bDrawingSkybox )
        if not IsValid(self) then
            hook.Remove("PostDrawOpaqueRenderables", hook_name)
            return
        end

        if bDrawingSkybox then return end

        if self.LastDraw and (self.LastDraw + 0.1) < CurTime() then
            return
        end

        self:DrawScreen()
    end)
end