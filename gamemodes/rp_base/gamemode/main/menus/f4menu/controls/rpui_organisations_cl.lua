-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_organisations_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};


function PANEL:SetSpacing( spacing )
    self.frameSpacing = spacing;
end


function PANEL:Init()
    self.Parent       = self:GetParent();
    self.frameSpacing = 0;

    self:Dock( FILL );
    self:InvalidateParent( true );

    net.Receive( "rp.OrgsMenu", function()
        if not IsValid(self) then
            return
        end

        self.OrgData = LocalPlayer():GetOrgData();
        self.Rank    = self.OrgData.Rank;
        self.MoTD    = self.OrgData.MoTD;
        self.Perms   = self.OrgData.Perms;

        self.OrgMembers = {};
        self.OrgRanks   = {};
        self.OrgRankRef = {};

        for i = 1, net.ReadUInt(5) do
            local rankname       = net.ReadString();
            local weight         = net.ReadUInt(7);
            local invite         = net.ReadBool();
            local kick           = net.ReadBool();
            local rank           = net.ReadBool();
            local motd           = net.ReadBool();
            local ccapture       = net.ReadBool();
            local cdiplomacy     = net.ReadBool();
            local cstorage       = net.ReadBool();

            self.OrgRanks[#self.OrgRanks + 1] = {
                Name         = rankname,
                Weight       = weight,
                Invite       = invite,
                Kick         = kick,
                Rank         = rank,
                MoTD         = motd,
                CanCapture   = ccapture,
                CanDiplomacy = cdiplomacy,
                CanStorage   = cstorage
            };

            self.OrgRankRef[rankname] = self.OrgRanks[#self.OrgRanks];
        end
        table.SortByMember( self.OrgRanks, "Weight" );

        for i1 = 1, net.ReadUInt(9) do
            local steamid     = net.ReadString();
            local name         = net.ReadString();
            local rank         = net.ReadString();

            if not self.OrgRankRef[rank] then
                rank = self.OrgRanks[#self.OrgRanks].Name;
            end

            local weight = self.OrgRankRef[rank].Weight;

            self.OrgMembers[#self.OrgMembers + 1] = {
                SteamID    = steamid,
                Name     = name,
                Rank     = rank,
                Weight     = weight
            }
        end
        table.SortByMember( self.OrgMembers, "Weight" );

        self:RebuildPanel();
    end );
end


function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.Orgs.MemberCount", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.0375,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.Quit", {
        font     = "Montserrat",
        extended = true,
        weight = 400,
        size     = frameH * 0.0275,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.QuitSmall", {
        font     = "Montserrat",
        extended = true,
        weight = 400,
        size     = frameH * 0.0225,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.QuitBold", {
        font     = "Montserrat",
        extended = true,
        weight = 800,
        size     = frameH * 0.03,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.QuitButton", {
        font     = "Montserrat",
        extended = true,
        weight = 1000,
        size     = frameH * 0.04,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.Button", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.0325,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.MoTD", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.025,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.Menu", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.03,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.MenuSmall", {
        font     = "Montserrat",
        extended = true,
        weight = 400,
        size     = frameH * 0.025,
    } );

    surface.CreateFont( "rpui.Fonts.Orgs.Check", {
        font     = "Montserrat",
        extended = true,
        weight = 400,
        size     = frameH * 0.02,
    } );
end


function PANEL:Initialize()
    self.frameW, self.frameH = self:GetSize();
    self:RebuildFonts( self.frameW, self.frameH );

    rp.RunCommand( "orgmenu" );
end


function PANEL:OnTabOpened()
    self.F4Menu.SetHeaderTitle( self.F4Menu, string.utf8upper(LocalPlayer():GetOrg() or "") );
end


function PANEL:PopulateMembers( needle )
    self.Header.MemberCount.SetText( self.Header.MemberCount, translates.Get("УЧАСТНИКИ: %s", table.Count(self.OrgMembers)) );

    self.MemberContainer.List.ClearItems(self.MemberContainer.List);
    self.MemberContainer.List.OrgMembers = {};

    local prevRank;
    local members = {};

    if needle and (#string.Trim(needle) ~= 0) then
        for k, v in pairs( self.OrgMembers ) do
            if string.find( v.SteamID, needle ) then
                table.insert( members, v ); continue;
            end

            if string.find( string.utf8lower(v.Name), string.utf8lower(needle) ) then
                table.insert( members, v ); continue;
            end
        end
    else
        members = self.OrgMembers;
    end

    for k, ply in pairs( members ) do
        if prevRank ~= ply.Rank then
            local CategoryPanel = vgui.Create( "DLabel" );
            self.MemberContainer.List.AddItem( self.MemberContainer.List, CategoryPanel );

            CategoryPanel:Dock( TOP );
            CategoryPanel:SetTall( self.frameH * 0.07 );

            surface.CreateFont( "CategoryPanel.Default", {
                font     = "Montserrat",
                weight = 700,
                extended = true,
                size     = CategoryPanel:GetTall() * 0.7,
            } );

            CategoryPanel:SetContentAlignment( 5 );
            CategoryPanel:SetFont( "CategoryPanel.Default" );
            CategoryPanel:SetTextColor( rpui.UIColors.White );
            CategoryPanel:SetText( string.utf8upper(ply.Rank) );

            CategoryPanel.Paint = function( this, w, h )
                surface.SetDrawColor( rpui.UIColors.Black );
                surface.DrawRect( 0, 0, w, h );
            end

            prevRank = ply.Rank;
        end

        local MemberPanel = vgui.Create( "DButton" );
        self.MemberContainer.List.AddItem( self.MemberContainer.List, MemberPanel );
        table.insert( self.MemberContainer.List.OrgMembers, MemberPanel );

        if ply.SteamID == LocalPlayer():SteamID64() then
            MemberPanel:SetMouseInputEnabled( false );
        end

        MemberPanel._alpha = 127;
        MemberPanel.Player = ply;

        MemberPanel.PlayerName = string.utf8upper( ply.Name );
        MemberPanel.PlayerRank = "(" .. string.utf8upper( ply.Rank ) .. ")";

        MemberPanel:Dock( TOP );
        MemberPanel:SetTall( self.frameH * 0.05 );

        surface.CreateFont( "MemberPanel.Medium", {
            font     = "Montserrat",
            extended = true,
            weight   = 600,
            size     = MemberPanel:GetTall() * 0.7,
        } );

        MemberPanel.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this.PlayerName, "MemberPanel.Medium", w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end

        MemberPanel.DoClick = function( this )
            if this.Selected then return end

            for k1, v1 in pairs( self.MemberContainer.List.GetItems(self.MemberContainer.List) ) do
                v1.Selected = false;
            end

            this.Selected = true;
            self.SelectedMember = ply;
        end

        MemberPanel.Avatar = vgui.Create( "AvatarImage", MemberPanel );
        MemberPanel.Avatar.Dock( MemberPanel.Avatar, LEFT );
        MemberPanel.Avatar.SetWide( MemberPanel.Avatar, MemberPanel:GetTall() );
        MemberPanel.Avatar.SetSteamID( MemberPanel.Avatar, ply.SteamID, MemberPanel.Avatar.GetWide(MemberPanel.Avatar) );
    end
end

function PANEL:PopulateRanks()
    if self.SelectedRank then self.SelectedRank = self.SelectedRank.Rank; end

    self.CenterContainer.RankList.ClearItems(self.CenterContainer.RankList);

    table.SortByMember( self.OrgRanks, "Weight" );

    for k2, v2 in ipairs( self.OrgRanks ) do
        local k3         = #self.OrgRanks - (k2 - 1);
        local newWeight = 1 + math.floor( ((k3 - 1) / (#self.OrgRanks - 1)) * 99 );

        v2.Weight = newWeight;
    end

    for _, r in pairs( self.OrgRanks ) do
        local RankButton = vgui.Create( "DButton" );
        self.CenterContainer.RankList.AddItem( self.CenterContainer.RankList, RankButton );

        RankButton.Rank = r;
        RankButton._alpha = 127;

        if r == self.SelectedRank then
            RankButton.Selected = true;
            RankButton._grayscale = 127;
            self.SelectedRank = RankButton;
        end

        RankButton:SetZPos( -r.Weight );
        RankButton:Dock( TOP );
        RankButton:SetFont( "rpui.Fonts.Orgs.Button" );
        RankButton:SetText( string.utf8upper(r.Name) );
        RankButton:SizeToContentsY( self.frameSpacing * 0.5 );
        RankButton.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            local s = this.Holding and (h * 0.2) or 0;
            surface.SetDrawColor( baseColor );
            surface.DrawRect( s * 0.5, s * 0.5, w - s, h - s );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end

        RankButton.DoClick = function( this )
            if this.Selected then return end

            for k4, v4 in pairs( self.CenterContainer.RankList.GetItems(self.CenterContainer.RankList) ) do v4.Selected = false; end

            this.Selected = true;
            self.SelectedRank = this;
        end

        RankButton.Think = function( this )
            if not self.Perms.Rank then return end

            if not this.Holding then
                if input.IsMouseDown( MOUSE_LEFT ) and (vgui.GetHoveredPanel() == this) and (not self.HoldingPnl) then
                    if (this.Rank.Weight >= 100) or (this.Rank.Weight <= 1) then return end
                    this.Holding, this.PrevWeight, self.HoldingPnl = true, this.Rank.Weight, this;
                    this:DoClick();
                end
            end

            if this.Holding then
                if not input.IsMouseDown( MOUSE_LEFT ) then
                    if IsValid(self.HoldingPnl) and (self.HoldingPnl.PrevWeight ~= self.HoldingPnl.Rank.Weight) then
                        rp.RunCommand( "orgrankweight", self.HoldingPnl.Rank.Name, self.HoldingPnl.Rank.Weight );
                    end

                    this.Holding, this.PrevWeight, self.HoldingPnl = nil, nil, nil;
                end

                local m_x, m_y = this:ScreenToLocal( input.GetCursorPos() );

                if not this.Swapped then
                    local RankItems = self.CenterContainer.RankList:GetItems();
                    if m_y <= -1 then
                        for i = 2, #RankItems-1 do
                            local v = RankItems[i];
                            if this ~= v then prevPanel = v; continue end

                            if not prevPanel then return end

                            local old_weight, new_weight = this.Rank.Weight, prevPanel.Rank.Weight;
                            this.Rank.Weight = new_weight; prevPanel.Rank.Weight = old_weight;

                            this:SetZPos( -this.Rank.Weight );
                            prevPanel:SetZPos( -prevPanel.Rank.Weight );

                            this.Swapped = true; prevPanel = nil;
                            break
                        end
                    elseif m_y >= this:GetTall() + 1 then
                        for i = #RankItems-1, 2, -1 do
                            local v = RankItems[i];
                            if this ~= v then prevPanel = v; continue end

                            if not prevPanel then return end

                            local old_weight, new_weight = this.Rank.Weight, prevPanel.Rank.Weight;
                            this.Rank.Weight = new_weight; prevPanel.Rank.Weight = old_weight;

                            this:SetZPos( -this.Rank.Weight );
                            prevPanel:SetZPos( -prevPanel.Rank.Weight );

                            this.Swapped = true; prevPanel = nil;
                            break
                        end
                    end
                else
                    if this.Swapped then this.Swapped = nil; end
                end

            end
        end
    end

    self:PopulateMembers();
end


function PANEL:RebuildPanel()
    self.Header = vgui.Create( "Panel", self );
    self.Header.Dock( self.Header, TOP );
    self.Header.DockMargin( self.Header, 0, 0, 0, self.frameSpacing );
    self.Header.InvalidateParent( self.Header, true );

    self.Header.QuitBtn = vgui.Create( "DButton", self.Header );
    self.Header.QuitBtn.Dock( self.Header.QuitBtn, RIGHT );
    self.Header.QuitBtn.SetFont( self.Header.QuitBtn, "rpui.Fonts.Orgs.Quit" );
    self.Header.QuitBtn.SetText( self.Header.QuitBtn, self.Perms.Owner and translates.Get("РАСПУСТИТЬ") or translates.Get("ПОКИНУТЬ") );
    self.Header.QuitBtn.SizeToContentsX( self.Header.QuitBtn, self.frameSpacing * 2 );
    self.Header.QuitBtn.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end
    self.Header.QuitBtn.DoClick = function( pnl )
        if not pnl.QuitPanel then
            pnl.QuitPanel = vgui.Create( "Panel", self );
            pnl.QuitPanel.SetAlpha( pnl.QuitPanel, 1 );
            pnl.QuitPanel.SetWide( pnl.QuitPanel, self.frameW * 0.3 );
            pnl.QuitPanel.Close = function( this )
                this.Closing = true;
                this:Stop();
                this:AlphaTo( 0, 0.25, 0, function()
                    if IsValid( this ) then this:Remove(); end
                    pnl.QuitPanel = nil;
                end );
            end
            pnl.QuitPanel.Think = function( this )
                if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and not this.Closing then
                    if (not this:IsHovered() and not this:IsChildHovered()) then
                        this:Close();
                    end
                end
            end

            pnl.QuitPanel.TopArrow = vgui.Create( "Panel", pnl.QuitPanel );
            pnl.QuitPanel.TopArrow.Dock( pnl.QuitPanel.TopArrow, TOP );
            pnl.QuitPanel.TopArrow.InvalidateParent( pnl.QuitPanel.TopArrow, true );
            pnl.QuitPanel.TopArrow.SetTall( pnl.QuitPanel.TopArrow, self.frameSpacing );
            pnl.QuitPanel.TopArrow.Paint = function( this, w, h )
                draw.NoTexture();
                surface.SetDrawColor( Color(0,0,0,200) );
                surface.DrawPoly( {{x = w, y = 0}, {x = w, y = h}, {x = w-h, y = h}} );
            end

            pnl.QuitPanel.Foreground = vgui.Create( "Panel", pnl.QuitPanel );
            pnl.QuitPanel.Foreground.Dock( pnl.QuitPanel.Foreground, TOP );
            pnl.QuitPanel.Foreground.DockPadding( pnl.QuitPanel.Foreground, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5 );
            pnl.QuitPanel.Foreground.InvalidateParent( pnl.QuitPanel.Foreground, true );
            pnl.QuitPanel.Foreground.Paint = function( this, w, h )
                surface.SetDrawColor( Color(0,0,0,200) );
                surface.DrawRect( 0, 0, w, h );
            end

            pnl.QuitPanel.WarningLabel = vgui.Create( "DLabel", pnl.QuitPanel.Foreground );
            pnl.QuitPanel.WarningLabel.Dock( pnl.QuitPanel.WarningLabel, TOP );
            pnl.QuitPanel.WarningLabel.SetFont( pnl.QuitPanel.WarningLabel, "rpui.Fonts.Orgs.QuitSmall" );
            pnl.QuitPanel.WarningLabel.SetContentAlignment( pnl.QuitPanel.WarningLabel, 5 );
            pnl.QuitPanel.WarningLabel.SetTextColor( pnl.QuitPanel.WarningLabel, rpui.UIColors.White );
            pnl.QuitPanel.WarningLabel.SetText( pnl.QuitPanel.WarningLabel, translates.Get("Вы уверены что хотите %s организацию:", (self.Perms.Owner and translates.Get("РАСПУСТИТЬ") or translates.Get("ПОКИНУТЬ"))) );
            pnl.QuitPanel.WarningLabel.SizeToContentsY(pnl.QuitPanel.WarningLabel);
            pnl.QuitPanel.WarningLabel.InvalidateParent( pnl.QuitPanel.WarningLabel, true );

            pnl.QuitPanel.OrgLabel = vgui.Create( "DLabel", pnl.QuitPanel.Foreground );
            pnl.QuitPanel.OrgLabel.Dock( pnl.QuitPanel.OrgLabel, TOP );
            pnl.QuitPanel.OrgLabel.DockMargin( pnl.QuitPanel.OrgLabel, 0, 0, 0, self.frameSpacing * 0.5 );
            pnl.QuitPanel.OrgLabel.SetFont( pnl.QuitPanel.OrgLabel, "rpui.Fonts.Orgs.QuitBold" );
            pnl.QuitPanel.OrgLabel.SetContentAlignment( pnl.QuitPanel.OrgLabel, 5 );
            pnl.QuitPanel.OrgLabel.SetTextColor( pnl.QuitPanel.OrgLabel, rpui.UIColors.White );
            pnl.QuitPanel.OrgLabel.SetText( pnl.QuitPanel.OrgLabel, "\"" .. LocalPlayer():GetOrg() .. "\"?" );
            pnl.QuitPanel.OrgLabel.SizeToContentsY(pnl.QuitPanel.OrgLabel);
            pnl.QuitPanel.OrgLabel.InvalidateParent( pnl.QuitPanel.OrgLabel, true );

            pnl.QuitPanel.Foreground.InvalidateLayout( pnl.QuitPanel.Foreground, true );
            pnl.QuitPanel.Foreground.SizeToChildren( pnl.QuitPanel.Foreground, true, true );
            pnl.QuitPanel.Foreground.SetTall( pnl.QuitPanel.Foreground, pnl.QuitPanel.Foreground.GetTall(pnl.QuitPanel.Foreground) + self.frameH * 0.1 );

            pnl.QuitPanel.ActionY = vgui.Create( "DButton", pnl.QuitPanel.Foreground );
            pnl.QuitPanel.ActionY.Dock( pnl.QuitPanel.ActionY, LEFT );
            pnl.QuitPanel.ActionY.SetWide( pnl.QuitPanel.ActionY, pnl.QuitPanel.Foreground.GetWide(pnl.QuitPanel.Foreground) * 0.5 - self.frameSpacing * 0.75 );
            pnl.QuitPanel.ActionY.SetFont( pnl.QuitPanel.ActionY, "rpui.Fonts.Orgs.QuitButton" );
            pnl.QuitPanel.ActionY.SetText( pnl.QuitPanel.ActionY, translates.Get("ДА") );
            pnl.QuitPanel.ActionY.DoClick = function( this )
                if not this.Selected then
                    this.Selected = true;
                    this:SetText( translates.Get("ПОДТВЕРДИТЕ") );
                    this.Timeout = SysTime() + 5;
                else
                    self.F4Menu.Close(self.F4Menu);
                    rp.RunCommand( "quitorg" );
                end
            end
            pnl.QuitPanel.ActionY.Think = function( this )
                if this.Timeout and this.Timeout < SysTime() then
                    this.Selected = false;
                    this:SetText( translates.Get("ДА") );
                    this.Timeout = nil;
                end
            end
            pnl.QuitPanel.ActionY.Paint = function( this, w, h )
                if not IsValid(pnl.QuitPanel) then return end
                this._alpha = math.Approach( this._alpha or 0, (this:IsHovered() or this.Selected) and 255 or 0, FrameTime() * 768 );

                local distsize  = math.sqrt( w*w + h*h );

                local parentalpha = pnl.QuitPanel.GetAlpha(pnl.QuitPanel) / 255;
                local alphamult   = (this._alpha or 0) / 255;

                surface.SetAlphaMultiplier( parentalpha * alphamult );
                    surface.SetDrawColor( rpui.UIColors.BackgroundDonateBuyed );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( rpui.UIColors.DonateBuyed );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, 0 );

                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.DonateBuyed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );

                return true
            end
            pnl.QuitPanel.ActionY.PaintOver = function( this, w, h )
                if not IsValid(pnl.QuitPanel) then return end
                rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, rpui.UIColors.BackgroundDonateBuyed, rpui.UIColors.DonateBuyed, pnl.QuitPanel.GetAlpha(pnl.QuitPanel) / 255 );
            end

            pnl.QuitPanel.ActionN = vgui.Create( "DButton", pnl.QuitPanel.Foreground );
            pnl.QuitPanel.ActionN.Dock( pnl.QuitPanel.ActionN, RIGHT );
            pnl.QuitPanel.ActionN.SetWide( pnl.QuitPanel.ActionN, pnl.QuitPanel.Foreground.GetWide(pnl.QuitPanel.Foreground) * 0.5 - self.frameSpacing * 0.75 );
            pnl.QuitPanel.ActionN.SetFont( pnl.QuitPanel.ActionN, "rpui.Fonts.Orgs.QuitButton" );
            pnl.QuitPanel.ActionN.SetText( pnl.QuitPanel.ActionN, translates.Get("НЕТ") );
            pnl.QuitPanel.ActionN.DoClick = function( this ) pnl.QuitPanel.Close(pnl.QuitPanel); end
            pnl.QuitPanel.ActionN.Paint = function( this, w, h )
                if not IsValid(pnl.QuitPanel) then return end
                this._alpha = math.Approach( this._alpha or 0, (this:IsHovered() or this.Selected) and 255 or 0, FrameTime() * 768 );

                local distsize  = math.sqrt( w*w + h*h );

                local parentalpha = pnl.QuitPanel.GetAlpha(pnl.QuitPanel) / 255;
                local alphamult   = (this._alpha or 0) / 255;

                surface.SetAlphaMultiplier( parentalpha * alphamult );
                    surface.SetDrawColor( rpui.UIColors.BackgroundDonateDisabled );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( rpui.UIColors.DonateDisabled );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, 0 );

                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.DonateDisabled, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );

                return true
            end
            pnl.QuitPanel.ActionN.PaintOver = function( this, w, h )
                if not IsValid(pnl.QuitPanel) then return end
                rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, rpui.UIColors.BackgroundDonateDisabled, rpui.UIColors.DonateDisabled, pnl.QuitPanel.GetAlpha(pnl.QuitPanel) / 255 );
            end

            pnl.QuitPanel.InvalidateLayout( pnl.QuitPanel, true );
            pnl.QuitPanel.SizeToChildren( pnl.QuitPanel, true, true );

            local x, y = self:ScreenToLocal( pnl:LocalToScreen() );
            pnl.QuitPanel.SetPos( pnl.QuitPanel, x + pnl:GetWide() - pnl.QuitPanel.GetWide(pnl.QuitPanel), y + pnl:GetTall() + self.frameSpacing * 0.5 );

            pnl.QuitPanel.AlphaTo( pnl.QuitPanel, 255, 0.25 );
        end
    end

    self.Header.MemberCount = vgui.Create( "DLabel", self.Header );
    self.Header.MemberCount.Dock( self.Header.MemberCount, TOP );
    self.Header.MemberCount.SetFont( self.Header.MemberCount, "rpui.Fonts.Orgs.MemberCount" );
    self.Header.MemberCount.SetTextColor( self.Header.MemberCount, rpui.UIColors.White );
    self.Header.MemberCount.SetText( self.Header.MemberCount, translates.Get("УЧАСТНИКИ: %s", #self.OrgMembers) );
    self.Header.MemberCount.SizeToContentsY( self.Header.MemberCount, self.frameSpacing * 0.5 );

    self.Header.InvalidateLayout( self.Header, true );
    self.Header.SizeToChildren( self.Header, false, true );

    self.MemberContainer = vgui.Create( "Panel", self );
    self.MemberContainer.Dock( self.MemberContainer, LEFT );
    self.MemberContainer.SetWide( self.MemberContainer, self.frameW * 0.35 );
    self.MemberContainer.InvalidateParent( self.MemberContainer, true );

    self.MemberContainer.Searchbar = vgui.Create( "Panel", self.MemberContainer );
    self.MemberContainer.Searchbar.Dock( self.MemberContainer.Searchbar, TOP );
    self.MemberContainer.Searchbar.DockMargin( self.MemberContainer.Searchbar, 0, 0, 0, self.frameSpacing * 0.5 );
    self.MemberContainer.Searchbar.SetTall( self.MemberContainer.Searchbar, self.frameSpacing * 2 );
    self.MemberContainer.Searchbar.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    self.MemberContainer.Searchbar.Icon = vgui.Create( "Panel", self.MemberContainer.Searchbar );
    self.MemberContainer.Searchbar.Icon.Dock( self.MemberContainer.Searchbar.Icon, LEFT );
    self.MemberContainer.Searchbar.Icon.DockMargin( self.MemberContainer.Searchbar.Icon, self.frameSpacing, 0, self.frameSpacing, 0 );
    self.MemberContainer.Searchbar.Icon.SetSize( self.MemberContainer.Searchbar.Icon, self.MemberContainer.Searchbar.GetTall(self.MemberContainer.Searchbar) );
    self.MemberContainer.Searchbar.Icon.Material = Material( "rpui/icons/usersearch.png", "smooth" );
    self.MemberContainer.Searchbar.Icon.Paint = function( this, w, h )
        if this.Material:IsError() then return end
        surface.SetDrawColor( rpui.UIColors.White );
        surface.SetMaterial( this.Material );
        surface.DrawTexturedRect( 0, 0, w, h );
    end

    self.MemberContainer.Searchbar.Input = vgui.Create( "DTextEntry", self.MemberContainer.Searchbar );
    self.MemberContainer.Searchbar.Input.Dock( self.MemberContainer.Searchbar.Input, FILL );
    self.MemberContainer.Searchbar.Input.DockMargin( self.MemberContainer.Searchbar.Input, 0, 0, self.frameSpacing * 0.5, 0 );
    self.MemberContainer.Searchbar.Input.SetPlaceholderText( self.MemberContainer.Searchbar.Input, translates.Get("ПОИСК ПО STEAMID") );
    self.MemberContainer.Searchbar.Input.SetFont( self.MemberContainer.Searchbar.Input, "rpui.Fonts.Orgs.MoTD" );
    self.MemberContainer.Searchbar.Input.Paint = function( this, w, h )
        if #this:GetValue() <= 0 and !this:HasFocus() then
            draw.SimpleText( this:GetPlaceholderText(), this:GetFont(), 0, h * 0.5, Color(255,255,255,127), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        else
            this:DrawTextEntryText( rpui.UIColors.White, rpui.UIColors.Pink, rpui.UIColors.White );
        end
    end
    self.MemberContainer.Searchbar.Input.OnTextChanged = function( this )
        self:PopulateMembers( this:GetText() );
    end

    self.MemberContainer.List = vgui.Create( "rpui.ScrollPanel", self.MemberContainer );
    self.MemberContainer.List.Dock( self.MemberContainer.List, FILL );
    self.MemberContainer.List.SetScrollbarMargin( self.MemberContainer.List, self.frameSpacing * 0.5 );
    self.MemberContainer.List.SetSpacingY( self.MemberContainer.List, self.frameSpacing * 0.5 );
    self.MemberContainer.List.InvalidateParent( self.MemberContainer.List, true );
    self.MemberContainer.List.AlwaysLayout( self.MemberContainer.List, true );
    self.MemberContainer.List.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    if self.Perms.Invite then
        self.MemberContainer.InviteMember = vgui.Create( "DButton", self.MemberContainer );
        self.MemberContainer.InviteMember.Dock( self.MemberContainer.InviteMember, BOTTOM );
        self.MemberContainer.InviteMember.DockMargin( self.MemberContainer.InviteMember, 0, self.frameSpacing * 0.5, 0, 0 );
        self.MemberContainer.InviteMember.SetFont( self.MemberContainer.InviteMember, "rpui.Fonts.Orgs.Button" );
        self.MemberContainer.InviteMember.SetText( self.MemberContainer.InviteMember, translates.Get("ПРИГЛАСИТЬ") );
        self.MemberContainer.InviteMember.SizeToContentsY( self.MemberContainer.InviteMember, self.frameSpacing * 0.5 );
        self.MemberContainer.InviteMember.InvalidateParent( self.MemberContainer.InviteMember, true );
        self.MemberContainer.InviteMember.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end
        self.MemberContainer.InviteMember.DoClick = function( this )
            if this.Selected then
                self.MemberContainer.Searchbar.Input.SetEditable( self.MemberContainer.Searchbar.Input, true );

                if IsValid( self.MemberContainer.EditMember ) then
                    self.MemberContainer.EditMember.DockMargin( self.MemberContainer.EditMember, 0, self.frameSpacing * 0.5, 0, 0 );
                    self.MemberContainer.EditMember.SizeToContentsY( self.MemberContainer.EditMember, self.frameSpacing * 0.5 );
                    self.MemberContainer.EditMember.InvalidateParent( self.MemberContainer.EditMember, true );
                end

                this:SetText( translates.Get("ПРИГЛАСИТЬ") );
                self:PopulateMembers();
            else
                self.MemberContainer.Searchbar.Input.SetEditable( self.MemberContainer.Searchbar.Input, false );

                if IsValid( self.MemberContainer.EditMember ) then
                    self.MemberContainer.EditMember.DockMargin( self.MemberContainer.EditMember, 0, 0, 0, 0 );
                    self.MemberContainer.EditMember.SetTall( self.MemberContainer.EditMember, 0 );
                    self.MemberContainer.EditMember.InvalidateParent( self.MemberContainer.EditMember, true );
                end

                this:SetText( translates.Get("НАЗАД") );
                self.MemberContainer.List.ClearItems(self.MemberContainer.List);

                local c = 0;

                for _, ply2 in ipairs( player.GetAll() ) do
                    if not ply2:GetOrg() then
                        local MemberPanel = vgui.Create( "DButton" );
                        self.MemberContainer.List.AddItem( self.MemberContainer.List, MemberPanel );

                        MemberPanel._alpha = 127;

                        MemberPanel.PlayerName = string.utf8upper( ply2:GetName() );

                        MemberPanel:Dock( TOP );
                        MemberPanel:SetTall( self.frameH * 0.05 );

                        surface.CreateFont( "MemberPanel.Medium", {
                            font     = "Montserrat",
                            extended = true,
                            weight   = 600,
                            size     = MemberPanel:GetTall() * 0.7,
                        } );

                        MemberPanel.Paint = function( this1, w, h )
                            local baseColor, textColor = rpui.GetPaintStyle( this1, STYLE_TRANSPARENT_INVERTED );
                            surface.SetDrawColor( baseColor );
                            surface.DrawRect( 0, 0, w, h );
                            draw.SimpleText( this1.PlayerName, "MemberPanel.Medium", w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                            return true
                        end

                        MemberPanel.DoClick = function( this2 )
                            if (!IsValid(ply2)) then return end
                            rp.RunCommand( "orginvite", ply2:SteamID64() );
                            this2:Remove();
                        end

                        MemberPanel.Avatar = vgui.Create( "AvatarImage", MemberPanel );
                        MemberPanel.Avatar.Dock( MemberPanel.Avatar, LEFT );
                        MemberPanel.Avatar.SetWide( MemberPanel.Avatar, MemberPanel:GetTall() );
                        MemberPanel.Avatar.SetPlayer( MemberPanel.Avatar, ply2, MemberPanel.Avatar.GetWide(MemberPanel.Avatar) );

                        c = c + 1;
                    end
                end

                if c == 0 then
                    local MemberPanel = vgui.Create( "DPanel" );
                    self.MemberContainer.List.AddItem( self.MemberContainer.List, MemberPanel );

                    MemberPanel._alpha = 127;

                    MemberPanel:Dock( TOP );
                    MemberPanel:SetTall( self.frameH * 0.05 );
                    MemberPanel:SetMouseInputEnabled( false );

                    surface.CreateFont( "MemberPanel.Medium", {
                        font     = "Montserrat",
                        extended = true,
                        weight   = 600,
                        size     = MemberPanel:GetTall() * 0.7,
                    } );

                    MemberPanel.Paint = function( this3, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this3 );
                        surface.SetDrawColor( baseColor );
                        surface.DrawRect( 0, 0, w, h );
                        draw.SimpleText( translates.Get("НЕТ ДОСТУПНЫХ ИГРОКОВ!"), "MemberPanel.Medium", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true
                    end
                end
            end

            this.Selected = not this.Selected;
        end
    end

    self.MemberContainer.EditMember = vgui.Create( "DButton", self.MemberContainer );
    self.MemberContainer.EditMember.Dock( self.MemberContainer.EditMember, BOTTOM );
    self.MemberContainer.EditMember.DockMargin( self.MemberContainer.EditMember, 0, self.frameSpacing * 0.5, 0, 0 );
    self.MemberContainer.EditMember.SetFont( self.MemberContainer.EditMember, "rpui.Fonts.Orgs.Button" );
    self.MemberContainer.EditMember.SetText( self.MemberContainer.EditMember, translates.Get("РЕДАКТИРОВАТЬ УЧАСТНИКА") );
    self.MemberContainer.EditMember.SizeToContentsY( self.MemberContainer.EditMember, self.frameSpacing * 0.5 );
    self.MemberContainer.EditMember.InvalidateParent( self.MemberContainer.EditMember, true );
    self.MemberContainer.EditMember.Paint = function( this4, w, h )
        if not self.SelectedMember then
            if this4:IsEnabled() then this4:SetEnabled( false ); end
        else
            if not this4:IsEnabled() then this4:SetEnabled( true ); end
        end

        local baseColor, textColor = rpui.GetPaintStyle( this4, STYLE_TRANSPARENT_INVERTED );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this4:GetText(), this4:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true;
    end
    self.MemberContainer.EditMember.DoClick = function( this5 )
        if this5.Selected then
            self.MemberContainer.Searchbar.Input.SetEditable( self.MemberContainer.Searchbar.Input, true );

            if IsValid( self.MemberContainer.InviteMember ) then
                self.MemberContainer.InviteMember.DockMargin( self.MemberContainer.InviteMember, 0, self.frameSpacing * 0.5, 0, 0 );
                self.MemberContainer.InviteMember.SizeToContentsY( self.MemberContainer.InviteMember, self.frameSpacing * 0.5 );
                self.MemberContainer.InviteMember.InvalidateParent( self.MemberContainer.InviteMember, true );
            end

            this5:SetText( translates.Get("РЕДАКТИРОВАТЬ УЧАСТНИКА") );
            self:PopulateMembers();
        else
            self.MemberContainer.Searchbar.Input.SetEditable( self.MemberContainer.Searchbar.Input, false );

            if IsValid( self.MemberContainer.InviteMember ) then
                self.MemberContainer.InviteMember.DockMargin( self.MemberContainer.InviteMember, 0, 0, 0, 0 );
                self.MemberContainer.InviteMember.SetTall( self.MemberContainer.InviteMember, 0 );
                self.MemberContainer.InviteMember.InvalidateParent( self.MemberContainer.InviteMember, true );
            end

            this5:SetText( translates.Get("НАЗАД") );
            self.MemberContainer.List.ClearItems(self.MemberContainer.List);

            local ply = self.SelectedMember;

            local MemberPanel = vgui.Create( "DPanel" );
            self.MemberContainer.List.AddItem( self.MemberContainer.List, MemberPanel );

            MemberPanel._alpha = 127;

            MemberPanel.PlayerName = string.utf8upper( ply.Name );

            MemberPanel:Dock( TOP );
            MemberPanel:SetTall( self.frameH * 0.05 );
            MemberPanel:SetMouseInputEnabled( false );

            surface.CreateFont( "MemberPanel.Medium", {
                font     = "Montserrat",
                extended = true,
                weight   = 600,
                size     = MemberPanel:GetTall() * 0.7,
            } );

            MemberPanel.Paint = function( this6, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this6 );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( this6.PlayerName, "MemberPanel.Medium", w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end

            MemberPanel.Avatar = vgui.Create( "AvatarImage", MemberPanel );
            MemberPanel.Avatar.Dock( MemberPanel.Avatar, LEFT );
            MemberPanel.Avatar.SetWide( MemberPanel.Avatar, MemberPanel:GetTall() );
            MemberPanel.Avatar.SetSteamID( MemberPanel.Avatar, ply.SteamID, MemberPanel.Avatar.GetWide(MemberPanel.Avatar) );

            if self.Perms.Rank then
                local ChangeRankBtn = vgui.Create( "DButton" );
                self.MemberContainer.List.AddItem( self.MemberContainer.List, ChangeRankBtn );

                ChangeRankBtn:Dock( TOP );
                ChangeRankBtn:SetTall( self.frameH * 0.05 );
                ChangeRankBtn:SetText( translates.Get("ИЗМЕНИТЬ РАНГ") );

                surface.CreateFont( "MemberPanel.Medium", {
                    font     = "Montserrat",
                    extended = true,
                    weight   = 600,
                    size     = MemberPanel:GetTall() * 0.7,
                } );

                ChangeRankBtn.Paint = function( this7, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this7, STYLE_TRANSPARENT_INVERTED );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this7:GetText(), "MemberPanel.Medium", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end

                ChangeRankBtn.DoClick = function( this8 )
                    local m = vgui.Create( "rpui.DropMenu" );
                    m:SetBase( this8 );
                    m:SetFont( "MemberPanel.Medium" );
                    m:SetSpacing( ScrH() * 0.01 );
                    m.Paint = function( this9, w, h ) draw.Blur( this9 ); end

                    local num = 0;

                    for k5, v5 in ipairs( self.OrgRanks ) do
                        if (v5.Weight > self.Perms.Weight) or (v5.Name == self.SelectedMember.Rank) then continue end

                        num = num + 1;

                        local option = m:AddOption( v5.Name, function()
                            rp.RunCommand( "orgsetrank", self.SelectedMember.SteamID, v5.Name );
                            self.SelectedMember.Rank = v5.Name;
                            self.SelectedMember.Weight = v5.Weight;

                            table.SortByMember( self.OrgMembers, "Weight" );

                            m:Remove();
                        end );

                        option.Paint = function( this9, w, h )
                            local baseColor, textColor = rpui.GetPaintStyle( this9, STYLE_TRANSPARENT_SELECTABLE );
                            surface.SetDrawColor( baseColor );
                            surface.DrawRect( 0, 0, w, h );
                            draw.SimpleText( this9:GetText(), this9:GetFont(), this9.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                            return true
                        end
                    end

                    if num > 0 then
                        m:Open();
                        m:SetPos(this8:LocalToScreen())
                    else
                        m:Remove();
                    end
                end
            end

            if self.Perms.Kick then
                local KickBtn = vgui.Create( "DButton" );
                self.MemberContainer.List.AddItem( self.MemberContainer.List, KickBtn );

                KickBtn:Dock( TOP );
                KickBtn:SetTall( self.frameH * 0.05 );
                KickBtn:SetText( translates.Get("ВЫГНАТЬ") );

                surface.CreateFont( "MemberPanel.Medium", {
                    font     = "Montserrat",
                    extended = true,
                    weight   = 600,
                    size     = MemberPanel:GetTall() * 0.7,
                } );

                KickBtn.Paint = function( this10, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this10, STYLE_TRANSPARENT_INVERTED );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this10:GetText(), "MemberPanel.Medium", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end

                KickBtn.DoClick = function( me )
                    if not me.Timeout then
                        me.Timeout = SysTime() + 3;
                        me:SetText( translates.Get("ПОДТВЕРДИТЕ") );
                    else
                        me.Timeout = 0;
                        this5:DoClick();

                        rp.RunCommand( "orgkick", self.SelectedMember.SteamID );

                        for k, member in pairs( self.OrgMembers ) do
                            if member.SteamID == self.SelectedMember.SteamID then
                                self.OrgMembers[k] = nil;
                                break;
                            end
                        end

                        self:PopulateMembers();
                    end
                end

                KickBtn.Think = function( this11 )
                    if this11.Timeout and this11.Timeout <= SysTime() then
                        this11:SetText( translates.Get("ВЫГНАТЬ") );
                        this11.Timeout = nil;
                    end
                end
            end
        end

        this5.Selected = not this5.Selected;
    end

    self.MoTDContainer = vgui.Create( "Panel", self );
    self.MoTDContainer.Dock( self.MoTDContainer, RIGHT );
    self.MoTDContainer.SetWide( self.MoTDContainer, self.frameW * 0.4 );
    self.MoTDContainer.InvalidateParent( self.MoTDContainer, true );

    if self.Perms.Owner then
        self.MoTDContainer.EditColour = vgui.Create( "DButton", self.MoTDContainer );
        self.MoTDContainer.EditColour.Dock( self.MoTDContainer.EditColour, BOTTOM );
        self.MoTDContainer.EditColour.DockMargin( self.MoTDContainer.EditColour, 0, self.frameSpacing * 0.5, 0, 0 );
        self.MoTDContainer.EditColour.SetFont( self.MoTDContainer.EditColour, "rpui.Fonts.Orgs.Button" );
        self.MoTDContainer.EditColour.SetText( self.MoTDContainer.EditColour, translates.Get("ИЗМЕНИТЬ ЦВЕТ") );
        self.MoTDContainer.EditColour.SizeToContentsY( self.MoTDContainer.EditColour, self.frameSpacing * 0.5 );
        self.MoTDContainer.EditColour.InvalidateParent( self.MoTDContainer.EditColour, true );
        self.MoTDContainer.EditColour.Paint = function( this13, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this13, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this13:GetText(), this13:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end
        self.MoTDContainer.EditColour.DoClick = function( this14 )
            if not this14.ColourFrame then
                if self.MoTDContainer.Message.Editable then
                    self.MoTDContainer.Message.SetText( self.MoTDContainer.Message, self.MoTD );
                    self.MoTDContainer.Message.SetEditable( self.MoTDContainer.Message, false );
                    self.MoTDContainer.Message.Editable = false;
                    self.MoTDContainer.EditMessage.SetText( self.MoTDContainer.EditMessage, translates.Get("ИЗМЕНИТЬ НОВОСТИ") );
                end

                this14.ColourFrame = vgui.Create( "Panel", self );
                this14.ColourFrame.SetAlpha( this14.ColourFrame, 1 );
                this14.ColourFrame.SetWide( this14.ColourFrame, self.frameH * 0.5 );
                this14.ColourFrame.Close = function( me )
                    me.Closing = true;
                    me:Stop();
                    me:AlphaTo( 0, 0.25, 0, function()
                        if IsValid( me ) then me:Remove(); end
                        this14.ColourFrame = nil;
                    end );
                    this14:SetText( translates.Get("ИЗМЕНИТЬ ЦВЕТ") );
                end
                this14.ColourFrame.Think = function( this15 )
                    if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and (not this15.Closing) and (not this15.WasHovered) then
                        if (not this15:IsHovered() and not this15:IsChildHovered()) then
                            this15:Close();
                        end
                    end

                    local this15_Hovered = this15:IsHovered() or this15:IsChildHovered();
                    if input.IsMouseDown( MOUSE_LEFT ) then
                        if this15_Hovered and (not this15.WasHovered) then this15.WasHovered = true; end
                    else
                        if this15.WasHovered then this15.WasHovered = nil; end
                    end
                end

                this14.ColourFrame.Foreground = vgui.Create( "Panel", this14.ColourFrame );
                this14.ColourFrame.Foreground.Dock( this14.ColourFrame.Foreground, TOP );
                this14.ColourFrame.Foreground.DockPadding( this14.ColourFrame.Foreground, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5 );
                this14.ColourFrame.Foreground.InvalidateParent( this14.ColourFrame.Foreground, true );
                this14.ColourFrame.Foreground.Paint = function( this16, w, h )
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawRect( 0, 0, w, h );
                end

                this14.ColourFrame.Title = vgui.Create( "DLabel", this14.ColourFrame.Foreground );
                this14.ColourFrame.Title.Dock( this14.ColourFrame.Title, TOP );
                this14.ColourFrame.Title.DockMargin( this14.ColourFrame.Title, 0, 0, 0, self.frameSpacing * 0.5 );
                this14.ColourFrame.Title.SetFont( this14.ColourFrame.Title, "rpui.Fonts.Orgs.MenuSmall" );
                this14.ColourFrame.Title.SetTextColor( this14.ColourFrame.Title, rpui.UIColors.White );
                this14.ColourFrame.Title.SetText( this14.ColourFrame.Title, translates.Get("ВЫБОР НОВОГО ЦВЕТА:") );
                this14.ColourFrame.Title.SizeToContentsY(this14.ColourFrame.Title);
                this14.ColourFrame.Title.InvalidateParent( this14.ColourFrame.Title, true );

                this14.ColourFrame.ColorMixer = vgui.Create( "DColorMixer", this14.ColourFrame.Foreground );
                this14.ColourFrame.ColorMixer.SetColor( this14.ColourFrame.ColorMixer, LocalPlayer():GetOrgColor() );
                this14.ColourFrame.ColorMixer.Dock( this14.ColourFrame.ColorMixer, TOP );
                this14.ColourFrame.ColorMixer.DockMargin( this14.ColourFrame.ColorMixer, 0, 0, 0, self.frameSpacing );
                this14.ColourFrame.ColorMixer.SetTall( this14.ColourFrame.ColorMixer, self.frameH * 0.3 );
                this14.ColourFrame.ColorMixer.SetPalette( this14.ColourFrame.ColorMixer, false );
                this14.ColourFrame.ColorMixer.SetAlphaBar( this14.ColourFrame.ColorMixer, false );
                this14.ColourFrame.ColorMixer.WangsPanel.SetWide( this14.ColourFrame.ColorMixer.WangsPanel, self.frameW * 0.065 );
                this14.ColourFrame.ColorMixer.txtR.SetTall( this14.ColourFrame.ColorMixer.txtR, self.frameH * 0.04 );
                this14.ColourFrame.ColorMixer.txtR.SetTextColor( this14.ColourFrame.ColorMixer.txtR, Color(255,38,38) );
                this14.ColourFrame.ColorMixer.txtR.SetFont( this14.ColourFrame.ColorMixer.txtR, "DermaDefault" );
                this14.ColourFrame.ColorMixer.txtR.Up.Paint = function( panel, w, h )
                    draw.SimpleText( "⯅", "DermaDefault", w * 0.5, h * 0.65, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtR.Down.Paint = function( panel, w, h )
                    draw.SimpleText( "⯆", "DermaDefault", w * 0.5, h * 0.45, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtR.Paint = function( this17, w, h )
                    surface.SetDrawColor( rpui.UIColors.Background ); surface.DrawRect( 0, 0, w, h );
                    this17:DrawTextEntryText( this17:GetTextColor(), rpui.UIColors.Background, rpui.UIColors.White );
                end
                this14.ColourFrame.ColorMixer.txtG.SetTall( this14.ColourFrame.ColorMixer.txtG, self.frameH * 0.04 );
                this14.ColourFrame.ColorMixer.txtG.SetTextColor( this14.ColourFrame.ColorMixer.txtG, Color(38,255,38) );
                this14.ColourFrame.ColorMixer.txtG.SetFont( this14.ColourFrame.ColorMixer.txtG, "DermaDefault" );
                this14.ColourFrame.ColorMixer.txtG.Up.Paint = function( panel, w, h )
                    draw.SimpleText( "⯅", "DermaDefault", w * 0.5, h * 0.65, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtG.Down.Paint = function( panel, w, h )
                    draw.SimpleText( "⯆", "DermaDefault", w * 0.5, h * 0.45, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtG.Paint = function( this18, w, h )
                    surface.SetDrawColor( rpui.UIColors.Background ); surface.DrawRect( 0, 0, w, h );
                    this18:DrawTextEntryText( this18:GetTextColor(), rpui.UIColors.Background, rpui.UIColors.White );
                end
                this14.ColourFrame.ColorMixer.txtB.SetTall( this14.ColourFrame.ColorMixer.txtB, self.frameH * 0.04 );
                this14.ColourFrame.ColorMixer.txtB.SetTextColor( this14.ColourFrame.ColorMixer.txtB, Color(38,38,255) );
                this14.ColourFrame.ColorMixer.txtB.SetFont( this14.ColourFrame.ColorMixer.txtB, "DermaDefault" );
                this14.ColourFrame.ColorMixer.txtB.Up.Paint = function( panel, w, h )
                    draw.SimpleText( "⯅", "DermaDefault", w * 0.5, h * 0.65, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtB.Down.Paint = function( panel, w, h )
                    draw.SimpleText( "⯆", "DermaDefault", w * 0.5, h * 0.45, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                this14.ColourFrame.ColorMixer.txtB.Paint = function( this19, w, h )
                    surface.SetDrawColor( rpui.UIColors.Background ); surface.DrawRect( 0, 0, w, h );
                    this19:DrawTextEntryText( this19:GetTextColor(), rpui.UIColors.Background, rpui.UIColors.White );
                end
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour = vgui.Create( "DPanel", this14.ColourFrame.ColorMixer.WangsPanel );
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.Dock( this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour, TOP );
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.DockMargin( this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour, 0, 4, 0, 0 );
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.InvalidateParent( this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour, true );
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.SetTall( this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour, this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.GetWide(this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour) );
                this14.ColourFrame.ColorMixer.WangsPanel.SelectedColour.Paint = function( _, w, h )
                    if not IsValid( this14.ColourFrame ) then return end
                    surface.SetDrawColor( rpui.UIColors.Background );
                    surface.DrawRect( 0, 0, w, h );
                    surface.SetDrawColor( this14.ColourFrame.ColorMixer.GetColor(this14.ColourFrame.ColorMixer) );
                    surface.DrawRect( 4, 4, w-8, h-8 );
                end
                this14.ColourFrame.ColorMixer.HSV.Knob.Paint = function( this20, w, h )
                    if not this20.BakedCircle then
                        this20.BakedCircleOutline = rpui.BakeCircle( 0, 0, h, 10 );
                        this20.BakedCircle        = rpui.BakeCircle( 2, 2, h-4, 10 );
                    end

                    draw.NoTexture();
                    surface.SetDrawColor( rpui.UIColors.Background ); surface.DrawPoly( this20.BakedCircleOutline );
                    surface.SetDrawColor( rpui.UIColors.White ); surface.DrawPoly( this20.BakedCircle );
                end
                this14.ColourFrame.ColorMixer.InvalidateParent( this14.ColourFrame.ColorMixer, true );

                this14.ColourFrame.BottomArrow = vgui.Create( "Panel", this14.ColourFrame );
                this14.ColourFrame.BottomArrow.Dock( this14.ColourFrame.BottomArrow, TOP );
                this14.ColourFrame.BottomArrow.SetTall( this14.ColourFrame.BottomArrow, self.frameSpacing );
                this14.ColourFrame.BottomArrow.Paint = function( this21, w, h )
                    draw.NoTexture();
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawPoly( {{x = w * 0.5 - h * 0.5, y = 0}, {x = w * 0.5 + h * 0.5, y = 0}, {x = w * 0.5, y = h}} );
                end

                this14.ColourFrame.Foreground.InvalidateLayout( this14.ColourFrame.Foreground, true );
                this14.ColourFrame.Foreground.SizeToChildren( this14.ColourFrame.Foreground, true, true );

                this14.ColourFrame.InvalidateLayout( this14.ColourFrame, true );
                this14.ColourFrame.SizeToChildren( this14.ColourFrame, true, true );

                local x, y = self:ScreenToLocal( this14:LocalToScreen() );
                this14.ColourFrame.SetPos( this14.ColourFrame, x + this14:GetWide() * 0.5 - this14.ColourFrame.GetWide(this14.ColourFrame) * 0.5, y - this14.ColourFrame.GetTall(this14.ColourFrame) - self.frameSpacing * 0.5 );

                this14.ColourFrame.AlphaTo( this14.ColourFrame, 255, 0.25 );

                this14:SetText( translates.Get("ГОТОВО") );
            else
                local selectedClr = this14.ColourFrame.ColorMixer.GetColor(this14.ColourFrame.ColorMixer);
                if selectedClr ~= LocalPlayer():GetOrgColor() then
                    rp.RunCommand( "setorgcolor", selectedClr.r, selectedClr.g, selectedClr.b );
                end

                this14:SetText( translates.Get("ИЗМЕНИТЬ ЦВЕТ") );
            end
        end
    end

    if self.Perms.MoTD then
        self.MoTDContainer.EditMessage = vgui.Create( "DButton", self.MoTDContainer );
        self.MoTDContainer.EditMessage.Dock( self.MoTDContainer.EditMessage, BOTTOM );
        self.MoTDContainer.EditMessage.DockMargin( self.MoTDContainer.EditMessage, 0, self.frameSpacing * 0.5, 0, 0 );
        self.MoTDContainer.EditMessage.SetFont( self.MoTDContainer.EditMessage, "rpui.Fonts.Orgs.Button" );
        self.MoTDContainer.EditMessage.SetText( self.MoTDContainer.EditMessage, translates.Get("ИЗМЕНИТЬ НОВОСТИ") );
        self.MoTDContainer.EditMessage.SizeToContentsY( self.MoTDContainer.EditMessage, self.frameSpacing * 0.5 );
        self.MoTDContainer.EditMessage.InvalidateParent( self.MoTDContainer.EditMessage, true );
        self.MoTDContainer.EditMessage.Paint = function( this22, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this22, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this22:GetText(), this22:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end
        self.MoTDContainer.EditMessage.DoClick = function( this23 )
            if self.MoTDContainer.Message.Editable then
                self.MoTDContainer.Message.SetEditable( self.MoTDContainer.Message, false );
                self.MoTDContainer.Message.Editable = false;
                this23:SetText( translates.Get("ИЗМЕНИТЬ НОВОСТИ") );

                local newMoTD = self.MoTDContainer.Message.GetValue(self.MoTDContainer.Message);
                if self.MoTD ~= newMoTD then
                    net.Start( "rp.SetOrgMoTD" );
                        net.WriteString( newMoTD );
                    net.SendToServer();

                    self.MoTD = newMoTD;
                end
            else
                self.MoTDContainer.Message.SetEditable( self.MoTDContainer.Message, true );
                self.MoTDContainer.Message.Editable = true;
                self.MoTDContainer.Message.RequestFocus(self.MoTDContainer.Message);
                this23:SetText( translates.Get("ГОТОВО") );
            end
        end
    end

    self.MoTDContainer.MessageContainer = vgui.Create( "Panel", self.MoTDContainer );
    self.MoTDContainer.MessageContainer.Dock( self.MoTDContainer.MessageContainer, FILL );
    self.MoTDContainer.MessageContainer.DockPadding( self.MoTDContainer.MessageContainer, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5 );
    self.MoTDContainer.MessageContainer.InvalidateParent( self.MoTDContainer.MessageContainer, true );
    self.MoTDContainer.MessageContainer.Paint = function( this24, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    self.MoTDContainer.MessageContainer.MessageScroll = vgui.Create( "rpui.ScrollPanel", self.MoTDContainer.MessageContainer );
    self.MoTDContainer.MessageContainer.MessageScroll.Dock( self.MoTDContainer.MessageContainer.MessageScroll, FILL );
    self.MoTDContainer.MessageContainer.MessageScroll.SetScrollbarMargin( self.MoTDContainer.MessageContainer.MessageScroll, self.frameSpacing * 0.5 );
    self.MoTDContainer.MessageContainer.MessageScroll.InvalidateParent( self.MoTDContainer.MessageContainer.MessageScroll, true );

    self.MoTDContainer.Message = vgui.Create( "DTextEntry" );
    self.MoTDContainer.MessageContainer.MessageScroll.AddItem( self.MoTDContainer.MessageContainer.MessageScroll, self.MoTDContainer.Message );

    self.MoTDContainer.Message.Dock( self.MoTDContainer.Message, FILL );
    self.MoTDContainer.Message.SetWrap( self.MoTDContainer.Message, true );
    self.MoTDContainer.Message.SetMultiline( self.MoTDContainer.Message, true );
    self.MoTDContainer.Message.Editable = false;
    self.MoTDContainer.Message.SetEditable( self.MoTDContainer.Message, false );
    self.MoTDContainer.Message.SetFont( self.MoTDContainer.Message, "rpui.Fonts.Orgs.MoTD" );
    self.MoTDContainer.Message.SetTextColor( self.MoTDContainer.Message, rpui.UIColors.White );
    self.MoTDContainer.Message.SetText( self.MoTDContainer.Message, self.MoTD );
    self.MoTDContainer.Message.Paint = function( this25, w, h )
        if this25.Editable then
            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( 0, 0, w, h );
        end

        if #this25:GetValue() <= 0 and !this25:HasFocus() then
            draw.SimpleText( this25:GetPlaceholderText(), this25:GetFont(), 0, h * 0.5, this25:GetTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
        else
            this25:DrawTextEntryText( this25:GetTextColor(), rpui.UIColors.Pink, this25:GetTextColor() );
        end
    end

    self.CenterContainer = vgui.Create( "Panel", self );
    self.CenterContainer.Dock( self.CenterContainer, FILL );
    self.CenterContainer.DockMargin( self.CenterContainer, self.frameSpacing, 0, self.frameSpacing, 0 );
    self.CenterContainer.InvalidateParent( self.CenterContainer, true );

    self.CenterContainer.Banner = vgui.Create( "DButton", self.CenterContainer );
    self.CenterContainer.Banner.Dock( self.CenterContainer.Banner, TOP );
    self.CenterContainer.Banner.DockMargin( self.CenterContainer.Banner, 0, 0, 0, self.frameSpacing );
    self.CenterContainer.Banner.SetTall( self.CenterContainer.Banner, self.CenterContainer.GetWide(self.CenterContainer) );
    self.CenterContainer.Banner.InvalidateParent( self.CenterContainer.Banner, true );
    self.CenterContainer.Banner.Paint = function( this26, w, h )
        local mat = rp.orgs.GetBanner( LocalPlayer():GetOrg() );
        if mat then
            surface.SetDrawColor( rpui.UIColors.White );
            surface.SetMaterial( mat );
            surface.DrawTexturedRect( 0, 0, w, h );
        else
            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( 0, 0, w, h );
        end

        return true
    end
    self.CenterContainer.Banner.DoClick = function( this27 )
        rp.orgs.OpenOrgBannerEditor( self.Perms );
    end

    if self.Perms.Owner and self.Perms.Owner ~= 0 then
        self.CenterContainer.AddRank = vgui.Create( "DButton", self.CenterContainer );
        self.CenterContainer.AddRank.Dock( self.CenterContainer.AddRank, BOTTOM );
        self.CenterContainer.AddRank.DockMargin( self.CenterContainer.AddRank, 0, self.frameSpacing * 0.5, 0, 0 );
        self.CenterContainer.AddRank.SetFont( self.CenterContainer.AddRank, "rpui.Fonts.Orgs.Button" );
        self.CenterContainer.AddRank.SetText( self.CenterContainer.AddRank, translates.Get("НОВЫЙ РАНГ") );
        self.CenterContainer.AddRank.SizeToContentsY( self.CenterContainer.AddRank, self.frameSpacing * 0.5 );
        self.CenterContainer.AddRank.InvalidateParent( self.CenterContainer.AddRank, true );
        self.CenterContainer.AddRank.Paint = function( this28, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this28, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this28:GetText(), this28:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end
        self.CenterContainer.AddRank.DoClick = function( pnl )
            if not pnl.RankPanel then
                pnl.Editable = true;

                pnl.RankPanel = vgui.Create( "Panel", self );
                pnl.RankPanel.SetWide( pnl.RankPanel, pnl:GetWide() );
                pnl.RankPanel.Close = function( this29 )
                    this29.Closing = true;
                    this29:Stop();
                    this29:AlphaTo( 0, 0.25, 0, function()
                        if IsValid( this29 ) then this29:Remove(); end
                        pnl.RankPanel = nil;
                    end );
                end
                pnl.RankPanel.Think = function( this30 )
                    if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and (not this30.Closing) and (not this30.WasHovered) then
                        if (not this30:IsHovered() and not this30:IsChildHovered()) then
                            this30:Close();
                        end
                    end

                    local this30_Hovered = this30:IsHovered() or this30:IsChildHovered();
                    if input.IsMouseDown( MOUSE_LEFT ) then
                        if this30_Hovered and (not this30.WasHovered) then this30.WasHovered = true; end
                    else
                        if this30.WasHovered then this30.WasHovered = nil; end
                    end
                end

                pnl.RankPanel.Foreground = vgui.Create( "Panel", pnl.RankPanel );
                pnl.RankPanel.Foreground.Dock( pnl.RankPanel.Foreground, TOP );
                pnl.RankPanel.Foreground.DockPadding( pnl.RankPanel.Foreground, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5 );
                pnl.RankPanel.Foreground.InvalidateParent( pnl.RankPanel.Foreground, true );
                pnl.RankPanel.Foreground.Paint = function( this31, w, h )
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawRect( 0, 0, w, h );
                end

                pnl.RankPanel.BottomArrow = vgui.Create( "Panel", pnl.RankPanel );
                pnl.RankPanel.BottomArrow.Dock( pnl.RankPanel.BottomArrow, TOP );
                pnl.RankPanel.BottomArrow.SetTall( pnl.RankPanel.BottomArrow, self.frameSpacing );
                pnl.RankPanel.BottomArrow.InvalidateParent( pnl.RankPanel.BottomArrow, true );
                pnl.RankPanel.BottomArrow.Paint = function( this32, w, h )
                    draw.NoTexture();
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawPoly( {{x = w * 0.5 - h * 0.5, y = 0}, {x = w * 0.5 + h * 0.5, y = 0}, {x = w * 0.5, y = h}} );
                end

                pnl.RankPanel.NameLabel = vgui.Create( "DLabel", pnl.RankPanel.Foreground );
                pnl.RankPanel.NameLabel.Dock( pnl.RankPanel.NameLabel, TOP );
                pnl.RankPanel.NameLabel.DockMargin( pnl.RankPanel.NameLabel, 0, 0, 0, self.frameSpacing * 0.25 );
                pnl.RankPanel.NameLabel.SetFont( pnl.RankPanel.NameLabel, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.NameLabel.SetTextColor( pnl.RankPanel.NameLabel, rpui.UIColors.White );
                pnl.RankPanel.NameLabel.SetText( pnl.RankPanel.NameLabel, translates.Get("НАЗВАНИЕ") );
                pnl.RankPanel.NameLabel.SizeToContentsY(pnl.RankPanel.NameLabel);
                pnl.RankPanel.NameLabel.InvalidateParent( pnl.RankPanel.NameLabel, true );

                pnl.RankPanel.Name = vgui.Create( "DTextEntry", pnl.RankPanel.Foreground );
                pnl.RankPanel.Name.Dock( pnl.RankPanel.Name, TOP );
                pnl.RankPanel.Name.DockMargin( pnl.RankPanel.Name, 0, 0, 0, self.frameSpacing * 0.5 );
                pnl.RankPanel.Name.SetZPos( pnl.RankPanel.Name, 0 );
                pnl.RankPanel.Name.SetFont( pnl.RankPanel.Name, "rpui.Fonts.Orgs.MenuSmall" );
                pnl.RankPanel.Name.SetText( pnl.RankPanel.Name, translates.Get("Новый ранг") );
                pnl.RankPanel.Name.SizeToContentsY(pnl.RankPanel.Name);
                pnl.RankPanel.Name.InvalidateParent( pnl.RankPanel.Name, true );
                pnl.RankPanel.Name.Paint = function( this33, w, h )
                    surface.SetDrawColor( rpui.UIColors.White );
                    surface.DrawRect( 0, 0, w, h );

                    if #this33:GetValue() <= 0 and !this33:HasFocus() then
                        draw.SimpleText( this33:GetPlaceholderText(), this33:GetFont(), 0, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                    else
                        this33:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Pink, rpui.UIColors.Black );
                    end
                end

                pnl.RankPanel.PermsLabel = vgui.Create( "DLabel", pnl.RankPanel.Foreground );
                pnl.RankPanel.PermsLabel.Dock( pnl.RankPanel.PermsLabel, TOP );
                pnl.RankPanel.PermsLabel.DockMargin( pnl.RankPanel.PermsLabel, 0, 0, 0, self.frameSpacing * 0.25 );
                pnl.RankPanel.PermsLabel.SetFont( pnl.RankPanel.PermsLabel, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.PermsLabel.SetTextColor( pnl.RankPanel.PermsLabel, rpui.UIColors.White );
                pnl.RankPanel.PermsLabel.SetText( pnl.RankPanel.PermsLabel, translates.Get("ПОЛНОМОЧИЯ") );
                pnl.RankPanel.PermsLabel.SizeToContentsY(pnl.RankPanel.PermsLabel);
                pnl.RankPanel.PermsLabel.InvalidateParent( pnl.RankPanel.PermsLabel, true );

                local rankperms = {
                    ["Invite"]       = { name = translates.Get("Приглашать") },
                    ["Kick"]         = { name = translates.Get("Выгонять") },
                    ["Rank"]         = { name = translates.Get("Ред. ранги") },
                    ["MoTD"]         = { name = translates.Get("Ред. новости") },
                    ["CanCapture"]   = { name = translates.Get("Захват точек") },
                    ["CanDiplomacy"] = { name = translates.Get("Дипломатия") },
                    ["CanStorage"]   = { name = translates.Get("Исп. склада") },
                };

                for key, perms in pairs( rankperms ) do
                    local chk = vgui.Create( "DCheckBoxLabel", pnl.RankPanel.Foreground );
                    chk:Dock( TOP );
                    chk:DockMargin( 0, 0, 0, self.frameSpacing * 0.25 );
                    chk:SetFont( "rpui.Fonts.Orgs.MenuSmall" );
                    chk:SetTextColor( rpui.UIColors.White );
                    chk:SetText( perms.name );
                    chk:InvalidateParent( true );

                    chk.Button.BaseAlpha    = chk:GetChecked() and 1 or 0;
                    chk.Button.HoveredAlpha = chk:GetChecked() and 1 or 0;

                    chk.Button.Paint = function( this34, w, h )
                        local ft = FrameTime();

                        this34.BaseAlpha = math.Approach( this34.BaseAlpha, chk:GetChecked() and 1 or 0, ft * 4 );
                        this34.HoveredAlpha = math.Approach( this34.HoveredAlpha, (chk:GetChecked() or this34:IsHovered()) and 1 or 0, ft * 4 );

                        if this34.BaseAlpha < 1 then
                            surface.SetDrawColor( rpui.UIColors.Background );
                            surface.DrawRect( 0, 0, w, h );

                            local bs = rpui.PowOfTwo( h * 0.1 );
                            surface.SetDrawColor( Color(255,255,255,8 + this34.HoveredAlpha * 247) );
                            surface.DrawRect( 0, 0, w, bs );
                            surface.DrawRect( 0, h - bs, w, bs );
                            surface.DrawRect( 0, bs, bs, h-bs*2 );
                            surface.DrawRect( w - bs, bs, bs, h-bs*2 );
                        end

                        if this34.BaseAlpha > 0 then
                            local a = this34.BaseAlpha * 255;
                            surface.SetDrawColor( Color(255,255,255,a) );
                            surface.DrawRect( 0, 0, w, h );
                            draw.SimpleText( "✔", "rpui.Fonts.Orgs.Check", w * 0.5, h * 0.5, Color(0,0,0,a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        end
                    end

                    perms.pnl = chk;
                end

                pnl.RankPanel.RegisterRank = vgui.Create( "DButton", pnl.RankPanel.Foreground );
                pnl.RankPanel.RegisterRank.Dock( pnl.RankPanel.RegisterRank, TOP );
                pnl.RankPanel.RegisterRank.DockMargin( pnl.RankPanel.RegisterRank, 0, self.frameSpacing * 0.25, 0, 0 );
                pnl.RankPanel.RegisterRank.SetFont( pnl.RankPanel.RegisterRank, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.RegisterRank.SetText( pnl.RankPanel.RegisterRank, translates.Get("ДОБАВИТЬ") );
                pnl.RankPanel.RegisterRank.SizeToContentsY( pnl.RankPanel.RegisterRank, self.frameSpacing * 0.5 );
                pnl.RankPanel.RegisterRank.InvalidateParent( pnl.RankPanel.RegisterRank, true );
                pnl.RankPanel.RegisterRank.Paint = function( this35, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this35 );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this35:GetText(), this35:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                pnl.RankPanel.RegisterRank.DoClick = function( this36 )
                    local name         = pnl.RankPanel.Name.GetText(pnl.RankPanel.Name);

                    -- what?
                    if (!self.OrgRanks or !self.OrgRanks[#self.OrgRanks - 1]) then return end

                    if self.OrgRankRef[name] then
                        return rp.Notify(NOTIFY_ERROR, translates.Get('Ранг с таким именем уже существует!'))
                    end

                    local weight       = self.OrgRanks[#self.OrgRanks - 1].Weight - 1;
                    local invite       = rankperms["Invite"].pnl.GetChecked(rankperms["Invite"].pnl);
                    local kick         = rankperms["Kick"].pnl.GetChecked(rankperms["Kick"].pnl);
                    local canrank      = rankperms["Rank"].pnl.GetChecked(rankperms["Rank"].pnl);
                    local motd         = rankperms["MoTD"].pnl.GetChecked(rankperms["MoTD"].pnl);
                    local cancapture   = rankperms["CanCapture"].pnl.GetChecked(rankperms["CanCapture"].pnl);
                    local candiplomacy = rankperms["CanDiplomacy"].pnl.GetChecked(rankperms["CanDiplomacy"].pnl);
                    local canstorage = rankperms["CanStorage"].pnl.GetChecked(rankperms["CanStorage"].pnl);

                    rp.RunCommand( "orgrank",
                        name,
                        tostring( weight ),
                        invite       and "1" or "0",
                        kick         and "1" or "0",
                        canrank      and "1" or "0",
                        motd         and "1" or "0",
                        cancapture   and "1" or "0",
                        candiplomacy and "1" or "0",
                        canstorage   and "1" or "0"
                    );

                    if #self.OrgRanks < (LocalPlayer():HasUpgrade("org_prem") and 16 or 5) then
                        self.OrgRankRef[name] = self.OrgRanks[ table.insert(self.OrgRanks, {
                            Weight       = weight,
                            Name         = name,
                            Invite       = invite,
                            Kick         = kick,
                            Rank         = canrank,
                            MoTD         = motd,
                            CanCapture   = cancapture,
                            CanDiplomacy = candiplomacy,
                            CanStorage   = canstorage,
                        }) ];
                    end

                    self:PopulateRanks();

                    pnl.RankPanel.Close(pnl.RankPanel);
                end

                pnl.RankPanel.Foreground.InvalidateLayout( pnl.RankPanel.Foreground, true );
                pnl.RankPanel.Foreground.SizeToChildren( pnl.RankPanel.Foreground, false, true );

                pnl.RankPanel.InvalidateLayout( pnl.RankPanel, true );
                pnl.RankPanel.SizeToChildren( pnl.RankPanel, false, true );

                local x, y = self:ScreenToLocal( pnl:LocalToScreen() );
                pnl.RankPanel.SetPos( pnl.RankPanel, x, y - pnl.RankPanel.GetTall(pnl.RankPanel) - self.frameSpacing * 0.25 );
            end
        end

        self.CenterContainer.ChangeRank = vgui.Create( "DButton", self.CenterContainer );
        self.CenterContainer.ChangeRank.Dock( self.CenterContainer.ChangeRank, BOTTOM );
        self.CenterContainer.ChangeRank.DockMargin( self.CenterContainer.ChangeRank, 0, self.frameSpacing * 0.5, 0, 0 );
        self.CenterContainer.ChangeRank.SetFont( self.CenterContainer.ChangeRank, "rpui.Fonts.Orgs.Button" );
        self.CenterContainer.ChangeRank.SetText( self.CenterContainer.ChangeRank, translates.Get("ИЗМЕНИТЬ РАНГ") );
        self.CenterContainer.ChangeRank.SizeToContentsY( self.CenterContainer.ChangeRank, self.frameSpacing * 0.5 );
        self.CenterContainer.ChangeRank.InvalidateParent( self.CenterContainer.ChangeRank, true );
        self.CenterContainer.ChangeRank.Paint = function( this37, w, h )
            if not self.SelectedRank then
                if this37:IsEnabled() then this37:SetEnabled( false ); end
            else
                if not this37:IsEnabled() then this37:SetEnabled( true ); end
            end

            local baseColor, textColor = rpui.GetPaintStyle( this37, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this37:GetText(), this37:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true;
        end
        self.CenterContainer.ChangeRank.DoClick = function( pnl )
            if not pnl.RankPanel and IsValid(self.SelectedRank) then
                local rank = self.SelectedRank.Rank;

                pnl.Editable = true;

                pnl.RankPanel = vgui.Create( "Panel", self );
                pnl.RankPanel.SetWide( pnl.RankPanel, pnl:GetWide() );
                pnl.RankPanel.Close = function( this38 )
                    this38.Closing = true;
                    this38:Stop();
                    this38:AlphaTo( 0, 0.25, 0, function()
                        if IsValid( this38 ) then this38:Remove(); end
                        pnl.RankPanel = nil;
                    end );
                end
                pnl.RankPanel.Think = function( this39 )
                    if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and (not this39.Closing) and (not this39.WasHovered) then
                        if (not this39:IsHovered() and not this39:IsChildHovered()) then
                            this39:Close();
                        end
                    end

                    local this39_Hovered = this39:IsHovered() or this39:IsChildHovered();
                    if input.IsMouseDown( MOUSE_LEFT ) then
                        if this39_Hovered and (not this39.WasHovered) then this39.WasHovered = true; end
                    else
                        if this39.WasHovered then this39.WasHovered = nil; end
                    end
                end

                pnl.RankPanel.Foreground = vgui.Create( "Panel", pnl.RankPanel );
                pnl.RankPanel.Foreground.Dock( pnl.RankPanel.Foreground, TOP );
                pnl.RankPanel.Foreground.DockPadding( pnl.RankPanel.Foreground, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5, self.frameSpacing * 0.5 );
                pnl.RankPanel.Foreground.InvalidateParent( pnl.RankPanel.Foreground, true );
                pnl.RankPanel.Foreground.Paint = function( this40, w, h )
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawRect( 0, 0, w, h );
                end

                pnl.RankPanel.BottomArrow = vgui.Create( "Panel", pnl.RankPanel );
                pnl.RankPanel.BottomArrow.Dock( pnl.RankPanel.BottomArrow, TOP );
                pnl.RankPanel.BottomArrow.SetTall( pnl.RankPanel.BottomArrow, self.frameSpacing );
                pnl.RankPanel.BottomArrow.InvalidateParent( pnl.RankPanel.BottomArrow, true );
                pnl.RankPanel.BottomArrow.Paint = function( this41, w, h )
                    draw.NoTexture();
                    surface.SetDrawColor( Color(0,0,0,200) );
                    surface.DrawPoly( {{x = w * 0.5 - h * 0.5, y = 0}, {x = w * 0.5 + h * 0.5, y = 0}, {x = w * 0.5, y = h}} );
                end

                pnl.RankPanel.NameLabel = vgui.Create( "DLabel", pnl.RankPanel.Foreground );
                pnl.RankPanel.NameLabel.Dock( pnl.RankPanel.NameLabel, TOP );
                pnl.RankPanel.NameLabel.DockMargin( pnl.RankPanel.NameLabel, 0, 0, 0, self.frameSpacing * 0.25 );
                pnl.RankPanel.NameLabel.SetFont( pnl.RankPanel.NameLabel, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.NameLabel.SetTextColor( pnl.RankPanel.NameLabel, rpui.UIColors.White );
                pnl.RankPanel.NameLabel.SetText( pnl.RankPanel.NameLabel, translates.Get("НАЗВАНИЕ") );
                pnl.RankPanel.NameLabel.SizeToContentsY(pnl.RankPanel.NameLabel);
                pnl.RankPanel.NameLabel.InvalidateParent( pnl.RankPanel.NameLabel, true );

                pnl.RankPanel.Name = vgui.Create( "DTextEntry", pnl.RankPanel.Foreground );
                pnl.RankPanel.Name.Dock( pnl.RankPanel.Name, TOP );
                pnl.RankPanel.Name.DockMargin( pnl.RankPanel.Name, 0, 0, 0, self.frameSpacing * 0.5 );
                pnl.RankPanel.Name.SetZPos( pnl.RankPanel.Name, 0 );
                pnl.RankPanel.Name.SetFont( pnl.RankPanel.Name, "rpui.Fonts.Orgs.MenuSmall" );
                pnl.RankPanel.Name.SetText( pnl.RankPanel.Name, self.SelectedRank.Rank.Name );
                pnl.RankPanel.Name.SizeToContentsY(pnl.RankPanel.Name);
                pnl.RankPanel.Name.InvalidateParent( pnl.RankPanel.Name, true );
                pnl.RankPanel.Name.Paint = function( this42, w, h )
                    surface.SetDrawColor( rpui.UIColors.White );
                    surface.DrawRect( 0, 0, w, h );

                    if #this42:GetValue() <= 0 and !this42:HasFocus() then
                        draw.SimpleText( this42:GetPlaceholderText(), this42:GetFont(), 0, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                    else
                        this42:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Pink, rpui.UIColors.Black );
                    end
                end

                pnl.RankPanel.PermsLabel = vgui.Create( "DLabel", pnl.RankPanel.Foreground );
                pnl.RankPanel.PermsLabel.Dock( pnl.RankPanel.PermsLabel, TOP );
                pnl.RankPanel.PermsLabel.DockMargin( pnl.RankPanel.PermsLabel, 0, 0, 0, self.frameSpacing * 0.25 );
                pnl.RankPanel.PermsLabel.SetFont( pnl.RankPanel.PermsLabel, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.PermsLabel.SetTextColor( pnl.RankPanel.PermsLabel, rpui.UIColors.White );
                pnl.RankPanel.PermsLabel.SetText( pnl.RankPanel.PermsLabel, translates.Get("ПОЛНОМОЧИЯ") );
                pnl.RankPanel.PermsLabel.SizeToContentsY(pnl.RankPanel.PermsLabel);
                pnl.RankPanel.PermsLabel.InvalidateParent( pnl.RankPanel.PermsLabel, true );

                local rankperms = {
                    ["Invite"]       = { name = translates.Get("Приглашать") },
                    ["Kick"]         = { name = translates.Get("Выгонять") },
                    ["Rank"]         = { name = translates.Get("Ред. ранги") },
                    ["MoTD"]         = { name = translates.Get("Ред. новости") },
                    ["CanCapture"]   = { name = translates.Get("Захват точек") },
                    ["CanDiplomacy"] = { name = translates.Get("Дипломатия") },
                    ["CanStorage"]   = { name = translates.Get("Исп. склада") },
                };

                for key2, perms2 in pairs( rankperms ) do
                    local chk = vgui.Create( "DCheckBoxLabel", pnl.RankPanel.Foreground );
                    chk:Dock( TOP );
                    chk:DockMargin( 0, 0, 0, self.frameSpacing * 0.25 );
                    chk:SetFont( "rpui.Fonts.Orgs.MenuSmall" );
                    chk:SetTextColor( rpui.UIColors.White );
                    chk:SetText( perms2.name );
                    chk:SetChecked( self.SelectedRank.Rank[key2] );
                    chk:InvalidateParent( true );

                    chk.Button.BaseAlpha    = chk:GetChecked() and 1 or 0;
                    chk.Button.HoveredAlpha = chk:GetChecked() and 1 or 0;

                    chk.Button.Paint = function( this43, w, h )
                        local ft = FrameTime();

                        this43.BaseAlpha = math.Approach( this43.BaseAlpha, chk:GetChecked() and 1 or 0, ft * 4 );
                        this43.HoveredAlpha = math.Approach( this43.HoveredAlpha, (chk:GetChecked() or this43:IsHovered()) and 1 or 0, ft * 4 );

                        if this43.BaseAlpha < 1 then
                            surface.SetDrawColor( rpui.UIColors.Background );
                            surface.DrawRect( 0, 0, w, h );

                            local bs = rpui.PowOfTwo( h * 0.1 );
                            surface.SetDrawColor( Color(255,255,255,8 + this43.HoveredAlpha * 247) );
                            surface.DrawRect( 0, 0, w, bs );
                            surface.DrawRect( 0, h - bs, w, bs );
                            surface.DrawRect( 0, bs, bs, h-bs*2 );
                            surface.DrawRect( w - bs, bs, bs, h-bs*2 );
                        end

                        if this43.BaseAlpha > 0 then
                            local a = this43.BaseAlpha * 255;
                            surface.SetDrawColor( Color(255,255,255,a) );
                            surface.DrawRect( 0, 0, w, h );
                            draw.SimpleText( "✔", "rpui.Fonts.Orgs.Check", w * 0.5, h * 0.5, Color(0,0,0,a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        end
                    end

                    if rank.Weight == 100 or rank.Weight == 1 then
                        chk:SetMouseInputEnabled( false );
                    end

                    perms2.pnl = chk;
                end

                pnl.RankPanel.RegisterRank = vgui.Create( "DButton", pnl.RankPanel.Foreground );
                pnl.RankPanel.RegisterRank.Dock( pnl.RankPanel.RegisterRank, TOP );
                pnl.RankPanel.RegisterRank.DockMargin( pnl.RankPanel.RegisterRank, 0, self.frameSpacing * 0.25, 0, 0 );
                pnl.RankPanel.RegisterRank.SetFont( pnl.RankPanel.RegisterRank, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.RegisterRank.SetText( pnl.RankPanel.RegisterRank, translates.Get("СОХРАНИТЬ") );
                pnl.RankPanel.RegisterRank.SizeToContentsY( pnl.RankPanel.RegisterRank, self.frameSpacing * 0.5 );
                pnl.RankPanel.RegisterRank.InvalidateParent( pnl.RankPanel.RegisterRank, true );
                pnl.RankPanel.RegisterRank.Paint = function( this44, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this44 );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this44:GetText(), this44:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                pnl.RankPanel.RegisterRank.DoClick = function( this45 )
                    local name = pnl.RankPanel.Name.GetText(pnl.RankPanel.Name);

                    if rank.Name ~= name and self.OrgRankRef[name] then
                        return rp.Notify(NOTIFY_ERROR, translates.Get('Ранг с таким именем уже существует!'))
                    end

                    local invite       = rankperms["Invite"].pnl.GetChecked(rankperms["Invite"].pnl);
                    local kick         = rankperms["Kick"].pnl.GetChecked(rankperms["Kick"].pnl);
                    local canrank      = rankperms["Rank"].pnl.GetChecked(rankperms["Rank"].pnl);
                    local motd         = rankperms["MoTD"].pnl.GetChecked(rankperms["MoTD"].pnl);
                    local cancapture   = rankperms["CanCapture"].pnl.GetChecked(rankperms["CanCapture"].pnl);
                    local candiplomacy = rankperms["CanDiplomacy"].pnl.GetChecked(rankperms["CanDiplomacy"].pnl);
                    local canstorage = rankperms["CanStorage"].pnl.GetChecked(rankperms["CanStorage"].pnl);

                    if
                        invite ~= rank.Invite or
                        kick ~= rank.Kick or
                        canrank ~= rank.Kick or
                        motd ~= rank.MoTD or
                        cancapture ~= rank.CanCapture or
                        candiplomacy ~= rank.CanDiplomacy or
                        canstorage ~= rank.CanStorage
                    then
                        rp.RunCommand( "orgrank",
                            rank.Name,
                            tostring( rank.Weight ),
                            invite       and "1" or "0",
                            kick         and "1" or "0",
                            canrank      and "1" or "0",
                            motd         and "1" or "0",
                            cancapture   and "1" or "0",
                            candiplomacy and "1" or "0",
                            canstorage   and "1" or "0"
                        );

                        rank.Invite       = invite;
                        rank.Kick         = kick;
                        rank.Rank         = canrank;
                        rank.MoTD         = motd;
                        rank.CanCapture   = cancapture;
                        rank.CanDiplomacy = candiplomacy;
                        rank.CanStorage   = canstorage;
                    end

                    if rank.Name ~= name then
                        rp.RunCommand( "orgrank", rank.Name, name );

                        for k7, v7 in ipairs( self.OrgMembers ) do
                            if v7.Rank == rank.Name then
                                v7.Rank = name;
                            end
                        end

                        rank.Name = name;
                    end

                    self:PopulateRanks();

                    pnl.RankPanel.Close(pnl.RankPanel);
                end


                local rem_text = translates.Get("УДАЛИТЬ")
                pnl.RankPanel.RemoveRank = vgui.Create( "DButton", pnl.RankPanel.Foreground );
                pnl.RankPanel.RemoveRank.Dock( pnl.RankPanel.RemoveRank, TOP );
                pnl.RankPanel.RemoveRank.DockMargin( pnl.RankPanel.RemoveRank, 0, self.frameSpacing * 0.25, 0, 0 );
                pnl.RankPanel.RemoveRank.SetFont( pnl.RankPanel.RemoveRank, "rpui.Fonts.Orgs.Menu" );
                pnl.RankPanel.RemoveRank.SetEnabled( pnl.RankPanel.RemoveRank, rank.Weight > 1 and rank.Weight < 100 );
                pnl.RankPanel.RemoveRank.SetText( pnl.RankPanel.RemoveRank, rem_text );
                pnl.RankPanel.RemoveRank.SizeToContentsY( pnl.RankPanel.RemoveRank, self.frameSpacing * 0.5 );
                pnl.RankPanel.RemoveRank.InvalidateParent( pnl.RankPanel.RemoveRank, true );
                pnl.RankPanel.RemoveRank.Paint = function( this47, w, h )
                    if this47.LastPress and CurTime() - this47.LastPress > 2 then
                        this47:SetText(rem_text)
                        this47.LastPress = nil
                    end

                    local baseColor, textColor = rpui.GetPaintStyle( this47 );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this47:GetText(), this47:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                pnl.RankPanel.RemoveRank.DoClick = function( this48 )
                    if this48:GetText() == rem_text then
                        this48:SetText(translates.Get('ПОДТВЕРДИТЕ'))
                        this48.LastPress = CurTime()
                    else
                        this48:SetText(rem_text)
                        rp.RunCommand( "orgrankremove", rank.Name )

                        for k, v in pairs(self.OrgRanks) do
                            if v.Name and v.Name == rank.Name then
                                self.OrgRanks[k] = nil
                                break
                            end
                        end

                        self:PopulateRanks();
                        pnl.RankPanel.Close(pnl.RankPanel);
                    end
                end

                pnl.RankPanel.Foreground.InvalidateLayout( pnl.RankPanel.Foreground, true );
                pnl.RankPanel.Foreground.SizeToChildren( pnl.RankPanel.Foreground, false, true );

                pnl.RankPanel.InvalidateLayout( pnl.RankPanel, true );
                pnl.RankPanel.SizeToChildren( pnl.RankPanel, false, true );

                local x, y = self:ScreenToLocal( pnl:LocalToScreen() );
                pnl.RankPanel.SetPos( pnl.RankPanel, x, y - pnl.RankPanel.GetTall(pnl.RankPanel) - self.frameSpacing * 0.25 );
            end
        end
    end

    self.CenterContainer.RankList = vgui.Create( "rpui.ScrollPanel", self.CenterContainer );
    self.CenterContainer.RankList.Dock( self.CenterContainer.RankList, FILL );
    self.CenterContainer.RankList.SetScrollbarMargin( self.CenterContainer.RankList, self.frameSpacing * 0.5 );
    self.CenterContainer.RankList.InvalidateParent( self.CenterContainer.RankList, true );
    self.CenterContainer.RankList.Paint = function( this46, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );
    end

    self:PopulateRanks();
end


vgui.Register( "rpui.OrganisationMenu", PANEL, "Panel" );