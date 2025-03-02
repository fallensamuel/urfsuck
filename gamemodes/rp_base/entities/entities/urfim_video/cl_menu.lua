-- "gamemodes\\rp_base\\entities\\entities\\urfim_video\\cl_menu.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("cl_youtubeapi.lua")
include("cl_twitchapi.lua")

local TextShadow = draw.TextShadow
local SetFont = surface.SetFont
local GetTextSize = surface.GetTextSize
local whiteCol = Color(255, 255, 255, 255)

function draw.SimpleTextShadow(text, font, xtt, ytt, colourt, xalign, yalign, distance, alpha, white)
    local data = {
        text = tostring(text),
        font = font or "DermaDefault",
        xalign = xalign or TEXT_ALIGN_LEFT,
        yalign = yalign or TEXT_ALIGN_TOP,
        pos = {xtt or 0, ytt or 0},
        colour = colourt or whiteCol
    }

    TextShadow(data, distance, alpha, white)

    SetFont(data.font)
    return GetTextSize(data.text)
end

surface.CreateFont("urfim.musicplayer.search", {
    font     = "Montserrat",
    extended = true,
    size     = 64 * 0.8,
})

surface.CreateFont("urfim.musicplayer.title", {
    font     = "Montserrat",
    extended = true,
    size     = 40 * 0.8,
})

surface.CreateFont("urfim.musicplayer.playtime", {
    font     = "Montserrat",
    extended = true,
    size     = 30 * 0.8,
})

surface.CreateFont("urfim.videoplayer.title1", {
    font     = "Montserrat",
    extended = true,
    size     = 24 * 0.8,
})

surface.CreateFont("urfim.videoplayer.title2", {
    font     = "Montserrat",
    extended = true,
    size     = 20 * 0.8,
})

surface.CreateFont("urfim.videoplayer.title3", {
    font     = "Montserrat",
    extended = true,
    size     = 42 * 0.8,
})

local LastSearch = cookie.GetString("urf.im/video/search", " ")
local LastTwitchSearch = cookie.GetString("urf.im/video/twitch_search", " ")
local white_col = Color(255, 255, 255)
local white_col_inactive = Color(200, 200, 200)
local white_col_d = Color(100, 100, 100)
local bg_col = Color(255, 255, 255, 15.3)
local dark = Color(0, 0, 0, 200)
local bg_col_hover = Color(255, 255, 255, 35)
local entry_focused_colr = Color(175, 175, 175, 20)

local notify_menu

net.Receive("urfim_video", function()
    if IsValid(menu) then
        if ActiveService == 1 then
            menu.workspace_twitch.search_input:OnEnter()
        end
        return
    end

    if not Youtube.IsChromium then
		-- gui.OpenURL("https://urf.im/page/tech#chromium")
		
		if IsValid(notify_menu) then 
			return 
		end
		
		surface.CreateFont( "rpui.Video.Font", {
			font     = "Montserrat",
			extended = true,
			weight = 500,
			size     = 21,
		} );
		
		surface.CreateFont( "rpui.Video.LabelFont", {
			font     = "Montserrat",
			extended = true,
			weight = 600,
			size     = 21,
		} );
		
		notify_menu = vgui.Create("urf.im/rpui/menus/blank")
        notify_menu:SetSize(490, 200)
        notify_menu:Center()
        notify_menu:MakePopup()

        notify_menu.header.SetIcon(notify_menu.header, "rpui/misc/flag.png")
        notify_menu.header.SetTitle(notify_menu.header, "Chromium")
        notify_menu.header.SetFont(notify_menu.header, "rpui.playerselect.title")

        notify_menu.header:SetTall(32)
        
		local btn = vgui.Create("DButton", notify_menu.workspace)
		btn:Dock(BOTTOM)
		btn:SetTall(32)
		btn:DockMargin(10, 0, 10, 10)
		btn:SetText("")
		btn:SetSize(notify_menu:GetWide(), 32)
		btn.Paint = function(me, w, h)
			local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_TRANSPARENT );
			surface.SetDrawColor( baseColor );
			surface.DrawRect( 0, 0, w, h );

			draw.SimpleText( translates.Get("Открыть инструкцию"), "rpui.Video.Font", w*0.5, h*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

			return true;
		end
		btn.DoClick = function(me)
			gui.OpenURL("https://urf.im/page/tech#chromium")
			notify_menu:Close()
		end
		
		local desc_1 = vgui.Create("DLabel", notify_menu.workspace)
		desc_1:SetFont("rpui.Video.LabelFont")
		desc_1:Dock(TOP)
		desc_1:DockMargin(10, 10, 10, 0)
		desc_1:SetSize(notify_menu:GetWide() - 20, 24)
		desc_1:SetContentAlignment(5)
		desc_1:SetText(translates.Get("Чтобы видеть видео, необходимо"))
		
		local desc_2 = vgui.Create("DLabel", notify_menu.workspace)
		desc_2:SetFont("rpui.Video.LabelFont")
		desc_2:Dock(TOP)
		desc_2:DockMargin(10, 0, 10, 0)
		desc_2:SetSize(notify_menu:GetWide() - 20, 24)
		desc_2:SetContentAlignment(5)
		desc_2:SetText(translates.Get("переключиться на Chromium версию игры."))
		
		local desc_3 = vgui.Create("DLabel", notify_menu.workspace)
		desc_3:SetFont("rpui.Video.LabelFont")
		desc_3:Dock(TOP)
		desc_3:DockMargin(10, 15, 10, 0)
		desc_3:SetSize(notify_menu:GetWide() - 20, 24)
		desc_3:SetContentAlignment(5)
		desc_3:SetText(translates.Get("Перейдите по ссылке, чтобы узнать как"))
		
        return 
    end

    local video_ent = LocalPlayer():GetEyeTrace().Entity
    if not IsValid(video_ent) or not video_ent.IsUrfVideo then return end

    local PlayingMaterials = {
        [true] = Material("error"),
        [false] = Material("error"),
    }

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

    local search_mat, arrow_left, arrow_right
    local circle_mat = Material("circle_button/circle.png")

    GetIco("https://i.imgur.com/ahzY9BV.png", function(mat) PlayingMaterials[true] = mat end)
    GetIco("https://i.imgur.com/fJxpX5r.png", function(mat) PlayingMaterials[false] = mat end)
    GetIco("https://i.imgur.com/Gc7ELiI.png", function(mat) search_mat = mat end)
    GetIco("https://i.imgur.com/A1bRV6g.png", function(mat) arrow_left = mat end)
    GetIco("https://i.imgur.com/IS7NjRE.png", function(mat) arrow_right = mat end)

    menu = vgui.Create("urf.im/rpui/menus/blank")
    menu:SetSize(550, 900)
    menu:Center()
    menu:MakePopup()
    menu.Think = function(me)
        if not IsValid(video_ent) then
            me:Remove()
        end
    end

    menu.btns_parent = vgui.Create("EditablePanel")
    menu.btns_parent.Think = function(me)
        if IsValid(menu) then
            me:SetAlpha(menu:GetAlpha())
        else
            me:Remove()
        end
    end
    menu.btns_parent:SetSize(52, 48 * 2 + 6)
    menu.btns_parent:SetPos(menu.X - menu.btns_parent:GetWide(), menu.Y)

    local ActiveService = cookie.GetNumber("urf.im/video/service", 0)

    local ToggleControls = function(pnl, v)
        local b = ActiveService == v
        pnl[b and "Show" or "Hide"](pnl)

        return b
    end

    local AddSerivceIcon = function(id, logo)
        local btn = menu.btns_parent:Add("DButton")
        btn:SetText("")
        btn:SetSize(48, 48)
        btn:SetPos(2, menu.btns_parent._f and (menu.btns_parent:GetTall() - btn:GetTall()) or 0)
        btn.Paint = function(me, w, h)
            draw.Blur(me)
            surface.SetDrawColor(dark)
            surface.DrawRect(0, 0, w, h)

            if logo then
                surface.SetMaterial(logo)
                surface.SetDrawColor((me:IsHovered() or ActiveService == id) and white_col or white_col_inactive)
                surface.DrawTexturedRect(w*0.2, h*0.2, w*0.6, h*0.6)
            end
        end
        btn.DoClick = function()
            ActiveService = id
            cookie.Set("urf.im/video/service", id)

            menu.header.SetIcon(menu.header, ActiveService == 0 and Youtube.Branding or Twitch.Branding)
            menu.header.SetTitle(menu.header, ActiveService == 0 and "Youtube" or "Twitch")

            menu.workspace_twitch:SetWide(menu.workspace:GetWide())
            menu.workspace_twitch:SetTall(menu.workspace:GetTall())
            menu.workspace_twitch.X = menu.workspace.X
            menu.workspace_twitch.Y = menu.workspace.Y

            ToggleControls(menu.workspace, 0)
            ToggleControls(menu.workspace_twitch, 1)

        end

        menu.btns_parent._f = btn
    end

    AddSerivceIcon(0, Youtube.Branding)
    --AddSerivceIcon(1, Twitch.Branding)

    menu.workspace_twitch = menu:Add("EditablePanel")
    menu.workspace_twitch.Y = rpui.AdaptToScreen(0, 44, {0, .7})[2]
    menu.workspace_twitch:SetSize(menu:GetSize())
    menu.workspace_twitch:SetTall(menu.workspace_twitch:GetTall() - menu.workspace_twitch.Y)
    ToggleControls(menu.workspace, 0)
    ToggleControls(menu.workspace_twitch, 1)

    local _twitch = menu.workspace_twitch

    _twitch.input = _twitch:Add("EditablePanel")
    _twitch.input:SetSize(550 - 16, 48)
    _twitch.input:SetPos(8, 8)

    _twitch.search_input = _twitch.input:Add("urf.im/rpui/txtinput")
    _twitch.search_input:Dock(FILL)
    _twitch.search_input.UID = "MusicSearch"
    _twitch.search_input:ApplyDesign()
    _twitch.search_input:SetFont("urfim.musicplayer.search")
    _twitch.search_input.m_FontName = "urfim.musicplayer.search"
    _twitch.search_input:SetFontInternal(_twitch.search_input.m_FontName)
    _twitch.search_input:SetPlaceholderText(translates.Get("Введите ссылку на twitch канал..."))

    _twitch.search_input.PaintOver = function(me, w, h)
        if not search_mat then return end

        surface.SetDrawColor(white_col)
        surface.SetMaterial(search_mat)
        surface.DrawTexturedRect(w - h*0.8, h*0.2, h*0.6, h*0.6)
    end
    _twitch.search_input.OnEnter = function(me)
        local url = me:GetValue()
        LastTwitchSearch = url
        timer.Create("urf.im/video/twitch_search", 1, 1, function()
            cookie.Set("urf.im/video/twitch_search", LastTwitchSearch)
        end)

        if IsValid(_twitch.preview_video) then
            _twitch.preview_video:Remove()
        end

        if IsValid(_twitch.play_btn) then
            _twitch.play_btn:Remove()
        end

        if IsValid(_twitch.loading) then
            _twitch.loading:Remove()
        end

        local channel = Twitch:ParseURL(url)
        if not channel then return end

        Twitch:GetMetaData(channel, function(meta)
            if not meta then return end

            if IsValid(_twitch.preview_video) then
                _twitch.preview_video:Remove()
            end

            if IsValid(_twitch.play_btn) then
                _twitch.play_btn:Remove()
            end

            if IsValid(_twitch.loading) then
                _twitch.loading:Remove()
            end

            local video_sizeW = _twitch:GetWide() - 16
            local video_sizeH = video_sizeW / (16/9)

            _twitch.preview_video = _twitch:Add("DHTML")
            _twitch.preview_video:SetSize(video_sizeW, video_sizeH)
            _twitch.preview_video.X = 8
            _twitch.preview_video.Y = 64
            _twitch.preview_video.ConsoleMessage = function() end
            Twitch:PlayVideo(_twitch.preview_video, meta.channel)

            _twitch.loading = _twitch.preview_video:Add("DHTML")
            _twitch.loading.ConsoleMessage = function() end
            _twitch.loading:Dock(FILL)
            _twitch.loading:SetHTML([[
                <style>
                    html,body{
                        height:100%;
                        margin: 0;
                        padding: 0;
                        background-color: black;
                        overflow: hidden;
                    }
                </style>
            ]])

            _twitch.preview_video.OnDocumentReady = function()
                if IsValid(_twitch.loading) then
                    _twitch.loading:Remove()
                end
            end

            _twitch.play_btn = _twitch:Add("urf.im/rpui/button")
            _twitch.play_btn:SetText(translates.Get("Выключить"))
            _twitch.play_btn:SetFont("urfim.videoplayer.title3")
            _twitch.play_btn:SizeToContentsX(10)
            _twitch.play_btn:SizeToContentsY(6)
             _twitch.play_btn:SetText(translates.Get("Включить"))
            _twitch.play_btn.X = _twitch:GetWide()*0.5 - _twitch.play_btn:GetWide()*0.5
            _twitch.play_btn.Y = 64 + _twitch.preview_video:GetTall() + 8
            _twitch.play_btn:SetPaintStyle(STYLE_TRANSPARENT)

            _twitch.play_btn.Paint = function(me, w, h)
                me:SetText(video_ent:GetVideoID() == meta.channel and translates.Get("Выключить") or translates.Get("Включить"))

                local b, f = rpui.GetPaintStyle(me, me.PaintStyle)
                surface.SetDrawColor(b)
                surface.DrawRect(0, 0, w, h)
                me:SetTextColor(f)
            end

            _twitch.play_btn.DoClick = function()
                net.Start("urfim_video")
                    net.WriteBool(false)
                    net.WriteString(meta.channel)
                net.SendToServer()
            end
        end)
    end

    if LastTwitchSearch ~= " " then
        _twitch.search_input:SetValue(LastTwitchSearch)
        _twitch.search_input:OnEnter()
    end

    _twitch.search_btn = _twitch.search_input.Add(_twitch.search_input, "DButton")
    _twitch.search_btn.SetText(_twitch.search_btn, "")
    _twitch.search_btn.SetWide(_twitch.search_btn, 48)
    _twitch.search_btn.Dock(_twitch.search_btn, RIGHT)
    _twitch.search_btn.Paint = function(me, w, h) end
    _twitch.search_btn.DoClick = function() _twitch.search_input.OnEnter(_twitch.search_input) end

    menu.header.SetIcon(menu.header, ActiveService == 0 and Youtube.Branding or Twitch.Branding)
    menu.header.SetTitle(menu.header, ActiveService == 0 and "Youtube" or "Twitch")
    menu.header.SetFont(menu.header, "rpui.playerselect.title")
    menu.header.IcoSizeMult = 1.75

    menu.input = menu.workspace.Add(menu.workspace, "EditablePanel")

    menu.input.SetSize(menu.input, 550 - 16, 48)
    menu.input.SetPos(menu.input, 8, 8)

    menu.search_input = menu.input.Add(menu.input, "urf.im/rpui/txtinput")
    menu.search_input.Dock(menu.search_input, FILL)
    menu.search_input.UID = "MusicSearch"
    menu.search_input.ApplyDesign(menu.search_input)
    menu.search_input.SetFont(menu.search_input, "urfim.musicplayer.search")
    menu.search_input.m_FontName = "urfim.musicplayer.search"
    menu.search_input.SetFontInternal(menu.search_input, menu.search_input.m_FontName)
    menu.search_input.SetPlaceholderText(menu.search_input, translates.Get("Поиск youtube..."))
    if LastSearch ~= " " then
        menu.search_input.SetValue(menu.search_input, LastSearch)
    end
    menu.search_input.PaintOver = function(me, w, h)
        if not search_mat then return end

        surface.SetDrawColor(white_col)
        surface.SetMaterial(search_mat)
        surface.DrawTexturedRect(w - h*0.8, h*0.2, h*0.6, h*0.6)
    end
    menu.search_input.OnEnter = function(me)
        local str = me:GetValue()
        LastSearch = str
        cookie.Set("urf.im/radio/search", str)
        menu:DoSearch()
    end
    menu.search_input.OnGetFocus = function(me)
        if IsValid(me.search_helper) then return end
        me.search_helper = menu.workspace.Add(menu.workspace, "EditablePanel")
        me.search_helper.scroll = me.search_helper.Add(me.search_helper, "rpui.ScrollPanel")
        me.search_helper.scroll.Dock(me.search_helper.scroll, FILL)
        me.search_helper.scroll.SetSpacingY(me.search_helper.scroll, 0)
        me.search_helper.scroll.SetScrollbarMargin(me.search_helper.scroll, 0)

        local par = me:GetParent()
        local meX, meY = par:GetPos()
        me.search_helper.SetPos(me.search_helper, meX, meY + par:GetTall())
        me.search_helper.SetSize(me.search_helper, par:GetWide(), 320)

        me.search_helper.Paint = function(me2, w, h)
            if #me:GetValue() < 1 then
                me2:SetMouseInputEnabled()
                return
            end

            me2:SetMouseInputEnabled(true)
            draw.Blur(me2)
            surface.SetDrawColor(entry_focused_colr)
            surface.DrawRect(0, 0, w, h)
        end

        me.helper_childs = {}

        if #me:GetValue() < 1 then return end
        me:DoSearchHelp()
    end
    menu.search_input.OnLoseFocus = function(me)
        timer.Simple(0.1, function()
            if not IsValid(me.search_helper) then return end
            me.search_helper.Remove(me.search_helper)
        end)
    end
    menu.search_input.OnChange = function(me)
        me:DoSearchHelp()
        timer.Simple(1, function()
            if IsValid(me) then me:DoSearchHelp() end
        end)
    end
    menu.search_input.DoSearchHelp = function(me)
        if not me.helper_childs or not IsValid(me.search_helper) then return end

        for k, v in pairs(me.helper_childs) do
            if IsValid(v) then v:Remove() end
        end
        me.helper_childs = {}

        if #me:GetValue() < 1 then return end

        Youtube:SearchHelper(me:GetValue(), function(str)
            if not IsValid(me.search_helper) or not IsValid(me.search_helper.scroll) then return end

            local new = vgui.Create("DButton")
            me.search_helper.scroll.AddItem(me.search_helper.scroll, new)
            table.insert(me.helper_childs, new)

            new:Dock(TOP)
            new.txt = str
            new:SetTall(32)
            new:SetText('')
            new.DoClick = function(me)
                menu.search_input.SetValue(menu.search_input, me.txt)
                menu.search_input.SetText(menu.search_input, me.txt)
                LastSearch = me.txt
                menu:DoSearch()
            end
            new.Paint = function(me, w, h)
                if me:IsHovered() then
                    surface.SetDrawColor(bg_col_hover)
                    surface.DrawRect(0, 0, w, h)
                end

                draw.SimpleText(me.txt, "urfim.videoplayer.title1", 4, h*0.5, white_col, nil, TEXT_ALIGN_CENTER)
            end
        end)
    end

    menu.search_btn = menu.search_input.Add(menu.search_input, "DButton")
    menu.search_btn.SetText(menu.search_btn, "")
    menu.search_btn.SetWide(menu.search_btn, 48)
    menu.search_btn.Dock(menu.search_btn, RIGHT)
    menu.search_btn.Paint = function(me, w, h) end
    menu.search_btn.DoClick = function() menu.search_input.OnEnter(menu.search_input) end

    menu.scroll = menu.workspace.Add(menu.workspace, "rpui.ScrollPanel")
    menu.scroll.SetSize(menu.scroll, menu:GetWide(), menu:GetTall() - 120)
    menu.scroll.SetPos(menu.scroll, 0, 64)
    menu.scroll.SetSpacingY(menu.scroll, 0)
    menu.scroll.SetScrollbarMargin(menu.scroll, 0)
    menu.scroll.OnMouseWheeled = function(this, dt)
        this.ySpeed = this.ySpeed + dt 
    end
    menu.scroll.InvalidateParent(menu.scroll, true)
    menu.scroll.AlwaysLayout(menu.scroll, true)

    menu.videos = {}

    menu.DoSearch = function(me, nextpage_token)
        local q = me.search_input.GetValue(me.search_input)
        cookie.Set("urf.im/video/search", q)

        local i = 0
        Youtube:Search(q, nextpage_token, function(vid)
            if not vid.id or not IsValid(me) or not IsValid(me.scroll) then return end
            i = i + 1

            local video = vgui.Create("DButton")
            me.scroll.AddItem(me.scroll, video)
            table.insert(me.videos, video)
            video.id = vid.id..""
            video:Dock(TOP)
            video:SetTall(64)
            video:DockMargin(8, i > 1 and 16 or 0, 0, 0)
            video:SetText("")
            GetIco(vid.thumbnail, function(mat)
                if IsValid(video) then
                    video.thumbnail = mat
                end
            end)

            video.Paint = function(me, w, h)
                surface.SetDrawColor(me:IsHovered() and bg_col_hover or bg_col)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(dark)
                surface.DrawRect(0, 0, h, h)

                if me.thumbnail then
                    surface.SetDrawColor(white_col)
                    surface.SetMaterial(me.thumbnail)
                    surface.DrawTexturedRect(0, 0, h, h)
                end

                local same = video_ent:GetVideoID() == me.id
                if me:IsHovered() or same then
                    surface.SetDrawColor(dark)
                    surface.SetMaterial(circle_mat)
                    surface.DrawTexturedRect(h*0.125, h*0.15, h*0.7, h*0.7)

                    surface.SetDrawColor(white_col)
                    surface.SetMaterial(PlayingMaterials[same])
                    surface.DrawTexturedRect(h*0.325, h*0.325, h*0.35, h*0.35)
                end

                draw.SimpleTextShadow(vid.author, "urfim.videoplayer.title1", h + 4, h*0.5, white_col, nil, TEXT_ALIGN_BOTTOM, 1, 175)
                draw.SimpleTextShadow(vid.title, "urfim.videoplayer.title2", h + 4, h*0.5, white_col, nil, nil, 1, 175)
            end
            video.DoClick = function(me)
                net.Start("urfim_video")
                    net.WriteBool(true)
                    net.WriteString(me.id)
                net.SendToServer()
            end

        end, function(nextpage, oldPage)

        end, function()
            if not IsValid(me) then return end

            for k, v in pairs(me.videos or {}) do
                if IsValid(v) then
                    v:AlphaTo(0, 0.25, 0, function()
                        if IsValid(v) then v:Remove() end
                    end)
                end
            end

            me.videos = {}
        end)
    end

    menu:DoSearch()
end)
