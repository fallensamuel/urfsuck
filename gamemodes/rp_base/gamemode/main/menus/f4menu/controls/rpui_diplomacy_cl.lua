-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_diplomacy_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
    self.ContentHeight, self.ContentSpacing = 0, 0
    self.Title = vgui.Create("DLabel", self)
    self.Title:Dock(TOP)
    self.Title:SetContentAlignment(5)
    self.Title:SetTextColor(rpui.UIColors.White)

    self.Title.Paint = function(this, w, h)
        surface.SetDrawColor(rpui.UIColors.Black)
        surface.DrawRect(0, 0, w, h)
    end
end

function PANEL:SetContentHeight(height)
    self.ContentHeight = height

    for k, v in pairs(self:GetChildren()) do
        v:SetTall(self.ContentHeight)
    end
end

function PANEL:SetContentSpacing(spacing)
    self.ContentSpacing = spacing

    for k, v in pairs(self:GetChildren()) do
        v:DockMargin(0, 0, 0, self.ContentSpacing)
    end
end

local webdir = "diplomacy/%s"
local iconstab = {
    [translates.Get("Война")]       = "enemic64.png",
    [translates.Get("Союз")]        = "allyic64.png",
    [translates.Get("Нейтралитет")] = "neutic64.png"
}

function PANEL:AddItem(data, callback)
    local AllianceBtn = vgui.Create("DButton", self)
    AllianceBtn:Dock(TOP)
    AllianceBtn:DockMargin(0, 0, 0, self.ContentSpacing)
    AllianceBtn:SetTall(self.ContentHeight)

    AllianceBtn.data = {}
    for key, val in pairs(data) do
        AllianceBtn.data[key] = val
    end

    local wide, tall

    AllianceBtn.Paint = function(this, w, h)
        if not wide or not tall then
            wide, tall = w, h
        end

        local baseColor = rpui.GetPaintStyle(this, STYLE_TRANSPARENT)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(rpui.UIColors.Black)
        surface.DrawRect(0, 0, tall, tall)


        local material = this.data.icon

        if material then
            surface.SetDrawColor(color_white)
            surface.SetMaterial(material)
            local sz = tall*0.5
            local ps = (tall-sz)/2
            surface.DrawTexturedRect(ps, ps, sz, sz)
        end

        draw.SimpleText(this.data.name, "rpui.Fonts.Diplomacy.AllianceBtn", tall + self.ContentSpacing, tall * 0.1, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        local tw = draw.SimpleText(this.data.about_status, "rpui.Fonts.Diplomacy.Status", tall + self.ContentSpacing, tall * 0.95, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        draw.SimpleText(this.data.status, "rpui.Fonts.Diplomacy.Status", tall + self.ContentSpacing + tw, tall * 0.95, this.data.statuscolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        return true
    end

    AllianceBtn.DoClick = callback
    AllianceBtn:InvalidateParent(true)
    self:InvalidateLayout(true)
    self:SizeToChildren(false, true)

    return AllianceBtn
end

vgui.Register("rpui._diplomacycategory", PANEL, "Panel")
local PANEL = {}

function PANEL:RebuildFonts(frameW, frameH)
    surface.CreateFont("rpui.Fonts.Diplomacy.CategoryTitle", {
        font = "Montserrat",
        extended = true,
        weight = 600,
        size = frameH * 0.035
    })

    surface.CreateFont("rpui.Fonts.Diplomacy.AllianceBtn", {
        font = "Montserrat",
        extended = true,
        weight = 535,
        size = frameH * 0.032
    })

    surface.CreateFont("rpui.Fonts.Diplomacy.Status", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.0225
    })

    surface.CreateFont("rpui.Fonts.Diplomacy.SmallDesc", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = frameH * 0.0175
    })
end

function PANEL:SetSpacing(spacing)
    self.Container:SetSpacingX(spacing)
    self.Container:SetSpacingY(spacing)
    self:SetScrollbarMargin(spacing * 0.8)

    for _, category in pairs(self.Container.Categories) do
        category:SetContentSpacing(spacing)
        category:InvalidateLayout(true)
        category:SizeToChildren(false, true)
    end
end

function PANEL:SetAlliance(alliance)
    self.alliance = alliance

    local allc = rp.Capture.Alliances[alliance]
    if not allc then return end
    
    local scr_scale = ScrH()/1080

    for _, pnl in pairs(self.Container.Categories["fractions"].PnlTab) do
        if IsValid(pnl) then
            pnl:Remove()
        end
    end
    self.Container.Categories["fractions"].PnlTab = {}

    for key, v in ipairs(rp.Capture.Alliances) do
        if key == alliance then continue end
            local state = rp.ConjGet(key, alliance)

            local data = {}
            data.alliancekey = key
            data.state = rp.ConjGet(key, alliance)
            data.name = v.printName
            data.about_status = translates.Get("ТЕКУЩЕЕ ОТНОШЕНИЕ") .. ": "
            data.status = rp.ConjGetName(data.state)
            data.statuscolor = rp.ConjGetColor(data.state) 
            data.icon = Material("diplomacy/"..iconstab[data.status], "smooth", "noclamp")

        local that_item = self.Container.Categories["fractions"]:AddItem(data, function(that)
            local new_sz = that.IsOpened and self.ContentHeight or self.ContentHeight*1.75
            that.IsOpened = not that.IsOpened

            self.PaintOver = function()
                that:InvalidateParent(true)
                self.Container.Categories["fractions"]:InvalidateLayout(true)
                self.Container.Categories["fractions"]:SizeToChildren(false, true)   
            end

            that:SizeTo(that:GetWide(), new_sz, 0.25, 0, -1, function()
                self.PaintOver = function() end

                if that.IsOpened then return end

                if IsValid(that.btn) then that.btn:Remove() end
                if IsValid(that.btn2) then that.btn2:Remove() end
            end)

            if that.IsOpened then
                if IsValid(that.btn) then
                    that.btn:Remove()
                end
                that.btn = vgui.Create("DButton", that)
                that.btn:SetFont("rpui.Fonts.Diplomacy.Status")
                that.btn:SetTextColor(color_white)
                that.btn:SetText(translates.Get("Просмотреть отношения"))
                that.btn:SizeToContents()
                that.btn.Paint = function(this, w, h)
                    local baseColor = rpui.GetPaintStyle(this, STYLE_SOLID)
                    surface.SetDrawColor(baseColor)
                    surface.DrawRect(0, 0, w, h)
                    this:SetTextColor(this:IsHovered() and rpui.UIColors.Black or rpui.UIColors.White)
                end
                that.btn.DoClick = function()
                    if (self.NetAllianceChange or 0) > CurTime() then return end
                    self.NetAllianceChange = CurTime() + 0.2

                    self:SetAlliance(that.data.alliancekey)
                    self.F4Menu:SetHeaderTitle(translates.Get("Отношения") .. " "..rp.Capture.Alliances[self.alliance].printName..(self.alliance == LocalPlayer():GetAlliance() and " (" .. translates.Get("ВЫ") .. ")" or ""))
                end

                if LocalPlayer():GetAlliance() == alliance and LocalPlayer():GetJobTable().canDiplomacy then
                    if IsValid(that.btn2) then
                        that.btn2:Remove()
                    end
                    that.btn2 = vgui.Create("DButton", that)
                    that.btn2:SetFont("rpui.Fonts.Diplomacy.Status")
                    that.btn2:SetTextColor(color_white)
                    that.btn2:SetText(translates.Get("Изменить отношения"))
                    that.btn2:SizeToContents()
                    that.btn2.Paint = function(this, w, h)
                        local baseColor = rpui.GetPaintStyle(this, STYLE_SOLID)
                        surface.SetDrawColor(baseColor)
                        surface.DrawRect(0, 0, w, h)
                        this:SetTextColor(this:IsHovered() and rpui.UIColors.Black or rpui.UIColors.White)
                    end
                    that.btn2.DoClick = function(this)
                        local m = vgui.Create("rpui.DropMenu", this)
                        m:SetBase(this)
                        m:SetFont("Context.DermaMenu.Label")
                        m:SetSpacing(ScrH() * 0.01)
                        m.Paint = function(this, w, h) draw.Blur(this) end

                        local state = rp.ConjGet(key, LocalPlayer():GetAlliance())
                        local valid_states = (state == CONJ_NEUTRAL) and {CONJ_WAR, CONJ_UNION} or {CONJ_NEUTRAL}

                        for key2, val in ipairs(valid_states) do
                            if not rp.ConjIsInvalid(v, LocalPlayer():GetAlliance(), val) then
                                local option = m:AddOption(rp.ConjGetName(val), function()
                                    rp.RunCommand('conjunction', key, val)
                                end)
                                option.Paint = function( this, w, h )
                                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                                    surface.SetDrawColor( baseColor );
                                    surface.DrawRect( 0, 0, w, h );
                                    draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                                    return true
                                end
                            end
                        end
						
                        m:Open()
                    end

                    local allwide = that.btn:GetWide() + that.btn2:GetWide()

                    that.btn2:SetPos(that:GetWide()/2 - allwide/2 - 4*scr_scale, new_sz - that.btn2:GetTall() - 8*scr_scale)
                    local btn2_xpos = that.btn2:GetPos()
                    that.btn:SetPos(btn2_xpos + that.btn2:GetWide() + 8*scr_scale, new_sz - that.btn:GetTall() - 8*scr_scale)
                else
                    that.btn:SetPos(that:GetWide()/2 - that.btn:GetWide()/2, new_sz - that.btn:GetTall() - 8*scr_scale)
                end
            end
        end)
        table.insert(self.Container.Categories["fractions"].PnlTab, that_item)
    end

    self:AddCapturePoints(alliance)
end

function PANEL:AddCapturePoints(alliance)
    local scr_scale = ScrH()/1080
	
	for key, val in pairs(rp.Capture.Points) do
        local data = {}
        data.name = val.printName
        --data.icon = val.icon
        data.owner = val.owner
        data.about_status = translates.Get("ВЛАДЕЛЕЦ") .. ": "
        data.status = isnumber(data.owner) and (rp.Capture.Alliances[data.owner] and rp.Capture.Alliances[data.owner].printName or 'Unknown') or data.owner
        data.statuscolor = Color(225, 225, 225)

        local state = rp.ConjGet(data.owner, alliance)
        local status = rp.ConjGetName(state)
        data.icon = Material("diplomacy/"..iconstab[status], "smooth", "noclamp")

        local that_item = self.Container.Categories["territories"]:AddItem(data, function(that)
            local new_sz = that.IsOpened and self.ContentHeight or self.ContentHeight*1.75
            that.IsOpened = not that.IsOpened

            if that.IsOpened then
                if IsValid(that.lbl) then that.lbl:Remove() end
                that.lbl = vgui.Create("DLabel", that)
                that.lbl:SetMultiline(true)
                that.lbl:SetWrap(true)
                that.lbl:SetFont("rpui.Fonts.Diplomacy.SmallDesc")
                that.lbl:SetText(rp.Capture.GetPointBonuses(val))

                surface.SetFont(that.lbl:GetFont())
                local szx, szy = surface.GetTextSize(that.lbl:GetText())

                that.lbl:SetSize(that:GetWide()*0.7, szy*2)
                that.lbl:SetPos(6*scr_scale, self.ContentHeight + 8*scr_scale)

                if LocalPlayer():GetJobTable().canDiplomacy then
                    if (val.isOrg and not val.isWar and LocalPlayer():GetOrg() == val.owner and LocalPlayer():GetOrgData().CanDiplomacy) or LocalPlayer():GetAlliance() == val.owner then
                        if IsValid(that.btn) then that.btn:Remove() end
                        that.btn = vgui.Create("DButton", that)
                        that.btn:SetFont("rpui.Fonts.Diplomacy.Status")
                        that.btn:SetTextColor(color_white)
                        that.btn:SetText(translates.Get("Передать"))
                        that.btn:SizeToContents()
                        that.btn:SetWide(that.btn:GetWide()*1.2)
                        that.btn:SetPos(that:GetWide() - that.btn:GetWide() - 8*scr_scale, new_sz - that.btn:GetTall() - 8*scr_scale)
                        that.btn.Paint = function(this, w, h)
                            local baseColor = rpui.GetPaintStyle(this, STYLE_SOLID)
                            surface.SetDrawColor(baseColor)
                            surface.DrawRect(0, 0, w, h)
                            this:SetTextColor(this:IsHovered() and rpui.UIColors.Black or rpui.UIColors.White)
                        end
                        that.btn.DoClick = function(this)
                            if IsValid(this.menu) then this.menu:Remove() end

                            local mn = vgui.Create("rpui.DropMenu", this)
                            this.menu = mn
                            mn:SetBase(this)
                            mn:SetFont("Context.DermaMenu.Label")
                            mn:SetSpacing(ScrH() * 0.01)
                            mn.Paint = function(this, w, h) draw.Blur(this) end

                            local allys = rp.Capture.Alliances
                            if LocalPlayer():GetAlliance() then
                                allys[LocalPlayer():GetAlliance()] = nil
                            end

                            local orgs = {}

                            if LocalPlayer():GetOrg() then
                                for _, v in pairs(player.GetAll()) do
                                    if v:GetOrg() and v:GetOrg() ~= LocalPlayer():GetOrg() then
                                        orgs[#orgs + 1] = v:GetOrg()
                                    end
                                end
                            end

                            for kk, v in pairs(val.isOrg and orgs or allys) do

                                local option = mn:AddOption(val.isOrg and v or v.printName, function()
                                    rp.RunCommand('givepoint', val.id, kk)
                                    self:SetAlliance(alliance)
                                end)

                                option.Paint = function( this, w, h )
                                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                                    surface.SetDrawColor( baseColor );
                                    surface.DrawRect( 0, 0, w, h );
                                    draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                                    return true
                                end
                            end

                            mn:Open()
                        end
                    end
                end
            end    

            self.PaintOver = function()
                that:InvalidateParent(true)
                self.Container.Categories["territories"]:InvalidateLayout(true)
                self.Container.Categories["territories"]:SizeToChildren(false, true)   
            end

            that:SizeTo(that:GetWide(), new_sz, 0.25, 0, -1, function()
                self.PaintOver = function() end

                if that.IsOpened then return end
                if IsValid(that.lbl) then that.lbl:Remove() end
                if IsValid(that.btn) then that.btn:Remove() end
            end)
        end)

        table.insert(self.Container.Categories["fractions"].PnlTab, that_item)
    end
end

function PANEL:Init()
    self.Parent = self:GetParent()
    self.frameW, self.frameH = self.Parent:GetSize()
    self.ContentHeight = self.frameH * 0.065
    self:Dock(FILL)
    self:SetScrollbarWidth(self.frameH * 0.0085)
    self:RebuildFonts(self.frameW, self.frameH)
    self.Container = vgui.Create("rpui.ColumnView")
    self.Container:Dock(TOP)
    self.Container:SetColumns(2)
    self.Container:SetAutoAlignToLower(true)
    self.Container.Categories = {}
    self:AddItem(self.Container)

    self.Container.Categories["fractions"] = vgui.Create("rpui._diplomacycategory")
    self.Container.Categories["fractions"]:Dock(TOP)
    self.Container.Categories["fractions"].Title:SetFont("rpui.Fonts.Diplomacy.CategoryTitle")
    self.Container.Categories["fractions"].Title:SetText(translates.Get("ФРАКЦИИ"))
    self.Container.Categories["fractions"]:SetContentHeight(self.ContentHeight)
    self.Container.Categories["fractions"].PnlTab = {}
    self.Container:AddItem(self.Container.Categories["fractions"])

    self.Container.Categories["territories"] = vgui.Create("rpui._diplomacycategory")
    self.Container.Categories["territories"]:Dock(TOP)
    self.Container.Categories["territories"].Title:SetFont("rpui.Fonts.Diplomacy.CategoryTitle")
    self.Container.Categories["territories"].Title:SetText(translates.Get("ТЕРРИТОРИИ"))
    self.Container.Categories["territories"]:SetContentHeight(self.ContentHeight)
    self.Container:AddItem(self.Container.Categories["territories"])

    local alliance = LocalPlayer():GetAlliance()
    if not alliance then
        alliance = table.Random(rp.Capture.Alliances)
        for key, val in pairs(rp.Capture.Alliances) do
            if alliance == val then
                alliance = key
            end
        end
    end

    self:SetAlliance(alliance)
end

function PANEL:OnTabOpened()
    if IsValid(self.F4Menu) and self.alliance and rp.Capture.Alliances and rp.Capture.Alliances[self.alliance] then
        self.F4Menu:SetHeaderTitle(translates.Get("Отношения") .. " "..rp.Capture.Alliances[self.alliance].printName..(self.alliance == LocalPlayer():GetAlliance() and " (" .. translates.Get("ВЫ") .. ")" or ""))
    end
end

vgui.Register("rpui.Diplomacy", PANEL, "rpui.ScrollPanel")