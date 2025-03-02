-- "gamemodes\\rp_base\\gamemode\\main\\interact_menu\\ping_system\\vgui\\circle_menu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "rp_base/gamemode/main/interact_menu/ping_system/config/config.lua" );


----------------------------------------------------------------
local framework = Nexus:ClassManager( "Framework" );

local _draw  = framework:Class( "Draw" );
local anim   = framework:Class( "Animations" );
local panels = framework:Class( "Panels" );

_NexusPanelsFramework = panels;
----------------------------------------------------------------


----------------------------------------------------------------
local PrecachedArcs = {};

local function PrecacheArc( cx, cy, radius, thickness, startang, endang, roughness )
    local uid = cx .. cy .. radius .. thickness .. startang .. endang .. roughness;

    local precachedArc = PrecachedArcs[uid];
    if precachedArc then
        return precachedArc
    end

    local triarc = {};

    local roughness = math.max( roughness or 1, 1 );
    local step = roughness;

    local startang, endang = startang or 0, endang or 0;
    local diffang = endang - startang;

    if startang > endang then
        step = math.abs( step ) * -1;
    end

    local inner = {};
    local r = radius - thickness;

    for deg = endang, startang, -step do
        local rad = math.rad( deg );
        local ox, oy = cx + (math.sin(rad) * r), cy - (math.cos(rad) * r)
        inner[#inner + 1] = {
            x = ox,
            y = oy,
            u = (endang - deg) / diffang,
            v = 0.975,
        };
    end

    local outer = {};
    for deg = endang, startang, -step do
        local rad = math.rad( deg );
        local ox, oy = cx + (math.sin(rad) * radius), cy - (math.cos(rad) * radius);
        outer[#outer + 1] = {
            x = ox,
            y = oy,
            u = (endang - deg) / diffang,
            v = 0.025,
        };
    end

    for tri = 1, #inner * 2 do
        local p1, p2, p3;
        local tr = math.floor( (tri+1) * 0.5 );

        p1 = outer[math.floor( tri * 0.5 ) + 1];
        p2 = (tri%2 == 0 and outer or inner)[tr];
        p3 = inner[tr + 1];

        triarc[#triarc + 1] = {p1, p2, p3};
    end

    PrecachedArcs[uid] = triarc;
    return triarc;
end

local function DrawArc( arc )
    for _, v in ipairs( arc ) do
        surface.DrawPoly( v );
    end
end

local function surface_DrawArc( cx, cy, radius, thickness, startang, endang, roughness )
    DrawArc( PrecacheArc( cx, cy, radius, thickness, startang, endang, roughness ) );
end
----------------------------------------------------------------


----------------------------------------------------------------
local leftClick, rightClick = Material( "rpui/interactmenu/lmb.png", "smooth" ), Material( "rpui/interactmenu/rmb.png", "smooth" );

local soundSelect = ""; -- "buttons/lightswitch2.wav";
local soundHover  = "garrysmod/ui_hover.wav";
local soundError  = "buttons/button10.wav";

local red    = Color( 223, 70, 24 );
local yellow = Color( 253, 177, 3 );
local green  = Color( 129, 163, 19 );

local errorMat = Material( "error", "smooth noclamp" );

local gradientDown = Material( "gui/gradient_down" );
local gradientCenter = Material( "gui/gradient_center" );
----------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------
local PANEL = {};


function PANEL:AddSection( name, mat, col, func, access, id )
    table.insert( self.SectionsTbl, {
        ["name"]   = name,
        ["mat"]    = mat,
        ["col"]    = col,
        ["func"]   = func,
        ["access"] = access,
        ["id"]     = id,
    } );
end


function PANEL:SetContents()
    for _, v in pairs( self.SectionsTbl ) do
        if ispanel( v ) then v:Remove(); end
    end

    self.SectionsTbl = {};
    self.SelectedArea = nil;

    local ply = self.SelectedPlayer;
    if ply then
		if ply:IsPlayer() then
			if PIS.Config.PlayerIteractButtons then
				for i, btn in ipairs( PIS.Config.PlayerIteractButtons ) do
					if btn.access and (not btn.access(LocalPlayer(), ply)) then continue end
					self:AddSection( btn.text, btn.material or errorMat, btn.color, btn.func, btn.access, i );
				end
			end
		else
			if PIS.Config.EntityIteractButtons and PIS.Config.EntityIteractButtons[ply:GetClass()] then
				for i, btn in ipairs(PIS.Config.EntityIteractButtons[ply:GetClass()]) do
					if btn.access and (not btn.access(LocalPlayer(), ply)) then continue end
                    self:AddSection( btn.text, btn.material or errorMat, btn.color, btn.func, btn.access, i );
				end
			end
        end
    elseif PIS.Config.WorldInteractButtons then
        for i, btn in ipairs(PIS.Config.WorldInteractButtons) do
            if btn.access and (not btn.access(LocalPlayer())) then continue end
            self:AddSection( btn.text, btn.material or errorMat, btn.color, btn.func, btn.access, i );
        end
    end

    self.Sections = #self.SectionsTbl;
    self.SectionSize = 360 / self.Sections;

	if self.Sections == 0 then
		PIS.BlockUseDelay = SysTime() + 0.25;
		self:Remove();
	end
end


function PANEL:SetCustomContents( contents )
    for _, v in pairs( self.SectionsTbl ) do
        if ispanel( v ) then v:Remove(); end
    end

    self.SectionsTbl = {};
    self.SelectedArea = nil;

    for i, btn in ipairs( contents ) do
        if btn.access and (not btn.access(LocalPlayer(), self.SelectedPlayer)) then continue end
        self:AddSection( btn.text, btn.material, btn.color, btn.func, btn.access, i );
    end

    self.Sections = #self.SectionsTbl;
    self.SectionSize = 360 / self.Sections;

	if self.Sections == 0 then
		PIS.BlockUseDelay = SysTime() + 0.25;
		self:Remove();
	end
end


function PANEL:Select( id )
    if self.FadingOut then return end

    local tbl = self.SectionsTbl[id + 1];

    if tbl then
        local ply = self.SelectedPlayer;

        if IsValid(ply) and ply:GetPos():Distance( LocalPlayer():GetPos() ) > PIS.Config.MaxInteractDistance then
            rp.Notify( NOTIFY_ERROR, translates.Get("Игрок слишком далеко!") );
            surface.PlaySound( soundError );
            self:Close();
            return
        end

        if tbl.access then
            if tbl.access( LocalPlayer(), ply ) then
                if tbl.func and (tbl.func(ply, self) == false) then
                    surface.PlaySound( soundSelect )
                    return
                end
            else
                surface.PlaySound( soundError );
                self:Close();
                return
            end
        else
            if tbl.func and (tbl.func(ply, self) == false) then
                surface.PlaySound( soundSelect );
                return
            end
        end
    end

    surface.PlaySound( soundSelect );
    self:Close();
end


function PANEL:RebuildFonts( w, h )
    surface.CreateFont( "rpui.Fonts.InteractMenu.Ping", {
        font     = "Montserrat",
        size     = math.Round( (h * 0.0425) * self.Settings.WheelScale ),
        weight   = 800,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.InteractMenu.Radial", {
        font     = "Montserrat",
        size     = math.Round( (h * 0.024) * self.Settings.WheelScale ),
        weight   = 600,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.InteractMenu.Name", {
        font     = "Montserrat",
        size     = math.Round( (h * 0.0275) * self.Settings.WheelScale ),
        weight   = 800,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.InteractMenu.Info", {
        font     = "Montserrat",
        size     = math.Round( (h * 0.024) * self.Settings.WheelScale ),
        extended = true,
    } );
end


function PANEL:Init()
    self.Settings = PIS:GetSettings( LocalPlayer() );

    self.Center = { X = ScrW() * 0.5, Y = ScrH() * 0.5 };

    self.Quality = 5;
    self.Radius = 325 * self.Settings.WheelScale;
    self.Thickness = self.Radius * 0.55;
    self.InnerThickness = self.Thickness * 0.1 * 0.5;

    self.AnimFadingLength = 0.25;
    self.RenderMatrix = Matrix();
    self.RotateMatrix = Matrix();

    self.SectionsTbl = {};

    self.SectionSize = 0;
    self.SelectedArea = 0;

    self.CircleColor = Color( 0, 0, 0, 0 );

    self:MakePopup();
    self:SetKeyboardInputEnabled( false );

    self:SetAlpha( 0 );
    self:AlphaTo( 255, self.AnimFadingLength );

    self.FadingIn   = true;
    self.FadingTime = SysTime() + self.AnimFadingLength;

    self:RebuildFonts( ScrW(), ScrH() );

    PIS.RadialMenu = self;

    local lastClick = 0;

    hook.Add( "rpui.InteractMenu.RightClick", self, function( self )
        if (not self.SelectedArea) and self.HasMovedSlightly then return end

        local CT = CurTime();
        if lastClick > CT then return end
        lastClick = CT + 0.2;

        self:Close();
    end );

    hook.Add( "rpui.InteractMenu.LeftClick", self, function( self )
        if not self.SelectedArea then return end

        local CT = CurTime();
        if lastClick > CT then return end
        lastClick = CT + 0.2;

        self:Select( self.SelectedArea, self.HasMovedSlightly );
    end );
end


function PANEL:Think()
    if LocalPlayer():GetEmoteAction() == 'dm_heal' then
        self:Remove();
    end

    if input.IsMouseDown( MOUSE_RIGHT ) or (self.KeyCode and (not input.IsKeyDown(self.KeyCode))) then
        PIS.BlockUseDelay = SysTime() + 0.25;
        self:Close();
        return
    end
end


function PANEL:Close()
    if self.FadingOut then return end

    self.FadingOut  = true;
    self.FadingTime = SysTime() + self.AnimFadingLength;

    self:AlphaTo( 0, self.AnimFadingLength, nil, function()
        if IsValid( self ) then self:Remove(); end
    end );
end


function PANEL:PerformLayout( w, h )
    local sectionSize = 360 / self.Sections;
    local rad = self.Thickness;

    for i, v in ipairs( self.SectionsTbl ) do
        if (not ispanel(v)) then continue end

        local ang  = math.rad( (i - 1) * sectionSize );
        local size = (self.Sections > 12) and (self.Radius * 2 / self.Sections) or (56 * self.Settings.WheelScale);

        if self.selectedArea and (self.selectedArea + 1 == i) then
            size = size * 1.285;
        end

        local r = self.Radius - rad * 0.5;

        local sin = math.sin( ang ) * r;
        local cos = math.cos( ang ) * r;

        local x = self.Center.X - size * 0.5 + sin;
        local y = self.Center.Y - size * 0.5 - cos;

        v:SetSize( size, size );
        v:SetPos( x, y );
    end
end


local vector_one = Vector( 1, 1, 1 );
local angle_rotate = Angle( 0, 1, 0 );
local math_min, math_max, math_atan2, math_abs, math_sqrt, math_Round, math_rad, math_deg, math_sin, math_cos = math.min, math.max, math.atan2, math.abs, math.sqrt, math.Round, math.rad, math.deg, math.sin, math.cos;
local surface_PlaySound, surface_GetDrawColor, surface_SetDrawColor, surface_GetAlphaMultiplier, surface_SetAlphaMultiplier, surface_GetTextSize, surface_SetMaterial, surface_SetFont, surface_DrawTexturedRect = surface.PlaySound, surface.GetDrawColor, surface.SetDrawColor, surface.GetAlphaMultiplier, surface.SetAlphaMultiplier, surface.GetTextSize, surface.SetMaterial, surface.SetFont, surface.DrawTexturedRect;
local cam_PushModelMatrix, cam_PopModelMatrix = cam.PushModelMatrix, cam.PopModelMatrix;
local draw_NoTexture, draw_SimpleTextOutlined = draw.NoTexture, draw.SimpleTextOutlined;
local ipairs, tobool, ispanel, isfunction, SysTime = ipairs, tobool, ispanel, isfunction, SysTime;
local render_SetStencilWriteMask, render_SetStencilTestMask, render_SetStencilReferenceValue, render_SetStencilPassOperation, render_SetStencilZFailOperation, render_ClearStencil, render_SetStencilEnable, render_SetStencilCompareFunction, render_SetStencilFailOperation = render.SetStencilWriteMask, render.SetStencilTestMask, render.SetStencilReferenceValue, render.SetStencilPassOperation, render.SetStencilZFailOperation, render.ClearStencil, render.SetStencilEnable, render.SetStencilCompareFunction, render.SetStencilFailOperation;
local gui_MouseX, gui_MouseY = gui.MouseX, gui.MouseY;

function PANEL:Paint( w, h )
    if not self.Sections then return end

    local settings = self.Settings;

    local x, y = self.Center.X, self.Center.Y;
    local s = 1;

    -- Fading Base:
    if self.FadingIn then
        local dt = 1 - (self.FadingTime - SysTime()) / self.AnimFadingLength;
        s = math_min( dt, 1 );

        if dt > 1 then
            self.FadingIn = false;
        end
    end

    if self.FadingOut then
        local dt = (self.FadingTime - SysTime()) / self.AnimFadingLength;
        s = math_max( dt, 0 );

        if dt > 1 then
            self.FadingOut = false;
        end
    end

    -- Cursor:
    self.CursorAng = 180 - math_deg(
        math_atan2( gui_MouseX() - x, gui_MouseY() - y )
    );

    -- Selected Area:
    local xDist, yDist = math_abs(x - gui_MouseX()), math_abs(y - gui_MouseY());
    local mDist = math_sqrt( xDist ^ 2 + yDist ^ 2 );
    local inrange = mDist > (self.Radius - self.Thickness);

    self:SetCursor( inrange and "hand" or "arrow" );

    local selectedArea = math_Round( self.CursorAng / self.SectionSize );
    selectedArea = (selectedArea >= self.Sections) and 0 or selectedArea;

    if inrange and (selectedArea ~= self.SelectedArea) then
        surface_PlaySound( soundHover );

        self.SelectedArea = selectedArea;
        self.SelectedTbl = self.SectionsTbl[self.SelectedArea + 1];

        self.FadingSelection     = true;
        self.FadingSelectionTime = SysTime() + self.AnimFadingLength;

        self.InfoOffset = nil;

        self:InvalidateLayout();
    end

    if not inrange and self.SelectedArea then
        self.FadingSelection     = true;
        self.FadingSelectionTime = SysTime() + self.AnimFadingLength;

        self.SelectedArea = nil;

        self:InvalidateLayout();
    end

    -- Fading Selection:
    local dt = 1;
    if self.FadingSelection then
        dt = math_min( math_Round( 1 - (self.FadingSelectionTime - SysTime()) / self.AnimFadingLength, 2 ), 1 );

        if dt > 1 then
            self.FadingSelection = false;
        end
    end

    -- Matrix Setup:
    self.RenderMatrix:SetTranslation( Vector( -x * s + x, -y * s + y ) );
    self.RenderMatrix:SetScale( vector_one * s );

    -- Render:
    cam_PushModelMatrix( self.RenderMatrix );

    draw_NoTexture();
    surface_SetDrawColor( rpui.UIColors.Shading );
    surface_DrawArc( x, y, self.Radius, self.Thickness, 0, 360, self.Quality );

    if tobool( settings.WheelBlur ) then
        local drawColor = surface_GetDrawColor();
        surface_SetDrawColor( color_white );

        render_SetStencilWriteMask( 0xFF );
        render_SetStencilTestMask( 0xFF );
        render_SetStencilReferenceValue( 0 );
        render_SetStencilPassOperation( STENCIL_KEEP );
        render_SetStencilZFailOperation( STENCIL_KEEP );
        render_ClearStencil();

        render_SetStencilEnable( true );
            render_SetStencilReferenceValue( 1 );
            render_SetStencilCompareFunction( STENCIL_NEVER );
            render_SetStencilFailOperation( STENCIL_REPLACE );
            -- Mask Render:
                draw_NoTexture();
                surface_DrawArc( x, y, self.Radius, self.Thickness, 0, 360, self.Quality );

            render_SetStencilReferenceValue( 1 );
            render_SetStencilCompareFunction( STENCIL_EQUAL );
            render_SetStencilFailOperation( STENCIL_KEEP );
            -- Main Render:
                surface_SetDrawColor( drawColor );
                cam_PopModelMatrix();
                _draw:Call( "Blur", self, 4, 4 );
                cam_PushModelMatrix( self.RenderMatrix );
            --
        render_SetStencilEnable( false );
    end

    surface_SetMaterial( gradientDown );
    surface_SetDrawColor( rpui.UIColors.Background );
    surface_DrawArc( x, y, self.Radius, self.Thickness, 0, 360, self.Quality );

    draw_NoTexture();
    surface_DrawArc( x, y, self.Radius, self.InnerThickness, 0, 360, self.Quality );

    -- Matrix maths?
    local surf_alpha = surface_GetAlphaMultiplier();
    surface_SetAlphaMultiplier( surf_alpha * dt );

    if self.SelectedArea then
        local ang = self.SelectedArea * self.SectionSize;
        local p = self.SectionSize * 0.5;

        surface_SetMaterial( gradientCenter );
        surface_DrawArc( x, y, self.Radius - self.Thickness - self.Thickness * 0.025, self.InnerThickness, -p + ang, p + ang, self.Quality );

        draw_NoTexture();
        surface_DrawArc( x, y, self.Radius, self.Thickness, -p + ang, p + ang, self.Quality );

        surface_SetDrawColor( rp.cfg.UIColor.BlockHeader or rpui.UIColors.BackgroundGold );
        surface_DrawArc( x, y, self.Radius, self.InnerThickness, -(p * dt) + ang, (p * dt) + ang, self.Quality );
    else
        surface_SetDrawColor( rpui.UIColors.Shading );
        surface_DrawArc( x, y, self.Radius - self.Thickness - self.Thickness * 0.025, self.InnerThickness, 0, 360, self.Quality );
    end

    surface_SetAlphaMultiplier( surf_alpha );

    -- Options:
    local size    = 76 * self.Settings.WheelScale;
    local padding = size * 0.1;

    if not self.SelectedArea then
        local _x = x;
        local _y = y + self.Radius + padding + size * 0.5;

        local text = translates.Get( "Взаимодействие с %s",
            (self.SelectedPlayer and (self.SelectedPlayer:IsPlayer() and self.SelectedPlayer:GetName() or self.SelectedPlayer.Name or self.SelectedPlayer.PrintName) or translates.Get("обьектом"))
        );

        local surf_alpha = surface_GetAlphaMultiplier();
        surface_SetAlphaMultiplier( surf_alpha * dt );

        draw_SimpleTextOutlined(
            text, "rpui.Fonts.InteractMenu.Name",
            _x, _y,
            rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
            2, rpui.UIColors.Background
        );

        surface_SetAlphaMultiplier( surf_alpha );
    end

    for i, v in ipairs( self.SectionsTbl ) do
        if ispanel(v) then continue end

        local ang  = math_rad( (i - 1) * self.SectionSize );
        local r   = self.Radius - self.Thickness * 0.5 - self.InnerThickness;
        local sin = math_sin( ang ) * r;
        local cos = math_cos( ang ) * r;

        local selected = false;
        if self.SelectedArea and (self.SelectedArea + 1 == i) then
            selected = true;
        end

        local _x = self.Center.X + sin;
        local _y = self.Center.Y - cos;

        local text = isfunction(v.name) and v.name(self.SelectedPlayer) or v.name;

        local mat = v.mat;
        if isfunction( mat ) then
            mat = mat( LocalPlayer(), self.SelectedPlayer );
        end

        if mat then
            local halfsize = size * 0.5;

            surface_SetMaterial( mat );
            surface_SetDrawColor( v.col or rpui.UIColors.White );
            surface_DrawTexturedRect( _x - halfsize, _y - halfsize, size, size );
        else
            draw_SimpleTextOutlined(
                text, "rpui.Fonts.InteractMenu.Radial",
                _x, _y,
                v.col or rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,
                2, rpui.UIColors.Background
            );
        end

        if selected then
            local surf_alpha = surface_GetAlphaMultiplier();
            surface_SetAlphaMultiplier( surf_alpha * dt );

            _x = x - (self.InfoOffset or 0);
            _y = y + self.Radius + padding;

            if mat then
                surface_SetMaterial( mat );
                surface_SetDrawColor( v.col or rpui.UIColors.White );
                surface_DrawTexturedRect( _x, _y, size, size );

                _x = _x + size + padding * 2;
            end

            draw_SimpleTextOutlined(
                text, "rpui.Fonts.InteractMenu.Name",
                _x, _y + size * 0.5,
                rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM,
                2, rpui.UIColors.Background
            );

            surface_SetFont( "rpui.Fonts.InteractMenu.Info" );
            local _, InfoHeight = surface_GetTextSize(" ");

            _y = _y + size * 0.5;

            surface_SetMaterial( leftClick );
            surface_SetDrawColor( rpui.UIColors.White );
            surface_DrawTexturedRect( _x, _y, InfoHeight, InfoHeight );

            _x = _x + InfoHeight + padding;

            local tw, th = draw_SimpleTextOutlined(
                translates.Get("Выбрать"), "rpui.Fonts.InteractMenu.Info",
                _x, _y + InfoHeight * 0.5,
                rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,
                2, rpui.UIColors.Background
            );

            _x = _x + tw + padding * 2;

            surface_SetMaterial( rightClick );
            surface_SetDrawColor( rpui.UIColors.White );
            surface_DrawTexturedRect( _x, _y, InfoHeight, InfoHeight );

            _x = _x + InfoHeight + padding;

            tw, th = draw_SimpleTextOutlined(
                translates.Get("Отменить"), "rpui.Fonts.InteractMenu.Info",
                _x, _y + InfoHeight * 0.5,
                rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER,
                2, rpui.UIColors.Background
            );

            if not self.InfoOffset then
                self.InfoOffset = ((_x + tw) - x) * 0.5;
            end

            surface_SetAlphaMultiplier( surf_alpha );
        end
    end

    cam_PopModelMatrix();
end


vgui.Register( "PIS.Radial", PANEL, "EditablePanel" );
--------------------------------------------------------------------------------------------------------------------------------


function PIS:OpenRadialMenu( keycode, target, custom_btns )
    local frame = panels:Call( "Create", "PIS.Radial" );

	net.Start('Radial::Open')
	net.SendToServer()

    frame:SetPos( 0, 0 );
    frame:SetSize( ScrW(), ScrH() );
    frame.SelectedPlayer = target;

    if custom_btns then
        frame:SetCustomContents( custom_btns );
    else
        frame:SetContents();
    end

    frame.KeyCode = keycode;
end


local function canOpenMenu()
    if IsValid( CHATBOX ) and CHATBOX._Open then
        return false
    end

    if IsValid( vgui.GetHoveredPanel() ) then
        return false
    end

    if rpSupervisor and (rpSupervisor.ID ~= 0) then
        return false
    end

    return true
end
canOpenInteractMenu = canOpenMenu;


hook.Add( "ItemShowEntityMenu", "InteractMenu:RPItems", function( ent )
    local self = LocalPlayer();
    local wep = self:GetActiveWeapon();

    if (not canOpenMenu()) or ((wep:GetClass() == "weapon_physgun") and input.IsMouseDown(MOUSE_LEFT)) then
        return
    end

    if not ent.getItemTable then
        rp.makeItem( ent );
    end

    local itemTable = ent:getItemTable();
    if not itemTable then return end

    local funcs = itemTable.functions;
    if not funcs then return end

    itemTable.player = self;
    itemTable.entity = ent;

    local customContents = {};

    for index, f in SortedPairs( funcs ) do
        if f.radial == false then continue end
        if (index == "combine") or (f.onCanRun and f.onCanRun(itemTable) == false) then continue end

        local AltTable;
        if f.onClientRun then
            AltTable        = table.Copy( itemTable );
            AltTable.player = self;
        end

        table.insert( customContents, {
            text     = f.name,
            material = Material( (f.InteractMaterial or "error"), "smooth noclamp" ),
            color    = f.InteractColor or rpui.UIColors.White,

            func = function()
                local send;

                if AltTable then
                    f.onClientRun( AltTable );
                end

                if f.sound then
                    if IsValid( ent ) and ent:GetPos():DistToSqr( self:GetPos() ) <= 9216 then
                        surface.PlaySound( f.sound );
                    end
                end

                if f.onClick then
                    send = f.onClick( itemTable );
                end

                if send ~= false then
					if IsValid( ent ) and (not ent.NoAnimatons) then
                        ent:ResetSequence( "close" );
                    end

                    self.usedEntity = ent;
                    netstream.Start( "invAct", index, ent );
                end
            end,

            access = function()
                return (not f.onCanRun) or f.onCanRun( itemTable ) ~= false;
            end
        } );
    end

    local access_count, acessed = 0;

    for k, v in ipairs( customContents ) do
        if v.access() then
            access_count = access_count + 1;
            acessed = v;
        end
    end

    if access_count < 1 then
        return
    elseif access_count < 2 then
        acessed.func();
        return
    end

    local frame = panels:Call( "Create", "PIS.Radial" );
    frame:SetPos( 0, 0 );
    frame:SetSize( ScrW(), ScrH() );
    frame.KeyCode = KEY_E;
    frame:SetCustomContents( customContents );
end );


hook.Add( "HUDPaint", "InteractMenu::Switcher", function()
    local self = LocalPlayer();

    if self:IsTyping() then
        return
    end

    local code   = KEY_E;
    local target = self:GetEyeTrace().Entity;
    local time   = SysTime();

    if input.IsKeyDown( code ) and canOpenMenu() then
        if (PIS.BlockUseDelay or 0) > time then return end

        if not IsValid( PIS.RadialMenu ) then
            if not IsValid( target ) then return end

            local isply = target:IsPlayer();

            if not isply then
                if target:IsWorld() then
                    if table.Count( PIS.Config.WorldInteractButtons ) < 1 then return end
                    PIS:OpenRadialMenu( code );
                else
                    local result = hook.Run( "IntractMenu", target );

					if not result and
                        (PIS.Config.EntityIteractButtons and PIS.Config.EntityIteractButtons[target:GetClass()]) and
                        target:GetPos():Distance( self:GetPos() ) < PIS.Config.MaxInteractDistance
                    then
						PIS:OpenRadialMenu( code, target );
					end
                end

                return
            end

            local wep = self:GetActiveWeapon();
            if IsValid( wep ) and (wep:GetClass() == "weapon_physgun") and input.IsMouseDown( MOUSE_LEFT ) then
                return
            end

            if isply and
                (target:GetPos():Distance(self:GetPos()) < PIS.Config.MaxInteractDistance) and
                (
                    not target:IsInDeathMechanics() -- and
                    --(not self:IsHandcuffed() and IsValid( self:GetWeapon("weapon_cuff_elastic") ))
                )
            then
                PIS:OpenRadialMenu( code, target );
            else
                PIS.BlockUseDelay = time + 0.25;
            end
        end
    end
end );


local mKeyCodes = {
    [MOUSE_LEFT] = "rpui.InteractMenu.LeftClick",
    [MOUSE_RIGHT] = "rpui.InteractMenu.RightClick",
};

hook.Add( "VGUIMousePressed", "InteractMenu::VGUIPressMouse", function( pnl, code )
    if IsValid( PIS.RadialMenu ) and (pnl == PIS.RadialMenu) then
        local mhook = mKeyCodes[code];
        if mhook then hook.Run( mhook ); end
    end
end );

hook.Add( "CreateMove", "InteractMenu::CMovePressMouse", function()
    if IsValid( PIS.RadialMenu ) then
        local leftClick  = input.WasMouseReleased( MOUSE_LEFT );
        if leftClick then
            hook.Run( "rpui.InteractMenu.LeftClick" );
        end

        local rightClick = input.WasMouseReleased( MOUSE_RIGHT );
        if rightClick then
            hook.Run( "rpui.InteractMenu.RightClick" );
        end
    end
end );

hook.Add( "DeathMechanics.CanUse", "InteractMenu::Handcuffs", function()
    local self = LocalPlayer();
    local b = (not self:IsHandcuffed()) and IsValid( self:GetWeapon("weapon_cuff_elastic") );

    local ply = self:GetEyeTrace().Entity;
    if IsValid( ply ) and ply:IsPlayer() and ply:IsHandcuffed() then
        return
    end

    return not b
end );

-- this is something:
timer.Simple( 0, function()
    hook.Remove( "HUDPaint", "InteractMenu_Switcher" );
    hook.Remove( "DeathMechanics.CanUse", "Interactmenu.Handcuffs" );
    hook.Remove( "Think", "InteractMenu_CheckTrace" );
    hook.Remove( "ItemShowEntityMenu", "RpItemsCircleMenu" );
    hook.Remove( "VGUIMousePressed", "PIS.PressMouse" );
    hook.Remove( "CreateMove", "PIS.CircleMenu" );
end );
