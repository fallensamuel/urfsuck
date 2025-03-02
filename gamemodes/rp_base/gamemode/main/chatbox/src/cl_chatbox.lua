-- "gamemodes\\rp_base\\gamemode\\main\\chatbox\\src\\cl_chatbox.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local systimer = { List = {} };

systimer.Simple = function( delay, func )
    systimer.List[SysTime() + delay] = func;
end

hook.Add( "PreRender", "systimer", function()
    for t, f in ipairs( systimer.List ) do
        if t <= SysTime() then f(); systimer.List[t] = nil; end
    end
end );

local LostConnection = false;

hook.Add( "OnConnectionLost", "CHATBOX:NoConnection", function()
    LostConnection = true;
end );

hook.Add( "OnConnectionRestored", "CHATBOX:NoConnection", function()
    LostConnection = false;
end );

local chat_no_scroll_while_open = CreateClientConVar("chatbox_no_openscroll", 0, true, false)
local chat_message_hidetime = 15

local matSend  = Material("chatbox/send.png", "noclamp", "smooth")
local matEmotes = Material("chatbox/emotes.png", "noclamp", "smooth")
local matTrigon = Material("chatbox/trigon_tr.png", "noclamp", "smooth")

local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawText = surface.DrawText
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local draw_TextShadow = draw.TextShadow
local draw_Blur = draw.Blur

cvar.Register( "enable_chatbox_ooc" )
    :AddMetadata( "State", "RPMenu" )
    :AddMetadata( "Menu", translates.Get("Включить отображение общего канала чата") )
    :SetDefault( true )
    :AddCallback( function( old, new )
        hook.Run( "ChatboxChangedRenderOOC", tobool(new) );
    end )

hook.Add( "ChatboxChangedRenderOOC", "CHATBOX::ChatboxChangedRenderOOC", function(state)
    if not IsValid(_CHATBOX) then return end

    local his = _CHATBOX.m_History
    local can = his:GetCanvas()

    for k, el in ipairs( can:GetChildren() ) do
        if not el.ooc then continue end

        if state and el.b_Hidden and el.fl_TrueHeight then
            el.SetTall(el, el.fl_TrueHeight)
            el.b_Hidden = nil

            continue
        end

        if not state and not el.b_Hidden then
            el.fl_TrueHeight = el.GetTall(el)
            el.SetTall(el, 0)
            el.b_Hidden = true

            continue
        end
    end
end );

function CHATBOX:OnChatTab(str)
    local ostr = str
    local args = string.Split(ostr, " ")
    local firstarg = args[1]
    if firstarg == "" and self.ChatModeList[self.InputMode].cmd then
        firstarg = self.ChatModeList[self.InputMode].cmd
    end

    str = string.TrimRight(str)

    local LastWord
    for word in string.gmatch( str, "[^ ]+" ) do
        LastWord = word
    end

    if ( LastWord == nil ) then return str end

    for k, v in pairs( player.GetAll() ) do

        local nicknamesas = {
            v:Nick(),
            v:SteamID(),
            v:SteamID64()
        }

        for i = 1, #nicknamesas do
            local nickname = nicknamesas[i]
            if ( utf8.len( LastWord ) < utf8.len( nickname ) && string.find( utf8.lower( nickname ), utf8.lower( LastWord ), 0, true ) == 1 ) then

                str = utf8.sub( str, 1, ( utf8.len( LastWord ) * -1 ) - 1 )

                local pref = {
                    utf8.sub(ostr, 1, 1),
                    self.ChatModeList[self.InputMode].cmd and self.ChatModeList[self.InputMode].cmd.sub(self.ChatModeList[self.InputMode].cmd, 1, 1)
                }

                local stop
                for i2 = 1, #pref do
                    if not stop then
                        local pref = pref[i2]
                        if (pref == '/' or pref == '!') and (firstarg != '//' and firstarg != '/ooc' and firstarg != '/ad' and firstarg != '/advert') then
                            str = str .. v:SteamID()
                            stop = true
                        else
                            str = str .. nickname
                            stop = true
                        end
                    end
                end
                return str

            end
        end

    end

    for idss, tab in pairs(self.Emoticons) do
        local id = ":"..idss..":"
        if (string.find(utf8.lower(id), utf8.lower(str), 1, true) or -1) == 1 then
            str = utf8.sub( str, 1, ( utf8.len( LastWord ) * -1 ) - 1 )
            str = str .. utf8.sub(id, utf8.len(str)+1)
            return str
        end
    end

    return str
end

function CHATBOX:NextPreviewEmote()
    if not self.ActivePreviewEmoteK then
        self:GetPreviewEmote()
    end

    local new = self.ActivePreviewEmoteK + 1
    if new > #self.PreviewEmotes or new < 1 then
        new = 1
    end

    if self.PreviewEmotes[new] then
        self.ActivePreviewEmote = self.PreviewEmotes[new]
        self.ActivePreviewEmoteK = new
    end
end

function CHATBOX:GetPreviewEmote()
    if self.ActivePreviewEmote then
        return self.ActivePreviewEmote
    else
        local v, k = table.Random(self.PreviewEmotes)
        self.ActivePreviewEmote = v
        self.ActivePreviewEmoteK = k
    end
end

CHATBOX.ChatboxOpen = false
CHATBOX.History = {}

CHATBOX.ChatboxFont = "CHATBOX_18"
CHATBOX.TimestampFont = "CHATBOX_16"

local function IsPlayer(e)
    return type(e) == "Player" and IsValid(e)
end

local function RemoveIfValid(e)
    if (IsValid(e)) then
        e:Remove()
    end
end

local function FindPlayer(cont)
    for _, v in pairs (cont) do
        if (IsPlayer(v)) then
            return v
        end
    end

    return NULL
end

local nopaint = function() end

CHATBOX.FontsToBold = {}

function CHATBOX:CreateChatboxFonts()
    local fntname = self.FontName
    local fntnamebold = self.FontNameBold
    local weight = 500
    local boldweight = 1000
    local sizes = {8, 10, 12, 14, 16, 18, 20, 24}

    for _, v in ipairs (sizes) do
        local n = "CHATBOX_" .. v

        surface.CreateFont(n, {font = fntname, size = v*self.FontScale, weight = weight, extended = true, antialias = true})
        surface.CreateFont(n .. "_B", {font = fntnamebold, size = v*self.FontScale, weight = boldweight, extended = true, antialias = true})

        self.FontsToBold[n] = n .. "_B"
    end
end

CHATBOX.ChatModeParsers = {}

function CHATBOX:ModeDown()
    local new = self.InputMode + 1

    if new > #self.ChatModeList then
        new = 1
    end

    self.InputMode = new
    cookie.Set("chatbox_mode", self.InputMode)

    local ishidden = isfunction(self.ChatModeList[new].hidden) and self.ChatModeList[new].hidden() or self.ChatModeList[new].hidden
    if ishidden then
        self:ModeDown()
    end
end

function CHATBOX:ModeUp()
    local new = self.InputMode - 1
    for i = 1, #self.ChatModeList do
        if self.ChatModeList[new] then
            local ishidden = isfunction(self.ChatModeList[new].hidden) and self.ChatModeList[new].hidden() or self.ChatModeList[new].hidden
            if ishidden then
                new = new - 1
                continue
            end

            self:SetMode(new)
            break
        else
            new = new - 1
            if new < 1 then
                new = #self.ChatModeList
            end
        end
    end
end

function CHATBOX:SetMode(n)
    self.InputMode = math.Clamp(n, 1, #self.ChatModeList)
    cookie.Set("chatbox_mode", self.InputMode)
end

function CHATBOX:CreateChatbox()
    RemoveIfValid(_CHATBOX)
    RemoveIfValid(_CHATBOX_EMOTICONS)

    self.LastKeyEntry = 0
    self.InputMode = cookie.GetNumber("chatbox_mode", 1)

    local W, H = ScrW(), ScrH()
    local scale = math.Clamp(H / 1080, 0.7, 1)
    _CHATBOX_SCALE = scale

    local dw = 546
    local dh = 248
    local wi = math.max(dw, cookie.GetNumber("urfchatbox_w", self.Size.w) * scale)
    local he = math.max(dh, cookie.GetNumber("urfchatbox_h", self.Size.h) * scale)

    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetSizable(true)
    frame:SetDraggable(true)
    frame:SetScreenLock(true)
    frame:SetSize(wi, he)
    frame:SetMinWidth(math.max(self.Size.w*scale, dw))
    frame:SetMinHeight(math.max(self.Size.h*scale, dh))
    frame:SetPos(0, cookie.GetNumber("urfchatbox_y", (self.PosY or self.y) /1080*H)*scale)
    frame.m_fAlpha = 0

    local _SetAlphaAndPain = function(p, a, cback)
        if not IsValid(p) then return end
        p.SetAlpha(p, a)
        p.PaintManual(p)

        if cback then
            cback(p)
        end
    end
    frame.Paint = function(me, w, h)
        if gui.IsGameUIVisible() then return end

        if self.ChatboxOpen then --or me.m_fAlpha > 0 then
            local cb = self.Color("bg")
            local a = me.m_fAlpha or 255
            local af = me.m_fAlphaFrac or 1

            self.Blur(me)
            draw.RoundedBox(0, 0, 0, w, h, Color(cb.r, cb.g, cb.b, cb.a * af))

            _SetAlphaAndPain(me.m_Switcher, a, function(p)
                p.NowPaintManualy = CurTime()
            end)
            _SetAlphaAndPain(me.m_Entry, a)
            _SetAlphaAndPain(me.m_Send, a)
        end

        me.m_History.PaintManual(me.m_History)
    end
    frame.OldOnMousePressed = frame.OnMousePressed
    frame.OnMousePressed = function(self1, code)
        if code == MOUSE_RIGHT then
            local menu = self.Menu()

            menu:AddOption(translates.Get("Очистить историю"), function()
                frame.m_History:Clear()
            end)

            menu:AddOption(translates.Get("Сбросить позицию"), function()
                local y = self.PosY / 1080 * H * scale
                cookie.Set("urfchatbox_y", y)
                frame.Y = y
            end)

            menu:AddOption(translates.Get("Сбросить размер"), function()
                cookie.Set("urfchatbox_w", dw)
                cookie.Set("urfchatbox_h", dh)

                frame:SetSize(dw, dh)
            end)

            return menu:Open()
        else
            self1:OldOnMousePressed()
        end
    end
    frame.OnMouseReleased = function(self2)
        self2.Dragging   = nil
        self2.Sizing     = nil
        self2:MouseCapture(false)

        local x, y = self2:GetPos()
        cookie.Set("urfchatbox_y", y)
    end
    frame.Think = function(self3)
        local mousex = math.Clamp(gui.MouseX(), 1, ScrW() - 1)
        local mousey = math.Clamp(gui.MouseY(), 1, ScrH() - 1)

        if (self3.Dragging) then
            local x = self3:GetPos()
            local y = mousey - self3.Dragging[2]

            if (self3:GetScreenLock()) then
                y = math.Clamp(y, 0, ScrH() - self3:GetTall())
            end

            self3:SetPos(x, y)
        end

        if (self3.Sizing) then
            local x = mousex - self3.Sizing[1]
            local y = mousey - self3.Sizing[2]
            local px, py = self3:GetPos()

            if (x < self3.m_iMinWidth) then
                x = self3.m_iMinWidth
            elseif (x > ScrW() - px and self3:GetScreenLock()) then
                x = ScrW() - px
            end

            if (y < self3.m_iMinHeight) then
                y = self3.m_iMinHeight
            elseif (y > ScrH() - py and self3:GetScreenLock()) then
                y = ScrH() - py
            end

            self3:SetSize(x, y)
            self3:SetCursor("sizenwse")

            return
        end

        local screenX, screenY = self3:LocalToScreen(0, 0)

        if (self3.Hovered and self3.m_bSizable and mousex > (screenX + self3:GetWide() - 20) and mousey > (screenY + self3:GetTall() - 20)) then
            self3:SetCursor("sizenwse")

            return
        end

        if (self3.Hovered and self3:GetDraggable() and mousey < (screenY + 24)) then
            self3:SetCursor("sizeall")

            return
        end

        self3:SetCursor("arrow")

        if (self3.y < 0) then
            self3:SetPos(self3.x, 0)
        end
    end
    _CHATBOX = frame
    self.frame = frame


        local history = vgui.Create("rpui.ScrollPanel", frame)
        history:SetSpacingY(0)
        history:SetScrollbarMargin(0)
        history:SetPaintedManually(true)
        local his_w = 0.9725 * frame:GetWide()
        local his_h = 0.72984 * frame:GetTall()
        history:SetSize(his_w, his_h)
        local his_x = frame:GetWide() - history:GetWide()
        local his_y = 0.0605 * frame:GetTall()
        history:SetPos(his_x, his_y)

        history.OldPerformLayout = history.PerformLayout
        history.PerformLayout = function(me1)
            me1:Rebuild()
            me1:OldPerformLayout()
        end

        history.Rebuild = function(me2)
            local cv = me2:GetCanvas()
            local chi = cv:GetChildren()
            local h = 4

            for _, v in ipairs (chi) do
                h = h + v:GetTall()
            end

            cv:SetTall(h + (#chi > 0 and 4 or 0))
        end
        history.ScrollToBottom = function(me3, max, instantly)
            local curOffset = me3.yOffset
            local maxOffset = max or me3:GetCanvas():GetTall()

			if instantly then
				me3:SetOffset(curOffset + maxOffset)
				return
			end

            me3:Stop()
            me3:NewAnimation(self.Anims.ScroolDown).Think = function(anim, me3, frac)
                me3:SetOffset(curOffset + (maxOffset * frac))
            end
        end
        history.OldThink = history.Think
        history.Think = function(me4)
            local sc = me4.yOffset
            frame.m_iScrollMin = sc
            frame.m_iScrollMax = sc + frame:GetTall()

            me4.VBar.SetAlpha(me4.VBar, frame.m_fAlpha or 255)

            me4:OldThink()
        end
        history.OnMouseWheeled = function(me5, dt)
            me5.ySpeed = me5.ySpeed + dt*self.scrollSpeeedMult
        end

        history.Clear = function(me4)
            for k, pnl in pairs(me4:GetCanvas():GetChildren()) do
                pnl:Remove()
            end
        end

        frame.m_History = history

            history:InvalidateParent(true)

        local bottom_h = 42*scale
        local bottom = vgui.Create("Panel", frame)
        bottom:SetSize(frame:GetWide(), bottom_h)
        bottom:SetPos(0, his_y + his_h + 10*scale)
        frame.m_Bottom = bottom

            local cs_wide = 60*scale

            for k, v in pairs(self.ChatModeList) do
                if isfunction(v.hidden) and v.hidden() or v.hidden then continue end
                local txt = v.cmd or (isfunction(v.name) and v.name() or v.name)
                if not txt then continue end

                surface.SetFont("CHATBOX_16")
                local this_w = surface.GetTextSize(txt)

                cs_wide = math.max(cs_wide, this_w)
            end

            cs_wide = cs_wide + 4*scale

            local chat_switcher = vgui.Create("DButton", bottom)
            chat_switcher:SetText("")
            chat_switcher:SetSize(cs_wide, bottom_h - 10*scale)
            chat_switcher:SetPos(15*scale, 0)
            chat_switcher.Paint = function(me6, w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.Color(me6:IsHovered() and "inbghover" or "inbg"))

                local mode = self.ChatModeList[self.InputMode] or {txt = "n/a", col = color_white}
                draw.SimpleTextShadow(mode.cmd or mode.name, "CHATBOX_16", w*0.5, h*0.5, mode.col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, 175)

                if IsValid(me6.ModeSelector) and me6.ModeSelector.opened then
                    me6.ModeSelector.SetAlpha(me6.ModeSelector, me6:GetAlpha())
                end
            end
            chat_switcher.NowPaintManualy = 0
            chat_switcher.Think = function(me)
                if IsValid(me.ModeSelector) and me.NowPaintManualy + 0.1 < CurTime() then
                    me.ModeSelector.Remove(me.ModeSelector)
                end

                local CT = CurTime()
                if me:IsHovered() then
                    if not me.MouseEnterTime then me.MouseEnterTime = CT end
                else
                    me.MouseEnterTime = nil
                    if IsValid(me.InfoTip) then
                        me.InfoTip.Close(me.InfoTip)
                    end
                end

                if me.MouseEnterTime and me.MouseEnterTime + 2 < CT and not IsValid(me.InfoTip) then
                    me.InfoTip = vgui.Create("DButton")
                    me.InfoTip.PseudoParent = me

                    local x, y = frame:GetPos()
                    me.InfoTip.SetPos(me.InfoTip, x, y + frame:GetTall())
                    me.InfoTip.Think = function(me)
                        if IsValid(me.PseudoParent) then
                            if me.AutoAlpha then me:SetAlpha(me.PseudoParent.GetAlpha(me.PseudoParent)) end
                        else
                            me:Remove()
                        end
                    end
                    me.InfoTip.Close = function(me)
                        if me.Closed then return end
                        me.Closed = true
                        me.AutoAlpha = nil
                        me:AlphaTo(0, self.Anims.FadeOutTime, 0, function()
                            if IsValid(me) then me:Remove() end
                        end)
                    end
                    me.InfoTip.SetAlpha(me.InfoTip, 0)
                    me.InfoTip.AlphaTo(me.InfoTip, 255, self.Anims.FadeInTime, 0, function()
                        if IsValid(me.InfoTip) then
                            me.InfoTip.AutoAlpha = true
                        end
                    end)

                    me.InfoTip.SetText(me.InfoTip, translates.Get("Попробуй по-нажимать на стрелочки с альтом и без. Я тебе сказал по секрету :)"))
                    me.InfoTip.SetFont(me.InfoTip, "CHATBOX_12")
                    me.InfoTip.SizeToContents(me.InfoTip)
                    me.InfoTip.SetTextColor(me.InfoTip, self.Color("text"))

                    me.InfoTip.Paint = function(me, w, h)
                        self.Blur(me)
                        surface.SetDrawColor(self.Color("bg"))
                        surface.DrawRect(0, 0, w, h)
                    end
                end
            end
            chat_switcher:SetPaintedManually(true)
            frame.m_Switcher = chat_switcher
            chat_switcher.DoClick = function(me7)
                if IsValid(me7.ModeSelector) then
                    me7.ModeSelector.Close(me7.ModeSelector)
                    return
                end

                me7.ModeSelector = vgui.Create("Panel", frame)
                local link = me7.ModeSelector
                local his_x, his_y = history:GetPos()
                link:SetPos(his_x, his_y + history:GetTall())
                link.Close = function(me8)
                    if me8.Closing then return end
                    me8.Closing = true

                    me8.opened = nil
                    me8:AlphaTo(0, self.Anims.FadeOutTime, 0, function(anim, me9)
                        if IsValid(me9) then
                            me9:Remove()
                        end
                    end)
                end
                link.btns = {}
                link.ChangeSize = function(me10)
                    local new_w, new_h = 0, 0
                    for k, btn in pairs(me10.btns) do
                        if IsValid(btn) then
                            new_w = math.max(new_w, btn:GetWide())
                            new_h = new_h + btn:GetTall()
                        end
                    end

                    me10:SetSize(new_w, new_h)
                    local cur_x, cur_y = me10:GetPos()
                    me10:SetPos(cur_x, cur_y - me10:GetTall())
                end
                link.Paint = function(me11, w, h)
                    self.Blur(me11)
                    draw.RoundedBox(0, 0, 0, w, h, self.Color("bg"))
                end

                link:SetAlpha(0)
                link:AlphaTo(255, self.Anims.FadeInTime, 0, function()
                    if IsValid(link) then link.opened = true end
                end)

                link.list = vgui.Create("DIconLayout", link)
                link.list.Dock(link.list, FILL)
                link.list.SetSpaceY(link.list, 0)
                link.list.SetSpaceX(link.list, 0)

                local whiteCol = Color(255, 255, 255)
                local hoverCol = Color(0, 0, 0, 125)
                local max_wide = 0
                for k = 1, #self.ChatModeList do
                    local mode = self.ChatModeList[k]
                    local ishidden = isfunction(mode.hidden) and mode.hidden() or mode.hidden
                    if ishidden then continue end

                    local btn = link.list.Add(link.list, "DButton")
                    btn.txt = isfunction(mode.name) and mode.name() or mode.name
                    btn:SetText(btn.txt)
                    btn:SetFont("CHATBOX_12")

                    local oldTall = btn:GetTall()
                    btn:SizeToContents()
                    btn:SetTall(oldTall)
                    btn:SetWide(btn:GetWide() + 8)
                    max_wide = math.max(max_wide, btn:GetWide())

                    btn:SetText("")
                    btn.Paint = function(me12, w, h)
                        local hov = me12:IsHovered()
                        if hov then
                            surface.SetDrawColor(hoverCol)
                            surface.DrawRect(0, 0, w, h)
                        end
                        draw.SimpleText(me12.txt, me12:GetFont(), 6, h*0.5, whiteCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    btn.DoClick = function()
                        self:SetMode(k)
                        link:Close()
                    end

                    link.btns[k] = btn
                end

                for k, btn in pairs(link.btns) do
                    btn:SetWide(max_wide)
                end

                link:ChangeSize()
            end

            local entry = vgui.Create("DTextEntry", bottom)
            entry:SetFont(self.ChatboxFont)
            entry:SetTextColor(self.Color("text"))
            entry:SetHighlightColor(self.Color("header"))
            entry:SetDrawLanguageID(false)
            entry:SetPaintedManually(true)
            entry:SetUpdateOnType(true)
            entry:SetSize(bottom:GetWide()*0.8132 - chat_switcher:GetWide(), chat_switcher:GetTall())
            entry:SetPos(15*scale + chat_switcher:GetWide(), 0)
            entry.OldOnKeyCodeTyped = entry.OnKeyCodeTyped
            entry.Paint = function(me, w, h)
                draw.RoundedBox(0, 0, 0, w, h, self.Color("inbg"))


                if utf8.len( me:GetText() ) < 1 then
                    local mode = self.ChatModeList[self.InputMode]
                    if mode then
                        me:SetPlaceholderText(isfunction(mode.howto) and mode.howto() or mode.howto or "")
                    end
                else

                end

                if ( me.GetPlaceholderText and me.GetPlaceholderColor and me:GetPlaceholderText() and me:GetPlaceholderText():Trim() ~= "" and me:GetPlaceholderColor() and (not me:GetText() or me:GetText() == "") ) then
                    local oldText = me:GetText()

                    local str = me:GetPlaceholderText()
                    if str:StartWith("#") then str = str:sub(2) end
                    str = language.GetPhrase(str)

                    me:SetText(str)
                    me:DrawTextEntryText(me:GetPlaceholderColor(), me:GetHighlightColor(), me:GetCursorColor())
                    me:SetText(oldText)

                    return
                end


                me:DrawTextEntryText(me:GetTextColor(), me:GetHighlightColor(), me:GetTextColor())

                if (vgui.GetKeyboardFocus() == frame) then
                    me:RequestFocus()
                end
            end

            entry.KeyHandlers = {
                [KEY_ESCAPE] = function(me13, kc)
                    self:CloseChatbox()
                    if gui.IsGameUIVisible() then
                        gui.HideGameUI()
                    end
                end,
                [KEY_TAB] = function(me14, kc)
                    local str = self:DoAutoFill()
                    me14.AutoFillText = nil
                    if str then
                        me14:SetText(str)
                        me14.AutoFillText = nil
                    end
                end,
                [KEY_UP] = function(me15, kc)
                    if input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
                        self:ModeUp()
                        return
                    end

                    if (#self.History > 0) then
                        if (!me15.m_iCurPos) then
                            me15.m_iCurPos = #self.History
                            me15:SetText(self.History[me15.m_iCurPos].txt)
                            me15:SetCaretPos(utf8.len(me15:GetText()))
                            self:SetMode(self.History[me15.m_iCurPos].mode)
                        elseif (me15.m_iCurPos > 1) then
                            me15.m_iCurPos = me15.m_iCurPos - 1
                            me15:SetText(self.History[me15.m_iCurPos].txt)
                            me15:SetCaretPos(utf8.len(me15:GetText()))
                            self:SetMode(self.History[me15.m_iCurPos].mode)
                        end
                    end
                end,
                [KEY_DOWN] = function(me16, kc)
                    if input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
                        self:ModeDown()
                        return
                    end

                    if (me16.m_iCurPos and me16.m_iCurPos < #self.History) then
                        me16.m_iCurPos = me16.m_iCurPos + 1
                        me16:SetText(self.History[me16.m_iCurPos].txt)
                        me16:SetCaretPos(utf8.len(me16:GetText()))
                        self:SetMode(self.History[me16.m_iCurPos].mode)
                    end
                end,
                [KEY_LEFT] = function(me17, kc)
                    if IsValid(chat_switcher) and (input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT)) then
                        chat_switcher:DoClick()
                    end
                end,
                [KEY_RIGHT] = function(me18, kc)
                    if input.IsKeyDown(KEY_LALT) or input.IsKeyDown(KEY_RALT) then
                        self:ShowEmoteList()
                        return
                    end

                    local str = self:DoAutoFill()
                    me18.AutoFillText = nil
                    --if str then
                        --me18:SetText(str)
                        --me18.AutoFillText = nil
                        me18:SetCaretPos(utf8.len(me18:GetText()))
                        return true
                    --end
                end,
            }

            entry.OnKeyCodeTyped = function(me19, kc)
                self.LastKeyEntry = CurTime()

                local v = me19:GetText()
                if self.ChatModeCmd2Index[v] then
                    self:SetMode(self.ChatModeCmd2Index[v])
                    me19:SetText("")
                    me19:SetCaretPos(0)
                    return
                end

                local handle = me19.KeyHandlers[kc]
                if handle then
                    if handle(me19, kc) then return true end
                end

                me19:OldOnKeyCodeTyped(kc)
            end
            entry.AllowInput = function(me20, str)
                local text = me20:GetText();
                local len = utf8.len( text .. str );

                if len > CHAT_MAX_CHARACTERS then
                    surface.PlaySound( "ui/beep-6.wav" );
                    return true
                end

                if me20:CheckNumeric( str ) then
                    return false
                end
            end
            entry.OnTextChanged = function(me47)
                local str2 = me47:GetText()
                if self.ChatModeCmd2Index[str2] then
                    self:SetMode(self.ChatModeCmd2Index[str2])
                    me47:SetText("")
                    me47:SetCaretPos(0)
                    return
                end

                local auto = self:DoAutoFill(true)

                me47.AutoFillText = auto or nil
            end
            entry.PaintOver = function(s, w, h)
                if (!s.AutoFillText) then return end
                local rh = h

                surface_SetFont(self.ChatboxFont)

                local x = surface_GetTextSize(s:GetValue())
                local w, h2 = surface_GetTextSize(s.AutoFillText)

                local y = 0.5 * h - 0.5 * h2
                surface_SetDrawColor(s:GetHighlightColor())
                surface_DrawRect(x+3, y, w, h2)
                surface_SetTextColor(ui.col.White)
                surface_SetTextPos(x+3, y)
                surface_DrawText(s.AutoFillText)
            end
            entry.OnValueChange = function(me21, val)
                hook.Call("ChatTextChanged", GAMEMODE, val)
            end
            entry.OnEnter = function(me22)
                local val = me22:GetValue()
                if (val:Trim() ~= "") then
                    val = utf8.sub(val, 1, CHAT_MAX_CHARACTERS)

                    local mode = self.ChatModeList[self.InputMode]
                    local cmd = mode.cmd or ""

                    if val:StartWith("/") or val:StartWith("!") then
                        cmd = nil
                    end

                    local new = ""
                    for char in string.gmatch(val, "([%z\1-\127\194-\244][\128-\191]*)") do
                        if self.AllowedChars[char] then
                            new = new .. char
                        end
                    end
                    val = new

                    if #val < 1 then return end

                    if not LostConnection then
                        if (val:find('"')) then
                            LocalPlayer():ConCommand("chatbox_say\"" .. (cmd and (" " .. cmd) or "") .. " " .. val .. "\"")
                        else
                            RunConsoleCommand("chatbox_say", cmd and (cmd.." "..val) or val)
                        end
                    end

                    hook.Run( "ChatTextSend", val );

                    table.insert(self.History, {
                        txt = val,
                        mode = self.InputMode
                    })
                end

                self:CloseChatbox()
            end
            frame.m_Entry = entry


            local whiteCol = Color(255, 255, 255)
            local hoverCol = Color(200, 200, 200)

            local emoticons = CHATBOX.Button("", bottom, function()
                entry:OnEnter()
            end)
            emoticons:SetPaintedManually(true)
            local size = 28*scale
            local offset = 0.5 * (entry:GetTall() - 28*scale)
            emoticons:SetSize(size, size)
            local pos_x, pos_y = entry:GetPos()
            emoticons:SetPos(pos_x + entry:GetWide() + 14*scale, pos_y + offset)
            emoticons.scale = 0.75 * 1
            emoticons.Paint = function(me23, w, h)
                local mat = self:GetPreviewEmote()
                if not mat then return end

                me23.scale = Lerp(FrameTime()*12, me23.scale, me23:IsHovered() and 0.9 * 1 or 0.8)
                local w_, h_ = w*me23.scale, h*me23.scale
                local x = 0.5 * (w - w_)
                local y = 0.5 * (h - h_)

                surface.SetDrawColor(whiteCol)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(x, y, w_, h_)
            end
            emoticons.OnCursorEntered = function()
                self:NextPreviewEmote()
            end
            emoticons.DoClick = function()
                self:ShowEmoteList()
            end
            frame.m_Emoticons = emoticons

            local send = CHATBOX.Button("", bottom, function()
                entry:OnEnter()
            end)
            send:SetSize(size, size)
            pos_x = emoticons:GetPos()
            send:SetPos(pos_x + 8*scale + size, pos_y + offset)
            send:SetPaintedManually(true)
            send.Paint = function(me24, w, h)
                surface.SetDrawColor(me24:IsHovered() and hoverCol or whiteCol)
                surface.SetMaterial(matSend)
                surface.DrawTexturedRect(h * 0.1, h * 0.1, w*0.8, h*0.8)
                frame.m_Emoticons.PaintManual(frame.m_Emoticons)
            end
            frame.m_Send = send

    self.frame.PerformLayout = function(me, w, h)
        cookie.Set("urfchatbox_w", w)
        cookie.Set("urfchatbox_h", h)

        local scale_tp = math.Clamp(ScrH() / 1080, 0.7, 1)

        local his_w = frame:GetWide() - 15*scale_tp
        local his_h = frame:GetTall() - 25*scale_tp - 42*scale_tp
        me.m_History.SetSize(me.m_History, his_w, his_h)
        local his_x = frame:GetWide() - me.m_History.GetWide(me.m_History)
        local his_y = 15*scale_tp
        me.m_History.SetPos(me.m_History, his_x, his_y)

        local bottom_h = 42*scale_tp
        me.m_Bottom.SetSize(me.m_Bottom, frame:GetWide(), bottom_h)
        me.m_Bottom.SetPos(me.m_Bottom, 0, h - bottom_h - 4*scale_tp)

        me.m_Switcher.SetSize(me.m_Switcher, cs_wide, bottom_h - 10*scale_tp)
        me.m_Switcher.SetPos(me.m_Switcher, 15*scale_tp, 0)

        local entry_wide = me.m_Bottom.GetWide(me.m_Bottom)*0.8132 - me.m_Switcher.GetWide(me.m_Switcher)
        me.m_Entry.SetSize(me.m_Entry, entry_wide, me.m_Switcher.GetTall(me.m_Switcher))
        me.m_Entry.SetPos(me.m_Entry, 15*scale_tp + me.m_Switcher.GetWide(me.m_Switcher), 0)

        local size = 28*scale_tp
        local offset = 0.5 * (me.m_Entry.GetTall(me.m_Entry) - 28*scale_tp)
        me.m_Emoticons.SetSize(me.m_Emoticons, size, size)
        local pos_x, pos_y = me.m_Entry.GetPos(me.m_Entry)


        me.m_Send.SetSize(me.m_Send, size, size)
        pos_x = me:GetWide() - 13*scale_tp - size
        me.m_Send.SetPos(me.m_Send, pos_x, pos_y + offset)

        me.m_Emoticons.SetPos(me.m_Emoticons, pos_x - 10*scale_tp - size, pos_y + offset)

        local addval = pos_x - ( 15*scale_tp + me.m_Switcher.GetWide(me.m_Switcher) ) - (me.m_Bottom.GetWide(me.m_Bottom)*0.8132 - me.m_Switcher.GetWide(me.m_Switcher)) - 53
        me.m_Entry.SetWide(me.m_Entry, entry_wide + addval)

        me.resize1.SetPos(me.resize1, me:GetWide() - me.resize1.GetWide(me.resize1), me:GetTall() - me.resize1.GetTall(me.resize1))

        me.m_History.PerformLayout(me.m_History)
        if me.m_History.VBar.IsVisible(me.m_History.VBar) then
            me.m_History.VBar.PerformLayout(me.m_History.VBar)
        end
    end

    frame.resize1 = vgui.Create("DButton", frame)
    frame.resize1.SetSize(frame.resize1, 10*scale, 10*scale)
    frame.resize1.SetPos(frame.resize1, frame:GetWide() - frame.resize1.GetWide(frame.resize1), frame:GetTall() - frame.resize1.GetTall(frame.resize1))
    frame.resize1.SetText(frame.resize1, "")
    frame.resize1.SetCursor(frame.resize1, "sizenwse")
    frame.resize1.Paint = function() end
    frame.resize1.OnMousePressed = function(selfa, code)
        selfa:GetParent():OnMousePressed(code)
    end
    frame.resize1.OnMouseReleased = function(selfb)
        selfb:GetParent():OnMouseReleased()
    end
    frame.resize1.SetZPos(frame.resize1, 99)

    timer.Create("chatbox.loademotes", 0, 2, function()
        self:ShowEmoteList()
    end)
end

function CHATBOX:DoAutoFill(ret)
    local match

    local words = string.Explode(' ', self.frame.m_Entry.GetValue(self.frame.m_Entry));
    match = words[#words];

    if (!match or match == '' or utf8.len(match) > 40) then return end

    local pl;
    local stype;
    for k, vply in ipairs(player.GetAll()) do
        local nickname = {
            vply:Nick(),
            vply:SteamID(),
            vply:SteamID64()
        }

        for itr = 1, #nickname do
            local nicknamest = utf8.lower(nickname[itr])

            if ((string.find(nicknamest, utf8.lower(match), 1, true) or -1) == 1) then
                pl = vply;
                stype = nickname[itr]--itr
                break;
            end
        end
    end

    if pl then
        local pref = utf8.sub(self.frame.m_Entry.GetValue(self.frame.m_Entry), 1, 1)
        local add

        local firstarg = utf8.sub(self.frame.m_Entry.GetValue(self.frame.m_Entry), 1, (string.find(self.frame.m_Entry.GetValue(self.frame.m_Entry), ' ')  or (#self.frame.m_Entry.GetValue(self.frame.m_Entry) + 1)) - 1)

        add = stype

        if (!ret) then
            pref = {
                pref,
                self.ChatModeList[self.InputMode].cmd and self.ChatModeList[self.InputMode].cmd.sub(self.ChatModeList[self.InputMode].cmd, 1, 1)
            }

            if not pl:IsBot() then
                for i2 = 1, #pref do
                    local pref = pref[i2]
                    if (pref == '/' or pref == '!') and (firstarg != '//' and firstarg != '/ooc' and firstarg != '/ad' and firstarg != '/advert') then
                        add = pl:SteamID()
                        break
                    end
                end
            end

            self.frame.m_Entry.SetText(self.frame.m_Entry, utf8.sub(self.frame.m_Entry.GetValue(self.frame.m_Entry), 1, -(utf8.len(match) + 1)) .. add .. ' ')
        else
            return utf8.sub(add, utf8.len(match)+1)
        end

        return
    else
        for idst, tab in pairs(self.Emoticons) do
            local id = ":"..idst..":"
            if (string.find(utf8.lower(id), utf8.lower(match), 1, true) or -1) == 1 then
                if not ret then
                    self.frame.m_Entry.SetText(self.frame.m_Entry, utf8.sub(self.frame.m_Entry.GetValue(self.frame.m_Entry), 1, -(utf8.len(match) + 1)) .. id .. ' ')
                    return
                else
                    return utf8.sub(id, utf8.len(match)+1)
                end
            end
        end
    end
end


local function urlpaint(me25, w25, h25)
    if (me25.m_Image) then
        surface.SetDrawColor(color_white)
        surface.SetMaterial(me25.m_Image)
        surface.DrawTexturedRect(0, 0, w25, h25)
    end
end

local CreateTrigon = function(self11, pnl)
    pnl.trigon = pnl.trigon or vgui.Create("Panel", _CHATBOX)
    pnl.trigon.pseudoparent = pnl
    pnl.trigon.SetSize(pnl.trigon, 22, 22)
    pnl.trigon.SetPos(pnl.trigon, -pnl.trigon.GetWide(pnl.trigon), 0)
    pnl.trigon.Paint = function(me26, w26, h26)
        if not IsValid(me26.pseudoparent) then
            me26:Remove()
            return
        end
        surface.SetDrawColor(self11.Color("bg"))
        surface.SetMaterial(matTrigon)
        surface.DrawTexturedRect(0, 0, w26, h26)
    end
end

function CHATBOX:ShowEmoteList()
    local frame = _CHATBOX
    local lx, ly = frame.m_Emoticons.LocalToScreen(frame.m_Emoticons, 0, 0)
    local x_stl, y_stl = frame:ScreenToLocal(lx, ly)

    local old = _CHATBOX_EMOTICONS
    if IsValid(old) then
        if (old:IsVisible()) then
            old:Close()
        else
            old:RebuildEmoticons()
            old:SetTall(0.65 * frame:GetTall())
            old:InvalidateLayout(true)
            old:SetVisible(true)
            old:SetAlpha(0)
            old:AlphaTo(255, self.Anims.FadeInTime)
            old.m_bClosing = false

            if not IsValid(old.trigon) then
                CreateTrigon(self, old)
            end

            old.trigon.SetVisible(old.trigon, true)
            old.trigon.SetAlpha(old.trigon, 0)
            old.trigon.AlphaTo(old.trigon, 255, self.Anims.FadeInTime)
        end

        return
    end

    local pnl = vgui.Create("DPanel", frame)
    _CHATBOX_EMOTICONS = pnl
    local pnl_w = 0.575 * frame:GetWide()
    local pnl_h = 0.65 * frame:GetTall()
    pnl:SetSize(pnl_w, pnl_h)
    local pnl_x = frame:GetWide() - pnl:GetWide() - 8
    local pnl_y = y_stl - pnl:GetTall() - 8
    pnl:SetPos(pnl_x, pnl_y)
    pnl.Paint = function(me27, w27, h27)
        if frame.m_fAlpha <= 0 then
            me27:Close()
            return
        end
        self.Blur(me27)
        draw.RoundedBox(0, 0, 0, w27, h27, self.Color("bg"))
    end
    pnl.Close = function(me28)
        if (me28.m_bClosing) then return end

        me28.m_bClosing = true
        me28:AlphaTo(0, self.Anims.FadeOutTime, 0, function()
            me28:SetVisible()
            me28.m_bClosing = nil
        end)

        if IsValid(me28.trigon) then
            me28.trigon.AlphaTo(me28.trigon, 0, self.Anims.FadeOutTime, 0, function()
                me28.trigon.SetVisible(me28.trigon)
            end)
        end
    end
    pnl.OnRemove = function(me29)
        if IsValid(me29.trigon) then
            me29.trigon.Remove(me29.trigon)
        end
    end

    pnl:SetAlpha(0)
    pnl:AlphaTo(255, self.Anims.FadeInTime)

    CreateTrigon(self, pnl)

    local scroll = vgui.Create("rpui.ScrollPanel", pnl)
    scroll:Dock(FILL)
    scroll:DockMargin(8, 8, 8, 8)
    scroll:SetSpacingY(0)
    scroll:SetScrollbarMargin(0)
    scroll.OnMouseWheeled = function(me30, dt)
        me30.ySpeed = me30.ySpeed + dt*self.scrollSpeeedMult
    end

    local ilist = vgui.Create("DIconLayout")
    ilist:Dock(FILL)
    scroll:AddItem(ilist)

    pnl.RebuildEmoticons = function(this)
        local count = table.Count( self.Emoticons );
        if (this.i_EmotesCount or 0) == count then return end
        this.i_EmotesCount = count;

        local emotes_tab = {}

        for k, v in pairs(self.Emoticons) do
            emotes_tab[v.h] = emotes_tab[v.h] or {}

            local i = #emotes_tab[v.h] + 1
            emotes_tab[v.h][i] = v
            emotes_tab[v.h][i].id = k
        end

        for k, v in pairs(emotes_tab) do
            table.sort(v, function(v1, v2)
                return v2.id > v1.id
            end)
        end

        ilist:Clear();

        for tall, emotes in pairs(emotes_tab) do
            for k, em in SortedPairs(emotes) do
                local iddd = em.id

                if (em.restrict) then
                    local ok = false

                    local rest = em.restrict
                    if rest then
                        if isfunction(rest) and rest(LocalPlayer()) then
                            ok = true
                        elseif istable(rest) then
                            if rest.usergroups and table.HasValue(rest.usergroups, LocalPlayer():GetUserGroup()) then
                                ok = true
                            elseif rest.steamids and (table.HasValue(rest.steamids, LocalPlayer():SteamID()) or table.HasValue(rest.steamids, LocalPlayer():SteamID64())) then
                                ok = true
                            end
                        end
                    else
                        ok = true
                    end

                    if not ok then continue end
                end

                local img
                if (em.url) then
                    img = vgui.Create("DButton", ilist)
                    img:SetText("")
                    img.Paint = urlpaint

                    local mat = CHATBOX.GetDownloadedImage(em.url)
                    if (mat) then
                        img.m_Image = mat
                    else
                        CHATBOX.DownloadImage(
                            em.url,
                            function(mat)
                                if (IsValid(img)) then
                                    img.m_Image = mat
                                end
                            end
                        )
                    end
                else
                    img = vgui.Create("DImageButton", ilist)
                    img:SetImage(em.path)
                end

                img:SetToolTip(":" .. iddd .. ":")
                img:SetSize(em.w, em.h)
                img.DoClick = function()
                    if (IsValid(frame) and IsValid(frame.m_Entry)) then
                        local tx = frame.m_Entry.GetValue(frame.m_Entry) .. ":" .. iddd .. ":"
                        frame.m_Entry.SetText(frame.m_Entry, tx)
                        frame.m_Entry.SetCaretPos(frame.m_Entry, tx:len())

                        if self.HideEmotesMenuWhenSelect then
                            pnl:Close()
                        end
                    end
                end
                img:DockMargin(4, 4, 4, 4)
            end
        end

        ilist:SizeToChildren( false, true );
        ilist:InvalidateLayout( true );
    end

    pnl:RebuildEmoticons();

    scroll:GetCanvas().PerformLayout = function(me28, w28, h28)
        if h28 < (pnl:GetTall() - 10) then
            local h = h28 + 16;
            pnl:SetTall(h)
        end

        local tri = frame.m_Emoticons;
        local pnl_x_t, pnl_y_t = frame:GetWide() - pnl:GetWide() - 8, y_stl - pnl:GetTall() - 24
        pnl:SetPos(pnl_x_t, pnl_y_t)
        pnl.trigon:SetPos(x_stl + frame.m_Emoticons:GetWide() * 0.5 - tri:GetWide() * 0.775, pnl_y_t + pnl:GetTall())
--        pnl.trigon:SetPos(pnl_x_t - frame.m_Emoticons.GetWide(frame.m_Emoticons)*0.5 + old.trigon.GetWide(old.trigon)*0.25, pnl_y_t + old:GetTall())
    end

    return pnl
end

function CHATBOX:SplitLine(tx, fnt, maxwi, cont, ias)
    if self.SplitLineByChars then
        surface.SetFont(fnt)
        local sw1 = surface.GetTextSize(tx)
        if (sw1 >= maxwi) then
            local s = ""

            if (self.UseUTF8) then
                tx = utf8.force(tx)

                for p, c in utf8.codes(tx) do
                    local n = s .. utf8.char(c)

                    local sw2 = surface.GetTextSize(n)
                    if (sw2 >= maxwi) then
                        s = self.sub(n, 1, -3)
                        table.insert(cont, ias + 1, self.sub(tx, s:len() + 1))

                        cont[ias] = s
                        return s
                    else
                        s = n
                    end
                end
            else
                for j = 1, #tx do
                    local n = s .. tx[j]

                    local sw2 = surface.GetTextSize(n)
                    if (sw2 >= maxwi) then
                        s = string.sub(n, 1, -3)
                        table.insert(cont, ias + 1, tx:sub(s:len() + 1))

                        cont[ias] = s
                        return s
                    else
                        s = n
                    end
                end
            end
        end
    end

    local sw2 = surface.GetTextSize(" ")

    local expl = string.Explode(" ", tx)

    local line_t = {}
    local w_off = 0

    for id_t, wo in pairs (expl) do
        local _w1, _h1 = surface.GetTextSize(wo)
        if w_off + _w1 + sw2 < maxwi then --if (id_t == 1 or w_off + _w1 < maxwi) then
            w_off = w_off + _w1 + sw2
            table.insert(line_t, wo)
        else
            table.insert(cont, ias + 1, table.concat(expl, " ", id_t))
            break
        end
    end

    cont[ias] = table.concat(line_t, " ")
    return cont[ias]
end

local color_perms = {
	color = true
}

function CHATBOX:ParseMarkups(parent, sender, tx, defaultfont, defaultcolor, maxwi, cont, isa, bypass, underline, no_color)
    local parsed = false
    for _, mup in ipairs (self.ChatMarkups) do
		if no_color and color_perms[mup.perm] then
			continue
		end

        local d = {string.find(tx, mup.match)}
        local s = d[1]
        local e = d[2]
        if (s) then
            local okay = true

            if mup.customCheck and IsValid(sender) and not bypass then
                okay = mup.customCheck(sender) or false
            end

            if okay then
                table.remove(d, 1)
                table.remove(d, 1)

                parsed = true
                cont[isa] = ""

                local before = self.sub(tx, 1, s - 1)
                local after = self.sub(tx, e + 1)
                if (before ~= "") then
                    table.insert(cont, isa + 1, before)
                    isa = isa + 1
                end

                local res = mup.func({parent = parent, sender = sender, args = d, text = self.sub(tx, s, e), defaultfont = defaultfont, defaultcolor = defaultcolor, underline = underline, maxwi = maxwi, cont = cont, i = i})
                if res then
                    if (istable(res) and !res.r) then
                        for __, v in pairs (res) do
                            table.insert(cont, isa + 1, v)
                            isa = isa + 1
                        end
                    else
                        table.insert(cont, isa + 1, res)
                        isa = isa + 1
                    end
                end

                if after ~= "" then
                    table.insert(cont, isa + 1, after)
                end
            end

            break
        end
    end

    if parsed then
        return nil
    else
        return tx
    end
end

local messagequeue = {}

local color_black = Color(0, 0, 0, 200)
function CHATBOX:MakeChatLabel(tx, font, color, parent, underline)
    local ele = self.Label(tx, font, color, parent)
    ele:SetWide(ele:GetWide() + 1)

    if (underline) then
        ele.Paint = function(me31, w31, h31)
            self.UnderlinePaint(me31, w31, h31)
        end
    end

    if self.DrawMsgShadows then
        ele:SetExpensiveShadow(1, color_black)
    end

    return ele
end

function CHATBOX.UnderlinePaint(me32, w32, h32)
    surface.SetDrawColor(me32:GetTextColor())
    surface.DrawRect(0, h32 - 2, w32, 1)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(1, h32 - 1, w32 - 2, 1)
end

local color_black, color_white = Color(0, 0, 0), Color(255, 255, 255)
function CHATBOX:ParseLineWrap(contt, maxwi, parent, sender)
    if (maxwi == true) then
        if (IsValid(_CHATBOX)) then
            maxwi = _CHATBOX.m_History.GetWide(_CHATBOX.m_History) - 24
        else
            if (!IsValid(LocalPlayer())) then
                table.insert(messagequeue, {
                    cont = contt,
                    maxwi = maxwi,
                    parent = parent,
                    sender = sender,
                })
                return
            end

            maxwi = 100
        end
    end

    local origtext = ""
    local message_text = ""
    local message_mode

    local line = vgui.Create("Panel", parent)

    line.OnMousePressed = function(mess, mc)
        if mc == MOUSE_RIGHT then
            mess:ShowMenu()
        end
    end
    line.ShowMenu = function(me, add)
        local menu = self.Menu()

        if (utf8.len(message_text) or 0) > 0 then
            menu:AddOption(translates.Get("Скопировать сообщение"), function()
                SetClipboardText(message_text)
            end)
        end

        if IsValid(me.sender) and me.sender.IsPlayer(me.sender) then
            local sender = me.sender

            menu:AddOption(translates.Get("Скопировать Ник"), function()
                SetClipboardText(sender:Nick())
            end)

            menu:AddOption(translates.Get("Скопировать SteamID"), function()
                SetClipboardText(sender:SteamID())
            end)

            if sender ~= LocalPlayer() then
                if not (self.PMChat and message_mode and message_mode.i and message_mode.i == self.PMChat) then
                    menu:AddOption(translates.Get("Написать личное сообщение"), function()
                        local a = translates.Get("Личный")

                        for k, v in pairs(self.ChatModeList) do
                            if ( isfunction(v.name) and v.name() or v.name ) == a then
                                self:SetMode(k)
                                if IsValid(_CHATBOX) and IsValid(_CHATBOX.m_Entry) then
                                    local txt = me.sender.Nick(me.sender).." "
                                    _CHATBOX.m_Entry.SetText(_CHATBOX.m_Entry, txt)
                                    _CHATBOX.m_Entry.SetCaretPos(_CHATBOX.m_Entry, self.UseUTF8 and utf8.len(txt) or txt:len() )
                                end
                                break
                            end
                        end
                    end)
                end
            end
        end

        if self.PMChat and message_mode and message_mode.i and message_mode.i == self.PMChat then
            local sendto = contt[3]

            menu:AddOption(translates.Get("Ответить"), function()
                local a = translates.Get("Личный")

                for k, v in pairs(self.ChatModeList) do
                    if ( isfunction(v.name) and v.name() or v.name ) == a then
                        self:SetMode(k)
                        if IsValid(_CHATBOX) and IsValid(_CHATBOX.m_Entry) then
                            local txt = sendto
                            _CHATBOX.m_Entry.SetText(_CHATBOX.m_Entry, txt)
                            _CHATBOX.m_Entry.SetCaretPos(_CHATBOX.m_Entry, self.UseUTF8 and utf8.len(txt) or txt:len() )
                        end
                        break
                    end
                end
            end)
        end

        if add then
            for _, v in pairs(add) do
                menu:AddOption(translates.Get(v.text), function()
                    v.func()
                end)
            end
        end

        menu:Open()
    end

        local contents = vgui.Create("Panel", line)
        contents:Dock(FILL)
        contents.OnMousePressed = function(me35, mc)
            line:OnMousePressed(mc)
        end
        line.m_Contents = contents

    local bx = 0
    local x = 0
    local y = 0
    local w = 0
    local lh = 0
    local h = 0
    local nl = false
    local inline = {}

    local defaultfont = self.ChatboxFont
    local defaultcolor = self.Color("msg")
    local noparse = false
    local bypassperm = false
    local underline = false
    local url
    local lua
    local luabtns = {}
    local urlbtns = {}

    local function urlpaint(me36, w36, h36)
        local b = false
        for _, v in ipairs (me36.m_Buttons) do
            if (IsValid(v) and v.Hovered) then
                b = true
                break
            end
        end

        me36:SetTextColor(b and self.Color("url_hover") or self.Color("url"))

        CHATBOX.UnderlinePaint(me36, w36, h36)
    end

    local scale = 1080/ScrH()

    local pre

    local firstlabel
    local chat_mode_btn
    local whosendmsg

    local next_skip
    local tries = 0

    local r_ooc, cv_ooc = true, cvar.Get("enable_chatbox_ooc")
    if cv_ooc then
        r_ooc = tobool(cv_ooc:GetValue());
    end

    for ivv, el in pairs(contt) do
        tries = tries + 1
        if (tries > 512) then
            line:Remove()
            --error("overflow!! (this shouldn't happen, report this to the author with the message)")
            return
        end

        local ele, forcebreak

        if (isstring(el) or isnumber(el)) then
            if (el == "") then continue end

            if next_skip then
                next_skip = nil
                continue
            end

            local is_nickname = false

			if IsValid(sender) and (sender:Nick() == el or (':' .. (sender:GetNickEmoji() or '') .. ': ' .. sender:Nick()) == el) then
				is_nickname = true
			else
				for k, ply in pairs(player.GetHumans()) do
					if (ply:Nick() == el) or ((':' .. (ply:GetNickEmoji() or '') .. ': ' .. ply:Nick()) == el) then
						is_nickname = true
						whosendmsg = ply
						break
					end
				end
			end

            if tries == 2 then
                local cur_mode
                if is_nickname then
                    cur_mode = 1
                else
					local el_len = utf8.len(el)

					if not isbool(el_len) then
						local pat = utf8.sub(el, 1, el_len - 1)

						if self.ChatModeParsers[pat or 0] then
							cur_mode = self.ChatModeParsers[pat]
						end
                    end
                end

                if cur_mode then
                    local mode = self.ChatModeList[cur_mode]
                    if not mode then continue end

                    message_mode = {m = mode, ivv = cur_mode}

                    local chat_txt = isfunction(mode.name) and mode.name(el, ivv, contt) or mode.name
                    if not chat_txt then continue end

                    if mode.skipnext then
                        next_skip = isfunction(mode.skipnext) and mode.skipnext(el, ivv, contt) or mode.skipnext
                    end

                    local chat_mode = vgui.Create("DButton")
                    chat_mode.txt = chat_txt
                    chat_mode:SetText(chat_mode.txt)
                    chat_mode:SetFont("CHATBOX_14_B")
                    chat_mode:SizeToContents()
                    chat_mode:SetWide(chat_mode:GetWide() + 4)
                    chat_mode:SetParent(contents)
                    chat_mode.bg_col = mode.col

                    local dontclick = isfunction(self.ChatModeList[cur_mode].dontclick) and self.ChatModeList[cur_mode].dontclick() or self.ChatModeList[cur_mode].dontclick
                    if dontclick then
                        chat_mode:SetCursor("arrow")
                    end

                    chat_mode:SetText("")
                    chat_mode.Paint = function(me38, w38, h38)
                        draw.RoundedBox(8, 0, 0, w38, h38, me38.bg_col)
                        draw.SimpleTextShadow(me38.txt, me38:GetFont(), w38*0.5, h38*0.5, self.Color("mode_name"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, 175, true)
                    end

                    if mode.cmd and mode.cmd == "/ooc" then
                        line.ooc = true;
                    end

                    chat_mode.DoClick = function()
                        local dontclick = isfunction(self.ChatModeList[cur_mode].dontclick) and self.ChatModeList[cur_mode].dontclick() or self.ChatModeList[cur_mode].dontclick
                        if not dontclick then
                            self:SetMode(cur_mode)
                        end
                    end

                    if self.DrawMsgShadows then
                        chat_mode:SetExpensiveShadow(1, color_black)
                    end

                    chat_mode_btn = chat_mode

                    if mode.msgkey and contt[mode.msgkey] then
                        message_text = contt[mode.msgkey]
                    end

                    x = x + chat_mode:GetWide() + 6
                    h = h + 5*scale
                    if not is_nickname then continue end
                end
            end

            if not IsValid(sender) and not IsValid(whosendmsg) and tries == 4 then
                for k, ply in pairs(player.GetHumans()) do
                    if (':' .. (ply:GetNickEmoji() or '') .. ': ') .. ply:Nick() == el then
                        whosendmsg = ply
                        break
                    end
                end
            end

            el = (noparse or url) and el or self:ParseMarkups(contents, line.sender or sender, el, defaultfont, defaultcolor, maxwi - x, contt, ivv, bypassperm, underline, is_nickname or (IsValid(whosendmsg) and tries == 4))

            if (maxwi and el and el ~= "") then
                surface.SetFont(defaultfont)
                local _w, _h = surface.GetTextSize(el)

                if (_w > maxwi - x) and not url then
                    el = self:SplitLine(el, defaultfont, maxwi - x, contt, ivv)

                    if (el == "") then
                        nl = true

                    else
                        el = el .. " "
                    end
                end
            end

            if (el and el ~= "") then
                if (#inline == 0) then
                    el = el:TrimLeft()
                end

                ele = self:MakeChatLabel(el, defaultfont, defaultcolor, contents, underline)

                if not IsValid(firstlabel) and ele then
                    firstlabel = ele
                end

                if ( url and url ~= "" ) and not IsValid( whosendmsg ) then
                    ele:SetMouseInputEnabled(true)
                    ele:SetWide(ele:GetWide() + 1)
                    ele:SetTall(ele:GetTall() + 2)
                    ele.Paint = urlpaint
                    ele.m_URL = url

                        local realurl = ele.m_URL.Trim(ele.m_URL)

                        local btn = vgui.Create("DButton", ele)
                        btn:SetToolTip(realurl)
                        btn:SetText("")
                        btn:Dock(FILL)
                        btn.Paint = function() end
                        btn.DoClick = function(me39)
                            gui.OpenURL(realurl)
                        end
                        btn.DoRightClick = function(me40)
                            line:ShowMenu({
                                {text = translates.Get("Скопировать ссылку"), func = function()
                                    SetClipboardText(realurl)
                                end}
                            })
                        end
                        ele.m_Button = btn

                    table.insert(urlbtns, btn)
                    ele.m_Buttons = urlbtns
                end
            end
        elseif (istable(el)) then
            if (el.r) then
                defaultcolor = el
            elseif (el.font) then
                defaultfont = el.font
            elseif (el.linebreak) then
                forcebreak = true
            elseif (el.noparse ~= nil) then
                noparse = el.noparse
            elseif (el.bypass ~= nil) then
                bypassperm = el.bypass
            elseif (el.pre and ivv == 1) then
                ele = el.pre
                ele:SetParent(contents)
                pre = ele

                bx = bx + ele:GetWide() + (el.space or 0)
            elseif (el.url ~= nil) then
                url = el.url

                if (url == false) then
                    for _, v in ipairs (urlbtns) do
                        if (IsValid(v)) then
                            v.m_Buttons = table.Copy(urlbtns)
                        end
                    end

                    urlbtns = {}
                end
            elseif (el.origtext) then
                origtext = el.origtext
            elseif (el.lua ~= nil) then
                lua = el

                if (el.lua == false) then
                    for _, v in ipairs (luabtns) do
                        if (IsValid(v)) then
                            v.m_Buttons = table.Copy(luabtns)
                        end
                    end

                    luabtns = {}
                    lua = nil
                end
            elseif (el.underline ~= nil) then
                underline = el.underline
            end
        elseif (IsPlayer(el)) then
            local coltouse = team.GetColor(el:Team())
            if (ROLE_DETECTIVE and el.IsActiveDetective and el:IsActiveDetective()) then
                coltouse = Color(50, 200, 255)
            end

            ele = self:MakeChatLabel(el:Nick(), defaultfont, coltouse, contents)
            if not IsValid(line.sender) then
                line.sender = el
            end
        elseif (ispanel(el)) then
            ele = el
        end

        if (lua and ispanel(ele) and IsValid(ele)) then
            local func = lua.lua

            ele:SetMouseInputEnabled(true)
            ele:SetCursor("user")
            ele.m_Lua = lua

                local btn = vgui.Create("DButton", ele)
                btn:SetText("")
                btn:Dock(FILL)
                btn.Paint = function() end
                btn.DoClick = function(me41)
                    func()
                end
                btn.DoRightClick = function(me42)
                    line:ShowMenu()
                end
                ele.m_Button = btn

                if (lua.hover) then
                    btn.OnCursorEntered = function(me43)
                        func()
                    end
                end
        end

        local function newl()
            if (lh == 0) then
                lh = draw.GetFontHeight(defaultfont)
            end

            x = bx
            h = h + lh
            y = y + lh
            lh = 0
            inline = {}
        end

        if (IsValid(ele)) then
            local wi = ele:GetWide()
            local he = ele:GetTall()
            if (ivv == 1 and bx > 0) then
                wi = math.max(wi, bx)
            end

            if (x + wi > maxwi) then
                newl()
            end

            if (he > lh) then
                lh = he

                for _, v in ipairs (inline) do
                    v:AlignTop(y + lh * 0.5 - v:GetTall() * 0.5)
                end
            end

            if (ele:GetName() ~= "DButton") then
                ele.OnMousePressed = function(me44, mc)
                    line:OnMousePressed(mc)
                end
            end

            ele:SetPos(x, y + lh * 0.5 - he * 0.5)
            x = x + wi
            w = x
            table.insert(inline, ele)
        end

        if (nl or forcebreak) then
            newl()
            nl = false
            forcebreak = false
        end
    end

    if (lh > 0) then
        h = h + lh
    end

    line:SetSize(w, h)

    if IsValid(chat_mode_btn) then
        if IsValid(firstlabel) then
            local x, y = firstlabel:GetPos()
            x = chat_mode_btn:GetPos()
            chat_mode_btn:SetPos(x, y + firstlabel:GetTall()*0.5 - chat_mode_btn:GetTall()*0.5)
        end
    else
        line:SetTall(h + 6*scale)
    end

    line.sender = sender or whosendmsg

    if not IsValid(line.sender) and message_mode and message_mode.m and message_mode.m.NickKey and contt[message_mode.m.NickKey] then
        local sender_name = contt[message_mode.m.NickKey]
        if isstring(sender_name) then
            for k, ply in pairs(player.GetAll()) do
                if ply:Name() == sender_name then
                    line.sender = ply
                    break
                end
            end
        elseif IsValid(sender_name) and sender_name:IsPlayer() then
            line.sender = sender_name
        end
    end

    if line.ooc and not r_ooc then
        line.fl_TrueHeight = line.GetTall(line)
        line.SetTall(line, 0)
        line.b_Hidden = true;
    end

    return line
end

function CHATBOX:AddToChatbox(el)
    if not IsValid(_CHATBOX) or not IsValid(el) then return end

    el:SetAlpha(1)

    el.m_fLastVisible = RealTime()
    el.Think = function(me45)
        local sc = _CHATBOX.m_iScrollMin
        local sc2 = _CHATBOX.m_iScrollMax

        local a, b = me45.y, me45.y + me45:GetTall()
        me45.m_Contents.SetVisible(me45.m_Contents, (a >= sc and a <= sc2) or (b >= sc and b <= sc2))

        if self.ChatboxOpen then
            me45:SetAlpha(255)
        end
    end

    local his = _CHATBOX.m_History
    local can = his:GetCanvas()

    if (self.MaxMessages > 0 and #can:GetChildren() > self.MaxMessages) then
        local i = 0
        while (#can:GetChildren() - i > self.MaxMessages) do
            local child = can:GetChild(i)
            if (IsValid(child)) then
                child:Remove()
                i = i + 1
            else
                break
            end
        end
    end

    local newyOffset = his.yOffset
    el:Dock(TOP)
    his:AddItem(el)
    can:InvalidateLayout(true)
    his:InvalidateLayout(true)
    his:InvalidateParent(true)

    --[[
    if self.ChatboxOpen then
		can:InvalidateLayout(true) --

        systimer.Simple(0, function()
            if IsValid(his) then
                his:SetOffset(newyOffset)

                local _, y = his.VBar.ScrollBtn.GetPos(his.VBar.ScrollBtn)
                if y + his.VBar.ScrollBtn.GetTall(his.VBar.ScrollBtn) == his:GetTall() then
                    his:ScrollToBottom()
                end
            end
        end)
    --else
        --timer.Simple(0, function()
            --if IsValid(his) then
                --his:ScrollToBottom()
            --end
        --end)
    end
    ]]--

    systimer.Simple(0, function()
        if IsValid(his) then
            his:SetOffset(newyOffset)

            local _, y = his.VBar.ScrollBtn.GetPos(his.VBar.ScrollBtn)
            if y + his.VBar.ScrollBtn.GetTall(his.VBar.ScrollBtn) == his:GetTall() then
                his:ScrollToBottom()
            end
        end
    end)

    el:SetAlpha(0)
    if cvar.GetValue("enable_simple_chatbox") then
        chat.PlaySound()
    end

    return el
end

function CHATBOX:OpenChatbox(bteam)
    if (self.ChatboxOpen) then return end

    hook.Call("StartChat", GAMEMODE, bteam)

    if (!IsValid(_CHATBOX)) then
        self:CreateChatbox()
    end
    if IsValid(_CHATBOX_EMOTICONS) then
        _CHATBOX_EMOTICONS:SetVisible(false)

		if IsValid(_CHATBOX_EMOTICONS.trigon) then
			_CHATBOX_EMOTICONS.trigon.SetVisible(_CHATBOX_EMOTICONS.trigon, false)
		end
    end

    _CHATBOX.m_fAlpha = 0
    _CHATBOX:Stop()
    _CHATBOX:NewAnimation(self.Anims.FadeInTime).Think = function(anim, me, frac)
        me.m_fAlpha = 255 * frac
    end

    _CHATBOX:MakePopup()

    _CHATBOX.m_Entry.m_iCurPos = nil
    _CHATBOX.m_Entry.RequestFocus(_CHATBOX.m_Entry)

    if (ROLE_TRAITOR and LocalPlayer().IsSpecial and !LocalPlayer():IsSpecial()) then
        bteam = false
    end
    _CHATBOX.m_bTeam = bteam

    if bteam then
        local ishidden = self.ChatModeList[self.GroupChat].hidden
        if isfunction(ishidden) then
            ishidden = ishidden()
        end
        if ishidden then
            self:SetMode(self.LocalChat)
        else
            self:SetMode(self.GroupChat)
        end
    else
        self:SetMode(self.LocalChat)
    end

    self.ChatboxOpen = true
	_CHATBOX:SetVisible(true)

    local his = _CHATBOX.m_History
    local can = his:GetCanvas()

	can:InvalidateLayout(true)
	his:ScrollToBottom(nil, true)

	systimer.Simple(0, function()
		if IsValid(his) then
			his:ScrollToBottom(nil, true)
		end
	end)

    net.Start("CHATBOX.Typing")
        net.WriteBool(true)
    net.SendToServer()
end

function CHATBOX:CloseChatbox()
    if (IsValid(_CHATBOX_EMOTICONS)) then
        _CHATBOX_EMOTICONS:Close()
    end

    self.ChatboxOpen = false
	_CHATBOX:SetVisible(false)

    SIMPLE_CHATBOX:UpdateLayout()

    net.Start("CHATBOX.Typing")
        net.WriteBool(false)
    net.SendToServer()

    hook.Call("ChatTextChanged", GAMEMODE, "")
    hook.Call("FinishChat", GAMEMODE)

    local a = _CHATBOX.m_fAlpha or 255

    _CHATBOX:Stop()
    _CHATBOX:NewAnimation(self.Anims.FadeOutTime * (a / 255)).Think = function(anim, me46, frac)
        me46.m_fAlpha = a * (1 - frac)
    end

    _CHATBOX:SetKeyboardInputEnabled(false)
    _CHATBOX:SetMouseInputEnabled(false)

    _CHATBOX.m_Entry.SetText(_CHATBOX.m_Entry, "")
end

chat.OldGetChatBoxPos = chat.OldGetChatBoxPos or chat.GetChatBoxPos
chat.OldGetChatBoxSize = chat.OldGetChatBoxSize or chat.GetChatBoxSize
chat.OldAddText = chat.OldAddText or chat.AddText

function chat.GetChatBoxPos()
    if (IsValid(_CHATBOX)) then
        return _CHATBOX:GetPos()
    else
        return chat.OldGetChatBoxPos()
    end
end

function chat.GetChatBoxSize()
    if (IsValid(_CHATBOX)) then
        return _CHATBOX:GetSize()
    else
        return chat.OldGetChatBoxSize()
    end
end

local function AddToChatbox(contt, maxwi, parent, sender)
    CHATBOX:AddToChatbox(CHATBOX:ParseLineWrap(table.Copy(contt), maxwi, parent, sender))
    SIMPLE_CHATBOX:AddToChatbox(SIMPLE_CHATBOX:ParseLineWrap(contt, maxwi, parent, sender))
end

function chat.AddText(...)
    local args = {...}

    local t = {}
    for _, v in pairs (args) do
        if (isstring(v)) then
            table.insert(t, v)
        end
    end
    local origtext = table.concat(t, "")
    table.insert(args, {origtext = origtext})

    chat.OldAddText(...)

    AddToChatbox(args, true)
end

concommand.Add("chatbox_clear", function()
    _CHATBOX.m_History.Clear(_CHATBOX.m_History)
end)

local con = {}
local tab = {}
local function Add(el, console, i)
    if (istable(el) and #el > 1) then
        table.Add(tab, el)
    else
        if (i) then
            table.insert(tab, i, el)
        else
            table.insert(tab, el)
        end
    end

    if (console) then
        if (istable(el) and !el.r) then
            table.Add(con, el)
        else
            if (i) then
                table.insert(con, i, el)
            else
                table.insert(con, el)
            end
        end
    end
end

function CHATBOX:OnPlayerChat(ply, text, bteam, bdead, preftext, prefcolor, color)
    con = {}
    tab = {}

    Add({bypass = true})

    local textcol = color_white
    local namecol = IsValid(ply) and team.GetColor(ply:Team()) or color_white

    if bteam then
        if (bteam == true and IsValid(ply)) then
            Add({team.GetColor(ply:Team()), self.TagTeam})

            table.insert(con, team.GetColor(ply:Team()))
            table.Add(con, self.TagTeamConsole)
        elseif (istable(bteam) and bteam.color and bteam.text) then
            Add({bteam.color, bteam.text}, true)
        end
    end

    if IsValid(ply) then
        if ply:GetNickEmoji() then
            Add({color_white, {noparse = true}, ':' .. ply:GetNickEmoji() .. ':', {noparse = false}}, true)
        end

        Add({namecol, {noparse = true}, ply:Nick(), {noparse = false}}, true)
    else
        Add(self.ConsoleName, true)
    end

    table.insert(con, prefcolor)
    table.insert(con, preftext)
    table.insert(con, textcol)
    table.insert(con, ": " .. text)


    Add({bypass = false})

    Add({textcol, ": " .. text})

    chat.OldAddText(unpack(con))

    table.insert(tab, {origtext = text})

    AddToChatbox(tab, true, nil, ply)
end

function CHATBOX:AddLuaMessage(text, func, hover)
    local tab = {
        {origtext = text},
        {lua = func, hover = hover or false},
        text,
        {lua = false},
    }

    AddToChatbox(tab, true, nil, ply)
end

CHATBOX.LuaButtons = {}

function CHATBOX:MakeLuaButton(text, func, hover)
    local i = #self.LuaButtons + 1
    self.LuaButtons[i] = func

    return "<luabtn=" .. i .. "," .. (hover and 1 or 0) .. ">" .. text .. "</luabtn>"
end

hook.Add("OnPlayerChat", "CHATBOX.OnPlayerChat", function(ply, text, bteam, bdead, preftext, prefcolor, color)
    CHATBOX:OnPlayerChat(ply, text, bteam, bdead, preftext, prefcolor, color)
    return true
end)

hook.Add("PlayerBindPress", "CHATBOX.PlayerBindPress", function(ply, bind, press)
    if (bind:find("messagemode")) then
        CHATBOX:OpenChatbox(bind:find("messagemode2"))
        return true
    end
end)

local ChatText_Blocked = {
    ["joinleave"] = true,
    ["namechange"] = true
};

hook.Add("ChatText", "CHATBOX.ChatText", function(index, name, text, typ)
    if ChatText_Blocked[typ] then return true end
    if index ~= 0 then return end

    chat.AddText(text)
end)

hook.Add("HUDShouldDraw", "CHATBOX.HUDShouldDraw", function(h)
    if (h == "CHudChat") then
        return false
    end
end)

CHATBOX:CreateChatboxFonts()

hook.Add("InitPostEntity", "CHATBOX.InitPostEntity", function()
    CHATBOX:CreateChatboxFonts()

	for k, v in pairs(CHATBOX.ChatModeList) do
		if not v.pattern then continue end

		if istable(v.pattern) then
			for k2, v2 in pairs(v.pattern) do
				CHATBOX.ChatModeParsers[v2] = k
			end
		else
			CHATBOX.ChatModeParsers[v.pattern] = k
		end
	end
end)

hook.Add("Think", "CHATBOX.Think", function()
    if (IsValid(LocalPlayer())) then
        hook.Remove("Think", "CHATBOX.Think")

        CHATBOX:CreateChatbox()
        SIMPLE_CHATBOX:Initialize()

        for _, v in pairs (messagequeue) do
			AddToChatbox(v.cont, v.maxwi, v.parent, v.sender)
        end
    end
end)

concommand.Add("reload_chatbox", function(ply)
    if not ply:IsRoot() then return end

    CHATBOX:CreateChatboxFonts()
    CHATBOX:CreateChatbox()

    for _, v in pairs (messagequeue) do
		AddToChatbox(v.cont, v.maxwi, v.parent, v.sender)
    end
end)

concommand.Add("dev_spam", function(ply, cmd, args)
    if not ply:IsRoot() then return end
    for ika = 1, (tonumber(args[1]) or 5) do
        local text = ""
        for ita = 1, math.random(2, 5) do
            text = text .. util.CRC( math.random(-999, 999) )
            local emote = args[2] and (" :"..table.Random( table.GetKeys(CHATBOX.Emoticons) )..":") or ""
            text = text .. emote
        end
        chat.AddText(text)
    end
end)
