-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_attributes_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

PANEL.MatCache = {
    ["locked"] = Material( "rpui/seasonpass/tab_locked" ),
    ["unlocked"] = Material( "rpui/seasonpass/tab_received" ),
};

PANEL.TranslatesCache = {
    ["ПРОГРЕСС:"] = translates.Get( "ПРОГРЕСС:" ),
    ["УЛУЧШИТЬ НАВЫК"] = translates.Get( "УЛУЧШИТЬ НАВЫК" ),
    ["ДОСТУПНО ОЧКОВ АТРИБУТОВ"] = translates.Get( "ДОСТУПНО ОЧКОВ АТРИБУТОВ" ),
    ["ПОЛУЧИТЬ 1 ОЧКО"] = translates.Get( "ПОЛУЧИТЬ 1 ОЧКО" ),
    ["ЧТОБЫ СНОВА ПОЛУЧИТЬ ОЧКО, НУЖНО ПОДОЖДАТЬ"] = translates.Get( "ЧТОБЫ СНОВА ПОЛУЧИТЬ ОЧКО, НУЖНО ПОДОЖДАТЬ" ),
    ["ОТЫГРАНО НЕДОСТАТОЧНО ВРЕМЕНИ"] = translates.Get( "ОТЫГРАНО НЕДОСТАТОЧНО ВРЕМЕНИ" ),
    ["Текущий прогресс"] = translates.Get( "Текущий прогресс" ),
};

AccessorFunc( PANEL, "m_iPadding", "Padding", FORCE_NUMBER );


function PANEL:CustomButtonPaint( w, h, p ) 
	local baseColor, textColor = rpui.GetPaintStyle( self, STYLE_TRANSPARENT_SELECTABLE );
	
    surface.SetDrawColor( baseColor );
	surface.DrawRect( 0, 0, w, h );

    local ability = rp.abilities.GetByName( "1skillpts" );
    
    if ability then
        if ability and (not ability:InCooldown(LocalPlayer())) then
            if not self.SavedTextLength then
                surface.SetFont( self:GetFont() );
                self.SavedTextLength = surface.GetTextSize( self:GetText() ) * 0.5;
                self.BoxSize = h / 4.5;
            end

            draw.SimpleText( self:GetText(), self:GetFont(), w * 0.5 - self.BoxSize * 0.65, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            
            draw.RoundedBox( 3, w * 0.5 + self.SavedTextLength + self.BoxSize * 0.65 - self.BoxSize, h * 0.5 - h / 4.5, self.BoxSize, self.BoxSize, rpui.UIColors.Pink );
            draw.SimpleText( "1", "rpui.Fonts.F4Menu.TimeMultiplier", w * 0.5 + self.SavedTextLength + self.BoxSize * 0.15, h * 0.5 - h / 4.5 + self.BoxSize * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            
            return
        end
    end
	
    draw.SimpleText( self:GetText(), self:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );	
end


function PANEL:Init()
    self:SetPadding( 10 );

    -- Displayer:
    self.Displayer = vgui.Create( "Panel", self );
    self.Displayer:Dock( RIGHT );
    self.Displayer.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );

        if IsValid( self.SelectedAttribute ) then
            local alpha = self.Displayer.Content:GetAlpha() / 255;

            if self.SelectedAttribute.Material and this.Content.RawData then
                local aspect_w = h * self.SelectedAttribute.AspectH;
                
                local surf_alpha = surface.GetAlphaMultiplier();
                surface.SetAlphaMultiplier( surf_alpha * alpha );
                    surface.SetDrawColor( this.Content.RawData.Color );
                    surface.SetMaterial( self.SelectedAttribute.Material );
                    surface.DrawTexturedRect( w * 0.5 - aspect_w * 0.5, 0, aspect_w, h );
                surface.SetAlphaMultiplier( surf_alpha );
            end
        end
    end

    self.Displayer.Content = vgui.Create( "Panel", self.Displayer );
    self.Displayer.Content:Dock( FILL );
    self.Displayer.Content:SetAlpha( 0 );

    self.Displayer.Content.Title = vgui.Create( "Panel", self.Displayer.Content );
    self.Displayer.Content.Title:Dock( TOP );
    self.Displayer.Content.Title.Think = function( this )
        this:SizeToChildren( false, true );
    end

    self.Displayer.Content.Description = vgui.Create( "Panel", self.Displayer.Content );
    self.Displayer.Content.Description:Dock( TOP ); 
    self.Displayer.Content.Description.Think = function( this )
        this:SizeToChildren( false, true );
    end

    self.Displayer.Content.TitleProgress = vgui.Create( "DLabel", self.Displayer.Content );
    self.Displayer.Content.TitleProgress:Dock( TOP );
    self.Displayer.Content.TitleProgress:SetText( self.TranslatesCache["ПРОГРЕСС:"] );
    self.Displayer.Content.TitleProgress.Paint = function( this, w, h )
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, this:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Displayer.Content.Progress = vgui.Create( "DLabel", self.Displayer.Content );
    self.Displayer.Content.Progress:Dock( TOP );
    self.Displayer.Content.Progress.Paint = function( this, w, h )
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, this:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Displayer.Content.ProgressList = vgui.Create( "Panel", self.Displayer.Content );
    self.Displayer.Content.ProgressList:Dock( TOP ); 
    self.Displayer.Content.ProgressList.Think = function( this )
        this:SizeToChildren( false, true );
    end
    
    self.Displayer.Content.SpendButton = vgui.Create( "DButton", self.Displayer.Content );
    self.Displayer.Content.SpendButton:Dock( BOTTOM );
    self.Displayer.Content.SpendButton:SetTall( 0 );
    self.Displayer.Content.SpendButton:SetText( self.TranslatesCache["УЛУЧШИТЬ НАВЫК"] );
    self.Displayer.Content.SpendButton.Think = function( this )
        if (LocalPlayer():GetAttributeSystemPoints() < 1) then
            if this:GetTall() ~= 0 then this:SetTall( 0 ); end
            return
        end
        
        if IsValid( self.SelectedAttribute ) and (LocalPlayer():GetAttributeAmount(self.SelectedAttribute.RawData.ID) >= self.SelectedAttribute.RawData.MaxAmount) then
            if this:GetTall() ~= 0 then this:SetTall( 0 ); end
            return
        end

        if this:GetTall() == 0 then
            this:SizeToContentsY( self:GetPadding() * 2 );
        end
    end
    self.Displayer.Content.SpendButton.DoClick = function()
        if not IsValid( self.SelectedAttribute ) then return end

        LocalPlayer():RequestUpgradeAttributes( {
            [self.SelectedAttribute.RawData.ID] = 1
        } );
    end
    self.Displayer.Content.SpendButton.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true 
    end

    -- Footer:
    self.Footer = vgui.Create( "Panel", self );
    self.Footer:Dock( BOTTOM );

    self.Footer.AttributePoints = vgui.Create( "DLabel", self.Footer );
    self.Footer.AttributePoints:SetTextColor( rpui.UIColors.White );
    self.Footer.AttributePoints.Think = function( this )
        this:SetText( string.format("%s: %d", self.TranslatesCache["ДОСТУПНО ОЧКОВ АТРИБУТОВ"], LocalPlayer():GetAttributeSystemPoints()) );
        this:SizeToContents();
        this:CenterHorizontal();
    end

    local ability = rp.abilities.GetByName( "1skillpts" );
    if ability then
        self.Footer.BonusButton = vgui.Create( "DButton", self.Footer );
        self.Footer.BonusButton:SetText( self.TranslatesCache["ПОЛУЧИТЬ 1 ОЧКО"] );
        self.Footer.BonusButton:SetEnabled( false );
        self.Footer.BonusButton.DoClick = function( this )
			if ability:InCooldown( LocalPlayer() ) then
				this:SetEnabled( false );
				this:SetText( self.TranslatesCache["ЧТОБЫ СНОВА ПОЛУЧИТЬ ОЧКО, НУЖНО ПОДОЖДАТЬ"] );
                this:SizeToContentsX( this:GetTall() * 2 );
                this:CenterHorizontal();
				return
			end

			if ability:GetPlayTime( LocalPlayer() ) > LocalPlayer():GetPlayTime() then
				this:SetEnabled( false );
				this:SetText( self.TranslatesCache["ОТЫГРАНО НЕДОСТАТОЧНО ВРЕМЕНИ"] );
                this:SizeToContentsX( this:GetTall() * 2 );
                this:CenterHorizontal();
				return
			end
			
			net.Start( "AbilityUse" );
				net.WriteInt( ability:GetID(), 6 );
			net.SendToServer();
			
			this:SetEnabled( false );
			this:SetText( self.TranslatesCache["ЧТОБЫ СНОВА ПОЛУЧИТЬ ОЧКО, НУЖНО ПОДОЖДАТЬ"] );
            this:SizeToContentsX( this:GetTall() * 2 );
            this:CenterHorizontal();
		end
        
		self.Footer.BonusButton.Think = function( this )
			if ability:InCooldown( LocalPlayer() ) then
				this:SetText( translates.Get("ЧЕРЕЗ %s ВЫ СМОЖЕТЕ ПОЛУЧИТЬ ЕЩЁ 1 ОЧКО!",
                    ba.str.FormatTime( ability:GetRemainingCooldown(LocalPlayer()) )
                ) );

                this:SizeToContentsX( this:GetTall() * 2 );
                this:CenterHorizontal();

                return
            end

            if ability:GetPlayTime( LocalPlayer() ) > LocalPlayer():GetPlayTime() then
				this:SetText( self.TranslatesCache["ОТЫГРАНО НЕДОСТАТОЧНО ВРЕМЕНИ"] );

                this:SizeToContentsX( this:GetTall() * 2 );
                this:CenterHorizontal();

				return
			end

            if not this:IsEnabled() then
                this:SetText( self.TranslatesCache["ПОЛУЧИТЬ 1 ОЧКО"] );
                this:SizeToContentsX( this:GetTall() * 2 );
                this:CenterHorizontal();
                this:SetEnabled( true );
            end
		end

        self.Footer.BonusButton.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true 
        end
    end

    -- Content:
    self.Content = vgui.Create( "rpui.ScrollPanel", self );
    self.Content:Dock( FILL );

    self:RebuildAttributes();
end


function PANEL:SelectAttribute( id )
    local AttributeButton = self.Attributes[id];

    if self.SelectedAttribute and (self.SelectedAttribute == AttributeButton) then
        return
    end

    self.Displayer.Content:Stop();
    self.Displayer.Content:AlphaTo( 0, 0.25, 0, function( _, this )
        if not IsValid( this ) then return end

        local AttributeButton = self.Attributes[id];

        this.RawData = AttributeButton.RawData;
    
        this.Title:Clear();
        this.Title:SetTall( 0 );
        
        for _, text in ipairs( string.Wrap("rpui.Fonts.Attributes.TitleBold", AttributeButton:GetText(), this:GetWide()) ) do
            local TitleLabel = vgui.Create( "DLabel", this.Title );
            TitleLabel:Dock( TOP );
            TitleLabel:SetFont( "rpui.Fonts.Attributes.TitleBold" );
            TitleLabel:SetText( string.Trim(text) );
            TitleLabel.Paint = function( this, w, h )
                draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, this:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
        end

        this.Title:SetText( AttributeButton:GetText() );
        
        this.Description:Clear();
        this.Description:SetTall( 0 );
    
        for _, text in ipairs( string.Explode("\n", this.RawData.Desc) ) do
            text = string.Trim( text );
            if #text < 1 then continue end
    
            local DescLabel = vgui.Create( "DLabel", this.Description );
            DescLabel:Dock( TOP );
            DescLabel:DockMargin( 0, 0, self:GetPadding(), self:GetPadding() );
            DescLabel:SetFont( "rpui.Fonts.Attributes.DefaultThin" );
            DescLabel:SetWrap( true );
            DescLabel:SetAutoStretchVertical( true );
            DescLabel:SetText( text );
            DescLabel:SetTextInset( self:GetPadding() * 3, 0 );
            DescLabel:SetTextColor( rpui.UIColors.White );
    
            DescLabel.PaintOver = function( me, w, h )
                draw.SimpleText( "●", me:GetFont(), self:GetPadding(), 0, me:GetTextColor() );
            end
        end
        
        this.Progress.Think = function( me )
            me:SetText( string.format(
                (this.RawData.ProgressText or self.TranslatesCache["Текущий прогресс"]) .. ": %i%% / %i%%",
                LocalPlayer():GetAttributeAmount(this.RawData.ID),
                this.RawData.MaxAmount
            ) );
        end
    
        this.ProgressList:Clear();
        this.ProgressList:SetTall( 0 );
    
        for _, Item in ipairs( this.RawData.ProgressList or {} ) do
            local ProgressItem = vgui.Create( "DLabel", this.ProgressList );
            ProgressItem.Locked = true;
            
            ProgressItem:Dock( TOP );
            ProgressItem:DockMargin( 0, 0, self:GetPadding() * 3, self:GetPadding() );
            ProgressItem:SetFont( "rpui.Fonts.Attributes.DefaultThin" );
            ProgressItem:SetWrap( true );
            ProgressItem:SetAutoStretchVertical( true );
            ProgressItem:SetText( Item[1] );
            ProgressItem:SetTextColor( rpui.UIColors.White );
            ProgressItem.Think = function( me )
                me.Locked = LocalPlayer():GetAttributeAmount(this.RawData.ID) < Item[2];
            end
    
            surface.SetFont( ProgressItem:GetFont() );
            local tw, th = surface.GetTextSize(" ");
            local s = th * 0.85;
    
            ProgressItem:SetTextInset( self:GetPadding() + s + self:GetPadding() * 3, 0 );
    
            ProgressItem.PaintOver = function( me, w, h )
                surface.SetDrawColor( rpui.UIColors.White );
                surface.SetMaterial( self.MatCache[me.Locked and "locked" or "unlocked"] );
                surface.DrawTexturedRect( self:GetPadding() * 3, math.min(th,h) - s, s, s );
            end
        end

        this.Title:InvalidateLayout( true );
        this.Description:InvalidateLayout( true );
        this.ProgressList:InvalidateLayout( true );
    
        timer.Simple( RealFrameTime() * 5, function()
            if not IsValid( this ) then return end
    
            this:AlphaTo( 255, 0.25 );
        end );
    end );

    self.SelectedAttribute = AttributeButton;
end


function PANEL:RebuildAttributes()
    self.Content:ClearItems();
    self.Attributes = {};

    for AttributeID, AttributeAmount in pairs( LocalPlayer():GetAttributes() ) do
        local AttributeButton = vgui.Create( "DButton" );
        
        AttributeButton.RawData = AttributeSystem.getAttribute( AttributeID );

        AttributeButton:Dock( TOP );
        AttributeButton:SetText( utf8.upper(AttributeButton.RawData.Name) );
        
        AttributeButton.m_iDelta = 0.5;
        AttributeButton.GetDelta = function( this ) return this.m_iDelta; end
        AttributeButton.SetDelta = function( this, dt ) this.m_iDelta = dt; end

        AttributeButton.Paint = function( this, w, h )
            this:SetDelta( LocalPlayer():GetAttributeAmount(AttributeID) / this.RawData.MaxAmount );

            local isSelected = self.SelectedAttribute == this;
            this.SelectedFade = Lerp( FrameTime() * 6, this.SelectedFade or 1, isSelected and 0 or 1 );
            
            local p = h * 0.1;

            if not this.Material then
                this.Material = Material( AttributeButton.RawData.Background or "rpui/attributes/debug.png", "smooth" );
                this.AspectW = this.Material:Height() / this.Material:Width();
                this.AspectH = this.Material:Width() / this.Material:Height();
            end
            
            local clr = AttributeButton.RawData.Color;
                local clr_dt = 1 - this.SelectedFade;
                
                surface.SetDrawColor( Color(
                    127 + (clr.r - 127) * clr_dt,
                    127 + (clr.g - 127) * clr_dt,
                    127 + (clr.b - 127) * clr_dt
                ) );
            surface.SetMaterial( this.Material );
            local aspect_h = w * this.AspectW;
            surface.DrawTexturedRect( 0, h * 0.5 - aspect_h * 0.5, w, aspect_h );

           
            draw.SimpleText( this:GetText(), isSelected and "rpui.Fonts.Attributes.TitleBold" or "rpui.Fonts.Attributes.Title", p * 4, h * 0.25, this:GetTextColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

            local pbar_x, pbar_y = p * 4, h * 0.5;
            local pbar_w, pbar_h = w - p * 8, h * 0.5 - p;

            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( pbar_x, pbar_y, pbar_w, pbar_h );
            
            local surf_alpha = surface.GetAlphaMultiplier();
                surface.SetAlphaMultiplier( surf_alpha * 0.85 );
                surface.SetDrawColor( clr );
                surface.DrawRect( pbar_x, pbar_y, pbar_w * math.Clamp(this:GetDelta(), 0, 1), pbar_h );
                
                surface.SetAlphaMultiplier( surf_alpha * 0.25 );
                surface.SetDrawColor( rpui.UIColors.White );
                surface.DrawOutlinedRect( pbar_x, pbar_y, pbar_w, pbar_h, self:GetPadding() * 0.25 );
            surface.SetAlphaMultiplier( surf_alpha );

            draw.SimpleText( math.Round(this:GetDelta() * this.RawData.MaxAmount) .. " / " .. this.RawData.MaxAmount, "rpui.Fonts.Attributes.Progress", pbar_x + pbar_w * 0.5, pbar_y + pbar_h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            return true
        end

        AttributeButton.DoClick = function( this )
            self:SelectAttribute( AttributeID );
        end

        self.Content:AddItem( AttributeButton );
        self.Attributes[AttributeID] = AttributeButton;
    end

    self:InvalidateLayout( true );
end


function PANEL:RebuildFonts( w, h )
    -- TitleBold
    surface.CreateFont( "rpui.Fonts.Attributes.TitleBold", {
        font     = "Montserrat",
        size     = w * 0.025,
        weight   = 1000,
        extended = true,
    } );

    self.Displayer.Content.Title.TextFont = "rpui.Fonts.Attributes.TitleBold";
    self.Displayer.Content.TitleProgress:SetFont( "rpui.Fonts.Attributes.TitleBold" );
    self.Footer.AttributePoints:SetFont( "rpui.Fonts.Attributes.TitleBold" );

    -- Title
    surface.CreateFont( "rpui.Fonts.Attributes.Title", {
        font     = "Montserrat",
        size     = w * 0.025,
        weight   = 0,
        extended = true,
    } );

    -- TitleThin
    surface.CreateFont( "rpui.Fonts.Attributes.TitleThin", {
        font     = "Montserrat",
        size     = w * 0.0225,
        weight   = 0,
        extended = true,
    } );

    self.Displayer.Content.SpendButton:SetFont( "rpui.Fonts.Attributes.TitleThin" );

    if IsValid( self.Footer.BonusButton ) then
        self.Footer.BonusButton:SetFont( "rpui.Fonts.Attributes.TitleThin" );
    end
    
    -- Progress
    surface.CreateFont( "rpui.Fonts.Attributes.Progress", {
        font     = "Montserrat",
        size     = w * 0.0175,
        weight   = 1000,
        extended = true,
    } );

    -- Default
    surface.CreateFont( "rpui.Fonts.Attributes.Default", {
        font     = "Montserrat",
        size     = w * 0.01725,
        weight   = 600,
        extended = true,
    } );

    self.Displayer.Content.Progress:SetFont( "rpui.Fonts.Attributes.Default" );

    -- DefaultThin
    surface.CreateFont( "rpui.Fonts.Attributes.DefaultThin", {
        font     = "Montserrat",
        size     = w * 0.01725,
        weight   = 200,
        extended = true,
    } );
end


function PANEL:PerformLayout( w, h )
    self:RebuildFonts( w, h );

    local p = self:GetPadding();

    -- Displayer:
    self.Displayer:SetWide( w * 0.4 );
    self.Displayer:DockMargin( p * 2, 0, 0, 0 );

    self.Displayer.Content:DockMargin( p, p * 4, p, p * 4 );
    
    self.Displayer.Content.Title:DockMargin( 0, 0, 0, p * 2 );
    self.Displayer.Content.Title:SizeToContents();
    
    self.Displayer.Content.SpendButton:DockMargin( p, p, p, p );
    self.Displayer.Content.SpendButton:SizeToContentsY( p * 2 );
    
    self.Displayer.Content.Description:DockMargin( 0, 0, 0, p * 4 );
    self.Displayer.Content.Description:SizeToChildren( false, true );

    self.Displayer.Content.TitleProgress:DockMargin( 0, 0, 0, p );

    self.Displayer.Content.Progress:DockMargin( 0, 0, 0, p * 2 );

    self.Displayer.Content.ProgressList:DockMargin( 0, 0, 0, p * 2 );

    -- Footer:
    self.Footer.AttributePoints:SetY( 0 );
    self.Footer.AttributePoints:SizeToContents();
    self.Footer.AttributePoints:CenterHorizontal();

    if IsValid( self.Footer.BonusButton ) then
        self.Footer.BonusButton:SizeToContentsY( p * 2 );
        self.Footer.BonusButton:SizeToContentsX( self.Footer.BonusButton:GetTall() * 2 );
        self.Footer.BonusButton:CenterHorizontal();
    end

    if IsValid( self.Footer.BonusButton ) then
        self.Footer.BonusButton:SetY( self.Footer.AttributePoints:GetY() + p + self.Footer.AttributePoints:GetTall() );
    end

    self.Footer:SizeToChildren( false, true );
    self.Footer:DockMargin( 0, p, 0, 0 );

    -- Content:
    self.Content:SetScrollbarMargin( p );
    self.Content:SetSpacingY( p );

    for _, AttributeButton in pairs( self.Attributes or {} ) do
        AttributeButton:DockMargin( 0, 0, 0, p );
        AttributeButton:SetTall( w * 0.1 );

        if not self.SelectedAttribute then
            AttributeButton:DoClick();
        end
    end
end


vgui.Register( "rpui.AttributesMenu", PANEL, "EditablePanel" );
