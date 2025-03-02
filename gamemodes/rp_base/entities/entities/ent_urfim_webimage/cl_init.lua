-- "gamemodes\\rp_base\\entities\\entities\\ent_urfim_webimage\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );


local BaseClass = baseclass.Get( "base_anim" );

ENT.MaxRenderDistance = 1024 * 1024;
ENT.LoadingMat = Material( "rpui/misc/download.png", "smooth noclamp" );


function ENT:Draw() end
function ENT:DrawTranslucent() end


local __cvar        = cvar.Get( "enable_webimage_render" );
local __renderqueue = {};
hook.Add( "PostDrawTranslucentRenderables", "urf.WebImages::Render", function( bIsDepth, bIsSkybox )
	if not __cvar or not __cvar.Value then return end
    if bIsSkybox then return end

    table.sort( __renderqueue, function( a, b )
        if not IsValid(a) then return false end
        if not IsValid(b) then return false end

        local eye = EyePos();
        return a:GetPos():DistToSqr( eye ) > b:GetPos():DistToSqr( eye );
    end );

    for k, self in pairs( __renderqueue ) do
        if not IsValid( self ) then
            __renderqueue[k] = nil;
            continue
        end

        self.RenderingBack = self.NoCull and ( EyePos() - self:GetPos() ):Dot( self:GetAngles():Up() ) < 0;

        self.Origin3D2D, self.Angles3D2D = self:GetPos(), self:GetAngles();
    
        if self.RenderingBack and self.Mirrorback then
            self.Angles3D2D:RotateAroundAxis( self:GetRight(), 180 );
        end
    
        cam.Start3D2D( self.Origin3D2D, self.Angles3D2D, self.Scaling3D2D );
            if self.RenderingBack and (not self.Mirrorback) then
                render.CullMode( MATERIAL_CULLMODE_CW );
                self.ResetCullMode = true;
            end
    
            self:DrawImage();
    
            if self.ResetCullMode then
                render.CullMode( MATERIAL_CULLMODE_CCW );
                self.ResetCullMode = false;
            end
        cam.End3D2D();
    end
end );


function ENT:Initialize()
    self:InitializeImage();
end


function ENT:InitializeImage()
    self.Scaling3D2D = 1 / self.PixelsPerUnit;

    self.IsAlphatest = self:HasRenderFlag( WEBIMAGE_RENDERFLAG_ALPHATEST );
    self.IsAdditive  = self:HasRenderFlag( WEBIMAGE_RENDERFLAG_ADDITIVE );
    self.NoCull      = self:HasRenderFlag( WEBIMAGE_RENDERFLAG_NOCULL ) or self:HasRenderFlag( WEBIMAGE_RENDERFLAG_MIRRORBACK );
    self.Mirrorback  = self:HasRenderFlag( WEBIMAGE_RENDERFLAG_MIRRORBACK );

    self.ScaleW, self.ScaleH = self:GetScaleWidth() or 1, self:GetScaleHeight() or 1;

    self.WebMaterial = rp.WebMat:Get( self:GetURL(), true );
    self.ImageMaterial = CreateMaterial( "urf_webimage" .. self:EntIndex(), "UnlitGeneric" );

    self.Loaded = false;

    if not self.RenderQueued then
        table.insert( __renderqueue, self );
        self.RenderQueued = true;
    end
end


function ENT:DrawImage()
    if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) > self.MaxRenderDistance then return end
    
    if not self.WebMaterial then
        self.WebMaterial = rp.WebMat:Get( self:GetURL(), true );

        surface.SetDrawColor( Color(255, 255, 255, 191 + math.sin(CurTime()) * 64 ) );
        surface.SetMaterial( self.LoadingMat );
        surface.DrawTexturedRect( -256, -256, 512, 512 );
    else
        if not self.Loaded then
            self.w, self.h = self.WebMaterial:Width(), self.WebMaterial:Height();
            
            local img_aspect_w, img_aspect_h = self.h / self.w, self.w / self.h;
            local img_scaling = (img_aspect_w > img_aspect_h) and (512 / self.h) or (512 / self.w);

            self.w, self.h = self.w * img_scaling * self.ScaleW, self.h * img_scaling * self.ScaleH;

            self.ImageMaterial:SetTexture( "$basetexture", self.WebMaterial:GetTexture( "$basetexture" ) );
            self.ImageMaterial:SetInt( "$flags", bit.bor(
                16,
                32,
                self.IsAdditive and 128 or 0,
                self.IsAlphatest and 256 or 0,
                2097152
            ) );

            self.Loaded = true;
        end

        surface.SetMaterial( self.ImageMaterial );
        surface.SetDrawColor( self:GetColor() );
        surface.DrawTexturedRect( -self.w * 0.5, -self.h * 0.5, self.w, self.h );
    end
end
