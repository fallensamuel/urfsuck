-- "gamemodes\\rp_base\\entities\\entities\\base_urf_radio\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local RealFrameTime, CurTime, Vector, Angle, Color, Material, Matrix, Lerp, LerpVector = RealFrameTime, CurTime, Vector, Angle, Color, Material, Matrix, Lerp, LerpVector;
local net_Start, net_WriteUInt, net_WriteEntity, net_WriteString, net_SendToServer, net_Receive, net_ReadUInt, net_ReadEntity = net.Start, net.WriteUInt, net.WriteEntity, net.WriteString, net.SendToServer, net.Receive, net.ReadUInt, net.ReadEntity;
local math_max, math_min, math_Round, math_cos, math_sin, math_floor, math_pow = math.max, math.min, math.Round, math.cos, math.sin, math.floor, math.pow;
local surface_CreateFont, surface_SetFont, surface_GetTextSize, surface_SetMaterial, surface_SetDrawColor, surface_DrawRect, surface_DrawTexturedRect = surface.CreateFont, surface.SetFont, surface.GetTextSize, surface.SetMaterial, surface.SetDrawColor, surface.DrawRect, surface.DrawTexturedRect;
local draw_RoundedBox, draw_SimpleTextOutlined = draw.RoundedBox, draw.SimpleTextOutlined;
local cam_Start3D2D, cam_End3D2D = cam.Start3D2D, cam.End3D2D;
local IsValid, pairs, LocalPlayer, EyePos, GetHUDPanel, ScrH = IsValid, pairs, LocalPlayer, EyePos, GetHUDPanel, ScrH;
local hook_Add, vgui_Create, string_FormattedTime, util_ScreenShake = hook.Add, vgui.Create, string.FormattedTime, util.ScreenShake;


----------------------------------------------------------------
include( "shared.lua" );
----------------------------------------------------------------


----------------------------------------------------------------
-- Networking:
----------------------------------------------------------------
ENT.Network.Handlers = {
    [ENT.Network.OPEN_MENU] = function( self )
        self:OpenMenu();
    end,

    [ENT.Network.SEND_TRACK] = function( self, data )
        if not data.id then return end

        net_Start( "urfim_radio" );
            net_WriteUInt( self.Network.SEND_TRACK, 2 );
            net_WriteEntity( self );
            net_WriteString( data.id );
            net_WriteUInt( data.duration, 16 );
        net_SendToServer();
    end
};

net_Receive( "urfim_radio", function()
    local t, e = net_ReadUInt(2), net_ReadEntity();

    if not IsValid( e ) then
        return
    end

    if LocalPlayer():GetPos():DistToSqr( e:GetPos() ) > 147456 then
        return
    end

    if e.Network and e.Network.Handlers[t] then
        e.Network.Handlers[t]( e );
    end
end );


----------------------------------------------------------------
-- Entity:
----------------------------------------------------------------
function ENT:OpenMenu()
    local Menu = vgui.Create( "rpui.VKPlayer" );
    Menu:SetSize( ScrH() * 0.5, ScrH() * 0.65 );
    Menu:Center();
    Menu:MakePopup();
    
    Menu:SetHandler( self );
end

function ENT:OnTrackID( id )
    local me = self;

    if IsValid( me.Station ) then
        me.Station:Stop();
    end

    me.IsDownloading = true;
    me.Failed = true;

    VKPlayer:Query( "?g=" .. id, function( track )
        me:SetTrackArtist( track.artist );
        me:SetTrackTitle( track.title );
        me:SetTrackLength( track.duration );

        VKPlayer:Play( track.id, function( station, sid )
            if not IsValid( me ) then return end
    
            if sid ~= me:GetTrackID() then 
                station:Stop();
                return
            end
    
            station:SetPos( me:GetPos() );
            station:Play();
            
            me.Station = station;
    
            me.IsDownloading = false;
            me.Failed = false;
        end );
    end );
end

function ENT:Initialize()
    self.FFT, self.RenderBoost, self.RenderMatrix = {}, 0, Matrix();

    local hsr = self.SoundRange * 0.5;
    self:SetRenderBounds( -Vector(hsr,hsr,hsr), Vector(hsr,hsr,hsr) );
end

function ENT:OnRemove()
    if IsValid( self.Station ) then
        self.Station:Stop();
    end
end

function ENT:Think()
    if self:GetTrackID() == "" then
        if IsValid( self.Station ) then
            self.Station:Stop();
        end

        if self.IsPlaying then
            self.IsPlaying = false;
        end

        return
    end

    if self:GetTrackStart() ~= (self.LastTrackStart or 0) then
        self.LastTrackStart = self:GetTrackStart();
        self.IsPlaying = false;
        self.Failed = false;

        if IsValid( self.Station ) then
            self.Station:Stop();
        end
    end

    if IsValid( self.Station ) then
        self.Station:SetPos( self:GetPos() );

        local rt = self.Station:GetTime();
        local t = CurTime() - self:GetTrackStart();

        if (t < 0) then
            self.Station:Stop();
            return
        end

        local dt_dist = LocalPlayer():GetPos():Distance(self:WorldSpaceCenter()) / self.SoundRange;
        local vol = 1 - (dt_dist < 0.3 and 0 or dt_dist);
        self.Station:SetVolume( (self.GigaMode and 3 or 1) * vol );

        if (t - rt) > 3 then
            self.Station:SetTime( t );
        end
    else
        if (not self.Failed) and (not self.IsPlaying) then
            self.IsPlaying = true;
            self:OnTrackID( self:GetTrackID() );
        end
    end
end


----------------------------------------------------------------
-- Rendering:
----------------------------------------------------------------
local vector_one = Vector(1,1,1);
local color_background_dark, color_background, color_segment = Color(0,0,0,225), Color(0,0,0,100), ENT.SegmentColor or color_white;
local mat_gradientup = Material( "gui/gradient_up" );

surface_CreateFont( "urfim_radio.Bold", {
    font = "Roboto",
    size = 85,
    weight = 1000,
    extended = true,
} );

surface_CreateFont( "urfim_radio.Default", {
    font = "Roboto",
    size = 65,
    weight = 0,
    extended = true,
} );

function ENT:DrawGiga()
    if not self.SpeakerMat then
        self.SpeakerMat = self:GetMaterials()[2];

        if self.SpeakerMat then
            self.SpeakerMat = Material( self.SpeakerMat );
        end
    end

    local IsValidMaterial = not self.SpeakerMat:IsError();
    local _prevTint;

    if IsValidMaterial then
        _prevTint = self.SpeakerMat:GetVector( "$selfillumtint" );
    end

    if self:GetTrackID() == "" then
        if IsValidMaterial then
            self.SpeakerMat:SetVector( "$selfillumtint", vector_origin );
        end

        self:DrawModel();

        goto restore_material
    end

    if IsValidMaterial then
        self.IllumColor = LerpVector( self.RenderBoost * 2, self.GigaLowColor, self.GigaHighColor );
        self.SpeakerMat:SetVector( "$selfillumtint", self.IllumColor );
    end

    self.RenderMatrix:SetScale( vector_one * (1 + self.RenderBoost) );
    self:EnableMatrix( "RenderMultiply", self.RenderMatrix );
    
    self:DrawModel();

    ::restore_material::

    if IsValidMaterial then
        self.SpeakerMat:SetVector( "$selfillumtint", _prevTint );
    end

    self.RenderBoost = Lerp( RealFrameTime() * 2, self.RenderBoost, 0 );
end

function ENT:Draw()
    self.IsDrawing = true;

    if not __urfim_radio_entities[self] then
        __urfim_radio_entities[self] = true;    
    end

    if self.GigaMode then
        self:DrawGiga();
        return
    end

    self:DrawModel();
end

function ENT:Draw3D2D()
    if not self.IsDrawing then return end
    self.IsDrawing = false;

    if EyePos():DistToSqr( self:WorldSpaceCenter() ) > 589824 then -- 768
        return
    end

    local origin = self:GetPos() + self:GetUp() * (self:GetModelRadius() * (1 + self.RenderBoost) * 0.5);
    origin = origin + vector_up * (self:GetModelRadius() * (1 + self.RenderBoost) * 0.65);
    
    local angles = Angle( 0, (EyePos() - origin):Angle().yaw, 0 );
    angles:RotateAroundAxis( angles:Up(), 90 );
    angles:RotateAroundAxis( angles:Forward(), 90 );

    local scale = 0.05 * (1 + self.RenderBoost);
    
    cam_Start3D2D( origin, angles, scale );
        if self.IsPlaying then
            local TrackLength = string_FormattedTime( math_max(0, self:GetTrackLength() - (CurTime() - self:GetTrackStart())), "%02i:%02i" );

            surface_SetFont( "urfim_radio.Bold" );
            local t_tw, t_th = surface_GetTextSize( self:GetTrackArtist() or "" );
            t_th = t_th * 0.75;

            surface_SetFont( "urfim_radio.Default" );
            local t_sw, t_sh = surface_GetTextSize( " " );
            local t_aw, t_ah = surface_GetTextSize( self:GetTrackTitle() or "" );
            local t_lw, t_lh = surface_GetTextSize( TrackLength );

            local w, h = math_max( math_max(t_tw + t_lw * 2, t_aw + t_lw * 2) * 0.5, t_sw * 38), t_th + t_ah + t_sw * 4;
            local x, y = -w, 0;

            local dt = math_max( 0, math_min(math_Round((CurTime() - self:GetTrackStart()) / self:GetTrackLength(), 2), 1) );        
            y = y - t_sh * 0.5;

            if self.IsDownloading then
                local cir_seg, cir_rad = (math.pi * 2) / 6, t_sw * 1.5;

                for i = 0, 5 do
                    draw_RoundedBox(
                        t_sw * 0.5,
                        x + (w * 2) + math_cos( cir_seg * i ) * cir_rad - t_sw * 0.5 - cir_rad * 2,
                        y - h + math_sin( cir_seg * i ) * cir_rad - t_sw * 0.5 + t_ah * 0.5,
                        t_sw, t_sw,
                        math_floor(CurTime() * 6) % 6 == i and color_white or color_background_dark
                    );
                end
            end

            surface_SetMaterial( mat_gradientup );
            surface_SetDrawColor( color_background );
            surface_DrawTexturedRect( -w, y - h, w * 2, h );

            if IsValid( self.Station ) then
                local ft = RealFrameTime();
                local fps = 30 / (1 / ft);
                local amp = 8;

                local fft = {};
                self.Station:FFT( fft, FFT_512 );

                local dist, canShake;

                if self.GigaMode then
                    dist = 1 - LocalPlayer():GetPos():Distance( self:GetPos() ) / (self.SoundRange * 0.5);
                    canShake = dist > 0;
                end

                local seg_w = (w * 2) / 32;

                for k = 1, 32 do
                    local v = fft[k] and fft[k] or 0;
                    local vis_v = (v * fps * amp);

                    self.FFT[k] = Lerp( ft * 6, (self.FFT[k] or 0) + vis_v, 0 );

                    if self.GigaMode and canShake and (v > 0.5) then
                        util_ScreenShake( self:GetPos(), (vis_v * 1.5) * dist, 5000, 0.5, 0 );
                        
                        if v > self.RenderBoost then
                            self.RenderBoost = Lerp( ft * 32, self.RenderBoost, v );
                        end
                    end

                    local seg_h = math_min(h, h * self.FFT[k] * 0.5);
                    color_segment.a = 255 * math_pow(seg_h / h, 4);

                    surface_SetDrawColor( color_segment );
                    surface_DrawTexturedRect( -w + seg_w * (k-1), math_Round(y - seg_h) + 2, seg_w - t_sw * 0.5, seg_h );
                end
            end

            surface_SetDrawColor( color_background_dark );
            surface_DrawRect( -w, y, w * 2, t_sh * 0.5 );

            surface_SetDrawColor( color_white );
            surface_DrawRect( -w, y, w * 2 * dt, t_sh * 0.5 );

            y = y - t_sw;
            draw_SimpleTextOutlined( self:GetTrackTitle() or "", "urfim_radio.Default", x + t_sw, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 4, color_black );
            
            x = w;
            draw_SimpleTextOutlined( TrackLength, "urfim_radio.Default", x - t_sw, y, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, color_black );
            
            x, y = -w, y - t_th;
            draw_SimpleTextOutlined( self:GetTrackArtist() or "", "urfim_radio.Bold", x + t_sw, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 4, color_black );
        else
            draw_SimpleTextOutlined( translates.Get("Включите во мне что-нибудь ;)"), "urfim_radio.Bold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 4, color_black );
        end
    cam_End3D2D();
end

__urfim_radio_entities = {};
hook_Add( "PostDrawTranslucentRenderables", "urfim_radio::Render3D2D", function()
    for self in pairs( __urfim_radio_entities ) do
        if not IsValid( self ) then
            __urfim_radio_entities[self] = nil;
            return
        end

        self:Draw3D2D();
    end
end );