-- "gamemodes\\darkrp\\gamemode\\addons\\stashing\\cl_stashing.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Stashing = rp.Stashing or {};

local function PrecacheArc( cx, cy, radius, thickness, startang, endang, roughness )
    local triarc = {};

    roughness = 360 / roughness;
    local step = roughness;

    startang, endang = startang or 0, endang or 0;
    startang, endang = math.min(startang, endang), math.max(startang, endang);

    if startang > endang then
        step = math.abs( step ) * -1;
    end

    local r = radius - thickness;

    local inner = {};
    for deg = startang, endang, step do
        local rad = math.rad( deg );
        local ox, oy = cx + (math.cos(rad) * r), cy + (-math.sin(rad) * r);
        table.insert( inner, {
            x = ox,
            y = oy,
            u = (ox-cx) / radius + 0.5,
            v = (oy-cy) / radius + 0.5
        } );
    end

    local outer = {};
    for deg = startang, endang, step do
        local rad = math.rad( deg );
        local ox, oy = cx + (math.cos(rad) * radius), cy + (-math.sin(rad) * radius);
        table.insert( outer, {
            x = ox,
            y = oy,
            u = (ox-cx) / radius + 0.5,
			v = (oy-cy) / radius + 0.5,
        } );
    end

    local p1, p2, p3;

    for tri = 1, #inner * 2 do
        local ctri = math.floor( tri * 0.5 );
        local ntri = math.floor( (tri + 1) * 0.5 );

        p1 = outer[ctri + 1];
        p2 = (tri % 2 == 0) and outer[ntri] or inner[ntri];
        p3 = inner[ntri + 1];

        table.insert( triarc, {p1, p2, p3} );
    end

    return triarc;
end

local function DrawArc( arc, color )
    for k, tri in pairs( arc ) do
        draw.NoTexture();
        surface.SetDrawColor( color and color or color_white );
        surface.DrawPoly( tri );
    end
end

local m_sqr_meters = math.pow( 1 / 39.37, 2 );
local mat_showel = Material( "materials/stashing/showel.png", "smooth noclamp" );
local mat_circle = Material( "materials/stashing/circle.png", "smooth noclamp" );
local angle_down = Angle( 90, 0, 0 );
local color_icon_visible = Color( 255, 255, 255 );
local color_icon_hidden = Color( 0, 0, 0, 200 );
local color_spot = Color( 255, 125, 0 );
local color_blank = Color( 0, 0, 0, 0 );
local vector_one = Vector( 1, 1, 1 );

-- Networking: -------------------------------------------------
net.Receive( "rp.Stashing", function()
    local handler = rp.Stashing.Handlers[net.ReadUInt(32)];

    if handler then
        handler( rp.Stashing );
    end
end );

rp.Stashing.ACT_SPOT      = 0;
rp.Stashing.ACT_CHALLENGE = 1;
rp.Stashing.ACT_CIRCLE    = 2;
rp.Stashing.ACT_UPDATE    = 3;

rp.Stashing.Handlers = {
    [rp.Stashing.ACT_SPOT] = function( self, ply )
        self:OnSpotReceived( net.ReadBool(), net.ReadVector() );
    end,

    [rp.Stashing.ACT_CHALLENGE] = function( self, ply )
        self:OnChallengeReceived( net.ReadBool() );
    end,

    [rp.Stashing.ACT_CIRCLE] = function( self, ply )
        local circle = {};
        local t = SysTime();

        circle.x = net.ReadFloat();
        circle.y = net.ReadFloat();

        local ts, te = net.ReadFloat(), net.ReadFloat();
        circle.l = (te - ts);

        circle.ts = t;
        circle.te = t + circle.l;

        self:OnCircleReceived( circle );
    end,

    [rp.Stashing.ACT_UPDATE] = function( self, ply )
        self:OnUpdateReceived( net.ReadFloat() );
    end
};

function rp.Stashing:OnSpotReceived( status, vec )
    self:SetupSpotVisuals( status, vec );
end

function rp.Stashing:OnChallengeReceived( status )
    self:SetupChallenge( status );
end

function rp.Stashing:OnCircleReceived( circle )
    local ch = self:GetChallenge();
    if not ch then return end

    ch.circles[#ch.circles + 1] = circle;
end

function rp.Stashing:OnUpdateReceived( progress )
    local ch = self:GetChallenge();
    if not ch then return end

    ch.progress = progress;
end

-- Requests: ---------------------------------------------------
function rp.Stashing:RequestSpot()
    net.Start( "rp.Stashing" );
        net.WriteUInt( self.ACT_SPOT, 32 );
    net.SendToServer();
end

function rp.Stashing:RequestChallenge( status )
    net.Start( "rp.Stashing" );
        net.WriteUInt( self.ACT_CHALLENGE, 32 );
        net.WriteBool( tobool( status ) );
    net.SendToServer();
end

function rp.Stashing:RequestCircle( x, y )
    net.Start( "rp.Stashing" );
        net.WriteUInt( self.ACT_CIRCLE, 32 );
        net.WriteFloat( tonumber( x ) );
        net.WriteFloat( tonumber( y ) );
    net.SendToServer();
end

-- Methods: ----------------------------------------------------
function rp.Stashing:GetChallenge()
    return self.Challenge;
end

function rp.Stashing:SetupChallenge( status )
    if not status then
        self.Challenge = nil;
        self:SetupChallengeVisuals( false );

        return
    end

    self.Challenge = {
        progress = 0,
        circles = {},
    };

    self:SetupChallengeVisuals( true );
end

function rp.Stashing:SetupChallengeVisuals( status )
    if not status then
        if IsValid( self.VGUI ) then self.VGUI:Close( true ); end
        return false;
    end

    if IsValid( self.VGUI ) then self.VGUI:Remove(); end

    local scr_w, scr_h = ScrW(), ScrH();
    local padding = scr_h * 0.1;

    surface.CreateFont( "rpui.fonts.Stashing-Large", {
        font = "Montserrat",
        size = padding * 0.45,
        weight = 1000,
        extended = true,
    } );

    surface.CreateFont( "rpui.fonts.Stashing-Small", {
        font = "Montserrat",
        size = padding * 0.2,
        weight = 500,
        extended = true,
    } );

    surface.CreateFont( "rpui.fonts.Stashing-Default", {
        font = "Montserrat",
        size = padding * 0.25,
        weight = 500,
        extended = true,
    } );

    self.VGUI = vgui.Create( "Panel" );
    self.VGUI:SetSize( scr_w, scr_h );
    self.VGUI:DockPadding( padding * 4, padding, padding * 4, padding );
    self.VGUI:Center();
    self.VGUI:MakePopup();
    -- self.VGUI:SetDrawOnTop( true );
    self.VGUI:SetAlpha( 0 );
    self.VGUI:AlphaTo( 255, 0.25 );

    self.VGUI.Paint = function( this, w, h )
        draw.Blur( this );

        surface.SetDrawColor( rpui.UIColors.Shading );
        surface.DrawRect( 0, 0, w, h );
    end

    self.VGUI.Close = function( this, forced )
        if this.b_Closing then return end
        this.b_Closing = true;

        if not forced then
            self:RequestChallenge( false );
        end

        this:AlphaTo( 0, 0.25, 0, function( anim, pnl )
            pnl:Remove();
        end );
    end

    self.VGUI.Footer = vgui.Create( "Panel", self.VGUI );
    self.VGUI.Footer:Dock( BOTTOM );
    self.VGUI.Footer:DockMargin( padding * 2, padding, padding * 2, 0 );
    self.VGUI.Footer.PerformLayout = function( this, w, h )
        this:SizeToChildren( false, true );
    end

    self.VGUI.Footer.Progress = vgui.Create( "Panel", self.VGUI.Footer );
    self.VGUI.Footer.Progress:Dock( TOP );
    self.VGUI.Footer.Progress:DockMargin( 0, 0, 0, padding * 0.25 );
    self.VGUI.Footer.Progress:SetTall( padding * 0.15 );
    self.VGUI.Footer.Progress.Value = 0;
    self.VGUI.Footer.Progress.Paint = function( this, w, h )
        local ch = self:GetChallenge();

        if ch and ch.progress then
            this.NextValue = ch.progress;
        end

        this.Value = Lerp( RealFrameTime() * 8, this.Value, this.NextValue or 0 );

        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( rpui.UIColors.White );
        surface.DrawRect( 0, 0, w * this.Value, h );
    end

    self.VGUI.Footer.Title = vgui.Create( "DLabel", self.VGUI.Footer );
    self.VGUI.Footer.Title:Dock( TOP );
    self.VGUI.Footer.Title:SetFont( "rpui.fonts.Stashing-Large" );
    self.VGUI.Footer.Title:SetText( "Ты прячешь секретные документы..." );
    self.VGUI.Footer.Title:SetTextColor( rpui.UIColors.White );
    self.VGUI.Footer.Title:SetContentAlignment( 5 );
    self.VGUI.Footer.Title:SizeToContentsY();

    self.VGUI.Footer.Desc = vgui.Create( "DLabel", self.VGUI.Footer );
    self.VGUI.Footer.Desc:Dock( TOP );
    self.VGUI.Footer.Desc:DockMargin( 0, 0, 0, padding * 0.25 );
    self.VGUI.Footer.Desc:SetFont( "rpui.fonts.Stashing-Small" );
    self.VGUI.Footer.Desc:SetText( "Нажимай на кружочки чтобы ускориться!" );
    self.VGUI.Footer.Desc:SetTextColor( rpui.UIColors.White );
    self.VGUI.Footer.Desc:SetContentAlignment( 5 );
    self.VGUI.Footer.Desc:SizeToContentsY();

    self.VGUI.Footer.Controls = vgui.Create( "Panel", self.VGUI.Footer );
    self.VGUI.Footer.Controls:Dock( TOP );
    self.VGUI.Footer.Controls.PerformLayout = function( this, w, h )
        this:SizeToChildren( false, true );
    end

    local ctrls = vgui.Create( "Panel", self.VGUI.Footer.Controls );

    ctrls.PerformLayout = function( this, w, h )
        this:SizeToChildren( true, true );
        this:Center();
    end

    ctrls.AddControl = function( this, mat, text )
        local icon = this:Add( "Panel" );
        icon.m_Material = Material( mat, "smooth noclamp" );
        icon.Paint = function( this, w, h )
            if not this.m_Material then return end

            surface.SetMaterial( this.m_Material );
            surface.SetDrawColor( color_white );
            surface.DrawTexturedRect( 0, 0, w, h );
        end

        icon.PerformLayout = function( this, w, h )
            icon:SetWide( h );
        end

        local label = this:Add( "DLabel" );
        label:SetFont( "rpui.fonts.Stashing-Default" );
        label:SetText( text );
        label:SetTextColor( rpui.UIColors.White );
        label:SizeToContents();

        this:InvalidateLayout( true );

        icon:Dock( LEFT );
        icon:DockMargin( 0, 0, padding * 0.25 * 0.5, 0 );

        label:Dock( LEFT );
        label:DockMargin( 0, 0, padding * 0.25, 0 );
    end

    ctrls:AddControl( "rpui/interactmenu/lmb.png", "Ускориться" );
    ctrls:AddControl( "rpui/interactmenu/rmb.png", "Отменить" );

    ctrls:InvalidateLayout( true );

    self.VGUI.Content = vgui.Create( "Panel", self.VGUI );
    self.VGUI.Content:Dock( FILL );
    self.VGUI.Content:InvalidateLayout( true );

    self.VGUI.Content.MouseHandlers = {
        [MOUSE_LEFT] = function( self, pnl )
            if not pnl.b_CircleSelected then return end

            local ch = self:GetChallenge();
            if not ch then return end

            if not ch.circles then return end

            ch.circles[pnl.b_CircleSelected] = nil;
            self:RequestCircle( self.VGUI.mx, self.VGUI.my );

            surface.PlaySound( self.Config.Circles.Sound );
        end,

        [MOUSE_RIGHT] = function( self, pnl )
            self:RequestChallenge( false );
        end
    };

    self.VGUI.Content.OnMousePressed = function( this, key )
        local handler = this.MouseHandlers[key];
        if handler then
            handler( self, this );
        end
    end

    self.VGUI.Content.Paint = function( this, w, h )
        local vmin = math.min( w, h );
        local scale = vmin * self.Config.Circles.Radius;
        local overscale = self.Config.Circles.Overscale;
        local mult_overscale = 1 / overscale;

        if not this.m_Transform then
            this.m_Transform = Matrix();
        end

        if not this.p_OuterPoly then
            this.p_OuterPoly = PrecacheArc( 0, 0, scale * overscale, scale * (0.1 * overscale), 0, 360, 24 );
        end

        local mx, my = this:ScreenToLocal( input.GetCursorPos() );
        self.VGUI.mx = math.Remap( mx, scale, w - scale, 0, 1 );
        self.VGUI.my = math.Remap( my, scale, h - scale, 0, 1 );

        local vw, vh = w - scale * 2, h - scale * 2;
        local vx, vy = w * 0.5 - vw * 0.5, h * 0.5 - vh * 0.5;

        local ch = self:GetChallenge();
        if ch then
            local t = SysTime();

            -- preprocessor:
            local cir_k, cir_dist = -1, math.huge;
            local vec_m, vec_c = Vector(vx + self.VGUI.mx * vw, vy + self.VGUI.my * vh), Vector(0, 0);

            for k, circle in pairs( ch.circles ) do
                if t > circle.te then
                    ch.circles[k] = nil;
                    continue
                end

                circle.selected = false;
                vec_c.x, vec_c.y = vx + circle.x * vw, vy + circle.y * vh;

                local dist = vec_c:DistToSqr( vec_m );
                if dist > cir_dist then
                    continue
                end

                cir_k, cir_dist = k, dist;
            end

            if ch.circles[cir_k] and cir_dist <= math.pow(scale, 2) then
                ch.circles[cir_k].selected = true;
                this.b_CircleSelected = cir_k;
            else
                this.b_CircleSelected = nil;
            end

            -- renderer:
            for k, circle in pairs( ch.circles ) do
                local cir_x, cir_y = vx + circle.x * vw, vy + circle.y * vh;

                local vector_cir = Vector( cir_x, cir_y );
                local vector_cir_screen = Vector( this:LocalToScreen(cir_x, cir_y) );

                local dt = 1 - (t - circle.ts) / circle.l;
                dt = math.ease.InCubic( dt );

                local color_cir = circle.selected and (dt > 0.025 and rpui.UIColors.White or color_spot) or rpui.UIColors.Hovered;

                local mult_scale = mult_overscale + (1 - mult_overscale) * dt;
                local clip = DisableClipping( true );
                    surface.SetDrawColor( rpui.UIColors.White );
                    surface.SetMaterial( mat_showel );
                    surface.DrawTexturedRect( cir_x - scale * 0.5, cir_y - scale * 0.5, scale, scale );

                    local oscale = (scale * 2) + (scale * overscale * dt);

                    surface.SetDrawColor( color_cir );
                    surface.SetMaterial( mat_circle );
                    surface.DrawTexturedRect( cir_x - oscale * 0.5, cir_y - oscale * 0.5, oscale, oscale );

                    --[[
                    this.m_Transform:SetScale( vector_one * mult_scale );
                    this.m_Transform:SetTranslation( vector_cir * mult_scale + vector_cir_screen * (1 - mult_scale) );
                    cam.PushModelMatrix( this.m_Transform );
                        DrawArc( this.p_OuterPoly, color_cir );
                    cam.PopModelMatrix();
                    ]]--
                DisableClipping( clip );
            end
        end
    end

    self.VGUI:InvalidateLayout( true );
end

function rp.Stashing:SetupSpotVisuals( status, vec )
    if self.Spot then
        if IsValid( self.Spot.model ) then
            self.Spot.model:Remove();
            self.Spot.model = nil;
        end

        if IsValid( self.Spot.projected_tex ) then
            self.Spot.projected_tex:Remove();
            self.Spot.projected_tex = nil;
        end
    end

    if not status then
        self.Spot = nil;
        return
    end

    if not self.Spot then
        self.Spot = {};
    end

    self.Spot.true_origin = vec;

    local tr_ground = util.TraceLine( {
        start = vec + vector_up * 8,
        endpos = vec - vector_up * 300,
        collisiongroup = COLLISION_GROUP_DEBRIS,
    } );

    self.Spot.ground = tr_ground.Hit and tr_ground.HitPos or vec;
    self.Spot.eye = self.Spot.ground + vector_up * 54;

    if not IsValid( self.Spot.model ) then
        self.Spot.model = ClientsideModel( "models/effects/vol_light128x128.mdl" );
        self.Spot.model:SetAngles( -angle_down * 2 );
        self.Spot.model:SetModelScale( self.Config.Spots.Radius / 64, 0 );
        self.Spot.model:SetColor( color_blank );
    end

    self.Spot.model:SetPos( self.Spot.ground - vector_up * (self.Config.Spots.Radius * 0.25) );

    if not IsValid( self.Spot.projected_tex ) then
        local r = self.Config.Spots.Radius * 1.2;

        self.Spot.projected_tex = ProjectedTexture();
        self.Spot.projected_tex:SetOrthographic( true, r, r, r, r );
        self.Spot.projected_tex:SetAngles( angle_down );
        self.Spot.projected_tex:SetLinearAttenuation( math.huge );
        self.Spot.projected_tex:SetNearZ( 0.001 );
        self.Spot.projected_tex:SetFarZ( self.Config.Spots.Radius * 2 );
        self.Spot.projected_tex:SetTexture( "effects/flashlight001" );
        self.Spot.projected_tex:SetColor( color_blank );
        self.Spot.projected_tex:SetEnableShadows( false );
    end

    self.Spot.projected_tex:SetPos( self.Spot.eye );
    self.Spot.projected_tex:Update();

    surface.CreateFont( "rpui.fonts.Stashing-HUD", {
        font = "Montserrat",
        size = ScrH() * 0.025,
        weight = 600,
        extended = true,
    } );

    hook.Add( "HUDPaint", "rp.Stashing::HUD", function( ent )
        if not self.Spot then
            hook.Remove( "HUDPaint", "rp.Stashing::HUD" );
            return
        end

        local w, h = ScrW(), ScrH();
        local icon_size = h * 0.05;

        local min_w, max_w = icon_size, w - icon_size;

        local screen = self.Spot.eye:ToScreen();

        if (screen.x < min_w) or (screen.x > max_w) then
            screen.x, screen.y = math.Clamp( screen.x, min_w, max_w ), h * 0.5;
            screen.visible = false;
        end

        local dist = EyePos():DistToSqr( self.Spot.eye );
        local alpha = math.min( 1, dist / math.pow(self.Config.Spots.Radius * 4, 2) );

        local surf_alpha = surface.GetAlphaMultiplier();
        surface.SetAlphaMultiplier( surf_alpha * alpha );
            surface.SetDrawColor( screen.visible and rpui.UIColors.White or rpui.UIColors.Background );
            surface.SetMaterial( mat_showel );
            surface.DrawTexturedRect( screen.x - icon_size * 0.5, screen.y - icon_size * 0.5, icon_size, icon_size );

            if screen.visible then
                local dist_m = math.Round( math.sqrt(dist * m_sqr_meters) );
                draw.SimpleTextOutlined( dist_m .. " м.", "rpui.fonts.Stashing-HUD", screen.x, screen.y + icon_size * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, rpui.UIColors.Shading );
            end
        surface.SetAlphaMultiplier( surf_alpha );

        if screen.visible then
            local blink = math.sin( SysTime() );

            local blink_projtex = 0.45 + 0.275 + blink * 0.275;
            local blink_spot = 0.25 + 0.375 + blink * 0.375;

            if IsValid( self.Spot.projected_tex ) then
                self.Spot.projected_tex:SetColor( Color(color_spot.r * blink_projtex, color_spot.g * blink_projtex, color_spot.b * blink_projtex) );
                self.Spot.projected_tex:Update();
            end

            if IsValid( self.Spot.model ) then
                self.Spot.model:SetColor( Color(color_spot.r * blink_spot, color_spot.g * blink_spot, color_spot.b * blink_spot) );
            end
        end

        hook.Run( "HUDStashing", self.Spot.eye, screen, dist, alpha );
    end );
end