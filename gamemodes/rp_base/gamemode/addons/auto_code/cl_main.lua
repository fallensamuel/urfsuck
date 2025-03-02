include("sh_main.lua")

local color = {
    background = Color(0, 0, 0, 89.25),
    selectedBase = Color(255, 255, 255, 255),
    selectedText = Color(0, 0, 0, 255)
}

surface.CreateFont("rpui.whitelist.title", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 24
})

surface.CreateFont("rpui.whitelist.button", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 18
})

surface.CreateFont("rpui.whitelist.button.small", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 16
})

surface.CreateFont("rpui.whitelist.count", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 18,
    weight = 600
})

surface.CreateFont("rpui.whitelist.searchbar", {
    font = "Montserrat",
    extended = true,
    antialias = true,
    size = 16,
    weight = 600
})

local PANEL = {}

function PANEL:Init()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)
    self.Header = vgui.Create("urf.im/rpui/header", self)
    self.Header.IcoSizeMult = 1.5
    self.Header:SetIcon("shop/filters/list.png")
    self.Header:SetTitle("WHITELIST")
    self.Header:SetFont("rpui.whitelist.title")
    self.MainContainer = vgui.Create("Panel", self)
    self.MainContainer:DockMargin(5, 5, 5, 5)
    self.Scroll = vgui.Create("rpui.ScrollPanel", self.MainContainer)
    self.Scroll:Dock(FILL)
    self.Scroll:SetSpacingY(0)
    self.Scroll:SetScrollbarMargin(0)

    self.Scroll.OnMouseWheeled = function(this, dt)
        this.ySpeed = this.ySpeed + dt * 2
    end

    self.Scroll:InvalidateParent(true)
    self.Scroll:AlwaysLayout(true)
end

function PANEL:SetTeams(teams)
    self.AllowedTeams = teams
end

function PANEL:DrawFactions()
    self.factions = {}
    self.faction_counts = {}
    local title = IsEntity(self.Player) and self.Player:IsPlayer() and self.Player:Name()
    if not title then
        self.BySID = self.Player
        title = self.Player or "???"
    end
    self.Header:SetTitle("WHITELIST - " .. title)
    self.Scroll:ClearItems()

    for k, v in pairs(rp.teams) do
        if v.command and v.faction and v.whitelisted then
            if self.AllowedTeams[v.team] then
                self.faction_counts[v.faction] = (self.faction_counts[v.faction] or 0) + 1
            end

            if not self.factions[v.faction] then
                self.factions[v.faction] = {}
                local pnl = vgui.Create('DButton')
                pnl:SetSize(50, 50)
                pnl:SetFont('rpui.whitelist.button')
                pnl:SetText(rp.Factions[v.faction].printName)
                pnl:Dock(TOP)
                pnl:DockMargin(5, 2.5, 5, 2.5)
                local fcolor = rp.Factions[v.faction].color or color.selectedText
                local baseColor, textColor, invGrayscale, grayscaleClamp, animspeed

                pnl.DoClick = function()
                    self:OpenFaction(v.faction)
                end

                pnl.Paint = function(this, w, h)
                    animspeed = 768 * FrameTime()
                    this._grayscale = math.Approach(this._grayscale or 0, (this:IsHovered() and 255 or 0) * (this:GetDisabled() and 0 or 1), animspeed)
                    this._alpha = math.Approach(this._alpha or 0, (this:IsHovered() and (this:GetDisabled() and 146 or 255) or 146), animspeed)
                    invGrayscale = 255 - this._grayscale
                    grayscaleClamp = this._grayscale / 255
                    baseColor = Color(fcolor.r + (255 - fcolor.r) * grayscaleClamp, fcolor.g + (255 - fcolor.g) * grayscaleClamp, fcolor.b + (255 - fcolor.b) * grayscaleClamp, this._alpha)
                    textColor = Color(invGrayscale, invGrayscale, invGrayscale, this:GetDisabled() and 78 or 255)
                    surface.SetDrawColor(baseColor)
                    surface.DrawRect(0, 0, w, h)
                    draw.SimpleText(this:GetText(), this:GetFont(), w * 0.025, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    if self.faction_counts[v.faction] and self.faction_counts[v.faction] > 0 then
                        surface.SetDrawColor(color.selectedBase)
                        surface.DrawRect(w - h * 0.7, h * 0.3, h * 0.4, h * 0.4)
                        draw.SimpleText(self.faction_counts[v.faction], 'rpui.whitelist.count', w - h * 0.5, h * 0.5, color.selectedText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end

                    return true
                end

                self.Scroll:AddItem(pnl)
            end

            self.factions[v.faction][v.team] = true
        end
    end

    timer.Simple(0, function()
        self.Scroll:InvalidateLayout()
    end)
end

function PANEL:OpenFaction(faction)
    self.Header:SetTitle("WHITELIST - " .. rp.Factions[faction].printName)
    self.Scroll:ClearItems()
    local baseColor, textColor, ft, bs, a, v
    local pnl = vgui.Create('DButton')
    pnl:SetSize(50, 50)
    pnl:SetFont('rpui.whitelist.button')
    pnl:SetText('ВЕРНУТЬСЯ')
    pnl:Dock(TOP)
    pnl:DockMargin(5, 2.5, 5, 2.5)

    pnl.DoClick = function()
        self:DrawFactions()
    end

    pnl.Paint = function(this, w, h)
        if IsValid(self.Blocked) and not this:GetDisabled() then
            this:SetDisabled(true)
        elseif not IsValid(self.Blocked) and this:GetDisabled() then
            this:SetDisabled(false)
        end

        baseColor, textColor = rpui.GetPaintStyle(this, STYLE_TRANSPARENT_INVERTED)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText(this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end

    self.Scroll:AddItem(pnl)

    for t, _ in pairs(self.factions[faction]) do
        v = rp.teams[t]

        if v.command and v.whitelisted then
            pnl = vgui.Create('DButton')
            pnl:SetSize(50, 50)
            pnl:SetFont('rpui.whitelist.button')
            pnl:SetText(team.GetName(v.team))
            pnl:Dock(TOP)
            pnl:DockMargin(5, 2.5, 5, 2.5)
            pnl.text_baked = string.Wrap('rpui.whitelist.button', team.GetName(v.team), 300)

            if self.AllowedTeams[t] then
                pnl.State = true
            end

            pnl.DoClick = function(this)
                if self.BySID or IsValid(self.Player) then
                    net.Start('Whitelist::ChangeAccess')
                        net.WriteString(self.BySID or self.Player:SteamID64())
                        net.WriteUInt(t, 10)
                    net.SendToServer()
                    self.Blocked = this
                    self.AllowedTeams[t] = not self.AllowedTeams[t]
                else
                    self:Close()
                    rp.Notify(NOTIFY_GENERIC, 'Игрок уже покинул сервер.')
                end
            end

            local lines_count = #pnl.text_baked

            pnl.Paint = function(this, w, h)
                if IsValid(self.Blocked) and not this:GetDisabled() then
                    this:SetDisabled(true)
                elseif not IsValid(self.Blocked) and this:GetDisabled() then
                    this:SetDisabled(false)
                end

                baseColor, textColor = rpui.GetPaintStyle(this, STYLE_TRANSPARENT_INVERTED)
                surface.SetDrawColor(baseColor)
                surface.DrawRect(0, 0, w, h)

                --draw.SimpleText( this:GetText(), this:GetFont(), w * 0.1, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                for i, j in pairs(this.text_baked) do
                    draw.SimpleText(j, this:GetFont(), w * 0.025, h * (0.5 + (i - lines_count / 2 - 0.5) * 0.28), textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                ft = FrameTime()
                this.BaseAlpha1 = math.Approach(this.BaseAlpha1 or 0, this.State and 1 or 0, ft * 4)
                this.HoveredAlpha1 = math.Approach(this.HoveredAlpha1 or 0, (this.State or this:IsHovered()) and 1 or 0, ft * 4)

                if this.BaseAlpha1 < 1 then
                    surface.SetDrawColor(rpui.UIColors.Background)
                    surface.DrawRect(w - h, h * 0.25, h * 0.5, h * 0.5)
                    bs = rpui.PowOfTwo(h * 0.05)
                    surface.SetDrawColor(Color(255, 255, 255, 8 + this.HoveredAlpha1 * 247))
                    surface.DrawRect(w - h, h * 0.25, h * 0.5, bs)
                    surface.DrawRect(w - h, h * 0.75 - bs, h * 0.5, bs)
                    surface.DrawRect(w - h, h * 0.25 + bs, bs, h * 0.5 - bs * 2)
                    surface.DrawRect(w - h * 0.5 - bs, h * 0.25 + bs, bs, h * 0.5 - bs * 2)
                end

                if this.BaseAlpha1 > 0 then
                    a = this.BaseAlpha1 * 255
                    surface.SetDrawColor(Color(255, 255, 255, a))
                    surface.DrawRect(w - h, h * 0.25, h * 0.5, h * 0.5)
                    draw.SimpleText('✔', "rpui.whitelist.count", w - h * 0.75, h * 0.5, Color(0, 0, 0, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end

                return true
            end

            self.Scroll:AddItem(pnl)
        end
    end

    timer.Simple(0, function()
        self.Scroll:InvalidateLayout()
    end)
end

local string_StartWith, strlower, table_insert = string.StartWith, string.utfnotutflower, table.insert

function PANEL:OnSearch(new)
    if not new then return end

    if new == "" then
        local i = 1

        for k, ply in pairs(player.GetAll()) do
            local pnl = self.scroll_items[ply]

            if IsValid(pnl) then
                i = i + 1
                pnl:Show()
                pnl:SetZPos(i)
            end
        end

        return
    end

    new = string.utfnotutflower(new) or ""
    local items = {}

    for ply, pnl in pairs(self.scroll_items) do
        if pnl.AlwaysShow or not IsValid(ply) or not IsValid(pnl) then continue end

        if string.StartWith(string.utfnotutflower(ply:Nick() or ""), new) or string.StartWith(string.utfnotutflower(ply:SteamID() or ""), new) or string.StartWith(string.utfnotutflower(ply:SteamID64() or ""), new) then
            pnl:Show()
            table.insert(items, ply)
        else
            pnl:Hide()
        end
    end

    if items ~= {} then
        local i = 0

        for k, ply in pairs(items) do
            local pnl = self.scroll_items[ply]

            if IsValid(pnl) then
                i = i + 1
                pnl:SetZPos(i)
            end
        end
    end

    self.Scroll:InvalidateLayout()
end

local selected_player, selectedsteamid

function PANEL:DrawPlayers()
    self.Header:SetTitle("WHITELIST - ИГРОКИ")
    self.Scroll:ClearItems()
    self.scroll_items = {}
    self.search = vgui.Create("urf.im/rpui/txtinput", self)
    local search = self.search
    search:SetFont('rpui.whitelist.searchbar')
    search:SetPlaceholderText("Введите имя игрока")
    search.UID = "playerselect"
    search:ApplyDesign()

    search.OnChange = function()
        self:OnSearch(search:GetValue())
    end

    search:SetPos(9, 55)
    search:SetSize(432, 30)

    local pnl = vgui.Create('DButton')
    pnl.AlwaysShow = true
    pnl:SetSize(50, 50)
    pnl:SetFont('rpui.whitelist.button')
    pnl:SetText(translates.Get("НАЙТИ ОФФЛАЙН ИГРОКА"))
    pnl:Dock(TOP)
    pnl:DockMargin(5, 2.5, 5, 2.5)
    pnl.DoClick = function()
        self:AlphaTo(50, 0.3)
        rpui.StringRequest(translates.Get("НАЙТИ ОФФЛАЙН ИГРОКА"), translates.Get("Введите steamid64 или steamid32:"), "shop/filters/list.png", 1.4, function(me, str)
            if IsValid(self) then self:AlphaTo(255, 0.3) end

            selectedsteamid = str
            rp.Notify(NOTIFY_GENERIC, "Загрузка данных игрока...")
            net.Start("Whitelist::IDInfo")
                net.WriteString(str)
            net.SendToServer()
        end, function(me)
            if IsValid(self) then self:AlphaTo(255, 0.3) end
        end)
    end
    pnl.Paint = function(this, w, h)
        if IsValid(self.Blocked) and not this:GetDisabled() then
            this:SetDisabled(true)
        elseif not IsValid(self.Blocked) and this:GetDisabled() then
            this:SetDisabled(false)
        end

        local baseColor, textColor = rpui.GetPaintStyle(this, STYLE_TRANSPARENT_INVERTED)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)
            
        draw.SimpleText(this:GetText(), this:GetFont(), w*0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        return true
    end

    self.Scroll:AddItem(pnl)

    for k, v in pairs(player.GetAll()) do
        if not IsValid(v) then continue end
        local pnl = vgui.Create('DButton')
        pnl:SetSize(50, 50)
        pnl:SetFont('rpui.whitelist.button')
        pnl:SetText(v:Name())
        pnl:Dock(TOP)
        pnl:DockMargin(5, 2.5, 5, 2.5)

        pnl.DoClick = function()
            if not IsValid(v) then
                v:Remove()

                timer.Simple(0, function()
                    self.Scroll:InvalidateLayout()
                end)

                return
            end

            selectedsteamid = nil
            selected_player = v
            rp.Notify(NOTIFY_GENERIC, 'Загрузка данных игрока...')
            net.Start('Whitelist::PlayerInfo')
            net.WriteEntity(v)
            net.SendToServer()
            self:Close()
        end

        self.scroll_items[v] = pnl
        pnl.Avatar = vgui.Create("AvatarImage", pnl)
        pnl.Avatar:SetPos(2, 2)
        pnl.Avatar:SetSize(46, 46)
        pnl.Avatar:SetPlayer(v, 64)

       	pnl.SteamID = v:SteamID()
       	if pnl.SteamID == "NULL" then
       		pnl.SteamID = ""
       	end
        pnl.TxtSize = {
            { 0, 0 },
            { 0, 0 }
        }
        pnl.Paint = function(this, w, h)
            if IsValid(self.Blocked) and not this:GetDisabled() then
                this:SetDisabled(true)
            elseif not IsValid(self.Blocked) and this:GetDisabled() then
                this:SetDisabled(false)
            end

            local baseColor, textColor = rpui.GetPaintStyle(this, STYLE_TRANSPARENT_INVERTED)
            surface.SetDrawColor(baseColor)
            surface.DrawRect(0, 0, w, h)
            
            this.TxtSize[1] = {
                draw.SimpleText(this:GetText(), this:GetFont(), h * 1.2, h*0.5 - this.TxtSize[1][2]*0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            }
            this.TxtSize[2] = {
                draw.SimpleText(this.SteamID, "rpui.whitelist.button.small", h * 1.2, h*0.5 + this.TxtSize[2][2]*0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            }

            return true
        end

        self.Scroll:AddItem(pnl)
    end

    timer.Simple(0, function()
        self.Scroll:InvalidateLayout()
    end)
end

function PANEL:Unblock()
    if IsValid(self.Blocked) then
        self.Blocked.State = not self.Blocked.State
        self.Blocked = nil
    end
end

function PANEL:Paint(w, h)
    draw.Blur(self)
    surface.SetDrawColor(color.background)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:Close()
    self:AlphaTo(0, 0.2, 0, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

function PANEL:PerformLayout()
    local w, h = self:GetWide(), self:GetTall()
    local htall = 45
    self.Header:SetSize(w, htall)
    self.MainContainer:SetSize(w - 10, h - htall - 15 - (self.scroll_items and 40 or 0))
    self.MainContainer:SetPos(5, htall + 7.5 + (self.scroll_items and 40 or 0))
end

vgui.Register("urf.im/rpui/menus/whitelist", PANEL, "EditablePanel")

local menu

net.Receive('Whitelist::PlayerInfo', function()
    if not IsValid(selected_player) then
        rp.Notify(NOTIFY_GENERIC, "Игрок уже покинул сервер.")
        return
    end

    local count = net.ReadUInt(10)
    local teams = {}

    if count > 0 then
        for k = 1, count do
            teams[net.ReadUInt(10)] = true
        end
    end

    menu = vgui.Create("urf.im/rpui/menus/whitelist")
    menu:SetSize(450, 550)
    menu:Center()
    menu:MakePopup()
    menu.Player = selected_player
    menu:SetTeams(teams)

    timer.Simple(0, function()
        menu:DrawFactions()
    end)
end)

net.Receive("Whitelist::IDInfo", function()
    if not selectedsteamid then return end

    local count = net.ReadUInt(10)
    local teams = {}

    if count > 0 then
        for k = 1, count do
            teams[net.ReadUInt(10)] = true
        end
    end

    menu = vgui.Create("urf.im/rpui/menus/whitelist")
    menu:SetSize(450, 550)
    menu:Center()
    menu:MakePopup()
    menu.Player = selectedsteamid
    menu:SetTeams(teams)

    timer.Simple(0, function()
        menu:DrawFactions()
    end)
end)

net.Receive('Whitelist::ChangeAccess', function()
    if IsValid(menu) then
        menu:Unblock()
    end
end)

local function open_whitelist_menu()
    if not rp.JobsWhitelist.Ranks[LocalPlayer():GetRank()] then return rp.Notify(NOTIFY_ERROR, 'У вас нет доступа к этой команде.') end

    if IsValid(menu) then
        menu:Close()
    else
        --[[
		rpui.PlayerReuqest("WHITELIST", "shop/filters/list.png", 1.5, function(ply)
			if not IsValid(ply) then return end
			
			selected_player = ply
			
			rp.Notify(NOTIFY_GENERIC, 'Loading player data...')
			
			net.Start('Whitelist::PlayerInfo')
			net.WriteEntity(ply)
			net.SendToServer()
		end)
		]]
        menu = vgui.Create("urf.im/rpui/menus/whitelist")
        menu:SetSize(450, 550)
        menu:Center()
        menu:MakePopup()

        timer.Simple(0, function()
            menu:DrawPlayers()
        end)
    end
end

concommand.Add('job_whitelist', open_whitelist_menu)