-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_seasonpass_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local HSVToColor = HSVToColor
local hue, RainbowColor, RainbowRotate, BGColor

local seasonpass_color 			= rpui.UIColors.Gold
local seasonpass_second_color 	= rpui.UIColors.BackgroundGold
local seasonpass_back_color 	= Color(255, 255, 255, 255) --Color(132, 138, 148, 255)
local seasonpass_title_color 	= Color(255, 60, 115, 255)
local seasonpass_default_tab 	= Color(170, 200, 235, 255)
local shadow_color 				= Color(0, 0, 0, 250)

local tab_bg_material 			= Material("rpui/seasonpass/tab_bg")
local tab_prem_bg_material 		= Material("rpui/seasonpass/tab_prem_bg")
local lock_material 			= Material("rpui/seasonpass/tab_locked")
local check_mark_material 		= Material("rpui/seasonpass/tab_received")
local pin_on_material 			= Material('rpui/seasonpass/pin_on')
local pin_off_material 			= Material('rpui/seasonpass/pin_off')
local circle_material 			= Material('rpui/seasonpass/circle')
local prem_back_mat 			= Material('premium/new_selector')

local cvar_pin_name = 'spass_pin'
local cvar_Get = cvar.GetValue


local PANEL = {}

PANEL.ParallaxElements = {
    {
        x = 0, y = 0,
        sizew  = 1.05,
        sizeh  = 1.05,
        mat    = Material("rpui/seasonpass/chinese/back.png"),
        range  = 0.1,
        speed  = 0.3,
    },
    {
        x = 0, y = 0,
        sizew  = 1.05,
        sizeh  = 1.05,
        mat    = Material("rpui/seasonpass/chinese/parallax.png"),
        range  = 0.1,
        speed  = 1,
    },
}

local function update_fonts(frameW, frameH)
	local season = rp.seasonpass.GetSeason()

    surface.CreateFont("rpui.Fonts.Seasonpass.Title", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 700,
        size     = math.ceil(frameH * 0.102 * (season and season.LogoNameMult or 1)),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.SubTitle", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 600,
        size     = math.ceil(frameH * 0.084 * (season and season.LogoNameMult or 1)),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.TimeTitle", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.max(math.ceil(frameH * 0.026), 16),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.QuestText", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.max(math.ceil(frameH * 0.026), 15),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.QuestTitle", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.038),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.PremiumButton", {
        font     = "Montserrat",
        extended = true,
        weight   = 900,
        size     = math.ceil(frameH * 0.038),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.MainLevel", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.ceil(frameH * 0.068),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.SubLevel", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.027),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.TitlePremium", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.054),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.TitleBuyLevel", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.144),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.Progress", {
        font     = "Montserrat",
        extended = true,
        weight   = 500,
        size     = math.ceil(frameH * 0.027),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitleUsual", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.03),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitlePremium", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.max(math.ceil(frameH * 0.019 * (season and season.RPPassNameMult or 1)), 11),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadTitlePremium2", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.max(math.ceil(frameH * 0.022 * (season and season.RPPassNameMult or 1)), 12),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadSeason", {
        font     = "Montserrat",
        extended = true,
        weight   = 400,
        size     = math.ceil(frameH * 0.03),
    })
    surface.CreateFont("rpui.Fonts.Seasonpass.HeadSeasonNamel", {
        font     = "Montserrat",
        extended = true,
        weight   = 400,
        size     = math.max(math.ceil(frameH * 0.02 * (season and season.RPPassSeasonNameMult or 1)), 11),
    })
    surface.CreateFont( "rpui.Fonts.Seasonpass.Small", {
        font     = "Montserrat",
        extended = true,
        weight 	 = 500,
        size     = math.ceil(frameH * 0.025),
    })
    surface.CreateFont( "rpui.Fonts.Seasonpass.Tooltip", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.max(math.ceil(frameH * 0.0175), 14),
    } );

	if season and season.Shadows then
		surface.CreateFont("rpui.Fonts.Seasonpass.SHeadSeason", {
			font     = "Montserrat",
			extended = true,
			weight   = 400,
			size     = math.ceil(frameH * 0.03),
			blursize = 3,
		})
		surface.CreateFont("rpui.Fonts.Seasonpass.SHeadSeasonNamel", {
			font     = "Montserrat",
			extended = true,
			weight   = 400,
			size     = math.max(math.ceil(frameH * 0.02 * (season and season.RPPassSeasonNameMult or 1)), 11),
			blursize = 3,
		})
		surface.CreateFont("rpui.Fonts.Seasonpass.SHeadTitleUsual", {
			font     = "Montserrat",
			extended = true,
			weight   = 700,
			size     = math.ceil(frameH * 0.03),
			blursize = 3,
		})
		surface.CreateFont("rpui.Fonts.Seasonpass.STitle", {
			font     = "Montserrat",
			extended = true,
			weight 	 = 400,
			size     = math.ceil(frameH * 0.102 * (season and season.LogoNameMult or 1)),
			blursize = 3,
		})
		surface.CreateFont("rpui.Fonts.Seasonpass.SSubTitle", {
			font     = "Montserrat",
			extended = true,
			weight 	 = 400,
			size     = math.ceil(frameH * 0.084 * (season and season.LogoNameMult or 1)),
			blursize = 3,
		})
		surface.CreateFont("rpui.Fonts.Seasonpass.STimeTitle", {
			font     = "Montserrat",
			extended = true,
			weight   = 500,
			size     = math.max(math.ceil(frameH * 0.026), 16),
			blursize = 3,
		})
	end
end

function PANEL:RebuildFonts(frameW, frameH)
	update_fonts(frameW, frameH)
end

TOOLTIP_OFFSET_LEFT = 1 / 10
TOOLTIP_OFFSET_CENTER = 1 / 2
function PANEL:RegisterTooltip( panel, textfunc, offset, parentwidth, posfunc )
    if not self.Tooltip then
        self.Tooltip = vgui.Create( "Panel", self );
        local tooltip = self.Tooltip;

        tooltip:SetMouseInputEnabled( false );
        tooltip:SetAlpha( 0 );
        tooltip.ArrowHeight = 0.01 * self.frameH;
        tooltip:DockPadding( self.frameW * 0.0075, self.frameH * 0.005, self.frameW * 0.0075, self.frameH * 0.005 + self.Tooltip.ArrowHeight );

        self.Tooltip.Label = vgui.Create( "DLabel", self.Tooltip );
        local label = self.Tooltip.Label;

        label:Dock( TOP );
        label:SetWrap( true );
        label:SetAutoStretchVertical( true );
        label:SetFont( "rpui.Fonts.Seasonpass.Tooltip" );
        label:SetTextColor( rpui.UIColors.White );
        label:SetText( "" );

        tooltip.TooltipOffset = -1;
        tooltip.IsActive      = false;

        tooltip.Paint = function( this, w, h )
            if string.Trim(this.Label.GetText(this.Label)) ~= "" then
                surface.SetDrawColor( rpui.UIColors.Tooltip );
                surface.DrawRect( 0, 0, w, h - this.ArrowHeight );

                if this.BakedPoly then
                    draw.NoTexture();
                    surface.DrawPoly( this.BakedPoly );
                end
            end
        end

        tooltip.Think = function( this )
            if IsValid( this.ActivePanel ) then
                if not this.IsActive then
                    this.IsActive = true;
                    this:Stop();
                    this:SetAlpha( 0 );

                    this:SetWide( this.ActivePanel.GetWide(this.ActivePanel) );

                    this.Label.SetText( this.Label, isfunction(this.ActivePanel.TooltipText) and this.ActivePanel.TooltipText(this.ActivePanel) or this.ActivePanel.TooltipText );
                    this.Label.SizeToContents(this.Label);

                    if not this.ActivePanel.TooltipWidth then
                        surface.SetFont( this.Label.GetFont(this.Label) );
                        local text_w, text_h = surface.GetTextSize( this.Label.GetText(this.Label) );
                        local pl, pt, pr, pb = this:GetDockPadding();
                        this:SetWide( pl + text_w + pr );
                    end

                    timer.Simple( FrameTime() * 10, function()
                        if not IsValid( self ) then return end

                        if not IsValid(this.ActivePanel) then return end

                        this:SizeToChildren( false, true );

                        local x, y, w, h, x2, y2 = 0, 0, 0, 0, 0, 0;

                        if this.ActivePanel.TooltipPosFunc then
                            x, y = this.ActivePanel.TooltipPosFunc(this.ActivePanel);
                        else
                            x, y = this.ActivePanel.LocalToScreen( this.ActivePanel, 0, 0 );
                            x2, y2 = self.LocalToScreen( self, 0, 0 );

							x = x - x2
							y = y - y2
                        end

                        w, h = this:GetSize();

                        this:AlphaTo( 255, 0.25 );

                        this.TooltipOffset = this.ActivePanel.TooltipOffset;
                        this.BakedPoly = {
                            { x = w * this.TooltipOffset - this.ArrowHeight/2, y = h - this.ArrowHeight - 1 },
                            { x = w * this.TooltipOffset + this.ArrowHeight/2, y = h - this.ArrowHeight - 1 },
                            { x = w * this.TooltipOffset,                      y = h },
                        };

                        if this.TooltipOffset == TOOLTIP_OFFSET_CENTER then
                            this.Label.SetContentAlignment( this.Label, 5 );
                            if not this.ActivePanel.TooltipPosFunc then
                                this:SetPos( x - w * 0.5 + this.ActivePanel.GetWide(this.ActivePanel) * 0.5, y - h - self.frameH * 0.0015 );
                            else
                                this:SetPos( x - w * 0.5, y - h - self.frameH * 0.0015 );
                            end
                        else
                            this.Label.SetContentAlignment( this.Label, 4 );
                            this:SetPos( x, y - h - self.frameH * 0.0015 );
                        end

                        this.PrevActivePanel = this.ActivePanel;
                    end );
                end
            else
                if this.IsActive then
                    this:AlphaTo( 0, 0.1, 0, function()
                        if IsValid( this ) then
                            this.IsActive        = false;
                            this.PrevActivePanel = nil;
                        end
                    end );
                end
            end
        end
    end

    if IsValid( panel ) then
        panel.TooltipText     = textfunc;
        panel.TooltipOffset   = offset or TOOLTIP_OFFSET_CENTER;
        panel.TooltipWidth    = parentwidth or false;
        panel.TooltipPosition = {x = 0, y = 0};
        panel.TooltipPosFunc  = posfunc or nil;

        panel._OnCursorEntered = self.OnCursorEntered;
        panel._OnCursorExited  = self.OnCursorExited;

        panel.OnCursorEntered = function( this )
            if this._OnCursorEntered then
                this._OnCursorEntered();
            end

            if IsValid( self.Tooltip ) then
				self.Tooltip.ActivePanel = this;
				self.Tooltip.IsActive = nil
			end
        end

        panel.OnCursorExited = function( this )
            if this._OnCursorExited then
                this._OnCursorExited();
            end

            if IsValid( self.Tooltip ) and self.Tooltip.ActivePanel == this then
				self.Tooltip.ActivePanel = nil
			end
        end
    end
end

function PANEL:Init()
	if IsValid(rp.seasonpass.Menu) then
		rp.seasonpass.Menu.Remove(rp.seasonpass.Menu)
	end

	self.UIColors = self.UIColors or {}
	self.UIColors.White = rpui.UIColors.White

	rp.seasonpass.Menu = self

    self:SetAlpha(0)

    timer.Simple(FrameTime() * 5, function()
        if not IsValid(self) then return end

		local season 			= LocalPlayer():GetSeason()
        local frameW, frameH 	= self:GetSize()

		if not season then
			self:Remove()
			return
		end

		frameH = 0.75 * ScrH()
		local rframeH = frameH

		local current_level = LocalPlayer():SeasonGetLevel()
		local max_levels 	= season.MaxLevel
		local max_page 		= math.floor((max_levels - 1) / 7) + 1

		local rate = 1.2 * frameH / 1080

		local current_score = -1 / 10
		local targed_score	= LocalPlayer():SeasonGetProgress()
		local needed_score 	= season:GetLevelupScore(LocalPlayer())
		local awards_avlb 	= table.Copy(LocalPlayer():SeasonGetRewards())
		local is_donated 	= LocalPlayer():SeasonIsDonated()

		self.awards_avlb = awards_avlb

		self.Season 		= season
		self.MaxLevels 		= max_levels
		self.LevelsLoaded	= 0
		self.CurrentPage 	= 1

		if season.Color then
			seasonpass_back_color = season.Color
		end

		if season.ParallaxElements then
			self.ParallaxElements = season.ParallaxElements
		end

        self.frameW = frameW
        self.frameH = frameH

        self.innerPadding = 0.02 * frameH

        self:RebuildFonts(frameW, frameH)

        self:DockPadding(self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding)

        self.Header = vgui.Create("Panel", self)
		local header = self.Header
        header:Dock(TOP)
        header:DockMargin(self.innerPadding * 2, 0, self.innerPadding * 2, 0)
        header:SetTall(frameH * 0.1)
        header:InvalidateParent(true)

		local loc_pos_x = ScrW() * 0.5 - 0.5 * frameW
		local loc_pos_y = ScrH() * 0.5 - 0.5 * rframeH

		self.Background = vgui.Create("DPanel")
		local background = self.Background
		background:SetSize(ScrW(), ScrH())
		background.Paint = function(pp, pw, ph)
			if not BGColor then return end

			if not IsValid(self) then
				pp:Remove()
				return
			end

			local alpha_cur = self:GetAlpha()
			local is_not_chome = (BRANCH ~= "x86-64")

			surface.SetAlphaMultiplier(alpha_cur / 255)
				if season.BackMaterial then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(season.BackMaterial)
					surface.DrawTexturedRect((ScrW() - frameW) * 0.5, (ScrH() - rframeH) * 0.5, frameW, rframeH)

				elseif season.BackColor then
					surface.SetDrawColor(season.BackColor)
					surface.DrawRect((ScrW() - frameW) * 0.5, (ScrH() - rframeH) * 0.5, frameW, rframeH)
				end

				local mX, mY = self:LocalCursorPos()

				mX = mX - 0.5 * frameW
				mY = mY - 0.5 * rframeH

				render.SetScissorRect((ScrW() - frameW) * 0.5, (ScrH() - rframeH) * 0.5, (ScrW() + frameW) * 0.5, (ScrH() + rframeH) * 0.5, true)

				for _, e in pairs( self.ParallaxElements ) do
					if e.frame_func then
						e.frame_func(e, self, frameW, rframeH)

					else
						e.x = Lerp( 0.005 * e.speed, e.x, mX * e.range * 0.5 )
						e.y = Lerp( 0.005 * e.speed, e.y, mY * e.range * 0.5 )

						local sw = frameW * (e.sizew or 1)
						local sh = rframeH * (e.sizeh or 1)

						local max_off_x = (sw - frameW) / 4
						local max_off_y = (sh - rframeH) / 4

						if max_off_x > 0 then
							e.x = math.Clamp(e.x, -max_off_x, max_off_x)
						end

						if max_off_y > 0 then
							e.y = math.Clamp(e.y, -max_off_y, max_off_y)
						end

						surface.SetDrawColor(BGColor)
						surface.SetMaterial((e.error_mat and is_not_chome) and e.error_mat or e.mat);
						surface.DrawTexturedRect(loc_pos_x + e.x + frameW * 0.5 - sw * 0.5, loc_pos_y + e.y + rframeH * 0.5 - sh * 0.5, sw, sh)
					end
				end

				if season.DarkMode then
					surface.SetDrawColor(Color(0, 0, 0, season.DarkMode * 500))
					surface.DrawRect((ScrW() - frameW) * 0.5, (ScrH() - rframeH) * 0.5, frameW, rframeH)
					surface.SetDrawColor(Color(255, 255, 255, 255))
				end

				render.SetScissorRect(0, 0, 0, 0, false)

				if season.LogoMaterial then
					local size_x = season.LogoMaterial.Width(season.LogoMaterial) * rate * 1.3 * (season.LogoMaterialMult or 1)
					local size_y = season.LogoMaterial.Height(season.LogoMaterial) * rate * 1.3 * (season.LogoMaterialMult or 1)

					surface.SetMaterial(season.LogoMaterial)
					surface.DrawTexturedRect((ScrW() - frameW) * 0.5 + (season.LogoOffset and season.LogoOffset.x or 0) * rate, (ScrH() - rframeH) * 0.5 + (season.LogoOffset and season.LogoOffset.y or 0) * rate, size_x, size_y)
				end
			surface.SetAlphaMultiplier(1)
		end
		background.DoClick = function() end
		background:MakePopup()

		self.MakePopup(self)
		self.DoModal(self)

		local header_stitle
		if season.Shadows then
			header.ShadowTitle = vgui.Create("DLabel", header)
			header_stitle = header.ShadowTitle
			header_stitle:Dock(LEFT)
			header_stitle:DockMargin(season.LogoNameOffsetX and season.LogoNameOffsetX * rate or 0, 0, 0, 0)
			header_stitle:SetTextColor(shadow_color)
			header_stitle:SetFont("rpui.Fonts.Seasonpass.STitle")
			header_stitle:SetText(utf8.upper(season.pre_name) .. ":")
			header_stitle:SizeToContentsX()
			header_stitle:SizeToContentsY()
		end

		local header_title
		if season.Shadows then
			header.Title = vgui.Create("DLabel", header_stitle)
			header_title = header.Title
			header_title:Dock(LEFT)
			header_title:DockMargin(0, -1, 0, 1)

		else
			header.Title = vgui.Create("DLabel", header)
			header_title = header.Title
			header_title:Dock(LEFT)
			header_title:DockMargin(season.LogoNameOffsetX and season.LogoNameOffsetX * rate or 0, 0, 0, 0)
		end

        header_title:SetTextColor(self.UIColors.White or rpui.UIColors.White)
        header_title:SetFont("rpui.Fonts.Seasonpass.Title")
        header_title:SetText(utf8.upper(season.pre_name) .. ":")
        header_title:SizeToContentsX()
        header_title:SizeToContentsY()
		header_title.Paint = function( p, w, h )
			local clip = DisableClipping( true );
				draw.SimpleText( p:GetText(), p:GetFont(), w * 0.5, h * 0.5, p:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			DisableClipping( clip );

			return true;
		end

		local header_ssubtitle
		if season.Shadows then
			header.ShadowSubTitle = vgui.Create("DLabel", header)
			header_ssubtitle = header.ShadowSubTitle
			header_ssubtitle:Dock(LEFT)
			header_ssubtitle:DockMargin(self.innerPadding, 0, 0, 0)
			header_ssubtitle:SetTextColor(shadow_color)
			header_ssubtitle:SetFont("rpui.Fonts.Seasonpass.SSubTitle")
			header_ssubtitle:SetText(" " .. utf8.upper(season.name))
			header_ssubtitle:SizeToContentsX()
			header_ssubtitle:SizeToContentsY()
		end

		local header_subtitle
		if season.Shadows then
			header.SubTitle = vgui.Create("DLabel", header_ssubtitle)
			header_subtitle = header.SubTitle
			header_subtitle:Dock(LEFT)
			header_subtitle:DockMargin(0, -1, 0, 1)

		else
			header.SubTitle = vgui.Create("DLabel", header)
			header_subtitle = header.SubTitle
			header_subtitle:Dock(LEFT)
			header_subtitle:DockMargin(self.innerPadding, 0, 0, 0)
		end

        header_subtitle:SetTextColor(season.TitleColor or seasonpass_title_color)
        header_subtitle:SetFont("rpui.Fonts.Seasonpass.SubTitle")
        header_subtitle:SetText(" " .. utf8.upper(season.name))
        header_subtitle:SizeToContentsX()
        header_subtitle:SizeToContentsY()
		header_subtitle.Paint = function( p, w, h )
			local clip = DisableClipping( true );
				draw.SimpleText( p:GetText(), p:GetFont(), w * 0.5, h * 0.5, p:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
			DisableClipping( clip );

			return true;
		end

        header:SizeToChildren(false, true)

        header.CloseButton = vgui.Create("DButton", header)
		local header_closebutton = header.CloseButton
        header_closebutton:SetFont("rpui.Fonts.Seasonpass.Small")
        header_closebutton:SetText(translates.Get("ЗАКРЫТЬ"))
        header_closebutton:SizeToContentsY(frameH * 0.015)
        header_closebutton:SizeToContentsX(header_closebutton:GetTall() + frameW * 0.025)
        header_closebutton:SetPos(
            header:GetWide()       - header_closebutton:GetWide(),
            header:GetTall() * 0.5 - header_closebutton:GetTall() * 0.5
        )
        header_closebutton.Paint = function(this, w, h)
            local baseColor, textColor = self.GetPaintStyle(this)
            surface.SetDrawColor(baseColor)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(self.UIColors.White or rpui.UIColors.White)
            surface.DrawRect(0, 0, h, h)

            surface.SetDrawColor(Color(0,0,0,this._grayscale or 0))
            local p = 0.1 * h
            surface.DrawLine(h, p, h, h - p)

            draw.SimpleText("✕", "rpui.Fonts.Seasonpass.Small", h/2, h/2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(this:GetText(), this:GetFont(), w/2 + h/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            return true
        end

        header_closebutton.DoClick = function()
			self:Close()
		end

		local cb_pos_x, cb_pos_y = header_closebutton:GetPos()

		local header_stimetitle
		if season.Shadows then
			header.ShadowTimeTitle = vgui.Create("DLabel", header)
			header_stimetitle = header.ShadowTimeTitle
			header_stimetitle:SetFont("rpui.Fonts.Seasonpass.STimeTitle")
			header_stimetitle:SetTextColor(shadow_color)
			header_stimetitle:SetText(season.OverrideCheck and '' or (translates.Get("До конца сезона:") .. " " .. rp.seasonpass.PrettyTime(rp.seasonpass.GetSeasonTimeLeft())))
			header_stimetitle:SizeToContentsX()
			header_stimetitle:SizeToContentsY()
			header_stimetitle:SetPos(cb_pos_x - header_stimetitle:GetWide() - self.innerPadding * 1.5, cb_pos_y + self.innerPadding * 0.3)
		end

        header.TimeTitle = vgui.Create("DLabel", header)
		local header_timetitle = header.TimeTitle
        header_timetitle:SetFont("rpui.Fonts.Seasonpass.TimeTitle")
        header_timetitle:SetTextColor(Color(255, 255, 255, 255))
        header_timetitle:SetText(season.OverrideCheck and '' or (translates.Get("До конца сезона:") .. " " .. rp.seasonpass.PrettyTime(rp.seasonpass.GetSeasonTimeLeft())))
        header_timetitle:SizeToContentsX()
        header_timetitle:SizeToContentsY()
        header_timetitle:SetPos(cb_pos_x - header_timetitle:GetWide() - self.innerPadding * 1.5, cb_pos_y + self.innerPadding * 0.3 - 1)


		-- Quest bar
        self.Questholder = vgui.Create("DPanel", self)
		local questholder = self.Questholder
        questholder:Dock(RIGHT)
        questholder:DockMargin(0, self.innerPadding * 1.5, self.innerPadding * 2, self.innerPadding * 0.5 + (season.NoPremium and -self.innerPadding * 2.1 or 0))
        questholder:SetWide(math.ceil(frameW * 0.24))
        questholder:InvalidateParent(true)
		questholder.Paint = function() end
		questholder.Quests = {}

        questholder.Questbar = vgui.Create("DPanel", questholder)
		local questholder_questbar = questholder.Questbar
        questholder_questbar:Dock(FILL)
        questholder_questbar:SetWide(math.ceil(frameW * 0.24))
        questholder_questbar:InvalidateParent(true)
		questholder_questbar.Paint = function(sqb, sqb_w, sqb_h)
			if season.QuestsBackMat then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(season.QuestsBackMat)
				surface.DrawTexturedRect(0, 0, sqb_w, sqb_h)

			else
				surface.SetDrawColor(Color(0, 0, 0, 77))
				surface.DrawRect(0, 0, sqb_w, sqb_h)
			end
		end

		local function draw_RoundedPoly(ths, start_x, start_y, poly_w, poly_h, poly_id)
			ths.poly_pts = ths.poly_pts or {}
			local id = poly_id or 1

			if not ths.poly_pts[id] then
				local radius = 15
				local steps = 5

				local pi = math.pi
				local step = pi / (steps - 1) / 2
				local cur_pi = pi

				local corners = {
					{ start_x + radius, start_y + radius },
					{ start_x + poly_w - radius, start_y + start_y + radius },
					{ start_x + poly_w - radius, start_y + poly_h - radius },
					{ start_x + radius, start_y + poly_h - radius },
				}

				ths.poly_pts[id] = {}

				for i = 1, 4 do
					for j = 0, steps - 1 do
						table.insert(ths.poly_pts[id], {
							x = math.Round(corners[i][1] + radius * math.cos(cur_pi + j * step)),
							y = math.Round(corners[i][2] + radius * math.sin(cur_pi + j * step)),
						})
					end

					cur_pi = cur_pi + pi / 2
				end
			end

			surface.DrawPoly(ths.poly_pts[id])
		end

		local questholder_questbutton

		if season.RerollFormula or season.NoPremium then
			questholder.Questbutton = vgui.Create("DButton", questholder)
			questholder_questbutton = questholder.Questbutton
			questholder_questbutton:Dock(BOTTOM)
			questholder_questbutton:SetWide(math.ceil(frameW * 0.24))
			questholder_questbutton:InvalidateParent(true)
			questholder_questbutton:SetText("")

			if season.NoPremium then
				questholder_questbutton:SetCursor("arrow")
				questholder_questbutton:SetEnabled(false)
			end

			questholder_questbutton.Paint = function(sqb, sqb_w, sqb_h)
				if season.NoPremium then return end
				sqb._alpha = math.Approach(sqb._alpha or 0, (sqb:IsHovered() or sqb.Selected) and not sqb.DoingReroll and 255 or 0, 768 * FrameTime())

				render.SetStencilWriteMask( 255 );
				render.SetStencilTestMask( 255 );
				render.SetStencilReferenceValue( 0 );
				render.SetStencilPassOperation( STENCIL_KEEP );
				render.SetStencilZFailOperation( STENCIL_KEEP );
				render.ClearStencil();
				render.SetStencilEnable( true );
				render.SetStencilReferenceValue( 1 );
				render.SetStencilCompareFunction( STENCIL_NEVER );
				render.SetStencilFailOperation( STENCIL_REPLACE );

				draw.NoTexture();
				surface.SetDrawColor(rpui.UIColors.White)
				draw_RoundedPoly(sqb, 0, -20, sqb_w, sqb_h + 20)

				render.SetStencilCompareFunction( STENCIL_EQUAL );
				render.SetStencilFailOperation( STENCIL_KEEP );

				sqb.rotAngle = (sqb.rotAngle or 0) + 100 * FrameTime();

				surface.SetDrawColor( Color(0, 0, 0, 100) );
				surface.DrawRect( 0, 0, sqb_w, sqb_h );

				local distsize  = math.sqrt( sqb_w*sqb_w + sqb_h*sqb_h );
				local parentalpha = self.GetAlpha(self) / 255;
				local bs = rpui.PowOfTwo(sqb_h * 0.03);
				local alphamult = sqb._alpha / 255

				surface.SetAlphaMultiplier( parentalpha * alphamult );
					surface.SetDrawColor( RainbowColor );
					surface.DrawRect( 0, 0, sqb_w, sqb_h );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor( RainbowRotate );
					surface.DrawTexturedRectRotated( sqb_w * 0.5, sqb_h * 0.5, distsize, distsize, (sqb.rotAngle or 0) );
				surface.SetAlphaMultiplier( 1 );

				if self.QuestingReroll and self.QuestingReroll >= CurTime() then
					draw.SimpleText(translates.Get("Подтвердите"), "rpui.Fonts.Seasonpass.SubLevel", sqb_w * 0.5, sqb_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

				elseif self.DoingReroll then
					draw.SimpleText(translates.Get("Обновляем..."), "rpui.Fonts.Seasonpass.SubLevel", sqb_w * 0.5, sqb_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

					if self.DoingReroll ~= LocalPlayer():SeasonRerollsCount() then
						self.Questholder.DoQuests()
						self.DoingReroll = nil

						if IsValid(rp.seasonpass.HudPanel) then
							rp.seasonpass.HudPanel.Remove(rp.seasonpass.HudPanel)
						end

						sqb:Remove()
					end

				else
					draw.SimpleText(translates.Get("Обновить досрочно"), "rpui.Fonts.Seasonpass.SubLevel", sqb_w * 0.5, sqb_h * 0.5 + self.innerPadding * 0.05, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );

					local cost = season:GetRerollCost(LocalPlayer())

					draw.SimpleText((cost > 0) and (translates.Get("за") .. " " .. rp.FormatMoney(cost)) or translates.Get("Бесплатно"), "rpui.Fonts.Seasonpass.SubLevel", sqb_w * 0.5, sqb_h * 0.5 - self.innerPadding * 0.05, ColorAlpha(rpui.UIColors.White, self.GetAlpha(self)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
				end

				render.SetStencilEnable(false)
			end
			questholder_questbutton.PaintOver = function(sqb, sqb_w, sqb_h)
				if season.NoPremium then return end

				render.SetStencilWriteMask( 255 );
				render.SetStencilTestMask( 255 );
				render.SetStencilReferenceValue( 0 );
				render.SetStencilPassOperation( STENCIL_KEEP );
				render.SetStencilZFailOperation( STENCIL_KEEP );
				render.ClearStencil();
				render.SetStencilEnable( true );
				render.SetStencilReferenceValue( 1 );
				render.SetStencilCompareFunction( STENCIL_NEVER );
				render.SetStencilFailOperation( STENCIL_REPLACE );

				draw.NoTexture();
				surface.SetDrawColor(rpui.UIColors.White)
				draw_RoundedPoly(sqb, 0, -20, sqb_w, sqb_h + 20)

				render.SetStencilReferenceValue( 0 );

				draw_RoundedPoly(sqb, 2, -20, sqb_w - 4, sqb_h + 18, 2)

				render.SetStencilReferenceValue( 1 );
				surface.DrawRect(0, 0, sqb_w, 2)

				render.SetStencilCompareFunction( STENCIL_EQUAL );
				render.SetStencilFailOperation( STENCIL_KEEP );

				render.SetStencilReferenceValue( 1 );

				sqb.rotAngle = (sqb.rotAngle or 0) + 100 * FrameTime();

				surface.SetDrawColor( Color(0,0,0) );
				surface.DrawRect( 0, 0, sqb_w, sqb_h );

				rpui.GetPaintStyle( sqb, STYLE_GOLDEN );

				local distsize  = math.sqrt( sqb_w*sqb_w + sqb_h*sqb_h );
				local parentalpha = self.GetAlpha(self) / 255;
				local bs = rpui.PowOfTwo(sqb_h * 0.03);

				surface.SetDrawColor( RainbowColor );
				surface.DrawRect( 0, 0, sqb_w, sqb_h );

				surface.SetMaterial( rpui.GradientMat );
				surface.SetDrawColor( RainbowRotate );
				surface.DrawTexturedRectRotated( sqb_w * 0.5, sqb_h * 0.5, distsize, distsize, (sqb.rotAngle or 0) );

				render.SetStencilEnable(false)
			end
			questholder_questbutton.DoClick = function()
				if self.DoingReroll then
					return
				end

				if self.QuestingReroll and self.QuestingReroll >= CurTime() then
					net.Start("Seasonpass::Reroll")
					net.SendToServer()

					self.DoingReroll = LocalPlayer():SeasonRerollsCount()
					self.QuestingReroll = nil

					return
				end

				self.QuestingReroll = 1.5 + CurTime()
			end

			if LocalPlayer():GetNetVar("SeasonpassRerolledToday") then
				questholder_questbutton:Remove()
			end
		end

        questholder_questbar.Title = vgui.Create("DLabel", questholder_questbar)
		local questholder_questbar_title = questholder_questbar.Title
        questholder_questbar_title:Dock(TOP)
        questholder_questbar_title:DockMargin(0, self.innerPadding, 0, self.innerPadding)
        questholder_questbar_title:SetTextColor(self.UIColors.White or rpui.UIColors.White)
        questholder_questbar_title:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
        questholder_questbar_title:SetText(season.QuestsCustomText or translates.Get("Задания на день"))
        questholder_questbar_title:SetContentAlignment(5)

		surface.SetFont("rpui.Fonts.Seasonpass.QuestTitle")
		local sq_off_x = surface.GetTextSize(season.QuestsCustomText or translates.Get("Задания на день"))
		local sq_off_sx = 0.014 * frameH

        questholder_questbar.PinButton = vgui.Create("DButton", questholder_questbar)
		local questholder_questbar_pinbutton = questholder_questbar.PinButton
        questholder_questbar_pinbutton:SetSize(frameH * 0.056, frameH * 0.056)
        questholder_questbar_pinbutton:SetText("")
        questholder_questbar_pinbutton:SetPos(frameW * 0.12 + sq_off_x * 0.5 + self.innerPadding * 0.5, self.innerPadding * 1.8 - frameH * 0.023)
        questholder_questbar_pinbutton.Paint = function(sqpb, sqpb_w, sqpb_h)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(cvar_Get(cvar_pin_name) and pin_on_material or pin_off_material)
			surface.DrawTexturedRect(sq_off_sx, sq_off_sx, sqpb_w - sq_off_sx * 2, sqpb_h - sq_off_sx * 2)
		end
        questholder_questbar_pinbutton.DoClick = function()
			cvar.SetValue(cvar_pin_name, not cvar_Get(cvar_pin_name))
		end

		if season.RerollFormula then
			questholder_questbar.FooterTime = vgui.Create("DLabel", questholder_questbar)
			local questholder_questbar_footertime = questholder_questbar.FooterTime
			questholder_questbar_footertime:Dock(BOTTOM)
			questholder_questbar_footertime:DockMargin(0, 0, 0, self.innerPadding * 0.5)
			questholder_questbar_footertime:SetTextColor(self.UIColors.White or rpui.UIColors.White)
			questholder_questbar_footertime:SetFont("rpui.Fonts.Seasonpass.QuestText")
			questholder_questbar_footertime:SetText(rp.seasonpass.PrettyTime(rp.seasonpass.GetDayTimeLeft(), true, true))
			questholder_questbar_footertime:SetContentAlignment(5)

			questholder_questbar.FooterDesc = vgui.Create("DLabel", questholder_questbar)
			local questholder_questbar_footerdesc = questholder_questbar.FooterDesc
			questholder_questbar_footerdesc:Dock(BOTTOM)
			questholder_questbar_footerdesc:DockMargin(0, 0, 0, -self.innerPadding * 0.5)
			questholder_questbar_footerdesc:SetTextColor(self.UIColors.White or rpui.UIColors.White)
			questholder_questbar_footerdesc:SetFont("rpui.Fonts.Seasonpass.QuestText")
			questholder_questbar_footerdesc:SetText(translates.Get("Задания обновятся через:"))
			questholder_questbar_footerdesc:SetContentAlignment(5)
			questholder_questbar_footerdesc:SetTall(self.innerPadding * 1.85)
		end

		questholder.DoQuests = function()
			for k, v in pairs(questholder.Quests) do
				if IsValid(v) then
					v:Remove()
				end
			end

			questholder.Quests = {}

			local temp_id		= 0
			local quests 		= {}

			for k = 1, 3 do
				if not LocalPlayer():SeasonCompletedQuest(LocalPlayer():SeasonGetQuests()[k]) then
					table.insert(quests, k)
				end
			end

			for k = 1, 3 do
				if LocalPlayer():SeasonCompletedQuest(LocalPlayer():SeasonGetQuests()[k]) then
					table.insert(quests, k)
				end
			end

			for k = 1, 3 do
				local quest = vgui.Create("rpui.Seasonpass.QuestPanel", questholder_questbar)
				quest.DockMargin(quest, self.innerPadding, self.innerPadding * ((k == 1) and 0.4 * 1 or 0.6), self.innerPadding, 0)
				quest.Dock(quest, TOP)

				quest.SetQuest(quest, quests[k], k)

				questholder.Quests[#questholder.Quests + 1] = quest
			end
		end
		questholder.DoQuests()


		-- Main panel
		questholder:SetTall(math.ceil(questholder:GetTall()))
		local full_tall = math.ceil(questholder:GetTall() - (season.NoPremium and 0 or self.innerPadding * 1.5))
		local full_wide = math.ceil(frameW * 0.76 - self.innerPadding * 7)

		if IsValid(questholder_questbutton) then
			questholder_questbutton:SetTall(math.ceil(full_tall * 0.09))
		end

        self.Mainholder = vgui.Create("DPanel", self)
		local mainholder = self.Mainholder
        mainholder:Dock(RIGHT)
        mainholder:DockMargin(0, self.innerPadding * 1.5, self.innerPadding * 1, self.innerPadding * 0.5)
        mainholder:SetWide(full_wide)
        mainholder:InvalidateParent(true)
        mainholder.Paint = function() end


        mainholder.Header = vgui.Create("DPanel", mainholder)
		local mainholder_header = mainholder.Header
        mainholder_header:Dock(TOP)
        mainholder_header:SetTall(math.ceil(full_tall * 0.083))
		mainholder_header.Paint = function() end

        mainholder_header.Level = vgui.Create("DPanel", mainholder_header)
		local mainholder_header_level = mainholder_header.Level
        mainholder_header_level:Dock(LEFT)
        mainholder_header_level:SetWide(math.ceil(full_wide * 0.104))
		mainholder_header_level.Paint = function(smhl, smhl_w, smhl_h)
			if season.LogoMaterial then
				surface.SetDrawColor(Color(0, 0, 0, 170))
				surface.DrawRect(0, 0, smhl_w, smhl_h)
			end

			if not smhl.BakedText then
				smhl.BakedText = string.format("%03d", LocalPlayer():SeasonGetLevel())
			end

			draw.SimpleText(smhl.BakedText, "rpui.Fonts.Seasonpass.MainLevel", smhl_w * 0.5, smhl_h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

        mainholder_header.Holder = vgui.Create("DPanel", mainholder_header)
		local mainholder_header_holder = mainholder_header.Holder
        mainholder_header_holder:Dock(LEFT)
        mainholder_header_holder:DockMargin(self.innerPadding * 0.5, 0, 0, 0)
        mainholder_header_holder:SetWide(math.ceil(full_wide * 0.896 - self.innerPadding * 0.5))
		mainholder_header_holder.Paint = function(smh, smh_w, smh_h)
			surface.SetDrawColor(Color(0, 0, 0, 77))
			surface.DrawRect(0, 0, smh_w, smh_h)
		end

        mainholder_header_holder.Page = vgui.Create("DButton", mainholder_header_holder)
		local mainholder_header_holder_page = mainholder_header_holder.Page
        mainholder_header_holder_page:Dock(RIGHT)
        mainholder_header_holder_page:DockMargin(0, self.innerPadding * 0.9, self.innerPadding * 1.5, self.innerPadding * 0.9)
        mainholder_header_holder_page:SetWide(math.ceil(full_wide * 0.13))
        mainholder_header_holder_page:SetText("")
		mainholder_header_holder_page.Paint = function(smhpc, smhpc_w, smhpc_h)
			if not smhpc.BakedPolyLeft then
				smhpc.BakedPolyLeft = {
					{ x = 0, y = smhpc_h * 0.5 },
					{ x = smhpc_w * 0.17, y = smhpc_h * 0.06 },
					{ x = smhpc_w * 0.17, y = smhpc_h * 0.94 },
				}

				smhpc.BakedPolyRight = {
					{ x = smhpc_w * 0.83, y = smhpc_h * 0.06 },
					{ x = smhpc_w, y = smhpc_h * 0.5 },
					{ x = smhpc_w * 0.83, y = smhpc_h * 0.94 },
				}
			end

			smhpc:SetCursor("hand")

			local cursor_x 		= smhpc:LocalCursorPos()
			local is_on_left	= smhpc:IsHovered() and cursor_x <= 0.5 * smhpc_w
			local is_on_right	= smhpc:IsHovered() and cursor_x > 0.5 * smhpc_w

			draw.NoTexture()

			if self.CurrentPage > 1 then
				surface.SetDrawColor(is_on_left and Color(0, 0, 0, 100) or Color(255, 255, 255, 255))
				surface.DrawPoly(smhpc.BakedPolyLeft)

			elseif is_on_left then
				smhpc:SetCursor("arrow")
			end

			if self.CurrentPage < max_page then
				surface.SetDrawColor(is_on_right and Color(0, 0, 0, 100) or Color(255, 255, 255, 255))
				surface.DrawPoly(smhpc.BakedPolyRight)

			elseif is_on_right then
				smhpc:SetCursor("arrow")
			end

			draw.SimpleText(self.CurrentPage .. " / " .. max_page, "rpui.Fonts.Seasonpass.Progress", smhpc_w * 0.5, smhpc_h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		mainholder_header_holder_page.DoClick = function(smhpb)
			local cursor_x 		= smhpb:LocalCursorPos()
			local is_on_left	= smhpb:IsHovered() and cursor_x <= 0.5 * smhpb.GetWide(smhpb)
			local is_on_right	= smhpb:IsHovered() and cursor_x > 0.5 * smhpb.GetWide(smhpb)

			if self.CurrentPage > 1 and is_on_left then
				self:SwitchPage(self.CurrentPage - 1)

			elseif self.CurrentPage < max_page and is_on_right then
				self:SwitchPage(self.CurrentPage + 1)
			end
		end


        mainholder_header_holder.Progress = vgui.Create("DPanel", mainholder_header_holder)
		local mainholder_header_holder_progress = mainholder_header_holder.Progress
        mainholder_header_holder_progress:Dock(LEFT)
        mainholder_header_holder_progress:SetWide(math.ceil(full_wide * 0.209))
		mainholder_header_holder_progress.Paint = function() end

        mainholder_header_holder_progress.Top = vgui.Create("DPanel", mainholder_header_holder_progress)
		local mainholder_header_holder_progress_top = mainholder_header_holder_progress.Top
        mainholder_header_holder_progress_top:Dock(TOP)
        mainholder_header_holder_progress_top:DockMargin(0, self.innerPadding * 0.4, 0, 0)
        mainholder_header_holder_progress_top:SetTall(math.ceil(full_tall * 0.041))
		mainholder_header_holder_progress_top.Paint = function() end

        mainholder_header_holder_progress_top.LeftText = vgui.Create("DLabel", mainholder_header_holder_progress_top)
		local mainholder_header_holder_progress_top_lefttext = mainholder_header_holder_progress_top.LeftText
        mainholder_header_holder_progress_top_lefttext:Dock(LEFT)
        mainholder_header_holder_progress_top_lefttext:DockMargin(self.innerPadding, 0, 0, 0)
        mainholder_header_holder_progress_top_lefttext:SetFont("rpui.Fonts.Seasonpass.Progress")
        mainholder_header_holder_progress_top_lefttext:SetTextColor(Color(255, 255, 255, 255))
        mainholder_header_holder_progress_top_lefttext:SetText(translates.Get("ОПЫТ:"))
        mainholder_header_holder_progress_top_lefttext:SizeToContentsX()
        mainholder_header_holder_progress_top_lefttext:SetContentAlignment(2)

        mainholder_header_holder_progress_top.RightText = vgui.Create("DLabel", mainholder_header_holder_progress_top)
		local mainholder_header_holder_progress_top_righttext = mainholder_header_holder_progress_top.RightText
        mainholder_header_holder_progress_top_righttext:Dock(RIGHT)
        mainholder_header_holder_progress_top_righttext:DockMargin(0, 0, self.innerPadding, 0)
        mainholder_header_holder_progress_top_righttext:SetFont("rpui.Fonts.Seasonpass.Progress")
        mainholder_header_holder_progress_top_righttext:SetTextColor(Color(255, 255, 255, 255))
		mainholder_header_holder_progress_top_righttext:SetText("9999 / 9999")
        mainholder_header_holder_progress_top_righttext:SizeToContentsX()
        mainholder_header_holder_progress_top_righttext:SetContentAlignment(2)

        mainholder_header_holder_progress.Bottom = vgui.Create("DPanel", mainholder_header_holder_progress)
		local mainholder_header_holder_progress_bottom = mainholder_header_holder_progress.Bottom
        mainholder_header_holder_progress_bottom:Dock(TOP)
        mainholder_header_holder_progress_bottom:DockMargin(self.innerPadding, self.innerPadding * 0.28, self.innerPadding, 0)
        mainholder_header_holder_progress_bottom:SetTall(math.ceil(full_tall * 0.012))
		mainholder_header_holder_progress_bottom.Paint = function(smhp, smhp_w, smhp_h)
			surface.SetDrawColor(Color(0, 0, 0, 150))
			surface.DrawRect(0, 0, smhp_w, smhp_h)

			if current_score < targed_score then
				current_score = current_score + 0.2 * (targed_score - current_score)

				if math.abs(current_score - targed_score) <= 0.3 * 1 then
					current_score = targed_score
				end

				mainholder_header_holder_progress_top_righttext:SetText(math.floor(current_score) .. ' / ' .. needed_score)
				mainholder_header_holder_progress_top_righttext:SizeToContentsX()
			end

            surface.SetDrawColor(RainbowColor)
            surface.DrawRect(0, 0, smhp_w * current_score / needed_score, smhp_h)

            surface.SetMaterial(rpui.GradientMat)
            surface.SetDrawColor(RainbowRotate)
            surface.DrawTexturedRect(0, 0, smhp_w * current_score / needed_score, smhp_h)
		end


        mainholder.LevelDescs = vgui.Create("DPanel", mainholder)
		local mainholder_leveldescs = mainholder.LevelDescs
        mainholder_leveldescs:Dock(TOP)
        mainholder_leveldescs:SetTall(math.ceil(full_tall * 0.056 + self.innerPadding * 0.5))
		mainholder_leveldescs.Paint = function() end

        mainholder_leveldescs.Level = vgui.Create("DPanel", mainholder_leveldescs)
		local mainholder_leveldescs_level = mainholder_leveldescs.Level
        mainholder_leveldescs_level:Dock(LEFT)
        mainholder_leveldescs_level:SetWide(math.ceil(full_wide * 0.104))
		mainholder_leveldescs_level.Paint = function(smhld, smhld_w, smhld_h)
			if season.LogoMaterial then
				surface.SetDrawColor(Color(0, 0, 0, 170))
				surface.DrawRect(0, 0, smhld_w, smhld_h)
			end

			draw.SimpleText(translates.Get("УРОВЕНЬ"), "rpui.Fonts.Seasonpass.SubLevel", smhld_w * 0.5, smhld_h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

        mainholder_leveldescs.Holder = vgui.Create("DHorizontalScroller", mainholder_leveldescs)
		local mainholder_leveldescs_holder = mainholder_leveldescs.Holder
        mainholder_leveldescs_holder:Dock(LEFT)
        mainholder_leveldescs_holder:DockMargin(self.innerPadding * 0.5, 0, 0, 0)
        mainholder_leveldescs_holder:SetWide(math.ceil(full_wide * 0.896 - self.innerPadding * 0.5))
		mainholder_leveldescs_holder:SetOverlap(-self.innerPadding * 0.5)
		mainholder_leveldescs_holder.OnMouseWheeled = function(mhld_omw, sl_dt1)
			if sl_dt1 < 0 then
				if self.CurrentPage < max_page then
					self:SwitchPage(self.CurrentPage + 1)
				end

			elseif sl_dt1 > 0 then
				if self.CurrentPage > 1 then
					self:SwitchPage(self.CurrentPage - 1)
				end
			end
		end
		mainholder_leveldescs_holder.Paint = function(smldh, smldh_w, smldh_h)
			local cur_offset = smldh.OffsetX

			local tar_offset = (self.CurrentPage - 1) * (smldh.GetWide(smldh) - math.ceil(full_wide * 0.104 - self.innerPadding * 0.015))
			tar_offset = math.min(tar_offset, (math.ceil((full_wide * 0.896 - self.innerPadding * 4) / 8) + self.innerPadding * 0.5) * (max_levels - 8))

			cur_offset = cur_offset + (tar_offset - cur_offset) * 5 * FrameTime()

			smldh.OffsetX = cur_offset
			smldh.pnlCanvas.x = -cur_offset

			smldh.btnLeft.SetVisible(smldh.btnLeft, false)
			smldh.btnRight.SetVisible(smldh.btnRight, false)
		end

		local off_y_p = season.LevelOnMat and math.ceil(self.innerPadding * 0.7) or math.ceil(self.innerPadding * 0.5)

		mainholder_leveldescs_holder.Tabs = {}
		mainholder_leveldescs_holder.AddTab = function()
			local level = #mainholder_leveldescs_holder.Tabs + 1

			local pnl = vgui.Create("DPanel")
			pnl.SetWide(pnl, math.ceil((full_wide * 0.896 - self.innerPadding * 4) / 8))
			pnl.Paint = function(sldp, sldp_w, sldp_h)
				if sldp.Level > max_levels then return end
				sldp_h = sldp_h - off_y_p

				local pp_x, pp_y = sldp:LocalToScreen(0, off_y_p)
				local pp_x_s, pp_y_s = sldp:LocalToScreen(sldp_w, sldp_h + off_y_p)

				if sldp.Level <= current_level then
					if season.LevelOnMat then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(season.LevelOnMat)
						surface.DrawTexturedRect(0, off_y_p, sldp_w, sldp_h)

					else
						sldp.rotAngle = (sldp.rotAngle or 0) + 100 * FrameTime()

						local distsize = math.sqrt(sldp_w * sldp_w + sldp_h * sldp_h)

						render.SetScissorRect(pp_x, pp_y, pp_x_s, pp_y_s, true)
							surface.SetAlphaMultiplier(self.GetAlpha(self) / 255)
								surface.SetDrawColor(RainbowColor)
								surface.DrawRect(0, off_y_p, sldp_w, sldp_h)

								surface.SetMaterial(rpui.GradientMat)
								surface.SetDrawColor(RainbowRotate)
								surface.DrawTexturedRectRotated(sldp_w * 0.5, sldp_h * 0.5 + off_y_p, distsize, distsize, (sldp.rotAngle or 0))
							surface.SetAlphaMultiplier(1)
						render.SetScissorRect(0, 0, 0, 0, false)
					end

				else
					if season.LevelOffMat then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(season.LevelOffMat)
						surface.DrawTexturedRect(0, off_y_p, sldp_w, sldp_h)

					else
						surface.SetDrawColor(Color(0, 0, 0, 77))
						surface.DrawRect(0, off_y_p, sldp_w, sldp_h)
					end
				end

				if season.LevelOnFontColor and season.LevelOffFontColor then
					draw.SimpleText(sldp.Level, "rpui.Fonts.Seasonpass.SubLevel", sldp_w * 0.5, sldp_h * 0.5 + off_y_p, (sldp.Level <= current_level) and season.LevelOnFontColor or season.LevelOffFontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				else
					draw.SimpleText(sldp.Level, "rpui.Fonts.Seasonpass.SubLevel", sldp_w * 0.5, sldp_h * 0.5 + off_y_p, season.LevelFontColor or Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			pnl.Level = level

			mainholder_leveldescs_holder:AddPanel(pnl)
			table.insert(mainholder_leveldescs_holder.Tabs, pnl)
		end

		local no_prem_offset = 0 --math.ceil(full_tall * 0.441) + math.ceil(full_tall * 0.09) - self.innerPadding

        mainholder.Levels = vgui.Create("DPanel", mainholder)
		local mainholder_levels = mainholder.Levels
        mainholder_levels:Dock(TOP)
        mainholder_levels:DockMargin(0, self.innerPadding * 0.5, 0, 0)
        mainholder_levels:SetTall(math.ceil(full_tall * 0.326) + (season.NoPremium and no_prem_offset or 0))
		mainholder_levels.Paint = function() end

        mainholder_levels.Head = vgui.Create("DPanel", mainholder_levels)
		local mainholder_levels_head = mainholder_levels.Head
        mainholder_levels_head:Dock(LEFT)
        mainholder_levels_head:SetWide(math.ceil(full_wide * 0.104))
		mainholder_levels_head.Paint = function(smlhd, smlhd_w, smlhd_h)
			surface.SetDrawColor(Color(0, 0, 0, season.LogoMaterial and 160 or 77))
			surface.DrawRect(0, 0, smlhd_w, smlhd_h)
		end

		local mainholder_levels_head_stitle
		if season.Shadows then
			mainholder_levels_head.STitle = vgui.Create("DLabel", mainholder_levels_head)
			mainholder_levels_head_stitle = mainholder_levels_head.STitle
			mainholder_levels_head_stitle:Dock(TOP)
			mainholder_levels_head_stitle:DockMargin(0, math.ceil(full_tall * 0.314 * 0.3) + (season.NoPremium and no_prem_offset * 0.5 or 0), 0, 0)
			mainholder_levels_head_stitle:SetFont("rpui.Fonts.Seasonpass.SHeadTitleUsual")
			mainholder_levels_head_stitle:SetTextColor(shadow_color)
			mainholder_levels_head_stitle:SetText(translates.Get("БАЗОВЫЙ"))
			mainholder_levels_head_stitle:SetWide(mainholder_levels_head:GetWide())
			mainholder_levels_head_stitle:SizeToContentsY()
			mainholder_levels_head_stitle:SetContentAlignment(5)
		end


		local mainholder_levels_head_title
		if season.Shadows then
			mainholder_levels_head.Title = vgui.Create("DLabel", mainholder_levels_head_stitle)
			mainholder_levels_head_title = mainholder_levels_head.Title
			mainholder_levels_head_title:Dock(TOP)
			mainholder_levels_head_title:DockMargin(0, -1, 0, 1)

		else
			mainholder_levels_head.Title = vgui.Create("DLabel", mainholder_levels_head)
			mainholder_levels_head_title = mainholder_levels_head.Title
			mainholder_levels_head_title:Dock(TOP)
			mainholder_levels_head_title:DockMargin(0, math.ceil(full_tall * 0.314 * 0.3) + (season.NoPremium and no_prem_offset * 0.5 or 0), 0, 0)
		end

        mainholder_levels_head_title:SetFont("rpui.Fonts.Seasonpass.HeadTitleUsual")
        mainholder_levels_head_title:SetTextColor(Color(255, 255, 255, 0.7 * 255))
        mainholder_levels_head_title:SetText(translates.Get("БАЗОВЫЙ"))
		mainholder_levels_head_title:SetWide(mainholder_levels_head:GetWide())
		mainholder_levels_head_title:SizeToContentsY()
		mainholder_levels_head_title:SetContentAlignment(5)

		local mainholder_levels_head_sseason
		if season.Shadows then
			mainholder_levels_head.ShadowSeason = vgui.Create("DLabel", mainholder_levels_head)
			mainholder_levels_head_sseason = mainholder_levels_head.ShadowSeason
			mainholder_levels_head_sseason:Dock(TOP)
			mainholder_levels_head_sseason:DockMargin(0, self.innerPadding, 0, 0)
			mainholder_levels_head_sseason:SetFont("rpui.Fonts.Seasonpass.SHeadSeason")
			mainholder_levels_head_sseason:SetTextColor(shadow_color)
			mainholder_levels_head_sseason:SetText(utf8.upper(season.pre_name) .. ':')
			mainholder_levels_head_sseason:SetWide(mainholder_levels_head:GetWide())
			mainholder_levels_head_sseason:SizeToContentsY()
			mainholder_levels_head_sseason:SetContentAlignment(5)
		end


		local mainholder_levels_head_season
		if season.Shadows then
			mainholder_levels_head.Season = vgui.Create("DLabel", mainholder_levels_head_sseason)
			mainholder_levels_head_season = mainholder_levels_head.Season
			mainholder_levels_head_season:Dock(TOP)
			mainholder_levels_head_season:DockMargin(0, -1, 0, 1)

		else
			mainholder_levels_head.Season = vgui.Create("DLabel", mainholder_levels_head)
			mainholder_levels_head_season = mainholder_levels_head.Season
			mainholder_levels_head_season:Dock(TOP)
			mainholder_levels_head_season:DockMargin(0, self.innerPadding, 0, 0)
		end

        mainholder_levels_head_season:SetFont("rpui.Fonts.Seasonpass.HeadSeason")
        mainholder_levels_head_season:SetTextColor(Color(255, 255, 255, 0.7 * 255))
        mainholder_levels_head_season:SetText(utf8.upper(season.pre_name) .. ':')
		mainholder_levels_head_season:SetWide(mainholder_levels_head:GetWide())
		mainholder_levels_head_season:SizeToContentsY()
		mainholder_levels_head_season:SetContentAlignment(5)

		mainholder_levels_head.SeasonNameHolder = vgui.Create("DPanel", mainholder_levels_head)
		local mainholder_levels_head_seasonnameholder = mainholder_levels_head.SeasonNameHolder
        mainholder_levels_head_seasonnameholder:Dock(TOP)
        mainholder_levels_head_seasonnameholder.Paint = function() end

		self.WrappedSeasonName = string.Wrap("rpui.Fonts.Seasonpass.HeadSeasonNamel", utf8.upper(season.name), mainholder_levels_head:GetWide())

		local part_title_s
		for k, v in pairs(self.WrappedSeasonName) do
			if season.Shadows then
				part_title_s = vgui.Create("DLabel", mainholder_levels_head_seasonnameholder)
				part_title_s:Dock(TOP)
				part_title_s:DockMargin(0, -self.innerPadding * ((k > 1) and  (1 - (season.RPPassSeasonNameMult or 0) / 5) or 0.2), 0, 0)
				part_title_s:SetFont("rpui.Fonts.Seasonpass.SHeadSeasonNamel")
				part_title_s:SetContentAlignment(5)
				part_title_s:SetTextColor(shadow_color)
				part_title_s:SetText(v)
				part_title_s:SetTall(self.innerPadding * 1.85)
			end

			local part_title
			if season.Shadows then
				part_title = vgui.Create("DLabel", part_title_s)
				part_title:Dock(TOP)
				part_title:DockMargin(0, -1, 0, 1)

			else
				part_title = vgui.Create("DLabel", mainholder_levels_head_seasonnameholder)
				part_title:Dock(TOP)
				part_title:DockMargin(0, -self.innerPadding * ((k > 1) and 1 or 0.2), 0, 0)
			end

			part_title:SetFont("rpui.Fonts.Seasonpass.HeadSeasonNamel")
			part_title:SetContentAlignment(5)
			part_title:SetTextColor(season.TitleColor or seasonpass_title_color)
			part_title:SetText(v)
			part_title:SetTall(self.innerPadding * 1.85)
		end

		mainholder_levels_head_seasonnameholder:InvalidateLayout()
		mainholder_levels_head_seasonnameholder:SizeToChildren()
		mainholder_levels_head_seasonnameholder:SetTall((#self.WrappedSeasonName) * self.innerPadding * 1.85)

		local btn_height = math.ceil(0.045 * frameH)

        mainholder_levels.Holder = vgui.Create("DHorizontalScroller", mainholder_levels)
		local mainholder_levels_holder = mainholder_levels.Holder
        mainholder_levels_holder:Dock(LEFT)
        mainholder_levels_holder:DockMargin(self.innerPadding * 0.5, 0, 0, 0)
        mainholder_levels_holder:SetWide(math.ceil(full_wide * 0.896 - self.innerPadding * 0.5))
        mainholder_levels_holder:SetOverlap(-self.innerPadding * 0.5)
		mainholder_levels_holder.OnMouseWheeled = function(mhldl_omw, sl_dt2)
			if sl_dt2 < 0 then
				if self.CurrentPage < max_page then
					self:SwitchPage(self.CurrentPage + 1)
				end

			elseif sl_dt2 > 0 then
				if self.CurrentPage > 1 then
					self:SwitchPage(self.CurrentPage - 1)
				end
			end
		end
		mainholder_levels_holder.Paint = function(smhlh)
			if IsValid(mainholder_leveldescs_holder) then
				smhlh.OffsetX = mainholder_leveldescs_holder.OffsetX
				smhlh.pnlCanvas.x = mainholder_leveldescs_holder.pnlCanvas.x
			end

			smhlh.btnLeft.SetVisible(smhlh.btnLeft, false)
			smhlh.btnRight.SetVisible(smhlh.btnRight, false)
		end

		mainholder_levels_holder.Tabs = {}
		mainholder_levels_holder.AddTab = function()
			local level = #mainholder_levels_holder.Tabs + 1
			local cur_reward_usual = season.UsualRewards[level] or {}

			local pnl = vgui.Create("DButton")
			pnl:SetWide(math.ceil((full_wide * 0.896 - self.innerPadding * 4) / 8))
			pnl:SetText("")
			pnl.Paint = function(slup, slup_w, slup_h)
				if slup.Level > max_levels then return end

				surface.SetDrawColor(Color(255, 255, 255, (slup.Level <= current_level) and 255 or (77 * (1 + (season.DarkMode or 0) * 5))))
				surface.SetMaterial(tab_bg_material)
				surface.DrawTexturedRect(0, 0, slup_w, slup_h)

				surface.SetDrawColor(Color(255, 255, 255, (slup.Level <= current_level) and 255 or (77 * (1 + (season.DarkMode or 0) * 5))))

				local icons_ct = #cur_reward_usual

				local icon_sz_u = math.ceil(0.84 * slup_w)

				for k, v in pairs(cur_reward_usual) do
					surface.SetMaterial(v.icon)
					surface.DrawTexturedRect((slup_w - icon_sz_u) * 0.5, slup_h * 0.5 + (k - 1) * icon_sz_u - icons_ct * icon_sz_u * 0.5, icon_sz_u, icon_sz_u)
					icon_sz_u = icon_sz_u - 0.05 * slup_w
				end

				local icon_size = math.ceil(0.17 * slup_w)

				if slup.Level <= current_level and icons_ct > 0 then
					local available = awards_avlb[1] or {}

					if not available[slup.Level] then
						surface.SetMaterial(check_mark_material)
						surface.DrawTexturedRect(slup_w - icon_size * 1.5, slup_h - icon_size * 1.5, icon_size, icon_size)
						slup.Button.SetVisible(slup.Button, false)
						slup.SetCursor(slup, "arrow")
					end
				else
					slup.SetCursor(slup, "arrow")
					slup.Button.SetVisible(slup.Button, false)
				end
			end
			pnl.DoClick = function(slpb)
				if slpb.Level > current_level then
					return
				end

				if self.GetRewardInProgress then
					return
				end

				local available = awards_avlb[1] or {}

				if not available[slpb.Level] then
					return
				end

				self.GetRewardInProgress = slpb

				net.Start("Seasonpass::GetReward")
					net.WriteUInt(slpb.Level, 16)
					net.WriteBool(false)
				net.SendToServer()
			end

			pnl.Description = ''
			for k, v in pairs(cur_reward_usual) do
				pnl.Description = pnl.Description .. (v.desc and v.desc .. (k < #cur_reward_usual and '\n' or '') or '')
			end
			if pnl.Description ~= '' then
				self:RegisterTooltip(pnl, translates.Get("Награда за %s уровень: \n", level) .. pnl.Description, TOOLTIP_OFFSET_CENTER)
			end

			pnl.Button = vgui.Create("DButton", pnl)
			local pnl1_button = pnl.Button
			pnl1_button:Dock(BOTTOM)
			pnl1_button:SetTall(btn_height)
			pnl1_button:SetText("")
			pnl1_button.Paint = function(slppbp, slppbp_w, slppbp_h)
				local hovered = slppbp:IsHovered() or pnl:IsHovered()

				if season.RewardBtnMaterialBack then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(season.RewardBtnMaterialBack)
					surface.DrawTexturedRect(0, 0, slppbp_w, slppbp_h)

				else
					surface.SetDrawColor(Color(0, 0, 0, 100))
					surface.DrawRect(0, 0, slppbp_w, slppbp_h)
				end

				slppbp.rotAngle = (slppbp.rotAngle or 0) + 100 * FrameTime()
				slppbp._alpha = math.Approach(slppbp._alpha or 0, (hovered or slppbp.Selected) and 255 or 0, 768 * FrameTime())

				local distsize  = math.sqrt(slppbp_w * slppbp_w + slppbp_h * slppbp_h)
				local parentalpha = self.GetAlpha(self) / 255
				local alphamult   = slppbp._alpha / 255

				surface.SetAlphaMultiplier(parentalpha * alphamult)
					if season.RewardBtnMaterialOn then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(season.RewardBtnMaterialOn)
						surface.DrawTexturedRect(0, 0, slppbp_w, slppbp_h)

					else
						surface.SetDrawColor(rpui.UIColors.BackgroundGold)
						surface.DrawRect(0, 0, slppbp_w, slppbp_h)

						surface.SetMaterial(rpui.GradientMat)
						surface.SetDrawColor(rpui.UIColors.Gold)
						surface.DrawTexturedRectRotated(slppbp_w * 0.5, slppbp_h * 0.5, distsize, distsize, slppbp.rotAngle or 0)
					end
				surface.SetAlphaMultiplier(1)

				draw.SimpleText(translates.Get("Забрать"), "rpui.Fonts.Seasonpass.Progress" or slppbp:GetFont(), slppbp_w * 0.5, slppbp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			pnl1_button.PaintOver = function(sphb, sphb_w, sphb_h)
				if season.RewardBtnMaterialOff then
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.SetMaterial(season.RewardBtnMaterialOff)
					surface.DrawTexturedRect(0, 0, sphb_w, sphb_h)

				else
					rpui.DrawStencilBorder(sphb, 0, 0, sphb_w, sphb_h, 0.06, ColorAlpha(RainbowRotate, self.GetAlpha(self)), ColorAlpha(RainbowColor, self.GetAlpha(self)))
				end
            end
			pnl1_button.DoClick = function()
				pnl.DoClick(pnl)
			end

			pnl.Level = level

			mainholder_levels_holder:AddPanel(pnl)
			table.insert(mainholder_levels_holder.Tabs, pnl)
		end


		if season.NoPremium then
			mainholder.PremBanner = vgui.Create("DPanel", mainholder)
			local mainholder_banner = mainholder.PremBanner
			mainholder_banner:Dock(TOP)
			mainholder_banner:DockMargin(0, self.innerPadding * 0.5, 0, 0)
			mainholder_banner:SetTall(math.ceil(full_tall * 0.441) + math.ceil(full_tall * 0.09) - self.innerPadding)
			mainholder_banner.Paint = function(pbn, pbnw, pbnh)
				local max_h = 0.29 * pbnw

				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(season.NoPremium)
				surface.DrawTexturedRect(0, 0, pbnw, max_h)
			end

		else
			mainholder.PremLevels = vgui.Create("DPanel", mainholder)
			local mainholder_premlevels = mainholder.PremLevels
			mainholder_premlevels:Dock(TOP)
			mainholder_premlevels:DockMargin(0, self.innerPadding * 0.5, 0, 0)
			mainholder_premlevels:SetTall(math.ceil(full_tall * 0.441))
			mainholder_premlevels.Paint = function() end

			mainholder_premlevels.Head = vgui.Create("DButton", mainholder_premlevels)
			local mainholder_premlevels_head = mainholder_premlevels.Head
			mainholder_premlevels_head:Dock(LEFT)
			mainholder_premlevels_head:SetWide(math.ceil(full_wide * 0.104))
			mainholder_premlevels_head:SetText("")
			mainholder_premlevels_head.Paint = function(sqb, sqb_w, sqb_h)
				if not season.PremiumHeadBack then return end

				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(season.PremiumHeadBack)
				surface.DrawTexturedRect(0, 0, sqb_w, sqb_h)
			end
			mainholder_premlevels_head.DoClick = function()
				if season.CustomOnBuyPressed then
					season.CustomOnBuyPressed(self)

				else
					self:OpenBuyMenu()
				end
			end

			if is_donated or not season.PremiumCost then
				mainholder_premlevels_head:SetEnabled(false)
				mainholder_premlevels_head:SetCursor("arrow")
			end

			mainholder_premlevels_head.Title = vgui.Create("DLabel", mainholder_premlevels_head)
			local mainholder_premlevels_head_title = mainholder_premlevels_head.Title
			mainholder_premlevels_head_title:Dock(TOP)
			mainholder_premlevels_head_title:DockMargin(0, math.ceil(full_tall * (season.PremHeadMargin or 0.314) * 0.52), 0, 0)
			mainholder_premlevels_head_title:SetFont("rpui.Fonts.Seasonpass.HeadTitlePremium")
			mainholder_premlevels_head_title:SetTextColor(Color(255, 255, 255, 255))
			mainholder_premlevels_head_title:SetText(season.PremHeadCustomText and season.PremHeadCustomText[1] or translates.Get("ГЛОБАЛЬНЫЙ"))
			mainholder_premlevels_head_title:SetWide(mainholder_levels_head:GetWide())
			mainholder_premlevels_head_title:SizeToContentsY()
			mainholder_premlevels_head_title:SetContentAlignment(5)

			mainholder_premlevels_head.Title2 = vgui.Create("DLabel", mainholder_premlevels_head)
			local mainholder_premlevels_head_title2 = mainholder_premlevels_head.Title2
			mainholder_premlevels_head_title2:Dock(TOP)
			mainholder_premlevels_head_title2:DockMargin(0, -self.innerPadding * 0.2, 0, 0)
			mainholder_premlevels_head_title2:SetFont("rpui.Fonts.Seasonpass.HeadTitlePremium2")
			mainholder_premlevels_head_title2:SetTextColor(Color(255, 255, 255, 255))
			mainholder_premlevels_head_title2:SetText(season.PremHeadCustomText and season.PremHeadCustomText[2] or translates.Get("RP ПРОПУСК"))
			mainholder_premlevels_head_title2:SetWide(mainholder_levels_head:GetWide())
			mainholder_premlevels_head_title2:SizeToContentsY()
			mainholder_premlevels_head_title2:SetContentAlignment(5)

			local mainholder_premlevels_head_sseason
			if season.Shadows then
				mainholder_premlevels_head.ShadowSeason = vgui.Create("DLabel", mainholder_premlevels_head)
				mainholder_premlevels_head_sseason = mainholder_premlevels_head.ShadowSeason
				mainholder_premlevels_head_sseason:Dock(TOP)
				mainholder_premlevels_head_sseason:DockMargin(0, self.innerPadding * 0.5, 0, 0)
				mainholder_premlevels_head_sseason:SetFont("rpui.Fonts.Seasonpass.SHeadSeason")
				mainholder_premlevels_head_sseason:SetTextColor(shadow_color)
				mainholder_premlevels_head_sseason:SetText(utf8.upper(season.pre_name) .. ':')
				mainholder_premlevels_head_sseason:SetWide(mainholder_premlevels_head:GetWide())
				mainholder_premlevels_head_sseason:SizeToContentsY()
				mainholder_premlevels_head_sseason:SetContentAlignment(5)
			end


			local mainholder_premlevels_head_season
			if season.Shadows then
				mainholder_premlevels_head.Season = vgui.Create("DLabel", mainholder_premlevels_head_sseason)
				mainholder_premlevels_head_season = mainholder_premlevels_head.Season
				mainholder_premlevels_head_season:Dock(TOP)
				mainholder_premlevels_head_season:DockMargin(0, -1, 0, 1)

			else
				mainholder_premlevels_head.Season = vgui.Create("DLabel", mainholder_premlevels_head)
				mainholder_premlevels_head_season = mainholder_premlevels_head.Season
				mainholder_premlevels_head_season:Dock(TOP)
				mainholder_premlevels_head_season:DockMargin(0, self.innerPadding * 0.5, 0, 0)
			end

			mainholder_premlevels_head_season:SetFont("rpui.Fonts.Seasonpass.HeadSeason")
			mainholder_premlevels_head_season:SetTextColor(Color(255, 255, 255, 255))
			mainholder_premlevels_head_season:SetText(utf8.upper(season.pre_name) .. ':')
			mainholder_premlevels_head_season:SetWide(mainholder_premlevels_head:GetWide())
			mainholder_premlevels_head_season:SizeToContentsY()
			mainholder_premlevels_head_season:SetContentAlignment(5)

			mainholder_premlevels_head.SeasonNameHolder = vgui.Create("DPanel", mainholder_premlevels_head)
			local mainholder_premlevels_head_seasonnameholder = mainholder_premlevels_head.SeasonNameHolder
			mainholder_premlevels_head_seasonnameholder:Dock(TOP)
			mainholder_premlevels_head_seasonnameholder:SetMouseInputEnabled(false)
			mainholder_premlevels_head_seasonnameholder.Paint = function() end

			local part_title_s
			for k, v in pairs(self.WrappedSeasonName) do
				if season.Shadows then
					part_title_s = vgui.Create("DLabel", mainholder_premlevels_head_seasonnameholder)
					part_title_s:Dock(TOP)
					part_title_s:DockMargin(0, -self.innerPadding * ((k > 1) and (1 - (season.RPPassSeasonNameMult or 0) / 5) or 0.2), 0, 0)
					part_title_s:SetFont("rpui.Fonts.Seasonpass.SHeadSeasonNamel")
					part_title_s:SetContentAlignment(5)
					part_title_s:SetTextColor(shadow_color)
					part_title_s:SetText(v)
					part_title_s:SetTall(self.innerPadding * 1.85)
				end

				local part_title
				if season.Shadows then
					part_title = vgui.Create("DLabel", part_title_s)
					part_title:Dock(TOP)
					part_title:DockMargin(0, -1, 0, 1)

				else
					part_title = vgui.Create("DLabel", mainholder_premlevels_head_seasonnameholder)
					part_title:Dock(TOP)
					part_title:DockMargin(0, -self.innerPadding * ((k > 1) and 1 or 0.2), 0, 0)
				end

				part_title:SetFont("rpui.Fonts.Seasonpass.HeadSeasonNamel")
				part_title:SetContentAlignment(5)
				part_title:SetTextColor(season.ColorPremNameToo and (season.TitleColor or seasonpass_title_color) or Color(255, 255, 255, 255))
				part_title:SetText(v)
				part_title:SetTall(self.innerPadding * 1.85)
			end

			mainholder_premlevels_head_seasonnameholder:InvalidateLayout()
			mainholder_premlevels_head_seasonnameholder:SizeToChildren()
			mainholder_premlevels_head_seasonnameholder:SetTall((#self.WrappedSeasonName) * self.innerPadding * 1.85)


			mainholder_premlevels.Holder = vgui.Create("DHorizontalScroller", mainholder_premlevels)
			local mainholder_premlevels_holder = mainholder_premlevels.Holder
			mainholder_premlevels_holder:Dock(LEFT)
			mainholder_premlevels_holder:DockMargin(self.innerPadding * 0.5, 0, 0, 0)
			mainholder_premlevels_holder:SetWide(math.ceil(full_wide * 0.896 - self.innerPadding * 0.5))
			mainholder_premlevels_holder:SetOverlap(-self.innerPadding * 0.5)
			mainholder_premlevels_holder.OnMouseWheeled = function(mhldpl_omw, sl_dt3)
				if sl_dt3 < 0 then
					if self.CurrentPage < max_page then
						self:SwitchPage(self.CurrentPage + 1)
					end

				elseif sl_dt3 > 0 then
					if self.CurrentPage > 1 then
						self:SwitchPage(self.CurrentPage - 1)
					end
				end
			end
			mainholder_premlevels_holder.Paint = function(smhph)
				if IsValid(self.Mainholder.LevelDescs.Holder) then
					smhph.OffsetX = mainholder_leveldescs_holder.OffsetX
					smhph.pnlCanvas.x = mainholder_leveldescs_holder.pnlCanvas.x
				end

				smhph.btnLeft.SetVisible(smhph.btnLeft, false)
				smhph.btnRight.SetVisible(smhph.btnRight, false)
			end
			mainholder_premlevels_holder.Tabs = {}
			mainholder_premlevels_holder.AddTab = function()
				local level = #mainholder_premlevels_holder.Tabs + 1
				local cur_reward_premium = season.PremiumRewards[level] or {}

				local pnl = vgui.Create("DButton")
				pnl:SetWide(math.ceil((full_wide * 0.896 - self.innerPadding * 4) / 8))
				pnl:SetText("")
				pnl.Paint = function(slpp, slpp_w, slpp_h)
					if slpp.Level > max_levels then return end

					if season.PremiumTabMat and season.PremiumTabShowBehind then
						surface.SetDrawColor(Color(255, 255, 255, (slpp.Level <= current_level) and 255 or (77 * (1 + (season.DarkMode or 0) * 5))))
						surface.SetMaterial(season.PremiumTabMat)
						surface.DrawTexturedRect(0, 0, slpp_w, slpp_h)
					end

					surface.SetDrawColor(ColorAlpha(season.RewardsData and season.RewardsData[slpp.Level] and season.RewardsData[slpp.Level].color_premium or seasonpass_default_tab, (slpp.Level <= current_level) and 255 or (77 * (1 + (season.DarkMode or 0) * 5))))
					surface.SetMaterial(tab_prem_bg_material)
					surface.DrawTexturedRect(0, 0, slpp_w, slpp_h)

					surface.SetDrawColor(Color(255, 255, 255, (slpp.Level <= current_level) and 255 or (77 * (1 + (season.DarkMode or 0) * 5))))

					if season.PremiumTabMat and not season.PremiumTabShowBehind then
						surface.SetMaterial(season.PremiumTabMat)
						surface.DrawTexturedRect(0, 0, slpp_w, slpp_h)
					end

					local prem_icons_ct = #cur_reward_premium

					local icon_sz = math.ceil(0.84 * slpp_w)

					for k, v in pairs(cur_reward_premium) do
						surface.SetMaterial(v.icon)
						surface.DrawTexturedRect((slpp_w - icon_sz) * 0.5, slpp_h * 0.5 + (k - 1) * icon_sz - prem_icons_ct * icon_sz * 0.5, icon_sz, icon_sz)
						icon_sz = icon_sz - 0.05 * slpp_w
					end

					local icon_size = math.ceil(0.17 * slpp_w)

					if not is_donated then
						surface.SetMaterial(lock_material)
						surface.DrawTexturedRect(slpp_w - icon_size * 1.5, slpp_h - icon_size * 1.5, icon_size, icon_size)
						slpp.Button.SetVisible(slpp.Button, false)
						slpp.SetCursor(slpp, "arrow")

					elseif slpp.Level <= current_level then
						local available = awards_avlb[2] or {}

						if not available[slpp.Level] then
							surface.SetMaterial(check_mark_material)
							surface.DrawTexturedRect(slpp_w - icon_size * 1.5, slpp_h - icon_size * 1.5, icon_size, icon_size)
							slpp.Button.SetVisible(slpp.Button, false)
							slpp.SetCursor(slpp, "arrow")
						end
					else
						slpp.SetCursor(slpp, "arrow")
						slpp.Button.SetVisible(slpp.Button, false)
					end
				end
				pnl.IsDonated = true
				pnl.DoClick = function(slppb)
					if not is_donated or slppb.Level > current_level then
						return
					end

					if self.GetRewardInProgress then
						return
					end

					local available = awards_avlb[2] or {}

					if not available[slppb.Level] then
						return
					end

					self.GetRewardInProgress = slppb

					net.Start("Seasonpass::GetReward")
						net.WriteUInt(slppb.Level, 16)
						net.WriteBool(true)
					net.SendToServer()
				end

				pnl.Description = ''
				for k, v in pairs(cur_reward_premium) do
					pnl.Description = pnl.Description .. (v.desc and v.desc .. (k < #cur_reward_premium and '\n' or '') or '')
				end
				if pnl.Description ~= '' then
					self:RegisterTooltip(pnl, translates.Get("Награда за %s уровень: \n", level) .. pnl.Description, TOOLTIP_OFFSET_CENTER)
				end

				pnl.Button = vgui.Create("DButton", pnl)
				local pnl2_button = pnl.Button
				pnl2_button:Dock(BOTTOM)
				pnl2_button:SetTall(btn_height)
				pnl2_button:SetText("")
				pnl2_button.Paint = function(slppbp, slppbp_w, slppbp_h)
					local hovered = slppbp:IsHovered() or pnl:IsHovered()

					if season.RewardBtnMaterialBack then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(season.RewardBtnMaterialBack)
						surface.DrawTexturedRect(0, 0, slppbp_w, slppbp_h)

					else
						surface.SetDrawColor(Color(0, 0, 0, 100))
						surface.DrawRect(0, 0, slppbp_w, slppbp_h)
					end

					slppbp.rotAngle = (slppbp.rotAngle or 0) + 100 * FrameTime()
					slppbp._alpha = math.Approach(slppbp._alpha or 0, (hovered or slppbp.Selected) and 255 or 0, 768 * FrameTime())

					local vecClrGold  = Vector(rpui.UIColors.BackgroundGold.r,rpui.UIColors.BackgroundGold.g,rpui.UIColors.BackgroundGold.b)
					local vecClrBlack = Vector(0, 0, 0)

					local vecTextColor = Lerp(768 * FrameTime(), slppbp._veccolor or vecClrBlack, hovered and vecClrBlack or vecClrGold)

					textColor = Color(vecTextColor.x, vecTextColor.y, vecTextColor.z)

					local distsize  = math.sqrt(slppbp_w * slppbp_w + slppbp_h * slppbp_h)
					local parentalpha = self.GetAlpha(self) / 255
					local alphamult   = slppbp._alpha / 255

					surface.SetAlphaMultiplier(parentalpha * alphamult)
						if season.RewardBtnMaterialOn then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(season.RewardBtnMaterialOn)
							surface.DrawTexturedRect(0, 0, slppbp_w, slppbp_h)

						else
							surface.SetDrawColor(rpui.UIColors.BackgroundGold)
							surface.DrawRect(0, 0, slppbp_w, slppbp_h)

							surface.SetMaterial(rpui.GradientMat)
							surface.SetDrawColor(rpui.UIColors.Gold)
							surface.DrawTexturedRectRotated(slppbp_w * 0.5, slppbp_h * 0.5, distsize, distsize, slppbp.rotAngle or 0)
						end
					surface.SetAlphaMultiplier(1)

					draw.SimpleText(translates.Get("Забрать"), "rpui.Fonts.Seasonpass.Progress" or slppbp:GetFont(), slppbp_w * 0.5, slppbp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				pnl2_button.PaintOver = function(sphb, sphb_w, sphb_h)
					if season.RewardBtnMaterialOff then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(season.RewardBtnMaterialOff)
						surface.DrawTexturedRect(0, 0, sphb_w, sphb_h)

					else
						rpui.DrawStencilBorder(sphb, 0, 0, sphb_w, sphb_h, 0.06, ColorAlpha(RainbowRotate, self.GetAlpha(self)), ColorAlpha(RainbowColor, self.GetAlpha(self)))
					end
				end
				pnl2_button.DoClick = function()
					pnl.DoClick(pnl)
				end

				pnl.Level = level

				mainholder_premlevels_holder:AddPanel(pnl)
				table.insert(mainholder_premlevels_holder.Tabs, pnl)
			end

			local mainholder_buttonholder
			local mainholder_button

			mainholder.ButtonHolder = vgui.Create("DPanel", mainholder)
			mainholder_buttonholder = mainholder.ButtonHolder
			mainholder_buttonholder:Dock(TOP)
			mainholder_buttonholder:SetTall(math.ceil(full_tall * 0.09))
			mainholder_buttonholder.Paint = function() end

			if not is_donated and season.PremiumCost then
				local color_prem_1 = table.Copy(season.PremiumHeadBackColor)
				local color_prem_2 = table.Copy(season.PremiumHeadBackColor)

				color_prem_1.r = 0.8 * color_prem_1.r
				color_prem_1.g = 0.8 * color_prem_1.g
				color_prem_1.b = 0.8 * color_prem_1.b

				color_prem_2.r = 0.6 * color_prem_2.r
				color_prem_2.g = 0.6 * color_prem_2.g
				color_prem_2.b = 0.6 * color_prem_2.b

				mainholder.Button = vgui.Create("DButton", mainholder_buttonholder)
				mainholder_button = mainholder.Button
				mainholder_button:Dock(LEFT)
				mainholder_button:SetWide(math.ceil(full_wide * 0.104))
				mainholder_button:SetText("")
				mainholder_button.Paint = function(smhbt, smhbt_w, smhbt_h)
					smhbt._alpha = 255

					render.SetStencilWriteMask( 255 );
					render.SetStencilTestMask( 255 );
					render.SetStencilReferenceValue( 0 );
					render.SetStencilPassOperation( STENCIL_KEEP );
					render.SetStencilZFailOperation( STENCIL_KEEP );
					render.ClearStencil();
					render.SetStencilEnable( true );
					render.SetStencilReferenceValue( 1 );
					render.SetStencilCompareFunction( STENCIL_NEVER );
					render.SetStencilFailOperation( STENCIL_REPLACE );

					draw.NoTexture();
					surface.SetDrawColor(rpui.UIColors.White)
					draw_RoundedPoly(smhbt, 0, -20, smhbt_w, smhbt_h + 20)

					render.SetStencilCompareFunction( STENCIL_EQUAL );
					render.SetStencilFailOperation( STENCIL_KEEP );

					smhbt.rotAngle = (smhbt.rotAngle or 0) + 100 * FrameTime();

					surface.SetDrawColor( Color(0, 0, 0, 100) );
					surface.DrawRect( 0, 0, smhbt_w, smhbt_h );

					local distsize  = math.sqrt( smhbt_w*smhbt_w + smhbt_h*smhbt_h );
					local parentalpha = self.GetAlpha(self) / 255;
					local bs = rpui.PowOfTwo(smhbt_h * 0.03);
					local alphamult = smhbt._alpha / 255

					surface.SetAlphaMultiplier( parentalpha * alphamult );
						surface.SetDrawColor( color_prem_1 );
						surface.DrawRect( 0, 0, smhbt_w, smhbt_h );

						surface.SetMaterial( rpui.GradientMat );
						surface.SetDrawColor( color_prem_2 );
						surface.DrawTexturedRectRotated( smhbt_w * 0.5, smhbt_h * 0.5, distsize, distsize, (smhbt.rotAngle or 0) );
					surface.SetAlphaMultiplier( 1 );

					draw.SimpleText(translates.Get("КУПИТЬ"), "rpui.Fonts.Seasonpass.SubLevel", smhbt_w * 0.5, smhbt_h * 0.5 + self.innerPadding * 0.05, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );

                    local price = season.PremiumCost or 590;

                    if rp.cfg.SeasonpassPrices and isnumber( rp.cfg.SeasonpassPrices.oneSeason ) then
                        price = rp.cfg.SeasonpassPrices.oneSeason;
                    end

					draw.SimpleText(translates.Get("за %s₽", price), "rpui.Fonts.Seasonpass.SubLevel", smhbt_w * 0.5, smhbt_h * 0.5 - self.innerPadding * 0.05, ColorAlpha(rpui.UIColors.White, self.GetAlpha(self)), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );

					render.SetStencilEnable(false)
				end
				mainholder_button.PaintOver = function(smhbo, smhbo_w, smhbo_h)
					render.SetStencilWriteMask( 255 );
					render.SetStencilTestMask( 255 );
					render.SetStencilReferenceValue( 0 );
					render.SetStencilPassOperation( STENCIL_KEEP );
					render.SetStencilZFailOperation( STENCIL_KEEP );
					render.ClearStencil();
					render.SetStencilEnable( true );
					render.SetStencilReferenceValue( 1 );
					render.SetStencilCompareFunction( STENCIL_NEVER );
					render.SetStencilFailOperation( STENCIL_REPLACE );

					draw.NoTexture();
					surface.SetDrawColor(rpui.UIColors.White)
					draw_RoundedPoly(smhbo, 0, -20, smhbo_w, smhbo_h + 20)

					render.SetStencilReferenceValue( 0 );

					draw_RoundedPoly(smhbo, 2, -20, smhbo_w - 4, smhbo_h + 18, 2)

					render.SetStencilReferenceValue( 1 );
					surface.DrawRect(0, 0, smhbo_w, 2)

					render.SetStencilCompareFunction( STENCIL_EQUAL );
					render.SetStencilFailOperation( STENCIL_KEEP );

					render.SetStencilReferenceValue( 1 );

					smhbo.rotAngle = (smhbo.rotAngle or 0) + 100 * FrameTime();

					surface.SetDrawColor( Color(0,0,0) );
					surface.DrawRect( 0, 0, smhbo_w, smhbo_h );

					local distsize  = math.sqrt( smhbo_w*smhbo_w + smhbo_h*smhbo_h );
					local parentalpha = self.GetAlpha(self) / 255;
					local bs = rpui.PowOfTwo(smhbo_h * 0.03);

					surface.SetDrawColor( color_prem_1 );
					surface.DrawRect( 0, 0, smhbo_w, smhbo_h );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor( color_prem_2 );
					surface.DrawTexturedRectRotated( smhbo_w * 0.5, smhbo_h * 0.5, distsize, distsize, (smhbo.rotAngle or 0) );

					render.SetStencilEnable(false)
				end
				mainholder_button.DoClick = function()
					if season.CustomOnBuyPressed then
						season.CustomOnBuyPressed(self)

					else
						self:OpenBuyMenu()
					end
				end
			end

			local has_levels_to_buy = false

			for k, v in pairs(season.PaidLevels or {}) do
				if LocalPlayer():SeasonGetLevel() > (season.MaxLevel - v.levels) then
					continue
				end

				has_levels_to_buy = true
				break
			end

			if has_levels_to_buy or (not is_donated and season.CustomOnBuyLevelsPressed) then
				local color_prem_1 = table.Copy(season.PremiumHeadBackColor)
				local color_prem_2 = table.Copy(season.PremiumHeadBackColor)

				color_prem_1.r = 0.8 * color_prem_1.r
				color_prem_1.g = 0.8 * color_prem_1.g
				color_prem_1.b = 0.8 * color_prem_1.b

				color_prem_2.r = 0.6 * color_prem_2.r
				color_prem_2.g = 0.6 * color_prem_2.g
				color_prem_2.b = 0.6 * color_prem_2.b

				mainholder.Button = vgui.Create("DButton", mainholder_buttonholder)
				local mainholder_button = mainholder.Button
				mainholder_button:Dock(RIGHT)
				mainholder_button:SetWide(math.ceil(full_wide * 0.896 - self.innerPadding * 0.5))
				mainholder_button:SetText("")
				local open_levels_text = season.BuyLevelsCustomText or translates.Get("ОТКРЫТЬ УРОВНИ")
				mainholder_button.Paint = function(smhbt, smhbt_w, smhbt_h)
					local hovered = smhbt:IsHovered()

					smhbt._alpha = math.Approach(smhbt._alpha or 0, (hovered or smhbt.Selected) and 255 or 0, 768 * FrameTime())

					render.SetStencilWriteMask( 255 );
					render.SetStencilTestMask( 255 );
					render.SetStencilReferenceValue( 0 );
					render.SetStencilPassOperation( STENCIL_KEEP );
					render.SetStencilZFailOperation( STENCIL_KEEP );
					render.ClearStencil();
					render.SetStencilEnable( true );
					render.SetStencilReferenceValue( 1 );
					render.SetStencilCompareFunction( STENCIL_NEVER );
					render.SetStencilFailOperation( STENCIL_REPLACE );

					draw.NoTexture();
					surface.SetDrawColor(rpui.UIColors.White)
					draw_RoundedPoly(smhbt, 0, -20, smhbt_w, smhbt_h + 20)

					render.SetStencilCompareFunction( STENCIL_EQUAL );
					render.SetStencilFailOperation( STENCIL_KEEP );

					smhbt.rotAngle = (smhbt.rotAngle or 0) + 100 * FrameTime();

					surface.SetDrawColor( Color(0, 0, 0, 100) );
					surface.DrawRect( 0, 0, smhbt_w, smhbt_h );

					local distsize  = math.sqrt( smhbt_w*smhbt_w + smhbt_h*smhbt_h );
					local parentalpha = IsValid(self) and self.GetAlpha(self) / 255 or 0;
					local bs = rpui.PowOfTwo(smhbt_h * 0.03);
					local alphamult = smhbt._alpha / 255

					surface.SetAlphaMultiplier( parentalpha * alphamult );
						surface.SetDrawColor( color_prem_1 );
						surface.DrawRect( 0, 0, smhbt_w, smhbt_h );

						surface.SetMaterial( rpui.GradientMat );
						surface.SetDrawColor( color_prem_2 );
						surface.DrawTexturedRectRotated( smhbt_w * 0.5, smhbt_h * 0.5, distsize, distsize, (smhbt.rotAngle or 0) );
					surface.SetAlphaMultiplier( 1 );

					draw.SimpleText(open_levels_text, "rpui.Fonts.Seasonpass.SubLevel", smhbt_w * 0.5, smhbt_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

					render.SetStencilEnable(false)
				end
				mainholder_button.PaintOver = function(smhbo, smhbo_w, smhbo_h)
					render.SetStencilWriteMask( 255 );
					render.SetStencilTestMask( 255 );
					render.SetStencilReferenceValue( 0 );
					render.SetStencilPassOperation( STENCIL_KEEP );
					render.SetStencilZFailOperation( STENCIL_KEEP );
					render.ClearStencil();
					render.SetStencilEnable( true );
					render.SetStencilReferenceValue( 1 );
					render.SetStencilCompareFunction( STENCIL_NEVER );
					render.SetStencilFailOperation( STENCIL_REPLACE );

					draw.NoTexture();
					surface.SetDrawColor(rpui.UIColors.White)
					draw_RoundedPoly(smhbo, 0, -20, smhbo_w, smhbo_h + 20)

					render.SetStencilReferenceValue( 0 );

					draw_RoundedPoly(smhbo, 2, -20, smhbo_w - 4, smhbo_h + 18, 2)

					render.SetStencilReferenceValue( 1 );
					surface.DrawRect(0, 0, smhbo_w, 2)

					render.SetStencilCompareFunction( STENCIL_EQUAL );
					render.SetStencilFailOperation( STENCIL_KEEP );

					render.SetStencilReferenceValue( 1 );

					smhbo.rotAngle = (smhbo.rotAngle or 0) + 100 * FrameTime();

					surface.SetDrawColor( Color(0,0,0) );
					surface.DrawRect( 0, 0, smhbo_w, smhbo_h );

					local distsize  = math.sqrt( smhbo_w*smhbo_w + smhbo_h*smhbo_h );
					local parentalpha = IsValid(self) and self.GetAlpha(self) / 255 or 0;
					local bs = rpui.PowOfTwo(smhbo_h * 0.03);

					surface.SetDrawColor( color_prem_1 );
					surface.DrawRect( 0, 0, smhbo_w, smhbo_h );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor( color_prem_2 );
					surface.DrawTexturedRectRotated( smhbo_w * 0.5, smhbo_h * 0.5, distsize, distsize, (smhbo.rotAngle or 0) );

					render.SetStencilEnable(false)
				end
				mainholder_button.DoClick = function()
					if season.CustomOnBuyLevelsPressed then
						season.CustomOnBuyLevelsPressed(self)

					else
						if self.OpenLevelsBuyMenu then
							self:OpenLevelsBuyMenu()
						end
					end
				end
			end
		end

		self:SwitchPage(math.floor((current_level - 1) / 7) + 1)
        self:AlphaTo(255, 0.25)
    end)
end

function PANEL:SwitchPage(page_num)
	self.TargetLevel = (page_num - 1) * 7 + 1

	if self.LevelsLoaded < (self.TargetLevel + 8) then
		for k = self.LevelsLoaded, self.TargetLevel + 8 do
			self.Mainholder.LevelDescs.Holder.AddTab()
			self.Mainholder.Levels.Holder.AddTab()

			if IsValid(self.Mainholder.PremLevels) then
				self.Mainholder.PremLevels.Holder.AddTab()
			end
		end

		self.LevelsLoaded = self.TargetLevel + 8
	end

	self.CurrentLevel = self.CurrentLevel or self.TargetLevel
	self.CurrentPage = page_num
end

function PANEL:Think()
    if not input.IsKeyDown(KEY_F4) then
		self.CanClose = true
	end

	local focus = vgui.GetKeyboardFocus()

    if (input.IsKeyDown(KEY_ESCAPE) or (input.IsKeyDown(KEY_X) and not (focus and focus:GetClassName() == "TextEntry")) or (input.IsKeyDown(KEY_F4) and self.CanClose)) and not self.Closing then
        gui.HideGameUI()
        self:Close()
    end
end

for k, v in pairs(include("rp_base/gamemode/main/menus/f4menu/controls/rpui_seasonpass_additions_cl.lua") or {}) do
	PANEL[k] = v
end

function PANEL:Close()
    self.Closing = true

    self:AlphaTo(0, 0.25, 0, function()
        if IsValid(self) then
			self:Remove()
		end
    end)
end

function PANEL:Paint(pw, ph)
	if seasonpass_color then
		BGColor = seasonpass_back_color
		RainbowColor = seasonpass_color
		RainbowRotate = seasonpass_second_color

	else
		hue = SysTime() * 0.1 % 360

		BGColor = HSVToColor(hue, 0.8, 0.73)
		RainbowColor = HSVToColor(hue, 0.77, 0.77)
		RainbowRotate = HSLToColor(hue, 0.90, 0.40)
	end

	self.BGColor = BGColor
	self.RainbowColor = RainbowColor
	self.RainbowRotate = RainbowRotate
end

net.Receive('Seasonpass::GetReward', function()
	local result = net.ReadBool()

	if not IsValid(rp.seasonpass.Menu) then return end
	if not IsValid(rp.seasonpass.Menu.GetRewardInProgress) then return end

	if result then
		rp.seasonpass.Menu.GetRewardInProgress.Button.SetVisible(rp.seasonpass.Menu.GetRewardInProgress.Button, false)
		rp.seasonpass.Menu.awards_avlb[rp.seasonpass.Menu.GetRewardInProgress.IsDonated and 2 or 1][rp.seasonpass.Menu.GetRewardInProgress.Level] = nil
	end

	rp.seasonpass.Menu.GetRewardInProgress = nil
end)

vgui.Register("rpui.Seasonpass", PANEL, "EditablePanel")




local function redo_fonts()
	local frameH = ScrH()

    surface.CreateFont("rpui.Fonts.Seasonpass.Notify", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.027),
    })

    surface.CreateFont("rpui.Fonts.Social.Title", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.025), 25)
    })
end

timer.Simple(0, function()
	rp.RegisterLoginPopup(75, function()
		redo_fonts()

		local h_mul = math.floor(ScrH() * 0.195) / 150
		local menu = vgui.Create('urf.im/rpui/menus/blank')
		menu:SetSize(320 * h_mul, 175 * h_mul)
		menu:Center()
		menu:MakePopup()

		menu.header.SetIcon(menu.header, 'bubble_hints/gift.png')
		menu.header.SetTitle(menu.header, translates.Get('Battlepass'))
		menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
		menu.header.IcoSizeMult = 1.4 + 0

		local season = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()

		if IsValid(menu) and not season then
			menu:Remove()
			return
		end

		local dop_color = season.PremiumHeadBackColor and Color(season.PremiumHeadBackColor.r * 0.7, season.PremiumHeadBackColor.g * 0.7, season.PremiumHeadBackColor.b * 0.7, 255) or Color(255, 255, 255, 255)

		local label1 = vgui.Create("DLabel", menu.workspace)
		label1.Dock(label1, TOP)
		label1.SetTall(label1, h_mul * 23)
		label1.DockMargin(label1, 10, 22 * h_mul, 10, 0)
		label1.SetFont(label1, "rpui.Fonts.Social.Title")
		label1.SetContentAlignment(label1, 5)
		label1.SetText(label1, translates.Get("У вас есть награды Battlepass!"))

		local label2 = vgui.Create("DLabel", menu.workspace)
		label2.Dock(label2, TOP)
		label2.SetTall(label2, h_mul * 23)
		label2.DockMargin(label2, 10, 0, 10, 10)
		label2.SetFont(label2, "rpui.Fonts.Social.Title")
		label2.SetContentAlignment(label2, 5)
		label2.SetText(label2, translates.Get("Забрать их можно в F4 меню"))

		local ok = vgui.Create("DButton", menu.workspace)
		ok.Dock(ok, BOTTOM)
		ok.SetTall(ok, h_mul * 32)
		ok.DockMargin(ok, 10, 0, 10, 10)
		ok.SetText(ok, "")
		ok.Paint = function(npo, npo_w, npo_h)
			npo.rotAngle = (npo.rotAngle or 0) + 100 * FrameTime()
			local baseColor, textColor = rpui.GetPaintStyle(npo, STYLE_GOLDEN)
			surface.SetDrawColor(Color(0, 0, 0, npo:IsHovered() and 255 or 146))
			surface.DrawRect(0, 0, npo_w, npo_h)

			local distsize  = math.sqrt(npo_w * npo_w + npo_h * npo_h)
			local parentalpha = npo.GetParent(npo).GetParent(npo.GetParent(npo)).GetAlpha(npo.GetParent(npo).GetParent(npo.GetParent(npo))) / 255
			local alphamult   = npo._alpha / 255

			surface.SetAlphaMultiplier(parentalpha * alphamult)
				surface.SetDrawColor(dop_color)
				surface.DrawRect(0, 0, npo_w, npo_h)

				surface.SetMaterial(rpui.GradientMat)
				surface.SetDrawColor(season.PremiumHeadBackColor)
				surface.DrawTexturedRectRotated(npo_w * 0.5, npo_h * 0.5, distsize, distsize, (npo.rotAngle or 0))
			surface.SetAlphaMultiplier(1)

			draw.SimpleText(translates.Get("К НАГРАДАМ!"), "rpui.Fonts.Seasonpass.Notify" or npo:GetFont(), npo_w * 0.5, npo_h * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		ok.PaintOver = function(npop, npop_w, npop_h)
			rpui.DrawStencilBorder(npop, 0, 0, npop_w, npop_h, 0.04, dop_color, season.PremiumHeadBackColor, 1)
		end

		ok._DoClick = ok._DoClick or ok.DoClick
		ok.DoClick = function()
			local cseason = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()
			menu:Close();

			if not isbool(cseason) then
				local SeasonpassMenu = vgui.Create("rpui.Seasonpass")
				if cseason.NoPremium then
					SeasonpassMenu.SetSize(SeasonpassMenu, ScrW() * 0.75, ScrH() * 0.63)
				else
					SeasonpassMenu.SetSize(SeasonpassMenu, ScrW() * 0.75, ScrH() * 0.75)
				end
				SeasonpassMenu.Center(SeasonpassMenu)
				SeasonpassMenu.MakePopup(SeasonpassMenu)
			end
		end

	end, function()
		local awards_avlb = table.Copy(LocalPlayer():SeasonGetRewards())
		return (table.Count(awards_avlb[1]) > 0) or (LocalPlayer():SeasonIsDonated() and (table.Count(awards_avlb[2]) > 0))
	end)
end)