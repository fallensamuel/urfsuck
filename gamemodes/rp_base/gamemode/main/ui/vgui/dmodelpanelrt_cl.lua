-- "gamemodes\\rp_base\\gamemode\\main\\ui\\vgui\\dmodelpanelrt_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};


function PANEL:Init()
    self.BaseClass.Init( self );
end


function PANEL:PerformLayout( w, h )
    self:InitCanvas( w, h );
end


function PANEL:DrawModel( bDrawingDepthAlpha, bDrawingAlpha )
	if self:PreDrawModel( self.Entity, bDrawingDepthAlpha, bDrawingAlpha ) ~= false then
		self.Entity:DrawModel();
		self:PostDrawModel( self.Entity, bDrawingDepthAlpha, bDrawingAlpha );
	end
end


function PANEL:InitCanvas( w, h )
    local s = math.min( ScrW(), ScrH() );

    if w < h then
        self.rt_aspect = w / h;
        self.rt_w, self.rt_h = self.rt_aspect * s, s;        
    else
        self.rt_aspect = h / w;
        self.rt_w, self.rt_h = s, self.rt_aspect * s;
    end

    if self.RenderTarget then
        if ( self.RenderTarget:Width() == self.rt_w ) and ( self.RenderTarget:Height() == self.rt_h ) then
            return
        end
    end

    local TEX_UID = "DModelPanelRT_" .. math.floor( math.random() * 2147483647 );

    self.RenderTarget = GetRenderTargetEx( TEX_UID, self.rt_w, self.rt_h,
        RT_SIZE_DEFAULT, MATERIAL_RT_DEPTH_SHARED, bit.bor( 16, 512, 32768 ), 0, IMAGE_FORMAT_DEFAULT
    );

    self.RenderMaterial = CreateMaterial( TEX_UID, "UnlitGeneric", {
        ["$basetexture"] = self.RenderTarget:GetName();
        ["$translucent"] = 1;
    } );
end


function PANEL:PaintCanvas( w, h )
    if not IsValid( self.Entity ) then return end

	self:LayoutEntity( self.Entity );

	local pos, ang = self.vCamPos, self.aLookAngle;
	if not ang then
		ang = ( self.vLookatPos - self.vCamPos ):Angle();
	end

	cam.Start3D( pos, ang, self.fFOV, 0, 0, self.rt_w, self.rt_h, 5, self.FarZ );

	render.SuppressEngineLighting( true );
	render.SetLightingOrigin( self.Entity:GetPos() );
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 );
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 );
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) );

	for i = 0, 6 do
		local col = self.DirectionalLight[i];
		if col then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 );
		end
	end

    render.SetWriteDepthToDestAlpha( true );
        self:DrawModel( true, false );
    render.SetWriteDepthToDestAlpha( false );

    render.OverrideAlphaWriteEnable( true, true );
        self:DrawModel( false, true );
    render.OverrideAlphaWriteEnable( false );

    self:DrawModel( false, false );

	render.SuppressEngineLighting( false );

	cam.End3D();

	self.LastPaint = RealTime();
end


function PANEL:Paint( w, h )
    if ( not self.RenderTarget ) or ( not self.RenderMaterial ) then return end

    render.PushRenderTarget( self.RenderTarget );

    render.Clear( 0, 0, 0, 0 );
    render.ClearDepth();

    self:PaintCanvas( w, h );

    render.PopRenderTarget();

    surface.SetDrawColor( color_white );
	surface.SetMaterial( self.RenderMaterial );
	surface.DrawTexturedRect( 0, 0, w, h );
end


derma.DefineControl( "DModelPanelRT", "A panel containing a model (by using RenderTarget)", PANEL, "DModelPanel" );