-- "gamemodes\\rp_base\\entities\\entities\\base_urf_itemroulette\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Material, Color, Matrix, Vector, Angle, Sound = Material, Color, Matrix, Vector, Angle, Sound;
local table_insert = table.insert;
local math_rad, math_sin, math_cos, math_pow, math_max, math_min, math_Round, math_Approach = math.rad, math.sin, math.cos, math.pow, math.max, math.min, math.Round, math.Approach;
local include, IsValid, pairs, isfunction, CurTime, LocalPlayer, utf8_upper, ModelIcons_Get, EmitSound = include, IsValid, pairs, isfunction, CurTime, LocalPlayer, utf8.upper, ModelIcons.Get, EmitSound;
local net_Receive, net_ReadEntity, net_ReadUInt = net.Receive, net.ReadEntity, net.ReadUInt;
local hook_Add, hook_Remove = hook.Add, hook.Remove;
local cam_Start3D2D, cam_End3D2D, cam_PushModelMatrix, cam_PopModelMatrix, cam_IgnoreZ = cam.Start3D2D, cam.End3D2D, cam.PushModelMatrix, cam.PopModelMatrix, cam.IgnoreZ;
local render_SetStencilEnable, render_ClearStencil, render_SetStencilWriteMask, render_SetStencilTestMask, render_SetStencilPassOperation, render_SetStencilZFailOperation, render_SetStencilReferenceValue, render_SetStencilCompareFunction, render_SetStencilFailOperation = render.SetStencilEnable, render.ClearStencil, render.SetStencilWriteMask, render.SetStencilTestMask, render.SetStencilPassOperation, render.SetStencilZFailOperation, render.SetStencilReferenceValue, render.SetStencilCompareFunction, render.SetStencilFailOperation;
local surface_GetAlphaMultiplier, surface_SetAlphaMultiplier, surface_CreateFont, surface_SetDrawColor, surface_SetMaterial, surface_DrawRect, surface_DrawTexturedRect, surface_DrawPoly = surface.GetAlphaMultiplier, surface.SetAlphaMultiplier, surface.CreateFont, surface.SetDrawColor, surface.SetMaterial, surface.DrawRect, surface.DrawTexturedRect, surface.DrawPoly;
local draw_NoTexture, draw_SimpleText = draw.NoTexture, draw.SimpleText;
local util_TraceLine = util.TraceLine;

include( "shared.lua" );

ENT.UI = {
    Sounds = {
        Click = Sound("buttons/lightswitch2.wav"),
    },

    Materials = {
        GradientUp    = Material( "vgui/gradient-d" ),
        GradeintLeft  = Material( "vgui/gradient-l" ),
        GradeintRight = Material( "vgui/gradient-r" ),
        Error         = Material( "bubble_hints/refresh.png", "smooth" ),
    },

    Colors = {
        Background       = Color(20,20,20,240),
        White            = Color(255,255,255),
        TransparentWhite = Color(255,255,255,100),
        Black            = Color(0,0,0),
        Orange           = Color(255,125,0),
        SideGradient     = Color(0,0,0,100),
        Error            = Color(255,0,0),
    },

    RarityColors = {
        [-1] = Color(50,50,50),
         [0] = Color(150,160,170),
         [1] = Color(110,255,0),
         [2] = Color(0,110,255),
         [3] = Color(110,0,255),
         [4] = Color(255,200,45)
    },

    GenerateRoundedRect = function( x, y, w, h, r, q )
        local p = {};
    
        table_insert( p, { x = x, y = y } );
        table_insert( p, { x = x+w, y = y } );
    
        for i = 0, q do
            local a = math_rad( 90 - (i/q) * 90 );
    
            local out = {
                x = x + w - r + math_sin(a) * r,
                y = y + h - r + math_cos(a) * r
            }
    
            table_insert( p, out );
        end
    
        for i = 0, q do
            local a = math_rad( (i/q) * -90 );
    
            local out = {
                x = x + r + math_sin(a) * r,
                y = y + h - r + math_cos(a) * r
            }
    
            table_insert( p, out );
        end
    
        for k, v in pairs( p ) do
            local x_, y_ = v.x - x, v.y - y;
            v.u = x_ / w; v.v = y_ / h + 0.0025;
        end

        return p;
    end
};


net_Receive( "ent.RouletteBox:Use", function()
    local self = net_ReadEntity();
    if not IsValid(self) then return end

    local act = net_ReadEntity();

    if act == Entity(0) then
        if self.Initialized3D2D then
            if not self.Animation.FadeOut.Active then
                self.Animation.FadeOut.Active = true;
                self.Animation.FadeOut.Start = CurTime();
            end
        end

        return
    end

    if act == LocalPlayer() then
        self.LastUse = CurTime();
    end

    self:SetActivator( act );

    self:Use();
end );


function ENT:Set3D2DScaling( f )
    self.ScalingFactor3D2D = f;
end


function ENT:DistanceCheck( ply )
    return ply:GetPos():DistToSqr( self:GetPos() ) <= 589824; -- 768 units
end


function ENT:SetActivator( ply )
    if not IsValid(ply) then return end
    if not ply:IsPlayer() then return end

    self.Activator = ply;
end

function ENT:GetActivator()
    return self.Activator;
end


function ENT:Initialize()
    self.UI.Width = 2048;
    self.UI.Height = 768;

    self.UI.Matrixes = {            
        _Offset       = Matrix(),
        ElementOffset = Matrix(),
    };

    self.UI.Frames = {};

    if self.PostInitialize then self:PostInitialize(); end
end


function ENT:Use()
    if self.Setup then self:Setup(); end
    
    local item_id = net_ReadUInt( 5 );
    
    self:InitializeRoulette( item_id );
    self:Initialize3D2D();
end


function ENT:SetPrintName( name )
    self.DisplayName = utf8_upper(name);
end

function ENT:GetPrintName()
    return self.DisplayName or "??";
end

function ENT:InitializeRoulette( w_item_id )
    self.RouletteItems = {};

    for _, item in pairs( self:GetItemPool() ) do
        if item.mdl then
            ModelIcons_Get( item.mdl, Angle(35,220,0), 1, function( m ) item.icon = m; end );
        end
    end

    for i = 0, 31 do
        self.RouletteItems[i] = (i == 26) and self:GetItemPool()[w_item_id] or self:GetWeightedRandom( self.Activator );
    end
end


function ENT:Initialize3D2D()
    self.Scaling3D2D = 0.04 * (self.ScalingFactor3D2D or 1);

    self.Animation = {
        Start     = CurTime(),
        RouletteV = 0,

        ScrollFunc = function( t )
            t = t - 1;
            local out = -1 * (math_pow(t,4) - 1);
            return math_Round( out, 4 );
        end,

        FadeIn = {
            Active   = true,
            Start    = CurTime(),
            Duration = 0.5,
        },

        FadeOut = {
            Active   = false,
            Delay    = 5,
            Duration = 0.5,
        },

        ItemsFadeOut = {
            Active   = false,
            Duration = (#self.ItemPool > 1) and 1 or 0,
        },

        FoundShrink = {
            Active   = false,
            Amount   = 0.45,
            Duration = 0.5,
        },

        AlphaMod = 0,
    };

    local w, h = self.UI.Width, self.UI.Height;

    self.UI.BottomArrow = {};
    self.UI.BottomArrow.Height = math_Round( h * 0.15 );
    self.UI.BottomArrow.Poly = {
        { x = w * 0.5 - self.UI.BottomArrow.Height * 1.75, y = h - self.UI.BottomArrow.Height },
        { x = w * 0.5 + self.UI.BottomArrow.Height * 1.75, y = h - self.UI.BottomArrow.Height },
        { x = w * 0.5, y = h },
    };

    self.UI.SelectorArrow = {};
    self.UI.SelectorArrow.Height = self.UI.BottomArrow.Height;
    self.UI.SelectorArrow.OuterPoly = {
        { x = w * 0.5 - self.UI.BottomArrow.Height, y = h - self.UI.SelectorArrow.Height},
        { x = w * 0.5,                              y = h - self.UI.SelectorArrow.Height - self.UI.SelectorArrow.Height },
        { x = w * 0.5 + self.UI.BottomArrow.Height, y = h - self.UI.SelectorArrow.Height},
    };

    self.UI.SelectorArrow.InnerPoly = {
        { x = self.UI.SelectorArrow.OuterPoly[1].x + math_Round(h * 0.025), y = self.UI.SelectorArrow.OuterPoly[1].y - math_Round(h * 0.01) },
        { x = self.UI.SelectorArrow.OuterPoly[2].x,                         y = self.UI.SelectorArrow.OuterPoly[2].y + math_Round(h * 0.01) },
        { x = self.UI.SelectorArrow.OuterPoly[3].x - math_Round(h * 0.025), y = self.UI.SelectorArrow.OuterPoly[3].y - math_Round(h * 0.01) },
    };

    self.UI.Matrixes._Offset:SetTranslation( Vector( -w * 0.5, - h - h * 0.1, 0 ) );

    self.Initialized3D2D = true;

    local h = self:EntIndex() .. "ent.RouletteBox::Render3D2D";
    hook_Add( "PostDrawTranslucentRenderables", h, function()
        if not IsValid( self ) or not self.Initialized3D2D then
            hook_Remove( "PostDrawTranslucentRenderables", h );
            return
        end

        if not self:DistanceCheck( LocalPlayer() ) then return end

        self.Origin3D2D = self:GetPos() + self:GetUp() * self:OBBMaxs()[3];

        self.Angles3D2D = Angle( 0, (EyePos() - self:GetPos()):Angle().yaw, 0 );
            self.Angles3D2D:RotateAroundAxis( self.Angles3D2D:Up(), 90 );
            self.Angles3D2D:RotateAroundAxis( self.Angles3D2D:Forward(), 90 );

        cam_Start3D2D( self.Origin3D2D, self.Angles3D2D, self.Scaling3D2D );
            cam_IgnoreZ( true );
            cam_PushModelMatrix( self.UI.Matrixes._Offset, true );
                local surfaceAlphaMult = surface_GetAlphaMultiplier();

                if self.Animation.FadeIn.Active then
                    local fadeIn = (CurTime() - self.Animation.FadeIn.Start) / self.Animation.FadeIn.Duration;

                    if fadeIn < 1 then
                        surface_SetAlphaMultiplier( fadeIn );
                    else
                        self.Animation.FadeIn.Active = false;
                        surface_SetAlphaMultiplier( surfaceAlphaMult );
                    end
                end

                if self.Animation.FadeOut.Active then
                    local fadeOut = (CurTime() - self.Animation.FadeOut.Start) / self.Animation.FadeOut.Duration;
                    
                    if fadeOut > 0 then
                        surface_SetAlphaMultiplier( 1 - fadeOut );

                        if fadeOut >= 1 then
                            self.Animation.FadeOut.Active = false;
                            self.Initialized3D2D = false;
                            if self.Finish then self:Finish(); end
                            self.Activator = nil;
                            surface_SetAlphaMultiplier( surfaceAlphaMult );
                        end
                    end
                end

                self:Render3D2D( self.UI.Width, self.UI.Height );

                if self.Animation.FadeIn.Active or self.Animation.FadeOut.Active then
                    surface_SetAlphaMultiplier( surfaceAlphaMult );
                end
            cam_PopModelMatrix();
            cam_IgnoreZ( false );
        cam_End3D2D();
    end );
end


function ENT:Render3D2D( _w, _h )
    if not self.Initialized3D2D then return end

    if self.RenderVisible then
        local tr = util_TraceLine( {
            start          = EyePos(),
            endpos         = self:GetPos() + self:OBBCenter(),
            collisiongroup = COLLISION_GROUP_WORLD,
        } );
        
        if tr.Entity == self then
            if self.Animation.AlphaMod < 1 then
                self.Animation.AlphaMod = math_Approach( self.Animation.AlphaMod, 1, 3 * RealFrameTime() );
            end
        else
            self.RenderVisible = false;
        end
    else
        if self.Animation.AlphaMod > 0 then
            self.Animation.AlphaMod = math_Approach( self.Animation.AlphaMod, 0, 3 * RealFrameTime() );
        else
            return
        end
    end

    local x, y, w, h = 0, 0, _w, _h;

    y = y - h * 0.25;
    h = h + h * 0.25;

    -- Mask:
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
            surface_SetDrawColor( self.UI.Colors.White );

            if not self.Animation.FoundShrink.Active then
                surface_DrawRect( x, y, w, h );
            else
                local s = w - w * self.Animation.FoundShrink.Amount * (self.Animation.FoundShrink.Value or 0);
                surface_DrawRect( x + w * 0.5 - s * 0.5, y, s, h );
            end
        render_SetStencilCompareFunction( STENCIL_EQUAL );
        render_SetStencilFailOperation( STENCIL_KEEP );

    -- AlphaMod:
        local __surface_alpha = surface_GetAlphaMultiplier();
        surface_SetAlphaMultiplier( __surface_alpha * self.Animation.AlphaMod );

    -- Title:
        if self.Activator == LocalPlayer() then
            surface_SetDrawColor( self.UI.Colors.White );
            surface_DrawRect( x, y, w, _h * 0.25 );

            if not self.UI.TextFont then
                surface_CreateFont( "ent.RouletteBox.Font", {
                    font     = "Montserrat",
                    extended = true,
                    size     = h * 0.15,
                    weight   = 1000,
                } );

                self.UI.TextFont = true;
            end

            draw_SimpleText( self.Animation.ItemsFadeOut.Active and translates.Get("ВЫ НАШЛИ") or self:GetPrintName(), "ent.RouletteBox.Font", w * 0.5, -_h * 0.25 * 0.5, self.UI.Colors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end

        x, y, w, h = 0, 0, _w, _h;
    -- Base:
        surface_SetDrawColor( self.UI.Colors.Background );
        draw_NoTexture();
        surface_DrawPoly( self.UI.BottomArrow.Poly );

        w, h = w, h - self.UI.BottomArrow.Height;
        surface_SetDrawColor( self.UI.Colors.Background );
        surface_DrawRect( x, y, w, h );
    
    -- Scroll:
        w, h = w, h * 0.825;
        y = y + h * 0.1;

    -- Items:
        self.Animation.Time = (CurTime() - self.Animation.Start) / self.AnimationDuration;

        if self.Animation.Time < 1  then
            self.Animation.RouletteV = 26 * self.Animation.ScrollFunc( self.Animation.Time );
        else
            if not self.Animation.FadeOut.Active then
                self.Animation.FadeOut.Active = true;
                self.Animation.FadeOut.Start = CurTime() + (self.Animation.FadeOut.Delay or 0);
            end

            if not self.Animation.ItemsFadeOut.Active then
                self.Animation.ItemsFadeOut.Active = true;
                self.Animation.ItemsFadeOut.Start = CurTime();
            else
                self.Animation.ItemsFadeOut.Value = math_max( 1 - (CurTime() - self.Animation.ItemsFadeOut.Start) / self.Animation.ItemsFadeOut.Duration, 0 );
            end

            if not self.Animation.FoundShrink.Active then
                self.Animation.FoundShrink.Active = true;
                self.Animation.FoundShrink.Start = CurTime();
            else
                self.Animation.FoundShrink.Value = math_min( (CurTime() - self.Animation.FoundShrink.Start) / self.Animation.FoundShrink.Duration, 1 );
            end
        end

        for i, item in pairs( self.RouletteItems ) do
            local iw, ih;
            
            item.Hovered = (i == ( self.Animation.RouletteV_R or 0 )) and true or false;

            if item.Hovered then
                iw, ih = h * 0.7, h;
            else
                iw, ih = h * 0.7, h * 0.7;
            end

            if math_Round( self.Animation.RouletteV ) ~= self.Animation.RouletteV_R then
                EmitSound( self.UI.Sounds.Click, self:GetPos(), self:EntIndex(), CHAN_AUTO, 1, 75, 0, 100 );
            end
            self.Animation.RouletteV_R = math_Round( self.Animation.RouletteV );

            self.UI.Matrixes.ElementOffset:SetTranslation( Vector(
                (w * 0.5 - iw * 0.5) + ((iw + iw * 0.05) * i) - ((iw + iw * 0.05) * self.Animation.RouletteV),
                y + h * 0.5 - ih * 0.5,
            0 ) );

            local iconsize = math_Round( item.Hovered and iw * 1 or iw * 0.65 );
            if self.UI.Matrixes.ElementOffset:GetTranslation().x > self.UI.Width then
                continue
            end

            if self.UI.Matrixes.ElementOffset:GetTranslation().x < -iconsize * 1.5 then
                self.RouletteItems[i] = nil;
                continue
            end
            
            if not self.UI.Frames[item.Hovered] then
                self.UI.Frames[item.Hovered] = self.UI.GenerateRoundedRect( 0, 0, iw, ih, iw * 0.15, 8 );
            end

            cam_PushModelMatrix( self.UI.Matrixes.ElementOffset, true );
                if not item.Hovered then
                    if self.Animation.ItemsFadeOut.Active then
                        self.Animation.ItemsFadeOut.SurfaceAlpha = surface_GetAlphaMultiplier();
                        surface_SetAlphaMultiplier( self.Animation.ItemsFadeOut.SurfaceAlpha * (self.Animation.ItemsFadeOut.Value or 1) );
                    end

                    surface_SetDrawColor( self.UI.RarityColors[-1] );
                    surface_SetMaterial( self.UI.Materials.GradientUp );
                    surface_DrawPoly( self.UI.Frames[item.Hovered] );

                    if isfunction( item.icon ) then
                        item.icon( item, iw, ih, iconsize, iconsize, i );
                    else
                        local ActivatorIsLP = self.Activator == LocalPlayer();
                        surface_SetDrawColor( self.UI.Colors.TransparentWhite );
                        surface_SetMaterial( item.icon or self.UI.Materials.Error );
                        surface_DrawTexturedRect(
                            iw * 0.5 - iconsize * 0.5,
                            ih * 0.5 - iconsize * 0.5 +
                                (ActivatorIsLP and math.sin( (CurTime() + i * 50) * 5 ) * (iw * 0.125) or 0),
                            iconsize, iconsize
                        );
                    end

                    if self.Animation.ItemsFadeOut.Active then
                        surface_SetAlphaMultiplier( self.Animation.ItemsFadeOut.SurfaceAlpha );
                    end
                else
                    surface_SetDrawColor( self.UI.RarityColors[item.rarity] and self.UI.RarityColors[item.rarity] or self.UI.RarityColors[0] );
                    surface_SetMaterial( self.UI.Materials.GradientUp );
                    surface_DrawPoly( self.UI.Frames[item.Hovered] );

                    if isfunction( item.icon ) then
                        item.icon( item, iw, ih, iconsize, iconsize, i );
                    else
                        local ActivatorIsLP = self.Activator == LocalPlayer();
                        surface_SetDrawColor( self.UI.Colors.White );
                        surface_SetMaterial( item.icon or self.UI.Materials.Error );
                        surface_DrawTexturedRect(
                            iw * 0.5 - iconsize * 0.5,
                            ih * 0.5 - iconsize * 0.5 +
                                (ActivatorIsLP and math.sin( (CurTime() + i * 50) * 5 ) * (iw * 0.125) or 0),
                            iconsize, iconsize
                        );
                    end
                end
            cam_PopModelMatrix();
        end

        
        -- Selector Arrow:
            draw_NoTexture();
            surface_SetDrawColor( self.UI.Colors.White );
            surface_DrawPoly( self.UI.SelectorArrow.OuterPoly );
            
            surface_SetDrawColor( self.UI.Colors.Black );
            surface_DrawPoly( self.UI.SelectorArrow.InnerPoly );
        
        -- Gradient:
            w, h = _w, _h - self.UI.BottomArrow.Height;
            surface_SetDrawColor( self.UI.Colors.SideGradient );
            surface_SetMaterial( self.UI.Materials.GradeintLeft );
            surface_DrawTexturedRect( 0, 0, h, h );

            surface_SetDrawColor( self.UI.Colors.SideGradient );
            surface_SetMaterial( self.UI.Materials.GradeintRight );
            surface_DrawTexturedRect( w-h, 0, h, h );

        -- AlphaMod:
            surface_SetAlphaMultiplier( __surface_alpha );

        -- Mask:
            render_SetStencilEnable( false );
end


function ENT:Draw()
    self.RenderVisible = true;
    self:DrawModel();
end