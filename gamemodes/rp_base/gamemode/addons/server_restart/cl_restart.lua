local time_to_min = {
    [5] = "минут",
    [4] = "минуты",
    [3] = "минуты",
    [2] = "минуты",
    [1] = "минуту"
}

surface.CreateFont("RestartNotify", {
    font = "Montserrat",
    size = 24,
    weight = 800,
    extended  = true
})

local col_r, col_w = Color(255, 0, 0), Color(255, 255, 255)
function URFNotify(...)
    chat.AddText(col_r, "[URF] ", col_w, ...)
end

net.Receive("server_restart", function()
    local minutes = net.ReadUInt(3)
    local txt = translates.Get("Авто-рестарт через %s %s!", minutes, translates.Get(time_to_min[math.Clamp(minutes, 1, 5)]))

    URFNotify(txt .. translates.Get(" Ваша профессия и предметы будут сохраненны!"))

    local pnl = vgui.Create("urf.im/rpui/menus/blank")
    pnl:SetSize(350, 100)
    pnl:SetPos(ScrW(), 0)
    pnl:MoveTo(ScrW() - pnl:GetWide(), 0, 0.25)
    pnl.header.btn:SetVisible(false)

    pnl.header:SetIcon("rpui/misc/alarm.png")
    pnl.header:SetTitle( translates.Get("Уведомление о рестарте") )
    pnl.header:SetFont("rpui.playerselect.title")
    pnl.header.IcoSizeMult = 1.35
    pnl.header.Colors.Inside = Color(0, 0, 0)

    local white = Color(255, 255, 255)
    pnl.PaintOver = function(me, w, h)
        local headerH = me.header:GetTall()
        local y = h - headerH
        y = h - y*0.5
        draw.SimpleText(txt, "RestartNotify", w*0.5, y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    timer.Simple(10, function()
        if not IsValid(pnl) then return end
        pnl:MoveTo(ScrW() - pnl:GetWide(), -pnl:GetTall(), 0.2, 0, -1, function()
            if not IsValid(pnl) then return end
            pnl:Remove()
        end)
    end)
end)

-----------------------------------------

local NextReTry = false
local IsCrashed = false
local ReconnectTime = 0
local Crash_Frame

local color_red = Color(255,0,0)
local color_black = Color(0,0,0)

local function StartAutoconect()
    ReconnectTime = CurTime() + 65

    if IsValid(Crash_Frame) then Crash_Frame:Remove() end

    Crash_Frame = vgui.Create("urf.im/rpui/menus/blank")
    local pnl = Crash_Frame
    pnl:SetSize(350, 100)
    pnl:SetPos(ScrW() - pnl:GetWide(), 0)
    pnl.header.btn:SetVisible(false)

    pnl.header:SetIcon("rpui/misc/alarm.png")
    pnl.header:SetTitle( translates.Get("Сервер не отвечает") )
    pnl.header:SetFont("rpui.playerselect.title")
    pnl.header.IcoSizeMult = 1.35
    pnl.header.FlashCol = color_black

    local reconnect_text = translates and translates.Get('Восстановление соединения') or 'Восстановление соединения'
    local reconnect_text2 = translates and translates.Get('через ') or 'через '
    local sec = translates and translates.Get(' сек') or ' сек'

    local white = Color(255, 255, 255)
    pnl.PaintOver = function(me, w, h)
        local delta = math.Clamp(ReconnectTime - CurTime(), 1, 40)

        local headerH = me.header:GetTall()
        local y = h - headerH
        y = h - y*0.5
        
        draw.SimpleText(reconnect_text, "RestartNotify", w*0.5, y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(reconnect_text2 .. math.ceil(delta) .. sec, "RestartNotify", w*0.5, y, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        me.header.FlashCol = (delta % 1 < 0.2 and color_red or color_black)
    end

    function pnl.header:Paint(w, h)
        surface.SetDrawColor(self.Colors.Background)
        surface.DrawRect(0, 0, w, h)

        if self.prev_btn.IsVisible(self.prev_btn) then
            if self.PreviousTitle then
                local pos_x = self.prev_btn.GetPos(self.prev_btn)
                draw.SimpleText(self.PreviousTitle, self.Font or "DermaDefault", pos_x + self.prev_btn.GetWide(self.prev_btn) + h/3, (h*0.5) + (self.TitleYOffset or 0), self.Colors.Inside, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            return
        end

        if self.NoDrawInfo then return end

        -- Icon
        surface.SetDrawColor(self.Colors.Inside)
        surface.SetMaterial(self.Icon)
        local h_3 = h/3 * (self.IcoSizeMult or 1)
        local offset_ = (h - h_3)*0.5
        surface.DrawTexturedRect(offset_ + 10, offset_ + 1, h_3, h_3)
        -- Title
        draw.SimpleText(utf8.upper(self.Title), self.Font or "DermaDefault", h_3 + 10 + h/3 + h/6, (h*0.5) + (self.TitleYOffset or 0) + 1, self.FlashCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

net.Receive('_AntiCrash', function()
    NextReTry = CurTime() + 10
    IsCrashed = false
    if IsValid(Crash_Frame) then
        Crash_Frame:Remove()
    end
end)

hook.Add('InitPostEntity', 'AntiCrash.InitPostEntity', function()
        RunConsoleCommand('cl_timeout', 9999)
    end)

hook.Add("HUDPaint", "AntiCrash.W8", function()
    hook.Remove("HUDPaint", "AntiCrash.W8")
    NextReTry = CurTime() + 10

    hook.Add('Think', 'AntiCrash.Think', function()
        if NextReTry and (not IsCrashed) and (NextReTry < CurTime()) then
            IsCrashed = true
            StartAutoconect()
        elseif IsCrashed and (ReconnectTime <= CurTime()) then
            RunConsoleCommand('retry')
        end
    end)
end)