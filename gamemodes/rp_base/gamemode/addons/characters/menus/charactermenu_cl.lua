-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\menus\\charactermenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ipairs, pairs, select, IsValid, GetHostName, Lerp, LerpVector, LocalToWorld, RealFrameTime = ipairs, pairs, select, IsValid, GetHostName, Lerp, LerpVector, LocalToWorld, RealFrameTime;
local Material, Color, Vector, Angle = Material, Color, Vector, Angle;
local isbool, isnumber, istable = isbool, isnumber, istable;
local translates_Get = translates.Get;
local rpui_GradientMat, rpui_PowOfTwo, rpui_GetPaintStyle, rpui_DrawStencilBorder, rpui_BakeText = rpui.GradientMat, rpui.PowOfTwo, rpui.GetPaintStyle, rpui.DrawStencilBorder, rpui.BakeText;
local surface_CreateFont, surface_GetTextSize, surface_GetAlphaMultiplier, surface_SetAlphaMultiplier, surface_SetDrawColor, surface_SetFont, surface_SetMaterial, surface_DrawRect, surface_DrawOutlinedRect, surface_DrawTexturedRect, surface_DrawTexturedRectRotated, surface_DrawPoly = surface.CreateFont, surface.GetTextSize, surface.GetAlphaMultiplier, surface.SetAlphaMultiplier, surface.SetDrawColor, surface.SetFont, surface.SetMaterial, surface.DrawRect, surface.DrawOutlinedRect, surface.DrawTexturedRect, surface.DrawTexturedRectRotated, surface.DrawPoly;
local draw_SimpleText, draw_Blur, draw_NoTexture = draw.SimpleText, draw.Blur, draw.NoTexture;
local timer_Simple = timer.Simple;
local vgui_Create, vgui_Register, vgui_GetHoveredPanel, vgui_GetWorldPanel = vgui.Create, vgui.Register, vgui.GetHoveredPanel, vgui.GetWorldPanel;
local hook_Add, hook_Remove = hook.Add, hook.Remove;
local input_GetCursorPos, input_IsMouseDown = input.GetCursorPos, input.IsMouseDown;
local math_random, math_sqrt, math_ceil, math_Round = math.random, math.sqrt, math.ceil, math.Round;
local table_GetKeys, table_insert = table.GetKeys, table.insert;
local string_format, string_find, string_lower, string_Trim = string.format, string.find, string.lower, string.Trim;
local utf8_upper = utf8.upper;


----------------------------------------------------------------
local PANEL = {};


local cfg_CharacterMenu = rp.cfg.CharacterMenu or {};
local cfg_CharacterMenu_Background, cfg_CharacterMenu_Colors = cfg_CharacterMenu.Background, cfg_CharacterMenu.Colors or {};


PANEL.Screens = {};

PANEL.TranslateCache = {
    ["ЗАГРУЗКА..."] = translates_Get( "ЗАГРУЗКА..." ),
    ["ПОДОЖДИТЕ..."] = translates_Get( "ПОДОЖДИТЕ..." ),
    ["ВОЙТИ КАК"] = translates_Get( "ВОЙТИ КАК" ),
    ["РЕГИСТРАЦИЯ"] = translates_Get( "РЕГИСТРАЦИЯ" ),
    ["ИГРАТЬ"] = translates_Get( "ИГРАТЬ" ),
    ["ВЕРНУТЬСЯ"] = translates_Get( "ВЕРНУТЬСЯ" ),
    ["ВЫ ХОТИТЕ УДАЛИТЬ"] = translates_Get( "ВЫ ХОТИТЕ УДАЛИТЬ" ),
    ["Удалить"] = translates_Get( "Удалить" ),
    ["Отмена"] = translates_Get( "Отмена" ),
    ["СОЗДАТЬ НОВОГО ПЕРСОНАЖА"] = translates_Get( "СОЗДАТЬ НОВОГО ПЕРСОНАЖА" ),
    ["СОЗДАТЬ ПЕРСОНАЖА"] = translates_Get( "СОЗДАТЬ ПЕРСОНАЖА" ),
    ["ИМЯ ПЕРСОНАЖА"] = translates_Get( "ИМЯ ПЕРСОНАЖА" ),
    ["ФАМИЛИЯ ПЕРСОНАЖА"] = translates_Get( "ФАМИЛИЯ ПЕРСОНАЖА" ),
    ["Введите имя"] = translates_Get( "Введите имя" ),
    ["Введите фамилию"] = translates_Get( "Введите фамилию" ),
    ["РОСТ"] = translates_Get( "РОСТ" ),
    ["СКИН"] = translates_Get( "СКИН" ),
    ["МОДЕЛЬ"] = translates_Get( "МОДЕЛЬ" ),
    ["СЛУЧАЙНЫЙ ВЫБОР"] = translates_Get( "СЛУЧАЙНЫЙ ВЫБОР" ),
    ["Организация"] = translates_Get( "Организация" ),
    ["Сторона"] = translates_Get( "Сторона" ),
    ["Неизвестная ошибка, пожалуйста, повторите попытку"] = translates_Get( "Неизвестная ошибка, пожалуйста, повторите попытку" ),
    ["InfoLabel"] = translates_Get("Ваши персонажи имеют общий кошелёк, инвентарь и прочий внутриигровой прогресс\nНовые персонажи нужны для вступления в разные организации\nИзменить никнейм после регистрации невозможно"),
};

PANEL.MaterialCache = {
    ["trashbin"] = Material( "rpui/icons/trashbin.png", "smooth" ),
    ["random"]   = Material( "rpui/icons/random.png", "smooth" ),
    ["gradient"] = rpui_GradientMat,
    ["outline"]  = Material( "rpui/charactermenu/outline" ),
};

PANEL.ErrorHandlers = {
    [CHARSYSTEM_REGISTER_ERROR_LIMIT]  = translates_Get( "Ошибка сервера, пожалуйста, повторите попытку" ),
    [CHARSYSTEM_REGISTER_ERROR_SHORTF] = translates_Get( "Имя персонажа слишком короткое (мин. длина - 3 символа)" ),
    [CHARSYSTEM_REGISTER_ERROR_SHORTL] = translates_Get( "Фамилия персонажа слишком короткая (мин. длина - 3 символа)" ),
    [CHARSYSTEM_REGISTER_ERROR_LONGN]  = translates_Get( "Имя персонажа слишком длинное (макс. длина - 32 символа)" ),
    [CHARSYSTEM_REGISTER_ERROR_BAD]    = translates_Get( "В имени присутствуют недопустимые символы" ),
    [CHARSYSTEM_REGISTER_ERROR_SVFAIL] = translates_Get( "Ошибка сервера, пожалуйста, повторите попытку" ),
    [CHARSYSTEM_REGISTER_ERROR_EXISTS] = translates_Get( "Данное имя уже кем-то занято, выберите другое" ),
};

PANEL.CharacterSequences = {
    "pose_standing_01",
    "pose_standing_02",
    "d1_t01_breakroom_watchbreen",
};

PANEL.Colors = {
    cfg_CharacterMenu_Colors[1] or rpui.UIColors.BackgroundGold;
    cfg_CharacterMenu_Colors[2] or rpui.UIColors.Gold;
};

PANEL.ParallaxElements = cfg_CharacterMenu_Background or {
    {
        mat   = Material("rpui/donatemenu/sparkles"),
        color = rpui.UIColors.White,
        range = -0.5,
        speed = 1,
    },

    {
        mat = Material("rpui/donatemenu/flash_bottom"),
    },

    {
        mat = Material("rpui/donatemenu/flash_middle"),
    },

    {
        mat = Material("rpui/donatemenu/flash_top"),
    },

    {
        mat   = Material("rpui/donatemenu/shards"),
        range = 0.5,
        speed = 1,
    },
};
----------------------------------------------------------------


function PANEL:RebuildFonts( w, h )
    surface_CreateFont( "rpui.Fonts.CharacterMenu.Tooltip", {
        font     = "Montserrat",
        size     = h * 0.0175,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.Header", {
        font     = "Montserrat",
        size     = w * 0.025,
        weight   = 800,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.Hostname", {
        font     = "Montserrat",
        size     = w * 0.025,
        weight   = 1000,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.Select", {
        font     = "Montserrat",
        size     = h * 0.0325,
        weight   = 800,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.Title", {
        font     = "Montserrat",
        size     = h * 0.0325,
        weight   = 500,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.Desc", {
        font     = "Montserrat",
        size     = h * 0.02,
        weight   = 500,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.DescBold", {
        font     = "Montserrat",
        size     = h * 0.03,
        weight   = 800,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.RegButton", {
        font     = "Montserrat",
        size     = w * 0.0135,
        weight   = 1000,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.RegLabel", {
        font     = "Montserrat",
        size     = w * 0.015,
        weight   = 500,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.RegError", {
        font     = "Montserrat",
        size     = w * 0.0125,
        weight   = 500,
        extended = true,
    } );

    surface_CreateFont( "rpui.Fonts.CharacterMenu.RegErrorIcon", {
        font     = "Montserrat",
        size     = w * 0.014,
        weight   = 1000,
        extended = true,
    } );
end

local TOOLTIP_OFFSET_LEFT = 0.1 + 0;
local TOOLTIP_OFFSET_CENTER = 0.5 + 0;

function PANEL:RegisterTooltip( panel, textfunc, offset, parentwidth, posfunc )
    if not self.Tooltip then
        self.Tooltip = vgui.Create( "Panel", self );
        self.Tooltip.SetMouseInputEnabled( self.Tooltip, false );
        self.Tooltip.SetAlpha( self.Tooltip, 0 );
        self.Tooltip.ArrowHeight = 0.01 * self.frameH;
        self.Tooltip.DockPadding( self.Tooltip, self.frameW * 0.0075, self.frameH * 0.005, self.frameW * 0.0075, self.frameH * 0.005 + self.Tooltip.ArrowHeight );

        self.Tooltip.Label = vgui.Create( "DLabel", self.Tooltip );
        self.Tooltip.Label.Dock( self.Tooltip.Label, TOP );
        self.Tooltip.Label.SetWrap( self.Tooltip.Label, true );
        self.Tooltip.Label.SetAutoStretchVertical( self.Tooltip.Label, true );
        self.Tooltip.Label.SetFont( self.Tooltip.Label, "rpui.Fonts.CharacterMenu.Tooltip" );
        self.Tooltip.Label.SetTextColor( self.Tooltip.Label, rpui.UIColors.White );
        self.Tooltip.Label.SetText( self.Tooltip.Label, "" );

        self.Tooltip.TooltipOffset = -1;
        self.Tooltip.IsActive      = false;

        self.Tooltip.Paint = function( this, w, h )
            if string.Trim(this.Label.GetText(this.Label)) ~= "" then
                surface_SetDrawColor( rpui.UIColors.Tooltip );
                surface_DrawRect( 0, 0, w, h - this.ArrowHeight );

                if this.BakedPoly then
                    draw_NoTexture();
                    surface_DrawPoly( this.BakedPoly );
                end
            end
        end

        self.Tooltip.Think = function( this )
            if IsValid( this.ActivePanel ) then
                if not this.IsActive then
                    this.IsActive = true;
                    this:Stop();
                    this:SetAlpha( 0 );

                    this:SetWide( this.ActivePanel.GetWide(this.ActivePanel) );

                    this.Label.SetText( this.Label, isfunction(this.ActivePanel.TooltipText) and this.ActivePanel.TooltipText(this.ActivePanel) or this.ActivePanel.TooltipText );
                    this.Label.SetText( this.Label, string_Trim(this.Label.GetText(this.Label)) );
                    this.Label.SizeToContents(this.Label);

                    if not this.ActivePanel.TooltipWidth then
                        surface_SetFont( this.Label.GetFont(this.Label) );
                        local text_w, text_h = surface_GetTextSize( this.Label.GetText(this.Label) );
                        local pl, pt, pr, pb = this:GetDockPadding();
                        this:SetWide( pl + text_w + pr );
                    end

                    timer.Simple( FrameTime() * 10, function()
                        if not IsValid( self ) then return end

                        if not IsValid(this.ActivePanel) then return end

                        this:SizeToChildren( false, true );

                        local x = 0;
                        local y = 0;
                        local w = 0;
                        local h = 0;

                        if this.ActivePanel.TooltipPosFunc then
                            x, y = this.ActivePanel.TooltipPosFunc(this.ActivePanel);
                        else
                            x, y = this.ActivePanel.LocalToScreen( this.ActivePanel, 0, 0 );
                        end

                        w, h = this:GetSize();

                        this:AlphaTo( 255, 0.25 );

                        this.TooltipOffset = this.ActivePanel.TooltipOffset;

                        if this.TooltipOffset == -1 then
                            this.BakedPoly = {
                                { x = w * this.TooltipOffset - this.ArrowHeight * 0.5, y = h - this.ArrowHeight - 1 },
                                { x = w * this.TooltipOffset + this.ArrowHeight * 0.5, y = h - this.ArrowHeight - 1 },
                                { x = w * this.TooltipOffset,                          y = h },
                            };

                            this.Label.SetContentAlignment( this.Label, 5 );
                            if not this.ActivePanel.TooltipPosFunc then
                                this:SetPos( x - w * 0.5 + this.ActivePanel.GetWide(this.ActivePanel) * 0.5, y - h - self.frameH * 0.0015 );
                            else
                                this:SetPos( x - w * 0.5, y - h - self.frameH * 0.0015 );
                            end
                        else
                            this.TooltipOffset = this.ActivePanel:GetWide() * 0.5;

                            this.BakedPoly = {
                                { x = this.TooltipOffset - this.ArrowHeight * 0.5, y = h - this.ArrowHeight - 1 },
                                { x = this.TooltipOffset + this.ArrowHeight * 0.5, y = h - this.ArrowHeight - 1 },
                                { x = this.TooltipOffset,                          y = h },
                            };

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

            if IsValid( self.Tooltip ) then self.Tooltip.ActivePanel = this; end
        end

        panel.OnCursorExited = function( this )
            if this._OnCursorExited then
                this._OnCursorExited();
            end

            if IsValid( self.Tooltip ) then self.Tooltip.ActivePanel = nil; end
        end
    end
end


function PANEL:Close()
    local Parent = self:GetParent();

    if IsValid( Parent ) and Parent ~= vgui_GetWorldPanel() then
        self = Parent;
    end

    self:AlphaTo( 0, 0.5, 0, function()
        if IsValid( self ) then self:Remove(); end
    end );
end


function PANEL:AddScreen( screen )
    local id = #self.Screens + 1;

    if screen:GetParent() ~= self.Content then
        screen:SetParent( self.Content );
    end

    screen:SetSize( self.Content:GetSize() );
    screen:Hide();

    self.Screens[id] = screen;

    return id;
end


function PANEL:SelectScreen( id )
    if self.IsSwapping then return end

    local screen = self.Screens[id];
    if not screen then return end

    self.IsSwapping = true;

    self.Content:AlphaTo( 0, 0.5, 0, function( anim, this )
        if IsValid( self.ActiveScreen ) then
            self.ActiveScreen:Hide();
        end

        self.ActiveScreen = screen;
        self.ActiveScreen:Show();

        this:AlphaTo( 255, 0.5, 0, function()
            self.IsSwapping = nil;
        end );
    end );
end


function PANEL:Paint( w, h )
    self:MoveToFront();

    surface_SetDrawColor( rpui.UIColors.Black );
    surface_DrawRect( 0, 0, w, h );

    local mX, mY;
    if system.HasFocus() then
        mX, mY = self:LocalCursorPos();
    else
        mX, mY = 0, 0;
    end

    mX = mX - w * 0.5;
    mY = mY - h * 0.5;

    for _, e in pairs( self.ParallaxElements ) do
        if not e.mat then continue end

        e.speed = e.speed or 0;
        e.range = e.range or 0;

        e.x = Lerp( 0.005 * e.speed, (e.x or 0), mX * e.range );
        e.y = Lerp( 0.005 * e.speed, (e.y or 0), mY * e.range );

        local sw = w * (e.sizew or 1);
        local sh = h * (e.sizeh or 1);

        surface_SetDrawColor( e.color or rpui.UIColors.White );
        surface_SetMaterial( e.mat );
        surface_DrawTexturedRect( e.x + w * 0.5 - sw * 0.5, e.y + h * 0.5 - sh * 0.5, sw, sh );
    end
end


function PANEL:Init()
    timer_Simple( RealFrameTime() * 15, function()
        if not IsValid( self ) then return end

        if not self.b_ReInitialized then
            self.b_ReInitialized = true;
            self:Init();
        end
    end );

    if not self.b_ReInitialized then return end

    local frameW, frameH = self:GetSize();

    self.frameW, self.frameH = frameW, frameH;
    self.innerPadding        = self.frameH * 0.05;

    self:RebuildFonts( self.frameW, self.frameH );

    self:DockPadding( 0, self.innerPadding, 0, 0 );

    self.Header = vgui_Create( "EditablePanel", self );
    self.Header:Dock( TOP );
    self.Header:DockMargin( self.innerPadding, 0, self.innerPadding, self.innerPadding );
    self.Header:SetTall( self.frameW * 0.05 );

    self.Header.ScreenTitle = vgui_Create( "EditablePanel", self.Header );
    self.Header.ScreenTitle:Dock( LEFT );
    self.Header.ScreenTitle:InvalidateParent( true );
    self.Header.ScreenTitle:DockMargin( 0, 0, self.innerPadding, 0 );
    self.Header.ScreenTitle:SetWide( self.Header.ScreenTitle:GetTall() * 4.5 );
    self.Header.ScreenTitle.Paint = function( this, w, h )
        surface_SetDrawColor( rpui.UIColors.Background );

        surface_DrawRect( 0, 0, w, h );

        if self.Content then
            local surf_alpha = surface_GetAlphaMultiplier();

            surface_SetAlphaMultiplier( surf_alpha * (self.Content:GetAlpha() / 255) );
                draw_SimpleText( self.ActiveScreen and (self.ActiveScreen.Title or self.TranslateCache["ЗАГРУЗКА..."]) or self.TranslateCache["ЗАГРУЗКА..."], "rpui.Fonts.CharacterMenu.Header", w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            surface_SetAlphaMultiplier( surf_alpha );
        end
    end

    if LocalPlayer().i_CharacterID then
        self.Header.Close = vgui_Create( "DButton", self.Header );
        self.Header.Close:Dock( RIGHT );
        self.Header.Close:InvalidateParent( true );
        self.Header.Close:DockMargin( self.innerPadding, 0, 0, 0 );
        self.Header.Close:SetWide( self.Header.Close:GetTall() );
        self.Header.Close.DoClick = function( this )
            self:Close();
        end
        self.Header.Close.Paint = function( this, w, h )
            local baseColor, textColor = rpui_GetPaintStyle( this );
            surface_SetDrawColor( baseColor );
            surface_DrawRect( 0, 0, w, h );
            draw_SimpleText( "✕", "rpui.Fonts.CharacterMenu.Header", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
    end

    self.Header.Hostname = vgui_Create( "EditablePanel", self.Header );
    self.Header.Hostname.Text = GetHostName(); --utf8_upper( GetHostName() );
    self.Header.Hostname:Dock( FILL );
    self.Header.Hostname.Paint = function( this, w, h )
        this.rotAngle  = (this.rotAngle or 0) + 100 * RealFrameTime();
        local distsize = math_sqrt( w*w + h*h );

        surface_SetDrawColor( self.Colors[2] );
        surface_DrawRect( 0, 0, w, h );
        surface_SetMaterial( self.MaterialCache["gradient"] );
        surface_SetDrawColor( self.Colors[1] );
        surface_DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

        draw_SimpleText( this.Text, "rpui.Fonts.CharacterMenu.Hostname", w - h * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
    end

    self.Content = vgui_Create( "EditablePanel", self );
    self.Content:Dock( FILL );
    self.Content:InvalidateParent( true );

    local SCREEN_CHARACTERS, SCREEN_REGISTRATION;

    local Characters = vgui_Create( "EditablePanel" );
    Characters.Title = self.TranslateCache["ВОЙТИ КАК"];
    SCREEN_CHARACTERS = self:AddScreen( Characters );

    Characters.Container = vgui_Create( "EditablePanel", Characters );
    Characters.Container:Dock( FILL );
    Characters.Container:DockMargin( 0, 0, 0, self.innerPadding );
    Characters.Container:InvalidateParent( true );

    -- Characters: -------------------------------------------------
    Characters.RebuildCharacters = function()
        local Root, Parent = Characters, Characters.Container;

        if IsValid( Parent ) then
            Parent.SelectedBtn = nil;
            Parent:Clear();
        end

        local player_characters = rp.CharacterSystem.Characters or {};
        for i, cData in ipairs( player_characters ) do
            local isActiveCharacter = LocalPlayer().i_CharacterID == i;

            Characters[i] = vgui_Create( "EditablePanel", Parent );
            local CharacterBtn = Characters[i];
            CharacterBtn:Dock( LEFT );
            CharacterBtn:DockMargin( 0, 0, self.innerPadding, 0 );
            CharacterBtn:InvalidateParent( true );
            CharacterBtn.TrueWidth     = self.innerPadding * 8;
            CharacterBtn.SelectedWidth = CharacterBtn.TrueWidth * 1.25;
            CharacterBtn:SetWide( CharacterBtn.TrueWidth );
            CharacterBtn.DoClick = function( this )
                local selected = Parent.SelectedBtn;

                if selected ~= this then
                    Parent:Stop();

                    Parent:MoveTo(
                        Root:GetWide() * 0.5 - this:GetX() - this.TrueWidth * 0.5,
                        -1,
                        2, 0, 0.1
                    );

                    if Parent.SelectedBtn then
                        if IsValid( Parent.SelectedBtn.Title ) then
                            Parent.SelectedBtn.Title.Selected = false;
                        end

                        if IsValid( Parent.SelectedBtn.Select ) then
                            Parent.SelectedBtn.Select:AlphaTo( 0, 0.25 );
                            Parent.SelectedBtn.Select:SetMouseInputEnabled( false );
                        end

                        if IsValid( Parent.SelectedBtn.Delete ) then
                            Parent.SelectedBtn.Delete:AlphaTo( 0, 0.25 );
                            Parent.SelectedBtn.Delete:SetMouseInputEnabled( false );
                        end
                    end

                    self.SelectedCharacter = player_characters[i];
                    Parent.SelectedBtn = this;

                    if IsValid( Parent.SelectedBtn.Title ) then
                        Parent.SelectedBtn.Title.Selected = true;
                    end

                    if IsValid( Parent.SelectedBtn.Select ) then
                        Parent.SelectedBtn.Select:AlphaTo( 255, 0.25 );
                        Parent.SelectedBtn.Select:SetMouseInputEnabled( true );
                    end

                    if IsValid( Parent.SelectedBtn.Delete ) then
                        Parent.SelectedBtn.Delete:AlphaTo( 255, 0.25 );
                        Parent.SelectedBtn.Delete:SetMouseInputEnabled( true );
                    end
                end
            end

            CharacterBtn.Select = vgui_Create( "DButton", CharacterBtn );
            CharacterBtn.Select:SetText( isActiveCharacter and self.TranslateCache["ВЕРНУТЬСЯ"] or self.TranslateCache["ИГРАТЬ"] );
            CharacterBtn.Select:SetFont( "rpui.Fonts.CharacterMenu.Select" );
            CharacterBtn.Select:SetMouseInputEnabled( false );
            CharacterBtn.Select:Dock( BOTTOM );
            CharacterBtn.Select:SetTall( CharacterBtn:GetTall() * 0.085 );
            CharacterBtn.Select:SetAlpha( 0 );
            CharacterBtn.Select.DoClick = function( this )
                if CharacterBtn.IsDeleting then return end

                self:SetMouseInputEnabled( false );

                if isActiveCharacter then
                    self:Close();
                    return
                end

                this:SetText( self.TranslateCache["ЗАГРУЗКА..."] );

                rp.CharacterSystem.SelectCharacter( i );
            end
            CharacterBtn.Select.Paint = function( this, w, h )
                local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID_INVERTED );

                this.rotAngle  = (this.rotAngle or 0) + 100 * RealFrameTime();
                local distsize = math_sqrt( w*w + h*h );

                surface_SetDrawColor( self.Colors[2] );
                surface_DrawRect( 0, 0, w, h );
                surface_SetMaterial( self.MaterialCache["gradient"] );
                surface_SetDrawColor( self.Colors[1] );
                surface_DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

                draw_SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                return true
            end

            CharacterBtn.Title = vgui_Create( "DButton", CharacterBtn );
            CharacterBtn.Title:SetText( utf8_upper(cData.name) );
            CharacterBtn.Title:SetFont( "rpui.Fonts.CharacterMenu.Title" );
            CharacterBtn.Title:Dock( BOTTOM );
            CharacterBtn.Title:SetTall( CharacterBtn:GetTall() * 0.085 );
            CharacterBtn.Title.DoClick = function( this )
                this:GetParent():DoClick();
            end
            CharacterBtn.Title.IsHovered = function( this )
                local hover = vgui_GetHoveredPanel();
                return (hover == this) or (hover == CharacterBtn.Model);
            end
            CharacterBtn.Title.Paint = function( this, w, h )
                local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE_INVERTED );

                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );

                if not this.BakedText then
                    this.BakedText, this.BakedTextHeight = rpui_BakeText( this:GetText(), this:GetFont(), w - self.innerPadding, h );

                    this.BakedTextWidth = {};
                    for k, v in ipairs( this.BakedText ) do
                        this.BakedTextWidth[v.y] = v.x + v.w;
                    end
                end

                for k, v in ipairs( this.BakedText ) do
                    draw_SimpleText( v.text, this:GetFont(), w * 0.5 - this.BakedTextWidth[v.y] * 0.5 + v.x, h * 0.5 - this.BakedTextHeight * 0.5 + v.y, textColor );
                end

                return true
            end

            CharacterBtn.Model = vgui_Create( "DModelPanelRT", CharacterBtn );
            CharacterBtn.Model:Dock( FILL );
            CharacterBtn.Model:SetModel( cData.model or "models/player.mdl" );
            CharacterBtn.Model.DoClick = function( this )
                this:GetParent():DoClick();
            end
            CharacterBtn.Model.LayoutEntity = function( this, ent )
                this:SetFOV( 35 );

                -- Appearance:
                if cData.mdlscale then
                    ent:SetModelScale( cData.mdlscale );
                end

                if cData.skin then
                    ent:SetSkin( cData.skin );
                end

                if cData.bgroups then
                    for k, v in pairs( cData.bgroups ) do
                        ent:SetBodygroup( k, v );
                    end
                end

                local mins, maxs = ent:GetModelRenderBounds();
                local r = mins:Distance( maxs ) * 0.5;

                origin = LerpVector( 0.5, mins, maxs ) + ent:GetUp() * maxs[3] * 0.25;
                this:SetLookAt( origin );

                this.legacyCamPos = origin + ent:GetForward() * (r * 0.5) * (90/this:GetFOV());
                this:SetCamPos( this.legacyCamPos );

                this.legacyEyeTarget = ent:GetForward() * 1024 + ent:GetUp() * maxs[3];
                ent:SetEyeTarget( this.legacyEyeTarget );

                this.LayoutEntity = function( this, ent )
                    if Parent.SelectedBtn == CharacterBtn then
                        if not this.Posed then
                            ent:ResetSequence( ent:LookupSequence(
                                self.CharacterSequences[math_random(1, #self.CharacterSequences)]
                            ) );

                            this.Posed = true;
                        end

                        if not this.attPrecache then
                            this.attEyes = ent:LookupAttachment( "eyes" );
                            this.attEyes = (this.attEyes > 0) and this.attEyes or nil;
                            this.attPrecache = true;
                        end

                        if this.attEyes then
                            local mx, my = this:CursorPos();
                            mx, my = mx - this:GetWide() * 0.5, my - this:GetTall() * 0.25;

                            local mx_d = (mx + Root:GetWide() * 0.5) / Root:GetWide() - 0.5;
                            local my_d = (my + Root:GetTall() * 0.5) / Root:GetTall() - 0.5;

                            ent:SetPoseParameter( "head_yaw", mx_d * 75 );
                            ent:SetPoseParameter( "head_pitch", my_d * 60 );

                            local att = ent:GetAttachment( this.attEyes );
                            local EyePos = LocalToWorld( Vector(1024,0,0), Angle(0,0,0), att.Pos, att.Ang );
                            ent:SetEyeTarget( EyePos );
                        end
                    else
                        if this.Posed then
                            ent:ResetSequence( ent:LookupSequence("idle_all_01") );

                            ent:SetPoseParameter( "head_yaw", 0 );
                            ent:SetPoseParameter( "head_pitch", 0 );
                            ent:SetEyeTarget( this.legacyEyeTarget );

                            this.Posed = nil;
                        end
                    end
                end;
            end
            CharacterBtn.Model.BaseClassPaint = CharacterBtn.Model.Paint;
            CharacterBtn.Model.Paint = function( this, w, h )
                if not this.TeamName then
                    local team = cData.orgteam or cData.team;
                    local t = rp.teams[team] and rp.teams[team] or rp.teams[rp.GetDefaultTeam(LocalPlayer())];

                    this.TeamName = t.name;

                    local f = t.faction;
                    if f then
                        local faction = rp.Factions[f];

                        this.TeamFaction = rp.Factions[f].printName;

                        if faction.BubbleIcon then
                            this.TeamFactionIcon  = Material( faction.BubbleIcon, "smooth" );
                            this.TeamFactionColor = Color( 0, 0, 0, 64 );
                        end
                    end

                    if (not cData.model) and (this:GetModel() == "models/player.mdl") and t.model[1] then
                        this:SetModel( t.model[1] );
                    end
                end

                this._alpha = CharacterBtn.Select:GetAlpha() / 255;
                local surf_alpha;

                surf_alpha = surface_GetAlphaMultiplier();
                surface_SetAlphaMultiplier( surf_alpha * this._alpha );
                    surface_SetDrawColor( rpui.UIColors.Background );
                    surface_DrawRect( 0, 0, w, h );

                    if this.TeamFactionIcon then
                        surface_SetDrawColor( this.TeamFactionColor );
                        surface_SetMaterial( this.TeamFactionIcon );
                        surface_DrawTexturedRect( 0, h * 0.5 - w * 0.5, w, w );
                    end
                surface_SetAlphaMultiplier( surf_alpha );

                this:BaseClassPaint( w, h );

                surf_alpha = surface_GetAlphaMultiplier();
                surface_SetAlphaMultiplier( surf_alpha * this._alpha );
                    local y = h - self.innerPadding * 0.5;

                    if this.TeamFaction then
                        tw, th = draw_SimpleText( this.TeamFaction, "rpui.Fonts.CharacterMenu.Desc", w * 0.5, y, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                        y = y - th;
                    end

                    tw, th = draw_SimpleText( this.TeamName or t, "rpui.Fonts.CharacterMenu.DescBold", w * 0.5, y, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                    y = y - th;

                    if cData.org then
                        tw, th = draw_SimpleText( self.TranslateCache["Организация"] .. ": " .. cData.org, "rpui.Fonts.CharacterMenu.Desc", w * 0.5, y, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                        y = y - th - self.innerPadding * 0.25;
                    end

                    if cData.side and rp.Sides then
                        local s = rp.Sides[cData.side];
                        if s then
                            tw, th = draw_SimpleText( self.TranslateCache["Сторона"] .. ": " .. (s.printName or s.name or cData.side), "rpui.Fonts.CharacterMenu.Desc", w * 0.5, y, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
                            y = y - th - self.innerPadding * 0.25;
                        end
                    end
                surface_SetAlphaMultiplier( surf_alpha );

                if CharacterBtn.IsDeleting then
                    draw_Blur( this );
                end
            end
            CharacterBtn.Model.PaintOver = function( this, w, h )
                this.rotAngle  = (this.rotAngle or 0) + 100 * RealFrameTime();
                rpui_DrawStencilBorder( this, 0, 0, w, h, 0.006, self.Colors[1], self.Colors[2], this._alpha or 0 );
            end

            if not isActiveCharacter then
                CharacterBtn.Delete = vgui_Create( "DButton", CharacterBtn );
                CharacterBtn.Delete:SetMouseInputEnabled( false );
                CharacterBtn.Delete:SetAlpha( 0 );
                CharacterBtn.Delete:SetText( "x" );
                CharacterBtn.Delete:SetSize( CharacterBtn:GetWide() * 0.075, CharacterBtn:GetWide() * 0.075 );
                CharacterBtn.Delete:SetPos( CharacterBtn:GetWide() - CharacterBtn.Delete:GetWide() - self.innerPadding * 0.25, self.innerPadding * 0.25 );
                CharacterBtn.Delete.Paint = function( this, w, h )
                    local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID );
                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );

                    surface_SetDrawColor( textColor );
                    surface_SetMaterial( self.MaterialCache["trashbin"] );
                    surface_DrawTexturedRect( 0, 0, w, h );
                    return true
                end
                CharacterBtn.Delete.DoClick = function( this )
                    CharacterBtn.IsDeleting = true;

                    this:SetMouseInputEnabled( not CharacterBtn.IsDeleting );
                    this:AlphaTo( 0, 0.25 );

                    CharacterBtn.DeletePopup = vgui_Create( "EditablePanel", CharacterBtn.Model );
                    CharacterBtn.DeletePopup:DockPadding( self.innerPadding * 0.5, self.innerPadding * 0.5, self.innerPadding * 0.5, self.innerPadding * 0.5 );
                    CharacterBtn.DeletePopup:SetWide( CharacterBtn.Model:GetWide() - self.innerPadding * 0.5 );
                    CharacterBtn.DeletePopup.DoClick = function( me, callback )
                        me:AlphaTo( 0, 0.25, 0, function()
                            if not IsValid( me ) then return end

                            CharacterBtn.IsDeleting = nil;

                            if Parent.SelectedBtn == CharacterBtn then
                                this:SetMouseInputEnabled( not CharacterBtn.IsDeleting );
                                this:AlphaTo( 255, 0.25 );
                            end

                            if callback then callback(); end

                            me:Remove();
                        end );

                        for _, child in ipairs( me:GetChildren() ) do
                            child:AlphaTo( 0, 0.25 );
                        end
                    end
                    CharacterBtn.DeletePopup.Think = function( me )
                        if input_IsMouseDown( MOUSE_LEFT ) and (vgui_GetHoveredPanel() ~= me) and (vgui_GetHoveredPanel():GetParent() ~= me) then
                            me:DoClick();
                        end
                    end

                    CharacterBtn.DeletePopup.Text = vgui_Create( "DLabel", CharacterBtn.DeletePopup );
                    CharacterBtn.DeletePopup.Text:Dock( TOP );
                    CharacterBtn.DeletePopup.Text:SetFont( "rpui.Fonts.CharacterMenu.Title" );
                    CharacterBtn.DeletePopup.Text:SetText( self.TranslateCache["ВЫ ХОТИТЕ УДАЛИТЬ"] );
                    CharacterBtn.DeletePopup.Text:SetTextColor( rpui.UIColors.White );
                    CharacterBtn.DeletePopup.Text:SetContentAlignment( 5 );
                    CharacterBtn.DeletePopup.Text:SizeToContentsY();

                    CharacterBtn.DeletePopup.Name = vgui_Create( "DLabel", CharacterBtn.DeletePopup );
                    CharacterBtn.DeletePopup.Name:Dock( TOP );
                    CharacterBtn.DeletePopup.Name:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
                    CharacterBtn.DeletePopup.Name:SetFont( "rpui.Fonts.CharacterMenu.Title" );
                    CharacterBtn.DeletePopup.Name:SetText( string_format( "\"%s\"?", CharacterBtn.Title:GetText() ) );
                    CharacterBtn.DeletePopup.Name:SetTextColor( rpui.UIColors.White );
                    CharacterBtn.DeletePopup.Name:SetContentAlignment( 5 );
                    CharacterBtn.DeletePopup.Name:SizeToContentsY();

                    CharacterBtn.DeletePopup:InvalidateChildren( true );
                    CharacterBtn.DeletePopup:SizeToChildren( false, true );

                    CharacterBtn.DeletePopup:SetTall( CharacterBtn.DeletePopup:GetTall() + self.innerPadding * 1.25 );

                    local w = ( CharacterBtn.DeletePopup:GetWide() - self.innerPadding * 1.5 ) * 0.5;
                    CharacterBtn.DeletePopup.Yes = vgui_Create( "DButton", CharacterBtn.DeletePopup );
                    CharacterBtn.DeletePopup.Yes:Dock( LEFT );
                    CharacterBtn.DeletePopup.Yes:SetWide( w );
                    CharacterBtn.DeletePopup.Yes:SetFont( "rpui.Fonts.CharacterMenu.Select" );
                    CharacterBtn.DeletePopup.Yes:SetText( self.TranslateCache["Удалить"] );
                    CharacterBtn.DeletePopup.Yes.DoClick = function()
                        CharacterBtn.DeletePopup:DoClick( function()
                            rp.CharacterSystem.DeleteCharacter( i );
                            Root.RebuildCharacters();
                        end );
                    end
                    CharacterBtn.DeletePopup.Yes.Paint = function( me, w, h )
                        local baseColor, textColor = rpui_GetPaintStyle( me, STYLE_SOLID_INVERTED );

                        me.rotAngle  = (me.rotAngle or 0) + 100 * RealFrameTime();
                        local distsize = math_sqrt( w*w + h*h );

                        surface_SetDrawColor( self.Colors[2] );
                        surface_DrawRect( 0, 0, w, h );
                        surface_SetMaterial( rpui_GradientMat );
                        surface_SetDrawColor( self.Colors[1] );
                        surface_DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (me.rotAngle or 0) );

                        draw_SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                        return true
                    end

                    CharacterBtn.DeletePopup.No = vgui_Create( "DButton", CharacterBtn.DeletePopup );
                    CharacterBtn.DeletePopup.No:Dock( RIGHT );
                    CharacterBtn.DeletePopup.No:SetWide( w );
                    CharacterBtn.DeletePopup.No:SetFont( "rpui.Fonts.CharacterMenu.Select" );
                    CharacterBtn.DeletePopup.No:SetText( self.TranslateCache["Отмена"] );
                    CharacterBtn.DeletePopup.No.DoClick = function()
                        CharacterBtn.DeletePopup:DoClick();
                    end
                    CharacterBtn.DeletePopup.No.Paint = function( me, w, h )
                        local baseColor, textColor = rpui_GetPaintStyle( me, STYLE_SOLID );

                        surface_SetDrawColor( baseColor );
                        surface_DrawRect( 0, 0, w, h );

                        draw_SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                        return true
                    end

                    CharacterBtn.DeletePopup:Center();
                    CharacterBtn.DeletePopup:SetAlpha( 0 );
                    CharacterBtn.DeletePopup:AlphaTo( 255, 0.25 );

                    for _, child in ipairs( CharacterBtn.DeletePopup:GetChildren() ) do
                        child:SetAlpha( 0 );
                        child:AlphaTo( 255, 0.25 );
                    end
                end
            end
        end

        if #player_characters == 0 then
            if IsValid( self.Header.Close ) then self.Header.Close:Remove(); end
        end

        -- New Character: ----------------------------------------------
        if #player_characters < LocalPlayer():GetMaxCharacters() then
            Root.NewCharacter = vgui_Create( "EditablePanel", Parent );
            local CharacterBtn = Root.NewCharacter;
            CharacterBtn:Dock( LEFT );
            CharacterBtn:DockMargin( 0, 0, self.innerPadding, 0 );
            CharacterBtn:InvalidateParent( true );
            CharacterBtn:DockPadding( 0, 0, 0, CharacterBtn:GetTall() * 0.085 );
            CharacterBtn.TrueWidth     = self.innerPadding * 8;
            CharacterBtn.SelectedWidth = CharacterBtn.TrueWidth * 1.25;
            CharacterBtn:SetWide( CharacterBtn.TrueWidth );
            CharacterBtn.DoClick = function( this )
                local selected = Parent.SelectedBtn;

                if selected ~= this then
                    Parent:Stop();

                    Parent:MoveTo(
                        Root:GetWide() * 0.5 - this:GetX() - this.TrueWidth * 0.5,
                        -1,
                        2, 0, 0.1
                    );

                    if Parent.SelectedBtn then
                        if IsValid( Parent.SelectedBtn.Title ) then
                            Parent.SelectedBtn.Title.Selected = false;
                        end

                        if IsValid( Parent.SelectedBtn.Select ) then
                            Parent.SelectedBtn.Select:AlphaTo( 0, 0.25 );
                            Parent.SelectedBtn.Select:SetMouseInputEnabled( false );
                        end

                        if IsValid( Parent.SelectedBtn.Delete ) then
                            Parent.SelectedBtn.Delete:AlphaTo( 0, 0.25 );
                            Parent.SelectedBtn.Delete:SetMouseInputEnabled( false );
                        end
                    end

                    Parent.SelectedBtn = this;
                    Parent.SelectedBtn.Title.Selected = true;
                else
                    self:SelectScreen( SCREEN_REGISTRATION );
                end
            end

            CharacterBtn.Title = vgui_Create( "DButton", CharacterBtn );
            CharacterBtn.Title:SetText( self.TranslateCache["СОЗДАТЬ НОВОГО ПЕРСОНАЖА"] );
            CharacterBtn.Title:SetFont( "rpui.Fonts.CharacterMenu.Title" );
            CharacterBtn.Title:Dock( BOTTOM );
            CharacterBtn.Title:SetTall( CharacterBtn:GetTall() * 0.085 );
            CharacterBtn.Title.DoClick = function( this )
                this:GetParent():DoClick();
            end
            CharacterBtn.Title.IsHovered = function( this )
                local hover = vgui_GetHoveredPanel();
                return (hover == this) or (hover == CharacterBtn.Model) or (this.Selected);
            end
            CharacterBtn.Title.Paint = function( this, w, h )
                local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID );

                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );

                if not this.BakedText then
                    this.BakedText, this.BakedTextHeight = rpui_BakeText( this:GetText(), this:GetFont(), w - self.innerPadding, h );

                    this.BakedTextWidth = {};
                    for k, v in ipairs( this.BakedText ) do
                        this.BakedTextWidth[v.y] = v.x + v.w;
                    end
                end

                for k, v in ipairs( this.BakedText ) do
                    draw_SimpleText( v.text, this:GetFont(), w * 0.5 - this.BakedTextWidth[v.y] * 0.5 + v.x, h * 0.5 - this.BakedTextHeight * 0.5 + v.y, textColor );
                end

                return true
            end

            CharacterBtn.Model = vgui_Create( "DButton", CharacterBtn );
            CharacterBtn.Model:Dock( FILL );
            CharacterBtn.Model.Model = self.MaterialCache["outline"];
            CharacterBtn.Model.Scale = 0.85;
            CharacterBtn.Model.DoClick = function( this )
                this:GetParent():DoClick();
            end
            CharacterBtn.Model.Paint = function( this, w, h )
                if not this.ModelAspect then
                    this.ModelAspect = this.Model:Width() / this.Model:Height();
                    this.sw, this.sh = math_ceil( h * this.ModelAspect * this.Scale ), math_ceil( h * this.Scale );
                end

                local clr = Color( CharacterBtn.Title._grayscale, CharacterBtn.Title._grayscale, CharacterBtn.Title._grayscale );

                surface_SetDrawColor( clr );
                surface_SetMaterial( this.Model );
                surface_DrawTexturedRect( w * 0.5 - this.sw * 0.5, h - this.sh, this.sw, this.sh );

                return true
            end
        end

        Parent:InvalidateChildren( true );

        Parent:Dock( NODOCK );
        Parent:SizeToChildren( true, false );

        Parent:CenterHorizontal();

        self:SelectScreen( (#player_characters < 1) and SCREEN_REGISTRATION or SCREEN_CHARACTERS );
    end

    Characters.RebuildCharacters();

    hook_Add( "PlayerCharacterLoaded", Characters, function( pnl )
        pnl.RebuildCharacters();
    end );

    --
    local Registration = vgui_Create( "EditablePanel" );
    Registration.Title = self.TranslateCache["РЕГИСТРАЦИЯ"];
    Registration:DockPadding( self.innerPadding, 0, self.innerPadding, 0 );

    SCREEN_REGISTRATION = self:AddScreen( Registration );

    Registration.Sidebar = vgui_Create( "EditablePanel", Registration );
    Registration.Sidebar:Dock( LEFT );
    Registration.Sidebar:DockMargin( 0, 0, 0, self.innerPadding );
    Registration.Sidebar:SetSize( self.Header.ScreenTitle:GetWide() );

    Registration.Sidebar.Return = vgui_Create( "DButton", Registration.Sidebar );
    Registration.Sidebar.Return:SetFont( "rpui.Fonts.CharacterMenu.RegButton" );
    Registration.Sidebar.Return:SetText( self.TranslateCache["ВЕРНУТЬСЯ"] );
    Registration.Sidebar.Return:Dock( BOTTOM );
    Registration.Sidebar.Return:DockMargin( 0, self.innerPadding * 0.5, 0, 0 );
    Registration.Sidebar.Return:InvalidateParent( true );
    Registration.Sidebar.Return:SetTall( self.innerPadding );
    Registration.Sidebar.Return.DoClick = function( this )
        self:SelectScreen( SCREEN_CHARACTERS );
    end
    Registration.Sidebar.Return.Paint = function( this, w, h )
        local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID );

        surface_SetDrawColor( baseColor );
        surface_DrawRect( 0, 0, w, h );

        draw_SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        return true
    end

    Registration.Sidebar.Create = vgui_Create( "DButton", Registration.Sidebar );
    Registration.Sidebar.Create:SetFont( "rpui.Fonts.CharacterMenu.RegButton" );
    Registration.Sidebar.Create:SetText( self.TranslateCache["СОЗДАТЬ ПЕРСОНАЖА"] );
    Registration.Sidebar.Create:Dock( BOTTOM );
    Registration.Sidebar.Create:DockMargin( 0, self.innerPadding * 0.5, 0, 0 );
    Registration.Sidebar.Create:InvalidateParent( true );
    Registration.Sidebar.Create:SetTall( self.innerPadding );
    Registration.Sidebar.Create.DoClick = function( this )
        self:SetMouseInputEnabled( false );
        this:SetText( self.TranslateCache["ПОДОЖДИТЕ..."] );

        hook_Add( "PlayerCharacterRegistration", "rpui.CharacterMenu", function( status, err )
            hook_Remove( "PlayerCharacterRegistration", "rpui.CharacterMenu" );
            if not IsValid( self ) then return end

            if status then
                hook_Add( "PlayerCharacterLoaded", "rpui.CharacterMenu.Reload", function()
                    hook_Remove( "PlayerCharacterLoaded", "rpui.CharacterMenu.Reload" );
                    if not IsValid( self ) then return end

                    local player_characters = rp.CharacterSystem.Characters or {};
                    local count = #player_characters;

                    if count > 1 then
                        Registration.Sidebar.Content.ErrorMessage:SetText( "" );
                        Registration.Sidebar.Content.FirstName:SetValue( "" );
                        Registration.Sidebar.Content.LastName:SetValue( "" );

                        this:SetText( self.TranslateCache["СОЗДАТЬ ПЕРСОНАЖА"] );

                        Characters.RebuildCharacters();

                        self:SelectScreen( SCREEN_CHARACTERS );
                        self:SetMouseInputEnabled( true );
                    elseif count == 1 then
                        rp.CharacterSystem.SelectCharacter( 1 );
                    end
                end );

                return
            end

            self:SetMouseInputEnabled( true );
            Registration.Sidebar.Content.ErrorMessage:SetText( self.ErrorHandlers[err] or self.TranslateCache["Неизвестная ошибка, пожалуйста, повторите попытку"] );

            Registration.Sidebar.Content.FirstName.Errored = (err == CHARSYSTEM_REGISTER_ERROR_SHORTF);
            Registration.Sidebar.Content.LastName.Errored = (err == CHARSYSTEM_REGISTER_ERROR_SHORTL);

            if -- prostite :(
                err == CHARSYSTEM_REGISTER_ERROR_LONGN or
                err == CHARSYSTEM_REGISTER_ERROR_BAD or
                err == CHARSYSTEM_REGISTER_ERROR_EXISTS
            then
                Registration.Sidebar.Content.FirstName.Errored = true;
                Registration.Sidebar.Content.LastName.Errored = true;
            end

            this:SetText( self.TranslateCache["СОЗДАТЬ ПЕРСОНАЖА"] );
        end );

        rp.CharacterSystem.RegisterCharacter( {Registration.Sidebar.Content.FirstName:GetValue() or "", Registration.Sidebar.Content.LastName:GetValue() or ""}, {
            model    = Registration.Appearance.AppearanceModel,
            skin     = Registration.Appearance.AppearanceSkin,
            mdlscale = Registration.Appearance.AppearanceScale,
            bgroups  = Registration.Appearance.AppearanceBodygroups,
            appearid = Registration.Appearance.AppearanceID,
            side     = Registration.SelectedSide,
        } );
    end
    Registration.Sidebar.Create.Paint = function( this, w, h )
        local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID_INVERTED );

        this.rotAngle  = (this.rotAngle or 0) + 100 * RealFrameTime();
        local distsize = math_sqrt( w*w + h*h );

        surface_SetDrawColor( self.Colors[2] );
        surface_DrawRect( 0, 0, w, h );
        surface_SetMaterial( rpui_GradientMat );
        surface_SetDrawColor( self.Colors[1] );
        surface_DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

        draw_SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        return true
    end

    Registration.Sidebar.Content = vgui_Create( "EditablePanel", Registration.Sidebar );
    Registration.Sidebar.Content:Dock( FILL );
    Registration.Sidebar.Content:InvalidateParent( true );
    Registration.Sidebar.Content:DockPadding( self.innerPadding * 0.5, self.innerPadding * 0.5, self.innerPadding * 0.5, self.innerPadding * 0.5 );
    Registration.Sidebar.Content.Paint = function( this, w, h )
        surface_SetDrawColor( rpui.UIColors.Background );
        surface_DrawRect( 0, 0, w, h );
    end

    Registration.Sidebar.Content.Label_FirstName = vgui_Create( "DLabel", Registration.Sidebar.Content );
    Registration.Sidebar.Content.Label_FirstName:Dock( TOP );
    Registration.Sidebar.Content.Label_FirstName:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
    Registration.Sidebar.Content.Label_FirstName:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Sidebar.Content.Label_FirstName:SetText( translates_Get("ИМЯ ПЕРСОНАЖА") );
    Registration.Sidebar.Content.Label_FirstName:SetTextColor( rpui.UIColors.White );
    Registration.Sidebar.Content.Label_FirstName:SizeToContents( false, true );
    Registration.Sidebar.Content.Label_FirstName:SetZPos( 0 );

    surface_SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    local fontTall = select( 2, surface_GetTextSize(" ") );

    local FirstName_Container = vgui_Create( "EditablePanel", Registration.Sidebar.Content );
    FirstName_Container:Dock( TOP );
    FirstName_Container:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    FirstName_Container:SetTall( fontTall + self.innerPadding * 0.25 );
    FirstName_Container:SetZPos( 1 );

    Registration.Sidebar.Content.FirstNameRandom = vgui_Create( "DButton", FirstName_Container );
    Registration.Sidebar.Content.FirstNameRandom:Dock( RIGHT );
    Registration.Sidebar.Content.FirstNameRandom:SetWide( FirstName_Container:GetTall() );
    Registration.Sidebar.Content.FirstNameRandom:DockMargin( self.innerPadding * 0.25, 0, 0, 0 );
    Registration.Sidebar.Content.FirstNameRandom.DoClick = function( this )
        if not IsValid( Registration.Sidebar.Content.FirstName ) then return end

        if rp.CharacterSystem.LastRandomName then
            if rp.CharacterSystem.LastRandomName[1] then
                Registration.Sidebar.Content.FirstName:SetValue( rp.CharacterSystem.LastRandomName[1] );
                rp.CharacterSystem.LastRandomName[1] = nil;
                return
            end
        end

        rp.CharacterSystem.RequestRandomName();

        hook.Add( "PlayerCharacterRandomName", "UpdateFirstName", function( name )
            hook.Remove( "PlayerCharacterRandomName", "UpdateFirstName" );

            if not IsValid( self ) then return end
            if not IsValid( Registration.Sidebar.Content.FirstName ) then return end

            rp.CharacterSystem.LastRandomName = string.Explode( " ", name );

            if rp.CharacterSystem.LastRandomName then
                Registration.Sidebar.Content.FirstName:SetValue( rp.CharacterSystem.LastRandomName[1] );
                rp.CharacterSystem.LastRandomName[1] = nil;
            end
        end );
    end
    Registration.Sidebar.Content.FirstNameRandom.Paint = function( this, w, h )
        local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID );
        surface_SetDrawColor( baseColor );
        surface_DrawRect( 0, 0, w, h );
        surface_SetDrawColor( textColor );
        surface_SetMaterial( self.MaterialCache["random"] );
        surface_DrawTexturedRect( 0, 0, w, h );
        return true
    end

    Registration.Sidebar.Content.FirstName = vgui_Create( "DTextEntry", FirstName_Container );
    Registration.Sidebar.Content.FirstName:Dock( FILL );
    Registration.Sidebar.Content.FirstName:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Sidebar.Content.FirstName:SetPlaceholderText( translates_Get("Введите имя") );
    Registration.Sidebar.Content.FirstName:SetDrawLanguageID( false );
    Registration.Sidebar.Content.FirstName.Paint = function( this, w, h )
        surface_SetDrawColor( rpui.UIColors.White );
        surface_DrawRect( 0, 0, w, h );

        if (#this:GetValue() == 0) and (not this:HasFocus()) and this:GetPlaceholderText() then
            draw_SimpleText( this:GetPlaceholderText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Background, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        else
            this:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Black, rpui.UIColors.Black );
        end

        if this.Errored then
            local eh   = rpui_PowOfTwo( h * 0.65 );
            local y_eh = h * 0.5 - eh * 0.5;

            surface_SetDrawColor( rpui.UIColors.Pink );
            surface_DrawRect( w - eh - y_eh, y_eh, eh, eh );

            draw_SimpleText( "!", "rpui.Fonts.CharacterMenu.RegErrorIcon", w - h * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            surface_SetDrawColor( rpui.UIColors.Pink );
            surface_DrawOutlinedRect( 0, 0, w, h );

            if this:HasFocus() then
                this.Errored = nil;
            end
        end
    end

    Registration.Sidebar.Content.Label_LastName = vgui_Create( "DLabel", Registration.Sidebar.Content );
    Registration.Sidebar.Content.Label_LastName:Dock( TOP );
    Registration.Sidebar.Content.Label_LastName:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
    Registration.Sidebar.Content.Label_LastName:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Sidebar.Content.Label_LastName:SetText( translates_Get("ФАМИЛИЯ ПЕРСОНАЖА") );
    Registration.Sidebar.Content.Label_LastName:SetTextColor( rpui.UIColors.White );
    Registration.Sidebar.Content.Label_LastName:SizeToContents( false, true );
    Registration.Sidebar.Content.Label_LastName:SetZPos( 2 );

    local LastName_Container = vgui_Create( "EditablePanel", Registration.Sidebar.Content );
    LastName_Container:Dock( TOP );
    LastName_Container:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    LastName_Container:SetTall( fontTall + self.innerPadding * 0.25 );
    LastName_Container:SetZPos( 3 );

    Registration.Sidebar.Content.LastNameRandom = vgui_Create( "DButton", LastName_Container );
    Registration.Sidebar.Content.LastNameRandom:Dock( RIGHT );
    Registration.Sidebar.Content.LastNameRandom:SetWide( LastName_Container:GetTall() );
    Registration.Sidebar.Content.LastNameRandom:DockMargin( self.innerPadding * 0.25, 0, 0, 0 );
    Registration.Sidebar.Content.LastNameRandom.DoClick = function( this )
        if not IsValid( Registration.Sidebar.Content.LastName ) then return end

        if rp.CharacterSystem.LastRandomName then
            if rp.CharacterSystem.LastRandomName[2] then
                Registration.Sidebar.Content.LastName:SetValue( rp.CharacterSystem.LastRandomName[2] );
                rp.CharacterSystem.LastRandomName[2] = nil;
                return
            end
        end

        rp.CharacterSystem.RequestRandomName();

        hook.Add( "PlayerCharacterRandomName", "UpdateLastName", function( name )
            hook.Remove( "PlayerCharacterRandomName", "UpdateLastName" );

            if not IsValid( self ) then return end
            if not IsValid( Registration.Sidebar.Content.LastName ) then return end

            rp.CharacterSystem.LastRandomName = string.Explode( " ", name );

            if rp.CharacterSystem.LastRandomName then
                Registration.Sidebar.Content.LastName:SetValue( rp.CharacterSystem.LastRandomName[2] );
                rp.CharacterSystem.LastRandomName[2] = nil;
            end
        end );
    end
    Registration.Sidebar.Content.LastNameRandom.Paint = function( this, w, h )
        local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_SOLID );
        surface_SetDrawColor( baseColor );
        surface_DrawRect( 0, 0, w, h );
        surface_SetDrawColor( textColor );
        surface_SetMaterial( self.MaterialCache["random"] );
        surface_DrawTexturedRect( 0, 0, w, h );
        return true
    end

    Registration.Sidebar.Content.LastName = vgui_Create( "DTextEntry", LastName_Container );
    Registration.Sidebar.Content.LastName:Dock( FILL );
    Registration.Sidebar.Content.LastName:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Sidebar.Content.LastName:SetPlaceholderText( translates_Get("Введите фамилию") );
    Registration.Sidebar.Content.LastName:SetDrawLanguageID( false );
    Registration.Sidebar.Content.LastName.Paint = function( this, w, h )
        surface_SetDrawColor( rpui.UIColors.White );
        surface_DrawRect( 0, 0, w, h );

        if (#this:GetValue() == 0) and (not this:HasFocus()) and this:GetPlaceholderText() then
            draw_SimpleText( this:GetPlaceholderText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Background, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        else
            this:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Black, rpui.UIColors.Black );
        end

        if this.Errored then
            local eh   = rpui_PowOfTwo( h * 0.65 );
            local y_eh = h * 0.5 - eh * 0.5;

            surface_SetDrawColor( rpui.UIColors.Pink );
            surface_DrawRect( w - eh - y_eh, y_eh, eh, eh );

            draw_SimpleText( "!", "rpui.Fonts.CharacterMenu.RegErrorIcon", w - h * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            surface_SetDrawColor( rpui.UIColors.Pink );
            surface_DrawOutlinedRect( 0, 0, w, h );

            if this:HasFocus() then
                this.Errored = nil;
            end
        end
    end

    if rp.Sides and (#rp.Sides > 0) then
        Registration.Sidebar.Content.Label_Side = vgui_Create( "DLabel", Registration.Sidebar.Content );
        Registration.Sidebar.Content.Label_Side:Dock( TOP );
        Registration.Sidebar.Content.Label_Side:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
        Registration.Sidebar.Content.Label_Side:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
        Registration.Sidebar.Content.Label_Side:SetText( translates_Get("СТОРОНА: %s", "") );
        Registration.Sidebar.Content.Label_Side:SetTextColor( rpui.UIColors.White );
        Registration.Sidebar.Content.Label_Side:SizeToContents( false, true );
        Registration.Sidebar.Content.Label_Side:SetZPos( 4 );

        Registration.Sidebar.Content.Sides = vgui_Create( "rpui.RowView", Registration.Sidebar.Content );
        Registration.Sidebar.Content.Sides:Dock( TOP );
        Registration.Sidebar.Content.Sides:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
        Registration.Sidebar.Content.Sides:SetZPos( 5 );
        Registration.Sidebar.Content.Sides:InvalidateParent( true );
        Registration.Sidebar.Content.Sides:SetSpacingX( self.innerPadding * 0.25 );
        Registration.Sidebar.Content.Sides:SetSpacingY( self.innerPadding * 0.25 );

        Registration.Sidebar.Content.Sides.InsertRow = function( this )
            local RowPanel = vgui.Create( "Panel", this );
            RowPanel:Dock( TOP );
            RowPanel:DockMargin( 0, 0, 0, this:GetSpacingY() );
            RowPanel:InvalidateParent( true );

            RowPanel.RebuildLayout = function( me )
                local w, h = me:GetSize();
                local child_w, child_c = 0, 0, 0;

                for k, v in pairs( me:GetChildren() ) do
                    child_w = child_w + v:GetWide();
                    child_c = child_c + 1;
                end

                child_w = child_w + (child_c - 1) * this:GetSpacingX();

                local x = 0; --w * 0.5 - child_w * 0.5;
                local dx = x;

                for k, v in pairs( me:GetChildren() ) do
                    v:SetPos( x, h * 0.5 - v:GetTall() * 0.5 );
                    x = x + v:GetWide() + this:GetSpacingX();
                end

                return w * 0.5 - child_w * 0.5;
            end

            return table.insert( this.Rows, RowPanel );
        end

        local btnwidth = (Registration.Sidebar.Content.Sides:GetWide() - Registration.Sidebar.Content.Sides:GetSpacingX() * 3) * 0.25;
        local SideButtons = {};

        timer.Simple( 0, function()
            if not IsValid( self ) then return end

            for side_id, v in ipairs( rp.Sides ) do
                if v.customCheck and (v.customCheck(LocalPlayer()) == false) then continue end

                local SideButton = vgui.Create( "DButton" );
                SideButton:SetSize( btnwidth, btnwidth );
                SideButton:SetText( v.printName );
                self:RegisterTooltip( SideButton, v.desc or v.printName, nil );

                SideButton.DoClick = function( this )
                    if this.Selected then return end

                    for pnl in pairs( SideButtons ) do pnl.Selected = false; end
                    this.Selected = true;

                    Registration.SelectedSide = side_id;
                    Registration.Sidebar.Content.Label_Side:SetText( translates_Get("СТОРОНА: %s", utf8_upper(v.printName)) );

                    local t = rp.teams[v.team and v.team(LocalPlayer())] or rp.teams[rp.GetDefaultTeam(LocalPlayer())];
                    if t then
                        Registration.Appearance:Rebuild( t );
                        if Registration.Appearance.Random:IsVisible() then
                            Registration.Appearance.Random:DoClick();
                        end
                    end
                end

                SideButton.Paint = function( this, w, h )
                    local baseColor = rpui_GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE_INVERTED );

                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );

                    if (not this.Material) and v.icon then
                        this.Material = Material( v.icon, "smooth noclamp" );
                    end

                    if this.Material then
                        local s = rpui.PowOfTwo( h * 0.65 );
                        surface_SetMaterial( this.Material );
                        surface_SetDrawColor( v.color or rpui.UIColors.White );
                        surface_DrawTexturedRect( rpui.PowOfTwo(w * 0.5 - s * 0.5), rpui.PowOfTwo(h * 0.5 - s * 0.5), s, s );
                    end

                    return true
                end

                if not Registration.SelectedSide then
                    SideButton:DoClick();
                end

                Registration.Sidebar.Content.Sides:AddItem( SideButton );
                SideButtons[SideButton] = true;
            end

            for k, pnl in pairs( Registration.Sidebar.Content.Sides.CategoriesLabel ) do
                pnl:DockMargin( 0, 0, 0, 0 );
                pnl:SetTall( 0 );
            end

            Registration.Sidebar.Content.Sides:InvalidateLayout( true );
            Registration.Sidebar.Content.Sides:SizeToChildren( false, true );
        end );
    end

    Registration.Sidebar.Content.ErrorMessage = vgui_Create( "DLabel", Registration.Sidebar.Content );
    Registration.Sidebar.Content.ErrorMessage:Dock( TOP );
    Registration.Sidebar.Content.ErrorMessage:SetFont( "rpui.Fonts.CharacterMenu.RegError" );
    Registration.Sidebar.Content.ErrorMessage:SetText( "" );
    Registration.Sidebar.Content.ErrorMessage:SetTextColor( Color(255,32,32) );
    Registration.Sidebar.Content.ErrorMessage:SetWrap( true );
    Registration.Sidebar.Content.ErrorMessage:SetAutoStretchVertical( true );
    Registration.Sidebar.Content.ErrorMessage:SetZPos( 6 );

    Registration.Appearance = vgui_Create( "EditablePanel", Registration );
    Registration.Appearance:Dock( RIGHT );
    Registration.Appearance:DockMargin( 0, 0, 0, self.innerPadding );
    Registration.Appearance:SetWide( self.innerPadding * 8 );

    Registration.Appearance.GetTranslation = function( this, str )
        local dict = rp.cfg.Dictionary or {};

        local KeyTranslations = table_GetKeys( dict );
        local out             = str;

        for k, v in pairs( dict ) do
            local key = table_GetKeys( v )[1];

            if string_find( string_lower(str), string_lower(key) ) then
                out = v[key];
            end
        end

        return utf8_upper(out);
    end

    Registration.Appearance.RefreshVisuals = function( this )
        local mdlent = this.ModelViewer.Entity;

        function mdlent:GetPlayerColor()
            return LocalPlayer():GetPlayerColor()
        end

        mdlent:SetSkin( this.AppearanceSkin or 0 );
        mdlent:SetModelScale( this.AppearanceScale or 1 );

        for k, v in pairs( mdlent:GetBodyGroups() ) do
            mdlent:SetBodygroup( k, 0 );
        end

        for bgroup_id, bgroup in pairs( this.AppearanceBodygroups or {} ) do
            mdlent:SetBodygroup( bgroup_id, bgroup );
        end
    end

    Registration.Appearance.Rebuild = function( this, teamData )
        this.teamData     = teamData;
        this.AppearanceID = 0;

        this.AppearancePointers = {};
        this.AppearanceCustom   = {};
        this.AppearanceModels   = {};

        this.AppearanceModel      = "";
        this.AppearanceSkin       = 0;
        this.AppearanceScale      = 1;
        this.AppearanceBodygroups = {};

        local can_use = true;

        for _, uid in pairs( table_GetKeys(rp.shop.ModelsMap) ) do
            can_use = not (rp.shop.ModelsMap[uid][2][teamData.team] or rp.shop.ModelsMap[uid][3][teamData.faction or 0])

            if can_use and rp.shop.ModelsMap[uid][4] then
                can_use = rp.shop.ModelsMap[uid][4][teamData.team] and true or false
            end
            if can_use and rp.shop.ModelsMap[uid][5] then
                can_use = rp.shop.ModelsMap[uid][5][teamData.faction or 0] and true or false
            end

            if
                (not LocalPlayer():HasUpgrade(uid)) or
                (not can_use)
            then
                continue
            end

            for IIndex, MData in pairs( rp.shop.ModelsMap[uid][1] ) do
                local mdl = MData;
                table_insert( this.AppearanceModels, mdl );
                this.AppearancePointers[mdl] = 0;
                this.AppearanceCustom[mdl]   = uid;
            end
        end

        for _, mdl in ipairs( istable(teamData.model) and teamData.model or {teamData.model} ) do
            table_insert( this.AppearanceModels, mdl );
        end

        local mdlslist = {};
        for k, v in pairs( this.AppearanceModels ) do
            if mdlslist[v] then this.AppearanceModels[k] = nil end
            mdlslist[v] = true;
        end

        if teamData.appearance then
            for appearID, appearData in pairs( teamData.appearance ) do
                local mdls = istable(appearData.mdl) and appearData.mdl or {appearData.mdl};

                for _, mdl in pairs( mdls ) do
                    this.AppearancePointers[mdl] = appearID;
                end
            end
        end

        if #this.AppearanceModels > 1 then
            this.Model:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
            this.Model:SetTall( self.innerPadding );
            this.Model:SetValues( this.AppearanceModels );
        else
            this.Model:DockMargin( 0, 0, 0, 0 );
            this.Model:SetTall( 0 );
            this.Model:OnValueChanged( this.AppearanceModels[1] );
        end
    end

    Registration.Appearance.SelectAppearance = function( this, id )
        this.ModelViewer.Entity:SetModel( this.AppearanceModel );

        for _, child in ipairs( this:GetChildren() ) do
            if IsValid( child ) and !child.NoRemove then child:Remove(); end
        end

        if not id then
            return
        end

        this.AppearanceID = id;

        local appearance   = this.teamData.appearance[this.AppearanceID] or {};
        local isRandomable = false;

        local mdlScales = {};

        if appearance.scale ~= nil then
            if (appearance.scale == false) or isnumber(appearance.scale) then
                this.AppearanceScale = appearance.scale or 1;
            else
                if istable(appearance.scale) then
                    local smin = appearance.scale[1];
                    local smax = appearance.scale[2];
                    local step = (smax - smin) / 5;
                    for i = smin, smax, step do
                        table_insert( mdlScales, math_Round(i,2) );
                    end
                end
            end
        else
            local smin = rp.cfg.AppearanceScaleMin;
            local smax = rp.cfg.AppearanceScaleMax;
            local step = (smax - smin) / 5;
            for i = smin, smax, step do
                table_insert( mdlScales, math_Round(i,2) );
            end
        end

        if #mdlScales ~= 0 then
            local scaleSelector = vgui_Create( "rpui.ButtonWang", this );
            scaleSelector:Dock( TOP );
            scaleSelector:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
            scaleSelector:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
            scaleSelector:SetText( self.TranslateCache["РОСТ"] );
            scaleSelector:SetTall( self.innerPadding );
            scaleSelector.OnValueChanged = function( me, value )
                this.AppearanceScale = value or 1;
                this:RefreshVisuals();
            end

            this.AppearancePanelScale = scaleSelector;

            scaleSelector:SetValues( mdlScales );
            scaleSelector:SetPosition( math_ceil(#scaleSelector:GetValues() * 0.5) );
        else
            this.AppearanceScale = 1;
        end

        if appearance.skins then
            if #appearance.skins > 1 then
                local skinSelector = vgui_Create( "rpui.ButtonWang", this );
                skinSelector:Dock( TOP );
                skinSelector:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
                skinSelector:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
                skinSelector:SetText( self.TranslateCache["СКИН"] );
                skinSelector:SetTall( self.innerPadding );
                skinSelector.OnValueChanged = function( me, value )
                    this.AppearanceSkin = value or 0;
                    this:RefreshVisuals();
                end
                skinSelector:SetValues( appearance.skins );
                this.AppearancePanelSkin = skinSelector;
                isRandomable = true;
            else
                this.AppearanceSkin = appearance.skins[1] or 0;
            end
        else
            local appearance_skincount = this.ModelViewer.Entity:SkinCount();

            if appearance_skincount > 1 then
                local appearance_skins = {};

                for skin_id = 0, appearance_skincount - 1 do
                    table_insert( appearance_skins, skin_id );
                end

                local skinSelector = vgui_Create( "rpui.ButtonWang", this );
                skinSelector:Dock( TOP );
                skinSelector:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
                skinSelector:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
                skinSelector:SetText( self.TranslateCache["СКИН"] );
                skinSelector:SetTall( self.innerPadding );
                skinSelector.OnValueChanged = function( me, value )
                    this.AppearanceSkin = value or 0;
                    this:RefreshVisuals();
                end
                skinSelector:SetValues( appearance_skins );
                this.AppearancePanelSkin = skinSelector;
                isRandomable = true;
            else
                this.AppearanceSkin = 0;
            end
        end

        this.AppearancePanelBGroups = {};

        if appearance.bodygroups then
            for bgroup_id, bgroup_data in pairs( appearance.bodygroups ) do
                if isbool(bgroup_data) and bgroup_data then
                    local out = {};

                    for i = 1, this.ModelViewer.Entity:GetBodygroupCount( bgroup_id ) do
                        table_insert( out, i - 1 );
                    end

                    bgroup_data = out;
                end

                if #bgroup_data > 1 then
                    local bgroupSelector = vgui_Create( "rpui.ButtonWang", this );
                    bgroupSelector:Dock( TOP );
                    bgroupSelector:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
                    bgroupSelector:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
                    bgroupSelector:SetText( this:GetTranslation( this.ModelViewer.Entity:GetBodygroupName(bgroup_id) ) );
                    bgroupSelector:SetTall( self.innerPadding );
                    bgroupSelector.OnValueChanged = function( me, value )
                        this.AppearanceBodygroups[bgroup_id] = value or 0;
                        this:RefreshVisuals();
                    end
                    bgroupSelector:SetValues( bgroup_data );
                    this.AppearancePanelBGroups[bgroup_id] = bgroupSelector;
                    isRandomable = true;
                else
                    this.AppearanceBodygroups[bgroup_id] = bgroup_data[1] or 0;
                end
            end
        elseif (rp.cfg.JobShowAllBodygroups ~= false) or this.AppearanceCustom[this.AppearanceModel] then
            for bgroup_uid, bgroup in pairs( this.ModelViewer.Entity:GetBodyGroups() ) do
                local bgroup_id = bgroup.id;
                if bgroup_id == 1 then continue end

                local bgroup_data = table_GetKeys( bgroup.submodels );
                if #bgroup_data > 1 then
                    local bgroupSelector = vgui_Create( "rpui.ButtonWang", this );
                    bgroupSelector:Dock( TOP );
                    bgroupSelector:DockMargin( 0, 0, 0, self.innerPadding * 0.25 );
                    bgroupSelector:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
                    bgroupSelector:SetText( this:GetTranslation( this.ModelViewer.Entity:GetBodygroupName(bgroup_id) ) );
                    bgroupSelector:SetTall( self.innerPadding );
                    bgroupSelector.OnValueChanged = function( me, value )
                        this.AppearanceBodygroups[bgroup_id] = value or 0;
                        this:RefreshVisuals();
                    end
                    bgroupSelector:SetValues( bgroup_data );
                    this.AppearancePanelBGroups[bgroup_id] = bgroupSelector;
                    isRandomable = true;
                else
                    this.AppearanceBodygroups[bgroup_id] = bgroup_data[1] or 0;
                end
            end
        end

        for _, child in ipairs( this:GetChildren() ) do
            if not child.Prev then continue end

            child.Paint = function( me, w, h )
                surface_SetDrawColor( rpui.UIColors.Background );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
            child.Prev.Paint = function( me, w, h )
                local baseColor, textColor = rpui_GetPaintStyle( me, STYLE_BLANKSOLID );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
            child.Next.Paint = function( me, w, h )
                local baseColor, textColor = rpui_GetPaintStyle( me, STYLE_BLANKSOLID );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( me:GetText(), me:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
        end

        this.Random:SetVisible( (this.Model:GetTall() > 0) or isRandomable );
    end

    Registration.Appearance.Model = vgui_Create( "rpui.ButtonWang", Registration.Appearance );
    Registration.Appearance.Model:Dock( TOP );
    Registration.Appearance.Model:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    Registration.Appearance.Model:SetTall( self.innerPadding );
    Registration.Appearance.Model:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Appearance.Model:SetText( self.TranslateCache["МОДЕЛЬ"] );
    Registration.Appearance.Model.NoRemove = true;
    Registration.Appearance.Model.OnValueChanged = function( this, value )
        this = this:GetParent();
        this.AppearanceModel = value;
        this:SelectAppearance( this.AppearancePointers[value] );
        this:RefreshVisuals();
    end

    Registration.Appearance.Random = vgui_Create( "DButton", Registration.Appearance );
    Registration.Appearance.Random:Dock( TOP );
    Registration.Appearance.Random:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    Registration.Appearance.Random:SetZPos( 228 );
    Registration.Appearance.Random:SetFont( "rpui.Fonts.CharacterMenu.RegLabel" );
    Registration.Appearance.Random:SetText( self.TranslateCache["СЛУЧАЙНЫЙ ВЫБОР"] );
    Registration.Appearance.Random:SetTall( self.innerPadding );
    Registration.Appearance.Random.NoRemove = true;
    Registration.Appearance.Random.DoClick = function( this )
        for k, v in ipairs( this:GetParent():GetChildren() ) do
            if (v:GetName() == "rpui.ButtonWang") and (v:GetTall() > 0) then v:SelectRandom(); end
        end
    end
    Registration.Appearance.Random.Paint = function( this, w, h )
        surface_SetDrawColor( rpui.UIColors.Background );
        surface_DrawRect( 0, 0, w, h );

        local baseColor, textColor = rpui_GetPaintStyle( this, STYLE_BLANKSOLID );
        surface_SetDrawColor( baseColor );
        surface_DrawRect( 0, 0, w, h );
        draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        return true
    end

    Registration.Appearance.ModelViewer = vgui_Create( "DModelPanel", Registration );
    Registration.Appearance.ModelViewer:SetModel( LocalPlayer():GetModel() );
    Registration.Appearance.ModelViewer:Dock( FILL );
    Registration.Appearance.ModelViewer:SetFOV( 55 );
    Registration.Appearance.ModelViewer.xOffset = 0;
    Registration.Appearance.ModelViewer.xVelocity = 0;
    Registration.Appearance.ModelViewer.yVelocity = 0;
    Registration.Appearance.ModelViewer.ZoomingVector = Vector(1,0,0);
    Registration.Appearance.ModelViewer.LayoutEntity = function( this, ent )
        if (this.lastModel or "") ~= ent:GetModel() then
            ent:SetSequence( ent:LookupSequence("idle_all_01") );

            local mins, maxs = ent:GetModelRenderBounds();
            local r = mins:Distance( maxs ) * 1;

            origin = LerpVector( 0.5, mins, maxs ) + ent:GetUp() * maxs[3] * 0.2;
            this:SetLookAt( origin );

            this.legacyCamPos = origin + ent:GetForward() * (r * 0.5) * (90/this:GetFOV());
            this:SetCamPos( this.legacyCamPos );

            this.legacyEyeTarget = ent:GetForward() * 1024 + ent:GetUp() * maxs[3];
            ent:SetEyeTarget( this.legacyEyeTarget );
        end

        this.lastModel = ent:GetModel();
    end
    Registration.Appearance.ModelViewer.OnMousePressed = function( this, keycode )
        if keycode == MOUSE_LEFT then
            this._MousePosition = {input_GetCursorPos()};
            this.Pressed = true;
        end
    end
    Registration.Appearance.ModelViewer.Think = function( this )
        if not input_IsMouseDown( MOUSE_LEFT ) then
            this.Pressed = false;
        end

        this.xVelocity = 0.9 * this.xVelocity;
        this.yVelocity = 0.9 * this.yVelocity;

        if this.Pressed then
            local mp, _mp = {input_GetCursorPos()}, this._MousePosition;
            local dx, dy = mp[1] - _mp[1], mp[2] - _mp[2];

            this.yVelocity = this.yVelocity + (dx * 0.03);
        end

        this._MousePosition = {input_GetCursorPos()};

        this.Entity:SetAngles( this.Entity:GetAngles() + Angle( 0, this.yVelocity, 0 ) );
    end

    Registration.Appearance:Rebuild( rp.teams[rp.GetDefaultTeam(LocalPlayer())] );
    if Registration.Appearance.Random:IsVisible() then
        Registration.Appearance.Random:DoClick();
    end

    if self.TranslateCache["InfoLabel"] then
        local textarray = string.Explode( "\n", self.TranslateCache["InfoLabel"] );

        local p = self.innerPadding;
        local y = Registration:GetTall();

        for i = #textarray, 1, -1 do
            local text = textarray[i];

            local InfoLabel = vgui.Create( "DLabel", Registration );
            InfoLabel:SetMouseInputEnabled( false );
            InfoLabel:SetFont( "rpui.Fonts.CharacterMenu.Desc" );
            InfoLabel:SetTextColor( rpui.UIColors.White );
            InfoLabel:SetText( text );
            InfoLabel:SizeToContents();

            y = y - InfoLabel:GetTall();
            InfoLabel:SetPos( Registration:GetWide() - InfoLabel:GetWide() - p, y - p );
        end
    end

    --
    self:SelectScreen( SCREEN_CHARACTERS );
    self:MoveToFront();
end

vgui_Register( "rpui.CharacterSelector", PANEL, "EditablePanel" );