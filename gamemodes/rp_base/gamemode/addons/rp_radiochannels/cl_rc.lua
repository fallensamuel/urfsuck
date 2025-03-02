-- "gamemodes\\rp_base\\gamemode\\addons\\rp_radiochannels\\cl_rc.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local LocalPlayer = LocalPlayer
local pairs = pairs
local net_Start = net.Start
local net_SendToServer = net.SendToServer
local surface_PlaySound = surface.PlaySound
local hook_Add = hook.Add
local IsValid = IsValid
local sound_PlayFile = sound.PlayFile
local Material = Material
local Color = Color
local surface_CreateFont = surface.CreateFont
local ScrH = ScrH
local math_Truncate = math.Truncate
local draw = draw
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local draw_SimpleText = draw.SimpleText
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local input_IsKeyDown = input.IsKeyDown
local gui_HideGameUI = gui.HideGameUI
local vgui_Register = vgui.Register
local vgui_Create = vgui.Create
local tonumber = tonumber
local timer_Simple = timer.Simple
local net_WriteUInt = net.WriteUInt
local ipairs = ipairs
local net_Receive = net.Receive
local rp_RefreshContextMenu = rp.RefreshContextMenu
local rp_AddContextCommand = rp.AddContextCommand
local translates_Get = translates.Get
local rpui_GetPaintStyle = rpui.GetPaintStyle


if not rp.cfg.DisableContextRedisign then
    local hear_text1 = translates and translates_Get("Включить приём рации") or "Включить приём рации"
    local hear_text2 = translates and translates_Get("Выключить приём рации") or "Выключить приём рации"
    local speak_text1 = translates and translates_Get("Включить передачу рации") or "Включить передачу рации"
    local speak_text2 = translates and translates_Get("Выключить передачу рации") or "Выключить передачу рации"
    local radio_text = translates and translates_Get("Рация") or "Рация"
    local channels_text = translates and translates_Get("Сменить канал рации") or "Сменить канал рации"
    local select_frequency = translates and translates_Get("Выбрать частоту") or "Выбрать частоту"

    local channels_map = rp.RadioTitles

    local btn_names = {
        Hear = {hear_text1, hear_text2},
        Speak = {speak_text1, speak_text2},
    }

    local btn_state = {
        Hear = 2,
        Speak = 1,
    }

    local function radioCanHear()
        return rp.RadioChanels and LocalPlayer():GetNetVar("RC_RadioChannel") and rp.RadioChanels[LocalPlayer():Team()]
    end

    local function radioCanSpeak()
        return rp.RadioSpeakers and LocalPlayer():GetNetVar("RC_RadioChannel") and rp.RadioSpeakers[LocalPlayer():Team()]
    end

    local function radioCanUse()
        return (rp.RadioSpeakers and rp.RadioSpeakers[LocalPlayer():Team()]) or rp.RadioFrequencyAccess[LocalPlayer():Team()] or LocalPlayer():GetNetVar("RC_RadioFrequency")
    end

    local function switchName(old, new)
        for k,v in pairs(rp.ContextMenu.Categories[radio_text].Commands) do
            if v.Name == old then
                v.Name = new
                rp_RefreshContextMenu()
            end
        end
    end

    local function radioMixContext(mode)
        local old_name
        for k, v in pairs((mode and {mode}) or {"Hear", "Speak"}) do
            old_name = btn_names[v][btn_state[v]]
            btn_state[v] = 3 - btn_state[v]
            switchName(old_name, btn_names[v][btn_state[v]])
        end
    end

    local function radioSwitch(mode)
        if mode ~= "Speak" and mode ~= "Hear" then return end

        radioMixContext(mode)

        net_Start("RC_RadioSwitch" .. mode)
        net_SendToServer()

        surface_PlaySound("sound/npc/overwatch/radiovoice/off4.wav")
    end

    function rp.IsRadioTransmiting()
        return LocalPlayer():GetNetVar("RC_RadioOnSpeak") or false
    end

    function rp.IsRadioReceiving()
        return LocalPlayer():GetNetVar("RC_RadioOnHear") or false
    end

    ----- Channels activate/deactivate sound -----
    local channels = rp.RadioChanels or {}
    local speakers = rp.RadioSpeakers or {}
    hook_Add("PlayerStartVoice", "rp.RadioStart", function(ply)
        if not IsValid(LocalPlayer()) or not IsValid(ply) then return end

        if (
            LocalPlayer():GetNetVar("RC_RadioChannel") == 0
            and LocalPlayer():GetNetVar("RC_RadioFrequency")
            and ply:GetNetVar("RC_RadioOnSpeak")
        ) then
            sound_PlayFile("sound/npc/overwatch/radiovoice/off4.wav", "", function(station)
                if IsValid(station) then
                    station:Play()
                    station:SetVolume(0.3)
                end
            end)
        end

        if (
            channels[LocalPlayer():Team()]
            and channels[LocalPlayer():Team()][LocalPlayer():GetNetVar("RC_RadioChannel")]
            and channels[LocalPlayer():Team()][LocalPlayer():GetNetVar("RC_RadioChannel")][ply:Team()]
            and ply:GetNetVar("RC_RadioOnSpeak")
        ) then
            sound_PlayFile("sound/npc/overwatch/radiovoice/off4.wav", "", function(station)
                if IsValid(station) then
                    station:Play()
                    station:SetVolume(0.3)
                end
            end)
        end
    end)

    hook_Add("PlayerEndVoice", "rp.RadioEnd", function(ply)
        if not IsValid(LocalPlayer()) or not IsValid(ply) then return end

        if (
            LocalPlayer():GetNetVar("RC_RadioChannel") == 0
            and LocalPlayer():GetNetVar("RC_RadioFrequency")
            and ply:GetNetVar("RC_RadioOnSpeak")
        ) then
            sound_PlayFile("sound/weapons/radiooperator/targetacquired.mp3", "", function(station)
                if IsValid(station) then
                    station:Play()
                    station:SetVolume(0.3)
                end
            end)
        end

        if (
            channels[LocalPlayer():Team()]
            and channels[LocalPlayer():Team()][LocalPlayer():GetNetVar("RC_RadioChannel")]
            and channels[LocalPlayer():Team()][LocalPlayer():GetNetVar("RC_RadioChannel")][ply:Team()]
            and ply:GetNetVar("RC_RadioOnSpeak")
        ) then
            sound_PlayFile("sound/weapons/radiooperator/targetacquired.mp3", "", function(station)
                if IsValid(station) then
                    station:Play()
                    station:SetVolume(0.3)
                end
            end)
        end
    end)

    local cached_texts = {
        title_text = translates_Get("ВЫБОР ЧАСТОТЫ"),
        info_text = translates_Get("УКАЖИТЕ ЧАСТОТУ:"),
        agree_text = translates_Get("Выбрать"),
        accept_text = translates_Get("Применить"),
        cancel_text = translates_Get("Отмена"),
        placeholder_text = translates_Get("Формат - 000"),
        ex_placeholder_text = translates_Get("Формат - 0"),
    }

    local cached_materials = {
        frame_icon = Material("rpui/radio/chanel_change.png", "smooth noclamp"),
    }

    local cached_fonts = {
        title_font = "Radio_Ui_Title",
        text_font = "Radio_Ui_TextBold",
    }

    local cached_colors = {
        color_white = Color(255, 255, 255),
        color_black = Color(0, 0, 0),
    }

    local cached_font_sizes = {
        title = 22,
        text = 22,
    }

    local FRAME = {}
    function FRAME:RebuildFonts(frameH)
        local title_tall = frameH * 0.17
        local text_tall = frameH * 0.17

        cached_font_sizes.title = title_tall
        surface_CreateFont(cached_fonts.title_font, {
            font = "Roboto",
            extended = true,
            weight = 500,
            size = title_tall,
        })

        cached_font_sizes.text = text_tall
        surface_CreateFont(cached_fonts.text_font, {
            font = "Montserrat",
            extended = true,
            weight = 500,
            size = text_tall,
        })
    end

    local scrh = ScrH()
    function FRAME:Init()
        self:SetFocusTopLevel(true)

        self:SetSize(scrh * 0.65, scrh * 0.15)
        self:RebuildFonts(self:GetTall())

        self.m_DockPadding = math_Truncate(self:GetTall() * 0.1)
        self.m_TitlePadding = math_Truncate(self:GetTall() * 0.2)
        self:DockPadding(self.m_DockPadding, self.m_TitlePadding + self.m_DockPadding, self.m_DockPadding, self.m_DockPadding)
        self:SetName("RadioFrequencyFrame")

        return true
    end

    function FRAME:GetClassName() return "RadioFrequencyFrame" end

    function FRAME:Paint(w, h)
        draw.Blur(self)
        surface_SetDrawColor(255, 255, 255)
        surface_DrawRect(0, 0, w, self.m_TitlePadding)

        local icon_padding = self.m_TitlePadding * 0.26
        local icon_size = self.m_TitlePadding * 0.6
        surface_SetDrawColor(0, 0, 0)
        surface_SetMaterial(cached_materials.frame_icon)
        surface_DrawTexturedRect(icon_padding, icon_padding, icon_size, icon_size)

        draw_SimpleText(cached_texts.title_text, cached_fonts.title_font, icon_padding + icon_size + 10, self.m_TitlePadding * 0.55, cached_colors.color_black, TEXT_ALIGN_TOP, TEXT_ALIGN_CENTER)

        surface_SetDrawColor(0, 0, 0, 200)
        surface_DrawRect(0, self.m_TitlePadding, w, h - self.m_TitlePadding)

        surface_SetDrawColor(60, 60, 66, 150)
        surface_DrawOutlinedRect(0, 0, w, h)

        return true
    end

    function FRAME:Think()
        if input_IsKeyDown(KEY_ESCAPE) then
            gui_HideGameUI()
            if IsValid(rpui.ESCMenu) then rpui.ESCMenu.HideMenu(rpui.ESCMenu) end
            self:Remove()
        end
    end

    vgui_Register("RadioFrequencyFrame", FRAME, "EditablePanel")

    local frame
    local function OpenFrequencyMenu()
        if frame and IsValid(frame) then frame:Remove() return end

        frame = vgui_Create("RadioFrequencyFrame")
        frame:Center()
        frame:MakePopup()

        local switch_btn = frame:Add("DButton")
        switch_btn:SetSize(frame:GetWide() * 0.45, frame.m_TitlePadding * 1.2)
        switch_btn:SetPos(frame.m_DockPadding, frame:GetTall() - switch_btn:GetTall() - frame.m_DockPadding)
        switch_btn:SetText("")
        switch_btn:SetFont(cached_fonts.text_font)

        local cancel_btn = frame:Add("DButton")
        cancel_btn:SetSize(frame:GetWide() * 0.45, frame.m_TitlePadding * 1.2)
        cancel_btn:SetPos(frame:GetWide() - cancel_btn:GetWide() - frame.m_DockPadding, frame:GetTall() - cancel_btn:GetTall() - frame.m_DockPadding)
        cancel_btn:SetText("")
        cancel_btn:SetFont(cached_fonts.text_font)
        cancel_btn.DoClick = function(self_b)
            frame:Remove()
        end
        cancel_btn.Paint = function(self, w, h)
            local baseColor, textColor = rpui_GetPaintStyle(self, STYLE_SOLID)
            surface_SetDrawColor(baseColor)
            surface_DrawRect(0, 0, w, h)
            draw_SimpleText(cached_texts.cancel_text, self:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local frequency_label = frame:Add("DLabel")
        frequency_label:SetFont(cached_fonts.text_font)
        frequency_label:SetText(cached_texts.info_text)
        frequency_label:SizeToContents()
        frequency_label:SetPos(switch_btn:GetWide() * 0.5 + switch_btn:GetX() - frequency_label:GetWide() * 0.5, frame.m_TitlePadding + frame.m_DockPadding)

        local freq_entry = frame:Add("urf.im/rpui/txtinput")
        freq_entry:SetSize(frequency_label:GetWide() * 0.7 - frame.m_DockPadding, frame:GetTall() * 0.21)
        freq_entry:SetPos(cancel_btn:GetX() + cancel_btn:GetWide() * 0.1, frame.m_TitlePadding + frame.m_DockPadding)
        freq_entry:SetFont(cached_fonts.text_font)
        freq_entry:SetPlaceholderText(cached_texts.placeholder_text)
        freq_entry:SetNumeric(true)
        freq_entry.UID = "radio_frequency"
        freq_entry:ApplyDesign()
        freq_entry:SetUpdateOnType(true)
        freq_entry.OnValueChange = function(self, value)
            if #value > 3 then
                self:SetValue(tonumber(self.m_LastValue))
                self:SetText(self.m_LastValue)
                self:SetCaretPos(#self.m_LastValue)
                return
            end
            self.m_LastValue = value
        end

        local dot = frame:Add("DLabel")
        dot:SetPos(freq_entry:GetWide() + freq_entry:GetX(), frame.m_TitlePadding + frame.m_DockPadding)
        dot:SetFont(cached_fonts.text_font)
        dot:SetText(".")
        dot:SizeToContents()

        local ex_freq_entry = frame:Add("urf.im/rpui/txtinput")
        ex_freq_entry:SetSize(frequency_label:GetWide() * 0.55 - frame.m_DockPadding, frame:GetTall() * 0.21)
        ex_freq_entry:SetPos(dot:GetWide() + dot:GetX(), frame.m_TitlePadding + frame.m_DockPadding)
        ex_freq_entry:SetFont(cached_fonts.text_font)
        ex_freq_entry:SetPlaceholderText(cached_texts.ex_placeholder_text)
        ex_freq_entry:SetNumeric(true)
        ex_freq_entry.UID = "radio_ex_frequency"
        ex_freq_entry:ApplyDesign()
        ex_freq_entry:SetUpdateOnType(true)
        ex_freq_entry.OnValueChange = function(self, value)
            if #value > 1 then
                self:SetValue(tonumber(self.m_LastValue))
                self:SetText(self.m_LastValue)
                self:SetCaretPos(#self.m_LastValue)
                return
            end
            self.m_LastValue = value
        end

        switch_btn.DoClick = function(self)
            if not self.Accepted then
                self.Accepted = true

                timer_Simple(2, function()
                    if not IsValid(self) then return end
                    self.Accepted = false
                end)
            else
                frame:Remove()

                local freq = (tonumber(freq_entry:GetValue()) or 0) * 10 + (tonumber(ex_freq_entry:GetValue()) or 0)

                net_Start("RC_SwitchFrequency")
                    net_WriteUInt(freq, 14)
                net_SendToServer()
            end
        end
        switch_btn.Paint = function(self, w, h)
            local text = not self.Accepted and cached_texts.agree_text or cached_texts.accept_text

            local baseColor, textColor = rpui_GetPaintStyle(self, STYLE_SOLID)
            surface_SetDrawColor(baseColor)
            surface_DrawRect(0, 0, w, h)
            draw_SimpleText(text, self:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    rp_AddContextCommand(radio_text, btn_names["Hear"][btn_state["Hear"]], function()
        radioSwitch("Hear")
    end, radioCanHear, "cmenu/chat")

    rp_AddContextCommand(radio_text, btn_names["Speak"][btn_state["Speak"]], function()
        radioSwitch("Speak")
    end, radioCanSpeak, "cmenu/chat")

    rp_AddContextCommand(radio_text, channels_text, function(parent)
        local dropdown = vgui_Create("rpui.DropMenu")
        dropdown:SetBase(parent)
        dropdown:SetFont("Context.DermaMenu.Label")
        dropdown:SetSpacing(ScrH() * 0.01)
        dropdown.Paint = function(this, w, h) draw.Blur(this) end

        if rp.RadioFrequencyAccess[LocalPlayer():Team()] then
            local option = dropdown:AddOption(select_frequency, function(this)
                if not this.Selected then
                    OpenFrequencyMenu()

                    for k, v in ipairs(dropdown:GetChildren()) do v.Selected = false end
                    this.Selected = true
                    rp_RefreshContextMenu()
                end
            end)

            option.Selected = false

            option.Paint = function(this, w, h)
                local baseColor, textColor = rpui_GetPaintStyle(this, STYLE_TRANSPARENT_SELECTABLE)
                surface_SetDrawColor(baseColor)
                surface_DrawRect(0, 0, w, h)
                draw_SimpleText(this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                return true
            end
        end

        local frequency = LocalPlayer():GetNetVar("RC_RadioFrequency")
        local ply_chan = LocalPlayer():GetNetVar("RC_RadioChannel")

        if frequency then
            option = dropdown:AddOption(translates_Get("Частота %s", frequency * 0.1), function(this)
                if not this.Selected then
                    net_Start("RC_SwitchFrequency")
                        net_WriteUInt(frequency, 14)
                    net_SendToServer()

                    for k, v in ipairs(dropdown:GetChildren()) do v.Selected = false end
                    this.Selected = true
                    rp_RefreshContextMenu()
                end
            end)

            option.Selected = ply_chan == 0

            option.Paint = function(this, w, h)
                local baseColor, textColor = rpui_GetPaintStyle(this, STYLE_TRANSPARENT_SELECTABLE)
                surface_SetDrawColor(baseColor)
                surface_DrawRect(0, 0, w, h)
                draw_SimpleText(this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                return true
            end
        end

        for chan_id, teams in pairs(speakers[LocalPlayer():Team()] or {}) do
            option = dropdown:AddOption(channels_map[chan_id], function(this)
                if not this.Selected then
                    net_Start("RC_SwitchChannel")
                        net_WriteUInt(chan_id, 4)
                    net_SendToServer()

                    for k, v in ipairs(dropdown:GetChildren()) do v.Selected = false end
                    this.Selected = true

                    rp_RefreshContextMenu()
                end
            end)

            option.Selected = chan_id == ply_chan

            option.Paint = function(this, w, h)
                local baseColor, textColor = rpui_GetPaintStyle(this, STYLE_TRANSPARENT_SELECTABLE)
                surface_SetDrawColor(baseColor)
                surface_DrawRect(0, 0, w, h)
                draw_SimpleText(this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                return true
            end
        end

        dropdown:Open()
    end, radioCanUse, "cmenu/chat")

    net_Receive("RC_RadioSync", function(_, ply)
        btn_state = {
            Hear = (rp.IsRadioReceiving() and 1) or 2,
            Speak = (rp.IsRadioTransmiting() and 1) or 2
        }
        radioMixContext()
    end)
end
