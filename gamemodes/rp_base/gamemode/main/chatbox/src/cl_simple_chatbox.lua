-- "gamemodes\\rp_base\\gamemode\\main\\chatbox\\src\\cl_simple_chatbox.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
cvar.Register( "enable_simple_chatbox" )
    :AddMetadata( "State", "RPMenu" )
    :AddMetadata( "Menu", translates.Get("Включить отображение истории чата") )
    :SetDefault( true )

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
local surface_SetAlphaMultiplier = surface.SetAlphaMultiplier
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local draw_TextShadow = draw.TextShadow
local draw_Blur = draw.Blur

local dw = 546
local dh = 248

local cv_shouldRender = cvar.Get( "enable_simple_chatbox" );

hook.Add( "ChatboxChangedRenderOOC", "SIMPLE_CHATBOX::ChatboxChangedRenderOOC", function(state)
    if CHATBOX and not CHATBOX.ChatboxOpen then
        timer.Simple(0, function()
            SIMPLE_CHATBOX:UpdateLayout()
        end)
    end
end );

function SIMPLE_CHATBOX:Initialize()
	if IsValid(SIMPLE_CHATBOX.box) then
		SIMPLE_CHATBOX.box:Remove()
	end

    _CHATBOX_SCALE = math.Clamp(ScrH() / 1080, 0.7, 1)

    local wi = math.max(dw, cookie.GetNumber("urfchatbox_w", CHATBOX.Size.w) * _CHATBOX_SCALE)
    local he = math.max(dh, cookie.GetNumber("urfchatbox_h", CHATBOX.Size.h) * _CHATBOX_SCALE)

    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:ShowCloseButton(false)
    frame:SetScreenLock(true)
    frame:SetSize(wi, he)
    frame:SetPos(0, cookie.GetNumber("urfchatbox_y", CHATBOX.PosY / 1080 * ScrH()) * _CHATBOX_SCALE)

	frame.m_fLastVisible = 0

	self.box = frame
	_SIMPLE_CHATBOX = frame

    frame.Paint = function(me, w, h)
        if (not cv_shouldRender) or (not cv_shouldRender.Value) then return end
        if gui.IsGameUIVisible() then return end

        if not CHATBOX.ChatboxOpen then
            local cb = CHATBOX.Color("bg")
            local af = _CHATBOX.m_fAlphaFrac or 1

            if RealTime() - me.m_fLastVisible >= chat_message_hidetime and !me.m_bFading then
                me.m_bFading = true
                me:AlphaTo(0, CHATBOX.Anims.TextFadeOutTime, 0, function()
					me:SetVisible(false)
				end)
            end

			me.m_History.PaintManual(me.m_History)
        end
    end

    frame.PerformLayout = function(me, w, h)
        local scale_tp = math.Clamp(ScrH() / 1080, 0.7, 1)

        local his_w = frame:GetWide() - 15 * scale_tp
        local his_h = frame:GetTall() - 25 * scale_tp - 42 * scale_tp
        me.m_History.SetSize(me.m_History, his_w, his_h)
        local his_x = frame:GetWide() - me.m_History.GetWide(me.m_History)
        local his_y = 15 * scale_tp
        me.m_History.SetPos(me.m_History, his_x, his_y)
	end

	frame.Think = function(self3)
        if _CHATBOX.Dragging then
            local x, y = _CHATBOX:GetPos()
            self3:SetPos(x, y)
        end

        if _CHATBOX.Sizing then
            local x, y = _CHATBOX:GetSize()
            self3:SetSize(x, y)
        end
    end

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

	history.ScrollToBottom = function(me3, max)
		local curOffset = me3.yOffset
		local maxOffset = max or me3:GetCanvas():GetTall()

		me3:Stop()
		me3:SetOffset(maxOffset)
	end

	history.VBar.SetAlpha(history.VBar, 0)

	frame.m_History = history
	history:InvalidateParent(true)
end

local color_black, color_white = Color(0, 0, 0), Color(255, 255, 255)
local line, contents, url, scale, firstlabel, chat_mode_btn, whosendmsg, next_skip
local ele, forcebreak, cur_mode, pat, mode, chat_txt, chat_mode, message_mode, el_len

local bx = 0
local x = 0
local y = 0
local w = 0
local lh = 0
local h = 0
local tries = 0
local nl = false
local inline = {}

local defaultfont = CHATBOX.ChatboxFont
local defaultcolor = CHATBOX.Color("msg")
local noparse = false
local bypassperm = false
local underline = false
local is_nickname = false

local function IsPlayer(e)
    return type(e) == "Player" and IsValid(e)
end

function SIMPLE_CHATBOX:ParseLineWrap(contt, maxwi, parent, sender)
	if not IsValid(_SIMPLE_CHATBOX) then
		return
	end

    if maxwi == true then
        maxwi = _SIMPLE_CHATBOX.m_History.GetWide(_SIMPLE_CHATBOX.m_History) - 24
    end

    line = vgui.Create("Panel", parent)

	contents = vgui.Create("Panel", line)
	contents:Dock(FILL)
	line.m_Contents = contents

    bx = 0
    x = 0
    y = 0
    w = 0
    lh = 0
    h = 0

    nl = false
    inline = {}

    defaultfont = CHATBOX.ChatboxFont
    defaultcolor = CHATBOX.Color("msg")
    noparse = false
    bypassperm = false
    underline = false
    url = false

    scale = 1080 / ScrH()

    firstlabel = nil
    chat_mode_btn = nil
    whosendmsg = nil
	message_mode = nil

    next_skip = nil
    tries = 0

    for ivv, el in pairs(contt) do
        tries = tries + 1
        if (tries > 512) then
            line:Remove()
            --error("overflow!! (this shouldn't happen, report this to the author with the message)")
            return
        end

        ele = nil
		forcebreak = nil

        if isstring(el) or isnumber(el) then
            if el == "" then continue end

            if next_skip then
                next_skip = nil
                continue
            end

            is_nickname = false

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
                cur_mode = nil

                if is_nickname then
                    cur_mode = 1
                else
					el_len = utf8.len(el)

					if not isbool(el_len) then
						pat = utf8.sub(el, 1, el_len - 1)

						if CHATBOX.ChatModeParsers[pat] then
							cur_mode = CHATBOX.ChatModeParsers[pat]
						end
                    end
                end

                if cur_mode then
                    mode = CHATBOX.ChatModeList[cur_mode]
                    if not mode then continue end

                    message_mode = {m = mode, ivv = cur_mode}

                    chat_txt = isfunction(mode.name) and mode.name(el, ivv, contt) or mode.name
                    if not chat_txt then continue end

                    if mode.skipnext then
                        next_skip = isfunction(mode.skipnext) and mode.skipnext(el, ivv, contt) or mode.skipnext
                    end

                    chat_mode = vgui.Create("DButton")
                    chat_mode.txt = chat_txt

                    chat_mode:SetText(chat_mode.txt)
                    chat_mode:SetFont("CHATBOX_14_B")
                    chat_mode:SizeToContents()
                    chat_mode:SetWide(chat_mode:GetWide() + 4)
                    chat_mode:SetParent(contents)
                    chat_mode.bg_col = mode.col
                    chat_mode:SetCursor("arrow")

                    chat_mode:SetText("")
                    chat_mode.Paint = function(me38, w38, h38)
                        draw.RoundedBox(8, 0, 0, w38, h38, me38.bg_col)
                        draw.SimpleTextShadow(me38.txt, me38:GetFont(), w38*0.5, h38*0.5, CHATBOX.Color("mode_name"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, 175, true)
                    end

                    if mode.cmd and mode.cmd == "/ooc" then
                        line.ooc = true;
                    end

                    if CHATBOX.DrawMsgShadows then
                        chat_mode:SetExpensiveShadow(1, color_black)
                    end

                    chat_mode_btn = chat_mode

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

            el = (noparse or url) and el or CHATBOX:ParseMarkups(contents, line.sender or sender, el, defaultfont, defaultcolor, maxwi - x, contt, ivv, bypassperm, underline, is_nickname or (IsValid(whosendmsg) and tries == 4))

            if maxwi and el and el ~= "" then
                surface.SetFont(defaultfont)
                local _w, _h = surface.GetTextSize(el)

                if (_w > maxwi - x) and not url then
                    el = CHATBOX:SplitLine(el, defaultfont, maxwi - x, contt, ivv)

                    if el == "" then
                        nl = true

                    else
                        el = el .. " "
                    end
                end
            end

            if el and el ~= "" then
                if #inline == 0 then
                    el = el:TrimLeft()
                end

                ele = CHATBOX:MakeChatLabel(el, defaultfont, defaultcolor, contents, underline)

                if not IsValid(firstlabel) and ele then
                    firstlabel = ele
                end

                if url and url ~= "" and not IsValid( whosendmsg ) then
                    ele:SetMouseInputEnabled(false)
                    ele:SetWide(ele:GetWide() + 1)
                    ele:SetTall(ele:GetTall() + 2)
					ele:SetTextColor(CHATBOX.Color("url"))
                    ele.Paint = CHATBOX.UnderlinePaint
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

                bx = bx + ele:GetWide() + (el.space or 0)

            elseif (el.url ~= nil) then
                url = el.url

            elseif (el.underline ~= nil) then
                underline = el.underline
            end

        elseif IsPlayer(el) then
            local coltouse = team.GetColor(el:Team())

            if ROLE_DETECTIVE and el.IsActiveDetective and el:IsActiveDetective() then
                coltouse = Color(50, 200, 255)
            end

            ele = CHATBOX:MakeChatLabel(el:Nick(), defaultfont, coltouse, contents)

            if not IsValid(line.sender) then
                line.sender = el
            end

        elseif ispanel(el) then
            ele = el

			--el.Paint = function(me, w, h)
				--if me.m_Image then
					--print(me)
					--surface.SetDrawColor(color_white)
					--surface.SetMaterial(me.m_Image)
					--surface.DrawTexturedRect(0, 0, w, h)
				--end
			--end
        end

        local function newl()
            if lh == 0 then
                lh = draw.GetFontHeight(defaultfont)
            end

            x = bx
            h = h + lh
            y = y + lh
            lh = 0
            inline = {}
        end

        if IsValid(ele) then
            local wi = ele:GetWide()
            local he = ele:GetTall()

            if ivv == 1 and bx > 0 then
                wi = math.max(wi, bx)
            end

            if x + wi > maxwi then
                newl()
            end

            if he > lh then
                lh = he

                for _, v in ipairs(inline) do
                    v:AlignTop(y + lh * 0.5 - v:GetTall() * 0.5)
                end
            end

            ele:SetPos(x, y + lh * 0.5 - he * 0.5)

            x = x + wi
            w = x
            table.insert(inline, ele)
        end

        if nl or forcebreak then
            newl()
            nl = false
            forcebreak = false
        end
    end

    if lh > 0 then
        h = h + lh
    end

    line:SetSize(w, h)

    if IsValid(chat_mode_btn) then
        if IsValid(firstlabel) then
            local x, y = firstlabel:GetPos()
            x = chat_mode_btn:GetPos()
            chat_mode_btn:SetPos(x, y + firstlabel:GetTall() * 0.5 - chat_mode_btn:GetTall() * 0.5)
        end
    else
        line:SetTall(h + 6 * scale)
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

function SIMPLE_CHATBOX:AddToChatbox(el)
    if not IsValid(_SIMPLE_CHATBOX) or not IsValid(el) then return end

    el:SetAlpha(0)
    el:AlphaTo(255, CHATBOX.Anims.FadeInTime)

	timer.Simple(chat_message_hidetime, function()
		if not IsValid(el) then return end
		el:AlphaTo(0, CHATBOX.Anims.FadeOutTime)
	end)

    local his = _SIMPLE_CHATBOX.m_History
    local can = his:GetCanvas()

    _SIMPLE_CHATBOX.m_fLastVisible = RealTime()
    _SIMPLE_CHATBOX.m_bFading = false
	_SIMPLE_CHATBOX:Stop()
	_SIMPLE_CHATBOX:SetVisible(true)
	_SIMPLE_CHATBOX:SetAlpha(255)

    if #can:GetChildren() > 10 then
        local i = 0

        while #can:GetChildren() - i > CHATBOX.MaxMessages do
            local child = can:GetChild(i)

            if IsValid(child) then
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

    if not CHATBOX.ChatboxOpen then
		SIMPLE_CHATBOX:UpdateLayout()
    end

    return el
end

function SIMPLE_CHATBOX:UpdateLayout()
	if not IsValid(_SIMPLE_CHATBOX) then return end

    local r_ooc, cv_ooc = true, cvar.Get("enable_chatbox_ooc")
    if cv_ooc then
        r_ooc = tobool(cv_ooc:GetValue());
    end

    local his = _SIMPLE_CHATBOX.m_History
    local can = his:GetCanvas()

    for k, el in ipairs( can:GetChildren() ) do
        if not el.ooc then continue end

        if r_ooc and el.b_Hidden and el.fl_TrueHeight then
            el.SetTall(el, el.fl_TrueHeight)
            el.b_Hidden = nil

            continue
        end

        if not r_ooc and not el.b_Hidden then
            el.fl_TrueHeight = el.GetTall(el)
            el.b_Hidden = true

            continue
        end
    end

	can:InvalidateLayout(true)
	his:InvalidateLayout(true)

    his:ScrollToBottom()

	timer.Simple(0, function()
		if IsValid(his) then
			his:ScrollToBottom()
		end
	end)
end
